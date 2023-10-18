<?php
/**
 * When we go live, make sure this checks to see if the current user has super_user authority
 *
 * Let's you switch your login to someone else's ID
 */
require "Humble.php";

session_start();
$super_user = false;

if (isset($_SESSION['login']) && $_SESSION['login']) {
    $user = \Humble::getEntity('humble/user/permissions')->setId($_SESSION['login']);
    $user->load();
    $super_user = ($user->getAdmin() === 'Y');
}
//COMMENT OUT NEXT LINE WHEN WE GO LIVE!!!
//$super_user = true;
if ($super_user) {
    $_SESSION['uid'] = isset($_GET['uid']) ? $_GET['uid'] : 1;
    header('Location: /dashboard/home/page');
} else {
    header('Location: /index.html?message=Having an identity crisis?');
}

?>