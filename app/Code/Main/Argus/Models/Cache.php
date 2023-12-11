<?php
namespace Code\Main\Argus\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Cache actions
 *
 * See Title
 *
 * PHP version 7.3+
 *
 * @category   Logical Model
 * @package    Application
 * @author     Rick Myers <rmyers@aflacbenefitssolutions.com>
 * @copyright  2016-present Hedis Dashboard
 * @license    https://hedis.aflacbenefitssolutions.com/license.txt
 * @since      File available since Release 1.0.0
 */
class Cache extends Model
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
     * Clears the security cache which will force the system to go get the new secret from AWS Secrets Manager
     * 
     * @workflow emit(securityCacheCleared)
     */
    public function clear() {
        Argus::cache($this->getToken(),null);
    }
}