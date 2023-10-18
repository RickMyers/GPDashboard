<?php
namespace Code\Main\Vision\Models;
use Argus;
use Log;
use Environment;
/**
 * 
 * Vision related functions and methods
 *
 *
 * PHP version 7.0+
 *
 * @category   Utility
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
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
     * Disassociates a user to an event by their role
     */
    public function clearAndUpdateActorsByRole() {
        $role = false;
        if (isset($this->_data['screeningOd']) && $this->_data['screeningOd']) {
            $role = 'O.D.';
        } else if (isset($this->_data['screeningTechnician']) && $this->_data['screeningTechnician']) {
            $role = 'PCP Staff';
        }
        if ($role) {
            $role_data = Argus::getEntity('argus/roles')->setName($role)->load(true);
            $role_id = $role_data['id'];
            foreach (Argus::getEntity('argus/user_roles')->getUsersByRoleName($role) as $actor) {
                $ids[] = $actor['user_id'];
            };
            Argus::getEntity('scheduler/event_participants')->setRoleId($role_id)->setEventId($this->getEventId())->userIdIn($ids)->delete(true);
            if ($user_id = $this->getScreeningOd() ? $this->getScreeningOd() : $this->getScreeningTechnician()) {
                Argus::getEntity('scheduler/event_participants')->setRoleId($role_id)->setEventId($this->getEventId())->setUserId($user_id)->save();
            }
        }
    }
    
    /**
     * Sends out notifications through sockets about event changed.
     */
    public function clearNotifications() {
        $role = false;
        if (isset($this->_data['screeningOd'])) {
            $role = 'O.D.';
        } else if ($this->_data['screeningTechnician']) {
            $role = 'PCP Staff';
        }
        if ($role) {
            foreach (Argus::getEntity('argus/user/roles')->getUsersByRoleName($role) as $actor) {
                $ids[] = $actor['user_id'];
            };
            
            foreach ($ids as $id) {
                Argus::emit('userCalendar'.$id.'Update',['event_id'=>$this->getEventId()]);
            }
        }
    }
    
    /**
     * Updates respective schedules if the value changed is related to a role like O.D. or technician
     */
    public function notifications() {
        $role = false;
        if (isset($this->_data['screeningOd']) && $this->_data['screeningOd']) {
            $role = 'O.D.';
        } else if (isset($this->_data['screeningTechnician']) && $this->_data['screeningTechnician']) {
            $role = 'PCP Staff';
        }
        if ($role) {
            foreach (Argus::getEntity('argus/user/roles')->getUsersByRoleName($role) as $actor) {
                Argus::emit('userCalendar'.$actor['user_id'].'Update',['event_id'=>$this->getEventId()]);
            };          
        }
    }
    
    /**
     * From an event_id, will attach recipient information to configurable nodes on an event
     * 
     * @workflow use(process) configuration(/vision/event/recipients)
     * @param type $EVENT
     */
    public function attachEventRecipients($EVENT=false) {
        if ($EVENT!==false) {
            if ($data   = $EVENT->load()) {
                $cfg    = $EVENT->fetch();
                if ($event_data = Argus::getEntity('scheduler/events')->setId($data['event_id'])->load()) {
                    if (isset($event_data['contact_email']) && $event_data['contact_email']) {
                        $EVENT->update([
                           'recipient' => [
                               'email' => $event_data['contact_email'],
                               'name'  => $event_data['contact_name'],
                               'phone' => $event_data['contact_phone']
                           ] 
                        ]);
                    }
                }
            }
        }
    }
    
    /**
     * From an event_id, will attach event information to configurable nodes on an event
     * 
     * @workflow use(process) configuration(/vision/event/attachdetails)
     * @param type $EVENT
     */
    public function attachEventDetails($EVENT=false) {
        if ($EVENT!==false) {
            if ($data   = $EVENT->load()) {
                $cfg    = $EVENT->fetch();
                if ($event_data = Argus::getEntity('scheduler/events')->setId($data['event_id'])->load()) {
                    $EVENT->update([
                       'event_details' => [
                           'location' => $event_data,
                           'members'  => Argus::getEntity('vision/event/members')->normalize(true)->setEventId($data['event_id'])->fetch()->toArray()
                       ]
                    ]);
                }
                
            }
        }
    }
    
    /**
     * Cancels an event (making inactive), then deletes any generated forms, and removes participants from the event.
     */
    public function cancelEvent() {
        if ($event_id = $this->getEventId()) {
            $generated_form = Argus::getEntity('vision/consultation/forms');
            Argus::getEntity('scheduler/events')->setId($event_id)->delete();
            Argus::getEntity('scheduler/event_dates')->setEventId($event_id)->delete();
            foreach (Argus::getEntity('vision/consultation/forms')->setEventId($event_id)->fetch() as $form) {
                if ($form['id'] && ($form['status']!=='C') && ($form['status']!=='Z')) {  //don't delete completed or archived forms
                    $generated_form->reset()->setId($form['id'])->delete();
                }
            } 
            $participants = Argus::getEntity('scheduler/event_participants')->setEventId($event_id)->fetch();
            Argus::getEntity('scheduler/event_participants')->setEventId($event_id)->delete();
            foreach ($participants as $participant) {
                Argus::emit('userCalendar'.$participant['user_id'].'Update',[]);
            }
        }
    }
    
    /**
     * Sends the notifications about the event being finished
     */
    public function close() {
        //this is deprecated... redo this as a notification
        if ($event_id = $this->getEventId()) {
            $forms   = Argus::getEntity('vision/consultation/forms')->setEventId($event_id)->fetch()->toArray();
            $data    = Argus::getEntity('scheduler/events')->setId($event_id)->load();
            $members = Argus::getEntity('vision/event_members')->setEventId($event_id)->fetch()->toArray();
            $templater = Environment::getInternalTemplater('lib/resources/email/templates/');
            $template  = Argus::emailTemplate('event_close');
            $templater->assign('event',$data);
            $templater->assign('referrals',0);
            $templater->assign('incomplete',2);
            $templater->assign('total',count($forms));
            $x = $templater->draw($template,true);
            //$n = $this->sendEmail('rmyers@argusdentalvision.com','Diabetic screening results from "'.$data['start_date'].'" are available via Hedis portal.',$x,'noreply@argusdentalvision.com');
                    
            
        }
    }
}
