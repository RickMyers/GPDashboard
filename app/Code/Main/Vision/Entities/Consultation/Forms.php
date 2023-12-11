<?php
namespace Code\Main\Vision\Entities\Consultation;
use Argus;
use Log;
use Environment;
/**
 * 
 * Consultation Form Queries
 *
 * Compound and Complex Queries pertaining to the forms we use for remote
 * vision consultations
 *
 * PHP version 7.0+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @since      File available since Release 1.0.0
 */
class Forms extends \Code\Main\Vision\Entities\Entity
{

    private $formData = [];
    
    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }


    /**
     * Retrieves a list of claims in the Admin or Complete queue that are flagged as failed in the claiming process
     * 
     * @return type
     */
    public function failedClaims() {
        $query = <<<SQL
        select * from vision_consultation_forms
         where claim_status = 'E' and `status` in ('A','C')
SQL;
        return $this->addAvatars($this->query($query));
    }
    
    
    public function missingPCPPortals() {
        $query = <<<SQL
            SELECT DISTINCT a.physician_npi_combo, b.* FROM vision_consultation_forms AS a
             LEFT OUTER JOIN argus_primary_care_physicians AS b
               ON a.physician_npi_combo = b.npi
            WHERE a.event_date > '2020-01-01'
              and a.`status` in ('C','A','I','R')
              AND b.id IS NULL
SQL;
        return $this->query($query);
    }
    
    /**
     * Sums up the number of records in the table that do not have a value for reviewer and a status of 'S' for submitted.
     * 
     * @return int
     */
    public function unassigned() {
        $query = <<<SQL
                select count(*) as total
                  from vision_consultation_forms
                 where reviewer is null
                   and `status` = 'S'
SQL;
        $results = $this->query($query)->toArray();
        return isset($results[0]) ? $results[0]['total'] : 0;
    }

    public function generateFormTag($len=8) {
        $chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        $tag   = '';
        for ($i=0; $i<$len; $i++) {
            $tag .= substr($chars,rand(0,strlen($chars)-1),1);
        }
        return $tag;
    }
    
    /**
     * Will create a new form and populate a few fields based on the role of the person who created it
     * 
     * @return int
     */
    public function create() {
        $form_id = false;
        $user    = Argus::getEntity('argus/user/roles');
        $this->setTag($tag     = $this->generateFormTag());
        
        if ($user->userHasRole('O.D.')) {
            $form_id = $this->setFormType('screening')->setReviewer(Environment::whoAmI())->setSubmitted(date('Y-m-d H:i:s'))->setStatus('I')->setPc_2023f('Y')->setPc_S3000('Y')->save();            
        } else {
            $this->setFormType('scanning');
            if ($user->userHasRole('PCP Staff')) {
                //what was I doing here again?
            }
            $form_id = $this->save();
        }
        return $tag;
    }
    
    /**
     * A form has been marked to delete but we are going to save off a copy 
     * 
     * @param type $useFields
     */
    public function delete($useFields=false) {
        if ($tag = $this->getTag()) {
            $log = Argus::getEntity('vision/consultation/forms/log');           //we are going to preserve the data incase this was a mistaken delete
            foreach ($this->load(true) as $var => $val) {
                $method = 'set'.underscoreToCamelCase($var,true);
                $log->$method($val);
            }
            $log->save();
            parent::delete();
        }
    }
    
    /**
     * 
     * @return iterator
     */
    public function recap() {
        $event_clause       = $this->getEventId()       ? "and a.event_id = '".$this->getEventId()."' "         : "";
        $ipa_clause         = $this->getIpaId()         ? "and a.ipa_id = '".$this->getEventId()."' "           : "";
        $loc_clause         = $this->getLocationId()    ? "and a.location_id = '".$this->getLocationId()."' "   : "";
        $addr_clause        = $this->getAddressId()     ? "and a.address_id = '".$this->getAddressId()."' "     : "";
        $query = <<<SQL
            SELECT b.created_by, b.created, b.form_type, b.event_date,  b.technician, b.client_id, b.ipa_id, b.ipa_id_combo, b.location_id, b.location_id_combo, b.address_id, b.address_id_combo, b.npi_id, b.npi_id_combo, b.screening_client,
                 b.submitted, b.last_activity, b.last_action, b.reviewer, b.physician_npi, b.physician_npi_combo, b.`status`, b.claim_status, b.pcp_portal_withhold, b.member_name, b.member_unscannable, b.tag,
                 b.pc_s3000, b.pc_2022f, b.pc_g2102, b.pc_2022f_8p, b.pc_2023f, b.pc_5010f, b.pc_3072f, b.pc_92227, b.pc_2026f, b.pc_g2104, b.pc_2033f, b.referral, b.referred,
                 CONCAT(c.last_name,', ',c.first_name) AS technician_name, CONCAT(d.last_name,', ',d.first_name) AS reviewer_name
              from vision_consultation_forms AS b
              LEFT OUTER JOIN humble_user_identification AS c
                ON b.technician = c.id
              LEFT OUTER JOIN humble_user_identification AS d
                ON b.reviewer  = d.id
             WHERE a.event_id is not null
                {$event_clause}
                {$ipa_clause}
                {$loc_clause}
                {$addr_clause}
SQL;
        return $this->query($query);
    }
    
    /**
     * Plays a little game with the flexibility of a polyglot ORM.  Signatures are maintained on the mongo side
     * 
     */
    public function sign() {
        $user_id    = $this->getUserId();
        $role       = Argus::getEntity('argus/user_roles')->setUserId($user_id);
        $user       = Argus::getEntity('humble/user_identification')->setId($user_id)->load();
        $info       = Argus::getEntity('argus/user_information')->setUserId($user_id)->load(true);
        $client     = Argus::getEntity('vision/clients');
        $data       = $this->load();
        if ($role->userHasRole('O.D.')) {
            $license = ($info && isset($info['license_number'])) ? $info['license_number'] : 'On File';
            if (count($client = $client->setClient($data['screening_client'])->load(true))) {  //we check to make sure this is an active client, if not, we withhold until there's a manual freeing of the form when payment is received
                $this->setPcpPortalWithhold(($client['active']=='N')?'Y':'N');
            }
            $this->setDoctorHasSigned('Y');
            $this->setDoctor($user['last_name'].", ".$user['first_name'].' '.($user['credential'] && $user['credential']? ' '.$user['credential']:''));
            $this->setLicenseNumber($license);
            $this->setLastAction('O.D. Signed');
            $this->save();
            Argus::getModel('vision/members')->setFormId($this->getId())->closeGap();
        } else if ($role->userHasRole('PCP Staff')) {
            $this->setPcpStaffHasSigned('Y');
            $this->setPcpStaffMember($user['last_name'].", ".$user['first_name']);
            $this->setLastAction('Technician Signed');
            $this->setTechnician($user_id);
            $this->save();
        }
    }
    
    /**
     * Gets forms ready for claiming based on several criteria
     * 
     * @return iterator
     */
    public function availableClaims() {
        $event_clause   = ($this->getEventId())      ? "and a.event_id = '".$this->getEventId()."' " : "";
        $od_clause      = ($this->getProviderId())  ? "and a.reviewer = '".$this->getProviderId()."' " : "";
        $type_clause    = ($this->getType())         ? "and a.form_type ='".$this->getType()."' " : "";
        $member_clause  = ($this->getMemberNumber()) ? "and a.member_id = '".$this->getMemberNumber()."' " : "";
        $name_clause    = ($this->getMemberName())   ? "and a.member_name like '%".$this->getMemberName()."%' " : "";
        $client_clause  = ($this->getClientId())     ? "and a.client_id = '".$this->getClientId()."' " : "";
        $ipa_clause     = ($this->getIpaId())        ? "and a.ipa_id = '".$this->getIpaId()."' " : "";
        $status_clause  = ($this->getStatus())       ? "and b.verified = '".$this->getStatus()."' " : "";
        $claim_clause   = ($status_clause)           ? "and a.claim_status = 'Y'" : "and a.claim_status = 'N'";
        $query = <<<SQL
            select a.*, b.verified
              from vision_consultation_forms as a
              left outer join argus_claims as b
                on a.id = b.form_id
             where a.`status` = 'C'
               and a.member_unscannable != 'Y'
               
                {$claim_clause}
                {$event_clause}
                {$client_clause}
                {$od_clause}
                {$type_clause}
                {$member_clause}
                {$ipa_clause}
                {$name_clause}
                {$status_clause}
SQL;
        return $this->query($query);
    }
    
    /**
     * Returns the number of non-contracted forms that are awaiting to be invoiced
     * 
     * @param mixed $year
     * @return type
     */
    public function noncontractedClaimsAvailable($year=false) {
        $year        = ($year) ? $year : ($this->getYear() ? $this->getYear() : false);
        $year_clause = $year ? "AND event_date BETWEEN '".$year."-01-01' AND '".$year."-12-31'" : "";
        
        $query       = <<<SQL
            SELECT COUNT(id) AS tot
              FROM vision_consultation_forms 
             WHERE client_id NOT IN (SELECT id FROM vision_clients WHERE ACTIVE = 'Y')
               AND claim_status != 'Y' 
               AND pcp_portal_withhold = 'Y'
               AND `status` IN ('A','C')
               {$year_clause}
               AND member_unscannable != 'Y'               
               AND id NOT IN (SELECT form_id FROM vision_invoice_forms)                
SQL;
        $result = $this->query($query)->toArray();
        return isset($result[0]) ? $result[0]['tot'] : 0;
    }
    
    /**
     * Returns the number of contracted forms that are ready to be batched and claimed
     * 
     * @return int
     */
    public function claims() {
        $query = <<<SQL
       SELECT COUNT(*) AS available 
         FROM vision_consultation_forms
        WHERE claim_status = 'N'
          AND `status` = 'C'
          AND client_id IN (SELECT id FROM vision_clients WHERE ACTIVE = 'Y') 
          and member_unscannable != 'Y'
SQL;
        $results = $this->query($query)->toArray();
        return isset($results[0]['available']) ? $results[0]['available'] : 0;
    }
    
    /**
     * Returns a list of events that have forms that haven't been claimed yet
     * 
     * @return type
     */
    public function activeEvents() {
        $query = <<<SQL
        select distinct event_id
          from vision_consultation_forms
         where event_id is not null
           and `status`  = 'C'
           and claim_status = 'N'
         order by event_id
SQL;
        return $this->with('scheduler/events')->on('event_id')->query($query);
    }
    
    
    /**
     * Returns the list of non contracted patients who have not been released yet
     * 
     * @return type
     */
    public function nonContractedMembers() {
        $query = <<<SQL
            SELECT * FROM vision_consultation_forms
             WHERE client_id IN (SELECT id FROM vision_clients WHERE active = 'N')
               AND pcp_portal_withhold ='Y'
SQL;
        return $this->query($query);
    }
    
    /**
     * Gets those members who are non-contracted and tries to group them together in reasonable manner
     * 
     * @return array
     */
    public function availableInvoices() {
        $year        = $this->getYear() ? $this->getYear() : false;
        $year_clause = ($year) ? " and event_date between '".$year."-01-01' and '".$year."-12-31' " : "";
        $candidates = [];
        $query = <<<SQL
            SELECT DISTINCT UPPER(ipa_id_combo) as ipa, UPPER(location_id_combo) as location, location_id, UPPER(address_id_combo) as address, member_id, member_name, screening_client, id, id as form_id, event_date
              FROM vision_consultation_forms
             WHERE client_id NOT IN (SELECT id FROM vision_clients WHERE active = 'Y')
               AND pcp_portal_withhold = 'Y'
               AND `status` IN ('A','C')
               AND id not in (select form_id from vision_invoice_forms)
               {$year_clause}
             ORDER BY ipa, address
SQL;
        $cnt = count($invoices = $this->query($query)->toArray());
        foreach ($invoices as $idx => $invoice) {
            if ($invoices[$idx]['address']) {
                $candidates[$invoice['address']] = [$invoice];
                $counter = 0;
                for ($i=$idx+1; $i<$cnt; $i++) {
                    $compare = similar_text($invoice['address'],$invoices[$i]['address'],$percent);
                    if ($percent > 85) {
                        $candidates[$invoice['address']][] = $invoices[$i];
                        $invoices[$i]['address'] = false;
                    }
                    if (++$counter > 100) {
                        break;
                    }
                }
            }
        }
        return $candidates;
    }
    
    /**
     * Retrieves graphable information about technicians
     * 
     * @param type $user_id
     * @param type $year
     * @return type
     */
    protected function technicianData($user_id=false,$year=false) {
        $result = [];
        if ($user_id = ($user_id) ? ($user_id) : ($this->getUserId() ? $this->getUserId() : Environment::whoAmI())) {
            $year_clause = ($year) ? "and a.created >= '".$year."-01-01' and a.created <= '".$year."-12-31'"  : "";
            $query = <<<SQL
                SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.event_date, a.tag,
                       b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender, a.form_type, a.status, a.claim_status, a.screening_client, a.modified,
                       concat(c.first_name,' ',c.last_name) as technician_name, a.last_action, a.address_id, a.phonetic_token1, a.phonetic_token2, a.reviewer, concat(d.first_name,' ',d.last_name) as reviewer_name, 
                       a.pcp_portal_withhold
                 FROM vision_consultation_forms AS a
                 LEFT OUTER JOIN humble_user_identification AS b
                   ON a.created_by = b.id
                 left outer join humble_user_identification as c
                   on a.technician = c.id           
                 left outer join humble_user_identification as d
                   on a.reviewer = d.id
                where a.technician = '{$user_id}' 
                  and a.`status` in ('S','C','A','I')
                  {$year_clause}   
SQL;
            $result = $this->query($query);
        }
        return $result;
    }
                  
    public function technicianFormsByHealthPlan() {
        $health_plans = [];
        if ($data = $this->technicianData()) {
            foreach ($data as $form) {
                if (isset($health_plans[$form['screening_client']])) {
                    $health_plans[$form['screening_client']]['total']++;
                } else {
                    $health_plans[$form['screening_client']] = array_merge([
                        'total'     => 1,
                        'name'      => $form['screening_client']
                    ],$this->graphColor());
                }
            }
        }
        return $health_plans;        
    }

    public function technicianFormsByPhysician() {
        $physicians = [];
        if ($data = $this->technicianData()) {
            foreach ($data as $form) {
                if (isset($form['primary_doctor'])) {
                    if (isset($physicians[$form['primary_doctor']])) {
                        $physicians[$form['primary_doctor']]['total']++;
                    } else {
                        $physicians[$form['primary_doctor']] = array_merge([
                            'total'     => 1,
                            'name'      => $form['primary_doctor']
                        ],$this->graphColor());
                    }
                }
            }
        }
        return $physicians;            
    }
    
    public function technicianReadableForms() {
        $data = ['readable'=>0,'nonreadable'=>0];
        if ($forms = $this->technicianData()) {
            foreach ($forms as $form) {
                if (isset($form['images_unreadable']) && (strtoupper($form['images_unreadable'])=='Y')) {
                    ++$data['nonreadable'];
                } else {
                    ++$data['readable'];
                }
            }
        }
        return $data;        
    }
    
    protected function formsByMonthData($year=false,$type=false) {
        $result = [];
        if ($user_id = ($user_id) ? ($user_id) : ($this->getUserId() ? $this->getUserId() : Environment::whoAmI())) {
            $year_clause = ($year) ? "and a.created >= '".$year."-01-01' and a.created <= '".$year."-12-31'"  : "";
            $query = <<<SQL
                SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.event_date, a.tag,
                       b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender, a.form_type, a.status, a.claim_status, a.screening_client, a.modified,
                       concat(c.first_name,' ',c.last_name) as technician_name, a.last_action, a.address_id, a.phonetic_token1, a.phonetic_token2, a.reviewer, concat(d.first_name,' ',d.last_name) as reviewer_name, 
                       a.pcp_portal_withhold
                 FROM vision_consultation_forms AS a
                 LEFT OUTER JOIN humble_user_identification AS b
                   ON a.created_by = b.id
                 left outer join humble_user_identification as c
                   on a.technician = c.id           
                 left outer join humble_user_identification as d
                   on a.reviewer = d.id
                where a.technician = '{$user_id}' 
                  and a.`status` in ('S','C','A','I')
                  {$year_clause}   
SQL;
            $result = $this->query($query);
        }
        return $result;
    }    
    
    /**
     * Constructs the data for the chart that shows number of forms submitted by technician by month
     * 
     * @return array
     */
    public function technicianFormsByMonth() {
        $values = [0=>0,1=>0,2=>0,3=>0,4=>0,5=>0,6=>0,7=>0,8=>0,9=>0,10=>0,11=>0];
        $labels = ['January','February','March','April','May','June','July','August','September','October','November','December'];
        //if ($data = $this->technicianData(false,date('Y'))) {
        if ($data = $this->technicianData(false,false)) {
            foreach ($data as $form) {
                $d = explode('-',$form['created']);
                $values[(int)$d[1]-1]++;
            }   
        }
        return ['values'=>$values,'labels'=>$labels];        
    }
    
    /**
     * Gets the data for various charts to display based on the type of forms we have processed by month
     * 
     * @param int $year
     * @param string $type
     * @return array
     */
    public function formsByMonth($year=false,$type='Scanning') {
        $values = [0=>0,1=>0,2=>0,3=>0,4=>0,5=>0,6=>0,7=>0,8=>0,9=>0,10=>0,11=>0];
        $labels = ['January','February','March','April','May','June','July','August','September','October','November','December'];
        $year   = $year ? $year : date('Y');
        $query = <<<SQL
                SELECT MONTH(event_date) AS 'Month', COUNT(*) AS total
                  FROM vision_consultation_forms AS a
                 WHERE YEAR(event_date) = '{$year}'
                   AND a.`status` IN ('S','C','A','I','R')
                   AND a.form_type = '{$type}'
                 GROUP BY MONTH(event_date)
SQL;
        foreach ($results = $this->query($query) as $row) {
            $values[$row['Month']-1] = $row['total'];
        }
        return ['values'=>$values,'labels'=>$labels];        
    }
    
    public function pcpTechCompletedForms($tech_id=false) {
        $results = [];
        if ($tech_id = ($tech_id) ? $tech_id : Environment::whoAmI()) {
            $query = <<<SQL
                    select a.*, concat('Dr. ',b.first_name,' ',b.last_name) as reviewer_name
                      from vision_consultation_forms as a
                      left outer join humble_user_identification as b
                        on a.reviewer = b.id
                     where a.technician = '{$tech_id}'
                       and a.`status` = 'C'
SQL;
            $results = $this->query($query);
        }
        return $results;
    }
    /**
     * 
     * 
     * @return iterator
     */
    public function ipaForms() {
        $results = [];
        if ($user_id = Environment::whoAmI()) {
            if (count($data = Argus::getEntity('vision/ipas')->setUserId($user_id)->load(true))) {
                $ipa_id = $data['id'];
                $group_clause = "";
                //now check to see if IPA is in a group, if so, get all the other group IDS to reference
                if (count($group = Argus::getEntity('vision/ipa/group/members')->setIpaId($ipa_id)->load(true))) {
                    $group_clause = "or a.ipa_id in (select ipa_id from vision_ipa_group_members where group_id = '".$group['group_id']."')";
                }
                $query = <<<SQL
                SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.event_date, a.modified,
                       b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender, a.tag,
                        a.status, a.claim_status, a.screening_client, 
                       concat(c.first_name,' ',c.last_name) as technician_name, a.last_action, a.address_id, a.phonetic_token1, a.phonetic_token2, a.reviewer, concat(d.first_name,' ',d.last_name) as reviewer_name, 
                       a.pcp_portal_withhold, a.ipa_id_combo, a.address_id_combo, a.location_id_combo, a.modified, a.physician_npi, a.physician_npi_combo, a.member_unscannable
                 FROM vision_consultation_forms AS a
                 LEFT OUTER JOIN humble_user_identification AS b
                   ON a.created_by = b.id
                 left outer join humble_user_identification as c
                   on a.technician = c.id           
                 left outer join humble_user_identification as d
                   on a.reviewer = d.id
                where (a.ipa_id = '{$ipa_id}' {$group_clause})
                  and a.`status` = 'C'
SQL;
                $results = $this->_normalize(true)->query($query);
               // file_put_contents('ipa_forms.txt',print_r($results->toArray(),true));
            }
        }
        return $results;
    }
    
    /**
     * Gets the unique PCPs at an IPA 
     * 
     * @return array
     */
    public function ipaPhysicians() {
        $results = [];
        if ($ipa_id = $this->getIpaId()) {
            $query = <<<SQL
               select distinct physician_npi_combo as npi, id
                 from vision_consultation_forms
                where ipa_id = '{$ipa_id}'
SQL;
            $xref = [];
            foreach ($this->query($query) as $pcp) {
                if (!isset($xref[$pcp['npi']])) {
                    $xref[$pcp['npi']] = isset($pcp['primary_doctor_combo']) ? $pcp['primary_doctor_combo'] : '';
                }
            }
            asort($xref);
            foreach ($xref as $npi => $name) {
                $results[] = ['npi' => $npi, 'name' => $name];
            }
        }
        return $results;
    }

    /**
     * Gets a list of health plans that an IPA deals with
     * 
     * @return type
     */    
    public function ipaHealthPlans() {
        $results = [];
        if ($ipa_id = $this->getIpaId()) {
            $query = <<<SQL
               select distinct a.client_id, b.client 
                 from vision_consultation_forms as a
                 left outer join vision_clients as b
                   on a.client_id = b.id
                where a.ipa_id = '{$ipa_id}'
                order by b.client
SQL;
            $results = $this->query($query);
        }
        return $results;
        
    }
    
    /**
     * 
     * 
     * @return iterator
     */
    public function sortedIpaForms() {
        $results = [];
        if ($user_id = Environment::whoAmI()) {
            if (count($data = Argus::getEntity('vision/ipas')->setUserId($user_id)->load(true))) {
                $ipa_id = $data['id'];
                $group_clause = "";
                //now check to see if IPA is in a group, if so, get all the other group IDS to reference
                if (count($group = Argus::getEntity('vision/ipa/group/members')->setIpaId($ipa_id)->load(true))) {
                    $group_clause = "or a.ipa_id in (select ipa_id from vision_ipa_group_members where group_id = '".$group['group_id']."')";
                }
                $physician_clause   = $this->getPhysicianNpi() ? " and a.physician_npi_combo = '".$this->getPhysicianNpi()."' " : "";
                $health_plan_clause = $this->getHealthPlan() ? " and a.client_id = '".$this->getHealthPlan()."' " : "";
                $query = <<<SQL
                SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.event_date, a.modified,
                       b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender,
                       concat(UCASE(LEFT(a.form_type, 1)),SUBSTRING(a.form_type, 2)) as form_type,
                       a.status, a.claim_status, a.screening_client, 
                       concat(c.first_name,' ',c.last_name) as technician_name, a.last_action, a.address_id, a.phonetic_token1, a.phonetic_token2, a.reviewer, concat(d.first_name,' ',d.last_name) as reviewer_name, 
                       a.pcp_portal_withhold, a.ipa_id_combo, a.address_id_combo, a.location_id_combo, a.modified, a.physician_npi, a.physician_npi_combo, a.member_unscannable, a.tag
                 FROM vision_consultation_forms AS a
                 LEFT OUTER JOIN humble_user_identification AS b
                   ON a.created_by = b.id
                 left outer join humble_user_identification as c
                   on a.technician = c.id           
                 left outer join humble_user_identification as d
                   on a.reviewer = d.id
                where (a.ipa_id = '{$ipa_id}' {$group_clause})
                  and a.`status` = 'C'
                {$physician_clause}
                {$health_plan_clause}
                order by a.event_date DESC
SQL;
                $results = $this->_normalize(true)->query($query);
            }
        }
        return $results;
    }  
    
    
    /**
     * 
     * 
     * @return iterator
     */
    public function sortedLocationForms() {
        $results = [];
        if ($user_id = Environment::whoAmI()) {
            if (count($data = Argus::getEntity('vision/ipa/locations')->setUserId($user_id)->load(true))) {
                $location_id = $data['id'];
                $group_clause = "";
                //now check to see if IPA is in a group, if so, get all the other group IDS to reference
                $physician_clause   = $this->getPhysicianNpi() ? " and a.physician_npi_combo = '".$this->getPhysicianNpi()."' " : "";
                $health_plan_clause = $this->getHealthPlan() ? " and a.client_id = '".$this->getHealthPlan()."' " : "";
                $query = <<<SQL
                SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.event_date, a.modified,
                       b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender,
                       concat(UCASE(LEFT(a.form_type, 1)),SUBSTRING(a.form_type, 2)) as form_type,
                       a.status, a.claim_status, a.screening_client, 
                       concat(c.first_name,' ',c.last_name) as technician_name, a.last_action, a.address_id, a.phonetic_token1, a.phonetic_token2, a.reviewer, concat(d.first_name,' ',d.last_name) as reviewer_name, 
                       a.pcp_portal_withhold, a.ipa_id_combo, a.address_id_combo, a.location_id_combo, a.modified, a.physician_npi, a.physician_npi_combo, a.member_unscannable, a.tag
                 FROM vision_consultation_forms AS a
                 LEFT OUTER JOIN humble_user_identification AS b
                   ON a.created_by = b.id
                 left outer join humble_user_identification as c
                   on a.technician = c.id           
                 left outer join humble_user_identification as d
                   on a.reviewer = d.id
                where (a.location_id = '{$location_id}')
                  and a.`status` = 'C'
                {$physician_clause}
                {$health_plan_clause}
                order by a.event_date DESC
SQL;
                $results = $this->_normalize(true)->query($query);
            }
        }
        return $results;
    }        
    
    /**
     * List of screenings and scannings by client per IPA
     * 
     * @return JSON
     */
    public function ipaClientForms() {
        $results = [];
        foreach ($this->ipaForms() as $form) {
            $form['location_id_combo'] = isset($form['location_id_combo']) ? $form['location_id_combo'] : 'N/A';
            if (isset($form['location_id_combo'])) {
                $form['location_id_combo'] = ($form['location_id_combo']) ? $form['location_id_combo'] : "N/A";
                if (!isset($results[$form['location_id_combo']])) {
                    $results[$form['location_id_combo']] = [];
                    $results[$form['location_id_combo']]['rows'] = [];
                }
                $results[$form['location_id_combo']]['rows'][] = $form;
            }
        }
        return json_encode($results);
    }

    /**
     * List of screenings and scannings by PCP per IPA
     * 
     * @return JSON
     */
    public function ipaPhysicianForms() {
        $results = [];
        foreach ($this->ipaForms() as $form) {
            if (isset($form['physician_npi_combo']) && $form['physician_npi_combo']) {
                if (!isset($results[$form['physician_npi_combo']])) {
                    $results[$form['physician_npi_combo']] = [];
                    $results[$form['physician_npi_combo']]['rows'] = [];
                }
                $results[$form['physician_npi_combo']]['pcp'] = isset($form['primary_doctor']) ? $form['primary_doctor'] : '';
                $results[$form['physician_npi_combo']]['rows'][] = $form;
            }
        }
        return json_encode($results);    
    }
    
    /**
     * 
     * 
     * @return iterator
     */
    public function odScreeningForms() {
        $uid = Environment::whoAmI();
        $open_clause = Argus::getEntity('argus/user_roles')->setUserId($uid)->userHasRole('HEDIS Vision Manager') ? "or a.reviewer is null" : "";
        $query = <<<SQL
            SELECT a.*, a.id as form_id, 
                   b.start_date, b.start_time, b.end_date, b.end_time,
                   CONCAT(c.last_name,", ",c.first_name) AS creator_name,
                   CONCAT(d.last_name,", ",d.first_name) AS technician_name
              FROM vision_consultation_forms AS a
              LEFT OUTER JOIN scheduler_events AS b
                ON a.event_id = b.id
              LEFT OUTER JOIN humble_user_identification AS c
                ON a.created_by = c.id
              LEFT OUTER JOIN humble_user_identification AS d
                ON a.technician = d.id
             WHERE (a.created_by = '{$uid}' OR a.reviewer = '{$uid}' {$open_clause} )
               AND a.`status` = 'S' 
               AND a.form_type = 'screening'
             order by a.event_date, a.event_time
SQL;
        return $this->query($query);
    }
    
    public function odScanningForms() {
        $uid = Environment::whoAmI();
        $open_clause = Argus::getEntity('argus/user_roles')->setUserId($uid)->userHasRole('HEDIS Vision Manager') ? "or a.reviewer is null" : "";
        $query = <<<SQL
            SELECT a.*, a.id as form_id, 
                   b.start_date, b.start_time, b.end_date, b.end_time,
                   CONCAT(c.last_name,", ",c.first_name) AS creator_name,
                   CONCAT(d.last_name,", ",d.first_name) AS technician_name
              FROM vision_consultation_forms AS a
              LEFT OUTER JOIN scheduler_events AS b
                ON a.event_id   = b.id
              LEFT OUTER JOIN humble_user_identification AS c
                ON a.created_by = c.id
              LEFT OUTER JOIN humble_user_identification AS d
                ON a.technician = d.id
             WHERE (a.created_by = '{$uid}' OR a.reviewer = '{$uid}' {$open_clause})
               AND a.`status` = 'S' 
               AND a.form_type = 'scanning'
             order by a.event_date, a.event_time
SQL;
        return $this->query($query);        
    }
    
    public function odStagingForms() {
        $uid = Environment::whoAmI();
        $query = <<<SQL
            SELECT a.*, a.id as form_id,
                   b.start_date, b.start_time, b.end_date, b.end_time,
                   CONCAT(c.last_name,", ",c.first_name) AS creator_name,
                   CONCAT(d.last_name,", ",d.first_name) AS technician_name
              FROM vision_consultation_forms AS a
              LEFT OUTER JOIN scheduler_events AS b
                ON a.event_id = b.id
              LEFT OUTER JOIN humble_user_identification AS c
                ON a.created_by = c.id
              LEFT OUTER JOIN humble_user_identification AS d
                ON a.technician = d.id
             WHERE (a.created_by = '{$uid}' OR a.reviewer = '{$uid}')
               AND (a.`status` in ('I','N')) 
             order by event_time
SQL;
        return $this->query($query);        
    }
    /**
     * Gets the screening forms 
     * 
     * @return type
     */
    public function screeningFormsByPCP($status='C',$year=false) {
        $results = json_encode([]);
        if ($this->getUserId() && !$this->getNpi()) {
            $user_id = $this->getUserId() ? $this->getUserId() : Environment::whoAmI();
            if (count($pcp = Argus::getEntity('argus/primary_care_physicians')->setUserId($user_id)->load(true))) {
                $this->setNpi($pcp['npi']);
            }
        }
        $status_clause = ($status)  ? "and a.`status` = '".$status."'" : "";
        $year_clause   = ($year)    ? "and (a.event_date >= '".$year."-01-01' and a.event_date <= '".$year."-12-31')": "";
        if ($npi = $this->getNpi() ? $this->getNpi() : ($this->getPhysicianNpi() ? $this->getPhysicianNpi() : false)) {
            $query = <<<SQL
                SELECT 	distinct a.*,c.npi, c.user_id AS physician_user_id, c.first_name AS physician_first_name, c.last_name AS physician_last_name, c.address AS physician_address
                  FROM vision_consultation_forms AS a
                  LEFT OUTER JOIN argus_primary_care_physicians AS c
                    ON a.physician_npi_combo = c.npi
                  left outer join vision_gaps as g
                    on a.member_id = g.mem_id
                 WHERE a.physician_npi_combo = '{$npi}'   
                   AND a.pcp_portal_withhold = 'N'
                   {$status_clause}
                   {$year_clause}
SQL;
            $results = $this->normalize($this->query($query));
        }
        return $results;
    }
    
    /**
     * Will assume that the passed in user id, or the id of the person logged on, is also a PCP and fetch their information
     * 
     * @param int $user_id
     * @return array
     */
    protected function primaryCarePhysicianData($user_id = false) {
        $data = [];
        if ($user_id = $user_id ? $user_id : Environment::whoAmI()) {
            $data = Argus::getEntity('argus/primary_care_physicians')->setUserId($user_id)->load(true);
        }
        return $data;
    }
    
    /**
     * Gets a PCPs current inventory of screening forms and then manually counts how many are marked illegible
     * 
     * @return array
     */
    public function calculateReadableForms() {
        $data = ['readable'=>0,'nonreadable'=>0];
        if ($pcp = $this->primaryCarePhysicianData()) {
            if (isset($pcp['npi']) && $pcp['npi']) {
                $this->setNpi($pcp['npi']);
                foreach ($this->screeningFormsByPCP() as $form) {
                    if (isset($form['images_unreadable']) && (strtoupper($form['images_unreadable'])=='Y')) {
                        ++$data['nonreadable'];
                    } else {
                        ++$data['readable'];
                    }
                }
            }
        }
        return $data;
    }

    /**
     * Returns completed and signed forms relevant to respective PCPs for a given date period
     * 
     * @param type $state_date
     * @param type $end_date
     * @return type
     */
    public function PCPFormsBetweenDates($state_date=false,$end_date=false) {
        $results    = [];
        $start_date = $start_date ? $start_date : $this->getStartDate();
        $end_date   = $end_date   ? $end_date   : $this->getEndDate();
        if ($start_date && $end_date) {
            $query = <<<SQL
                SELECT a.id, a.screening_client, a.event_date, a.ipa_id_combo, a.location_id_combo, a.address_id_combo, a.member_name, a.member_id, a.tag
                       b.user_id, b.npi, b.first_name, b.last_name,
                       c.email
                  FROM vision_consultation_forms AS a
                  LEFT OUTER JOIN argus_primary_care_physicians AS b
                    ON a.physician_npi_combo = b.npi 
                  LEFT OUTER JOIN humble_users AS c
                    ON b.user_id = c.uid
                 WHERE `status` = 'C'
                   AND a.last_action = 'O.D. Signed'
                   AND a.last_activity >= '{$start_date} 00:00:00'
                   AND a.last_activity <= '{$end_date} 00:00:00'
                 ORDER BY b.npi
SQL;
            $results = $this->query($query);
        }
        return $results;
    }
    
    /**
     * A gap closed is a completed form based on some given criteria, this calculates the number of gaps closed by PCP
     * 
     * @return array
     */
    public function calculateGapsClosed() {
        $data = ['closed'=>0,'open'=>0];
        if ($pcp = $this->primaryCarePhysicianData()) {
            if (isset($pcp['npi']) && $pcp['npi']) {
                $this->setNpi($pcp['npi']);
                foreach ($this->screeningFormsByPCP(false) as $form) {
                    if (isset($form['gap_closed']) && $form['gap_closed']) {
                        ++$data['closed'];
                    } else {
                        ++$data['open'];
                    }
                }
            }
        }
        return $data;        
    }
    
    /**
     * Calculates a random color and highlight for graphing purposes
     * 
     * @return type
     */
    protected function graphColor() {
        $rh = ($r = random_int(50,210)) + 20;
        $gh = ($g = random_int(50,210)) + 20;
        $bh = ($b = random_int(50,210)) + 20;
        return [
            'color' => '#'.dechex($r).''.dechex($g).''.dechex($b),
            'highlight' => '#'.dechex($rh).''.dechex($gh).''.dechex($bh)
        ];
    }
    
    /**
     * Calculates how many screening forms have come in by health plan
     * 
     * @return type
     */
    public function screeningsByHealthPlan() {
        $health_plans = [];
        if ($pcp = $this->primaryCarePhysicianData()) {
            if (isset($pcp['npi']) && $pcp['npi']) {
                $this->setNpi($pcp['npi']);
                foreach ($this->screeningFormsByPCP() as $form) {
                    if (isset($health_plans[$form['screening_client']])) {
                        $health_plans[$form['screening_client']]['total']++;
                    } else {
                        $health_plans[$form['screening_client']] = array_merge([
                            'total'     => 1,
                            'name'      => $form['screening_client']
                        ],$this->graphColor());
                    }
                }
            }
        }
        return $health_plans;
    }
    
    /**
     * Provides the data for the screenings by month pie chart
     * 
     * @return array
     */
    public function screeningsByMonth() {
        $values = [0=>0,1=>0,2=>0,3=>0,4=>0,5=>0,6=>0,7=>0,8=>0,9=>0,10=>0,11=>0];
        $labels = ['January','February','March','April','May','June','July','August','September','October','November','December'];
        if ($pcp = $this->primaryCarePhysicianData()) {
            if (isset($pcp['npi']) && $pcp['npi']) {
                $this->setNpi($pcp['npi']);
                $year = ($this->getYear() ? $this->getYear() :date('Y'));
                foreach ($this->screeningFormsByPCP(false,($this->getYear() ? $this->getYear() : date('Y'))) as $form) {
                    $d = explode('-',$form['created']);
                    $values[(int)$d[1]-1]++;
                }   
            }
        }
        return ['values'=>$values,'labels'=>$labels];
    }

    /**
     * Report that shows when gaps were closed
     * 
     * @return array
     */
    public function gapsClosedReport() {
        $report = ['Closed'=>[],'Open'=>[]];
        if ($pcp = $this->primaryCarePhysicianData()) {
            if (isset($pcp['npi']) && $pcp['npi']) {
                $this->setNpi($pcp['npi']);
                foreach ($this->screeningFormsByPCP(false,($this->getYear() ? $this->getYear() : date('Y'))) as $form) {
                    if (isset($form['gap_closed']) && $form['gap_closed']) {
                        $report['Closed'][] = $form;
                    } else {
                        $report['Open'][]   = $form;
                    }                    
                }   
            }
        }
        return $report;
    }
    
    /**
     * Report that shows which members had unreadable screenings
     * 
     * @return array
     */
    public function readableFormsReport() {
        $report = ['Readable'=>[],'Non-Readable'=>[]];
        if ($pcp = $this->primaryCarePhysicianData()) {
            if (isset($pcp['npi']) && $pcp['npi']) {
                $this->setNpi($pcp['npi']);
                foreach ($this->screeningFormsByPCP(false,($this->getYear() ? $this->getYear() : date('Y'))) as $form) {
                    if (isset($form['images_unreadable']) && (strtoupper($form['images_unreadable'])=='Y')) {
                        $report['Non-Readable'][] = $form;
                    } else {
                        $report['Readable'][] = $form;
                    }
                }   
            }
        }
        return $report;
    }
    
    /**
     * Breaks down screening forms by health plan they were associated to
     * 
     * @return array
     */
    public function healthPlansReport() {
        $report = [];
        if ($pcp = $this->primaryCarePhysicianData()) {
            if (isset($pcp['npi']) && $pcp['npi']) {
                $this->setNpi($pcp['npi']);
                $year = ($this->getYear() ? $this->getYear() :date('Y'));
                foreach ($this->screeningFormsByPCP(false,$year) as $form) {
                    if (!isset($report[$form['screening_client']])) {
                        $report[$form['screening_client']] = [];
                    }
                    $report[$form['screening_client']][] = $form;
                }   
            }
        }
        return $report;
    }  
    
    /**
     * 
     * 
     * @return array
     */
    public function monthlyScreeningsReport() {
        $labels = ['January','February','March','April','May','June','July','August','September','October','November','December'];
        $report = [];
        if ($pcp = $this->primaryCarePhysicianData()) {
            if (isset($pcp['npi']) && $pcp['npi']) {
                $this->setNpi($pcp['npi']);
                foreach ($this->screeningFormsByPCP(false,date('Y')) as $form) {
                    $d = explode('-',$form['created']);
                    if (!isset($report[$labels[(int)$d[1]-1]])) {
                        $report[$labels[(int)$d[1]-1]] = []; 
                    }
                    $report[$labels[(int)$d[1]-1]][] = $form;
                }   
            }
        }
        return $report;
    }
    
    /**
     * Gets all the extended data associated to a screening form
     * 
     * @return type
     */
    public function data() {
        $results    = [];
        $form_data  = $this->load(true);
        if ($id = $this->getId() ? $this->getId() : ($this->getFormId() ? $this->getFormId() : false)) {
            $query  = <<<SQL
                SELECT a.*
#                    b.first_name, b.last_name, b.gender, b.phonetic_token_1, b.phonetic_token_2, b.gap_closed,
#                   c.relation_id,
#                    concat(d.first_name,' ',d.last_name) primary_doctor, d.user_id AS pcp_user_id, d.address AS pcp_address, d.fax AS pcp_fax
                  FROM vision_consultation_forms AS a
#                  LEFT OUTER JOIN vision_members AS b
#                    ON a.member_id = b.member_number
#                   AND b.health_plan_id = (SELECT id FROM vision_clients WHERE `client` = '{$form_data['screening_client']}')
#                  LEFT OUTER JOIN argus_relationship_dates AS c
#                    ON b.id = c.member_id
#                   AND c.relationship_type = (SELECT id FROM argus_relationship_types WHERE relationship = 'PCP')
#                   AND (c.effective_start_date <= NOW() AND (c.effective_end_date > NOW() OR c.effective_end_date IS NULL))
#                  LEFT OUTER JOIN argus_primary_care_physicians AS d
#                    ON c.relation_id = d.id
                 WHERE a.tag = '{$tag}'    
SQL;
           $results = $this->with('vision/consultation/forms')->on('id')->query($query)->toArray();
        }
        return $form_data;
    }
    
    /**
     * Fetches data on current workloads (active) for vision retina consultations
     * 
     * @return iterator
     */
    public function workloads() {
        $query = <<<SQL
            SELECT COALESCE(b.last_name,'Unassigned') AS label, a.total AS 'value'
              FROM (SELECT reviewer, COUNT(*) AS total 
                     FROM vision_consultation_forms
                    WHERE reviewer IS NULL OR reviewer IN (SELECT user_id FROM argus_user_roles WHERE role_id = '13')
                      AND `status` IN ('S','I')
                    GROUP BY reviewer) AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.reviewer = b.id
             ORDER BY last_name            
SQL;
        $data = [
            "labels" => [],
            "values" => []
        ];
        foreach ($this->query($query) as $screening) {
            $data['labels'][] = $screening['label'];
            $data['values'][] = $screening['value'];
        }
        return $data;
    }
    
    /**
     * The first person with a role of O.D. gets assigned as the default reviewer
     * 
     * @param int $form_id
     * @param int $user_id
     */
    public function placeInReview($form_id=false,$user_id=false) {
        $form    = Argus::getEntity('vision/consultation/forms')->setId(($form_id) ? $form_id : $this->getId())->setStatus(VISION_PACKET_IN_REVIEW)->setLastActivity(date('Y-m-d H:i:s'))->setLastAction('Reviewer Assigned')->setReviewer(($user_id) ? $user_id :  Environment::whoAmI())->save();
    }
    
    /**
     * Adds the image for the person, or a placeholder if none is available
     * 
     * @return JSON
     */    
    public function addAvatars($dataset) {
        $rows = [];
        foreach ($dataset->toArray() as $row) {
            $row['avatar'] = (file_exists('../images/argus/avatars/tn/'.$row['created_by'].'.jpg')) ? "/images/argus/avatars/tn/".$row['created_by'].'.jpg' : "/images/argus/placeholder-".($row['creator_gender']??'').'.png';
            $rows[] = $row;
        }
        return json_encode(unserialize(str_replace(['NAN;','INF;'],'0;',serialize($rows))));
    }
    
    /**
     * Returns a dataset of vision packets that have been signed by the O.D.
     * 
     * @return iterator
     */    
    public function signedVisionPackets() {
        $year = date('Y').'-01-01';
        $query = <<<SQL
             SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.tag,
                    b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender,
                    concat(c.first_name,' ',c.last_name) as technician_name, a.last_action, a.event_date, a.address_id, a.address_id_combo
              FROM vision_consultation_forms AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.created_by = b.id
              left outer join humble_user_identification as c
                on a.technician = c.id                    
             where status = 'C'
               and a.event_date >= '{$year}'
SQL;
        return $this->addAvatars($this->query($query));    
    }
    
    /**
     * Returns a list of forms that haven't been assigned a reviewer yet
     * 
     * @return iterator
     */    
    public function unassignedConsultationForms() {
        $query = <<<SQL
             SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.tag,
                    b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender,
                    concat(c.first_name,' ',c.last_name) as technician_name, a.last_action, a.event_date, a.address_id, a.address_id_combo
              FROM vision_consultation_forms AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.created_by = b.id
              left outer join humble_user_identification as c
                on a.technician = c.id
              left outer join scheduler_events as d
                on a.event_id = d.id
             where status = 'A'
               and technician is null
             order by a.created asc
SQL;
        $results = $this->with('vision/consultation/forms')->query($query);
        return $results;
    }
    
    /**
     * Returns a dataset of vision packets that have been archived
     * 
     * @return iterator
     */    
    public function archivedVisionPackets() {
        $year = date('Y').'-01-01';
        $query = <<<SQL
             SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.tag,
                    b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender,
                    concat(c.first_name,' ',c.last_name) as technician_name, a.last_action, a.address_id, a.address_id_combo
              FROM vision_consultation_forms AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.created_by = b.id
              left outer join humble_user_identification as c
                on a.technician = c.id                    
             where status = 'C'
               and a.event_date < '{$year}'
SQL;
        return $this->addAvatars($this->query($query));        
    }
    
    /**
     * Returns a dataset of vision packets the current user has created but not submitted
     * 
     * @return iterator
     */
    public function stagingVisionPackets() {
        $user_id = ($this->getUserId())? $this->getUserId() : Environment::whoAmI();
        if (Argus::getEntity('argus/user_roles')->userHasRole('O.D.')) {
            $query = <<<SQL
                SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.event_date, a.event_time, a.tag,
                        b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender,
                        concat(c.first_name,' ',c.last_name) as technician_name, a.last_action, a.address_id, a.address_id_combo
                  FROM vision_consultation_forms AS a
                  LEFT OUTER JOIN humble_user_identification AS b
                    ON a.created_by = b.id
                  left outer join humble_user_identification as c
                    on a.technician = c.id
                 where (reviewer = '{$user_id}' and status = 'I')
                 or (created_by = '{$user_id}' and status in ('N')) 
                 order by a.modified desc
SQL;
        } else {
            $query = <<<SQL
                SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.tag,
                        b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender,
                        concat(c.first_name,' ',c.last_name) as technician_name, a.last_action, a.address_id, a.address_id_combo
                  FROM vision_consultation_forms AS a
                  LEFT OUTER JOIN humble_user_identification AS b
                    ON a.created_by = b.id
                  left outer join humble_user_identification as c
                    on a.technician = c.id                    
                 where (created_by = '{$user_id}' or technician = '{$user_id}')
                   and status in ('N')
                 order by a.modified desc
SQL;
        }
        $results = $this->query($query);
        if (!$results) {
            \Log::warning($this->lastQuery());
        }
        return $this->addAvatars($this->query($query));
    }
    
    /**
     * Returns a dataset of vision packets that the current user has submitted for review
     * 
     * @return iterator
     */
    public function outboundVisionPackets() {
        $user_id = ($this->getUserId())? $this->getUserId() : Environment::whoAmI();
        if (Argus::getEntity('argus/user_roles')->userHasRole('O.D.')) {
            $query = <<<SQL
                 SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.tag,
                        b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender,
                        concat(c.first_name,' ',c.last_name) as technician_name, a.last_action, a.address_id, a.address_id_combo
                  FROM vision_consultation_forms AS a
                  LEFT OUTER JOIN humble_user_identification AS b
                    ON a.created_by = b.id
                  left outer join humble_user_identification as c
                    on a.technician = c.id                    
                 where reviewer = '{$user_id}' 
                   and status = 'R'
SQL;
        } else {
            $query = <<<SQL
                 SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.tag,
                        b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender,
                        concat(c.first_name,' ',c.last_name) as technician_name, a.last_action, a.address_id, a.address_id_combo
                  FROM vision_consultation_forms AS a
                  LEFT OUTER JOIN humble_user_identification AS b
                    ON a.created_by = b.id
                  left outer join humble_user_identification as c
                    on a.technician = c.id                    
                 where (created_by = '{$user_id}' or technician =  '{$user_id}')
                   and status = 'S'
SQL;
        }        
        return $this->addAvatars($this->query($query));
    }
    
    /**
     * Gets the current set of reasons for forms being in admin queue
     * 
     * @return iterator
     */
    public function activeReferralReasons() {
        $query = <<<SQL
           select distinct referral_reason from vision_consultation_forms where `status` = 'A' order by referral_reason
SQL;
        return $this->query($query);
    }
    
    /**
     * Gets the forms that have a status of 'A', which means requiring administration...
     * 
     * @return array
     */
    public function formsRequiringAdmin() {
        $referral_clause = $this->getReferralReason() ? " and a.referral_reason = '".$this->getReferralReason()."' " : "";
        $query = <<<SQL
             SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.screening_client, a.tag,
                    b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender, a.referral_reason,
                    concat(c.first_name,' ',c.last_name) as technician_name, a.last_action, a.address_id, a.address_id_combo
              FROM vision_consultation_forms AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.created_by = b.id
              left outer join humble_user_identification as c
                on a.technician = c.id                    
             where status = 'A'
                {$referral_clause}
SQL;
        return $this->addAvatars($this->on('form_id')->with('vision/consultation/forms')->query($query));           
    }
    
    /**
     * Gets the forms that have a status of 'A', which means requiring administration...
     * 
     * @return array
     */
    public function formsRequiringReferral() {
        $query = <<<SQL
             SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.screening_client, a.tag,
                    b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender,
                    concat(c.first_name,' ',c.last_name) as technician_name, a.last_action, a.address_id, a.address_id_combo
              FROM vision_consultation_forms AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.created_by = b.id
              left outer join humble_user_identification as c
                on a.technician = c.id                    
             where referral = 'Y' and referred != 'Y'
               and `status` in ('C','A')
SQL;
        return $this->addAvatars($this->on('form_id')->with('vision/consultation/forms')->query($query));           
    }    
    
    /**
     * We are going to return the form back to the previous status from which it was referred for administration
     */
    public function resolve() {
        $data = $this->load();
        //if the claim is in administration and the claim_status = 'E', we are going to reset the claim_status to 'N' so that it can be reclaimed after the administrative action is complete
        $claim_status = (isset($data['claim_status'])) ? $data['claim_status'] : 'N';
        if ($claim_status == 'E') {
            $claim_status = 'N';
        }
        if ($data['previous_status']==='A') {
            $data['previous_status'] = (isset($data['doctor_has_signed']) &&($data['doctor_has_signed']==='Y')) ? 'C' : (($data['reviewer'] ? 'I' : (($data['submitted']) ? 'S' : 'N')));
        }
        $this->reset()->setId($data['id'])->setClaimStatus($claim_status)->setStatus($data['previous_status'])->save();
    }
    
    /**
     * Returns a dataset of vision packets for the current user to review
     * 
     * @return iterator
     */
    public function inboundVisionPackets() {
        /**
         * If you are a O.D and you are not the reviewer, and the 
         */
        $user_id = ($this->getUserId())? $this->getUserId() : Environment::whoAmI();
        if (Argus::getEntity('argus/user_roles')->userHasRole('O.D.')) {
            $clause = (Argus::getEntity('argus/user_roles')->userHasRole('HEDIS Vision Manager')) ? "reviewer is null or reviewer = '' or reviewer = '{$user_id}'" : "reviewer = '{$user_id}'";
            $query = <<<SQL
                SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.event_date, a.event_time, a.tag,
                        b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender,
                        concat(c.first_name,' ',c.last_name) as technician_name, a.last_action, a.address_id, a.address_id_combo
                  FROM vision_consultation_forms AS a
                  LEFT OUTER JOIN humble_user_identification AS b
                    ON a.created_by = b.id
                  left outer join humble_user_identification as c
                    on a.technician = c.id                    
                 where ({$clause})
                   and status = 'S'
                 order by a.event_date asc, a.event_time asc
SQL;
        } else {
            $query = <<<SQL
                SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.tag,
                        b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender,
                        concat(c.first_name,' ',c.last_name) as technician_name, a.last_action, a.address_id, a.address_id_combo
                  FROM vision_consultation_forms AS a
                  LEFT OUTER JOIN humble_user_identification AS b
                    ON a.created_by = b.id
                  left outer join humble_user_identification as c
                    on a.technician = c.id                    
                 where (created_by = '{$user_id}' or technician =  '{$user_id}')
                   and status = 'R'
                 order by a.modified desc
SQL;
        }

        return $this->addAvatars($this->query($query));
    } 
    
    /**
     * Appends a comment to the existing consultation form comment
     * 
     * @return string
     */
    public function addComment() {
        $comment = $this->getComment();
        $this->unsetComment();
        $user_id = $this->getUserId();
        $user    = Argus::getEntity('humble/user_identification')->setId($user_id)->load();
        $this->unsetUserId();  //Due to polyglot nature of this table, we don't want to accidentally store this information that isn't required
        $this->load();
        $this->setComment($this->getComment().$user['first_name'].' '.$user['last_name'].' @ '.date('m/d/Y H:i:s')."\n".$comment."\n");
        $this->save();
        return $this->getComment();
    }
    
    public function getText($field=false) {
        return ($field) ? ((isset($this->formData[$field])) ? $this->formData[$field] : '') : '';
    }
    
    public function setCheckBox($field=false) {
        return ($field) ? ((isset($this->formData[$field])) ? ($this->formData[$field] === 'on') : '') : '';
    }
    
    public function prePrintProcessing() {
        $this->formData = $this->load();
    }
    
    /**
     * Very basic search on the full members name and/or the member id.  If you pass in a search string that qualifies as a valid date, we use only the date to search and skip text searching
     * 
     * To avoid haywire results as consequence of doing a phonetic search, if the search string isn't a date but contains numbers, we only do the member id search and skip all other searches
     * 
     * @return iterator
     */
    public function search($search=false,$status=false) {
        $search     = ($search) ? $search : $this->getSearch();
        $me         = \Environment::whoAmI();
        $ipa        = false;
        $event_id   = false;
        if (substr(strtoupper($search),0,6)==='EVENT=') {
            $data = explode('=',$search);
            $event_id = $data[1];
        } else {
            if (is_numeric($search) && ((int)$search<15000)) {
                $event_id = $search;
            }
        }

        if ($this->getIpa()) {
            $ipa = Argus::getEntity('vision/ipas')->setUserId($me)->load(true);
        }
        $roles                  = Argus::getEntity('argus/user/roles');
        $pcp_clause             = '';
        $member_clause          = '';
        $tech_clause            = '';
        $admin                  = $roles->userHasRole('System Administrator');
        if ($roles->reset()->userHasRole('Primary Care Physician')) {
            $pcp                = Argus::getEntity('argus/primary_care_physicians')->setUserId($me)->load(true);
            $pcp_clause         = "and physician_npi_combo = '{$pcp['npi']}'";
        } else if ($roles->reset()->userHasRole('PCP Staff') && !$admin) {
            $tech_clause        = "and technician = '".$me."' ";
        }
        $status_clause          = $event_id ? '' : "and a.status = '".(($status) ? $status : 'C')."' ";   //custom status, or form has to be in a completed state
        $ipa_clause             = $ipa && isset($ipa['id']) ? " a.ipa_id = '".$ipa['id']."' and " : "";
        $word_count             = count($words = explode(" ",$search));
        $numeric                = is_numeric($words[0]);
        $event_date_clause      = preg_match('~^[0-9]{1,2}[\-/][0-9]{1,2}[\-/][0-9]{2,4}$~',$search) ? "a.event_date = '".date('Y-m-d',strtotime($search))."'" : "";
        $address_clause         = $event_id || $event_date_clause ? "" : "a.address_id_combo like '{$search}%'";
        $search_mine_clause     = ($this->getSearchMineOnly() == "Y") ? "and (reviewer = '".$me."' || created_by = '".$me."' || technician = '".$me."') " : "";    
        $form_clause            = (!$event_id && $numeric && ($search<500000)) ? "a.id = '{$search}'" : "";
        $event_id_clause        = ($event_id) ? "a.event_id = '{$event_id}'" : "";
        $name_clause            = '';
        $phonetic_clause        = '';
        $order_by_clause        = $event_id ? "order by a.event_time ASC" : "order by a.modified DESC";
        if ((count($name = explode(',',$search))===2) || (count($name = explode(' ',$search))===2)) {
            if (strpos($search,',')) {
                $name_clause        = "(a.member_name like '%".trim($name[0])."%' and a.member_name like '%".trim($name[1])."%') ";                
            } else {
                $name_clause        = "(a.member_name like '%".trim($name[1])."%' and a.member_name like '%".trim($name[0])."%') ";                
            }
            if ((strlen($name[0])>3) && (strlen($name[1])>3)) {
                if (strpos($search,',')) {
                    $phonetic_clause    = ($member_clause) ? " a.phonetic_token1 like '".metaphone(trim($name[1]))."%' or a.phonetic_token2 like '".metaphone(trim($name[0]))."%'": "";
                } else {
                    $phonetic_clause    = ($member_clause) ? " a.phonetic_token1 like '".metaphone(trim($name[0]))."%' or a.phonetic_token2 like '".metaphone(trim($name[1]))."%'": "";
                }
            }
        } else {
            $member_clause          = $event_date_clause || !preg_match('~^[^0-9]+$~',$search) ? "" : "a.member_name like '{$search}%'";            
        }
        $member_id_clause       = !$member_clause && (($word_count === 1) && (preg_match('~^[A-Z]{0,3}[0-9]+$~', $search))) ? "a.member_id like '{$search}%'" : "";
        
        $clause                 = '';
        $clause                 = $clause.(($clause && $event_date_clause) ? ' or ' : "").$event_date_clause;
        $clause                 = $clause.(($clause && $member_clause) ? ' or ' : "").$member_clause;
        $clause                 = $clause.(($clause && $member_id_clause) ? ' or ' : "").$member_id_clause;
        $clause                 = $clause.(($clause && $form_clause) ? ' or ' : "").$form_clause;
        $clause                 = $clause.(($clause && $address_clause) ? ' or ' : "").$address_clause;
        $clause                 = $clause.(($clause && $phonetic_clause) ? ' or ' : "").$phonetic_clause;
        $clause                 = $clause.(($clause && $name_clause) ? ' or ' : "").$name_clause;
        $clause                 = $clause.(($clause && $event_id_clause) ? ' or ' : "").$event_id_clause;    
        $query = <<<SQL
             SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.event_date, a.event_time, a.tag,
                    b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender, a.form_type, a.status, a.claim_status, a.screening_client,
                    concat(c.first_name,' ',c.last_name) as technician_name, a.last_action, a.address_id, a.phonetic_token1, a.phonetic_token2, a.reviewer, concat(d.first_name,' ',d.last_name) as reviewer_name, 
                    a.pcp_portal_withhold, a.location_id_combo, a.address_id_combo, a.event_id
              FROM vision_consultation_forms AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.created_by = b.id
              left outer join humble_user_identification as c
                on a.technician = c.id           
              left outer join humble_user_identification as d
                on a.reviewer = d.id    
             where 
                {$ipa_clause}
                (
                    {$clause}
                )
               {$pcp_clause}
               {$tech_clause}
               {$status_clause}
               {$search_mine_clause}
               {$order_by_clause}
SQL;
               //Log::general($query);
        return $this->query($query);
    }

    
        /**
     * Very basic search on the full members name and/or the member id.  If you pass in a search string that qualifies as a valid date, we use only the date to search and skip text searching
     * 
     * To avoid haywire results as consequence of doing a phonetic search, if the search string isn't a date but contains numbers, we only do the member id search and skip all other searches
     * 
     * @return iterator
     */
    public function pcpSearch($search=false,$status=false) {
        $search = ($search) ? $search : (($this->getSearch()) ? $this->getSearch() : false);

        $pcp    = Argus::getEntity('argus/primary_care_physicians')->setUserId(\Environment::whoAmI())->load(true);

        $query = <<<SQL
             SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.event_date, a.tag,
                    b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender, a.form_type, a.status, a.claim_status, a.screening_client,
                    concat(c.first_name,' ',c.last_name) as technician_name, a.last_action, a.address_id, a.phonetic_token1, a.phonetic_token2, a.reviewer, concat(d.first_name,' ',d.last_name) as reviewer_name, 
                    a.pcp_portal_withhold, a.location_id_combo, a.address_id_combo
              FROM vision_consultation_forms AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.created_by = b.id
              left outer join humble_user_identification as c
                on a.technician = c.id           
              left outer join humble_user_identification as d
                on a.reviewer = d.id           
             where physician_npi_combo = '{$pcp['npi']}'
               and a.member_name like '%{$search}%'
               and a.status = 'C'
SQL;
        return $this->query($query);
    }

    /**
     * Just a relay to the default search mechanism
     * 
     * @return iterator
     */
    public function searchAdminQueue() {
        return $this->search($this->getSearch(),'A');
    }
    
    /**
     * Returns the number of screening forms available for reassignment
     * 
     * @return type
     */
    public function availableScanningForms($type='scanning') {
        $query = <<<SQL
            SELECT COUNT(*) AS total 
              FROM vision_consultation_forms 
             WHERE form_type = '{$type}' 
               AND `status` = 'S' 
               AND reviewer IS NULL                
SQL;
        $results = $this->query($query)->toArray();
        return isset($results[0]['total']) ? $results[0]['total'] : 0;
    }
    
    /**
     * Gets as much data as it can on a particular IPA
     * 
     * @param date $start
     * @param date $end
     * @return iterator
     */
    public function formsBetweenDates($start=false,$end=false) {
        $result = [];
        $end    = ($end) ? $end : date('Y-m-d');
        $ipa_id = $this->getIpaId();
        if ($start && $ipa_id && $end) {
            $query = <<<SQL
              select a.*, concat(b.first_name,' ',b.last_name) as 'OD', concat(c.first_name,' ',c.last_name) as 'Technician Name'
                from vision_consultation_forms as a
                left outer join humble_user_identification as b
                  on a.reviewer = b.id
                left outer join humble_user_identification as c
                  on a.technician = c.id
               where event_date between '{$start}' and '{$end}'
                 and ipa_id in ('{$ipa_id}')
                 and `status` in ('C','A')
SQL;
            $result = $this->normalize($this->query($query));
        }
        return $result;
    }
    
    
    /**
     * Aggregates available form data for claiming.  If you pass in a claim list, then just those are run, otherwise those that are completed but haven't been run are queued up
     * 
     * @return type
     */
    public function batchClaims($number_to_run,$claim_list=false) {
        $errors         = [];
        $event_list     = [];
        $events         = Argus::getEntity('scheduler/events');
        $claim_clause   = ($claim_list) ? " and a.id in (".$claim_list.") " : ""; 
        $run_clause     = ($number_to_run) ? " limit ".$number_to_run : "";
        $cs_clause      = ($claim_clause)  ? "" : "and claim_status = 'N'";
        $query          = <<<SQL
            select a.*
              from vision_consultation_forms as a
              left outer join vision_clients as b
                 on a.screening_client = b.client
              left outer join scheduler_events as c
                 on a.event_id = c.id
             where `status` = 'C' 
               and `claim_status` != 'Y'
                {$cs_clause}
                {$claim_clause}
                {$run_clause}
SQL;
        $claim_data = $this->with('vision/consultation/forms')->on('id')->query($query)->toArray();
        $aldera = Argus::getModel('vision/aldera');                             //this is a "virtual" class... just used to pick up the RPC settings
        foreach ($claim_data as $idx => $claim) {
            (isset($claim['event_date']) && $claim['event_date']) ? $aldera->setDateOfService($claim['event_date']) : $aldera->unsetDateOfService();            
            $member_id = explode('*',$claim['member_id']);
            $member_id = explode('-',$member_id[0]);
            $member_id = strtoupper($member_id[0]);
            //$dmg       = json_decode($aldera->setMemberId($member_id)->demographicInformation(),true);
            $dmg       = [];
/*            if (!($dmg && isset($dmg['demographics']))) {                                    //Try again but without the 01
                if (substr($member_id,-2)==='01') {
                    $dmg = json_decode($aldera->setMemberId(substr($member_id,0,-2))->demographicInformation(),true);
                }
                if (!isset($dmg['demographics'])) {
                    $errors[] = $claim;
                    continue;
                }
            }*/
            $name = explode(',',$claim['member_name']);
            $addr = explode(',',$claim['member_address']);
            $dmg['demographics'] = [
                'address_1'  => '',
                'address_2'  => '',
                'city'       => '',
                'state'      => '',
                'zip_code'   => ''
            ];
            for ($i=0; $i<count($addr); $i++) {
                $addr[$i] = trim($addr[$i]);
            }
            if (count($addr)==5) {
                $dmg['demographics'] = [
                    'street_address' => $addr[0],
                    'last_name'  => $name[0],
                    'first_name' => $name[1],
                    'gender'     => $claim['gender'],                    
                    'address_1'  => $addr[0],
                    'address_2'  => $addr[1],
                    'city'       => $addr[2],
                    'state'      => $addr[3],
                    'zip_code'   => $addr[4]
                ];
            } else if (count($addr)==4) {
                $dmg['demographics'] = [
                    'street_address' => $addr[0],
                    'last_name'  => $name[0],
                    'first_name' => $name[1],
                    'gender'     => $claim['gender'],                    
                    'address_1'  => $addr[0],
                    'city'       => $addr[1],
                    'state'      => $addr[2],
                    'zip_code'   => $addr[3]
                ];
            }
            if (isset($claim['event_id']) && $claim['event_id']) {              //We are going to merge the event information with the member information
                if (!isset($event_list[$claim['event_id']])) {
                    if ($d = $events->reset()->setId($claim['event_id'])->load()) {
                        unset($d['id']); unset($d['modified']);
                        $event_list[$claim['event_id']] = $d;
                    } else {
                        $event_list[$claim['event_id']] = [];                   //If we don't have event information, just store an empty array so the array merge can complete
                    }
                }
                $claim_data[$idx] = array_merge($event_list[$claim['event_id']],$claim);   //does this now give preference to what was on the form over the event?
            }
            $claim_data[$idx] = array_merge($claim_data[$idx],$dmg['demographics']);
           // $claim_data[$idx]['street_address'] = $dmg['demographics']['address'];
        }
        return $claim_data;
    }
    
    /**
     * Because of the variable columns per row, we need to get a list of all columns across our dataset
     */
    private function getColumns($forms) {
        $columns    = [];
        foreach ($forms as $form) {
            foreach ($form as $column => $value) {
                $columns[$column] = $column;
            }
        }
        return $columns;
    }

    /**
     * 
     */
    public function export() {
        $results = [];
        foreach ($this->normalize($this->fetch()) as $form) {
            $form['procedure_codes'] = '';
            $form['diagnosis_codes'] = '';
            $form['biometrics']      = 'FBS='.(isset($form['fbs']) && $form['fbs'] ? $form['fbs'] : 'N/A').'['.(isset($form['fbs_date']) && $form['fbs_date'] ? $form['fbs_date'] : 'N/A').'],HBA1C='.(isset($form['hba1c']) && $form['hba1c'] ? $form['hba1c'] : 'N/A').'['.(isset($form['hba1c_date']) && $form['hba1c_date'] ? $form['hba1c_date'] : 'N/A').']';
            $form['comment'] = isset($form['comment']) ?  str_replace(["\r","\n"],[" "," "],$form['comment']): '';
            foreach ($form as $field => $value) {
                if (substr($field,0,3) === 'pc_') {
                    if (strtoupper($value)==='Y') {
                        $field = strtoupper(substr($field,3));
                        $form['procedure_codes'] = ($form['procedure_codes']) ? $form['procedure_codes'].",".$field : $field;
                    }
                } else if (substr($field,0,9)==='lbl_code_') {
                    if (trim($value)) {
                        $form['diagnosis_codes'] = ($form['diagnosis_codes']) ? $form['diagnosis_codes'].",".$value : $value;
                    }
                } else if (substr($field,0,10)==='diag_code_') {
                    if (strtoupper($value)==='Y') {
                        $field = str_replace('_','.',strtoupper(substr($field,10)));
                        $form['diagnosis_codes'] = ($form['diagnosis_codes']) ? $form['diagnosis_codes'].",".$field : $field;
                    }
                }
            }
            $results[] = $form;           
        }
        return Argus::getHelper('argus/CSV')->toCSV(Argus::report($results,'forms_export'),',','"',true);
    }
    
    /**
     * Will return member information for a health plan from a certain date
     * 
     * @param type $date
     * @param type $health_plan
     * @return type
     */
    public function formMemberDataFromDate($date=false,$health_plan='CarePlus') {
        $results = [];
        if ($date = ($date) ? $date : $this->getDate()) {
            $query = <<<SQL
                SELECT id, member_name, address_id_combo AS 'event_address', event_id, member_id, tag,
                  FROM vision_consultation_forms
                 WHERE event_date > '{$date}'
                   AND (screening_client LIKE '{$health_plan}%' OR client_id = 111)
                   AND `status` IN ('C','A','I','R');                    
SQL;
            $results = $this->normalize($this->query($query));
        }
        return $results;
    }
    
    /**
     * Returns the form status and the claim status in a single query
     * 
     * @return iterator
     */
    public function aggregateStatus() {
        $query = <<<SQL
         SELECT a.id, a.`status`, a.claim_status, b.verified, a.tag
           FROM vision_consultation_forms AS a
           LEFT OUTER JOIN argus_claims AS b
             ON a.id = b.form_id;                
SQL;
        return $this->query($query);
    }
    
    
    /**
     * Gets outstanding work items (forms) that are sitting in OD queues
     * 
     * @return iterator
     */
    public function odWorkloads() {
        $query = <<<SQL
            SELECT id, reviewer, event_date, event_id, member_id, member_name, `status` FROM vision_consultation_forms
             WHERE `status` IN ('I','S','R')
               AND (reviewer IN (SELECT user_id FROM argus_user_roles WHERE role_id = 13) OR reviewer IS NULL) 
               AND event_date > '2020-01-01'
             ORDER BY reviewer, event_date;
SQL;
        return $this->query($query);
    }
    
    /**
     * Just an idea... didn't work out but leaving it for posterity sake
     * 
     * @return string
     */
    protected function buildClause() {
        $skip = ['n'=>true,'c'=>true,'m'=>true,'session_id'=>true];
        $clause = '';
        foreach ($this->_data as $field => $value) {
            if (isset($skip[$field])) {
                continue;
            }
            $clause .= " and a.".$field." = '".addslashes($value)."'";
        }
        return $clause;
    }
    
    /**
     * Returns normalized screening/scanning forms with the names of the participants attached

     * @return iterator
     */
    public function extendedInformation() {
        //$clause = $this->buildClause();
        $ipa_clause         = $this->getIpaId()         ? " and a.ipa_id = '".$this->getIpaId()."' " : "";
        $event_clause       = $this->getEventId()       ? " and a.event_id = '".$this->getEventId()."' " : "";
        $client_clause      = $this->getClientId()      ? " and a.client_id = '".$this->getClientId()."' " : "";
        $location_clause    = $this->getLocationId()    ? " and a.location_id = '".$this->getLocationId()."' " : "";
        $address_clause     = $this->getAddressId()     ? " and a.address_id = '".$this->getAddressId()."' " : "";
        $start_clause       = $this->getStartDate()     ? " and a.event_date >= '".$this->getStartDate()."' " : "";
        $end_clause         = $this->getEndDate()       ? " and a.event_date <= '".$this->getEndDate()."' " : "";
        $reviewer_clause    = $this->getReviewer()      ? " and a.reviewer = '".$this->getReviewer()."' " : "";
        $memberid_clause    = $this->getMemberId()      ? " and a.member_id = '".$this->getMemberId()."' " : "";
        $date_clause        = $this->getDate()          ? " and a.event_date = '".$this->getDate()."' " : "";
        $tech_clause        = $this->getTechnician()    ? " and a.technician = '".$this->getTechnician()."' " : "";
        $include_note       = $this->getIncludeNote();
        $year_clause        = $this->getYear()          ? " and (a.event_date >= '".$this->getYear()."-01-01' and a.event_date <= '".$this->getYear()."-12-31')  " : "";
        $pc2023f_clause     = $this->getPc_2023f()      ? " and a.pc_2023f = '".$this->getPc_2023f()."' " : "";
        $pc92227_clause     = $this->getPc_92227()      ? " and a.pc_92227 = '".$this->getPc_92227()."' " : "";
        $scannable_clause   = $this->getMemberUnscannable() ? " and a.member_unscannable = '".$this->getMemberUnscannable()."' " : "";
        $pc_clause          = '';
        if ($this->getProcedureCode()) {
            $pc_clause = " and a.".$this->getProcedureCode()." = 'Y' ";
        }
        $query = <<<SQL
            select a.*,
                   concat(b.first_name,' ',b.last_name) as 'technician_name',
                   concat('Dr. ',c.first_name,' ',c.last_name) as 'reviewer_name',
                   d.`date` as 'claim_submitted', d.verified as 'claim_paid', d.total as 'claim_amount',
                   g.*
              from vision_consultation_forms as a
              left outer join humble_user_identification as b
                on a.technician = b.id
              left outer join humble_user_identification as c
                on a.reviewer   = c.id
              left outer join argus_claims as d
                on a.id = d.form_id
              left outer join vision_gaps as g
                on a.member_id = g.mem_id
             where a.id is not null
                {$year_clause}
                {$event_clause}
                {$date_clause}
                {$client_clause}
                {$ipa_clause}
                {$reviewer_clause}
                {$memberid_clause}
                {$location_clause}
                {$address_clause}
                {$start_clause}
                {$end_clause}
                {$tech_clause}
                {$pc2023f_clause}
                {$pc92227_clause}
                {$scannable_clause}
                {$pc_clause}
             order by a.event_date
SQL;
        /**
         * To-Do: Loop through the event_member table to get the value of "note" column and attach to the $results
         */
        $results = $this->normalize($this->query($query));
        if($include_note == "Y") {
            
        }
        return $results;
    }
    
    
    /**
     * Just tallies up how many time a particular value is found in a field in a set of records
     * 
     * @param array $rows
     * @param string $field
     * @param mixed $value
     * @return int
     */
    public function tally($rows=[],$field=false,$value=false) {
        $result = 0;
        if (count($rows)) {
            foreach ($rows as $row) {
                $result += (isset($row[$field]) && ($row[$field]==$value)) ? 1 : 0;
            }
        }
        return $result;
    }
    /**
     * Looks for PCPs on forms who don't have entries in our primary care physicians table
     * 
     * @return type
     */
    public function findMissingPCPRegistrations() {
        $query = <<<SQL
            SELECT a.id, a.physician_npi_combo, b.user_id, a.tag,
              FROM vision_consultation_forms AS a
              LEFT OUTER JOIN argus_primary_care_physicians AS b
                ON a.physician_npi_combo = b.npi
             WHERE `status` = 'C'
               AND pcp_portal_withhold = 'N'
               AND user_id IS NULL
               AND physician_npi_combo IS NOT NULL
               AND created > '2020-01-01'                
SQL;
        return $this->query($query);
    }
    
    /**
     * Modify as you see fit
     * 
     * @return CSV
     */
    public function formnormalizer() {
        $forms          = $this->fetch();                                       //Get a list of all data
        $results        = [];                                                   //This will end up being the CSV
        $ctr            = 0;                                                    //We only want the records that meet our condition below
        $columns        = $this->getColumns($forms);                            //Gets the full list of columns, regardless of whether it was set per row
        $someCondition  = true; 
        
        foreach ($forms as $idx => $form) {
            $ctr++;
            foreach ($columns as $column) {
                $results[$ctr][$column] = isset($form[$column]) ? $form[$column] : '';  //Now we "normalize" the data, providing a value for each column if that row didn't have it.  Also normalizes the order
            }
        }
        
        
        return $results;             
    }
    
    public function batchpdffinder() {
        
        /**/
        $event_date = '';
        $event_location = '';
        
        
        $theloc=$_POST['evloc'];
        $thedate=$_POST['evdate'];  
        if($thedate!=null){
            if($thedate.trim()!=''){
                $event_date ="and a.event_date='".date('Y-m-d',strtotime($thedate))."'";
                //and a.event_date='2018-03-21'
                //
                //$event_date='and a.event_date='.$ntde;
            }
        }
        if($theloc!=null){
            if($theloc.trim()!=''){
                $exploc=explode(" ",$theloc);

                $event_location="and a.address_id LIKE '".$exploc[0]."%'";

                //and a.event_date='2018-03-21'
                //
                //$event_date='and a.event_date='.$ntde;
            }
        }
        $query = <<<SQL
             SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.event_date, a.tag,
                    b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender,
                    concat(c.first_name,' ',c.last_name) as technician_name, a.last_action, a.address_id
              FROM vision_consultation_forms AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.created_by = b.id
              left outer join humble_user_identification as c
                on a.technician = c.id                    
              WHERE a.address_id <> ""            
              AND a.event_date<>""
                 and a.status='C'
                $event_date
                $event_location 
SQL;
        return $this->query($query);
    }
   
}