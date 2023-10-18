<?php
namespace Code\Main\Argus\Entities;
use Argus;
use Log;
use Environment;
/**
 * 
 * Argus User related queries
 *
 * This is a class that represents what a user from the Argus perspective
 *
 * PHP version 5.5+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @since      File available since Release 1.0.0
 */
class User extends Entity
{

    public function __construct() {
        parent::__construct();
    }
    /**
     * Don't use this until I can get some things sorted out with building the field of things to search on
    public function load($nonkeys=false) {
        $query = <<<SQL
            SELECT a.user_name, a.password, a.email, a.authenticated, a._password_token, a.change_password_token, a.authentication_token, a.account_status, a.login_attempts,
                   b.appellation_id, b.first_name, b.last_name, b.middle_name, b.name_suffix, b.maiden_name, b.use_preferred_name, b.preferred_name, b.entity, b.gender, b.date_of_birth
              FROM humble_users AS a
             INNER JOIN humble_user_identification AS b
                ON a.uid = b.id
SQL;
        $query .= $this->buildWhereClause($nonkeys);
        $query .= $this->buildOrderByClause();
        return $this->query($query);
    }
    */
    
    public function userData($user_id = false) {
        $data = [];
        if ($user_id = ($user_id) ? $user_id : ($this->getUserId() ? $this->getUserId() : false)) {
            $query = <<<SQL
            SELECT c.entity AS entity_name, a.user_name, a.password, a.email, a.authenticated, a.reset_password_token, a.security_token, a.authentication_token, a.account_status, a.login_attempts, a.logged_in,
                   a.uid as id, e.appellation, d.appellation_id, b.first_name, COALESCE(b.last_name,c.entity) AS last_name, b.middle_name, b.name_suffix, b.maiden_name, b.use_preferred_name, b.preferred_name, b.gender, b.date_of_birth
              FROM humble_users AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.uid = b.id
              LEFT OUTER JOIN argus_user_entities AS c
                ON a.uid = c.user_id
              LEFT OUTER JOIN argus_user_appellations AS d
                ON a.uid = d.user_id
              LEFT OUTER JOIN argus_appellations AS e
                ON d.appellation_id = e.id
              where a.uid = '{$user_id}'
                limit 1
SQL;
              $data = $this->query($query)->toArray();
        }
        $d = $data ? $data[0] : $data;
        return $d;
    }
    
    /**
     * 
     * 
     * @param type $useKeys
     * @return type
     */
    public function fetchData($useKeys=false) {
        $starts_clause = ($this->getStartsWith()) ? "and last_name like '".$this->getStartsWith()."%' or entity like '".$this->getStartsWith()."%'" : "";
        $role_clause   = ($this->getRoleId()) ? " INNER JOIN argus_user_roles AS f ON a.uid = f.user_id AND f.role_id = '".$this->getRoleId()."'" : "";
        $query = <<<SQL
            SELECT c.entity AS entity_name, a.user_name, a.password, a.email, a.authenticated, a.reset_password_token, a.security_token, a.authentication_token, a.account_status, a.login_attempts,
                   a.uid as id, e.appellation, d.appellation_id, b.first_name, COALESCE(b.last_name,c.entity) AS last_name, b.middle_name, b.name_suffix, b.maiden_name, b.use_preferred_name, b.preferred_name, b.gender, b.date_of_birth
              FROM humble_users AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.uid = b.id
              LEFT OUTER JOIN argus_user_entities AS c
                ON a.uid = c.user_id
              LEFT OUTER JOIN argus_user_appellations AS d
                ON a.uid = d.user_id
              LEFT OUTER JOIN argus_appellations AS e
                ON d.appellation_id = e.id
             {$role_clause}
             where a.uid is not null
              {$starts_clause}
SQL;
        return $this->with('humble/user/identification')->on('id')->query($query);
    }
    
    /**
     * Tries to deduce an available username
     * 
     * @param type $name
     * @return type
     */
    public function fetchUserName($name) {
        $basename   = '';
        $parts      = explode(' ',str_replace(["'","-"],[""," "],$name));
        for ($i=0; $i<(count($parts)-1); $i++) {
            $basename .= substr(strtolower($parts[$i]),0,1);
        }
        $basename   .= strtolower($parts[count($parts)-1]);
        $user        = Argus::getEntity('humble/users');
        $user_exists = false; $attempts = 1; $username = $basename;
        //somewhere in here account for more than a first and last name... like a hyphenated name
        do {
            if ($user_exists = count($user->reset()->setUserName($username)->load(true))) {
                $username = $basename.$attempts;
            } 
        } while ($user_exists && (++$attempts < 50));        
        
        return ($user_exists) ? null : $username;
    }
    
    /**
     * Will take a user id (uid) and a password already in MD5 format and update the users password
     * 
     * @param int $user_id
     * @param string $md5_password
     */
    public function updatePassword($user_id=false,$md5_password=false) {
        $user   = Argus::getEntity('humble/users');
        $cpwd   = $this->getCurrentPassword()   ? $this->getCurrentPassword() : false;
        $uid    = $user_id ? $user_id           : ($this->getUid()  ? $this->getUid()  : '');
        $pwd    = $md5_password ? $md5_password : ($this->getPassword()  ? $this->getPassword()  : false);
        if ($cpwd) {
            if ($data = $user->setUid($uid)->load()) {
                $t = crypt($cpwd,$data['salt']);
                if ($data['password'] !== crypt($cpwd,$data['salt'])) {
                    return 'The current password entered is incorrect';
                }
            } else {
                return 'Error encountered while checking the existing password';
            }
            
        }
        if ($uid && $pwd) {
            $salt   = $user->salt();
            $pwd    = crypt($pwd,$salt);
            $x      = $user->reset()->setUid($uid)->setSalt($salt)->setPassword($pwd)->save();
            return 'Password Changed';
        }
    }
}