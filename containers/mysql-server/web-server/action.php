<?php
$login = $_POST['login'];
$passwd = $_POST['passwd'];
$mysqli = mysqli_connect("localhost", "root", "toor", "my_database");
$query = sprintf("SELECT name FROM Users WHERE name='%s' AND passwd='%s'",$login,$passwd);
if ($mysqli->multi_query($query)) {
    do {
        if ($result = $mysqli->store_result()) {
            while ($row = $result->fetch_row()) {
                if ($row['name']) {
			echo "Bienvenue ", $row['name'];
		} else {
			echo "Echec de la connexion";		
		}
            }
            $result->free();
        }
    } while ($mysqli->next_result());
}
$mysqli->close();
?>
