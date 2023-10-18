<?php
namespace Code\Clients\Prestige\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * Limited Prestige Support
 *
 * Due to the use of SQL Server, we are going to only provide a bit of
 * support
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Client
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Eligibility.html
 * @since      File available since Release 1.0.0
 */
class Eligibility extends \Code\Main\Argus\Entities\MSEntity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Returns the current eligibility of members for prestige
     *
     * @return iterator
     */
    public function current($member_id = false) {
        $member_id_clause = ($id = $member_id ? $member_id : ($this->getMemberId() ? $this->getMemberId() : ($this->getId() ? $this->getId() : false ))) ? "and EC.member_id in ('".$id."')" : "";
        $query = <<<SQL
            SELECT DISTINCT top 10
            group_id,
            EC.member_id,
            rtrim(ISNULL(C.first_name, '')) first_name,
            rtrim(ISNULL(C.middle_name, '')) middle_name,
            rtrim(ISNULL(C.last_name, '' )) last_name,
            rtrim(replace(d.address_1,'@','')) address_1,
            rtrim(replace(d.address_2,'@','')) address_2,
            rtrim(isnull(d.city,'')) city,
            rtrim(isnull(d.State,'')) state,
            left(isnull(d.zip_code,''),5) zip_code,
            isnull(d.county,'') county,
            isnull(phone_number,'') phone_number,
            cast(birth_date as date) birth_date,
            cast(round(datediff(day, birth_date, getdate())/365.25,0) as int) age,
            rtrim(isnull(cr.email_address,'')) email,
            ec.effective_date,
            ec.termination_date
            FROM [ARGUSAPP].[dbo].[Eligibility_Coverage] EC with (nolock)
            join Groups G WITH (NOLOCK) on g.group_gid = ec.group_gid and g.record_status = 'A' and
                   group_id in ('Prestige')
            join Contacts  C WITH (NOLOCK)
                   on EC.child_gid = C.contact_gid AND C.record_status  = 'A'
            join Contact_Relation CR with (nolock)
                   on c.contact_gid = cr.contact_gid and cr.entity_identifier = 'MEMBER'
                   and cr.record_status = 'A' and cr.contact_purpose_flag = 'PHYS'
            join Demographics D with (nolock)
                   on d.demographic_gid = cr.demographic_gid and d.record_status = 'A'
            where EC.RECORD_STATUS = 'A' and cast(getdate() as date) between ec.effective_date and ec.termination_date
                {$member_id_clause}
                    ;
SQL;
                //print($query);
        return $this->query($query);
    }
    
    /**
     * Returns the current eligibility of members for prestige
     *
     * @return iterator
     */
    public function multipleCheck($member_id = false) {
        $member_id_clause = ($id = $member_id ? $member_id : ($this->getMemberIds() ? $this->getMemberIds() : ($this->getId() ? $this->getId() : false ))) ? "and EC.member_id in (".implode(",",$id).")" : "";
        $query = <<<SQL
            SELECT DISTINCT
            group_id,
            EC.member_id,
            rtrim(ISNULL(C.first_name, '')) first_name,
            rtrim(ISNULL(C.middle_name, '')) middle_name,
            rtrim(ISNULL(C.last_name, '' )) last_name,
            rtrim(replace(d.address_1,'@','')) address_1,
            rtrim(replace(d.address_2,'@','')) address_2,
            rtrim(isnull(d.city,'')) city,
            rtrim(isnull(d.State,'')) state,
            left(isnull(d.zip_code,''),5) zip_code,
            isnull(d.county,'') county,
            isnull(phone_number,'') phone_number,
            cast(birth_date as date) birth_date,
            cast(round(datediff(day, birth_date, getdate())/365.25,0) as int) age,
            rtrim(isnull(cr.email_address,'')) email,
            ec.effective_date,
            ec.termination_date
            FROM [ARGUSAPP].[dbo].[Eligibility_Coverage] EC with (nolock)
            join Groups G WITH (NOLOCK) on g.group_gid = ec.group_gid and g.record_status = 'A' and
                   group_id in ('Prestige')
            join Contacts  C WITH (NOLOCK)
                   on EC.child_gid = C.contact_gid AND C.record_status  = 'A'
            join Contact_Relation CR with (nolock)
                   on c.contact_gid = cr.contact_gid and cr.entity_identifier = 'MEMBER'
                   and cr.record_status = 'A' and cr.contact_purpose_flag = 'PHYS'
            join Demographics D with (nolock)
                   on d.demographic_gid = cr.demographic_gid and d.record_status = 'A'
            where EC.RECORD_STATUS = 'A' and cast(getdate() as date) between ec.effective_date and ec.termination_date
                {$member_id_clause}
                    ;
SQL;
                //print($query);
                //Argus::response($query);
        return $this->query($query);
    }    
}