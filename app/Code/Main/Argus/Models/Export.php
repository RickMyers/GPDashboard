<?php
namespace Code\Main\Argus\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Environment Export methods
 *
 * Based on a toolset I created at another company
 * 
 * see title
 *
 * PHP version 7.3+
 *
 * @category   Utility
 * @package    Dashboard
 * @author     Rick Myers <rmyers@argusdentalvision.com>
 * @copyright  2016-present Hedis Dashboard
 * @license    https://hedis.argusdentalvision.com/license.txt
 * @since      File available since Release 1.0.0
 */
class Export extends Model
{

    use \Code\Base\Humble\Event\Handler;

    private $namespace = [];

    private     $lorumText  = <<<GETTYSBURGADDRESS
Four score and seven years ago our fathers brought forth on this continent a new nation, conceived in liberty, and dedicated to the proposition that all men are created equal. Now we are engaged in a great civil war, testing whether that nation, or any nation so conceived and so dedicated, can long endure. We are met on a great battlefield of that war. We have come to dedicate a portion of that field, as a final resting place for those who here gave their lives that that nation might live. It is altogether fitting and proper that we should do this. But, in a larger sense, we can not dedicate, we can not consecrate, we can not hallow this ground. The brave men, living and dead, who struggled here, have consecrated it, far above our poor power to add or detract. The world will little note, nor long remember what we say here, but it can never forget what they did here. It is for us the living, rather, to be dedicated here to the unfinished work which they who fought here have thus far so nobly advanced. It is rather for us to be here dedicated to the great task remaining before us - that from these honored dead we take increased devotion to that cause for which they gave the last full measure of devotion - that we here highly resolve that these dead shall not have died in vain - that this nation, under God, shall have a new birth of freedom - and that government of the people, by the people, for the people, shall not perish from the earth. Four score and seven years ago our fathers brought forth on this continent a new nation, conceived in liberty, and dedicated to the proposition that all men are created equal. Now we are engaged in a great civil war, testing whether that nation, or any nation so conceived and so dedicated, can long endure. We are met on a great battlefield of that war. We have come to dedicate a portion of that field, as a final resting place for those who here gave their lives that that nation might live. It is altogether fitting and proper that we should do this. But, in a larger sense, we can not dedicate, we can not consecrate, we can not hallow this ground. The brave men, living and dead, who struggled here, have consecrated it, far above our poor power to add or detract. The world will little note, nor long remember what we say here, but it can never forget what they did here. It is for us the living, rather, to be dedicated here to the unfinished work which they who fought here have thus far so nobly advanced. It is rather for us to be here dedicated to the great task remaining before us - that from these honored dead we take increased devotion to that cause for which they gave the last full measure of devotion - that we here highly resolve that these dead shall not have died in vain - that this nation, under God, shall have a new birth of freedom - and that government of the people, by the people, for the people, shall not perish from the earth.
GETTYSBURGADDRESS;
    private     $redactChars = array('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
                                     'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
                                     '0','1','2','3','4','5','6','7','8','9');
    private     $redactChar =  array('#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#',
                                     '#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#','#',
                                     '#','#','#','#','#','#','#','#','#','#');
    private     $malesDB    = 'Code/Main/Argus/lib/data/males.txt';
    private     $femalesDB  = 'Code/Main/Argus/lib/data/females.txt';
    private     $usernames  = [];
    private     $userid     = null;
    private     $addresses  = [];
    private     $sAddresses = array(
        'FL' => 'Code/Main/Argus/lib/data/addresses-fl.txt',
        'NM' => 'Code/Main/Argus/lib/data/addresses-nm.txt',
        'SD' => 'Code/Main/Argus/lib/data/addresses-sd.txt'
    );
    private     $original   = [];   //original list of users based on login id
    private     $userids    = [];   //original list of userids pointing to their users, if any
    private     $current    = [];   //original data about the current user who is getting scrambled
    private     $currentId  = null;
    public      $_user      = null; //Entity object holding the current user
    private     $_username  = false;
    private     $_address   = [];
    private     $_collision = [];
    private     $_state     = '';
    private     $company    = 0;
    private     $phonenums  = [];
    private     $_exclusions = null;
    private     $_numerics  = [];
    private     $_member_id = [];
    private     $males      = [];
    private     $females    = [];
    private     $dir        = '';
    
    
    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
        $state = $this->getState() ? $this->getState() : 'FL';                  //default to Florida
        $this->_state($state);
        $this->resetFemales();
        $this->resetMales();
        $this->resetAddresses();
        $this->resetPhoneNumbers();        
    }

    /**
     * Required for Helpers, Models, and Events, but not Entities
     *
     * @return system
     */
    public function getClassName() {
        return __CLASS__;
    }
    
    private function _state($whichone=false) {
        if ($whichone) {
            $this->_state = $whichone;
            return $this;
        }
        return $this->_state;
    }
    private function wd_check_serialization( $string, &$errmsg ) {
        $str        = 's';
        $array      = 'a';
        $integer    = 'i';
        $any        = '[^}]*?';
        $count      = '\d+';
        $content    = '"(?:\\\";|.)*?";';
        $open_tag   = '\{';
        $close_tag  = '\}';
        $parameter  = "($str|$array|$integer|$any):($count)" . "(?:[:]($open_tag|$content)|[;])";
        $preg       = "/$parameter|($close_tag)/";
        if (!preg_match_all( $preg, $string, $matches ))    {
            $errmsg = 'not a serialized string';
            return false;
        }
        $open_arrays = 0;
        foreach ($matches[1] as $key => $value) {
            if (!empty($value) && (($value != $array) xor ($value != $str) xor ($value != $integer))) {
                $errmsg = 'undefined datatype';
                return false;
            }
            if ($value == $array) {
                $open_arrays++;
                if ($matches[3][$key] != '{') {
                    $errmsg = 'open tag expected';
                    return false;
                }
            }
            if ($value == '') {
                if ($matches[4][$key] != '}') {
                    $errmsg = 'close tag expected';
                    return false;
                }
                $open_arrays--;
            }
            if ($value == $str) {
                $aVar = ltrim($matches[3][$key], '"');
                $aVar = rtrim($aVar, '";');
                if (strlen( $aVar ) != $matches[2][$key]) {
                    $errmsg = 'stringlen for string not match';
                    return false;
                }
            }
            if ($value == $integer) {
                if (!empty( $matches[3][$key])) {
                    $errmsg = 'unexpected data';
                    return false;
                }
                if (!is_integer( (int)$matches[2][$key])) {
                    $errmsg = 'integer expected';
                    return false;
                }
            }
        }
        if ($open_arrays != 0){
            $errmsg = 'wrong setted arrays';
            return false;
        }
        return true;
    }    
    protected function resetFemales() {
        $this->females  = explode("\n",file_get_contents($this->femalesDB));
    }

    protected function resetMales() {
        $this->males    = explode("\n",file_get_contents($this->malesDB));
    }

    protected function resetPhoneNumbers() {
        $state          = $this->getState() ? $this->getState() : 'FL';
        $data           = explode("\n",file_get_contents($this->sAddresses[$state]));
        foreach ($data as $row) {
            $addr = explode(",", $row);
            $this->phonenums[] = $addr[5];
        }
    }

    protected function resetAddresses() {
        $state          = $this->getState() ? $this->getState() : 'FL';
        $data           = explode("\n",file_get_contents($this->sAddresses[$state]));

        /*have to get rid of blank lines in the file */
        foreach ($data as $row) {
            $row = trim($row);
            if ($row) {
                $this->addresses[$state][] = $row;
            }
        }
    }
    

    /**
     * For use when people have put strings where they should have put numbers
     *
     * @param type $val
     * @param type $ref
     * @return type
     */
    public function whenNotNumeric($val,$ref=false) {
        $val = trim($val);
        if ($val && $ref) {
            if (!isset($this->_numerics[$ref])) {
                $this->_numerics[$ref] = 0;
            }

            if (!is_numeric($val) && (!strpos($val,"/"))) {
                //print("I am swapping ".$val);
                $this->_numerics[$ref] += 1;
                $val = str_pad((string)$this->_numerics[$ref],10,'0',STR_PAD_LEFT);
                //print(" with ".$val."\n");
            }
        }
        return $val;
    }
    
    /**
     * Takes a number and adds the PHI offset to each digit, also optionally check to see if that number has been encountered before, if so re-scramble
     *
     * @return string
     */
    public function offsetDigits($num,$row) {
        if ($num=='') {
            return '';
        }
        $scrambled = '';
        
        for ($i=0; $i<strlen($num); $i++) {
            $digit = substr($num,$i,1);
            if (ctype_digit($digit)) {
                $digit = (int)$digit+$row['phi_offset'];
                if ($digit>9) {
                    $digit = $digit - 10;
                }
            }
            $scrambled = $scrambled.$digit;
        }
        
        return $scrambled;
    }    

    public function serializedRedacter($val) {
        if ($val=='') {
            return $val;
        }

        $form = @unserialize($val);

        if (!$form) {
            return '';
        }
        foreach ($form as $idx => $field) {
            $form[$idx] = str_replace($this->redactChars,$this->redactChar,$field);
        }

        return serialize($form);
    }


    /**
     * Blanks out a field irrespective of what was processed
     *
     * @return string
     */
    public function blankout() {
        return '';
    }

    /**
     * Returns a string of spaces the same length as what is passed in, or a minimum of one character
     *
     * @param type $val
     * @return type
     */
    public function spaces($val) {
        $retVal = ' ';
        $len = strlen($val);
        if ($len) {
            $retVal = substr($retVal,0,$len);
        }
        return $retVal;
    }
    /**
     *
     *
     * @return type
     */
    public function dateOfBirth($val,$row) {
        $d = 60 * 60 * 24; //this is a day
        $y = $d * 365; //this is a year
        $e = 60 * 60 * 26; //this is a day plus possible day light savings adjustment
        return date('m/d/Y',strtotime($val) + ($row['phi_offset']*$d*30) + $e - $y);
    }

    /**
     *
     * @return type
     */
    public function email($val) {
        return 'hedis@argusdentalvision.com';
    }

    /**
     *
     * @return type
     */
    public function userid() {
        $username = strtolower(substr($this->firstname(),0,1).$this->lastname());
        $ctr=0;
        while (isset($this->usernames[$username])) {
            $ctr      = $ctr+1;
            $username = strtolower(substr($this->firstname(),0,1).$this->lastname()).$ctr;
        }
        $this->usernames[$username] = true;
        $this->current['username']  = $username;
        $this->_userid($username);
        return $this->userid        = $username;
    }

    private function _username($name=[]) {
        if ($name) {
            $this->_username = $name;
            return $this;
        }
        return $this->_username;
    }
    
    private function setFullName($row) {
        $row['gender'] = (isset($row['gender']) && $row['gender']) ? $row['gender'] : 'M';        
        $this->_username(explode(" ",($row['gender']=='F') ? array_pop($this->females) : array_pop($this->males)));      
    }
    
    /**
     * What we are going to do is create a new id, then add it to the xref that will be cached so as to make member lookup 
     * 
     * @param type $num
     * @param type $row
     * @return type
     */
    private function scrambleMemberNumber($num,$row) {
        $new_id = $this->offsetDigits($num, $row);
        $this->_member_id[$new_id] = $num;
        return $new_id;
    }
    
    /**
     *
     * @return type
     */
    public function firstname() {
        if (empty($this->females)) {
            $this->resetFemales();
        }
        if (empty($this->males)) {
            $this->resetMales();
        }
        return strtoupper($this->_username[0]);
    }

    /**
     *
     * @return type
     */
    public function lastname() {
        if (empty($this->females)) {
            $this->resetFemales();
        }
        if (empty($this->males)) {
            $this->resetMales();
        }
        return strtoupper($this->_username[1]);
    }

    public function fullName($field,$row) {
        $this->setFullName($row);
        return $this->firstname().', '.$this->lastname();
    }
    
    private function _resetAddress() {
        $this->_address = false;
        
    }
    private function _address($whichone=false) {
        if ($whichone) {
            $this->_address = $whichone;
            return $this;
        }
        return $this->_address;
    }
     
    public function fullAddress() {
        return $this->street().', '.$this->city().', '.$this->state().', '.$this->zipcode();
    }
    
    /**
     *
     * @return type
     */
    public function street() {
        if (empty($this->addresses[$this->_state()])) {
            $this->resetAddresses();
        }
        if (!$this->_address()) {
            $this->_address(explode(",",array_pop($this->addresses[$this->_state()])));
        }
        return strtoupper(trim($this->_address[0]));
    }

    /**
     *
     * @return type
     */
    public function city() {
        if (empty($this->addresses[$this->_state()])) {
            $this->resetAddresses();
        }
        if (!$this->_address()) {
            $this->_address(explode(",",array_pop($this->addresses[$this->_state()])));
        }
        return strtoupper(trim($this->_address[1]));
    }

    /**
     *
     * @return type
     */
    public function state() {
        if (empty($this->addresses[$this->_state()])) {
            $this->resetAddresses();
        }
        if (!$this->_address()) {
            $this->_address(explode(",",array_pop($this->addresses[$this->_state()])));
        }
        return strtoupper(trim($this->_address[2]));
    }

    /**
     *
     * @return type
     */
    public function zipcode() {
        if (empty($this->addresses[$this->_state()])) {
            $this->resetAddresses();
        }
        if (!$this->_address()) {
            $this->_address(explode(",",array_pop($this->addresses[$this->_state()])));
        }
        $str = array(' ','(',')');
        $rpl = array('','','');
        return str_replace($str,$rpl,$this->_address[3]);
    }

    /**
     *
     * @return type
     */
    public function phone($currentPhone) {
        if (!$currentPhone) {
            return '';  /* don't waste a phone number if there wasn't one there in the first place */
        }
        if (empty($this->phonenums)) {
            $this->resetPhoneNumbers();
        }
        $str = array(' ','(',')','-');
        $rpl = array('','','','');
        return str_replace($str,$rpl,array_pop($this->phonenums));
    }

    /**
     *
     * @return type
     */
    public function company() {
        return 'ACME Company #'.++$this->company;
    }

    /**
     * This finds the login data for a userid passed in.  If one can't be determined, a random login user is used since we only really need the PHI offset scrambler for someone
     *
     * @param type $uid
     * @return this
     */
    public function setCurrent($uid,$type) {
        if ($type) {
            if ($type == 'login_id') {
                $this->currentId = $uid;
                $this->current   = isset($this->original[$uid]) ? $this->original[$uid] : [];
            } else {
                if (!isset($this->userids[$uid])) {
                    //need to randomly pick someone
                    $num = rand(1,count($this->original)-1);
                    $this->currentId = array_keys($this->original)[$num];
                } else {
                    $this->currentId = $this->userids[$uid]['login_id'];
                }
                $this->current   = isset($this->original[$this->currentId]) ? $this->original[$this->currentId] : die('Could not find someone to tie this userid too...'.$uid);
            }
        }
        return $this;
    }

    /**
     * Let's hide some text
     *
     * @param type $originalText
     * @return string
     */
    public function textScrambler($originalText='') {
        if (!$originalText) {
            return '';   /* Don't scramble what doesn't need scrambled */
        }
        $wordCount  = str_word_count($originalText);
        $sentence   = [];
        $source     = $this->lorumText;
        for ($i=0; $i<$wordCount; $i++) {
           $sentence[]  = substr($source,0,strpos($source,' '));
           $source      = substr($source,strpos($source,' ')+1);
        }
        return implode(' ',$sentence);
    }    
    
    /**
     * Saves off the original set of data and calculates and offset based on date of birth
     *
     * @param type $data
     * @return this
     */
    public function storeOriginal($data) {
        foreach ($data as $idx => $user) {
            $birthdate = isset($user['dob']) ? $user['dob'] : $user['date_of_birth'];
            $user['phi_offset'] = abs((floor(strtotime($birthdate)/1000))%8)+1;  //make sure we don't get a zero
            $this->original[$user['login_id']] = $user;
        }
        //file_put_contents("users.txt",print_r($this->original,true));
        return $this->original;
    }

    /**
     * corellates the user id to the login Id...
     */
    public function xrefOriginal($data) {
        foreach ($data as $idx => $user) {
            if (isset($user['login_id']) && $user['login_id'] && isset($this->original[$user['login_id']])) {
                $this->userids[$user['user_id']] = $this->original[$user['login_id']];
            }
        }
    }
    
    /**
     * We are going to take in a segment of the scheme, process those tables, and place the converted rows back into the scheme
     * 
     * @param array $scheme
     * @param string $namespace
     * @param string $table
     * @param array $options
     * @return array
     */
    public function process($scheme,$namespace,$table,$options) {
        $orm = Argus::getEntity($namespace.'/'.$table);
        $results = isset($options['condition']) ? $orm->condition($options['condition'])->fetch() : $orm->fetch();
        if (count($results)) {
            $scheme[$table] = $results->toArray();
            if (isset($options['scrub'])) {
                $obs = [];
                foreach ($scheme[$table] as $idx => $row) {
                    $this->_resetAddress();
                    if (!isset($row['date_of_birth'])) {
                        $row['date_of_birth'] = date('m/d/Y',rand(strtotime('1945-01-01'),strtotime('1960-12-31')));
                    }
                    $row['phi_offset'] = abs((floor(strtotime($row['date_of_birth'])/1000))%8)+1;  //make sure we don't get a zero
                    $this->current = $row;
                    foreach ($options['scrub'] as $field => $masker) {
                        if (isset($row[$field])) {
                            $row[$field] = $this->$masker($row[$field],$row);
                        }
                    }
                    $scheme[$table][$idx] = $row;
                }
            }
        }
        return $scheme;
    }

    /**
     * If the asterisk option is present, this expands out the list of entities to process
     * 
     * @param json $scheme
     * @return type
     */
    public function preProcess($scheme) {
        $t_orm = Argus::getEntity('humble/entities');
        $flags = [];
        foreach ($scheme as $namespace => $tables) {
            $flags[$namespace] = false;
            foreach ($tables as $table => $options) {
                $flags[$namespace] = $flags[$namespace] || ($table == "*");
                if ($table == "*") {
                    unset($scheme[$namespace][$table]);
                }
            }
        }
        foreach ($flags as $namespace => $all) {
            if ($all) {
                $entities = $t_orm->reset()->setNamespace($namespace)->fetch(true);
                foreach ($entities as $entity) {
                    $scheme[$namespace][$entity['entity']] =  (isset($scheme[$namespace][$entity['entity']])) ? $scheme[$namespace][$entity['entity']] : false ;
                }
            }
        }
        return $scheme;
    }
    
    /**
     * Drives the export and masking process
     */
    public function generate($scheme=false) {
        if ($scheme = ($scheme) ? json_decode($scheme,true) : json_decode($this->getScheme(),true)) {
            foreach ($scheme = $this->preProcess($scheme)  as $namespace => $tables) {
                foreach ($tables as $table => $options) {
                    $scheme[$namespace] = $this->process($scheme[$namespace],$namespace,$table,$options);
                }
            }
            chdir('import_tmp');
            $stamp = date('YmdHis');
            $file  = 't'.$stamp.'.zip';
            $zip   = new \ZipArchive();
            if ($zip->open($file, \ZipArchive::CREATE)!==TRUE) {
                exit("cannot open <$file>\n");
            }            
            $zip->addFromString('entities.json',json_encode($scheme));
            $zip->close();
            print(file_get_contents($file));
            unlink($file);
            chdir('..');
            if (count($this->_member_id)) {
                Argus::cache('member_xref',$this->member_id);
            }
        }
    }
    
    /**
     * Will prepare and start the process to export database tables as a ZIP file
     * 
     * @workflow use(PROCESS)
     * @param type $EVENT
     * @return boolean
     */
    public function service($EVENT=false) {
        if ($EVENT!==false) {
            $data = $EVENT->load();
            if (isset($data['scheme']) && ($data['scheme'])) {
                $this->generate($data['scheme']);
            }
        }
        return true;
    }
    
    /**
     * Creates a randomly named directory for use in exporting data
     * 
     * @return type
     */
    public function exportDirectory() {
        if (!$this->dir) {
            $tokens = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
            for ($i=0; $i<8; $i++) {
                $this->dir .= substr($tokens,rand(0,25),1);
            }
          
            mkdir('export/'.$this->dir,0775,true);            
        }
        return $this->dir;
    }
    /**
     * Selective export of certain tables on a per table basis rather than a per namespace basis
     * 
     * @param type $namespace
     * @param type $entity
     */
    public function entity($namespace=false,$entity=false) {
        $namespace = ($namespace) ? $namespace : ($this->getNamespace() ? $this->getNamespace() : false);
        $entity    = ($entity)    ? $entity    : ($this->getEntity()    ? $this->getEntity()    : false);
        $results   = [];
        $results[$namespace] = [];
        $results[$namespace][$entity] = [];
        if ($namespace && $entity) {
            $dir = $this->exportDirectory();
            $this->setFileName($entity.'.zip');
            $orm = Argus::getEntity($namespace.'/'.$entity);
            if ($condition = $this->getCondition() ? $this->getCondition() : false) {
                $orm->_condition(' where '.$condition);
            }
            foreach ($orm->fetch() as $row) {
                if (isset($row['csrf_buster'])) {
                    unset($row['csrf_buster']);         //fields which are used by the CSRF protection
                    unset($row['browser_tab_id']);      //they aren't needed and can mess things up
                }
                $results[$namespace][$entity][] = $row;
            }
            file_put_contents('export.json',json_encode($results,JSON_PRETTY_PRINT));
            $zip   = new \ZipArchive();
            if ($zip->open('export/'.$this->exportDirectory().'/'.$this->getFileName(), \ZipArchive::CREATE)!==TRUE) {
//                exit("cannot open <$file>\n");
            }            
            $zip->addFile('export.json');
            $zip->close();
            unlink('export.json');
        }
        return $this->getFileName();
    }
}