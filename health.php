<?php
// Enhanced health check endpoint for Railway
header('Content-Type: application/json');

$status = [
    'status' => 'healthy',
    'timestamp' => date('c'),
    'php_version' => PHP_VERSION,
    'apache_modules' => apache_get_modules(),
    'books_count' => 0,
    'books_directory' => is_dir('books') ? 'exists' : 'missing',
    'memory_usage' => memory_get_usage(true),
    'disk_free_space' => disk_free_space('.'),
    'current_working_directory' => getcwd(),
    'files_in_root' => count(scandir('.'))
];

// Count PDF files
if (is_dir('books')) {
    $files = scandir('books');
    $pdfs = array_filter($files, function($f) {
        return is_file("books/$f") && strtolower(pathinfo($f, PATHINFO_EXTENSION)) === 'pdf';
    });
    $status['books_count'] = count($pdfs);
    $status['pdf_files'] = array_values($pdfs);
}

// Check if Apache is running
$status['apache_running'] = function_exists('apache_get_modules');

// Check if we can read files
$status['can_read_files'] = is_readable('index.php');

echo json_encode($status, JSON_PRETTY_PRINT);
?>
