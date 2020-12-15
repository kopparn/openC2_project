<?php
$openc2_cmd = escapeshellarg(file_get_contents('php://input'));
$shell_cmd = "echo $openc2_cmd | /usr/bin/python3 /etc/openc2-proxy/mysql_proxy/main.py";
$output = shell_exec($shell_cmd);
echo $output;
?>
