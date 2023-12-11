<?php
namespace Code\Main\Vision\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * Test for Queue to help with display of archive event date
 *
 * see short
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Client
 * @author     Aaron Binder abinder@aflacbenefitssolutions.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Queue.html
 * @since      File available since Release 1.0.0
 */
class Forms extends Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }
    
    /**
     * Very basic search on the full members name and/or the member id
     * 
     * @return iterator
     */
    public function search($stuff=false,$text=false) {
        $query = <<<SQL
             SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.event_date,
                    b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender,
                    concat(c.first_name,' ',c.last_name) as technician_name, a.last_action
              FROM vision_consultation_forms AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.created_by = b.id
              left outer join humble_user_identification as c
                on a.technician = c.id                    
            
SQL;
        return $this->query($query);
    }

}