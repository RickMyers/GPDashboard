<?php
namespace Code\Main\Edi\Models;
/**    
 *
 * Claim Model (related to EDI 837 claim processing)
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
class Claim extends EDIModel implements \Iterator
{

    private $position   = 0;
    private $services   = null;

    /**
     * Constructor
     */
    public function __construct() {
        $this->parameters['total'] = 0;
    }
    
    /**
     * Let's initialize the basic values
     * 
     * @return array
     */
    public function defaults () {
        return [
            'claim_number'              => '',
            'location_information'      => '',
            'claim_date'                => '',
            'entity_code'               => '2',
            'last_name'                 => '',
            'first_name'                => '',
            'amount'                    => '0',
            'identification_code'       => '',
            'specialty_code'            => '',
            'license_number'            => '',
            'form_id'                   => ''
        ];
    }    
    
    public function name() {
        return 'claim';
    }
    
    public function rewind() {
        $this->position = 0;
    }

    public function current() {
        return $this->parameters[$this->position];
    }

    public function key() {
        return $this->position;
    }

    public function next() {
        ++$this->position;
    }

    public function valid() {
        return isset($this->parameters[$this->position]);
    }
    
    public function services() {
        return $this->services;
    }
    
    public function addServices($services) {
        $this->services = $services;
        foreach ($this->services as $idx => $service) {
            $service->addParameter('claim_number',$this->parameters['claim_number']);
            if ($tot = $service->getParameter('amount')) {
                $this->parameters['total'] += $tot;
            }
        }
        return $this;
    }
    
    public function create($parameters) {
      //  if (isset($parameters['amount'])) {
       //     $this->parameters['total'] += $parameters['amount'];
       // }
        $this->parameters = array_merge($this->parameters,$parameters);
        return $this;
    }

    public function getTotal() {
        return $this->parameters['total'];
    }

}