<?php
namespace Code\Main\Argus\Entities\Entity;
use Argus;
use Log;
use Environment;
/**
 * 
 * User Entities Method
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @since      File available since Release 1.0.0
 */
class Users extends \Code\Main\Argus\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Returns basic fetch data with a few other things...
     * 
     * @return iterator
     */
    public function fetch($usekeys=false) {
        $query = <<<SQL
        SELECT a.id, a.entity_id, a.user_id, a.effective_start_date, a.effective_end_date, a.modified, b.entity
          FROM argus_entity_users AS a
          LEFT OUTER JOIN argus_entities AS b
            ON a.entity_id = b.id           
SQL;
        return $this->query($query);
    }
}