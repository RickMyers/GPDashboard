<?php
namespace Code\Main\Edi\Models;
use \Argus;
/** 
 * Provider related methods
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Other
 * @since      File available since Release 1.0.0
 */
class Provider extends EDIModel implements \Iterator
{

    use \Code\Base\Humble\Event\Handler;

    private $position   = 0;
    private $subscribers = [];
    
    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Required for Helpers, Models, and Events, but not Entities
     *
     * @return system
     */
    public function getClassName() {
        return __CLASS__;
    }
    
    public function defaults () {
        return [
            'has_children'          => '1',
            'entity_code'           => '2',
            'last_name'             => '',
            'first_name'            => '',
            'middle_name'           => '',
            'provider_name'         => '',
            'street_address'        => '',
            'street_address_2'      => '',
            'identification_code'   => '',
            'license_number'        => '',
            'city'                  => '',
            'state'                 => '',
            'zip_code'              => '',
            'telephone'             => '',
            'employer_identification_number' => '',
        ];
    }
    
    /**
     * Changes the status from New to Submitted, effectively signing the registration form and making it available for review
     * 
     * @workflow use(event)
     */
    public function sign() {
        $form = Argus::getEntity('argus/provider_registration_forms')->setFormId($this->getFormId());
        $data = $form->load(true);
        if ($data) {
            $form->setStatus(CREDENTIALING_FORM_SUBMITTED);
            $form->setDateSubmitted(date('Y-m-d H:i:s'));
            $form->save();
            $this->trigger('providerRegistrationFormSigned',__CLASS__,__METHOD__,[
                'name' => $data['name'],
                'email' => $data['email'],
                'date_signed' => date('Y-m-d H:i:s')
            ]);
        }
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
    
    public function subscribers() {
        return $this->subscribers;
    }
    
    public function name() {
        return 'provider';
    }    
    
    public function valid() {
        return isset($this->parameters[$this->position]);
    }
    
    public function addSubscribers($subscribers) {
        $this->subscribers = $subscribers;
    }
    
    public function create($parameters) {
        $this->parameters = $parameters;
        return $this;
    }
    
}

