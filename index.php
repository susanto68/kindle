<?php // file: index.php
// Auto-list books from /books and open flipbook for each book
// InfinityFree compatible version with new folder structure

// Set error reporting for development (remove in production)
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Get the current directory path
$current_dir = __DIR__;
$books_dir = $current_dir . '/books';

// Check if books directory exists and is readable
if (!is_dir($books_dir) || !is_readable($books_dir)) {
    // Try alternative paths for InfinityFree
    $books_dir = $current_dir . '/htdocs/books';
    if (!is_dir($books_dir)) {
        $books_dir = $current_dir . '/public_html/books';
    }
}

// Function to get book information
function getBookInfo($book_path) {
    $pages = [];
    $total_size = 0;
    
    if (is_dir($book_path)) {
        $files = scandir($book_path);
        foreach ($files as $file) {
            if ($file !== '.' && $file !== '..') {
                $file_path = $book_path . '/' . $file;
                if (is_file($file_path)) {
                    $ext = strtolower(pathinfo($file, PATHINFO_EXTENSION));
                    if (in_array($ext, ['jpg', 'jpeg', 'png', 'gif'])) {
                        $pages[] = $file;
                        $total_size += filesize($file_path);
                    }
                }
            }
        }
    }
    
    return [
        'pages' => $pages,
        'total_size' => $total_size,
        'page_count' => count($pages)
    ];
}

// Get all book folders
$books = [];
if (is_dir($books_dir)) {
    $items = scandir($books_dir);
    foreach ($items as $item) {
        if ($item !== '.' && $item !== '..' && is_dir($books_dir . '/' . $item)) {
            $book_info = getBookInfo($books_dir . '/' . $item);
            if ($book_info['page_count'] > 0) {
                $books[] = [
                    'name' => $item,
                    'info' => $book_info
                ];
            }
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>My Flipbook Library - InfinityFree</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <link rel="stylesheet" href="css/style.css">
</head>
<body>
  <header class="topbar">📚 My Flipbook Library (InfinityFree Hosted)</header>
  <main class="library">
    <?php if (empty($books)): ?>
      <div class="empty">
        <p>Create book folders inside the <code>/books</code> directory.</p>
        <p><strong>InfinityFree Setup:</strong></p>
        <ul>
          <li>Create a folder for each book in <code>books/</code></li>
          <li>Upload page images (JPG, PNG, GIF) to each book folder</li>
          <li>Name images as: page1.jpg, page2.jpg, etc.</li>
          <li>Ensure folder permissions are set to 755</li>
          <li>Image files should have 644 permissions</li>
        </ul>
        <p><strong>Example Structure:</strong></p>
        <pre>
books/
├── book1/
│   ├── page1.jpg
│   ├── page2.jpg
│   └── page3.jpg
└── book2/
    ├── page1.jpg
    └── page2.jpg
        </pre>
      </div>
    <?php else: ?>
      <?php foreach ($books as $book): ?>
        <a class="book" href="<?= 'flipbook/index.html?book=' . urlencode($book['name']) ?>">
          <div class="cover">📖</div>
          <div class="title"><?= htmlspecialchars($book['name']) ?></div>
          <div class="meta">
            <?= $book['info']['page_count'] ?> pages | 
            <?= number_format($book['info']['total_size']/1024, 0) ?> KB
          </div>
        </a>
      <?php endforeach; ?>
    <?php endif; ?>
  </main>
  
  <footer class="footer">
    <p>Hosted on InfinityFree | PHP <?= PHP_VERSION ?> | 
    <a href="health.php">Health Check</a></p>
  </footer>
</body>
</html>
