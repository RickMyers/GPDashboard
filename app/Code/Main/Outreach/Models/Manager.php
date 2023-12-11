<?php
namespace Code\Main\Outreach\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Outreach actions
 *
 * General set of actions for our Outreach app
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Desktop
 * @author     Rick Myers <rmyers@aflacbenefitssolutions.com>
 */
class Manager extends Model
{

    use \Code\Base\Humble\Event\Handler;
  //  use \Spatie\Async\Pool;

	
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
     * Propagates a message to the client that person has begun working a contact
     */
    public function notifyContactCenter() {
        //include '/vendor/spatie/async/src/Pool.php';
        if ($contact_id = $this->getContactId()) {
            $data = Argus::getEntity('outreach/campaign/members')->setId($contact_id)->load();
            $data['user_id'] = Environment::whoAmI();
            //$pool = Pool::create();
         //   $pool->add(function () {
                Argus::emit('outreachContactOpened',$data);
          //  })->then(function ($output) {
                // Handle success
           // })->catch(function (Throwable $exception) {
                // Handle exception
           /// });            
            
        }
    }
    
    /**
     * Assigns a certain number of contacts to a person involved in a campaign
     */
    public function assign() {
        $contacts   = $this->getContacts();
        $assignee   = $this->getAssignee();
        $campaign   = $this->getCampaignId();
        if ($contacts && $assignee && $campaign) {
            $ctr = 0;
            $contact = Argus::getEntity('outreach/campaign/members');
            foreach (Argus::getEntity('outreach/campaign/members')->setStatus('N')->setCampaignId($campaign)->fetch() as $available) {
                $contact->reset()->setId($available['id'])->setAssignee($assignee)->setStatus('A')->save();
                if (++$ctr >= $contacts) {
                    break;
                }
            }
        }
        Argus::emit('coordinator'.$assignee.'Campaign'.$campaign.'ContactsAssigned',['uid'=>$assignee, 'contacts'=>$contacts]);
    }
    
    /**
     * Increments the total number of times a contact was attempted
     * 
     * @param mixed $id
     * @return int
     */
    public function recordAttempt($id=false) {
        if ($id = $id ? $id : ($this->getContactId() ? $this->getContactId() : ($this->getId() ? $this->getId() : false))) {
            $orm = Argus::getEntity('outreach/campaign/members')->setId($id);
            $orm->load();
            $orm->setAttempts($orm->getAttempts() + 1)->save();
            return $orm->getAttempts();
        }
    }
}