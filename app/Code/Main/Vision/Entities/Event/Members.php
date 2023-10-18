<?php
namespace Code\Main\Vision\Entities\Event;
use Argus;
use Log;
use Environment;
/**
 *
 * Event Member Queries
 *
 * Assorted queries
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Members.html
 * @since      File available since Release 1.0.0
 */
class Members extends \Code\Main\Vision\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Gets extended information, including polyglot, for this entity
     * 
     * @return iterator
     */
    public function eventParticipants() {
        $results = $this->normalize($this->setEventId($this->getEventId())->with('vision/event_members')->fetch()); //no need to specify ID field with on() since that is the default
        $aldera  = Argus::getModel('vision/aldera');
        foreach ($results as $idx => $row) {
            if (!(isset($row['first_name']) && isset($row['last_name']))) {
                $data = $aldera->setMember_id($row['member_number'])->memberDemographicInformation();
                print_r($data);
            }
        }
        return $results;
    }
    
    /**
     * Will first add the member to other entities, then save that member id to this entity
     */
    public function add() {
        $event_id       = $this->getEventId();
        $health_plan    = $this->getHealthPlan();
        if (count($data = Argus::getEntity('vision/clients')->setClient($health_plan)->load(true))) {
            $health_plan_id = $data['id'];
        };
        $member         = Argus::getEntity('vision/members');        
        $event_member   = Argus::getEntity('vision/event_members');
        $member_number  = $this->getMemberId();
        $member_name    = $this->getMemberName();
        $member_address = $this->getMemberAddress();
        $member_dob     = $this->getMemberDob();
        $hba1c          = $this->getMemberHba1c();
        $hba1c_date     = $this->getMemberHba1cDate();
        $fbs            = $this->getMemberFbs();
        $fbs_date       = $this->getMemberFbsDate();
        $diabetes_type  = $this->getDiabetesType();
        $diabetes_status= $this->getDiabetesStatus();
        $number_of_years= $this->getNumberOfYears();
        $type_diet      = $this->getTypeDiet();
        $type_insulin   = $this->getTypeInsulin();
        $type_oral      = $this->getTypeOral();
        
        if (isset($fbs)) {
            $member->setFbs($fbs);
        }
        if (isset($fbs_date) ){
            $member->setFbsDate($fbs_date);
        }
        if (isset($hba1c)) {
            $member->setHba1c($hba1c);
        }
        if (isset($hba1c_date)) {
            $member->setHba1cDate($hba1c_date);
        }
        if ($member_dob) {
            $member->setDateOfBirth($member_dob);
        }
        $name = [];
        if (strpos($member_name,",")) {
            $name = explode(",",$member_name);
            $member->setFirstName(strtoupper(trim($name[1])))->setLastName(strtoupper(trim($name[0])));
        } else {
            $name = explode(" ",$member_name);
            $member->setFirstName(trim($name[0]))->setLastName(trim($name[1]));
        }
        $member->setPhoneticToken1(metaphone($name[0]));
        $member->setPhoneticToken2(metaphone($name[1]));
        if ($number_of_years) {
            $member->setNumberOfYears($number_of_years);
        }
        if ($type_diet) {
            $member->setTypeDiet($type_diet);
        }
        if ($type_insulin) {
            $member->setTypeInsulin($type_insulin);
        }
        if ($type_oral) {
            $member->setTypeOral($type_oral);
        }
        if ($diabetes_status) {
            $member->setDiabetesStatus($diabetes_status);
        }
        if ($diabetes_type) {
            $member->setDiabetesType($diabetes_type);
        }
        
        
        $member_id = $member->setMemberNumber($member_number)->save();
        if ($member_address) {
            $util        = Argus::getHelper('vision/event');
            $address     = explode(",",$member_address);
            if ($address_id  = Argus::getEntity('vision/addresses')->setAddress($util->fixAddress(strtoupper($address[0])))->setCity(strtoupper(trim($address[1])))->setState(strtoupper(trim($address[2])))->setZipCode(strtoupper(trim($address[3])))->save()) {
                Argus::getEntity('vision/member_addresses')->setMemberId($member_id)->setAddressId($address_id)->save();
            }
        }
        $event_member->setMemberId($member_id)->setEventId($event_id)->save();
    }
    
    /**
     * Gets extended information about the people who are attending the event and marries it with extended event information
     * 
     * Humble supports only 1 with/on combination.  We need to do 2 with/on polyglot functions here so we are splitting into a separate function
     * 
     * @return iterator
     */
    public function attendees() {
        $results = [];
        if ($event_id = $this->getEventId()) {
            $query = <<<SQL
                SELECT a.*,
                      e.start_date, e.start_time, e.end_date, e.end_time
                 FROM vision_event_members AS a
                 left outer join scheduler_events as e
                   on a.event_id = e.id
                WHERE a.event_id = '{$event_id}'
SQL;
            $event_data  = Argus::getEntity('scheduler/events')->setId($event_id)->load();
            $results    = []; $skip = ['id'=>true,'modified'=>true,'client_id'=>true];
            foreach ($this->query($query) as $idx => $attendee) {
                $results[$idx] = $attendee;
                foreach ($event_data as $var => $val) {
                    if (!isset($skip[$var])) {
                        $results[$idx][$var] = $val;
                    }
                }
            }
        }
        return $results;
    }

    /**
     * Returns data about members from an event including the status of the screening/scanning form.  If no status, member did not attend, otherwise if status is 'S', it is completed from a tech perspective
     * 
     * @return iterator
     */
    public function report() {
        $query = <<<SQL
        select a.*, b.status
          from vision_event_members as a
          left outer join vision_consultation_forms as b
            on a.event_id = b.event_id
           and a.member_id = b.member_id
         where a.event_id = '{$this->getEventId()}'
SQL;
        return $this->query($query);
    }
    
    /**
     * A general summary of an event
     * 
     * @param int $event_id
     * @return iterator
     */
    public function summarizeEvent($event_id=false) {
        $results = Argus::array();
        if ($event_id = ($event_id ? $event_id : ($this->getEventId() ? $this->getEventId() : false))) {
            $query = <<<SQL
                SELECT a.id, a.member_id, a.event_id, a.form_generated, b.id as form_id, b.created, b.created_by, b.member_name, b.`status`, b.claim_status, b.last_action
                  from vision_event_members as a
                  left outer join vision_consultation_forms as b
                    on a.event_id = b.event_id
                   and a.member_id = b.member_id
                 where a.event_id = '{$event_id}' 
SQL;

        }
        $data    = [];
        $cnt     = 2300;
        foreach ($this->query($query) as $member) {
            $time = isset($member['time']) ? (int)str_replace([':','AM','PM',' '],['','','',''],strtoupper($member['time'])) : ++$cnt;
            $data[($time < 700) ? $time + 1200 : $time] = $member;
        }
        ksort($data);
        return $data;
    }
    
    /**
     * 
     * @return iterator
     */
    public function recap() {
        $event_clause       = $this->getEventId()       ? "and a.event_id = '".$this->getEventId()."' "         : "";
        $ipa_clause         = $this->getIpaId()         ? "and a.ipa_id = '".$this->getEventId()."' "           : "";
        $loc_clause         = $this->getLocationId()    ? "and a.location_id = '".$this->getLocationId()."' "   : "";
        $client_clause      = $this->getClientId()      ? "and b.client_id = '".$this->getClientId()."' "       : "";
        $start_date_clause  = $this->getStartDate()     ? "and b.event_date >= '".$this->getStartDate()."' "     : "";
        $end_date_clause    = $this->getEndDate()       ? "and b.event_date <= '".$this->getEndDate()."' "       : "";
        $addr_clause        = $this->getAddressId()     ? "and a.address_id = '".$this->getAddressId()."' "     : "";
        $query = <<<SQL
            SELECT a.*,
                 b.created_by, b.created, b.form_type, b.event_date,  b.technician, b.client_id, b.ipa_id, b.ipa_id_combo, b.location_id, b.location_id_combo, b.address_id, b.address_id_combo, b.npi_id, b.npi_id_combo, b.screening_client,
                 b.submitted, b.last_activity, b.last_action, b.reviewer, b.physician_npi, b.physician_npi_combo, b.`status`, b.claim_status, b.pcp_portal_withhold, b.member_name, b.member_unscannable,
                 b.pc_s3000, b.pc_2022f, b.pc_g2102, b.pc_2022f_8p, b.pc_2023f, b.pc_5010f, b.pc_3072f, b.pc_92227, b.pc_2026f, b.pc_g2104, b.pc_2033f, b.referral, b.referred,
                 CONCAT(c.last_name,', ',c.first_name) AS technician_name, CONCAT(d.last_name,', ',d.first_name) AS reviewer_name, b.images_unreadable
              FROM vision_event_members AS a
              LEFT OUTER JOIN vision_consultation_forms AS b
                ON a.event_id = b.event_id
               AND a.member_id = b.member_id
              LEFT OUTER JOIN humble_user_identification AS c
                ON b.technician = c.id
              LEFT OUTER JOIN humble_user_identification AS d
                ON b.reviewer  = d.id
             WHERE a.event_id is not null
                {$event_clause}
                {$ipa_clause}
                {$loc_clause}
                {$addr_clause}
                {$client_clause}
                {$start_date_clause}
                {$end_date_clause}
SQL;
        $recap = $this->query($query);
        $event = Argus::getEntity('scheduler/events')->setId($this->getEventId())->load();
        unset($event['id']); unset($event['modified']);
        $members = [];
        foreach ($recap->toArray() as $participant) {
            $members[] = array_merge($participant,$event);
        }
        return $recap->set($members);
    }
    /**
     * Just a standalone report of all the events done in a year
     */
    public function eventReport() {
        $query = <<<SQL
            SELECT a.id AS 'Event ID', COALESCE(event_address,address_id_combo) AS 'Event Address', b.member_id, c.member_name, c.form_type AS 'Type', a.start_date AS 'Start Date', c.`status` AS 'Status', c.claim_status AS 'Claimed'
                  , CONCAT(d.last_name,', ',d.first_name) AS 'Creator'
                  , CONCAT(e.last_name,', ',e.first_name) AS 'Technician'
                  , CONCAT(f.last_name,', ',f.first_name) AS 'Reviewer'
              FROM scheduler_events AS a
              LEFT OUTER JOIN vision_event_members AS b
                ON a.id = b.event_id 
              LEFT OUTER JOIN vision_consultation_forms AS c
                ON b.event_id = c.event_id 
               AND b.member_id = c.member_id
              LEFT OUTER JOIN humble_user_identification AS d
                ON c.created_by = d.id
              LEFT OUTER JOIN humble_user_identification AS e
                ON c.technician = e.id
              LEFT OUTER JOIN humble_user_identification AS f
                ON c.reviewer = f.id
             WHERE a.start_date > '2020-01-01'
              ORDER BY a.id              
SQL;
        $report = $this->normalize($this->with('scheduler/events')->on('event_id')->query($query));
    }
}