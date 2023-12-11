<?php
namespace Code\Main\Vision\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * Limited Demographic Support
 *
 * Due to the use of SQL Server, we are going to only provide a bit of support
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Client
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2005-Present Jarvis Project
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Eligibility.html
 * @since      File available since Release 1.0.0
 */
class Demographics extends \Code\Main\Argus\Entities\MSEntity
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
public function information($member_id = false,$date=false) {
        $member_id_clause = ($id = $member_id ? $member_id : ($this->getMemberId() ? $this->getMemberId() : ($this->getId() ? $this->getId() : false ))) ? "and ec.member_id = '".$id."'" : "";
        $date             = $date ? $date : ($this->getDateOfService() ? $this->getDateOfService() : date('Y-m-d'));
        $query = <<<SQL
            SELECT DISTINCT
            g.group_id group_id,
            ec.default_lob,
            ec.member_id,
            co.last_name,
            co.first_name,
            co.middle_name,
            cast(co.birth_date as date) date_of_birth,
            co.gender,
            rtrim(d.address_1) address_1,
            rtrim(d.address_2) address_2,
            rtrim(d.address_1) + ' ' + rtrim(d.address_2) address_full,
            rtrim(isnull(d.city,'')) city,
            rtrim(isnull(d.State,'')) state,
            left(isnull(d.zip_code,''),5) zip_code,
            phone_number,
            ec.effective_date,
            ec.termination_date,
            ec.record_status,
           email_address
            FROM [ArgusApp].dbo.Groups G WITH (NOLOCK)
            JOIN [ArgusApp].dbo.[Eligibility_Coverage] EC with (nolock)
                    on g.group_gid = ec.group_gid and
                    ec.default_lob = 'VIS'
                    and cast('{$date}' as date) >  cast(ec.effective_date as date)  and
                    ec.record_status = 'A'
            join [ArgusApp].dbo.Contacts co with (nolock)
                    on EC.child_gid = CO.contact_gid
                    and co.record_status = 'A'
            join [ArgusApp].dbo.Contact_Relation cr with (nolock)
                    on co.contact_gid = cr.contact_gid and
                    cr.entity_identifier = 'MEMBER' and
                    cr.contact_purpose_flag = 'PHYS' and
                    cr.record_status = 'A'
            join [ArgusApp].dbo.Demographics d with (nolock)
                    on d.demographic_gid = cr.demographic_gid
                    and d.record_status = 'A'
            WHERE
                    g.group_id in ('Freedom','Optimum','CarePlus','Ultimate HP','DHCP') and
                    g.record_status = 'A'
            {$member_id_clause}
SQL;
        $x= $this->query($query);
        if (count($x)) {                                                        //What we are doing here is if more than one record shows up, we are only going to get the last one which should be most recent
                $y = $x->toArray();
                $y = $y[count($y)-1];
                $t = [];
                $t[] = $y;
                $x->override($t);
        }
        return $x;
    }    
    
    public function groups() {
        $query = <<<SQL
            SELECT *
            FROM [ArgusApp].dbo.Groups G WITH (NOLOCK)
SQL;
        return $this->query($query);        
    }
}
