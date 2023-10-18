<?php
namespace Code\Main\Vision\Entities\Address;
use Argus;
use Log;
use Environment;
/**
 *
 * Location NPI Queries
 *
 * see description
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Npis.html
 * @since      File available since Release 1.0.0
 */
class Npis extends \Code\Main\Vision\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * 
     * 
     * @param int $address_id
     * @return iterator
     */
    public function listNpis($address_id=false) {
        $result = [];
        if ($address_id = ($address_id) ? $address_id : ($this->getAddressId() ? $this->getAddressId() : false) ) {
            $query = <<<SQL
                select '' as `value`, '' as `text`
                union
                select id as `value`, npi as `text`
                  from vision_address_npis
                 where address_id = '{$address_id}' 
                 order by `text`                    
SQL;
            $result = $this->query($query);
        }
        return $result;
    }
}