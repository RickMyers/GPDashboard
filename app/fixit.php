<?php
ob_start();
chdir('/var/www/dashboard/app');
print(date("m/d/Y H:i:s")."\n\n");
require "Argus.php";

print(shell_exec('php run.php fix_missing_ipa_ids'));

print(shell_exec('php run.php fix_missing_pcp_portals'));

print("\n\nDone!\n");

file_put_contents('last_run.txt',ob_get_flush());
