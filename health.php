<?php
// Health check endpoint for Railway
header('Content-Type: application/json');

$status = [
    'status' => 'healthy',
    'timestamp' => date('c'),
    'php_version' => PHP_VERSION,
    'books_count' => 0,
    'books_directory' => is_dir('books') ? 'exists' : 'missing'
];

// Count PDF files
if (is_dir('books')) {
    $files = scandir('books');
    $pdfs = array_filter($files, function($f) {
        return is_file("books/$f") && strtolower(pathinfo($f, PATHINFO_EXTENSION)) === 'pdf';
    });
    $status['books_count'] = count($pdfs);
}

echo json_encode($status, JSON_PRETTY_PRINT);
?>
