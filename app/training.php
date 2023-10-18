<?php

if (!isset($_GET['video'])) {
    die();
}

$video    = $_GET['video'];

if ($video && (file_exists($video_file  = '../../training/training/'.$video.'.mp4'))) {
    header('Content-Type: video/mp4');
    print(file_get_contents($video_file));
};

?>

