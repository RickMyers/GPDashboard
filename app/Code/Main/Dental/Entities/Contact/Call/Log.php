<?php
namespace Code\Main\Dental\Entities\Contact\Call;
use Argus;
use Log as ArgusLog;
use Environment;
/**
 * 
 * Call Log Queries
 *
 * See Title
 *
 * PHP version 7.0+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @since      File available since Release 1.0.0
 */
class Log extends \Code\Main\Dental\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }
    
    /**
     * Returns a dataset of all HEDIS call comments plus information about who left the comment
     * 
     * @return iterator
     */
    public function fullComments($contact_id = false) {
        $contact_id = ($contact_id) ? $contact_id : $this->getContactId();
        $contacts   = [];
        if ($contact_id) {
            $query = <<<SQL
                SELECT a.comments, a.user_id, a.contact_id, a.attempt, a.modified, a.time_of_call, a.user_id, b.first_name, b.last_name, b.gender
                  FROM dental_contact_call_log AS a
                  LEFT OUTER JOIN humble_user_identification AS b
                    ON a.user_id = b.id
                 WHERE a.contact_id = '{$contact_id}'                
SQL;
            $contacts = $this->query($query);
        }
        return $contacts;
    }
}