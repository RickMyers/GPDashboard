<?php
namespace Code\Main\Dental\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Dental Portal functionality
 *
 * A collection of methods important to our Dental portal
 *
 * PHP version 7.2+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Portal.html
 * @since      File available since Release 1.0.0
 */
class Portal extends Model
{

    use \Code\Base\Humble\Event\Handler;

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
     * This returns true if there's a page in the database with that 
     * 
     * @return boolean
     */
    public function routing() {
        return (Argus::getEntity('dental/portal')->setPage(Argus::_action())->load(true) !== null);
    }

    /**
     * 
     * 
     * @return boolean
     */    
    public function pinCheck() {
        return (Argus::getEntity('dental/portal')->setPage(Argus::_action())->setPin($this->getPin())->load(true) !== null);
    }
}