<?php
namespace Code\Main\Tools\Models;
use Argus;
use Log;
use Environment;

/**
 * If you are going to be a "tool", you need to do at least the following:
 */
interface ArgusTool {
    public function initialize();   //Loads data
    public function run();          //Processes the data
    public function report();       //Reports on the processed data
    public function finalize();     //Outputs the processed data
}


/**    
 *
 * A tool parent class
 *
 * Manages the location of where the data files reside
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Client
 * @author     Rick Myers <rmyers@aflacbenefitssolutions.com>
 * @since      File available since Release 1.0.0
 * 
 */
class Tool extends Model   {
    
   // use \Code\Base\Humble\Event\Handler;    
    
    private $_root = false;

    public function getClassName() {
        return __CLASS__;
    }
    
    /**
     * 
     */
    public function __construct() {
        $this->_root(Environment::getRoot('argustools'));

        parent::__construct();
        return $this;
    }    
    /**
     * Fancy accessor/mutator for managing the base location for our data files
     * 
     * @param string $root
     * @return string
     */
    public function _root($root=false) {
        if ($root !== false) {
            $this->_root = $root;
        } else {
            return $this->_root;
        }
    }

    /**
     * Just something that populates data in the event object, used in testing
     * 
     * @workflow use(process)
     * @param type $EVENT
     * @returns bool
     */
    public function populateEvent($EVENT=false) {
        if ($EVENT!==false) {
            $template = <<<MSG
                    <h1> This is a test </h1>
                    <u>A man, a plan, a canal, panama<u>
                    %%test.greeting%%
MSG;
            $data = [
                'recipients' => 'rickmyers1969@gmail.com',
                'subject' => 'A test email',
                'person'    => 'Rick',
                'greeting' => '<h1>Hello %%test.person%%</h1>',
                'attachment' => [ 'data' => 'a long text file', 'filename' => 'message.txt'],
                'email_template' => $template
            ];
            $EVENT->update(['test'=>$data]);
        }
        return true;
    }

}
