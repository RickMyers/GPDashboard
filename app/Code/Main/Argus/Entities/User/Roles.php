<?php
namespace Code\Main\Argus\Entities\User;
use Argus;
use Log;
use Environment;
/**
 *
 * Argus User Roles
 *
 * User Role Queries
 *
 * PHP version 5.6+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @since      File available since Release 1.0.0
 */
class Roles extends \Code\Main\Argus\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Returns a list of users based on the role they have... in this case, the role is spelled out in text (i.e. "Super User", rather than a number)
     *
     * @param string $role_name
     * @return iterator
     */
    public function getUsersByRoleName($role_name = false) {
        $results    = [];
        $role_name  = ($role_name) ? $role_name : $this->getRoleName();
        if ($role_name) {
            $query = <<<SQL
                SELECT a.user_id,
                       b.user_name, b.password, b.email, b.authenticated, b.security_token, b.reset_password_token, b.authentication_token, b.logged_in, b.account_status, b.login_attempts,
                       e.appellation_id, c.first_name, c.last_name, c.middle_name, c.name_suffix, c.maiden_name, c.use_preferred_name, c.preferred_name,  c.gender, c.date_of_birth,
                       d.appellation
                  FROM argus_user_roles AS a
                 INNER JOIN humble_users AS b
                    ON a.user_id = b.uid
                 INNER JOIN humble_user_identification AS c
                    ON b.uid = c.id
                 LEFT OUTER JOIN argus_user_appellations AS e
                    ON a.user_id = e.user_id
                 LEFT OUTER JOIN argus_appellations AS d
                    ON e.appellation_id = d.id
                 WHERE a.role_id = (SELECT id FROM argus_roles WHERE `name` = '{$role_name}')
                 order by last_name, first_name
SQL;
            $results = ($this->_polyglot()) ? $this->with('humble/user/identification')->on('user_id')->query($query) : $this->query($query);
        }
        return $results;
    }

    /**
     * Returns a list of users based on the role they have
     *
     * @param int $role_type
     * @return iterator
     */
    public function getUsersByRoleId($role_id = false) {
        $results    = [];
        $role_id    = ($role_id) ? $role_id : $this->getRoleId();
        if ($role_id) {
            $query = <<<SQL
                SELECT a.user_id,
                        b.user_name, b.password, b.email, b.authenticated, b.security_token, b.reset_password_token, b.authentication_token, b.logged_in, b.account_status, b.login_attempts,
                        e.appellation_id, d.appellation, c.first_name, c.last_name, c.middle_name, c.name_suffix, c.maiden_name, c.use_preferred_name, c.preferred_name, c.entity, c.gender, c.date_of_birth
                  FROM argus_user_roles AS a
                 INNER JOIN humble_users AS b
                    ON a.user_id = b.uid
                 INNER JOIN humble_user_identification AS c
                    ON b.uid = c.id
                 LEFT OUTER JOIN argus_user_appellations AS e
                    ON a.user_id = e.user_id
                 LEFT OUTER JOIN argus_appellations AS d
                    ON e.appellation_id = d.id                    
                 WHERE a.role_id = '{$role_id}'
SQL;
            $results = $this->query($query);
        }
        return $results;
    }
    
    /**
     * Just a relay function because I keep forgetting the actual name
     * 
     * @param string $role
     * @return iterator
     */
    public function usersWithRoleName($role=false) {
        $results = [];
        if ($role) {
            $results = $this->getUsersByRoleName($role);
        }
        return $results;
    }

    /**
     * Just a relay function because I keep forgetting the actual name
     * 
     * @param string $role
     * @return iterator
     */
    public function usersWithRoleId($role_id=false) {
        $results = [];
        if ($role_id) {
            $results = $this->getUsersByRoleId($role_id);
        }
        return $results;
    }
    /**
     * List anyone or anything that doesn't have a role, thus likely a dead account
     * 
     * @return type
     */
    public function usersWithoutAnyRoles() {
        $query = <<<SQL
            SELECT a.uid, CONCAT(b.first_name, ' ', b.last_name) AS `Name`, a.user_name, COALESCE(c.roles,0) AS roles, d.ipa, d.legacy, 'Yes' as Agree
              FROM humble_users AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.uid = b.id
              left outer join vision_ipas as d
                on a.uid = d.user_id
              LEFT OUTER JOIN (
                    SELECT user_id, COUNT(role_id) AS roles
                      FROM argus_user_roles
                      GROUP BY user_id) AS c
                ON a.uid = c.user_id
             HAVING roles = 0                
SQL;
        return $this->query($query);
    }
    /**
     * List of roles by id that I have
     * 
     * @return iterator
     */
    public function myRoles() {
        $user_id = Environment::whoAmI();
        $query = <<<SQL
            select distinct role_id
              from argus_user_roles
             where user_id = '{$user_id}'
SQL;
        return $this->query($query);
    }
   
    /**
     * Returns if a user has a particular role.  It will accept a passed user_id, a magic method user_id, if it can't resolve who from that, will use who ever is logged in
     * 
     * @param string $role_name
     * @return boolean
     */
    public function userHasRole($role_name = false,$user_id=false) {
        $role_name  = ($role_name) ? $role_name : $this->getRoleName();
        $results    = [];
        if ($role_name) {
            if (!$user_id) {
                $user_id    = ($this->getUserId()) ? $this->getUserId() : Environment::whoAmI();
            }
            $query = <<<SQL
                    SELECT id, user_id, role_id
                      FROM argus_user_roles 
                     WHERE role_id = (SELECT id FROM argus_roles WHERE `name` = '{$role_name}')
                      and user_id = '{$user_id}'
SQL;
            $results = $this->query($query)->toArray();
        }
        return (count($results) > 0);
    }
    
    /**
     * Returns the users who have a particular role
     * 
     * @return type
     */
    public function usersWithRole($role_id=false) {
        $role_name = $this->getRoleName();                                      //someday allow for them to pass the role name instead of the numeric ID
        $role_id   = ($role_id) ? $role_id : $this->getRoleId();
        $query      = <<<SQL
             select a.user_id, concat(b.last_name,', ',b.first_name) as name
               from argus_user_roles as a
               left outer join humble_user_identification as b
                 on a.user_id = b.id
              where a.role_id = '{$role_id}'
SQL;
        return $this->query($query);
    }

    public function canAccess() {
        
    }
    
    public function hasRole() {
        return json_encode([ "role" => $this->userHasRole($this->getRole()) ]);
    }
    
    /**
     * You are logged in and you have the role of "Application Reviewer" or are a system administrator
     * 
     * @return boolean
     */
    public function canViewSubmittedRegistrationForms() {
        //possibly allow the submitter to review their data... since they don't have an ID, do what?  Make them register? Decisions....
        return ($this->getUserId() && ($this->userHasRole('Application Reviewer') || $this->userHasRole('System Administrator')));
    }

    /**
     * You are logged in and you have the role of "Application Reviewer" or are a system administrator
     * 
     * @return boolean
     */    
    public function canViewArchivedRegistrationForms() {
        return ($this->getUserId() && ($this->userHasRole('Application Reviewer') || $this->userHasRole('System Administrator')));
    }
}