<?php
namespace Code\Clients\Prestige\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Limited SQL Server Support
 *
 * Due to the use of SQL Server, we are going to only provide a bit of
 * support
 *
 * PHP version 7.2+
 *
 * @category   Logical Model
 * @package    Client
 * @author     Richard Myers <rmyers@argusdentalvision.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Eligibility.html
 * @since      File available since Release 1.0.0
 */
class Eligibility extends Model
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
     * From a field set in configuration, uses the member id to look up member information and attach it to the event in another field also specified from the configuration
     * 
     * @workflow use(process) configuration(/prestige/eligibility/attach)
     * @param type $EVENT
     */
    public function attach($EVENT=false) {
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            if (isset($data[$cfg['source']]) && ($data[$cfg['source']])) {
                $results = Argus::getMSEntity('prestige/eligibility')->setMemberId($data[$cfg['source']])->current()->toArray();
                $EVENT->update([$cfg['field']=>(isset($results[0])?$results[0]:false)]);
            }
        }
    }

    /**
     * Will output information about multiple members
     * 
     * @workflow use(process) configuration(/prestige/eligibility/output)
     * @param type $EVENT
     */    
    public function multiOutput($EVENT=false) {
        $output = [];
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            $output = $data;
        }
        Argus::response(json_encode($data['members'],JSON_PRETTY_PRINT));
    }
    
    /**
     * Gets a list of member ids in JSON format and gets their information, including eligibility
     * 
     * @workflow use(process) configuration(/prestige/eligibility/attach)
     * @param type $EVENT
     */
    public function multiCheck($EVENT=false) {
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            if (isset($data[$cfg['source']]) && ($data[$cfg['source']])) {
                $results = Argus::getMSEntity('prestige/eligibility')->setMemberIds($data[$cfg['source']])->multipleCheck()->toArray();
                $EVENT->update([$cfg['field']=>$results]);
            }
        }
    }
    
    /**
     * Will output just the effect start date and the termination date
     * 
     * @workflow use(process) configuration(/prestige/eligibility/output)
     * @param type $EVENT
     */
    public function output($EVENT=false) {
        $output     = [];
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            if (isset($data[$cfg['field']]) && $data[$cfg['field']]) {
                if (isset($cfg['expose']) && ($cfg['expose']=='all')) {
                    $output = (array)$data[$cfg['field']];
                } else {
                    $sd = (array)$data[$cfg['field']]['effective_date'];
                    $ed = (array)$data[$cfg['field']]['termination_date'];
                    $sd = date('Y-m-d',strtotime($sd['date']));
                    $ed = date('Y-m-d',strtotime($ed['date']));
                    $output = [
                        'effective_start_date'  => $sd,
                        'effective_end_date'    => $ed,
                        'active'                => (date('Y-m-d')<$ed)
                    ];
                }
            }
            
        }
        Argus::response(json_encode($output,JSON_PRETTY_PRINT));
    }
 
}