<?php
namespace Code\Main\Vision\Entities\Missing;
use Argus;
use Log;
use Environment;
/**
 *
 * Missing Member Queries
 *
 * See Title
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
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
     * 
     * 
     * @param boolean $useKeys
     * @return iterator
     */
    public function fetch($useKeys=false) {
        $query = <<<SQL
            SELECT a.event_id, a.health_plan_id, a.member_number, a.first_name, a.last_name,
                a.id,
                c.client
              FROM vision_missing_members AS a
#              LEFT OUTER JOIN vision_members AS b
#                ON a.health_plan_id = b.health_plan_id
#               AND a.member_number = b.member_number
              LEFT OUTER JOIN vision_clients AS c
                ON a.health_plan_id = c.id
SQL;
        return $this->query($query);
    }
    
    /**
     * 
     * @param string $field
     * @param string $text
     * @return iterator
     */
    public function search($field=false,$text=false) {
        $search = $this->getSearch();
        $query = <<<SQL
            SELECT *
              FROM vision_missing_members
             WHERE member_number LIKE '{$search}%'
                OR first_name LIKE '%{$search}%'
                OR last_name LIKE '%{$search}%'
SQL;
        return $this->query($query);
    }
}