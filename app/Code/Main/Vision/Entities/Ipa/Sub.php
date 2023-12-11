<?php
namespace Code\Main\Vision\Entities\Ipa;
use Argus;
use Log;
use Environment;
/**
 *
 * subipafinder
 *
 * see tiltle
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Other
 * @author     Aaron Binder abinder@aflacbenefitssolutions.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Sub.html
 * @since      File available since Release 1.0.0
 */
class Sub extends \Code\Main\Vision\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    
    
    /**
     * Returns a dataset of the IPA subs
     * 
     * @return iterator
     */    
    public function ipafinder() {
        $query = <<<SQL
                
                SELECT 
                    vis.id as 'id',
                    (CASE WHEN vis.sub_name!=' ' THEN CONCAT(vi.ipa_name,' - ', vis.sub_name) ELSE vi.ipa_name END) AS 'The_Name', 
                    vis.sub_order_id  as 'sub_order_id', 
                    vis.sub_id as 'the_sub_id',
                    vis.ipa_parent_id as 'ipa_parent_id',
                    vis.is_enabled as 'is_enabled'
                FROM vision_ipa AS vi 
                LEFT OUTER JOIN vision_ipa_sub AS vis 
                    ON vi.ipa_id=vis.ipa_parent_id 
                ORDER BY vi.is_not_other DESC, vi.ipa_name ASC, vis.sub_name ASC
             
SQL;
        return $this->query($query);        
    }
    
    
    
    
    
    public function ipagetter() {
        
        $val=$_GET['theval'];
        
        
        $assignee_clause = ($_GET['theval']!='') ? " WHERE vis.sub_id=".$val."" : "";
        
        $query = <<<SQL
                
                SELECT 
                    vis.id as 'id',
                    (CASE WHEN vis.sub_name!=' ' THEN CONCAT(vi.ipa_name,' - ', vis.sub_name) ELSE vi.ipa_name END) AS 'The_Name', 
                    vis.sub_order_id  as 'sub_order_id', 
                    vis.sub_id as 'the_sub_id',
                    vis.ipa_parent_id as 'ipa_parent_id',
                    vis.is_enabled as 'is_enabled'
                FROM vision_ipa AS vi 
                LEFT OUTER JOIN vision_ipa_sub AS vis 
                    ON vi.ipa_id=vis.ipa_parent_id 
                {$assignee_clause}
                ORDER BY vi.is_not_other DESC, vi.ipa_name ASC, vis.sub_name ASC
             
SQL;
        return $this->query($query);        
    }
    
    
    
    
    
    public function getipamount(){
        
        
        $query = <<<SQL
            SELECT Count(*) AS theamount
              FROM vision_ipa
                      
SQL;
        
        return $this->query($query); 
    
    }
    
    
    
    public function getipasubamount(){
        
        
        $query = <<<SQL
            SELECT Count(*) AS theamount
              FROM vision_ipa_sub
                      
SQL;
        
        return $this->query($query); 
    
    }
    
    
    
    
    
    
    
    public function createsubtable(){
        
        $val=0;
        $val=$_GET['selectedrow'];
        
        
        $assignee_clause = ($_GET['selectedrow']!='') ? " WHERE vi.ipa_id=".$val."" : "";
        
        
        $query = <<<SQL
            SELECT vis.id as 'id', (CASE WHEN vis.sub_name!=' ' THEN CONCAT(vi.ipa_name,' - ', vis.sub_name) ELSE vi.ipa_name END) AS 'The_Name', 
                    vis.sub_order_id  as 'sub_order_id', vis.sub_id as 'the_sub_id', vis.is_enabled as 'is_enabled', vis.ipa_parent_id as 'ipa_parent_id'
                FROM vision_ipa AS vi 
                LEFT OUTER JOIN vision_ipa_sub AS vis 
                    ON vi.ipa_id=vis.ipa_parent_id     
                {$assignee_clause}
                ORDER BY vi.is_not_other DESC, vi.ipa_name ASC, vis.sub_name ASC
                      
SQL;
         return $this->query($query);
        
        
    }
    
    
    public function createmainipatable(){
        
        
        $query = <<<SQL
            SELECT *
                FROM vision_ipa
                
                ORDER BY is_not_other DESC, ipa_name ASC
                      
SQL;
         return $this->query($query);
        
        
    }
    
    
    
    
    
    
    
    
    
    public function ordertoipaid(){
        
        $val=0;
        $val=$_GET['selectedorder'];
        
        
        $assignee_clause = " WHERE order_by_num=".$val;
        
        
        $query = <<<SQL
            SELECT id
                FROM vision_ipa
                {$assignee_clause}
                
                      
SQL;
         return $this->query($query);
        
        
    }
    
    
    
    public function ordertoipasubid(){
        
        $val=0;
        $val=$_GET['selectedorder'];
        $val2=0;
        $val2=$_GET['theparent'];
        
        //$assignee_clause = " WHERE sub_order_id=".$val." AND ipa_parent_id=".$val2;
        
        
        $assignee_clause = " WHERE ipa_parent_id=".$val2;
        $suborderval=($_GET['selectedorder']!='') ? " AND sub_order_id=".$val : "";
        
        
        
        $query = <<<SQL
            SELECT id, sub_name, sub_order_id
                FROM vision_ipa_sub
                {$assignee_clause}
                {$suborderval}
                      
SQL;
         return $this->query($query);
        //note area:
        //$assignee_clause = ($_GET['selectedrow']!='') ? " WHERE vi.ipa_id=".$val."" : "";
        
        
    }
    
    
    
    public function createnpitable(){
        
        
        
        $query = <<<SQL
            SELECT id, npi_id, location, created_on
                FROM vision_event_npi
                
                
                      
SQL;
         return $this->query($query);
        
        
    }
    
    
    
    
    
    
    
    
    //quick test
    
    
    
    //aaron-> here be a normalized call to get name, id, date, and location
    
    /**
     * 
     */
    public function batchpdffinder() {
        
        
        $start_clause = ($this->getEventDate()) ? $this->getEventDate() : '';
        $event_location = ($this->getEventLocation()) ? $this->getEventLocation() : '';
        
        
        
        //$event_location='400 8th Street N, Naples, FL 34102';
        /*
        $results    = [];
        foreach (Argus::getEntity('vision/consultation/forms')->setStatus('C')->formnormalizer() as $form) {
        $a = $b=$c=$d=false;
            $isgood=true;

            if(!isset($form['event_date']) || $form['event_date']=="" ){
                $isgood=false;
                $a =true;
            }
            if($start_clause!==''){
                
                if(strtotime($start_clause)!=strtotime($form['event_date'])){$isgood=false; $b=true;}

            }

            if(!isset($form['address_id']) || $form['address_id']==""){$isgood=false; $c=true;}
            if($event_location!==''){
                
                //todo -> get first 'word' of address_id and do a LIKE statement against the rest -> X%
                $eventlocspl=  explode(' ',$event_location);
                $theaddress=$eventlocspl[0];
                $curloc=$form['address_id'];
                
                if($event_location!=$form['address_id']){$isgood=false;$d=true;}

            }
            
            
            
            if($isgood){
                
                
                
                $results[] = $form;
            }
            else{
                
            }
            
        }
       
        
       return $results;
        */
        $query = <<<SQL
             SELECT a.id, a.id AS form_id, a.created_by, a.created, a.submitted, a.last_activity, a.review_by, a.member_id, a.status, a.member_name, b.id as creator, a.event_date,
                    b.first_name AS creator_first_name, b.last_name AS creator_last_name, b.gender as creator_gender,
                    concat(c.first_name,' ',c.last_name) as technician_name, a.last_action, a.address_id
              FROM vision_consultation_forms AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.created_by = b.id
              left outer join humble_user_identification as c
                on a.technician = c.id                    
              WHERE a.address_id <> ""            
              AND a.event_date<>""
                and a.status='C'
                 
SQL;
     
       
        return $this->query($query);
        
        
    }
  
    
    
    
    
    //report creator
    
    public function reportcreator(){
       
        $results    = [];
        
        
        $theeventid=$_GET['eventid'];
        
        
        $businessname=$_GET['businessname']; 
        $eventdate=$_GET['eventdate'];
        $healthplan=$_GET['healthplan'];
        $thecity=$_GET['city'];
        
        
        
        
        
        $theform=Argus::getEntity('vision/consultation/forms')->setStatus('C')->formnormalizer();
       
        $results= $this-> batchconverter($theform,$theeventid);
        if(count($results)<1){
            
            return json_encode($results);
        }
        else{
           
            
       $results2= array_multisort(array_column($results, 'member_name'),  SORT_ASC, $results); 
        $data = array('_combine'=>[]);
        //$data=[];
        
        $_combine= [];
        
        foreach ($results as $abc) {
            
            $_combine[]= $abc;
        }
        
        $data['_combine']=$_combine; 
        
        $theid=Environment::whoAmI();
        
        $query = <<<SQL
SELECT email
FROM humble_users
WHERE uid= '{$theid}'
SQL;
         
        
               $ttt=$this->query($query);
          
               $theemail='';
               
              if (strpos($ttt, ':') !== false) { 
                  $thesplit=explode('"' , $ttt);
                  $theemail=$thesplit[3];
              }
        
        $data['email']=$theemail;
        
        
        // (date) _ (Healthplan) _ (business name) _ (city)
        $data['filetitle']=$eventdate.' _ '.$healthplan.' _ '.$businessname.' _ '.$thecity;
        
        
        
        $json_data = json_encode($data); 

        
//old
        //$url = 'https://www.webmerge.me/merge/194510/wti8wk?test=1';
        ////current test
        //$url = 'https://www.webmerge.me/merge/203945/71i4ip?test=1';
        //current
        //$url = 'https://www.webmerge.me/merge/203945/71i4ip';
        $url ='https://www.webmerge.me/merge/244646/2zdk95';
        //open connection
        $ch = curl_init();

        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
        curl_setopt($ch, CURLOPT_POSTFIELDS, $json_data);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
            'Content-Type: application/json',
            'Content-Length: ' . strlen($json_data))
        );
        curl_setopt ($ch, CURLOPT_CAINFO, dirname(__FILE__)."/cacert.pem");

        //execute post
        $resultval = curl_exec($ch);


        $error_msg='';
        if (curl_error($ch)) {
            $error_msg = curl_error($ch);
        }


        //close connection
        curl_close($ch);

        if ($resultval) {
            $response = 'Document created successfully. Check WebMerge for more details.';
        } else {
            $response = 'No documents created.';
        }

    
        /**/
        
        //do flag restore here -> any values that have a flag value will be reset
        
        return json_encode($results);
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //report creator
    
    public function singlereportcreator(){
       
        $results    = [];
        
        
        $theeventid=$_GET['eventid'];        
        $theeventdate=$_GET['eventdate'];
        $theeventlocation=$_GET['eventlocation'];
        $memid=$_GET['memberid'];
        
        $businessname=$_GET['businessname']; 
        $healthplan=$_GET['healthplan'];
        $thecity=$_GET['city'];
        
        
        $theform=Argus::getEntity('vision/consultation/forms')->setMemberId($memid)->setEventDate($theeventdate)->setEventAddress($theeventlocation)->setStatus('C')->formnormalizer();
        $results= $this-> batchconverter($theform,$theeventid);
        
       //$results2= array_multisort(array_column($results, 'member_name'),  SORT_ASC, $results); 
        
        $data = array('_combine'=>[]);
        //$data=[];
        
        $_combine= [];
        
        foreach ($results as $abc) {
            
            $_combine[]= $abc;
        }
        
        $data['_combine']=$_combine; 
        
        $theid=Environment::whoAmI();
        
        $query = <<<SQL
SELECT email
FROM humble_users
WHERE uid= '{$theid}'
SQL;
         
        
               $ttt=$this->query($query);
          
               $theemail='';
               
              if (strpos($ttt, ':') !== false) { 
                  $thesplit=explode('"' , $ttt);
                  $theemail=$thesplit[3];
              }
        
        $data['email']=$theemail;
        
        
                 
         
        
        // (date) _ (Healthplan) _ (business name) _ (city)
        $data['filetitle']=$theeventdate.' _ '.$healthplan.' _ '.$businessname.' _ '.$thecity;
        
        
        $json_data = json_encode($data); 


//old
        //$url = 'https://www.webmerge.me/merge/194510/wti8wk?test=1';
//        current test
        //$url = 'https://www.webmerge.me/merge/203945/71i4ip?test=1';
        //current live
        //$url = 'https://www.webmerge.me/merge/203945/71i4ip';
        
        
        //new test
        //$url ='https://www.webmerge.me/merge/244646/2zdk95?test=1';
        
        $url ='https://www.webmerge.me/merge/244646/2zdk95';
        
        //open connection
        $ch = curl_init();

        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
        curl_setopt($ch, CURLOPT_POSTFIELDS, $json_data);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, array(
            'Content-Type: application/json',
            'Content-Length: ' . strlen($json_data))
        );
        curl_setopt ($ch, CURLOPT_CAINFO, dirname(__FILE__)."/cacert.pem");

        //execute post
        $resultval = curl_exec($ch);


        $error_msg='';
        if (curl_error($ch)) {
            $error_msg = curl_error($ch);
        }


        //close connection
        curl_close($ch);

        if ($resultval) {
            $response = 'Document created successfully. Check WebMerge for more details.';
        } else {
            $response = 'No documents created.';
        }

    
        /**/
        
        //do flag restore here -> any values that have a flag value will be reset
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //for personal printup
    public function idcsvwirter(){
       $util       = Argus::getHelper('argus/CSV'); 
        $results    = [];
        
        
        $memid = ($this->getMemid()) ? $this->getMemid() : '';
       
       $theeventdate=($this->getEvdate()) ? $this->getEvdate() : '';
       $theeventlocation=($this->getEvloc()) ? $this->getEvloc() : '';
       
       $theeventid=($this->getEvid()) ? $this->getEvid() : '';
       
       //$madechange=($this->getMadechange()) ? $this->getMadechange() : '';
       
       $theeventlocation = str_replace('{HASH}', '#', $theeventlocation);
       $theeventlocation = str_replace('{AND}', '&', $theeventlocation);
       
        //for use for searching by event id
       //->setEventId($theeventid)
       //for use for searching for forms in events that had been edited
       //->setMadeChange($madechange)
       
       
       if($theeventid!=''){
           //$theform=Argus::getEntity('vision/consultation/forms')->setEventId($theeventid)->setStatus('C')->formnormalizer();
           $theform=Argus::getEntity('vision/consultation/forms')->setStatus('C')->formnormalizer();        
       }
       else{
           $theform=Argus::getEntity('vision/consultation/forms')->setMemberId($memid)->setEventDate($theeventdate)->setEventId($theeventid)->setEventAddress($theeventlocation)->setStatus('C')->formnormalizer();
       }
       
       
        $results= $this-> batchconverter($theform,$theeventid);
        
       
        
       $results2= array_multisort(array_column($results, 'member_name'),  SORT_ASC, $results); 
        
        
       
       
        $data = array('_combine'=>[]);
        //$data=[];
        
        $_combine= [];
        
        foreach ($results as $abc) {
            
            $_combine[]= $abc;
        }
        
        $data['_combine']=$_combine; 
        
        
        
        
        
        
        
        $theid=Environment::whoAmI();
        
        $query = <<<SQL
SELECT email
FROM humble_users
WHERE uid= '{$theid}'
SQL;
         
        
               $ttt=$this->query($query);
          
               $theemail='';
               
              if (strpos($ttt, ':') !== false) { 
                  $thesplit=explode('"' , $ttt);
                  $theemail=$thesplit[3];
              }
        
        
               
        
        $data['email']=$theemail;
        
        /**/



$json_data = json_encode($data); 



$url = 'https://www.webmerge.me/merge/194510/wti8wk?test=1';
//$url = 'https://www.webmerge.me/merge/203945/71i4ip?test=1';
//open connection
$ch = curl_init();

curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
curl_setopt($ch, CURLOPT_POSTFIELDS, $json_data);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, array(
    'Content-Type: application/json',
    'Content-Length: ' . strlen($json_data))
);
curl_setopt ($ch, CURLOPT_CAINFO, dirname(__FILE__)."/cacert.pem");



//execute post
$resultval = curl_exec($ch);





$error_msg='';
if (curl_error($ch)) {
    $error_msg = curl_error($ch);
}





//close connection
curl_close($ch);

if ($resultval) {
    $response = 'Document created successfully. Check WebMerge for more details.';
} else {
    $response = 'No documents created.';
}



    
        /**/
        
        //do flag restore here -> any values that have a flag value will be reset
        
        
        
        
        
        
        
        
        
       // header('Content-Disposition: attachment; filename="testtest.csv"');
       // return $util -> arrayToCSV(Argus::report($results,'vision/batchfile'));
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    
    
    //need to do
    public function eventidcsvwirter(){
       $util       = Argus::getHelper('argus/CSV'); 
        $results    = [];
        
        $evid = ($this->getEventId()) ? $this->getEventId() : '';
        
        $theform=Argus::getEntity('vision/consultation/forms')->setStatus('C')->setEventID($evid)->formnormalizer();
        $results= $this-> batchconverter($theform,'');
        
        
        //aaron do reorder here
        
        
        //$results2= array_multisort(array_column($results, 'member_name'),  SORT_ASC, $results);
        
        
        header('Content-Disposition: attachment; filename="testtest.csv"');
        return $util -> arrayToCSV(Argus::report($results,'vision/batchfile'));
        
    }
    
    
    
    /*
    //test
    public function locanddatecsvwirter(){
       $util       = Argus::getHelper('argus/CSV'); 
        $results    = [];
       $theeventdate='';
       $theeventlocation='';
        $theform=Argus::getEntity('vision/consultation/forms')->setStatus('C')->setEventDate($theeventdate)->setEventAddress($theeventlocation)->formnormalizer();
        $results= $this-> batchconverter($theform);
        
        header('Content-Disposition: attachment; filename="testtest.csv"');
        return $util -> arrayToCSV(Argus::report($results,'vision/batchfile'));
        
    }*/
    
    public static function getemail($theid){
        
        
        
        $query = <<<SQL
SELECT email
FROM humble_users
WHERE uid= '{$theid}'
SQL;
         
        
               $ttt=$this->query($query);
        
        
        
        return $ttt;
        
        
    }
    
    
    public function batchconverter($theform, $searchid){
        $results=[];
        
        
        //$theemail= function::getemail(Environment::whoAmI());
        //
        //
        $theid=Environment::whoAmI();
        //$theid=112;
        $query = <<<SQL
SELECT email
FROM humble_users
WHERE uid= '{$theid}'
SQL;
         
        
               $ttt=$this->query($query);
          
               $theemail='';
               
              if (strpos($ttt, ':') !== false) { 
                  $thesplit=explode('"' , $ttt);
                  $theemail=$thesplit[3];
              }
        
        
        
         
        
        foreach ($theform as $form) {
            $temppage=[];
            
            if(isset($form['screening_client'])){
                
                $scrfull=$form['screening_client'];
                if(isset($form['screening_client_other'])){
                    if($form['screening_client_other']!=''){
                        $scrfull.=' - '.$form['screening_client_other'];
                    }
                }
                
                $temppage['screening_client']=$scrfull;
            }
            else{
                $temppage['screening_client']= 'N/A';    
            }
            //$temppage['screening_client']=isset($form['screening_client']) ? $form['screening_client'] : '';
            
            $temppage['primary_doctor']=isset($form['primary_doctor']) ? $form['primary_doctor'] : 'N/A';
            
            $temppage['event_date']=isset($form['event_date']) ? $form['event_date'] : 'N/A';
            
            $temppage['member_name']=isset($form['member_name']) ? trim($form['member_name']) : 'N/A';
            
            $temppage['member_id']=isset($form['member_id']) ? $form['member_id'] : 'N/A';
            
            $temppage['date_of_birth']=isset($form['date_of_birth']) ? $form['date_of_birth'] : 'N/A';
            
            $temppage['member_address']=isset($form['member_address']) ? $form['member_address'] : 'N/A';
            
            $temppage['address_id']=isset($form['address_id']) ? $form['address_id'] : 'N/A';
            
            if(isset($form['gender'])){
                $gen='';
                $thegender=$form['gender'];
                if($thegender=='M'){
                    $gen='Male';
                }
                else{
                    $gen='Female';
                }
                $temppage['gender']=$gen;
            }
            else{
                $temppage['gender']='N/A';
            }
            $temppage['npi_id']=isset($form['npi_id']) ? $form['npi_id'] : 'N/A';
            
            $temppage['bmi']=isset($form['bmi']) ? $form['bmi'] : '';
            
            $temppage['fbs']=isset($form['fbs']) ? $form['fbs'] : '';
            
            $temppage['fbs_date']=isset($form['fbs_date']) ? $form['fbs_date'] : '';
            
            $temppage['pcp_staff_signature']=isset($form['pcp_staff_signature']) ? $form['pcp_staff_signature'] : '';
            
            $temppage['patient_agreement']=isset($form['patient_agreement']) ? (($form['patient_agreement']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            
            
            $temppage['type_oral']=isset($form['type_oral']) ? (($form['type_oral']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            $temppage['type_insulin']=isset($form['type_insulin']) ? (($form['type_insulin']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            $temppage['type_diet']=isset($form['type_diet']) ? (($form['type_diet']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            
            $usethistype=0;
            $atype=0;
            $btype=0;
            if(isset($form['type_1dm'])){
                if($form['type_1dm']!=''){
                    $atype++;
                }
            }
            
            if(isset($form['type_2dm'])){
                if($form['type_2dm']!=''){
                    $btype++;
                }
            }
            if(isset($form['type_1yrs'])){
                if($form['type_1yrs']!=''){
                    $atype++;
                }
            }
            if(isset($form['type_2yrs'])){
                if($form['type_2yrs']!=''){
                    $btype++;
                }
            }
            if(isset($form['dm_type'])){
                if($form['dm_type']!=''){
                    $atype++;
                }
            }
            if(isset($form['dm_type_2'])){
                if($form['dm_type_2']!=''){
                    $btype++;
                }
            }


            if($atype>0 || $btype>0){
                if($atype>=$btype){
                    $usethistype=1;

                }
                else{
                    $usethistype=2;

                }
            }
            
            
            
            
            
            $dothing=TRUE;
            if(isset($form['type_dm'])){
                if($form['type_dm']!=''){
                    $temppage['type_dm']=isset($form['type_dm']) ? $form['type_dm'] : '';
                    $dothing=false;
                }
                else{
                    
                }
                
            }
            else{
                
            }
            
            
            if($dothing){
                

               if($usethistype!=0){
                    if($usethistype==1){
                        $temppage['type_dm']=isset($form['type_1dm']) ? 't1' : '';                        
                    }
                    else{
                        $temppage['type_dm']=isset($form['type_2dm']) ? 't2' : '';
                    }
                } 
                
                
                
            } 
            
            
            
            
            
            $dothing=true;
            if(isset($form['type_years'])){
                
                if($form['type_years']!=''){
                    $temppage['type_years']=isset($form['type_years']) ? $form['type_years'] : '';
                    $dothing=FALSE;
                }
                else{
                    $temppage['type_years']='N/A';
                }
            }
            else{
                $temppage['type_years']='N/A';
            }
            
            if($dothing){
                
                        
                if($usethistype!=0){
                    if($usethistype==1){
                        $temppage['type_yrs']=isset($form['type_1yrs']) ? $form['type_1yrs'] : '';                        
                    }
                    else{
                        $temppage['type_yrs']=isset($form['type_2yrs']) ? $form['type_2yrs'] : '';
                    }
                }
            }



            
            
            $dothing=true;
            if(isset($form['type_yrs'])){
                if($form['type_yrs']!=''){
                    $temppage['dm_alltype']=isset($form['dm_alltype']) ? $form['dm_alltype'] : '';
                    $dothing=false;
                }
                else{
                    
                }
               
            }
            if($dothing){
                if($usethistype!=0){
                    if($usethistype==1){
                        $temppage['dm_alltype']=isset($form['dm_type']) ? $form['dm_type'] : '';
                    }
                    else{
                        $temppage['dm_alltype']=isset($form['dm_type_2']) ? $form['dm_type_2'] : '';
                    }
                }
            }
            
            
            
            
              
            //$temppage['type_1dm']=isset($form['type_1dm']) ? (($form['type_1dm']==('Y' || 'Yes' || 'YES'))?'X':'') : '';                
            //$temppage['type_2dm']=isset($form['type_2dm']) ? (($form['type_2dm']==('Y' || 'Yes' || 'YES'))?'X':'') : '';            
            //$temppage['type_1yrs']=isset($form['type_1yrs']) ? $form['type_1yrs'] : '';            
            //$temppage['type_2yrs']=isset($form['type_2yrs']) ? $form['type_2yrs'] : '';
            //$temppage['dm_type']=isset($form['dm_type']) ? $form['dm_type'] : '';
            //$temppage['dm_type_2']=isset($form['dm_type_2']) ? $form['dm_type_2'] : '';
            
            
            $temppage['event_id']=isset($form['event_id']) ? $form['event_id'] : 'N/A';
            
            if(isset($form['form_type'])){
                if($form['form_type']=='screening'){
                    $temppage['screen_or_scan']='Screening';
                    $temppage['form_type']='Screening';
                    
                    
                    
                    $temppage['techorod']='Doctor:';    
                }
                else{
                    $temppage['screen_or_scan']='Scanning';
                    $temppage['form_type']='Scanning';
                    
                    $temppage['techorod']= 'Technician:';    
                }
                
            }
            else{
                $temppage['screen_or_scan']='Scanning';
                $temppage['form_type']='Scanning';
                $temppage['techorod']= 'Technician:';
            }
            
            
            $temppage['form_num']=isset($form['id']) ? $form['id'] : 'N/A';
            //$temppage['pcp_npi']=isset($form['physician_npi']) ? (if(trim($form['physician_npi'])=='') ? 'N/A': $form['physician_npi']) : 'N/A';
            if(isset($form['physician_npi'])){
                if(trim($form['physician_npi'])==''){
                    $temppage['pcp_npi']='N/A';
                } 
                else {
                    $temppage['pcp_npi']=$form['physician_npi'];
                }
            }
            else{
                $temppage['pcp_npi']='N/A';
            }
             
             if(isset($form['date_of_birth'])){
                 $d1=($form['date_of_birth']);
                 //$d2=date("Y/m/d");
                 //$diff =  abs($d2 - $d1);
                 //$yeardif=floor($diff / (365*60*60*24));
                 
                 
                 $birthDate = explode("-", $d1);
                //get age from date or birthdate
                $yeardif = (date("md", date("U", mktime(0, 0, 0, $birthDate[1], $birthDate[2], $birthDate[0]))) > date("md") ? ((date("Y") - $birthDate[0]) - 1) : (date("Y") - $birthDate[0]));
                
                //$yeardif = (date("md", mktime(0, 0, 0, $birthDate[2], $birthDate[1], $birthDate[0])) > date("md") ? ((date("Y") - $birthDate[0]) - 1) : (date("Y") - $birthDate[0]));
                
                
                
                
                 
                 $temppage['age']=$yeardif.' Years Old';
             }
             else{
                 $temppage['age']='N/A';
             }
             

            $temppage['hba1c']=isset($form['hba1c']) ? $form['hba1c'] : '';
            
            $temppage['hba1c_date']=isset($form['hba1c_date']) ? $form['hba1c_date'] : '';
            
            if(isset($form['dv_od'])){
                if($form['dv_od']=='FC'){
                    if(isset($form['fcvals_od'])){
                        if($form['fcvals_od']=="HM"){
                            $temppage['dv_od']=$form['dv_od'].'-'.(isset($form['fcvals_od']) ? $form['fcvals_od'] : '');                
                        }
                        else{
                            $temppage['dv_od']=$form['dv_od'].'@'.(isset($form['fcvals_od']) ? $form['fcvals_od'] : '');                
                        }
                    
                    }
                    else{
                        $temppage['dv_od']=$form['dv_od'];
                    }
                    
                }
                else if($form['dv_od']!='HM' && $form['dv_od']!='L Proj' && $form['dv_od']!='LP' && $form['dv_od']!='NLP' && $form['dv_od']!='N/A' && (strpos($form['dv_od'],'20/')==false) && $form['dv_od']!='' ){
                    $temppage['dv_od']='20/'.$form['dv_od'];
                }
                else{
                    $temppage['dv_od']=$form['dv_od'];
                }
            }
            else{
                $temppage['dv_od']='';
            }
            
            if(isset($form['dv_os'])){
                if($form['dv_os']=='FC'){
                    if(isset($form['fcvals_os'])){
                        if($form['fcvals_os']=="HM"){
                            $temppage['dv_os']=$form['dv_os'].'-'.(isset($form['fcvals_os']) ? $form['fcvals_os'] : '');                
                        }
                        else{
                            $temppage['dv_os']=$form['dv_os'].'@'.(isset($form['fcvals_os']) ? $form['fcvals_os'] : '');                
                        }
                    
                    }
                    else{
                        $temppage['dv_os']=$form['dv_os'];
                    }
                   // $temppage['dv_os']=$form['dv_os'].'-'.(isset($form['fcvals_os']) ? $form['fcvals_os'] : '');    
                }
                else if($form['dv_os']!='HM' && $form['dv_os']!='L Proj' && $form['dv_os']!='LP' && $form['dv_os']!='NLP' && $form['dv_os']!='N/A' && (strpos($form['dv_os'],'20/')==false) && $form['dv_os']!='' ){
                    $temppage['dv_os']='20/'.$form['dv_os'];
                }
                else{
                    $temppage['dv_os']=$form['dv_os'];
                }
                
                
            }
            else{
                $temppage['dv_os']='';
            }
            
            //$temppage['dv_os']=isset($form['dv_os']) ? $form['dv_os'] : '';
            
            $temppage['last_exam_date']=isset($form['last_exam_date']) ? $form['last_exam_date'] : '';
            
            
            if(isset($form['iop_od'])){
            
                if($form['iop_od']=='FC'){
                    $temppage['iop_od']=$form['iop_od'].' '.(isset($form['fcvals_od']) ? $form['dv_od'] : '');
                }
                else{
                    $temppage['iop_od']=$form['iop_od'];
                }
            }
            else{
                $temppage['iop_od']='';
                
            }
            
            //$temppage['iop_os']=isset($form['iop_os']) ? $form['iop_os'] : '';
            if(isset($form['iop_os'])){
            
                if($form['iop_os']=='FC'){
                    $temppage['iop_os']=$form['iop_os'].' '.(isset($form['fcvals_os']) ? $form['dv_os'] : '');
                }
                else{
                    $temppage['iop_os']=$form['iop_os'];
                }
            }
            else{
                $temppage['iop_os']='';
                
            }
            
            if(isset($form['exam_time'])){
                $temppage['exam_time'] = $form['exam_time'];
                $temppage['exam_time_ampm']=isset($form['exam_time_ampm']) ? $form['exam_time_ampm'] : 'AM';
            } 
            else{
                $temppage['exam_time'] = '';
                $temppage['exam_time_ampm']=isset($form['exam_time_ampm']) ? $form['exam_time_ampm'] : '';
            }
            
            
            
            $temppage['ta_tp']=isset($form['ta_tp']) ? $form['ta_tp'] : '';
            
            $temppage['angle_od']=isset($form['angle_od']) ? $form['angle_od'] : '';
            
            $temppage['angle_os']=isset($form['angle_os']) ? $form['angle_os'] : '';
            
            
            $angleosval='';
            $angleodval='';
            
            if(isset($form['angle_os']) && $form['angle_os']!=''){
                if($form['angle_os']=='open'){
                    $angleosval="Open";
                }
                else if($form['angle_os']=='moderate'){
                    $angleosval="Moderate";
                }
                else if($form['angle_os']=='narrow'){
                    $angleosval="Narrow";
                }
                else{
                    $angleosval=$form['angle_os'];
                }
                
            }
            else{
                //radion buttons
                if(isset($form['os_pupil']) && $form['os_pupil']!='' && $form['os_pupil']!='0'){
                    $angleosval="Grade ".$form['os_pupil'];
                }
            }
            
            $temppage['angleosval']=$angleosval;
            
            if(isset($form['angle_od']) && $form['angle_od']!=''){
                if($form['angle_od']=='open'){
                    $angleodval="Open";
                }
                else if($form['angle_od']=='moderate'){
                    $angleodval="Moderate";
                }
                else if($form['angle_od']=='narrow'){
                    $angleodval="Narrow";
                }
                else{
                    $angleodval=$form['angle_od'];
                }
                
            }
            else{
                //radion buttons
                if(isset($form['od_pupil']) && $form['od_pupil']!='' && $form['od_pupil']!='0'){
                    $angleodval="Grade ".$form['od_pupil'];
                }
            }
            $temppage['angleodval']=$angleodval;
            
            
            
                        
            if(isset($form['dilation'] )){
                $temppage['dilation']=$form['dilation'];
            }
            else{
                $temppage['dilation']= '';
            }
            //$cbdil=true;
            
            /*
            $dilval='';
            $cbdil=false;
            if( isset($form['dilation_none'])){
                if($form['dilation_none']=='Y'){
                    if($dilval!=''){
                        $dilval.=', ';
                    }
                    $dilval.='None';
                    $cbdil=true;
                }
            }
            
            if( isset($form['dilation_fivem'])){
                if($form['dilation_fivem']=='Y'){
                    if($dilval!=''){
                        $dilval.=', ';
                    }
                    $cbdil=true;
                    $dilval.='0.5% M';
                }
            }
            
            if( isset($form['dilation_onem'])){
                if( $form['dilation_onem']=='Y' ){
                    if($dilval!=''){
                        $dilval.=', ';
                    }
                    $cbdil=true;
                    $dilval.='1.0% M';
                }
            }
            
            if( isset($form['dilation_twentyfiven'])){
                if( $form['dilation_twentyfiven']=='Y' ){
                    if($dilval!=''){
                        $dilval.=', ';
                    }
                    $cbdil=true;
                    $dilval.='2.5% N';
                }
            }
            if($dilval==''){
                $dilval='None';
            }
            //if($cbdil){
                $temppage['dilation']=$dilval;
            //}
            
            */
            //dilation vals
            $temppage['dilation_none']=isset($form['dilation_none']) ? 'X' : '';               
            $temppage['dilation_fivem']=isset($form['dilation_fivem']) ? 'X' : '';   
            $temppage['dilation_onem']=isset($form['dilation_onem']) ? 'X' : '';   
            $temppage['dilation_twentyfiven']=isset($form['dilation_twentyfiven']) ? 'X' : '';   
            
            
             
            if(isset($form['dilation_time'])){
                $temppage['dilation_time']= $form['dilation_time'];                    
                $temppage['dilation_ampm']=isset($form['dilation_ampm']) ? $form['dilation_ampm'] : 'AM';    
            }
            else{
                $temppage['dilation_time']= '';    
                $temppage['dilation_ampm']=isset($form['dilation_ampm']) ? $form['dilation_ampm'] : '';
            }
            
            $temppage['ipa_other_box']=isset($form['ipa_other_box']) ? $form['ipa_other_box'] : '';
            
            $temppage['exam_finding']=isset($form['exam_finding']) ? $form['exam_finding'] : '';
            
            $temppage['diag_code_e11_9']=isset($form['diag_code_e11_9']) ? (($form['diag_code_e11_9']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e10_9']=isset($form['diag_code_e10_9']) ? (($form['diag_code_e10_9']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e11_65']=isset($form['diag_code_e11_65']) ? (($form['diag_code_e11_65']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e10_65']=isset($form['diag_code_e10_65']) ? (($form['diag_code_e10_65']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e11_39']=isset($form['diag_code_e11_39']) ? (($form['diag_code_e11_39']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e10_39']=isset($form['diag_code_e10_39']) ? (($form['diag_code_e10_39']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['other_diabetes']=isset($form['other_diabetes']) ? (($form['other_diabetes']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e11_319']=isset($form['diag_code_e11_319']) ? (($form['diag_code_e11_319']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e10_319']=isset($form['diag_code_e10_319']) ? (($form['diag_code_e10_319']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e11_311']=isset($form['diag_code_e11_311']) ? (($form['diag_code_e11_311']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e10_311']=isset($form['diag_code_e10_311']) ? (($form['diag_code_e10_311']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            
            
            if(isset($form['retinopathy'])){
               //retinopathy
                $val=$form['retinopathy'];
                $gen='';
                if($val=='B'){
                    //$gen='Background diabetic retinopathy';
                    $gen='retinopath_background';
                }
                else if($val=="C" || $val=="P"){
                    //$gen='Proliferative diabetic retinopathy';    
                    $gen='retinopath_proliferative';
                }
                else if($val=="A" || $val=="N"){
                    //$gen='No diabetic retinopathy';                    
                    $gen='retinopath_no';
                }
                
                $temppage['retinopathy']=$gen;
            }
            else{
                $temppage['retinopathy']='';
            }
            
            //$temppage['retinopathy']=isset($form['retinopathy']) ? $form['retinopathy'] : 'retinopath_no';
            
            $temppage['od_pupil']=isset($form['od_pupil']) ? $form['od_pupil'] : '';
            $temppage['os_pupil']=isset($form['os_pupil']) ? $form['os_pupil'] : '';
            
            
            $temppage['location_id']=isset($form['location_id']) ? $form['location_id'] : 'N/A';
            
            
            $temppage['sorc']=isset($form['sorc']) ? $form['sorc'] : '';
            
            $temppage['lbl_code_e11_321']=isset($form['lbl_code_e11_321']) ? (($form['lbl_code_e11_321'])==''?'E 11.321':$form['lbl_code_e11_321']) : 'E 11.321';
            
            $temppage['lbl_code_e10_321']=isset($form['lbl_code_e10_321']) ? (($form['lbl_code_e10_321'])==''?'E 10.321':$form['lbl_code_e10_321']) : 'E 10.321';
            
            $temppage['lbl_code_e11_329']=isset($form['lbl_code_e11_329']) ? (($form['lbl_code_e11_329'])==''?'E 11.329':$form['lbl_code_e11_329']) : 'E 11.329';
            
            $temppage['lbl_code_e10_329']=isset($form['lbl_code_e10_329']) ? (($form['lbl_code_e10_329'])==''?'E 10.329':$form['lbl_code_e10_329']) : 'E 10.329';
            
            $temppage['lbl_code_e11_331']=isset($form['lbl_code_e11_331']) ? (($form['lbl_code_e11_331'])==''?'E 11.331':$form['lbl_code_e11_331']) : 'E 11.331';
            
            $temppage['lbl_code_e10_331']=isset($form['lbl_code_e10_331']) ? (($form['lbl_code_e10_331'])==''?'E 10.331':$form['lbl_code_e10_331']) : 'E 10.331';
            
            $temppage['lbl_code_e11_339']=isset($form['lbl_code_e11_339']) ? (($form['lbl_code_e11_339'])==''?'E 11.339':$form['lbl_code_e11_339']) : 'E 11.339';
            
            $temppage['lbl_code_e10_339']=isset($form['lbl_code_e10_339']) ? (($form['lbl_code_e10_339'])==''?'E 10.339':$form['lbl_code_e10_339']) : 'E 10.339';
            
            $temppage['lbl_code_e11_341']=isset($form['lbl_code_e11_341']) ? (($form['lbl_code_e11_341'])==''?'E 11.341':$form['lbl_code_e11_341']) : 'E 11.341';
            
            $temppage['lbl_code_e10_341']=isset($form['lbl_code_e10_341']) ? (($form['lbl_code_e10_341'])==''?'E 10.341':$form['lbl_code_e10_341']) : 'E 10.341';
            
            $temppage['lbl_code_e11_349']=isset($form['lbl_code_e11_349']) ? (($form['lbl_code_e11_349'])==''?'E 11.349':$form['lbl_code_e11_349']) : 'E 11.349';
            
            $temppage['lbl_code_e10_349']=isset($form['lbl_code_e10_349']) ? (($form['lbl_code_e10_349'])==''?'E 10.349':$form['lbl_code_e10_349']) : 'E 10.349';
            
            $temppage['lbl_code_e11_351']=isset($form['lbl_code_e11_351']) ? (($form['lbl_code_e11_351'])==''?'E 11.351':$form['lbl_code_e11_351']) : 'E 11.351';
            
            $temppage['lbl_code_e10_351']=isset($form['lbl_code_e10_351']) ? (($form['lbl_code_e10_351'])==''?'E 10.351':$form['lbl_code_e10_351']) : 'E 10.351';
            
            $temppage['lbl_code_e11_359']=isset($form['lbl_code_e11_359']) ? (($form['lbl_code_e11_359'])==''?'E 11.359':$form['lbl_code_e11_359']) : 'E 11.359';
            
            $temppage['lbl_code_e10_359']=isset($form['lbl_code_e10_359']) ? (($form['lbl_code_e10_359'])==''?'E 10.359':$form['lbl_code_e10_359']) : 'E 10.359';
            
            
            // ipa_box ->	check if correct
            // $temppage['ipa_box']=isset($form['ipa_box']) ? getipaname($form['ipa_box']) : '';
            if(isset($form['ipa_box'])){
                
                $fullipa=$form['ipa_box'];
                if(isset($form['ipa_other_box'])){
                    $fullipa.=' - '.$form['ipa_other_box'];
                }
                
                
                //$aquicktest=($form['ipa_box']);
                //if($aquicktest==''){
                //    $aquicktest='Nope';
                //}
                //else{
                //    $test=(int)$aquicktest;
                //    $aval= $this->getipaname($test);
                //    $bbb='';
                    /*
                    if(isset($aval)){
                        foreach ($aval as $ff) {
                            if(isset($ff['thename'])){

                            }
                        }
                    }
                      */      
                    
                //}
                
                
                $temppage['ipa_box']=$fullipa;
                
            }
            else{
                $temppage['ipa_box']='N/A';
            }
            
            
            $temppage['diag_code_e11_321']=isset($form['diag_code_e11_321']) ? (($form['diag_code_e11_321']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e10_321']=isset($form['diag_code_e10_321']) ? (($form['diag_code_e10_321']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e11_329']=isset($form['diag_code_e11_329']) ? (($form['diag_code_e11_329']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e10_329']=isset($form['diag_code_e10_329']) ? (($form['diag_code_e10_329']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e11_331']=isset($form['diag_code_e11_331']) ? (($form['diag_code_e11_331']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e10_331']=isset($form['diag_code_e10_331']) ? (($form['diag_code_e10_331']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e11_339']=isset($form['diag_code_e11_339']) ? (($form['diag_code_e11_339']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e10_339']=isset($form['diag_code_e10_339']) ? (($form['diag_code_e10_339']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
                                    
            $temppage['diag_code_e11_341']=isset($form['diag_code_e11_341']) ? (($form['diag_code_e11_341']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e10_341']=isset($form['diag_code_e10_341']) ? (($form['diag_code_e10_341']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
                                    
            $temppage['diag_code_e11_349']=isset($form['diag_code_e11_349']) ? (($form['diag_code_e11_349']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e10_349']=isset($form['diag_code_e10_349']) ? (($form['diag_code_e10_349']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e11_351']=isset($form['diag_code_e11_351']) ? (($form['diag_code_e11_351']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e10_351']=isset($form['diag_code_e10_351']) ? (($form['diag_code_e10_351']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e11_359']=isset($form['diag_code_e11_359']) ? (($form['diag_code_e11_359']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['diag_code_e10_359']=isset($form['diag_code_e10_359']) ? (($form['diag_code_e10_359']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            if(isset($form['retinal_referral_period'])){
                $val=$form['retinal_referral_period'];
                $gen='';
                if($val=='Weeks'){
                    $gen='Wks';
                }
                else if($val=="Months"){
                    $gen='Mos';    
                }
                else if($val=="Days"){
                    $gen='Days';                    
                }                
                $temppage['retinal_referral_period']=$gen;
            }
            
            if(isset($form['opth_referral_period'])){
                $val=$form['opth_referral_period'];
                $gen='';
                if($val=='Weeks'){
                    $gen='Wks';
                }
                else if($val=="Months"){
                    $gen='Mos';    
                }
                else if($val=="Days"){
                    $gen='Days';                    
                }                
                $temppage['opth_referral_period']=$gen;
            }
            
            if(isset($form['eye_exam_period'])){
                $val=$form['eye_exam_period'];
                $gen='';
                if($val=='Weeks'){
                    $gen='Wks';
                }
                else if($val=="Months"){
                    $gen='Mos';    
                }
                else if($val=="Days"){
                    $gen='Days';                    
                }                
                $temppage['eye_exam_period']=$gen;
            }

            
            
            
            
            $temppage['pc_s3000']=isset($form['pc_s3000']) ? (($form['pc_s3000']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['pc_2022f_8p']=isset($form['pc_2022f']) ? (($form['pc_2022f']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            if(isset($form['pc_2022f_8p'])){
                if(($form['pc_2022f_8p']==('Y' || 'Yes' || 'YES'))){
                    $temppage['twotwoftitle']='2022F-8P';
                    $temppage['twotwofwords']='No DFE';
                    $temppage['pc_2022f_8p']='X';
                }
                else{
                    $temppage['twotwoftitle']='2022F';
                    $temppage['twotwofwords']='DFE w/ review and interpret';
                }
            }
            else{
               $temppage['twotwoftitle']='2022F';
               $temppage['twotwofwords']='DFE w/ review and interpret';
                
            }
            //if 8p 
            
            //twotwoftitle
            
            //twotwofwords
            
            
            $temppage['pc_3072f']=isset($form['pc_3072f']) ? (($form['pc_3072f']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['pc_5010f']=isset($form['pc_5010f']) ? (($form['pc_5010f']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
                        
            //
            $temppage['pc_g8397']=isset($form['pc_g8397']) ? (($form['pc_g8397']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['pc_92227']=isset($form['pc_92227']) ? (($form['pc_92227']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['pc_92228']=isset($form['pc_92228']) ? (($form['pc_92228']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['pc_2026f']=isset($form['pc_2026f']) ? (($form['pc_2026f']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            if(isset($form['images_unreadable'])){
                if($form['images_unreadable']==('Y' || 'Yes' || 'YES')){
                    $temppage['retinopathy']='';
                    $temppage['images_unreadable']='X';    
                }
                else{
                    $temppage['images_unreadable']= '';        
                }
            }
            else{
                $temppage['images_unreadable']= '';    
            }
            //$temppage['images_unreadable']=isset($form['images_unreadable']) ? (($form['images_unreadable']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['eye_exam']=isset($form['eye_exam']) ? (($form['eye_exam']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['eye_exam_period_quantity']=isset($form['eye_exam_period_quantity']) ? $form['eye_exam_period_quantity'] : '';
            
            $temppage['opth_referral']=isset($form['opth_referral']) ? (($form['opth_referral']==('Y' || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['opth_referral_period_quantity']=isset($form['opth_referral_period_quantity']) ? $form['opth_referral_period_quantity'] : '';
            
            $temppage['retinal_referral']=isset($form['retinal_referral']) ? (($form['retinal_referral']==(('Y' || 'Yes' || 'YES') || 'Yes' || 'YES'))?'X':'') : '';
            
            $temppage['retinal_referral_period_quantity']=isset($form['retinal_referral_period_quantity']) ? $form['retinal_referral_period_quantity'] : '';
            
            //need to change (?) -> have to remove extra lines for comments
            $temppage['comment']=isset($form['comment']) ? $form['comment'] : '';
            
            $temppage['email']=$theemail;
            
            if(isset($form['doctor']) && isset($form['license_number']) && isset($form['od_signed_date']) && isset($form['od_signed_time']) ){
                
                $temppage['od_signature']='Electronically Signed By: '.$form['doctor'].' ('.$form['license_number'].') on '.$form['od_signed_date'].'@'.$form['od_signed_time'];
                
            }
                
            if($searchid=='' || $searchid==$form['event_id'])
                $results[] = $temppage;
                
            
             
        }
        
        
        return $results;
    }
    
    public function getipaname($theval){
        
        if ( is_numeric($theval) == true){
            
        $query = <<<SQL
SELECT CASE WHEN a.sub_name ="" THEN b.ipa_name ELSE CONCAT(b.ipa_name,' - ', a.sub_name) END AS thename
FROM vision_ipa_sub AS a
INNER JOIN vision_ipa AS b
ON a.ipa_parent_id=b.ipa_id
WHERE a.sub_id= '{$theval}'
SQL;
         
        
               $ttt=$this->query($query);
               
               
                
               
               
               if (count($ttt)>0) {
                    $result = $ttt->toArray();
                    return $result[0]['thename'];
                }
                else{
                    
                    return $theval;
                }
        }     
        else{ return $theval;}
        
        
    }
    
    
    
    
    
    
    
    
    
    public function getidfromod(){
        
       
        $val=0;
        $val=$_GET['selectedorder'];
        $a=''; 
        if($val!=0 && isset($val) && $val!='' ){
            $query = <<<SQL
             SELECT id
              FROM vision_od_predetermined 
              WHERE od_id = {$val}
              
                 
SQL;
      
       
        $a= $this->query($query);
      
        }
        
        
        return $a;
    }
    
    
    
    
}