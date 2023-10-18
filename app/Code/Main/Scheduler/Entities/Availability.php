<?php
namespace Code\Main\Scheduler\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * Availability Queries
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Entity
 * @package    Dashboard
 * @author     Rick Myers rmyers@argusdentalvision.com
 */
class Availability extends Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Gets the aggregate or individual availability for a particular year
     * 
     * @param int $yyyy
     * @return iterator
     */
    public function fetchStatus($yyyy=false) {
        $yyyy = ($yyyy) ? $yyyy : ($this->getYear() ? $this->getYear() : false);
        $year_clause = ($yyyy) ? "where date >= '".$yyyy."-01-01' and date <= '".$yyyy."-12-31'" : "";
        $query = <<<SQL
            select a.*, 
                   concat(b.last_name,', ',b.first_name) as name
              from scheduler_availability as a
              left outer join humble_user_identification as b
                on a.user_id = b.id
                {$year_clause}
SQL;
        return $this->query($query);
    }
}