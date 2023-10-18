<?php
namespace Code\Main\Vision\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * vision client queries
 *
 * see title
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Other
 * @author     Aaron Binder abinder@argusdentalvision.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Clients.html
 * @since      File available since Release 1.0.0
 */
class Clients extends Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }
    
    
    /**
     * Returns a dataset of vision packets that have been signed by the O.D.
     * 
     * @return iterator
     */    
    public function ipafinder() {
        $query = <<<SQL
                
                SELECT 
                    (CASE WHEN vis.sub_name!=' ' THEN CONCAT(vi.ipa_name,' - ', vis.sub_name) ELSE vi.ipa_name END) AS 'The_Name', 
                     vis.sub_id 
                FROM vision_ipa AS vi 
                LEFT OUTER JOIN vision_ipa_sub AS vis 
                    ON vi.ipa_id=vis.ipa_parent_id 
                where vis.is_enabled=1 and vi.is_enabled=1
                ORDER BY vi.is_not_other DESC, vi.ipa_name ASC, vis.sub_name ASC
             
SQL;
        return $this->query($query);        
    }

}