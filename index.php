<?php // file: index.php
// Auto-list PDFs from /books and open reader.html?book=<file>
$files = is_dir('books') ? scandir('books') : [];
$books = array_values(array_filter($files, fn($f) =>
  is_file("books/$f") && strtolower(pathinfo($f, PATHINFO_EXTENSION)) === 'pdf'
));
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>My Library</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <header class="topbar">📚 My Library</header>
  <main class="library">
    <?php if (empty($books)): ?>
      <div class="empty">Put your PDFs inside the <code>/books</code> folder.</div>
    <?php else: ?>
      <?php foreach ($books as $b): ?>
        <a class="book" href="<?= 'reader.html?book=' . urlencode($b) ?>">
          <div class="cover">📖</div>
          <div class="title"><?= htmlspecialchars(pathinfo($b, PATHINFO_FILENAME)) ?></div>
          <div class="meta"><?= number_format(filesize("books/$b")/1024, 0) ?> KB</div>
        </a>
      <?php endforeach; ?>
    <?php endif; ?>
  </main>
</body>
</html>
