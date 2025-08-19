<?php
echo "<h1>PHP Test</h1>";
echo "<p>PHP is working! Current time: " . date('Y-m-d H:i:s') . "</p>";
echo "<p>PHP version: " . phpversion() . "</p>";

// Test PDF directory
$booksDir = 'books/';
if (is_dir($booksDir)) {
    echo "<p>✅ Books directory found</p>";
    $pdfFiles = glob($booksDir . '*.pdf');
    echo "<p>Found " . count($pdfFiles) . " PDF files:</p>";
    echo "<ul>";
    foreach ($pdfFiles as $pdfFile) {
        echo "<li>" . basename($pdfFile) . "</li>";
    }
    echo "</ul>";
} else {
    echo "<p>❌ Books directory not found</p>";
}
?>
