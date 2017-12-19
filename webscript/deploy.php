<?php 
$fqdn = $_POST["fqdn"];
$taddr = $_POST["taddr"];
$email = $_POST["email"];
$string = $fqdn . "\n" . $taddr;
$file = '/var/www/secnodeinfo.txt';
$file2 = '/var/www/certbotsetup.txt';
file_put_contents($file, $string, FILE_APPEND);
file_put_contents($file2, $email);
echo "completed";
?>

