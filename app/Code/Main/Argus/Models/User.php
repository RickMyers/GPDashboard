<?php
namespace Code\Main\Argus\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Argus User Related Actions
 *
 * User related actions
 *
 * PHP version 5.6+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @since      File available since Release 1.0.0
 */
class User extends Model
{

    use \Code\Base\Humble\Event\Handler;

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
     * Creates a new user fetching a unique user name and sends a notification via E-mail when complete
     * 
     * @workflow use(EVENT)
     * @return string
     */
    public function newUser() {
        $user_name   = Argus::getEntity('argus/user')->fetchUserName($this->getFirstName()." ".$this->getLastName());
        $humble_user = Argus::getEntity('humble/users')->setUserName($user_name)->setSalt($this->_uniqueId(true))->setResetPasswordToken($this->_token(8));
        $humble_user->setEmail($this->getEmail())->setPassword(crypt($this->getPassword(),$humble_user->getSalt()));
        
        $pde = new \DateTime();
        $pde->modify('+3 months');
        $pde->format('d');
        if ($uid = $humble_user->save()) {
            $argus_user = Argus::getEntity('humble/user/identification')->setId($uid)->setFirstName($this->getFirstName())->setLastName($this->getLastName())->setGender($this->getGender())->setPde($pde)->save();
            Argus::getEntity('argus/user/settings')->setId($uid)->save();
        }
        $body = "The User Name ".$user_name." was assigned to ".$this->getFirstName().' '.$this->getLastName().'.'; 
        $this->trigger(
                "newUserCreated",
                __CLASS__,
                __METHOD__,
                [
                    "user_name" => $user_name,
                    "uid" => $uid,
                    "user_email" => $this->getEmail(),
                    "subject" => "HEDIS: User Account Created",
                    "body" => $body,
                    "created_by" => Environment::whoAmIReally(),
                    "created" => date("Y-m-d H:i:s")
                ]
        );
        return $body;
    }
    
    /**
     * Ends the session
     */
    public function logout() {
        session_unset();
        session_destroy();
        //you could also now calculate time in the system by subtracting the 'last logged in' time from current time and storing it somewhere
    }
    
    /**
     * 
     */
    public function passwordReset() {
        $password   = $this->getPassword();
        $user_id    = $this->getUserId();
        Argus::getEntity('humble/users')->setUid($user_id)->setPassword($password)->setResetPasswordToken($this->_uniqueId())->updatePassword();
    }
    
    /**
     * Sets the new password value if the email and reset_password_token or security_token match up
     *
     * @return boolean
     */
    public function newPassword() {
        $changed  = false;
        $salt     = $this->_uniqueId(true);
        $password = $this->getPassword();
        $confirm  = $this->getConfirm();
        $user = Argus::getEntity('humble/users');
        if ($res_token = $this->getResetPasswordToken()) {
            $user->setResetPasswordToken($res_token);
        } else if ($sec_token = $this->getSecurityToken()) {
            $user->setSecurityToken($sec_token);
        }
        if (count($user->load(true)) && $password && ($password == $confirm)) {
            $user->setSalt($salt)->setPassword(crypt($password,$salt));
            $user->setSecurityToken(null)->setResetPasswordToken(null);
            $user->setAccountStatus(USER_ACCOUNT_UNLOCKED);
            $user->setLoginAttempts(0);
            $user->save();
            $changed = true;
            if ($this->getNextPage()) {
                header('location: '.$this->getNextPage().'?message=Successful Password Change!  Please Login');
            }
        }
        return $changed;
    }    
    
    /**
     * Sends the user the recover password process
     *
     * @workflow use(event)
     */
    public function recoverPasswordEmail() {
        $user  = Argus::getEntity('humble/users');
        $email = $this->getEmail();
        $data  = $user->setEmail($email)->load(true);
        $result = false;
        if ($data) {
            $user_data = Argus::getEntity('humble/user/identification')->setId($data['uid'])->load();
            $token = '';
            for ($i=0; $i<16; $i++) {
                $token .= rand(0,1) ? chr(rand(ord('a'),ord('z'))) : chr(rand(ord('A'),ord('Z'))) ;
            }
            $user->setSecurityToken($token);
            $user->save();
            $rain = Environment::getInternalTemplater(getcwd().'/lib/resources/email/templates/');
            $template = Argus::emailTemplate('reset_password');
            $rain->assign('token',$token);
            $rain->assign('email',$email);
            $rain->assign('name',$user_data['first_name'].' '.$user_data['last_name']);
            $rain->assign('host',Environment::getHost());
            $emailer = Argus::getModel('argus/email');
            $result = $emailer->sendEmail($email,'HEDIS Portal Reset Password',$rain->draw($template,true),"support@aflacbenefitssolutions.com","noreply@aflacbenefitssolutions.com");            
        }
        $this->trigger('recover-password-email-sent',__CLASS__,__METHOD__,array('email'=>$email,'result'=>$result,"sent"=>date('Y-m-d H:i:s')));
        return $result;
    }

    /**
     * Returns true if there's a recover password token and user email that matches
     *
     * @return type
     */
    public function isLegitimate() {
        $user  = Argus::getEntity('humble/users')->setSecurityToken($this->getSecurityToken())->setEmail($this->getEmail())->load(true);
        return (isset($user['uid']) ? true : false);
    }

    /**
     * A new user is registered.  We also calculate the user name for them based on their first initial and last name, and a number if necessary
     * 
     * @workflow use(event)
     * @return boolean
     */
    public function register() {
        $username   = ''; $ctr = '';
        $first_name = $this->getFirstName();
        $last_name  = $this->getLastName();
        $preferred  = $this->getNickName();
        $basename   = strtolower(substr($first_name,0,1).$last_name);
        $potential_user = Argus::getEntity('humble/users');
        while (!$username && ($ctr<100)) {
            $potential_user->reset();
            $d      = $potential_user->setUserName($basename.$ctr)->load(true); //Lets check to see if somebody already has this user name
            if (!$d) {
                $this->setUserName($username = $basename.$ctr);
            }
            (int)$ctr++;                                                        //this is a hack... it will cast an empty string into a 0... Nifty!
        }
        if ($username && ($this->getPassword() == $this->getConfirm())) {
            $pde = new DateTime();
            $pde->modify('+3 months');
            $pde->format('d');
            $user_id = Argus::getEntity('humble/user_identification')->setId($potential_user->reset()->setUserName($username)->setEmail($this->getEmail())->setPassword($this->getPassword())->save())->setFirstName($first_name)->setLastName($last_name)->setPreferredName($preferred)->setUsePreferredName(($preferred ? "Y" : "N"))->setPde($pde)->save();
        }
        $this->trigger('newUserRegister',__CLASS__,__METHOD__,[
            'email'             => $this->getEmail(),
            'user_id'           => $user_id,
            'first_name'        => $first_name,
            'last_name'         => $last_name,
            'preferred_name'    => $preferred,
            'user_name'         => $username,
            'password'          => $this->getPassword(),
            'registered'        => date('Y-m-d H:i:s')
        ]);
        header('Location: /index.html?m=Thank you for registering, your user name is '.$username.'.  Please use that to log in');
        return ($username !== '');
    }
    
    public function update() {
        $data = $this->getData();
        $core = Argus::getEntity('humble/users')->setUid($data['user_id']);
        $core->load();
        if ($data['account_status'] == '') {
            $core->setLoginAttempts(0);
        }
        $core->setAccountStatus($data['account_status']);
        $core->setEmail($data['email']);
        $core->save();
        $user = Argus::getEntity('humble/user/identification')->setId($data['user_id']);
        $user->load();
        $user->setFirstName($data['first_name']);
        $user->setLastName($data['last_name']);
        $user->setMiddleName($data['middle_name']);
        $user->setPreferredName($data['preferred_name']);
        $user->setGender($data['gender']);
        $user->setDateOfBirth($data['date_of_birth']);
        $user->save();
        if (isset($data['appellation_id']) && $data['appellation_id']) {
            Argus::getEntity('argus/user/appellations')->setUserId($data['user_id'])->setAppellationId($data['appellation_id'])->save();
        }        
    }
    
    /**
     * Displays as JSON some of the fields stored in the session if the user has the correct role for accessing the web service API
     * 
     * @workflow use(process)
     */
    public function echoLoginCredentials($EVENT=false) {
        if ($EVENT!==false) {
            $user = \Argus::getEntity('humble/user/identification')->setId($_SESSION['uid'])->load();
//            session_regenerate_id();
            $_SESSION['began'] = isset($_SESSION['began']) ? $_SESSION['began'] : strtotime('now');
            $response = [
                "RC"            => "0",          "UID" => $_SESSION['uid'],
                "sessionId"     => session_id(), "message"       => 'Login Successful',
                "session_start" => date("Y-m-d H:i:s",$_SESSION['began']),
                "user"          => $user['last_name'].', '.$user['first_name']                
            ];
            if (!Argus::getEntity('argus/user/roles')->userHasRole('Webservice Access')) {
                $response['RC']         = '16';
                $response['sessionId']  = false;
                $response['error']      = 'User lacks required role to access webservices api';
                $response['remedy']     = "Admin needs to add role of 'Webservice Access' to user";
                unset($response['session_start']);
            }
            print(json_encode($response));
        }
    }
    
    /**
     * Will calculate the users actual user id and then use that to retrieve the users api key and compare them returning true if they match
     * 
     * @workflow use(decision)
     * @param type $EVENT
     */
    public function apiKeyValidated($EVENT=false) {
        $valid = false;
        if ($EVENT!==false) {
            if ($data = $EVENT->load()) {
                if (isset($data['api_key'])) {
                    $user = Argus::getEntity('humble/user/identification')->setId(10980 - $data['api_user_id'])->load();
                    if (isset($user['api_key'])) {
                        if ($valid = ($data['api_key'] == $user['api_key'])) {
                            session_start();
                            $_SESSION['uid'] = $user['uid'] = $user['id'];
                            $_SESSION['user'] = $user;
                            $EVENT->update(['user'=>$user]);
                        }
                    }
                }
            }
        }
        return $valid;
    }
    
    /**
     * Displays a JSON based error for when a person passes in an invalid session id
     * 
     * @workflow use(process)
     * @param type $EVENT
     */
    public function echoInvalidLogin($EVENT=false) {
        if ($EVENT!==false) {
            Argus::response(json_encode([
                "RC" => '12',
                "message" => "Credentials Incorrect",
                "remedy" => "Correct user_name and/or password"
            ]));
        }        
    }
    
    /**
     * Will return true if, using either a user name or an email, the password matches with what is stored
     * 
     * @workflow use(DECISION)  configuration(/argus/user/login)
     * @param type $EVENT
     */
    public function loginSuccessful($EVENT=false) {
        $result = false;
        if ($EVENT!==false) {
            $data   = $EVENT->load();
            $cfg    = $EVENT->fetch();
            if ((isset($data[$cfg['source_field']]) && $data[$cfg['source_field']]) && (isset($data[$cfg['password_field']]) && $data[$cfg['password_field']])) {
                if (isset($data[$cfg['node_field']])) {
                    $result = crypt($data[$cfg['password_field']],$data[$cfg['node_field']]['salt']) === $data[$cfg['node_field']]['password'];
                }
            }
        }
        if ($result) {
            session_start();
            $_SESSION['uid']    = $data[$cfg['node_field']]['uid'];
            $_SESSION['began']  = time();
            $_SESSION['login']  = $data[$cfg['node_field']]['uid']; //This is the id that was actually authenticated... it lets admins jump around posing as other users
            $_SESSION['user']   = $data[$cfg['node_field']];
        }
        return $result;
    }
    /**
     * Will lookup a user either using the email or username and attach it to the event
     * 
     * @workflow use(PROCESS) configuration(/argus/user/information)
     * @param type $EVENT
     */
    public function attachUserInformation($EVENT=false) {
        if ($EVENT!==false) {
            $data   = $EVENT->load();
            $cfg    = $EVENT->fetch();
            if (isset($data[$cfg['source']]) && $data[$cfg['source']]) {
                $u = (filter_var($data[$cfg['source']], FILTER_VALIDATE_EMAIL)? Argus::getEntity('humble/users')->setEmail($data[$cfg['source']])->load(true) : Argus::getEntity('humble/users')->setUserName($data[$cfg['source']])->load(true) );
                $EVENT->update([$cfg['field']=>$u]);
            }
            $EVENT->update([
                'login_page' => '/index.html'
            ]);
            
        }
    }
    
    /**
     * Adds one to the number of times you've tried to login without success
     *
     * @param type $EVENT
     * @workflow use(process) configuration(/argus/user/increment)
     */
    public function incrementTries($EVENT=false) {
        if ($EVENT!==false) {
            $data   = $EVENT->load();
            $cfg    = $EVENT->fetch();
            if (isset($data[$cfg['node']])) {
                $user   = Argus::getEntity('humble/users')->setUserName($data[$cfg['node']][$cfg['field']]);
                if (count($user->load(true))) {
                    $user->setLoginAttempts($user->getLoginAttempts()+1)->save();
                }
            } else {
                //throw an exception for insufficient data
            }
        }
    }
    
    /**
     * Determines if a user has a specific role, specified by the name of the role in the configuration page
     * 
     * @workflow use(decision) configuration(/argus/user/role)
     * @param type $EVENT
     */
    public function hasRole($EVENT=false) {
        $hasRole = false;
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            /*
             * First we check to see if we are checking the current user for role, or using a value from the EVENT that has the userid
             * Get Role
             */
            $user_id = $cfg['option']=='field' ? $data[$cfg['field']] : Environment::whoAmI(); 
            $hasRole = Argus::getEntity('argus/user_roles')->setId($user_id)->hasRole($cfg['role']);
        }
        return $hasRole;
    }
    
    /**
     * Will record the users IP address and related information if it is available
     * 
     * @workflow use(process) configuration(/argus/user/ipaddress)
     * @param type $EVENT
     */
    public function recordIpAddress($EVENT=false) {
        if ($EVENT!==false) {
            $data       = $EVENT->load();
            $cnfg       = $EVENT->fetch();
            $ip_address = $user_id = null; 
            if ($cnfg['ip_address_source'] == 'SERVER') {
                $ip_address = (isset($_SERVER['HTTP_CLIENT_IP']) && $_SERVER['HTTP_CLIENT_IP']) ? $_SERVER['HTTP_CLIENT_IP'] : ((isset($_SERVER['HTTP_X_FORWARDED_FOR']) && $_SERVER['HTTP_X_FORWARDED_FOR']) ? $_SERVER['HTTP_X_FORWARDED_FOR'] : $_SERVER['REMOTE_ADDR']);
            } else if (($cnfg['ip_address_source']=='FIELD') && (isset($data[$cnfg['ip_address_source_field']]))) {
                $ip_address = $data[$cnfg['ip_address_source_field']];
            }
            if ($cnfg['user_id_source'] == 'SESSION') {
                $user_id = Environment::whoAmIReally();
            } else if (($cnfg['user_id_source'] == 'field') && (isset($data[$cnfg['user_id_source_field']]))) {
                $user_id = $data[$cnfg['user_id_source_field']];
            }
            if ($user_id && $ip_address) {
                $record = Argus::getEntity('argus/user_ip_addresses')->setIpAddress($ip_address)->setUserId($user_id);
                $current = $record->load(true);
                $record->reset()->setIpAddress($ip_address)->setUserId($user_id)->setLastObserved(date('Y-m-d H:i:s'))->setObservations((isset($current['observations']) ? (int)$current['observations']+1 : 1))->save();
            }
        }
    }
    
    
    /**
     * Will route the user to a page where they can set their new password (which should be their first password)
     * 
     * @workflow use(process)
     * @param type $EVENT
     */
    public function forwardToResetPasswordPage($EVENT=false) {
        if ($EVENT!==false) {
            $data = $EVENT->load();
            if ($user = Argus::getEntity('humble/users')->setUid(Environment::whoAmIReally())->load()) {
                if (isset($user['reset_password_token']) && $user['reset_password_token']) {
                    header('location: /argus/user/newPasswordForm?token='.$user['reset_password_token'].'&clearReset=true&then='.(isset($data['login_page']) ? $data['login_page'] : '/index.html'));
                }
            }
        }
    }    
    
    /**
     * Will route the user to a page where they can set their new password (which should be their first password)
     * 
     * @workflow use(process)
     * @param type $EVENT
     */
    public function forwardToNewPasswordPage($EVENT=false) {
        if ($EVENT!==false) {
            $data = $EVENT->load();
            if ($user = Argus::getEntity('humble/users')->setUid(Environment::whoAmIReally())->load()) {
                if (isset($user['reset_password_token']) && $user['reset_password_token']) {
                    header('location: /argus/user/firstpassword?token='.$user['reset_password_token'].'&then='.(isset($data['login_page']) ? $data['login_page']:'/index.html'));
                }
            }
        }
    }
    
    /**
     * Will send you back to the login page, which is passed in on the event, to try again
     * 
     * @workflow use(process)
     * @param type $EVENT
     */
    public function invalidAttemptTryReLogin($EVENT=false) {
        if ($EVENT) {
            $data   = $EVENT->load();
            $cfg    = $EVENT->fetch();
            $msg    = isset($cfg['message']) ? $cfg['message'] : 'Invalid UserID Or Password';
            $login_page = isset($data['login_page']) ? $data['login_page']:'/index.html';
            header('location: '.$login_page.'?message='.$msg);
        }
    }
    
    /**
     * Will create a new password for the user with a matching security token
     * 
     * @return boolean type
     */
    public function createPassword() {
        $created    = false;
        $token      = $this->getToken();
        $password   = $this->getPassword();
        $confirm    = $this->getConfirm();
        if ($token && ($confirm === $password)) {
            $user = Argus::getEntity('humble/users');
            if (count($user->setNewPasswordToken($token)->load(true))) {
                $created = $user->setPassword($password)->setNewPasswordToken(null)->save();
            }
        }
        return $created;
    }
    
}