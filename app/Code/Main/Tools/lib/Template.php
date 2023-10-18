<?php
namespace Code\Main\Tools\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * The template to base other tools on
 *
 * Copy this file into your appropriately named file and make all necessary changes
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Client
 * @since      File available since Release 1.0.0
 */
class [ClassName] extends Model implements ArgusTool
{

    use \Code\Base\Humble\Event\Handler;

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Close up shop, if necessary
     */
    public function __destruct() {
        parent::__destruct();
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
     * Perform initializing and pre processing here
     */
    public function setup() {

        return true;
    }
    
    /**
     * This is where you do most of the heavy lifting
     */
    public function run() {

        return true;
    }
    
    /**
     * Cleanup and finalization here
     */
    public function finalize() {

        return true;
    }
    
}
