<?php
namespace Code\Main\Scheduler\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Scheduler Event Methods
 *
 * see title
 *
 * PHP version 7.2+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@argusdentalvision.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Events.html
 * @since      File available since Release 1.0.0
 */
class Events extends Model
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
     * Actually puts the event on the calendar and enables it
     */
    public function schedule() {
        //First let's activate the event
        $event_id   = $this->getEventId();
        $role_data  = Argus::getEntity('argus/roles')->setName('Scheduling')->load(true);
        $role_id    = $role_data['id'];
        $event_day  = \Humble::getEntity('scheduler/event_dates');
        $event      = \Humble::getEntity('scheduler/events')->setId($event_id);
        $event->setActive('Y')->save();
        
        //Now let's schedule the event days
        $event_data = $event->load();
        $epoch_day  = 60*60*24;
        $days       = 0;
        $start_date = strtotime($event_data['start_date'].' '.$event_data['start_time']);
        $end_date   = strtotime($event_data['end_date'].' '.$event_data['end_time']);
        $days=0;
        while ($start_date < $end_date) {
            $event_day->reset()->setDate(date('Y-m-d',$start_date))->setEventId($event_id)->save();
            $start_date += $epoch_day;            
            if (++$days >= 100) {
                break;                                                          //We are not going to allow for an infinite loop
            }
        };
        
        //And then let's add this to people's calendar
        $user_id = $this->getUserId();
        Argus::getEntity('scheduler/event_participants')->setEventId($event_id)->setRoleId($role_id)->setUserId($user_id)->save();
        Argus::emit('userCalendar'.$this->getUserId().'Update',['event_id'=>$event_id]);
    }
    
    /**
     * Gets a list of events that match some criteria
     * 
     * @return type
     */
    public function listEvents() {
        $results    = [];
        $technician = $this->getTechnician();
        $reviewer   = $this->getOd();
        $year       = $this->getYear();
        $month      = $this->getMonth();
        $start_date = ($month) ? $year.'-'.$month.'-01' : $year.'-01-01';
        $end_date   = ($month) ? $year.'-'.$month.'-31' : $year.'-12-31';
        if ($technician) {
            $results = Argus::getEntity('scheduler/event/participants')->_normalize(true)->_dynamic(true)->_alias('a')->startDateBetween($start_date,$end_date)->setRoleId(6)->setUserId($technician)->list();
        } else if ($reviewer) {
            $results = Argus::getEntity('scheduler/event/participants')->_normalize(true)->_dynamic(true)->_alias('a')->startDateBetween($start_date,$end_date)->setRoleId(13)->setUserId($reviewer)->list();
        } else {
            $results = Argus::getEntity('scheduler/event/participants')->_normalize(true)->_dynamic(true)->_alias('a')->startDateBetween($start_date,$end_date)->list();
        }
        return $results;
    }
}