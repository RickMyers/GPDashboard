<?php
namespace Code\Main\Dental\Entities\Consultation;
use Argus;
use Log;
use Environment;
/**
 * 
 * Dental Snapshots
 *
 * Queries and useful methods
 *
 * PHP version 7.0+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Snapshots.html
 * @since      File available since Release 1.0.0
 */
class Snapshots extends \Code\Main\Dental\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Generates just a list of the smaller thumbnails of snapshots
     * 
     * @return iterator
     */
    public function thumbnails() {
        $query = <<<SQL
         select id, form_id, taken_by, thumbnail
           from dental_consultation_snapshots
          where form_id = '{$this->getFormId()}'
SQL;
        $results = $this->query($query);
        return $results;
    }
    
    /**
     * Creates a thumbnail of the snapshot and saves it with the snapshot for faster rendering later
     * 
     * 
     */
    public function thumbnailAndSave($width=250,$height=187.5) {
        $image        = imagecreatefromstring(base64_decode(substr($this->getSnapshot(),22)));
        $imageWidth   = imageSX($image);
        $imageHeight  = imageSY($image);        
        $tmp_img      = ImageCreateTrueColor(250,250);
        imagecopyresampled($tmp_img,$image,0,0,0,0,$width,$height,$imageWidth,$imageHeight);
        ob_start();
        imagepng($tmp_img);
        $png = ob_get_flush();
        $this->setThumbnail('data:image/png;base64,'.base64_encode($png));
        $this->save();
    }
}