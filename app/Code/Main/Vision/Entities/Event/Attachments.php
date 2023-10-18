<?php
namespace Code\Main\Vision\Entities\Event;
use Argus;
use Log;
use Environment;
/**
 *
 * Vision Event Attachments
 *
 * Special processing for attachments
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Attachments.html
 * @since      File available since Release 1.0.0
 */
class Attachments extends \Code\Main\Vision\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }
    
    /**
     * If the user uploaded an attachment, this will save it to a repository on disk before calling the actual save method
     * 
     * @return int
     */
    public function save() {
        if ($attachment = $this->getAttachment()) {
            $event_id = $this->getEventId();
            $this->setFilename($attachment['name']);
            @mkdir('/var/www/attachments/vision/events/'.$event_id,0775,true);            
            @copy($attachment['path'],'/var/www/attachments/vision/events/'.$event_id.'/'.$attachment['name']);
        };
        return parent::save();
    }
    
    /**
     * Will get all attachments related to an event and who created that attachment
     * 
     * @param int $event_id
     * @return iterator
     */
    public function details($event_id=null) {
        $event_id = ($event_id) ? $event_id : $this->getEventId();
        $query = <<<SQL
                select a.*,
                       concat(b.first_name,' ',b.last_name) as author
                  from vision_event_attachments as a
                  left outer join humble_user_identification as b
                    on a.author_id = b.id
                 where a.event_id = '{$event_id}'
SQL;
        return $this->query($query);
    }

    /**
     * Gets the attachment and reads it back...
     */
    public function open() {
        if ($attachment = $this->load()) {
            $resource = '/var/www/attachments/vision/events/'.$attachment['event_id'].'/'.$attachment['filename'];
            if (file_exists($resource)) {
                if ($mime_type = mime_content_type($resource)) {
                    Header('Content-Type: '.$mime_type);
                    Header('Content-Disposition: attachment; filename="'.$attachment['filename'].'"');
                    return file_get_contents($resource);
                }
            }
        };
    }
}