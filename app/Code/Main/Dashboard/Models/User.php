<?php
namespace Code\Main\Dashboard\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * General User Methods
 *
 * see Title
 *
 * PHP version 7.3+
 *
 * @category   Logical Model
 * @package    Application
 * @author     Rick Myers <rick@humbleprogramming.com>
 * @copyright  2016-present Hedis Dashboard
 * @license    https://hedis.argusdentalvision.com/license.txt
 * @since      File available since Release 1.0.0
 */
class User extends Model
{

    //use \Code\Base\Humble\Event\Handler;
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
    
    public function logoff() {
        \Log::console('Yeah, Im trying to log off '.$this->getUid());
        Argus::emit('messageRelay',['message'=>'logUsersOff','id'=>$this->getUid()]);
       // Argus::emit('logUserOff',['id'=>$this->getUid()]);
    }

}