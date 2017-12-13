<?php 
$fqdn = $_POST["fqdn"];
$taddr = $_POST["taddr"];
$string = $fqdn . "\n" . $taddr;
$file = '/var/www/secnodeinfo.txt';
file_put_contents($file, $string, FILE_APPEND);
echo "completed";
?>

