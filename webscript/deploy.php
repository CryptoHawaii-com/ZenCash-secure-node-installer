<?php 
$fqdn = $_POST["fqdn"];
$taddr = $_POST["taddr"];
$string = "\n" . $fqdn . "\n" . $taddr;
$file = '/var/www/secnodeinfo.txt';
file_put_contents($file, $string, FILE_APPEND);
echo "completed";
?>

