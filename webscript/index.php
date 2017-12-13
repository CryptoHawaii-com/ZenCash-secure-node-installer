<html>
<body>
<h3>ZenCash Secure Node Configurator</h3>
<p>
<?php
$zaddr = file_get_contents('/var/www/secnodeinfo.txt', true);
echo "Z_ADDR:<br><b>" . $zaddr . "</b>";
?>

<form action="deploy.php" method="post">
Fully Quailified Domain Name: <input type="text" name="fqdn" size="64">
<br>
T_ADDR: <input type="text" name=taddr"" size="64"><br>
<input type="submit">
</form>

</body>
</html>

