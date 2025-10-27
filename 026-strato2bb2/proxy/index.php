<?php
// Mål: din GCS-bucket
$origin = 'https://storage.googleapis.com/bildbank2';

// Bygg mål-URL med path + query. Tvinga "/" -> "/index.html"
$reqUri = $_SERVER['REQUEST_URI'];              // t.ex. "/?query=Christer" eller "/json/bilder.json"
$parts  = parse_url($reqUri);
$path   = isset($parts['path']) ? $parts['path'] : '/';
$query  = isset($parts['query']) ? ('?' . $parts['query']) : '';

if ($path === '/' || $path === '') {
  $path = '/index.html';
}

$target = $origin . $path . $query;

// cURL-förfrågan
$ch = curl_init($target);
curl_setopt_array($ch, [
  CURLOPT_RETURNTRANSFER => true,
  CURLOPT_HEADER         => true,   // hämta headers + body
  CURLOPT_FOLLOWLOCATION => true,
  CURLOPT_CONNECTTIMEOUT => 10,
  CURLOPT_TIMEOUT        => 30,
  CURLOPT_USERAGENT      => $_SERVER['HTTP_USER_AGENT'] ?? 'StratoPHPProxy/1.0',
  CURLOPT_HTTPHEADER     => [
    'Accept: ' . ($_SERVER['HTTP_ACCEPT'] ?? '*/*'),
    'Accept-Language: ' . ($_SERVER['HTTP_ACCEPT_LANGUAGE'] ?? 'sv-SE,sv;q=0.9'),
  ],
]);

$response = curl_exec($ch);
if ($response === false) {
  http_response_code(502);
  header('Content-Type: text/plain; charset=utf-8');
  echo "Proxy error: " . curl_error($ch);
  curl_close($ch);
  exit;
}

$statusCode = curl_getinfo($ch, CURLINFO_RESPONSE_CODE);
$headerSize = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
$headersRaw = substr($response, 0, $headerSize);
$body       = substr($response, $headerSize);
curl_close($ch);

// Skicka vidare statuskod
http_response_code($statusCode);

// Välj ut harmlösa/nyttiga headers att vidarebefordra
$passHeaders = [
  'content-type',
  'cache-control',
  'etag',
  'last-modified',
  'expires',
  'accept-ranges',
  'content-encoding',
];

// Skriv ut headers
foreach (explode("\r\n", $headersRaw) as $hline) {
  if (stripos($hline, ':') === false) continue;
  [$name, $value] = explode(':', $hline, 2);
  $lname = strtolower(trim($name));
  if (in_array($lname, $passHeaders, true)) {
    header($name . ':' . $value, true);
  }
}

// (Valfritt) Stäng av framing-skydd om du *vill* kunna iframa din domän senare
// header_remove('X-Frame-Options');

// Skicka kropp
echo $body;
