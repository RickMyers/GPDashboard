<?php
namespace Code\Main\Dashboard\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * Requests
 *
 * Requests related functionality
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Core
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2007-Present, Rick Myers <rick@humbleprogramming.com>
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Requests.html
 * @since      File available since Release 1.0.0
 */
class Requests extends Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Lists the requests in the system with additional data
     */
    public function list() {
        $query = <<<SQL
            SELECT a.*, b.module, c.feature, CONCAT(d.last_name,", ",d.first_name) AS submitter, e.attachment, a.subject,
              CASE a.priority
		WHEN 1 THEN "red"
		WHEN 2 THEN "orange"
		WHEN 3 THEN "green"
		ELSE "black"
	      END AS color,
              CASE a.`status`
		WHEN "N" THEN "New"
		WHEN "I" THEN "In-Progress"
		WHEN "H" THEN "On-Hold"
		WHEN "C" THEN "Completed"
		ELSE "?"
	      END AS state	      
              FROM dashboard_requests AS a
              LEFT OUTER JOIN dashboard_modules AS b
                ON a.module_id = b.id
              LEFT OUTER JOIN dashboard_features AS c
                ON a.feature_id = c.id
              LEFT OUTER JOIN humble_user_identification AS d
                ON a.submitter = d.id
              LEFT OUTER JOIN dashboard_request_attachments AS e
                ON a.id = e.request_id
SQL;
        return $this->query($query);
    }
}