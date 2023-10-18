<?php
namespace Code\Main\Dental\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Teledentistry related methods
 *
 * Assorted methods supporting the teledentistry product.
 *
 * PHP version 7.2+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@argusdentalvision.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Teledentistry.html
 * @since      File available since Release 1.0.0
 */
class Teledentistry extends Model
{

    use \Code\Base\Humble\Event\Handler;

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
     * Takes an x-ray image and stores it in the DB, while also makes a thumbnail of it.
     */
    public function uploadXray() {
        $xray  = $this->getXray();
        $image = Argus::getHelper('humble/image');
        $t = explode('.',$xray['name']);
        $ext   = $image->getExtension($xray['name']);
        $form  = Argus::getEntity('dental/consultation/xrays');
        $image->fetch($xray['path']);
        $image->generateThumbnail($xray['name'],$ext);
        $form->setThumbnail('data:image/png;base64,'.base64_encode(file_get_contents($xray['name'])));
        $image->writePNG($xray['name']);
        $form->setXray('data:image/png;base64,'.base64_encode(file_get_contents($xray['name'])));
        $form->setFilename($t[0].".png");
        $form->setMemberId($this->getMemberId());
        $form->save();
        unlink($xray['name']);
        Argus::emit('newTeledentistryXray',['filename'=>$xray['name'],'member_id'=>$this->getMemberId()]);
    }
    
    /**
     * Will tag any xrays that have a member id but no form id with the form id passed in.
     */
    public function claimXrays() {
        $member_id = $this->getMemberId();
        $form_id   = $this->getFormId();
        if ($member_id && $form_id) {
            
        }
    }    
}