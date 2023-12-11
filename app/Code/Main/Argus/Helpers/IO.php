<?php
namespace Code\Main\Argus\Helpers;
use Argus;
use Log;
use Environment;
/**
 *
 * File and Directory functions
 *
 * Various handy methods for working with the filesystem
 *
 * PHP version 7.0+
 *
 * @category   Utility
 * @package    Dashboard
 * @author     Rick Myers rmyers@aflacbenefitssolutions.com
 */
class IO extends Helper
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Required for Helpers, Models, and Events, but not Entities
     *
     * @return system
     */
    public function getClassName() {
        return __CLASS__;
    }

    /**
     * Gets a hash table of the files in a directory, optionally only those with a particular file extension
     * 
     * @param string $dir
     * @param string $file_extension
     * @return array
     */
    public function filesInDirectory($dir=false,$file_extension=false) {
        $files = [];
        if ($dir = ($dir) ? $dir : ( ($this->getDirectory()) ? $this->getDirectory() : false )) {
            $extension = ($file_extension) ? $file_extension : (($this->getFileExtension()) ? $this->getFileExtension() : false);
            if ($dh = dir($dir)) {
                while ($entry = $dh->read()) {
                    if (($entry == '.') || ($entry == '..')) {
                        continue;
                    }
                    if ($extension) {
                        if (strpos($entry,$extension)) {
                            $files[$entry] = stat($dir.'/'.$entry);
                        }
                    } else {
                        $files[$entry] = stat($dir.'/'.$entry);
                    }
                }
            }
        }
        return $files;
    }

    
    public function compress($filename=false,$directory=false) {
        
    }
    
    public function uncompress($file=false,$destination=false) {
        
    }
}