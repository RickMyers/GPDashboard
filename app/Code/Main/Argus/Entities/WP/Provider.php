<?php
namespace Code\Main\Argus\Entities\WP;
use Argus;
use Log;
use Environment;
/**
 *
 * Relay to the DWH for provider search
 *
 * see title
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Application
 * @author     Rick Myers rick@humbleprogramming.com
 * @copyright  2007-Present, Rick Myers <rick@humbleprogramming.com>
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Provider.html
 * @since      File available since Release 1.0.0
 */
class Provider extends \Code\Main\Argus\Entities\MSEntity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Searches for a list of providers
     */
    public function search() {
        
    }
}