<?php
namespace Code\Main\Argus\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * MS SQL Server Limited Support
 *
 * This class is a minor wrapper for MS SQL Server basic load/fetch
 * feature, along with custom queries
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Client
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-MSObject.html
 * @since      File available since Release 1.0.0
 */
class MSEntity extends \Code\Base\Humble\Entities\Unity
{

    private     $project    = null;
    private     $settings   = null;
    private     $term       = true;
    protected   $_ms_db     = false;
    protected   $_isVirtual = null;
    
    /**
     * By being a public function, allows for alternative connection options
     */
    public function connect($dbhost,$connectionOptions) {
        if (!$this->_ms_db = sqlsrv_connect($dbhost,$connectionOptions)) {
            \Log::error(sqlsrv_errors());
            if ($this->term) {
                print_r(sqlsrv_errors());
                die();
            }
        }
        return $this;
    }
    
    /*
     * Standard connection to the data warehouse
     */
    public function __construct($term=true) {
        $this->term = $term;
        if ($this->project = Environment::getProject()) {
            require "../../Settings/".$this->project->namespace."/MSSettings.php";
            if ($this->settings = new \MSSettings()) {
                $a = $this->settings;
                $connectionOptions = [
                    "Database" => $this->settings->getDatabase(),
                    "Uid" => $this->settings->getUserid(),
                    "PWD" => $this->settings->getPassword()
                ];
                $this->connect($this->settings->getDBHost(),$connectionOptions);
            }
        }
        //parent::__construct();
    }
    
    /**
     * Simple wrapper for the SQL Server Query method, but doesn't support enhanced functionality as the normal Harmony ORM
     * 
     * @param type $query
     * @return type
     */
    public function query($query=false) {
        $dataset = [];
        if ($query) {
            if ($dataset = sqlsrv_query($this->_ms_db,$query)) {
            } else {
                print_r(sqlsrv_errors());
            }
        }
        return \Humble::getModel('argus/iterator')->set($dataset);
    }
    
    /**
     *
     */
    public function _entity($arg=false) {
        if ($arg) {
            $this->_entity = $arg;
            return $this;
        } else {
            return $this->_entity;
        }
    }

    /**
     *
     */
    public function _namespace($arg=false) {
        if ($arg) {
            $this->_namespace = $arg;
        } else {
            return $this->_namespace;
        }
        return $this;
    }


}