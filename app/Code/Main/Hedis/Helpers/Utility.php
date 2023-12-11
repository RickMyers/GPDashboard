<?php
namespace Code\Main\Hedis\Helpers;
use Argus;
use Log;
use Environment;
/**
 *
 * Image Uploader Utility
 *
 * Just a method to manage the uploaded image
 *
 * PHP version 7.0+
 *
 * @category   Utility
 * @package    Dashboard
 * @author     Rick Myers rmyers@aflacbenefitssolutions.com
 */
class Utility extends Helper
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