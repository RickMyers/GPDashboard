<?php
namespace Code\Main\Argus\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * PCP Methods
 *
 * For general PCP related actions, these methods support retrieving and
 * manipulation of PCP information
 *
 * PHP version 7.2+
 *
 * @category   Logical Model
 * @package    Core
 * @author     Richard Myers <rmyers@argusdentalvision.com>
 * @copyright  2005-present Hedis Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-PCP.html
 * @since      File available since Release 1.0.0
 */
class PCP extends Model
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
     * Consults our local cache of PCP information first, but then hits the CMS Registry if nothing is found
     * 
     * @return json
     */
    public function info() {
        $info   = '';
        $pcp    = Argus::getEntity('argus/pcp/cache');
        if ($npi = $this->getNumber()) {
            if (!count($data = $pcp->setNpi($npi)->load(true))) {               //if we don't have this pcp in our cache, continue below to get data and store locally
                if ($info = $this->npiLookup()) { 
                    $data = json_decode($info,true);
                    if (isset($data['result_count']) && $data['result_count']) {
                        $pcp->setInfo($data)->save();
                    }
                }
            } else {
                $info = json_encode($data['info']);                             //We had found an entry in the cache so are pulling just the "info" node
            }
        }
        return $info;
    }
}