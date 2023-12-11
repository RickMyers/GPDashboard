<?php
namespace Code\Main\Scheduler\Entities\Event;
use Argus;
use Log;
use Environment;
/**
 *
 * Scheduler Event Type Methods
 *
 * see title
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Types.html
 * @since      File available since Release 1.0.0
 */
class Types extends \Code\Main\Scheduler\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    public function userEventTypes($user_id=false) {
        $user_id = ($user_id) ? $user_id : ($this->getUserId() ? $this->getUserId() : Environment::whoAmI());
        $query = <<<SQL
            SELECT b.id, b.namespace, b.type, b.description, b.resource
              FROM scheduler_event_roles AS a
              LEFT OUTER JOIN scheduler_event_types AS b
                ON a.event_type_id = b.id
             WHERE a.id IN (
            SELECT role_id
              FROM argus_user_roles
              WHERE user_id = '{$user_id}')
              UNION 
              SELECT id, namespace, `type`, description, resource
              FROM scheduler_event_types
               WHERE namespace = 'Default'                
SQL;
        return $this->query($query);
    }
}