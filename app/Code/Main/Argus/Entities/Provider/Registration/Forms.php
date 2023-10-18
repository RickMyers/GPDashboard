<?php
namespace Code\Main\Argus\Entities\Provider\Registration;
use Argus;
use Log;
use Environment;
/**
 * 
 * Provider Registration Entity
 *
 * Queries and methods in support of the New Provider Registration
 * process
 *
 * PHP version 5.5+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @since      File available since Release 1.0.0
 */
class Forms extends \Code\Main\Argus\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Checks to see if the email entered is in the system or not and an appropriate message is generated.  Sends the email with the link to the form for the provider
     */
    public function emailAndConfirm() {
        $email      = $this->getEmail();
        $name       = $this->getName();
        $medicaid   = $this->getMedicaid();
        $medicare   = $this->getMedicare();
        $commercial = $this->getCommercial();
        $fhk        = $this->getFhk();
        $helper     = Argus::getHelper('argus/data');
        $this->unsetName();                                                     //We need to see if this email was used before, perhaps with another name, so name needs to be removed from the search criteria
        if ($this->load(true)) {
            $this->setMessage('The E-mail address entered is already assigned to a form. <br /><br /> Another E-mail has been sent with the link the to the existing form');
        } else {
            $this->setMessage("Your registration form link has been sent.<br /><br />Please look for it in your mailbox");
        }
        $rain     = Environment::getInternalTemplater(getcwd().'/lib/resources/email/templates/');
        $template = Argus::emailTemplate('provider_registration');
        $provider = MD5($email);
        $root     = Environment::getRoot('argus');
        @mkdir($root."/lib/providers/".$provider,0775,true);
        $this->reset();
        $this->setName($name);
        $this->setMedicare($medicare);
        $this->setMedicaid($medicaid);
        $this->setCommercial($commercial);
        $this->setFhk($fhk);
        $this->setEmail($email);
        $this->setFormId($provider);
        $this->setPin($pin = $helper->createPin(6));                             //Create a 6 digit pin        
        $this->save();
        $rain->assign('name',$name);
        $rain->assign('email',$email);
        $rain->assign('pin',$pin);
        $rain->assign('host',Environment::getHost());
        $rain->assign('form_id',$this->getFormId());
        $emailer = Argus::getModel('argus/email');
        return $emailer->sendEmail($email,'ARGUS Provider Registration Link',$rain->draw($template,true),"registrar@argusdentalvision.com","noreply@argusdentalvision.com");
    }
    
    /**
     * If you are only a commercial provider, you get the short form.  Else you get the long form.
     * 
     * @return boolean
     */
    public function onlyCommercial() {
        $commercial = $this->getCommercial();
        $medicare   = $this->getMedicare();
        $medicaid   = $this->getMedicaid();
        $fhk        = $this->getFhk();
        return ($commercial && !($medicare || $medicaid || $fhk));
    }
    
    /**
     * Returns a dataset of provider registration forms that have yet to be reviewed
     * 
     * @return iterator
     */
    public function inboundRegistrationForms() {
        $query = <<<SQL
            SELECT a.id, form_id, a.email, a.name, a.modified AS created, a.date_submitted, a.reviewer, a.status,
                    b.first_name AS reviewer_first_name, b.last_name AS reviewer_last_name, b.gender AS reviewer_gender
              FROM argus_provider_registration_forms AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.reviewer = b.id
             WHERE STATUS = 'N'
SQL;
        return $this->query($query);
    }
    
    /**
     * Returns a dataset of provider registration forms that are being reviewed
     * 
     * @return iterator
     */
    public function processingRegistrationForms() {
        $query = <<<SQL
            SELECT a.id, form_id, a.email, a.name, a.modified AS created, a.date_submitted, a.reviewer, a.status,
                    b.first_name AS reviewer_first_name, b.last_name AS reviewer_last_name, b.gender AS reviewer_gender
              FROM argus_provider_registration_forms AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.reviewer = b.id
             where status = 'S'
SQL;
        return $this->query($query);
    }
    
    /**
     * Returns a dataset of provider registration forms that have been processed
     * 
     * @return iterator
     */
    public function archivedRegistrationForms() {
        $query = <<<SQL
            SELECT a.id, form_id, a.email, a.name, a.modified AS created, a.date_submitted, a.reviewer, a.status,
                    b.first_name AS reviewer_first_name, b.last_name AS reviewer_last_name, b.gender AS reviewer_gender
              FROM argus_provider_registration_forms AS a
              LEFT OUTER JOIN humble_user_identification AS b
                ON a.reviewer = b.id
             where status = 'R'
SQL;
        return $this->query($query);
    }    

}