<?php

require "Argus.php";

$entity = 'vision/consultation_forms';                                          //Table to operate on
$field  = 'images_unreadable';                                                    //Field to elevate

$entity = Argus::getEntity($entity);                        
$rows   = $entity->fetch();
foreach ($rows as $row) {
    if (isset($row[$field]) && $row[$field]) {
        print('Elevating '.$row['id']."\n");
        $entity->reset()->setId($row['id'])->load();
        $entity->save();
    }
}
echo('done');



