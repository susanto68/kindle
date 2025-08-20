<?php
// Simple health check endpoint for InfinityFree
header('Content-Type: text/plain');
http_response_code(200);
echo "OK - InfinityFree Hosted";
?>
