<?php

if (!isset($_GET['method']) || !isset($_GET['form_id']) || !isset($_GET['scan_id'])) {
    die();
}
$method     = $_GET['method'];
$form_id    = $_GET['form_id'];
$scan_id    = $_GET['scan_id'];
if ($method && $form_id && $scan_id) {
    switch ($method) {
        case "tn"   :
            if (file_exists($image  = '../../Scans/forms/'.$form_id.'/tn/'.$scan_id.'.jpg')) {
                header('Content-Type: image/jpeg');
                print(file_get_contents($image));
            };
            break;
        case "img"  :
            if (file_exists($image  = '../../Scans/forms/'.$form_id.'/'.$scan_id.'.jpg')) {
                header('Content-Type: image/jpeg');
                print(file_get_contents($image));
            };            
            break;
        default     :
            break;
    }
}
?>
