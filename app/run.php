<?php
/*
        __  ____  _ ___ __               
      / / / / /_(_) (_) /___  __        
     / / / / __/ / / / __/ / / /        
    / /_/ / /_/ / / / /_/ /_/ /         
    \________/_/_/__\__/\__, /          
       / __ \_____(_)  /_____  _____    
      / / / / ___/ / | / / _ \/ ___/    
     / /_/ / /  / /| |/ /  __/ /        
    /_____/_/  /_/ |___/\___/_/         
 
    This program "normalizes" how we                                
    run utilities to try to give some
    order to how they are designed, and
    to keep input/output/error files 
    straightened out.

    Set 'mode=p' on command line to log
    the results of the run.
 */


require "Argus.php";
$me      = array_shift($argv);
$utility = array_shift($argv);
$opts    = [
    'input'  => '',
    'output' => '',
    'errors' => '',
    'mode'   => 'T'
];

while ($argv) {
    $parms = explode('=',array_shift($argv));
    if (isset($opts[$parms[0]]) && ($parms[0] !== 'mode')) {
        $opts[$parms[0]] = 'utils/'.$utility.'/'.$parms[0].'/'.$parms[1];
    } else {
        $opts[$parms[0]] = $parms[1];
    }
}

if (file_exists('utils/'.$utility.'/util.php')) {
    print('Running '.$utility."...\n");
    $cmd = 'php utils/'.$utility.'/util.php '; 
    foreach ($opts as $opt => $val) {
        $cmd .= ' '.$opt.'='.$val;
    }

    $rc = exec($cmd,$results);
    foreach ($results as $result) {
        print($result."\n");
    }
    if (strtoupper($opts['mode'])==='P') {
        print("\n\nLogging Results...\n\n");
        $id = Argus::getEntity('argus/utility/run/log')->setUtility($utility)->setRc($rc)->setRunDate('Y-m-d H:i:s')->setCommand($cmd)->save();
        file_put_contents('utils/RUN_RESULTS/'.$id.'.txt',implode("\n",$results));
    }
} else {
    die('Not a valid utility, check spelling'."\n");
}
