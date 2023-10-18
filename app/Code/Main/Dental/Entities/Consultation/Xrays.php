<?php
namespace Code\Main\Dental\Entities\Consultation;
use Argus;
use Log;
use Environment;
/**
 *
 * Consultation XRAY Queries
 *
 * see title
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Xrays.html
 * @since      File available since Release 1.0.0
 */
class Xrays extends \Code\Main\Dental\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Generates just a list of the smaller thumbnails of snapshots
     * 
     * @return iterator
     */
    public function thumbnails() {
        $query = <<<SQL
         select id, form_id, member_id, thumbnail
           from dental_consultation_xrays
          where form_id = '{$this->getFormId()}'
SQL;
        $results = $this->query($query);
        return $results;
    }    
    
    /**
     * "Claims" any x-rays that have been uploaded but aren't attached to a form to the form id that was passed in
     */
    public function claim() {
        $member_id  = $this->getMemberId();
        $form_id    = $this->getFormId();
        if ($member_id && $form_id) {
            $query = <<<SQL
            update dental_consultation_xrays
               set form_id = '{$form_id}'
             where member_id = '{$member_id}'
               and form_id is null
SQL;
            $this->query($query);
        }
    }
}