<?php
namespace Code\Clients\Aetna\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * Aetna Queries
 *
 * A container for Aetna related queries
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Client
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Plans.html
 * @since      File available since Release 1.0.0
 */
class Plans extends \Code\Main\Argus\Entities\MSEntity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
        $this->connect('14tpawndb001',[
            "Database" => 'grp_Aetna',
            "Uid" => 'sa',
            "PWD" => '##@rgu$99'
        ]);
    }
    
    /**
     * Simply returns the contents of the Argus/Aetna cross reference table
     * 
     * @return type
     */
    public function data() {
        $query = <<<SQL
            select *
              from Eligibility_Plan_Aetna_to_Argus
SQL;
        return $this->query($query);
    }

}