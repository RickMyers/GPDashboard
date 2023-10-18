<?php
namespace Code\Main\Dashboard\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * Generic Query Module
 *
 * This isn't a real entity, it's just a wrapper to run a query
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Application
 * @author     Rick Myers rick@humbleprogramming.com
 * @copyright  2007-Present, Rick Myers <rick@humbleprogramming.com>
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Query.html
 * @since      File available since Release 1.0.0
 */
class Query extends Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Wrapper for executing a general SELECT query... doesn't support modifying data
     * 
     * @return type
     */
    public function exec() {
        $results = [];
        if ($query = trim($this->getQuery())) {
            $words = explode(' ',strtoupper($query));
            if ($words[0] === 'SELECT') {
                $results = $this->query($query);                                // No modifi
            }
        }
        return $results;
    }
}