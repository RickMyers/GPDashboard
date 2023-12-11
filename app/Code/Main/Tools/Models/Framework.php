<?php
namespace Code\Main\Tools\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * The base tool framework
 *
 * This class implements a "dependency injection" design pattern
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Framework
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @since      File available since Release 1.0.0
 */

class Framework extends Model
{

    use \Code\Base\Humble\Event\Handler;
    
    private $_dependency    = null;
    private $_description   = null;
    private $_authorization = null;
    private $_role          = null;
    private $_start         = null;
    private $_end           = null;
    
    /**
     * Constructor
     */
    public function __construct($dependency=false) {
        if ($dependency !== false) {
            $this->_dependency($dependency);
        }
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

    protected function silentPrompt($prompt = "Enter Password:") {
        $password = null;
        if (preg_match('/^win/i', PHP_OS)) {
            $vbscript   = sys_get_temp_dir() . 'prompt_password.vbs';
            file_put_contents($vbscript, 'wscript.echo(InputBox("'. addslashes($prompt).'", "", "Please Enter the Password"))');
            $command    = "cscript //nologo " . escapeshellarg($vbscript);
            $password   = rtrim(shell_exec($command));
            unlink($vbscript);
        } else {
            $command = "/usr/bin/env bash -c 'echo OK'";
            if (rtrim(shell_exec($command)) !== 'OK') {
                die("Can't invoke bash");
            }
            $command = "/usr/bin/env bash -c 'read -s -p \"". addslashes($prompt). "\" mypassword && echo \$mypassword'";
            $password = rtrim(shell_exec($command));
        }
        return $password;
    }
    
    /**
     * Fancy accessor/mutator
     * 
     * @param class $arg
     * @return class
     */
    public function _authorization($arg=false) {
        if ($arg !== false) {
            $this->_authorization = $arg;
        }
        return $this->_authorization;
    }
    
    /**
     * Fancy accessor/mutator
     * 
     * @param class $arg
     * @return class
     */
    public function _role($arg=false) {
        if ($arg !== false) {
            $this->_role = $arg;
        }
        return $this->_role;
    }    
    
    /**
     * Fancy accessor/mutator for the dependent class
     * 
     * @param class $d
     * @return class
     */
    public function _dependency($d=false) {
        if ($d !== false) {
            $this->_dependency = $d;
        }
        return $this->_dependency;
    }

    /**
     * Fancy accessor/mutator for the dependent class
     * 
     * @param class $d
     * @return class
     */
    public function _description($d=false) {
        if ($d !== false) {
            $this->_description = $d;
        }
        return $this->_description;
    }
    
    /**
     * Validates that a username (with password) has the required role to run this tool
     * 
     * @return boolean
     */
    private function authorizationRoutine() {
        $username = readline("User Name: ");
        $pde = new DateTime();
        $pde->modify('+3 months');
        $pde->format('d');
        if (!count($data = Argus::getEntity('humble/users')->setUserName($username)->setPassword(MD5($this->silentPrompt('Please enter your password')))->setPde($pde)->load(true))) {
           die("\nAuthorization Failure\n");
        } else {
           if (!count(Argus::getEntity('argus/user_roles')->setUserId($data['uid'])->setRoleId($this->_role($this->_role()))->load(true))) {
               die("\nYou lack the required role to run this tool\n");
           }
        }
        return true;
    }
    
    /**
     * Prints a header with some accounting information and a description
     */
    public function printHeader() {
        $len = strlen($this->_description())*2;
        $pre = "## "; $post = " ##\n";
        $tot = $len + 6;
        $bar = str_pad('',$tot,'#')."\n";
        print("\n".$bar);
        print($pre.str_pad('',$len).$post);
        print($pre.str_pad($this->_description(),$len,' ',STR_PAD_BOTH).$post);
        print($pre.str_pad('',$len).$post);
        print($bar);
        print($bar);        
        print($pre.str_pad('Starting @ '.date("m/d/Y H:i:s",$this->_start()),$len,' ',STR_PAD_BOTH).$post);
        print($pre.str_pad('',$len).$post);
    }
    
    /**
     * Prints the footer with some accounting information
     */
    public function printFooter($success=false) {
        $message = ($success) ? "Success!" : "Failure.";
        $len = strlen($this->_description())*2;
        $pre = "## "; $post = " ##\n";
        $tot = $len + 6;
        $bar = str_pad('',$tot,'#')."\n";
        print($pre.str_pad('',$len).$post);
        print($pre.str_pad($message.' @ '.date("m/d/Y H:i:s",$this->_start()),$len,' ',STR_PAD_BOTH).$post);        
        print($bar);        
    }
    
    
    public function report() {
        $successful = false;
        $this->printHeader();
        if ($this->_dependency()) {
            if ($this->_dependency->initialize()) {
                if ($this->_dependency->run()) {
                    $successful = true;
                    $this->_dependency->report();
                } else {
                    //throw a run error
                }
            } else {
                //throw a initialize error
            }

        } else {
            //Throw a missing dependency tantrum
        }
        $this->_end();
        $this->printFooter($successful);
        return $successful;
    }
    
    /**
     * 
     */
    public function execute() {
        if ($this->_authorization() == 'Y') {
            $this->authorizationRoutine();
        }
        try {
            $successful = false;
            $this->printHeader();
            //print header, record time
            if ($this->_dependency()) {
                if ($this->_dependency->initialize()) {
                    if ($this->_dependency->run()) {
                        if ($this->_dependency->finalize()) {
                            $successful = true;
                        } else {
                            //throw a finalize error
                        }
                    } else {
                        //throw a run error
                    }
                } else {
                    //throw a initialize error
                }

            } else {
                //Throw a missing dependency tantrum
            }
        } catch (Exception $ex) {
            print($ex->getMessage()."\n");
        }
        $this->_end();
        $this->printFooter($successful);
    }
    
    private function _start() {
        if (!$this->_start) {
            $this->_start = time();
        }
        return $this->_start;
    }
    
    private function _end() {
        if (!$this->_end) {
            $this->_end = time();
        }
        return $this->_end;
    }    
    /**
     * Relay to the dependency's magic method
     * 
     * @param string $var
     * @param mixed $val
     * @return $this
     */
    public function __set($var,$val) {
        if ($this->_dependency) {
            $this->_dependency->__set($var,$val);
        }
        return $this;
    }

    /**
     * Relay to the dependency's magic method
     * 
     * @param string $var
     * @return $this
     */    
    public function __get($var) {
        if ($this->_dependency) {
            $this->_dependency->__get($var);
        }
        return $this;
    }    

    /**
     * Relay to the dependency's magic method
     * 
     * @param string $name
     * @param mixed $arguments
     * @return $this
     */    
    public function __call($name,$arguments) {
        if ($this->_dependency) {
            $this->_dependency->__call($name,$arguments);
        }
        return $this;
        
    }
}