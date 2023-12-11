<?php
namespace Code\Main\Dashboard\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * Dashboard User Entity
 *
 * Really just a wrapper for humble/users
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Users.html
 * @since      File available since Release 1.0.0
 */
class User extends Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * A fake entity just to get some data for the Node.js signaling server
     * 
     * @return iterator
     */
    public function info() {
        $result = [];
        if ($uid = $this->getUid()) {
            $query = <<<SQL
                 select a.uid, user_name, first_name, last_name, email, gender, use_preferred_name, date_of_birth from humble_users as a
                   left outer join humble_user_identification as b
                     on a.uid = b.id
                  where a.uid = '{$uid}'
SQL;
            foreach ($result = $this->query($query) as $row) {
                if (file_exists('../images/argus/avatars/'.$uid.'.jpg')) {
                    $row['avatar'] = '/images/argus/avatars/'.$uid.'.jpg';
                } else {
                    $row['avatar'] = '/images/argus/placeholder-'.$row['gender'].'.png';
                }
                $result->set($row);
            };
        }
        return $result;
    }
}