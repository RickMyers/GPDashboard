<?php
namespace Code\Main\Vision\Entities\Client;
use Argus;
use Log;
use Environment;
/**
 *
 * Client IPA DAO
 *
 * Queries related to working with Vision clients and their IPAs
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Ipas.html
 * @since      File available since Release 1.0.0
 */
class Ipas extends \Code\Main\Vision\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }
    
    /**
     * Returns the list of IPAs associated to a client
     * 
     * @return iterator
     */
    public function clientIpas($client_id=false) {
        $result = [];
        if ($client_id = ($client_id ? $client_id : ($this->getClientId() ? $this->getClientId() : false))) {
            $query = <<<SQL
                select a.*,
                       b.ipa
                  from vision_client_ipas as a
                  left outer join vision_ipas as b
                    on a.ipa_id = b.id
                 where a.client_id = '{$client_id}'
                   and b.ipa is not null
SQL;
            $result = $this->query($query);
        }
        return $result;
    }
    
    /**
     * Returns a list of available IPAs related to a particular client
     * 
     * @return Iterator
     */
    public function listIpas() {
        $result = [];
        if ($client_id = $this->getClientId()) {
            $query = <<<SQL
                select '' as `value`, '' as `text`
                union
                select b.id as `value`, b.ipa as `text`
                  from vision_client_ipas as a
                  left outer join vision_ipas as b
                    on a.ipa_id = b.id
                 where a.client_id = '{$client_id}' 
                 order by `text`
SQL;
            $result = $this->query($query);
                
        }
        return $result;
    }

}