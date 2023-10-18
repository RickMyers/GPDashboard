<?php
namespace Code\Main\Vision\Entities\Ipa;
use Argus;
use Log;
use Environment;
/**
 *
 * Client IPA Offices DAO
 *
 * Queries related to working with Vision clients and their IPAs
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Locations.html
 * @since      File available since Release 1.0.0
 */
class Locations extends \Code\Main\Vision\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }
    
    
    /**
     * Returns a list of available offices related to a particular IPA
     * 
     * @return Iterator
     */
    public function listOffices() {
        $result = [];
        if ($ipa_id = $this->getIpaId()) {
            $query = <<<SQL
                select '' as `value`, '' as `text`
                union
                select id as `value`, location as `text`
                  from vision_ipa_locations
                 where ipa_id = '{$ipa_id}' 
                 order by `text`
SQL;
            $result = $this->query($query);
        }
        return $result;
    }    

}