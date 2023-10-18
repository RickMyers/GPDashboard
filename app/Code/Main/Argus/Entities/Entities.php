<?php
namespace Code\Main\Argus\Entities;
use Argus;
use Log;
use Environment;
/**
 * 
 * Entities Queries
 *
 * See Title
 *
 * PHP version 7.0+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2005-Present Argus Dental and Vision
 * @since      File available since Release 1.0.0
 */
class Entities extends Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Returns extended data on entities
     * 
     * @return iterator
     */
    public function information($id=false) {
        $id            = ($id) ? $id : ($this->getEntityId() ? $this->getEntityId() : ($this->getId() ? $this->getId() : null));
        $entity_clause =  $id ? " where a.id = '".$id."' " : "";
        $query = <<<SQL
            SELECT a.id, a.entity, a.entity_type_id, b.type, b.description, a.modified
              FROM argus_entities AS a
              LEFT OUTER JOIN argus_entity_types AS b
                ON a.entity_type_id = b.id
                {$entity_clause}   
             ORDER BY b.`type`, a.entity              
SQL;
        return $this->query($query);
    }
}