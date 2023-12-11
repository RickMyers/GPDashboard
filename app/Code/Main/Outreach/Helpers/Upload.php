<?php
namespace Code\Main\Outreach\Helpers;
use Argus;
use Log;
use Environment;
/**
 *
 * Member Upload methods
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Utility
 * @package    Dashboard
 * @author     Rick Myers rmyers@aflacbenefitssolutions.com
 */
class Upload extends Helper
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
     * Map an arbitrary list of fields and members to our internal outreach table
     */
    public function members() {
       if ($member_list = $this->getMemberList()) {
           $members  = Argus::getHelper('outreach/CSV')->toHashTable($member_list['path']);
           if ($xref = (($mappings = $this->getMapFile()) && isset($mappings['path']) && $mappings['path']) ? json_decode($mappings['path'],true) : json_decode(file_get_contents('../documents/outreach/upload_mapping.json'),true)) {
               $orm = Argus::getEntity('outreach/campaign/members');
               foreach ($members as $member) {
                   $orm->reset()->setCampaignId($this->getCampaignId())->setDateAdded(date('Y-m-d'));
                   foreach ($xref as $field => $map) {
                        if (is_array($map)) {
                            $value = '';
                            foreach ($map as $comp) {
                                $value .= (isset($member[$comp]) && $member[$comp]) ? ($value ? ', ': '').$member[$comp] : ''; 
                            } 
                        } else {
                            $value = isset($member[$map]) ? $member[$map] : '';
                        }
                        $method = 'set'.$this->underscoreToCamelCase($field,true);
                        $orm->$method($value);
                   } 
                   $orm->save();                   
               }
               Argus::emit('campaign'.$this->getCampaignId().'MemberListUploaded');
           }
       }
    }

}