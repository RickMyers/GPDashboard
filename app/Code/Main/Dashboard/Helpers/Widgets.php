<?php
namespace Code\Main\Dashboard\Helpers;
use Argus;
use Log;
use Environment;
/**
 * 
 * Dashboard related stuff
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Utility
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    1.0.0
 * @link       https://humbleprogramming.com/docs/class-Widgets.html
 * @since      File available since Release 1.0.0
 */
class Widgets extends Helper
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
     * Wrapper for the 
     * 
     * @return array
     */
    public function analyzeUploadedFile() {
        $file_data = $this->getClaimsFile();
        $results   = [];
        if (isset($file_data['path'])) {
            $results = Argus::getModel('argus/claims')->summarizeFile($file_data['path']);
        }
        return $results;
    }
}