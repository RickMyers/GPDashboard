<?php
namespace Code\Main\Hedis\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * News Queries
 *
 * see description
 *
 * PHP version 7.0+
 *
 * @category   Entity
 * @package    Dashboard
 * @author     Rick Myers rmyers@argusdentalvision.com
 */
class News extends Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    public function fetch($userkeys=false) {
        $query = <<<UserName
        select a.*, b.first_name, b.last_name from hedis_news as a
        left outer join humble_user_identification as b
        on a.author=b.id
UserName;
        return $this->query($query);
    }

    public function load($userkeys=false) {
        $query = <<<UserName
        select a.*, b.first_name, b.last_name from hedis_news as a
        left outer join humble_user_identification as b
        on a.author=b.id
        where a.id = {$this->getId()}
UserName;
        return $this->query($query)->toArray()[0];
    }
}