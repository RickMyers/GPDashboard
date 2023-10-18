<?php

/**
   _____ _       _             __  __                     
  / ____| |     (_)           |  \/  |                    
 | |    | | __ _ _ _ __ ___   | \  / | _____   _____ _ __ 
 | |    | |/ _` | | '_ ` _ \  | |\/| |/ _ \ \ / / _ \ '__|
 | |____| | (_| | | | | | | | | |  | | (_) \ V /  __/ |   
  \_____|_|\__,_|_|_| |_| |_| |_|  |_|\___/ \_/ \___|_|   
                                                          
                                                          
 This program runs periodically to move generated claims files to the proper Aldera intake folder.
  
 Once the file has been successfully moved, it is migrated to the archive folder

 */
Claim_Mover:
    $source     = '/var/www/Claims';
    $archive    = '/var/www/Claims/Archive';
    
    if (chdir('/var/www/dashboard/app')) {
        require "Argus.php";
        if ($cfg = file_get_contents('../../claims_config.json')) {
            $cfg = json_decode($cfg);
            $dir = dir($cfg->source);
            while ($entry = $dir->read()) {
                if (($entry !== '.') && ($entry !== '..')) {
                    if (!is_dir($source.'/'.$entry)) {
                        print('Moving: '.$entry." to $cfg->target/$entry\n");
                        if ($status = copy($cfg->source.'/'.$entry,$cfg->target.'/'.$entry)) {
                            copy($cfg->source.'/'.$entry,$cfg->archive.'/'.$entry);
                            unlink($cfg->source.'/'.$entry);
                        }
                        Argus::getEntity('argus/claims_log')->setFileName($entry)->setSuccess($status?'Y':'N')->setMoved(date('Y-m-d h:i:s'))->save();
                    }
                }
            }
        } else {
            die('Could not find the configuration file for the claims move process'."\n");
        }
    } else {
        die('Could not switch to the app directory'."\n");
    }
exit;