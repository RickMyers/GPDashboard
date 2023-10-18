<?php
namespace Code\Main\Dashboard\Models;
use Humble;
use Log;
use Environment;
/**    
 *
 * Dashboard Controls
 *
 * Handles dashboard controls
 *
 * PHP version 5.5+
 *
 * @category   Logical Model
 * @package    Framework
 * @author     Richard Myers <rmyers@argusdentalvision.com>
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://jarvis.enicity.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://jarvis.enicity.com/docs/class-&&MODULE&&.html
 * @since      File available since Release 3.0.0
 */
class Controls extends Model
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

    public function progress() {
        $app = $this->getApp();
        $file = 'progress/'.Environment::whoAmI().'/'.$app.'.json';
        return file_exists($file) ? file_get_contents($file) : json_encode(['app'=>$app,'result'=>'Progress File Not Found','RC'=>16]);
    }
}