<?php
$login = $_POST['login'];
$passwd = $_POST['passwd'];
$mysqli = mysqli_connect("localhost", "root", "toor", "my_database");
$query = sprintf("SELECT name FROM Users WHERE name='%s' AND passwd='%s'",$login,$passwd);
$res = mysqli_multi_query($mysqli, $query);
$row = mysqli_fetch_assoc($res);
if ($row['name']) {
	echo "Bienvenue ", $row['name'];
} else {
	echo "Echec de la connexion";
}
?>
