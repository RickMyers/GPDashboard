<?php
namespace Code\Main\Argus\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * Entity related methods
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @since      File available since Release 1.0.0
 */
class Entities extends Model
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
     * Returns true to a workflow if the entity registration succeeded
     * 
     * @param type $EVENT
     * @workflow use(decision)
     * @return type
     */
    public function entityRegistrationSuccessful($EVENT=false) {
        $success = false;
        if ($EVENT!==false) {
            if ($data = $EVENT->load()) {
                $success = (isset($data['successful']) && $data['successful']);
            }
        }
        return $success;
    }

    /**
     * Returns true to a workflow if the entity registration failed
     * 
     * @param type $EVENT
     * @workflow use(decision)
     * @return type
     */    
    public function entityRegistrationFailed() {
        $failed = false;
        if ($EVENT!==false) {
            if ($data = $EVENT->load()) {
                $failed = (isset($data['successful']) && !$data['successful']);
            }
        }        
        return $failed;
    }
    
    /**
     * Will attempt to create a new entity and record who the primary administrator is
     * 
     * @workflow use(event)
     * 
     */
    public function registerNewEntity() {
        $registered = false;
        $admin_id   = false;
        if ($entity_id = Argus::getEntity('argus/entities')->setEntity($this->getEntity())->setEntityTypeId($this->getEntityTypeId())->save()) {
            if ($admin_id = Argus::getEntity('argus/entity_administrators')->setEntityId($entity_id)->setUserId($this->getUserId())->save()) {
                $registered = true;
            }
        }
        $this->trigger('newEntityRegistrationAttempt',__CLASS__,__METHOD,[
            "entity" => $this->getEntity(),
            "entity_type_id" => $this->getEntityTypeId(),
            "successful" => $registered,
            "admin_id" => $admin_id
        ]);
    }
    
    
    /**
     * 
     */
    public function removeType() {
        if ($type_id = $this->getTypeId()) {
            //first we remove relationships
            $relationships = Argus::getEntity("argus/entity_relationships");
            $entities      = Argus::getEntity("argus/entities");
            foreach (Argus::getEntity('argus/entities')->setEntityTypeId($type_id)->fetch() as $entity) {
                    $relationships->reset()->setEntityId($entity['id'])->delete(true);
                    $entities->setId($entity['id'])->delete();
            }
        }
        
    }
}