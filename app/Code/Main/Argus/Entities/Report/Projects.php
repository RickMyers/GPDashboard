<?php
namespace Code\Main\Argus\Entities\Report;
use Argus;
use Log;
use Environment;
/**
 * 
 * Report related queries
 *
 * Report configuration related queries
 *
 * PHP version 7.0+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @since      File available since Release 1.0.0
 */
class Projects extends \Code\Main\Argus\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Returns a list of projects and the reports in the projects
     * 
     * @return type
     */
    public function contents() {
        $project_clause = ($this->getProjectId()) ? "where a.id = '".$this->getProjectId()."' " : "";
        $query = <<<SQL
        SELECT a.id AS project_id, b.id AS report_id, a.project as project_name, a.description AS project_description, b.report AS report_name, b.description AS report_description,
            CONCAT(c.first_name , ' ' , c.last_name) AS project_creator, CONCAT(d.first_name , ' ' , d.last_name) AS report_creator
          FROM argus_report_projects AS a
          LEFT OUTER JOIN argus_reports AS b
            ON a.id = b.project_id
          LEFT OUTER JOIN humble_user_identification AS c
            ON a.created_by = c.id
          LEFT OUTER JOIN humble_user_identification AS d
            ON b.created_by = d.id   
            {$project_clause}
SQL;
        return $this->query($query);
    }
    
    public function projectsAvailableToUser($user_id = false) {
        $user_id    = ($user_id) ? $user_id : ($this->getUserId() ? $this->getUserId() : false);
        if ($user_id) {
            $query = <<<SQL
                SELECT a.project_id, b.project, b.description FROM
                (SELECT DISTINCT project_id
                  FROM argus_report_projects_access a
                 WHERE role_id IN (SELECT role_id FROM argus_user_roles WHERE user_id = '{$user_id}')) AS a
                  LEFT OUTER JOIN argus_report_projects AS b
                  ON a.project_id = b.id
SQL;
        }
        return $this->query($query);
    }
}