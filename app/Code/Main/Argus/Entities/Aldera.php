<?php
namespace Code\Main\Argus\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * Aldera Interface
 *
 * A class to contain queries directly hitting the Aldera DWH
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Core
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2007-Present, Rick Myers <rick@humbleprogramming.com>
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Aldera.html
 * @since      File available since Release 1.0.0
 */
class Aldera extends MSEntity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }
    
    /**
     * Deprecated... don't use. Just left in here for historical sake
     * 
     * @param type $claim_number
     * @return type
     */
    public function ourClaimData($claim_number=false) {
        $results = [];
        if ($claim_number = ($claim_number) ? $claim_number : (($this->getClaimNumber()) ? $this->getClaimNumber() : false)) {
            $query = <<<SQL
            SELECT C.*, V.* 
              FROM [ArgusApp].dbo.Claims_Detail_V2 C WITH (NOLOCK)
              LEFT OUTER JOIN [ArgusApp].dbo.Claims_Log_V2 V WITH (NOLOCK)      
                ON C.claim_number = V.claim_number
             WHERE V.pos_claim_id = '{$claim_number}'
SQL;
            $results = $this->query($query);
        }
        return $results;
    }    
    
    /**
     * Deprecated... don't use. Just left in here for historical sake
     * 
     * @param type $claim_number
     * @return type
     */    
    public function claimData($claim_number=false) {
        $results = [];
        if ($claim_number = ($claim_number) ? $claim_number : (($this->getClaimNumber()) ? $this->getClaimNumber() : false)) {
            $query = <<<SQL
            SELECT C.*, V.* 
              FROM [ArgusApp].dbo.Claims_Detail_V2 C WITH (NOLOCK)
              LEFT OUTER JOIN [vm-win-p-dwh].[ArgusApp].dbo.Claims_Log_V2 V WITH (NOLOCK)      
                ON C.claim_number = V.claim_number
            WHERE C.claim_number = '{$claim_number}'
SQL;
            $results = $this->query($query);
        }
        return $results;
    }

    /**
     * Queries a Data Warehouse View for extended claim information
     * 
     * @param string $claim_number (ex. 2020175T0129200)
     * @return type
     */
    public function extendedClaimData($claim_number = false) {
        $results = [];
        if ($claim_number = ($claim_number) ? $claim_number : ($this->getClaimNumber() ? $this->getClaimNumber() : false)) {
            $query = <<<SQL
            select * from [dwh].dbo.VW_Claim_Reject_Info
             where claim_number = '{$claim_number}'                
SQL;
            $results = $this->query($query)->toArray();
            foreach ($results as $index => $data) {
                if (is_array($data)) {
                    $rows    = [];
                    foreach ($data as $field => $value) {
                        $rows[str_replace(["_"]," ",$field)] = (is_object($value)) ? $value->format("d/m/Y") : $value;
                    }
                    $data = $rows;
                }
                $results[$index] = $data;
            }
        }
        return $results;
    }
    
    /**
     * We get claim information using the HEDIS claim number to get the ALdera claim number
     * 
     * @param string $pos_claim_id
     * @return iterator
     */    
    public function claimLogInformation($pos_claim_id=false) {
        $result = [];
        if ($pos_claim_id = ($pos_claim_id) ? $pos_claim_id : ($this->getPosClaimId() ? $this->getPosClaimId() : false)) {
            $query = <<<SQL
                select V2.*
                  from  [ArgusApp].dbo.Claims_Log_V2 V2 with (NOLOCK)
                 where pos_claim_id = '{$pos_claim_id}'
SQL;
            $result = $this->query($query)->toArray();
        }
        return isset($result[0]) ? $result[0] : [];
    }
    

    /**
     * Gets claim number based on Aldera claim number
     * 
     * @param string $claim_number
     * @return iterator
     */
    public function claimDetailInformation($claim_number=false) {
        if ($claim_number = $claim_number ? $claim_number : ($this->getClaimNumber() ? $this->getClaimNumber() : false)) {
            $query = <<<SQL
            select V2.*
              from  [ArgusApp].dbo.Claims_Detail_V2 V2 with (NOLOCK)
             where claim_number = '{$claim_number}';
SQL;
            $result = $this->query($query)->toArray();
        }
        return isset($result[0]) ? $result[0] : [];
    }
    
    /**
     * 
     * 
     * @return array
     */
    public function verify($claim_list) {
        $claim = Argus::getEntity('argus/claims');
        foreach ($claim_list as $pos_claim_id) {
            if ($log = $this->claimLogInformation($pos_claim_id)) {
                if (isset($log['claim_number'])) {
                    if ($detail = $this->claimDetailInformation($log['claim_number'])) {
                        $status = false;
                        switch ($detail['default_status']) {
                            case 'A' :
                                $status = 'A';
                                break;
                            case 'D' :
                                $status = 'D';
                                break;
                            case 'F' :
                                $status = '';
                                break;
                            case 'P' :
                                $status = 'P';
                                break;
                            case 'R' :
                                $status = 'I';
                                break;
                            case 'X' :
                                $status = '';
                                break;
                            case 'Z' :
                                $status = '';
                                break;
                            default :
                                break;
                        }
                        if ($status) {
                            $claim->reset()->setClaimNumber($pos_claim_id)->setVerified($status)->save();
                        }
                    }
                }
            }
        }
        
        return $results;
    }
}