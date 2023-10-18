<?php
namespace Code\Main\Argus\Helpers;
use Argus;
use Log;
use Environment;
/**
 * General Helper
 *
 * PHP version 5.6+
 *
 * @category   Utility
 * @package    Other
 * @author     Richard Myers rickmyers1969@gmail.com
 * @since      File available since Release 1.0.0
 */
class Data extends Helper
{

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
     * If a file name was passed, save it off
     */
    public function storeProfilePhoto() {
        $uid    = $this->getUid();
        $photo  = $this->getPhoto();
        $image  = Argus::getHelper('argus/image');
        if ($photo && isset($photo['path'])) {
            @mkdir('../images/argus/avatars/tn',0775,true);
            $x = copy($photo['path'],'../images/argus/avatars/'.$photo['name']);
            $image->setImage('../images/argus/avatars/'.$photo['name']);
            if ($image->getImageHeight() > 500) {
                $image->generateThumbnail('../images/argus/avatars/'.$uid.'.'.$image->getImageExtension(),$image->getImageExtension(),500);
            } else {
                copy($photo['path'],'../images/argus/avatars/'.$uid.'.'.$image->getImageExtension());
            }
            $image->generateThumbnail('../images/argus/avatars/tn/'.$uid.'.'.$image->getImageExtension(),$image->getImageExtension(),100);
            unlink('../images/argus/avatars/'.$photo['name']);
        }
    }
    
    protected function extractAndCorrelateHedisInformationFromSchedule($rows) {
        
    }
    
    /**
     * Gets just the data rows out of
     * 
     * @param type $source
     * @return type
     */
    protected function extractRowsFromCSVHedisSchedule($source=false) {
        $rows = [];
        if ($source) {
            if (($handle = fopen($source, "r")) !== FALSE) {
                while (($data = fgetcsv($handle, 0, ",")) !== FALSE) {
                    if (($timestamp = strtotime($data[0])) === false) {
                        continue;  //not a line I want
                    }
                    if (trim($data[1])) {
                        $data[0] = date('m/d/Y',$timestamp);
                        $rows[] = $data;
                    }
                }
                fclose($handle);
            }            
        }
        return $rows;
    }
    
    /**
     * Saves HEDIS participant data, returning the ID from the row inserted into the table
     * 
     * @param resource entity reference
     * @param array user_data
     * @return int
     */
    private function saveHedisParticipantData($participant,$address,$user_address,$phone,$user_phone,$campaign_id,$data) {
        //First, save participant data
        $member->reset();
        $member->setCampaignId($campaign_id);
        $member->setMemberId($data[1]);
        $member->setFirstName($data[2]);
        $member->setLastName($data[3]);
        $member->setDateOfBirth(date('Y-m-d'),strtotime($data[4]));
        $member_id = $member->save();
        //Now save participant address
        $address->reset();
        $address->setAddress($data[6]);
        $address->setCity($data[7]);
        $address->setState($data[8]);
        $address->setZipCode($data[9]);
        $address_id = $address->save();   
        //Now save participant phone number
        $phone->reset();
        $phone->setPhoneNumber($data[5]);
        $phone_id = $phone->save();
        //Now associate participant to address
        $user_address->reset();
        $user_address->setParticipantId($member_id);
        $user_address->setAddressId($address_id);
        $user_address->save();
        //And then associate participant to phone number
        $user_phone->reset();
        $user_phone->setParticipantId($member_id);
        $user_phone->setPhoneNumberId($phone_id);
        $user_phone->save();
        //Return an array of the keys created during this process
        return [
            'member_id'=>$member_id,
            'address_id'=>$address_id,
            'phone_number_id'=>$phone_id
        ];
    }
    
    /**
     * For the provider credentialing process, this saves an attachment into a particular directory
     */
    public function handleAttachment() {
        $attachment = $this->getAttachment();
        $file       = $this->getAttachmentFile();
        $root       = Environment::getRoot('argus');
        $id         = $this->getId();
        if (isset($file['path'])) {
            $provider_form = Argus::getEntity('argus/provider_registration_forms')->setId($id);
            $provider_data = $provider_form->load();
            $dest_dir      = $root.'/lib/providers/'.$provider_data['form_id'].'/'.$attachment;
            @mkdir($dest_dir,0775,true);
            file_put_contents($dest_dir.'/'.$file['name'],file_get_contents($file['path']));
            $attach_file    = Argus::getEntity('argus/provider_registration_form_attachments');
            $attach_file->setFormId($id)->setField($attachment)->setAttachment($file['name'])->save();
        }
    }
    
    /**
     * If an attachment is found, determine mime type and output file directly
     */
    public function outputProviderAttachment() {
        $id      = $this->getId();
        $field   = $this->getField();
        $root    = Environment::getRoot('argus');
        $data    = Argus::getEntity('argus/provider_registration_forms')->setId($id)->load();
        $attach  = Argus::getEntity('argus/provider_registration_form_attachments')->setFormId($id)->setField($field)->load(true);
        $file    = $root.'/lib/providers/'.$data['form_id'].'/'.$field.'/'.$attach['attachment'];
        if (file_exists($file)) {
           if ($a_mime_is_a_terrible_thing_to_waste = mime_content_type($file)) {
               header('Content-Type: '.$a_mime_is_a_terrible_thing_to_waste);
               Argus::response(file_get_contents($file));
           }
        };
    }
    
    /**
     * Creates a PIN (Personal Identification Number) of a particular length, determined by the value passed in
     * 
     * @param type $number_of_digits
     * @return string
     */
    public function createPin($number_of_digits=4) {
        $pin = '';
        if ((int)$number_of_digits) {
            $digits = '0123456789';
            for ($i=0; $i<(int)$number_of_digits; $i++) {
                $pin .= substr($digits,rand(0,9),1);  
            }
        }
        return $pin;
    }
}