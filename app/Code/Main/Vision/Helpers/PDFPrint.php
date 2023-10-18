<?php
namespace Code\Main\Vision\Helpers;
use Argus;
use Log;
use Environment;
/**
 *
 * Consultation Printing Helper
 *
 * see description
 *
 * PHP version 7.2+
 *
 * @category   Utility
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    1.0.0
 * @link       https://humbleprogramming.com/docs/class-Print.html
 * @since      File available since Release 1.0.0
 */
class PDFPrint extends Helper
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