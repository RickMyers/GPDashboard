<?php
namespace Code\Main\Outreach\Helpers;
use Argus;
use Log;
use Environment;
/**
 *
 * Outreach CSV, a modification of default CSV handling
 *
 * CSV Related methods just for outreach
 *
 * PHP version 7.0+
 *
 * @category   Utility
 * @package    Desktop
 * @author     Rick Myers rmyers@aflacbenefitssolutions.com
 */
class CSV extends \Code\Main\Argus\Helpers\CSV
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
     * This overrides the "official" CSV hash table method... I needed it to work a little bit differently here
     * 
     * @param type $filename
     * @param type $keepCase
     * @param type $separator
     */
    public function toHashTable($filename=false,$keepCase=false,$separator=',') {
        $arr = []; $fields = []; $first  = true;
        if ($filename && file_exists($filename)) {
            if (($handle = fopen($filename, "r")) !== FALSE) {
                while (($data = fgetcsv($handle, 0, $separator)) !== FALSE) {
                    if ($first) {
                        foreach ($data as $key => $val) {
                            $data[$key] = preg_replace("/[^A-Za-z0-9_ ]/", '', $val);  //strip non alphanumeric chars
                        }
                        $fields = $data; $first = false;
                        continue;
                    }
                    $row = [];
                    foreach ($data as $idx => $value) {
                        $row[(isset($fields[$idx]) ? $fields[$idx] : $idx)] = $value;
                    }
                    $arr[] = $row;
                }
                fclose($handle);
            }
        }
        return $arr;        
    }
}