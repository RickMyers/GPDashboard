<?php
namespace Code\Main\Argus\Entities;
use Humble;
use Log;
use Environment;
/**
 * 
 * Organization related queries
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
class Organizations extends Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }
    
    /**
     * Returns extended information about an organization
     * 
     * @return iterator
     */
    public function fetchInformation() {
        $idClause   = ($this->getId()) ? " where a.id = '".$this->getId()."' " : "";
        $orgClause  = ($this->getOrganization()) ? " where a.organization = '".$this->getOrganization()."' " : "";
        $query = <<<SQL
            SELECT a.id, a.organization, a.org_type_id, a.created_by, b.type AS type, b.description, c.first_name, c.last_name
              FROM argus_organizations AS a
              LEFT OUTER JOIN argus_organization_types AS b
                ON a.org_type_id = b.id
              LEFT OUTER JOIN humble_user_identification AS c
                ON a.created_by = c.id 
              {$idClause} {$orgClause}
SQL;
        return $this->query($query);
    }

}