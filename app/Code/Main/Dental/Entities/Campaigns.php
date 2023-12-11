<?php
namespace Code\Main\Dental\Entities;
use Argus;
use Log;
use Environment;
/**
 * 
 * Hedis Campaign Queries
 *
 * Queries involving hedis campaigns
 *
 * PHP version 7.0+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @since      File available since Release 1.0.0
 */
class Campaigns extends \Code\Main\Dental\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Selects the current active campaigns in a particular category
     * 
     * @return iterator
     */
    public function fetchActive() {
        $query = <<<SQL
            select id as `value`, campaign as `text`
              from dental_campaigns
              where category_id = (select id from dental_campaign_categories where category = '{$this->getCategory()}')
                and active = 'Y'                
SQL;
        return $this->query($query);
    }
}