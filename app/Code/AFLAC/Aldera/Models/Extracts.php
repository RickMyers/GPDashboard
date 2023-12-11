<?php
namespace Code\AFLAC\Aldera\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * Aldera related methods
 *
 * Aldera related functionality
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Client
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @copyright  2005-present &&PROJECT&&
 * @license    https://jarvis.enicity.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://jarvis.enicity.com/docs/class-&&MODULE&&.html
 * @since      File available since Release 1.0.0
 */
class Extracts extends Model
{

    use \Code\Base\Humble\Event\Handler;

	/**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    
    /**
     * Interfaces with Aldera to retrieve 834 data
     * 
     * @workflow use(process) configuration(/aldera/extracts/get834)
     * @param type $EVENT
     */
    public function get834($EVENT=false) {
        $retrieved = false;
        print("I am getting an 834");
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
        }
        return $retrieved;
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
