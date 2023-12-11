<?php
namespace Code\Main\Vision\Entities\Ipa\Group;
use Argus;
use Log;
use Environment;
/**
 *
 * IPA Group Member Queries
 *
 * see title
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Framework
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2007-Present, Rick Myers <rick@humbleprogramming.com>
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
     * Returns a list of members in a particular IPA group
     * 
     * @param type $group_id
     * @return type
     */
    public function list($group_id=false) {
        $results = [];
        if ($group_id = ($group_id) ? $group_id : (($this->getGroupId()) ? $this->getGroupId() : (($this->getId()) ? $this->getId() : false))) {
            $query = <<<SQL
               select a.*, b.ipa
                 from vision_ipa_group_members as a
                 left outer join vision_ipas as b
                   on a.ipa_id = b.id
                where a.group_id = '{$group_id}'
SQL;
            $results = $this->query($query);
        }
        return $results;
    }
}