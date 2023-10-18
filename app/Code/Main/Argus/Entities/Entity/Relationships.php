<?php
namespace Code\Main\Argus\Entities\Entity;
use Argus;
use Log;
use Environment;
/**
 * 
 * Entity Relationship Queries
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
class Relationships extends \Code\Main\Argus\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }
    
    /**
     * Returns extended information about relationships
     * 
     * @param int $id
     * @return iterator
     */
    public function information($id=false) {
        $id              = ($id) ? $id : ($this->getEntityId() ? $this->getEntityId() : ($this->getId() ? $this->getId() : null));
        $relation_clause =  $id ? " where a.id = '".$id."' " : "";
        $query = <<<SQL
            select 	a.id, a.entity_id, a.parent_id, a.effective_start_date, a.effective_end_date, a.modified,
                    b.entity as entity_name, c.`type` as entity_type,
                    d.entity as parent_name, e.`type` as parent_type,
                    g.address, g.city, g.state, g.zip_code
              from 	argus_entity_relationships as a
              left  outer join argus_entities as b
                on  a.entity_id = b.id
              left  outer join argus_entity_types as c
                on  b.entity_type_id = c.id
              left  outer join argus_entities as d
                on  a.parent_id = d.id
              LEFT  OUTER JOIN argus_entity_types AS e
                ON  d.entity_type_id = e.id    
              left  outer join argus_entity_addresses as f
                on  a.parent_id = f.entity_id
              left  outer join argus_addresses as g
                on  f.address_id = g.id
                {$relation_clause}      
         
SQL;
        return $this->query($query);
    }    

}