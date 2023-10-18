<?php
namespace Code\Main\Vision\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * IPA related queries
 *
 * see Description
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Ipas.html
 * @since      File available since Release 1.0.0
 */
class Ipas extends Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Calculates a random color and highlight for graphing purposes
     * 
     * @return type
     */
    protected function graphColor() {
        $rh = ($r = random_int(50,210)) + 20;
        $gh = ($g = random_int(50,210)) + 20;
        $bh = ($b = random_int(50,210)) + 20;
        return [
            'color' => '#'.dechex($r).''.dechex($g).''.dechex($b),
            'highlight' => '#'.dechex($rh).''.dechex($gh).''.dechex($bh)
        ];
    }

    /**
     * Looks up the IPA ID (if they have one) of the current user
     * 
     * @return int
     */
    protected function getMyIpaId() {
        $data = $this->setUserId(Environment::whoAmI())->load(true);
        return ($data && isset($data['id'])) ? $data['id'] : false;
    }
    
    /**
     * Groups the forms by client
     * 
     * @return iterator
     */
    public function formsByHealthPlan($ipa_id=false) {
        $results = [];
        if ($ipa_id = ($ipa_id) ? $ipa_id : ($this->getIpaId() ? $this->getIpaId() : $this->getMyIpaId())) {
            $query = <<<SQL
                SELECT screening_client, COUNT(*) AS tot
                  FROM vision_consultation_forms 
                 WHERE ipa_id = '{$ipa_id}'
                   AND screening_client IS NOT NULL
                 GROUP BY screening_client
SQL;
            $results = $this->query($query)->toArray();
            foreach ($results as $idx => $row) {
                $results[$idx] = array_merge($row,$this->graphColor());
            }
        }
        return $results;
    }

    /**
     * Provides the data for the screenings by month pie chart
     * 
     * @return array
     */
    public function screeningsByMonth() {
        $values = [0=>0,1=>0,2=>0,3=>0,4=>0,5=>0,6=>0,7=>0,8=>0,9=>0,10=>0,11=>0];
        $labels = ['January','February','March','April','May','June','July','August','September','October','November','December'];
        if ($pcp = $this->primaryCarePhysicianData()) {
            if (isset($pcp['npi']) && $pcp['npi']) {
                $this->setNpi($pcp['npi']);
                foreach ($this->screeningFormsByPCP(false,date('Y')) as $form) {
                    $d = explode('-',$form['created']);
                    $values[(int)$d[1]-1]++;
                }   
            }
        }
        return ['values'=>$values,'labels'=>$labels];
    }
    
    /**
     * Groups the forms by technician
     * 
     * @return iterator
     */
    public function formsByTechnician($ipa_id=false) {
        $labels     = [];
        $values     = [];
        if ($ipa_id = ($ipa_id) ? $ipa_id : ($this->getIpaId() ? $this->getIpaId() : $this->getMyIpaId())) {
            $query = <<<SQL
                SELECT CONCAT(b.first_name,' ',b.last_name) AS tech, a.tot 
                  FROM
                (SELECT technician, COUNT(*) AS tot
                 FROM vision_consultation_forms 
                WHERE ipa_id = {$ipa_id}
                  AND technician IS NOT NULL
                GROUP BY technician) AS a
                LEFT OUTER JOIN humble_user_identification AS b
                  ON a.technician = b.id
SQL;
            foreach ($this->query($query) as $row) {
                $labels[] = $row['tech'];
                $values[] = $row['tot'];
            }
        }
        return ['labels'=>$labels,'values'=>$values];
    }
    
    /**
     * Groups the forms by physician
     * 
     * @return iterator
     */
    public function formsByPhysician($ipa_id=false) {
        $labels     = [];
        $values     = [];
        $results    = [];
        if ($ipa_id = ($ipa_id) ? $ipa_id : ($this->getIpaId() ? $this->getIpaId() : $this->getMyIpaId())) {
            $query = <<<SQL
                SELECT CONCAT(b.first_name,' ',b.last_name) AS doc, a.tot 
                  FROM
                (SELECT physician_npi_combo, COUNT(*) AS tot
                 FROM vision_consultation_forms 
                WHERE ipa_id = '{$ipa_id}'
                  AND physician_npi_combo IS NOT NULL
                GROUP BY physician_npi_combo) AS a
                LEFT OUTER JOIN argus_primary_care_physicians AS b
                  ON a.physician_npi_combo = b.npi   
                WHERE b.first_name IS NOT NULL
SQL;
            $results = $this->query($query)->toArray();
            foreach ($results as $idx => $row) {
                $results[$idx] = array_merge($row,$this->graphColor());
            }
        }
        return $results;
    }
    
    /**
     * Groups the forms by physician
     * 
     * @return iterator
     */
    public function formsByLocation($ipa_id=false) {
        $labels     = [];
        $values     = [];
        $results    = [];
        if ($ipa_id = ($ipa_id) ? $ipa_id : ($this->getIpaId() ? $this->getIpaId() : $this->getMyIpaId())) {
            $query = <<<SQL
                SELECT address_id_combo as address, COUNT(*) AS tot
                 FROM vision_consultation_forms 
                WHERE ipa_id = '{$ipa_id}'
                  AND address_id_combo IS NOT NULL
                GROUP BY address_id_combo
SQL;
            $results = $this->query($query)->toArray();
            foreach ($results as $idx => $row) {
                $results[$idx] = array_merge($row,$this->graphColor());
            }
        }
        return $results;
    }
    
    /**
     * Lists forms by screening client and then physician
     * 
     * @param type $uid
     * @return type
     */
    public function ipaFormsByClients($uid=false) {
        $results = [];
        if ($uid = ($uid) ? $uid : ($this->getUserId() ? $this->getUserId() : Environment::whoAmI())) {
            $data = Argus::getEntity('vision/ipas')->setUserId($uid)->load(true);
            $query = <<<SQL
               select a.*,
                    concat(b.first_name, ' ', b.last_name) as physician
                 from vision_consultation_forms as a
                 left outer join argus_primary_care_physicians as b
                   on a.physician_npi = b.npi
                where ipa_id = '{$data['id']}'
                order by screening_client, physician
SQL;
            $results = $this->query($query)->toArray();
        }
        return $results;
    }
    
    /**
     * Lists forms by screening client and then physician
     * 
     * @param type $uid
     * @return type
     */
    public function ipaFormsByPhysician($uid=false) {
        $results = [];
        if ($uid = ($uid) ? $uid : ($this->getUserId() ? $this->getUserId() : Environment::whoAmI())) {
            $data = Argus::getEntity('vision/ipas')->setUserId($uid)->load(true);
            $query = <<<SQL
               select a.*,
                    concat(b.first_name, ' ', b.last_name) as physician
                 from vision_consultation_forms as a
                 left outer join argus_primary_care_physicians as b
                   on a.physician_npi = b.npi
                where ipa_id = '{$data['id']}'
                order by physician, screening_client
SQL;
            $results = $this->with('vision/consultation/forms')->on('id')->query($query)->toArray();
        }
        return $results;
        
    }
    
    /**
     * 
     * @param type $ipa_id
     * @return type
     */
    public function export($ipa_id = false) {
        $results = [];
        if (!$ipa_id = ($ipa_id) ? $ipa_id : ($this->getIpaId() ? $this->getIpaId() : false)) {
            if (count($ipa = $this->reset()->setUserId(Environment::whoAmI())->load(true))) {
                $ipa_id = $ipa['id'];
            }
        }
        if ($ipa_id) {
            foreach ($this->normalize(Argus::getEntity('vision/consultation/forms')->setStatus('C')->setIpaId($ipa_id)->fetch()) as $form) {
                $form['procedure_codes'] = '';
                $form['diagnosis_codes'] = '';
                $form['biometrics']      = 'FBS='.(isset($form['fbs']) && $form['fbs'] ? $form['fbs'] : 'N/A').'['.(isset($form['fbs_date']) && $form['fbs_date'] ? $form['fbs_date'] : 'N/A').'],HBA1C='.(isset($form['hba1c']) && $form['hba1c'] ? $form['hba1c'] : 'N/A').'['.(isset($form['hba1c_date']) && $form['hba1c_date'] ? $form['hba1c_date'] : 'N/A').']';
                $form['comment'] = isset($form['comment']) ?  str_replace(["\r","\n"],[" "," "],$form['comment']): '';
                foreach ($form as $field => $value) {
                    if (substr($field,0,3) === 'pc_') {
                        if (strtoupper($value)==='Y') {
                            $field = strtoupper(substr($field,3));
                            $form['procedure_codes'] = ($form['procedure_codes']) ? $form['procedure_codes'].",".$field : $field;
                        }
                    } else if (substr($field,0,9)==='lbl_code_') {
                        if (trim($value)) {
                            $form['diagnosis_codes'] = ($form['diagnosis_codes']) ? $form['diagnosis_codes'].",".$value : $value;
                        }
                    } else if (substr($field,0,10)==='diag_code_') {
                        if (strtoupper($value)==='Y') {
                            $field = str_replace('_','.',strtoupper(substr($field,10)));
                            $form['diagnosis_codes'] = ($form['diagnosis_codes']) ? $form['diagnosis_codes'].",".$field : $field;
                        }
                    }
                }
                $results[] = $form;
            }
            $report = Argus::report($results,'ipa_export');
        }
        return Argus::getHelper('argus/CSV')->toCSV($report,',','"',true);
    }
    
    /**
     * 
     */
    public function ipasWithoutLastNames() {
        $query = <<<SQL
            SELECT c.user_id, c.ipa FROM humble_users AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.uid = b.id
              LEFT OUTER JOIN vision_ipas AS c
                ON a.uid = c.user_id
             WHERE b.first_name IS NULL
               AND b.last_name IS NULL
               AND c.ipa IS NOT NULL                
SQL;
        return $this->query($query);
    }
}