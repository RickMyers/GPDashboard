<?php
namespace Code\Main\Argus\Entities\Entity;
use Argus;
use Log;
use Environment;
/**
 * 
 * Entity Address Queries
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
class Addresses extends \Code\Main\Argus\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }
    
    /**
     * Returns extended information about addresses
     * 
     * @param int $id
     * @return iterator
     */
    public function information($id=false) {
        $id             = ($id) ? $id : ($this->getEntityId() ? $this->getEntityId() : ($this->getId() ? $this->getId() : null));
        $address_clause =  $id ? " where a.entity_id = '".$id."' " : "";
        $query = <<<SQL
            SELECT  a.id, a.entity_id, a.address_id, a.address_type_id,
                    b.address, b.city, b.state, b.zip_code, b.modified,
                    c.type, c.description
              FROM argus_entity_addresses AS a
              LEFT OUTER JOIN argus_addresses AS b
                ON a.address_id = b.id
              LEFT OUTER JOIN argus_address_types as c
                on a.address_type_id = c.id
                {$address_clause}      
             ORDER BY c.`type`, b.address              
SQL;
        return $this->query($query);
    }
}