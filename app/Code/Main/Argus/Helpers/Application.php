<?php
namespace Code\Main\Argus\Helpers;
use Argus;
use Log;
use Environment;
/**
 * 
 * Online Application Helper
 *
 * Methods supporting our management of online dental and vision
 * applications
 *
 * PHP version 7.0+
 *
 * @category   Utility
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2005-present Argus Dashboard
 * @license    https://jarvis.enicity.com/license.txt
 * @version    1.0.0
 * @link       https://jarvis.enicity.com/docs/class-Application.html
 * @since      File available since Release 1.0.0
 */
class Application extends Helper
{

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
     * Finds a PDF that has been stored off the web root and spits it out
     */
    public function fetchPDF() {
        $out = '';
        if (count($app = Argus::getEntity('argus/online_applications')->setApplicationId($this->getAppId())->load(true))) {
            $location = '../../lib/online/applications/'.$app['broker'].'/app_'.$app['application_id'].'.pdf';
            if (file_exists($location)) {
                $out = file_get_contents($location);
            }
        }
        return $out;
    }
    
    /**
     * 
     * @param EventObject $event
     * @return array
     */
    public function filterEvent($event=false) {
        $filtered_event = [];
        if ($EVENT!==false) {
            $event                          = json_decode(json_encode($event),true);  //converts the serialized objects into arrays
            $filter_event['id']             = isset($event['_id']) ? $event['_id'] : 'N/A';
            $event_name                     = lcfirst($event['name']);
            if (isset($event[$event_name]['application'])) {
                unset($event[$event_name]['application']);
            }
            $filtered_event[$event['name']] = $event[$event_name];
            if (isset($event['stages'])) {
                $filtered_event['stages'] = $event['stages'];
                foreach ($event['stages'] as $idx => $stage) {
                    $filtered_event['stages'][$idx]['configuration'] = isset($event['configurations'][$stage['id']])     ? $event['configurations'][$stage['id']] : 'N/A';
                    $filtered_event['stages'][$idx]['started']       = isset($filtered_event['stages'][$idx]['started']) ? date('m/d/Y H:i:s',$filtered_event['stages'][$idx]['started']) : 'N/A';
                    $filtered_event['stages'][$idx]['finished']      = isset($filtered_event['stages'][$idx]['finished'])? date('m/d/Y H:i:s',$filtered_event['stages'][$idx]['finished']) : 'N/A';
                }
            }
        }
        return $filtered_event;
    }
    
    /**
     * Adds some HTML annotation to a recursive node list so that we can collapse/expand it
     * 
     * @param type $nodes
     * @return string
     */
    public function recurseNodelist($nodelist,$class="nodeList") {
        $out = '';
        foreach ($nodelist as $idx => $node) {
            if (is_array($node)) {
                $out .= '<li class="'.$class.'">'.$idx.'<ul>'.$this->recurseNodelist($node,$class).'</ul></li>';
            } else {
                $out .= '<li class="'.$class.'">'.$idx.' - '.$node.'</li>';
            }
        }
        return $out;
    }
            
    public function expandEvent($mongo_data,$class) {
        return $this->recurseNodelist($this->filterEvent(json_decode(json_encode($mongo_data),true)),$class);
    }
    
    public function IEFBR14() {
        parent::IEFBR14();
    }    
    /**
     * Removes PCI related data from the Event
     * 
     * @param \app\Code\Base\Core\Event\Object $EVENT
     * @return \app\Code\Base\Core\Event\Object
     */
    public function nukePaymentdata($EVENT=false) {
        return $EVENT;
    }
}