<?php
// Simple health check endpoint for Railway
header('Content-Type: text/plain');
http_response_code(200);
echo "OK";
?>
