<?php
namespace Code\Main\Scheduler\Entities\Event;
use Argus;
use Log;
use Environment;
/**
 *
 * Event Participant Queries
 *
 * see title
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Application
 * @author     Rick Myers rick@humbleprogramming.com
 * @copyright  2007-Present, Rick Myers <rick@humbleprogramming.com>
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Participants.html
 * @since      File available since Release 1.0.0
 */
class Participants extends \Code\Main\Scheduler\Entities\Entity
{

    public function getClassName() {
        return __CLASS__;
    }
    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }
    
    /**
     * Returns information about a participants events, or just the events from a particular time period
     * 
     * @return type
     */
    public function list() {
        $query = <<<SQL
        SELECT distinct a.event_id,
               b.event_type_id, b.start_date, b.end_date, b.start_time, b.end_time, b.active,
               c.date,
               d.namespace, d.type
          FROM scheduler_event_participants AS a
          LEFT OUTER JOIN scheduler_events AS b
            ON a.event_id = b.id
           AND b.active = 'Y'
          LEFT OUTER JOIN scheduler_event_dates AS c
            ON b.id = c.event_id
          LEFT OUTER JOIN scheduler_event_types AS d
            ON b.event_type_id = d.id 
SQL;
        $resutls = $this->with('scheduler/events')->on('event_id')->query($query);
        $q = Log::general($this->lastQuery());
        return $resutls;
    }

}