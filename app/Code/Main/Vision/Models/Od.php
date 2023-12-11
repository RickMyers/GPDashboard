<?php
namespace Code\Main\Vision\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * O.D. Related Methods
 *
 * see Title
 *
 * PHP version 7.2+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Mark Sarno, O.D. <msarno@aflacbenefitssolutions.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Od.html
 * @since      File available since Release 1.0.0
 */
class Od extends Model
{

    use \Code\Base\Humble\Event\Handler;
    
    private $od_stages = [
            'I' => 'In Review',
            'S' => 'Submitted',
            'N' => 'New',
            'R' => 'Returned'
        ];
    
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
     * Reassigns a set number of available scanning forms to an O.D.
     * 
     * @return type
     */
    public function reassign() {
        $total = $this->getReassign();
        $ctr   = 0;
        if ($assignee = $this->getAssignee()) {
            $od_form  = Argus::getEntity('vision/consultation/forms');
            foreach (Argus::getEntity('vision/consultation/forms')->odScanningForms() as $form) {
                if (!$form['reviewer']) {
                    $od_form->reset()->setId($form['id'])->setReviewer($assignee)->save();
                }
                if (++$ctr >= $total) {
                    return;
                }
            }
        }
    }
    
    /**
     * Calculates the number of scannings/screenings waiting for an OD to review, and adds that information to the Event
     * 
     * @workflow use(process) configuration(/vision/od/workloads)
     * @param type $EVENT
     */
    public function currentOdWorkloads($EVENT=false) {
        if ($EVENT!==false) {
            $cfg    = $EVENT->fetch();
            if (isset($cfg['field_name']) && $cfg['field_name']) {
                $workload = ['unassigned'=>[]];
                foreach (Argus::getEntity('vision/consultation/forms')->odWorkloads() as $row) {
                    if ($row['reviewer']) {
                        if (!isset($workload[$row['reviewer']])) {
                            $workload[$row['reviewer']] = [];
                        }
                        if (!isset($workload[$row['reviewer']][$row['status']])) {
                            $workload[$row['reviewer']][$row['status']] = [];
                        }
                        $workload[$row['reviewer']][$row['status']][] = $row;
                    } else {
                        $workload['unassigned'][] = $row;
                    }
                };
                $EVENT->update([$cfg['field_name']=>$workload]);
            }
        }
    }    
    
    /**
     * By looking at a configurable field on the event, we will return true if we find one or more ODs that have an active workload
     * 
     * @workflow use(decision) configuration(/vision/od/activeworkload)
     * @param type $EVENT
     * @return boolean
     */
    public function odWorkloadFound($EVENT=false) {
        $workload_found = false;
        if ($EVENT!==false) {
            $cfg    = $EVENT->fetch();
            $data   = $EVENT->load();
            $workload_found = (isset($data[$cfg['field_name']]) && count($data[$cfg['field_name']])>0);
        }
        return $workload_found; 
    }
       
    /**
     * Will receive a list of OD workloads and will spawn a 'odWorkloadNotification' event that can be handled by another workflow
     * 
     * @workflow use(process) configuration(/vision/od/notification) emit(odWorkloadNotification) comment(A notification that there is work for an OD)
     * @param type $EVENT
     */   
    public function odWorkloadNotifications($EVENT=false) {  
        if ($EVENT!==false) {
            $cfg    = $EVENT->fetch(); 
            $data   = $EVENT->load(); 
            if (isset($data[$cfg['field_name']])) { 
                $user       = Argus::getEntity('humble/users');
                $unassigned = 0;
                foreach ($data[$cfg['field_name']] as $OD => $workload) {
                    if ($OD == "unassigned") {
                        $unassigned = count($workload);
                        continue;
                    }
                    $event = ['queues' => []];
                    foreach ($workload as $stage => $rows) {
                        if ($stage = (isset($this->od_stages[$stage]) ? $this->od_stages[$stage] : false)) {
                            $event['queues'][$stage] = count($rows);
                        }
                    } 
                    if (count($event)) {
                        if ($info = $user->reset()->setUid($OD)->information()) {
                              $event['name']    = $info['first_name'].' '.$info['last_name'];
                              $event['email']   = $info['email'];
                              $event['subject'] = 'Status of Forms for review';
                              $event['unassigned'] = $unassigned;
                        } 
                        $this->fire(
                            $this->_namespace(),
                            'odWorkloadNotification',
                            $event
                        ); 
                    }  
                }
            }
        }        
    }
}