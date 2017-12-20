<?php 
$fqdn = $_POST["fqdn"];
$taddr = $_POST["taddr"];
$email = $_POST["email"];
$string = $fqdn . "\n" . $taddr . "\n" . $email;
$file = '/var/www/secnodeinfo.txt';
file_put_contents($file, $string, FILE_APPEND);
echo "completed";
?>

