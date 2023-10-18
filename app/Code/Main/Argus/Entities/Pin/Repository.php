<?php
namespace Code\Main\Argus\Entities\Pin;
use Argus;
use Log;
use Environment;
/**
 * 
 * Pin Management
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Entity
 * @package    Client
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2005-Present Argus Dental and Vision
 * @since      File available since Release 1.0.0
 */
class Repository extends \Code\Main\Argus\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * A user_id and an MD5'd pin is passed in, if we find a row, then it was a match
     * 
     * @return boolean
     */
    public function valid() {
        $data = $this->load(true);
        return (isset($data['id']));
    }
}