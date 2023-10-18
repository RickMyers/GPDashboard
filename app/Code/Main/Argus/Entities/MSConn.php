<?php
namespace Code\Main\Argus\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * SQL Server Connection Check
 *
 * A simple utility to see if we can connect to the server before we run
 * some other action
 *
 * PHP version 7.0+
 *
 * @category   Entity
 * @package    Dashboard
 * @author     Rick Myers rmyers@argusdentalvision.com
 */
class MSConn extends MSEntity
{

    /**
     * Constructor
     */
    public function __construct() {

    }

    /**
     * A check to see if we can establish a connection to the SQL server because it tends to be flakey
     * 
     * @return boolean
     */
    public function status() {
        parent::__construct(false);  //don't term if you encounter an error
        return ($this->_ms_db !== false) ? 1 : 0;
    }
    
}