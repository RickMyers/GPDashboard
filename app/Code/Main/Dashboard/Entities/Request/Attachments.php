<?php
namespace Code\Main\Dashboard\Entities\Request;
use Argus;
use Log;
use Environment;
/**
 *
 * Request Attachments
 *
 * Attachments related functionality
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Core
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2007-Present, Rick Myers <rick@humbleprogramming.com>
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Attachments.html
 * @since      File available since Release 1.0.0
 */
class Attachments extends \Code\Main\Dashboard\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }
    
    /**
     * Overrides the default save to only save if they uploaded a file
     * 
     * array(2) (
  [name] => (string) M. Pongos, PolkCountyAdult3.4.2020.csv
  [path] => (string) C:\Windows\Temp\tmp9382.tmp
)
     */
    public function save() {
        if ($attachment = $this->getAttachment()) {
            if (isset($attachment['path']) && file_exists($attachment['path'])) {
                @mkdir('../../lib/attachments/'.$this->getRequestId(),0775,true);
                $filename = str_replace([" ",",","'"],["_","",""],$attachment['name']);
                copy($attachment['path'],'../../lib/attachments/'.$this->getRequestId().'/'.$filename);
                $this->setAttachment($filename);
                parent::save();
            }
        }
    }

}