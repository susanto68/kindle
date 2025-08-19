// file: reader.js
// Smooth Kindle-like page view + word-by-word TTS highlight with tap-to-start

// ===== URL & DOM =====
const params = new URLSearchParams(location.search);
const bookFile = params.get('book'); // required
const bookNameEl = document.getElementById('bookName');
const canvas = document.getElementById('pdf-canvas');
const ctx = canvas.getContext('2d', { alpha: false });
const textLayerDiv = document.getElementById('text-layer');

const prevBtn = document.getElementById('prevPage');
const nextBtn = document.getElementById('nextPage');
const pageInfo = document.getElementById('pageInfo');
const playPauseBtn = document.getElementById('playPause');

if (!bookFile) {
  alert('No book specified. Open from the library.');
  location.href = 'index.php';
}

// ===== PDF STATE =====
let pdfDoc = null;
let pageNum = 1;
let scale = 1.4;            // Adjust for your device; we auto-fit later
let rendering = false;

// ===== TTS STATE =====
let voices = [];
let utterance = null;
let isPlaying = false;
let currentWordIndex = 0;
let words = [];             // array of strings we will speak (joined with spaces)
let wordCharStarts = [];    // cumulative char starts to map boundary charIndex -> word index
let wordSpans = [];         // array of span elements, one per word (for highlight)

// ===== INIT =====
document.addEventListener('DOMContentLoaded', async () => {
  bookNameEl.textContent = decodeURIComponent(bookFile || '');
  // Preload voices (some browsers need this)
  voices = speechSynthesis.getVoices();
  speechSynthesis.onvoiceschanged = () => { voices = speechSynthesis.getVoices(); };

  // Load PDF
  const url = 'books/' + bookFile;
  try {
    const loading = pdfjsLib.getDocument(url);
    pdfDoc = await loading.promise;
    pageNum = 1;
    await renderPage(pageNum);
    updateNav();
  } catch (e) {
    console.error(e);
    alert('Failed to load PDF.');
    history.back();
  }
});

// ===== RENDER PAGE =====
async function renderPage(num) {
  if (!pdfDoc) return;
  rendering = true;
  // Cancel any ongoing speech when changing page
  stopSpeech(false);
  currentWordIndex = 0;

  const page = await pdfDoc.getPage(num);

  // Fit-to-width scaling
  const viewport0 = page.getViewport({ scale: 1 });
  const maxWidth = Math.min(window.innerWidth - 16, 1200);
  const s = (maxWidth) / viewport0.width;
  scale = Math.max(1, s); // keep >=1 for better text mapping

  const viewport = page.getViewport({ scale });
  canvas.width = Math.floor(viewport.width);
  canvas.height = Math.floor(viewport.height);

  // Center canvas in viewer
  const viewerRect = document.getElementById('viewer').getBoundingClientRect();
  const left = (viewerRect.width - canvas.width) / 2;
  const top  = (viewerRect.height - canvas.height) / 2;
  canvas.style.marginLeft = left > 0 ? left + 'px' : '0';
  canvas.style.marginTop  = top  > 0 ? top  + 'px' : '0';

  // Render page bitmap
  await page.render({ canvasContext: ctx, viewport }).promise;

  // Size/position text layer to canvas
  const canvasRect = canvas.getBoundingClientRect();
  textLayerDiv.style.position = 'absolute';
  textLayerDiv.style.left = canvas.style.marginLeft || '0';
  textLayerDiv.style.top  = canvas.style.marginTop  || '0';
  textLayerDiv.style.width = canvas.width + 'px';
  textLayerDiv.style.height= canvas.height + 'px';

  // Render PDF.js text layer
  textLayerDiv.innerHTML = '';
  const textContent = await page.getTextContent();
  const tlTask = pdfjsLib.renderTextLayer({
    textContentSource: textContent,
    container: textLayerDiv,
    viewport,
    textDivs: []
  });
  await tlTask.promise;

  // Convert text layer into per-word spans and build mapping
  buildWordLayerAndMap(textLayerDiv);

  rendering = false;
}

// Convert PDF.js textDivs into word-level spans and build arrays for TTS sync
function buildWordLayerAndMap(container) {
  words = [];
  wordSpans = [];
  wordCharStarts = [];

  // Walk through each text div produced by PDF.js
  const textDivs = Array.from(container.querySelectorAll('span'));
  // For each div, split into words and spaces, wrap words in <span class="w">
  textDivs.forEach(div => {
    const txt = div.textContent || '';
    if (!txt) return;

    const frag = document.createDocumentFragment();
    // Split with capture to keep spaces/punctuation as separate tokens
    const tokens = txt.split(/(\s+)/);

    tokens.forEach(tok => {
      if (!tok) return;
      if (/\s+/.test(tok)) {
        // keep spaces as raw text so layout stays identical
        frag.appendChild(document.createTextNode(tok));
      } else {
        const w = document.createElement('span');
        w.className = 'w';
        w.textContent = tok;
        // tap a word to jump
        w.addEventListener('click', () => {
          const idx = wordSpans.indexOf(w);
          if (idx >= 0) {
            currentWordIndex = idx;
            startSpeech();
          }
        });
        frag.appendChild(w);

        // TTS sequence arrays
        wordCharStarts.push(words.join(' ').length + (words.length ? 1 : 0));
        words.push(tok);
        wordSpans.push(w);
      }
    });

    // Replace original text with our word-level DOM
    div.replaceChildren(frag);
  });
}

// ===== NAVIGATION =====
prevBtn.addEventListener('click', async () => {
  if (!pdfDoc || pageNum <= 1 || rendering) return;
  pageNum--;
  await renderPage(pageNum);
  updateNav();
});
nextBtn.addEventListener('click', async () => {
  if (!pdfDoc || pageNum >= pdfDoc.numPages || rendering) return;
  pageNum++;
  await renderPage(pageNum);
  updateNav();
});
function updateNav() {
  pageInfo.textContent = `${pageNum} / ${pdfDoc?.numPages ?? 1}`;
  prevBtn.disabled = pageNum <= 1;
  nextBtn.disabled = pageNum >= (pdfDoc?.numPages ?? 1);
}

// Optional: simple swipe (left/right) to change page
let touchStartX = null;
canvas.addEventListener('touchstart', e => { touchStartX = e.changedTouches[0].clientX; }, {passive:true});
canvas.addEventListener('touchend', async e => {
  if (touchStartX == null) return;
  const dx = e.changedTouches[0].clientX - touchStartX;
  if (Math.abs(dx) > 50) {
    if (dx < 0 && pageNum < pdfDoc.numPages) { // swipe left -> next
      pageNum++; await renderPage(pageNum); updateNav();
    } else if (dx > 0 && pageNum > 1) {        // swipe right -> prev
      pageNum--; await renderPage(pageNum); updateNav();
    }
  }
  touchStartX = null;
}, {passive:true});

// ===== TTS: PLAY/PAUSE & HIGHLIGHT =====
playPauseBtn.addEventListener('click', () => {
  if (!isPlaying) {
    startSpeech();
  } else {
    // toggle pause/resume
    if (speechSynthesis.paused) {
      speechSynthesis.resume();
      playPauseBtn.textContent = '⏸︎ Pause';
    } else {
      speechSynthesis.pause();
      playPauseBtn.textContent = '▶ Resume';
    }
  }
});

function startSpeech() {
  if (!words.length) return;
  stopSpeech(false);
  // Process words to improve pronunciation and add line breaks
  let processedWords = [];
  let i = currentWordIndex;
  
  while (i < words.length) {
    let word = words[i];
    
    // Convert "ans" to "answer" for better pronunciation
    if (word.toLowerCase() === 'ans') {
      processedWords.push('answer');
      i++;
    }
    // Handle "Class - 10" pattern - combine into "Class 10"
    else if (word.toLowerCase() === 'class' && i + 2 < words.length && words[i + 1] === '-' && /^\d+$/.test(words[i + 2])) {
      processedWords.push('Class ' + words[i + 2]);
      i += 3; // Skip the next two words (the dash and number)
    }
    // Handle other variations like "Chapter - 1", "Unit - 2", etc.
    else if ((word.toLowerCase() === 'chapter' || word.toLowerCase() === 'unit' || word.toLowerCase() === 'part') && 
             i + 2 < words.length && words[i + 1] === '-' && /^\d+$/.test(words[i + 2])) {
      processedWords.push(word + ' ' + words[i + 2]);
      i += 3; // Skip the next two words (the dash and number)
    }
    // Skip reading "-" characters
    else if (word === '-') {
      i++;
    }
    // Regular word
    else {
      processedWords.push(word);
      i++;
    }
  }
  
  if (processedWords.length === 0) return;
  
  // Debug logging to see what words are being processed
  console.log('Original words:', words.slice(currentWordIndex, currentWordIndex + 10));
  console.log('Processed words:', processedWords);
  
  utterance = new SpeechSynthesisUtterance(processedWords.join(' '));
  // Voice selection: pick a global/neutral English voice if available
  const enVoice = voices.find(v => /^en(-|_)/i.test(v.lang)) || voices[0];
  if (enVoice) utterance.voice = enVoice;
  // Pace for slow learners with line breaks
  utterance.rate = 0.9;          // slightly slower than default
  utterance.pitch = 1.0;
  utterance.lang = enVoice?.lang || 'en-US';

  // Boundary sync: track current word (no highlighting)
  utterance.onboundary = (e) => {
    // Map utterance.charIndex -> absolute word index
    if (typeof e.charIndex !== 'number') return;
    // charIndex is relative to utterance.text (which starts at currentWordIndex)
    const absoluteChar = e.charIndex;
    // Find local word offset with binary search on starts in local text
    const localStarts = [];
    let sum = 0;
    for (let i = currentWordIndex; i < words.length; i++) {
      localStarts.push(sum);
      sum += words[i].length + 1; // + space
      if (sum > absoluteChar + 60) break; // early exit heuristic
    }
    // Find nearest index
    let lidx = 0;
    while (lidx + 1 < localStarts.length && localStarts[lidx + 1] <= absoluteChar) lidx++;
    const absoluteWord = currentWordIndex + lidx;
    // No highlighting - just track position
    if (absoluteWord >= currentWordIndex) currentWordIndex = absoluteWord;
  };

  utterance.onstart = () => {
    isPlaying = true;
    playPauseBtn.textContent = '⏸︎ Pause';
  };
  utterance.onend = () => {
    isPlaying = false;
    playPauseBtn.textContent = '▶ Play';
    // Move to the next word after the last spoken (end-of-utterance)
    currentWordIndex = Math.min(currentWordIndex + 1, words.length - 1);
    
         // Add 1 second pause after each line/utterance
     setTimeout(() => {
       // Continue reading if there are more words
       if (currentWordIndex < words.length - 1) {
         // 1 second pause between lines for better comprehension
         // This gives students time to process what was just read
       }
     }, 1000);
  };
  utterance.onerror = () => {
    isPlaying = false;
    playPauseBtn.textContent = '▶ Play';
  };

  speechSynthesis.speak(utterance);
}

function stopSpeech(clear = true) {
  try { speechSynthesis.cancel(); } catch(e) {}
  isPlaying = false;
  playPauseBtn.textContent = '▶ Play';
  // No highlighting to clear
}

// Highlighting functions removed - no highlighting during reading

// Stop TTS if user navigates away
window.addEventListener('pagehide', () => stopSpeech(true));
window.addEventListener('beforeunload', () => stopSpeech(true));
