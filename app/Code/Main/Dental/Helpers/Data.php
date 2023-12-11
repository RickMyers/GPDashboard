<?php
namespace Code\Main\Dental\Helpers;
use Argus;
use Log;
use Environment;
/**
 * 
 * Dental helper
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Utility
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2005-present Argus Dashboard
 * @license    https://jarvis.enicity.com/license.txt
 * @version    1.0.0
 * @link       https://jarvis.enicity.com/docs/class-Data.html
 * @since      File available since Release 1.0.0
 */
class Data extends Helper
{

    private $languageXref = [
        "English"   => "ENG",
        "ENG"       => "ENG",
        "EN"        => "ENG",
        "Spanish"   => "SPAN",
        "SP"        => "SPAN",
        "ESP"       => "SPAN",
        "SPAN"      => "SPAN",
        "ES"        => "SPAN",
        "CPF"       => "CPF",
        "Creole"    => "CPF",
        "Pidgins"   => "CPF"
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
     * 
     */
    protected function resetStatus() {
        
    }
    
    protected function setUploadStatus($percent=0,$message='Starting..') {
        file_put_contents('Code/Main/Dental/web/js/upload_status.json','{ "percent": "'.$percent.'", "message": "'.$message.'"}');
    }
    
    /**
     * Manages the upload and processing of the HEDIS call schedule
     */
    public function processHedisSchedule() {
        $schedule       = $this->getSchedule();
        $campaign_id    = $this->getCampaignId();
        $households     = [];
        $statuses       = [];
        $member_count   = [];
        $this->setUploadStatus();
        if ($schedule && isset($schedule['path'])) {
            if (strpos($schedule['name'],'.csv')) {
                $csv          = Argus::getHelper('argus/CSV');
                $member       = Argus::getEntity('dental/members');
                $address      = Argus::getEntity('dental/addresses');
                $user_address = Argus::getEntity('dental/member_addresses');
                $phone        = Argus::getEntity('dental/phone_numbers');
                $user_phone   = Argus::getEntity('dental/member_phone_numbers');
                $rows         = $csv->toHashTable($schedule['path']);

                $candidates = [];
                foreach ($rows as $idx => $candidate) {                         // Lets screen the rows to weed out the ones we can't process
                    //if ($candidate['PHONE'] && (strpos(strtoupper($row['ELIGIBILITY END DATE']),'INELIGIBLE')===false)) {
                    if (isset($candidate['PHONE']) && $candidate['PHONE']) {
                        $candidates[] = $candidate;
                    }
                }
                $inc          = floor(250/ round(count($candidates)/100));
                $pct          = 0;
                file_put_contents('candidates.txt',print_r($candidates,true));
                foreach ($candidates as $idx => $row) {
                    //below normalizes the language value because prestige is inconsistent as F
                    $row['LANGUAGE'] = 'ENG';
                    $row['LANGUAGE'] = isset($this->languageXref[$row['LANGUAGE']]) ? $this->languageXref[$row['LANGUAGE']] : substr($this->languageXref[$row['LANGUAGE']],0,3);
                    $hedis_member_id = $member->reset()->setCampaignId($campaign_id)->setMemberId($row['MEDICAIDID'])->setFirstName($row['FIRST_NAME'])->setLastName($row['LAST_NAME'])->setDateOfBirth(date('Y-m-d',strtotime($row['BIRTHDATE'])))->setEligibilityStartDate('2018-01-01')->setEligibilityEndDate('2199-12-31')->setLanguage($row['LANGUAGE'])->setGender($row['GENDER'])->setModified(date('Y-m-d H:i:s'))->save();
                    $address_id      = $address->reset()->setAddress($row['ADDRESS1'])->setCity($row['CITY'])->setState($row['STATE'])->setZipCode(substr($row['ZIP5'],0,5))->setTypeId(1)->setModified(date('Y-m-d H:i:s'))->save();
                    if (!isset($households[$address_id])) {
                        $households[$address_id] = [];
                    }
                    $households[$address_id][] = $hedis_member_id;
                    if ($row['PHONE']) {
                        $user_phone->reset()->setMemberId($hedis_member_id)->setPhoneNumberId($phone->reset()->setPhoneNumber($row['PHONE'])->setTypeId(1)->save())->setModified(date('Y-m-d H:i:s'))->save();
                    }
                    if (isset($row['APPENDED PHONE']) && $row['APPENDED PHONE']) {
                        $user_phone->reset()->setMemberId($hedis_member_id)->setPhoneNumberId($phone->reset()->setPhoneNumber($row['APPENDED PHONE'])->setTypeId(4)->save())->setModified(date('Y-m-d H:i:s'))->save();
                    }
                    if (!isset($member_count[$address_id])) {
                        $member_count[$address_id] = 0;
                    }
                    $member_count[$address_id] = $member_count[$address_id] + 1;
                    $user_address->reset()->setMemberId($hedis_member_id)->setAddressId($address_id)->setModified(date('Y-m-d H:i:s'))->save();
                    if (($idx % 100) == 0) {
                        $pct += $inc;
                        $this->setUploadStatus($pct,'Populating Member Data ['.$idx.']');
                    }
                }
                $household  = Argus::getEntity('dental/contact_members');
                $call       = Argus::getEntity('dental/contact_call_schedule');
                $ctr = 0;
                $inc = floor(250/round(count($households)/100));
                $pct = 250;
                foreach ($households as $address_id => $members) {
                    $ctr++;
                    $call->reset()->setCampaignId($campaign_id)->setAddressId($address_id)->setMembers($member_count[$address_id])->setModified(date('Y-m-d H:i:s'))->save();
                    foreach ($members as $hedis_member_id) {
                        $household->reset()->setAddressId($address_id)->setMemberId($hedis_member_id)->setModified(date('Y-m-d H:i:s'))->save();
                    }
                    if (($ctr % 100) == 0) {
                        $pct += $inc;
                        $this->setUploadStatus($pct,'Creating Call Schedule ['.$ctr.']');
                    }
                    
                }
            }
        }
        $this->setUploadStatus();
    }
}