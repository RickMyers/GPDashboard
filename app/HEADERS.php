<?php
//###########################################################################
//Allows for custom headers to be created and passed to the client
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, GET, PUT, DELETE');
header('Access-Control-Expose-Headers: Errors, Warnings, Notices, Messages, Alerts, Pagination');

header("X-Frame-Options: SAMEORIGIN");

