<?php
namespace Code\Main\Argus\Entities\Organization;
use Humble;
use Log;
use Environment;
/**
 * 
 * Entity related queries
 *
 * See Title
 *
 * PHP version 7.0+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @since      File available since Release 1.0.0
 */
class Entities extends \Code\Main\Argus\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }
    
    /**
     * Fetches extended information about the entities within an organization
     * 
     * @return iterator
     */
    public function fetchInformation() {
        $idClause   = ($this->getId()) ? " where a.id = '".$this->getId()."' " : "";
        $orgClause  = ($this->getOrganizationId()) ? " where a.organization_id = '".$this->getOrganizationId()."' " : "";
        $query = <<<SQL
            SELECT a.id, a.organization_id, a.entity, a.entity_type_id, a.created_by, b.type , b.description, c.first_name, c.last_name
              FROM argus_organization_entities AS a
              LEFT OUTER JOIN argus_organization_entity_types AS b
                ON a.entity_type_id = b.id
              LEFT OUTER JOIN humble_user_identification AS c
                ON a.created_by = c.id 
              {$idClause} {$orgClause}
SQL;
        return $this->query($query);        
    }

}