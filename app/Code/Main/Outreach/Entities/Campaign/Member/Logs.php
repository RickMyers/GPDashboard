<?php
namespace Code\Main\Outreach\Entities\Campaign\Member;
use Argus;
use Log;
use Environment;
/**
 *
 * Campaign Member Logs queries
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Entity
 * @package    Desktop
 * @author     Rick Myers rmyers@argusdentalvision.com
 */
class Logs extends \Code\Main\Outreach\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Returns all log information related to contact along with the authors name
     * 
     * @param type $contact_id
     * @return iterator
     */
    public function review($contact_id=false) {
        $results = [];
        if ($contact_id = ($contact_id) ? $contact_id : ($this->getContactId() ? $this->getContactId() : false)) {
            $query = <<<SQL
               select a.*, concat(b.first_name,' ',b.last_name) as author
                 from outreach_campaign_member_logs as a
                 left outer join humble_user_identification as b
                   on a.user_id = b.id
                where a.contact_id = '{$contact_id}'
SQL;
            $results = $this->query($query);
        }
        return $results;
    }
}