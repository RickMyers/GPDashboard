<?php
namespace Code\Main\Vision\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Primary Care Physician methods
 *
 * see title
 *
 * PHP version 7.2+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@argusdentalvision.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Pcp.html
 * @since      File available since Release 1.0.0
 */
class Pcp extends Model
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
     * Adds unregistered PCPs to our physician register, but doesn't create a portal or userid for them... that's done elsewhere
     */
    public function registerPCP() {
        if ($form = Argus::getEntity('vision/consultation/forms')->setId($this->getFormId())->load()) {
            if (isset($form['primary_doctor']) && isset($form['physician_npi_combo']) && $form['primary_doctor'] && $form['physician_npi_combo']) {
                $name = explode(",",$form['primary_doctor']);
                Argus::getEntity('argus/primary_care_physicians')->setFirstName(trim($name[1]))->setLastName(trim($name[0]))->setNpi(trim($form['physician_npi_combo']))->save();
            }
        }
    }
    
    /**
     * Will look for unregistered PCPs and create accounts for them, creating a unique userid and assigning password as their NPI.  Also will give them the PCP role...
     */
    public function register() {
        $user       = Argus::getEntity('humble/users');
        foreach (Argus::getEntity('argus/primary_care_physicians')->setRegistered('N')->fetch() as $pcp) {
            $pcp['first_name'] = trim($pcp['first_name']);
            $pcp['last_name'] = trim($pcp['last_name']);
            $this->createAccount($user,$pcp);
        }
    }
    
    /**
     * Determines if there are new forms to review, and if so
     * 
     * @workflow use(decision) configuration(/vision/pcp/formstoreview) 
     * @param type $EVENT
     * @return boolean
     */
    public function odHasFormsToReview($EVENT=false) {
        $review = false;
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
        }
        return $review;
    }
    public function sendNotification() {
        
    }
    
    /**
     * Create the account for the PCP using the NPI as password and setting the change-password token
     * 
     * Also selects the right graphs and desktop app
     * 
     * @workflow use(EVENT)
     * 
     * @param emtotu $user
     * @param array $pcp
     */
    public function createAccount($user=false,$pcp=false) {
        $user        = ($user) ? $user : Argus::getEntity('humble/users');
        $app_id      = Argus::getEntity('dashboard/available_apps')->getAppIdByName('PCP Reports');
        $app         = Argus::getEntity('dashboard/installed_apps');
        $user_role   = Argus::getEntity('argus/user_roles');        
        $pcps        = Argus::getEntity('argus/primary_care_physicians');        
        $pcp_role    = Argus::getEntity('argus/roles')->getRoleIdByName('Primary Care Physician');        
        $reports     = Argus::getEntity('vision/pcp_reports')->fetch();
        $chart       = Argus::getEntity('dashboard/user_charts');
        $username    = Argus::getEntity('argus/user')->fetchUserName(trim($pcp['first_name']).' '.trim($pcp['last_name']));
        if ($username) {
            if ($uid = $user->setResetPasswordToken($this->_uniqueId())->newUser($username,md5($pcp['npi']),$pcp['last_name'],$pcp['first_name'])) {
                $pcps->reset()->setId($pcp['id'])->setUserId($uid)->setRegistered('Y')->save();
                $user_role->reset()->setUserId($uid)->setRoleId($pcp_role)->save();
                $app->setUserId($uid)->setAppId($app_id)->save();
                $ctr =0;
                $pcp = array_merge([
                            'user_name' => $username,
                            'user_id'   => $uid
                        ],
                        $pcp);
                foreach ($reports as $report) {
                    $chart->reset()->setNamespace('dashboard')->setController('user')->setAction('home')->setLayer('dashboard-chart-'.++$ctr)->setUserId($uid)->setChartId($report['chart_id'])->save();
                }
                $this->trigger('newPCPRegistered',__CLASS__,__METHOD__,$pcp);
            }
        }
    }
    
    /**
     * 
     * o We need to add this member if they don't exist
     * o We need to add the PCP if they don't exist
     * o We need to relate the two together if no relationship exists
     * o We need to create the account for the new PCP
     */
    public function add() {
        if ($form = Argus::getEntity('vision/consultation/forms')->setId($this->getId())->load()) {
            $relation_id = false; $member_id = false;
            if (isset($form['physician_npi']) && ($form['physician_npi'])) {
                if (!count($physician = Argus::getEntity('argus/primary_care_physicians')->setNpi(trim($form['physician_npi']))->load(true))) {
                    if (isset($form['primary_doctor']) && $form['primary_doctor']) {
                        $dr         = explode(',',$form['primary_doctor']);
                        if (isset($dr[1])) {
                            if ($relation_id = Argus::getEntity('argus/primary_care_physicians')->setLastName(trim($dr[0]))->setFirstName(trim($dr[1]))->setNpi(trim($form['physician_npi']))->save()) {
                                //@TODO: now go create an account for this person
                            }
                        }
                    }
                } else {
                    $relation_id = $physician['id'];
                }
                $hp_data    = Argus::getEntity('vision/clients')->setClient($form['screening_client'])->load(true);
                if (!count($member  = Argus::getEntity('vision/members')->setHealthPlanId($hp_data['id'])->setMemberNumber($form['member_id'])->load())) {
                    $nm = explode(',',$form['member_name']);
                    if (isset($nm[1])) {
                        $member_id = Argus::getEntity('vision/members')->setFirstName(trim($nm[1]))->setLastName(trim($nm[0]))->setDateOfBirth(date('Y-m-d',strtotime($form['date_of_birth'])))->setMemberNumber($form['member_id'])->setHealthPlanId($hp_data['id'])->save();
                    }
                } else {
                    $member_id = $member['id'];
                }
                if ($relation_id && $member_id) {
                    if (count($relationship =  Argus::getEntity('argus/relationship_dates')->setMemberId($member['id'])->setRelationId($relation_id)->setRelationshipType(1)->load(true))) {
                        if (!$relationship['effective_end_date'] || (strtotime($relationship['effective_end_date']) > strtotime(date('Y-m-d')))) {
                            //no end date or end date later than today so you are fine
                        } else {
                            $t = Argus::getEntity('argus/relationship/dates')->setMemberId($member_id)->setRelationId($relation_id)->setEffectiveEndDate(null)->setRelationshipType(1)->save();
                        }
                    } else {
                        //Create new relationship
                        $t = Argus::getEntity('argus/relationship/dates')->setMemberId($member_id)->setRelationId($relation_id)->setEffectiveStartDate(date('Y-m-d'))->setRelationshipType(1)->save();
                    }
                }
                $this->setFormId($this->getId())->registerPCP();                //No longer eating our own dog food... we are doing direct calls
                $this->register();
            }
        }
    }
    
    /**
     * Returns the results of vision screenings/scannings using a required PCP NPI and optionally a date (otherwise todays date is used)
     * 
     * @workflow use(process)
     * @param type $EVENT
     */
    public function screeningFormResults($EVENT=false) {
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            if ($data && isset($data['npi']) && $data['npi']) {
                $forms = Argus::getEntity('vision/consultation/forms')->setNpi($data['npi']);
                $date  = (isset($data['date']) && $data['date']) ? date('Y-m-d',strtotime($data['date'])) : date('Y-m-d');
                $results = ['pcpresults'=>Argus::getEntity('vision/consultation/forms')->setNpi($data['npi'])->setDate($date)->screeningFormsByPCP()->toArray()];
                $EVENT->update($results);
            }
        }
    }
    
    /**
     * Creates a PCP Portal from data collected by the desktop utility
     */
    public function createPortal() {
        $result     = 'Failed To Create Portal';
        $first_name = $this->getFirstName();
        $last_name  = $this->getLastName();
        $npi        = $this->getNpi();
        $pcp        = Argus::getEntity('argus/primary_care_physicians');
        if (!count($pcp->setNpi($npi)->load(true))) {
            if ($pcp->reset()->setNpi($npi)->setFirstName($first_name)->setLastName($last_name)->setRegistered('N')->save()) {
                $this->register();
                $result = 'PCP Portal Created';
            }
            
        } else {
            $result = 'PCP Portal Already Exists!';
        }
        return $result;
    }
    
    /**
     * This just proves something was triggered
     * 
     * @workflow use(process)
     * @param type $EVENT
     */
    public function testRun($EVENT=false) {
        file_put_contents('triggered_last.run',date('m/d/Y H:i:s'));
    }
    
    /**
     * Will generate an event per each PCP that has had new forms arrive in the last 24 hours
     * 
     * @workflow use(process) configuration(/vision/pcp/notification) emit(pcpFormsAvailable)
     * @param type $EVENT
     */
    public function generatePCPNotifications($EVENT=false) {
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            if ($end_date = (isset($data['date']) && $data['date']) ? date('Y-m-d',strtotime($data['date'])) : date('Y-m-d')) {
                $date       = new DateTime($start_date);
                $start_date = $date->sub(new DateInterval('24h'));
                $pcps       = [];
                foreach (Argus::getEntity('vision/consultation/forms')->PCPFormsBetweenDates($start_date,$end_date) as $form) {
                    $pcps[$form['npi']]   = isset($pcps[$form['npi']]) ? $pcps[$form['npi']] : [];
                    $pcps[$form['npi']][] = $form;
                }
                foreach ($pcps as $npi => $forms) {
                    $this->trigger('pcpFormsAvailable', __CLASS__, __METHOD__, [ 'first_name' => $forms[0]['first_name'], 'last_name'  => $forms[0]['last_name'],'email'  => $forms[0]['email'], 'members'   => $forms ]);
                }
            }
        }
    }
    
}