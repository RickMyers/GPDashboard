<?php
namespace Code\Main\Argus\Models;
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
class Provider extends Model implements \Iterator
{

    use \Code\Base\Humble\Event\Handler;

    private $parameters = [];
    private $position   = 0;

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
    public function next() {
        ++$this->position;
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



    public function valid() {
        return isset($this->parameters[$this->position]);
    }

    public function create($parameters) {
        $this->parameters = $parameters;
        return $this;
    }
}

