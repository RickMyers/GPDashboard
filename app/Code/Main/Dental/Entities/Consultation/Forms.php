<?php
namespace Code\Main\Dental\Entities\Consultation;
use Argus;
use Log;
use Environment;
/**
 *
 * Consultation Form Queries
 *
 * Compound and Complex Queries pertaining to the forms we use for remote
 * Dental consultations
 *
 * PHP version 5.5+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @since      File available since Release 1.0.0
 */
class Forms extends \Code\Main\Dental\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Polyglot magic 4TW!
     *
     * @return type
     */
    public function consultationInformation() {
        $results = [];
        if ($id = $this->getId() ? $this->getId() : ($this->getFormId() ? $this->getFormId() : false)) {
            $query = <<<SQL
                 SELECT a.id, a.id as form_id, a.visit_date, a.submit_date, a.last_activity_date, a.review_by_date, a.member_id, a.member_name, a.`status`,
			CONCAT(b.first_name,' ',b.last_name) AS hygienist,
			CONCAT(c.first_name,' ',c.last_name) AS dentist
		   FROM dental_consultation_forms AS a
		   LEFT OUTER JOIN humble_user_identification AS b
		     ON a.hygienist = b.id
		   LEFT OUTER JOIN humble_user_identification AS c
		     ON a.dentist = c.id
                 where a.id = '{$id}'
SQL;
            $results = $this->with('dental/consultation_forms')->on('id')->query($query);
        } else {
            $id = $this->save();
            $results = $this->reset()->setId($id)->load();
        }
        return $results;
    }

    public function queueContents() {
        $status_clause = ($this->getStatus()) ? " where a.`status` = '".$this->getStatus()."' " : "";
        $query = <<<SQL
        SELECT a.id AS form_id, a.member_id, a.member_name, a.last_activity_date, a.review_by_date,
               CONCAT(b.first_name,' ',b.last_name) AS hygienist, b.gender as hygienist_gender,
               CONCAT(c.first_name,' ',c.last_name) AS dentist, c.gender as dentist_gender
          FROM dental_consultation_forms AS a
          LEFT OUTER JOIN humble_user_identification AS b
            ON a.hygienist = b.id
          LEFT OUTER JOIN humble_user_identification AS c
            ON a.dentist = b.id
            {$status_clause}
SQL;
        return $this->query($query);
    }

    /**
     * Captures the form ID from the save and assigns that to the waiting room
     */
    public function newConsultation() {
        $this->setFormId($form_id = $this->save());
        $room = Argus::getEntity('dental/waiting_rooms')->setHygienist(Environment::whoAmI())->setFormId($form_id)->save();
    }
    
    /**
     * Does a search against either a member ID or member name... will also add member address at some time
     * 
     * @return iterator
     */
    public function search($field=false,$text=false) {
        $text = $this->getText();
            $query = <<<SQL
             select *
               from dental_consultation_forms
               where member_name like '%{$text}%'
                  or member_id like '%{$text}%'
SQL;
        return $this->query($query);
    }    

}