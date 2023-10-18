<?php
namespace Code\Main\Dental\Entities\Waiting;
use Argus;
use Log;
use Environment;
/**
 *
 * Teledentistry support
 *
 * See Title
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Client
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Rooms.html
 * @since      File available since Release 1.0.0
 */
class Rooms extends \Code\Main\Dental\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Gets the currently active waiting rooms
     * 
     * @return iterator
     */
    public function details() {
        $query = <<<SQL
                SELECT a.id AS room_id,  a.hygienist, a.form_id, a.status,
                     CONCAT(b.first_name,' ',b.last_name) AS hygienist_name,
                     c.*
                  FROM dental_waiting_rooms AS a
                  LEFT OUTER JOIN humble_user_identification AS b
                    ON a.hygienist = b.id
                  LEFT OUTER JOIN dental_consultation_forms AS c
                    ON a.form_id = c.id
                 WHERE a.`status` = 'A' 
SQL;
        $results = $this->with('argus/user_settings')->on('hygienist')->query($query);
        return $this->query($query);
    }
    
    /**
     * 
     * @return type
     */
    public function myWaitingRoom() {
        $query = <<<SQL
            SELECT a.id, b.id AS user_id, a.session_start, a.form_id, a.`status`, CONCAT(b.last_name,', ',b.first_name) AS hygienist
              FROM dental_waiting_rooms AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.hygienist = b.id
             WHERE hygienist = {$this->getUserId()}
SQL;
       /* A little Polyglot Razzmatazz below... */
        $results = $this->with('argus/user_settings')->on('user_id')->query($query);
        return $results;
    }
    
    /**
     * For a new room, we first need to create a form for that room
     */
    public function newRoom() {
       /*
        * 0) Check to see if the form
        * 1) First create a new form
        * 2) Then create the room and bind it to the form
        */ 
        $this->setFormId(Argus::getEntity('dental/consultation_forms')->setCreatedBy($this->getUserId())->add());
        parent::save();
    }
}