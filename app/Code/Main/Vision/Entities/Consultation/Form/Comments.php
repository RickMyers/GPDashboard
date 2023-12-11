<?php
namespace Code\Main\Vision\Entities\Consultation\Form;
use Argus;
use Log;
use Environment;
/**
 *
 * Consultation Form Comment Queries
 *
 * Basic functionality for managing comments on forms
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Dashboard
 * @author     Rick Myers rmyers@aflacbenefitssolutions.com
 */
class Comments extends \Code\Main\Vision\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Returns the comments made on a form along with the name of the person who left them
     * 
     * @param int $form_id (optional)
     * @return iterator
     */
    public function fetch($form_id=false) {
        $results = [];
        if ($form_id = ($form_id) ? $form_id : ($this->getFormId() ? $this->getFormId() : false)) {
            $query = <<<SQL
            select a.*, 
                   concat(b.last_name, ', ',b.first_name) as commenter
              from vision_consultation_form_comments as a
              left outer join humble_user_identification as b
                on a.user_id = b.id
             where a.form_id = '{$form_id}'
SQL;
             $results = $this->query($query);
        }
        return $results;
    }
}