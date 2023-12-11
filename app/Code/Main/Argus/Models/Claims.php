<?php
namespace Code\Main\Argus\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * Claims related stuff
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Client
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Claims.html
 * @since      File available since Release 1.0.0
 */
class Claims extends Model
{

    use \Code\Base\Humble\Event\Handler;

    private $report = [];
    private $dwh    = false;
    
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
     * Based on varied criteria, retrieve claim data and then return it in CSV format
     * 
     * @return string
     */
    public function export() {
        $report = [];
        $claims = Argus::getEntity('argus/claims')->setProviderId($this->getProviderId())->setVerified($this->getVerified())->setMemberNumber($this->getMemberNumber())->setMemberName($this->getMemberName())->setEventId($this->getEventId())->setClientId($this->getClientId())->exportClaims();
        foreach ($claims as $claim) {
            $row = [];
            foreach ($claim as $field => $value) {
                if (is_array($value)) {
                    foreach ($value as $f => $v) {
                        $row[$f] = $v;
                    }
                } else {
                    $row[$field] = $value;
                }
            }
            $report[] = $row;
        }
        return Argus::getHelper('argus/CSV')->toCSV($report); 
    }
    
    /**
     * Work in progress... like all the other attempts
     * 
     * @param type $data
     * @return type
     */
    protected function organizeEdiFile($data) {
        $whereAt    = false;
        $currentHL  = false;
        $parentHL   = false;
        $currentSBR = false;
        $header     = true;
        $footer     = false;
        $summary = [
            'header'       => [],
            'hierarchy'     => [],
            'subscribers'   => [],
            'footer'        => []
        ];
        foreach (explode('~',$data) as $row) {
            $segments = explode('*',$row);
            switch ($segments[0]) {
                case    'HL' :
                    $header     = false;
                    $currentHL  = $segments[1];
                    $parentHL   = $segments[2];
                    if ($parentHL && !isset($summary['hierarchy']['HL_'.$parentHL])) {
                        $summary['hierarchy']['HL_'.$parentHL] = [];
                    }
                    if ($parentHL && $currentHL) {
                        $summary['hierarchy']['HL_'.$parentHL]['HL_'.$currentHL] = [];
                        $summary['hierarchy']['HL_'.$parentHL]['HL_'.$currentHL][]=$row;
                    } else if ($currentHL) {
                        $summary['hierarchy']['HL_'.$currentHL] = [];
                        $summary['hierarchy']['HL_'.$currentHL][]=$row;
                    }
                    break;
                case    'SE' :
                    $footer = true;
                    break;
                default      :
                    if ($header) {
                        $summary['header'][] = $row;
                    } else if ($footer) {
                        $summary['footer'][]  = $row;
                    } else {
                        if ($parentHL && $currentHL) {
                            $summary['hierarchy']['HL_'.$parentHL]['HL_'.$currentHL][] = $row;    
                        } else if ($currentHL) {
                            $summary['hierarchy']['HL_'.$currentHL][] = $row;    
                        }
                    }
            }
        }
        return $summary;
    }

    /**
     * Will read and output (download) a claim file
     * 
     * @param string $claim_file
     */
    public function download($claim_file=false) {
        if ($claim_file = ($claim_file) ? $claim_file : (($this->getClaimFile()) ? $this->getClaimFile() : false)) {
            header('Content-Disposition: attachment; filename="'.$claim_file.'"');
            if ($location = file_exists('/var/www/Claims/'.$claim_file) ? '/var/www/Claims/'.$claim_file : ((file_exists('/var/www/Claims/Archive/'.$claim_file)) ? '/var/www/Claims/Archive/'.$claim_file: false)) {
                return file_get_contents($location);
            } else {
                print("Claim File Not Found");
            }
        } else {
            print("No claim file name was passed to retrieve");
        }
    }
    
    /**
     * Part of a work in progress
     * 
     * @param type $filename
     * @return type
     */
    public function summarizeFile($filename=false) {
        if ($filename = ($filename) ? $filename : $this->getFileName()) {
            $summary  = $this->organizeEdiFile(file_get_contents($filename));
            file_put_contents('summary.rpt',print_r($summary,true));
        }
        return $summary;
    }

    /**
     * 
        F0:  Finalized, the claim has completed the adjudication cycle and is awaiting payment cycle [Y - for 'yes', it is paid]
        F1:  Finalized/Payment, the claim/line has been paid                                         [Y - for 'accepted', it hasn't been paid but will be]
        F2:  Finalized/Denied.  The claim/line has been denied.                                      [D - for 'denied', for some reason that needs researched]
        P1:  Pending/In Process                                                                      [I - for 'being processed right now', don't know yet if it will pay or be denied]
        F4:  Pending/Patient Requested Information, Payer requested COB or confirmation, etc.        [P - for 'pending', there's something wrong and the claim needs corrected]
     * 
     * @param array $claim
     * @param driver $aldera
     * @param entity $model
     * 
     */
    public function evaluateClaim($claim,$aldera,$entity) {
        $this->report[] = $claim['claim_number'];
        $details  = $aldera->setPatientControlNumber($claim['claim_number'])->claimData();  //This is an RPC to the Aldera REST API
        $j        = json_decode($details,true);
        $verified = false;
        $status   = ''; $text_status = '';
        $entity->reset()->setId($claim['id']);
        if (isset($j['details']['claims'][0])) {
            $dwh = ($this->dwh) ? $this->dwh : $this->dwh = Argus::getEntity('argus/aldera');
            $entity->setAlderaDetails(json_encode($j['details']['claims'][0]));
            $entity->setExtendedClaimData($dwh->extendedClaimData($j['details']['claims'][0]['claimNumber']));
            switch ($status = $j['details']['claims'][0]['claimStatus']) {
                case "F0" :
                    $verified = 'Y'; $text_status = 'Awaiting Payment Cycle';
                    break;                    
                case "F1" :
                    $verified = 'Y'; $text_status = 'Finalized, the claim was paid';
                    break;
                case "F2" :
                    $verified = 'D'; $text_status = 'Finalized, the claim was denied';
                    break;
                case "P1" :
                    $verified = 'I'; $text_status = 'Processing';
                    break;
                case "F4" :
                    $verified = 'P'; $text_status = 'Pending review';
                    break;
                default:
                    $verified = 'U'; $text_status = 'Unknown: ['.$status.']';
                    break;
            }
        } else {
            //now we do a date/time check and if more than 3 days has passed, we mark it missing 
            $datetime1  = new \DateTime($claim['date']);
            $datetime2  = new \DateTime(date('Y-m-d'));
            $difference = $datetime1->diff($datetime2);
            if ($verified   = ((int)$difference->d > 3) ? 'M' : false) {
                $text_status = 'Missing, review claim file for bad data';
            }
        } 
        if ($verified) {
           $entity->setVerified($verified)->setTextStatus($text_status)->save();
           $this->report[] = "Verified: ".$verified.' - '.$text_status;
        }
        return (($verified) ? $verified : 'N').' ['.$status.']';
    }
    
    public function writeReport() {
        //file_put_contents('claim_report.txt',implode("\n",$this->report));
    }
    
    /**
     * 
        F0:  Finalized, the claim has completed the adjudication cycle and is awaiting payment cycle [Y - for 'yes', it is paid]
        F1:  Finalized/Payment, the claim/line has been paid                                         [Y - for 'accepted', it hasn't been paid but will be]
        F2:  Finalized/Denied.  The claim/line has been denied.                                      [D - for 'denied', for some reason that needs researched]
        P1:  Pending/In Process                                                                      [I - for 'being processed right now', don't know yet if it will pay or be denied]
        F4:  Pending/Patient Requested Information, Payer requested COB or confirmation, etc.        [P - for 'pending', there's something wrong and the claim needs corrected]
     * 
     * @param array $claim
     * @param driver $aldera
     * @param entity $model
     * 
     */
    public function reconcileClaim($claim,$aldera) {
        $details  = $this->setPatientControlNumber($claim['claim_number'])->claimData();  
        $j        = json_decode($details,true);
        $verified = false;
        $status   = '';
        if (isset($j['details']['claims'][0])) {
            switch ($status = $j['details']['claims'][0]['claimStatus']) {
                case "F0" :
                    $verified = 'Y';
                    break;                    
                case "F1" :
                    $verified = 'Y';
                    break;
                case "F2" :
                    $verified = 'D';
                    break;
                case "P1" :
                    $verified = 'I';
                    break;
                case "F4" :
                    $verified = 'P';
                    break;
                default:
                    $verified = 'U';
                    break;
            }
            $this->setDetails($j['details']['claims'][0]);
        } else {
            //now we do a date/time check and if more than 3 days has passed, we mark it missing 
            $datetime1  = new \DateTime($claim['date']);
            $datetime2  = new \DateTime(date('Y-m-d'));
            $difference = $datetime1->diff($datetime2);
            $verified   = ((int)$difference->d > 3) ? 'M' : false;
            $this->setDetails(false);
        } 
        return $verified;
    }

    
    /**
     * Grabs claims that aren't in a finished or failed state
     * 
     * @workflow use(process) configuration(/argus/claims/batch)
     * @param type $EVENT
     */
    public function batchUnreconciledClaims($EVENT=false) {
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            if (isset($cfg['field']) && $cfg['field']) {
                $claims = Argus::getEntity('argus/claims');
                $EVENT->update(
                    [
                        $cfg['field']  => [
//                            'other'             => $claims->reset()->setVerified(null)->fetch()->toArray(),
                            CLAIM_DENIED        => $claims->reset()->setVerified(CLAIM_DENIED)->fetch()->toArray(),
                            CLAIM_READY         => $claims->reset()->setVerified(CLAIM_READY)->fetch()->toArray(),
                            CLAIM_PENDING       => $claims->reset()->setVerified(CLAIM_PENDING)->fetch()->toArray(),
                            CLAIM_INPROGRESS    => $claims->reset()->setVerified(CLAIM_INPROGRESS)->fetch()->toArray(),
                            CLAIM_MISSING       => $claims->reset()->setVerified(CLAIM_MISSING)->fetch()->toArray(),
                        ]
                    ]
                );
            }
        }        
    }
    
    /**
     * Will receive a list of claims and try to reconcile them with Aldera
     * 
     * This is the reconciliation from prior to 2022... use the 'reconciliation' method instead
     * 
     * @workflow use(process) configuration(/argus/claims/reconciliation)
     * @param type $EVENT
     */
    public function attemptClaimReconciliation($EVENT=false) {
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            if (isset($cfg['field']) && $cfg['field'] && isset($data[$cfg['field']])) {
                $claims_orm = Argus::getEntity('argus/claims');
                $report     = [];
                $aldera     = Argus::getEntity('argus/aldera');
                foreach ($data[$cfg['field']] as $status => $claims) {
                    foreach ($claims as $claim) {
                        $report[] = [
                            'id' => $claim['id'],
                            'claim_number'      => $claim['claim_number'],
                            'member_number'     => $claim['member_number'],
                            'original_status'   => $claim['verified'],
                            'new_status'        => $this->reconcileClaim($claim,$aldera,$claims_orm),
                            'aldera_details'    => $this->getDetails()
                        ];
                    }
                }
                foreach ($report as $line) {
                    if ($line['original_status'] !== $line['new_status']) {
                       $claims_orm->reset()->setId($line['id'])->setVerified($line['new_status'])->setAlderaDetails($this->getDetails())->save();
                    }
                }
            }
            $EVENT->update([$cfg['report']=>$report]);
        }        
    }
    
    
    public function reconcileReport($EVENT=false) {
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            if (isset($data[$cfg['reconciliation_report']])) {
                $orm = Argus::getEntity('argus/claims');
                foreach ($data[$cfg['reconciliation_report']] as $claim) {
                    if ($claim['original_status']!==$claim['current_status']) {
                        $orm->reset()->setId($claim['id'])->setVerified($claim['current_status'])->save();
                    }
                }
            }
        }
    }
    
    /**
     * 
     * @workflow use(process) configuration(argus/claims/reconciliation)
     * @param type $EVENT
     */
    public function claimsReconciliationReport($EVENT=false) {
        $argus  = Argus::getEntity('argus/claims');
        $dwh    = Argus::getEntity('argus/aldera');
        $report = [];
        foreach ($argus->unfinishedClaims() as $claim) {
            $report[$claim['id']] = ['hedis_claim_number'=>$claim['number'],'original_status'=>$claim['verified']];
            if ($log    = $dwh->setPosClaimId($claim['claim_number'])->claimLogInformation()) {
                $report['id']['aldera_claim_number'] = $log['claim_number'];
                $data   = $dwh->setClaimNumber($log['claim_number'])->claimDetailInformation();
                $status = 'U';                                                  //unknown
                if (isset($data['default_status'])) {
                    switch ($data['default_status']) {
                        case 'P'    : $status = 'Y';
                            break;
                        case 'F'    :
                        case 'R'    : $status = 'D';
                            break;
                        case 'X'    : $status = 'V';
                            break;
                        case 'P'    : $status = 'I';
                            break;
                        default:
                            break;
                    }
                }
                $report[$claim['id']]['current_status']=$status;
            } else {
                //figure out if missing
            }
        }        
    }
    
    /**
     * Checks to see if there are claims attached to the event, returning true if indeed there are
     * 
     * @workflow use(decision) configuration(/argus/claims/ready)
     * @param type $EVENT
     * @return boolean
     */
    public function claimsAvailableToReconcile($EVENT=false) {
        $available = false;
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            if (isset($cfg['field']) && $cfg['field'] && isset($data[$cfg['field']])) {
                $ctr = 0;
                foreach ($data[$cfg['field']] as $status => $claims) {
                    $ctr += count($claims);
                }
                $available = ($ctr > 0);
            }
        }
        return $available;
    }

}