<?php
namespace Code\Main\Edi\Models;
use Argus;
/**    
 *
 * EDI Header Model (related to EDI 837 claim processing)
 *
 * see Title
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @since      File available since Release 1.0.0
 */
class Header extends EDIModel
{
    
    
    /**
     * Constructor
     */
    public function __construct() {
    }
    
    
    public function defaults() {
        return [
            'sender_id'                     => '',
            'receiver_id'                   => '',
            'interchange_date'              => date('ymd'),
            'interchange_time'              => date('Hi'),
            'control_number'                => '',
            'prod_flag'                     => 'T',   /* default to test */
            'receiving_partner_id'          => '',
            'sending_partner_id'            => '',
            'create_date'                   => date('Ymd'),
            'create_time'                   => date('Hi'),
            'group_control_number'          => '',
            'transaction_control_number'    => ''
        ];
    }
    
    public function name() {
        return 'header';
    }    
    
    public function create($parameters) {
        $this->parameters                 = $parameters;
        return $this;
    }
}