<?php
namespace Code\Main\Librio\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * The primary documentation management engine
 *
 * See Title
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://jarvis.enicity.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://jarvis.enicity.com/docs/class-Engine.html
 * @since      File available since Release 1.0.0
 */
class Engine extends Model
{

    use \Code\Base\Humble\Event\Handler;
    
    private $root = "../../librio/";
    
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
     * Adds a document to a category in a project
     * 
     * @return boolean
     */
    public function addDocumentsToProjectCategory() {
        $success = false;
        if ($doc = Humble::getEntity('librio/project_documents')->setId($this->getDocumentId())->load()) {
            
        }
        return $success;
    }
    
    /**
     * Returns a document to its "available" status
     * 
     * @return boolean
     */
    public function checkIn() {
        $success = false;
        if ($doc = Humble::getEntity('librio/project_documents')->setId($this->getDocumentId())->load()) {
            
        }
        return $success;
    }
    
    /**
     * Marks a document as checked out
     * 
     * @return boolean
     */
    public function checkOut() {
        $success = false;
        if ($doc = Humble::getEntity('librio/project_documents')->setId($this->getDocumentId())->load()) {
            
        }
        return $success;
    }
    
    /**
     * Finds a document and outputs it to the user
     * 
     * @return boolean
     */
    public function retrieveDocument() {
        $document = false;
        if ($doc = Humble::getEntity('librio/project_documents')->setId($this->getDocumentId())->load()) {
            
        }
        return $document;
    }
    
    /**
     * Creates an over-arching project
     * 
     * @return boolean
     */
    public function createProject() {
        $created = false;
        if ($project_id = Humble::getEntity('librio/projects')
                            ->setProject($this->getName())
                            ->setDescription($this->getDescription())
                            ->setCreator(Environment::whoAmI())
                            ->save()) {
            $created = mkdir($this->root.'/Projects/'.$project_id,0755,true);      
        }
        return $created;
    }
    
    /**
     * Creates a category within a project
     * 
     * @return boolean
     */
    public function addCategoryToProject() {
        $created = false;
        if ($category_id = Humble::getEntity('librio/project_categories')
                            ->setProjectId($this->getProjectId())
                            ->setCategory($this->getName())
                            ->setDescription($this->getDescription())
                            ->setCreator(Environment::whoAmI())
                            ->save()) {
            $created = mkdir($this->root.'/Projects/'.$project_id.'/Category/'.$category_id.'/Versions',0755,true);
        }
        return $created;
    }
}