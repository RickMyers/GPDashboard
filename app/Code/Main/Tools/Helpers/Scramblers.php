<?php
namespace Code\Main\Tools\Helpers;
use Argus;
use Log;
use Environment;
/**
 * 
 * Scramblers
 *
 * adsfasdf
 *
 * PHP version 7.0+
 *
 * @category   Utility
 * @package    Framework
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2005-present Argus Dashboard
 * @license    https://jarvis.enicity.com/license.txt
 * @version    1.0.0
 * @link       https://jarvis.enicity.com/docs/class-Scramblers.html
 * @since      File available since Release 1.0.0
 */
class Scramblers extends Helper
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

}