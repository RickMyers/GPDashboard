<?php
namespace Code\Main\Argus\Entities\Provider\Credentialing;
use Argus;
use Log;
use Environment;
/**
 * 
 * Credentialing Form Queries and Methods
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
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

    public function sendRequest() {
        if ($this->load(true)) {
            $this->setMessage('The E-mail address entered is already assigned to a form. <br /><br /> Another E-mail has been sent with the link the to the existing form');
        }        
    }
}