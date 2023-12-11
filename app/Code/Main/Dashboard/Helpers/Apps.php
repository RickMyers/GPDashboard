<?php
namespace Code\Main\Dashboard\Helpers;
use Argus;
use Log;
use Environment;
/**
 *
 * Desktop App Helper Methods
 *
 * See Title
 *
 * PHP version 7.2+
 *
 * @category   Apps
 * @package    Desktop
 * @author     Rick Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2005-present Hedis Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    1.0.0
 * @link       https://humbleprogramming.com/docs/class-Apps.html
 * @since      File available since Release 1.0.0
 */
class Apps extends Helper
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
     * If the user uploaded icons, this routine moves them to their appropriate directory
     */
    public function processIconImages() {
        $icon   = $this->getIcon();
        $app_id = $this->getAppId();
        if (isset($icon['path']) && file_exists($icon['path'])) {
            $app = Argus::getEntity('dashboard/desktop/available/apps')->setId($app_id);
            @mkdir('../images/dashboard/desktop/minimized',0777,true);
            copy($icon['path'],'app/Code/Main/Dashboard/desktop/'.$icon['name']);
            copy($icon['path'],'../images/dashboard/desktop/'.$icon['name']);
            $app->setIcon('/images/dashboard/desktop/'.$icon['name']);
            if ($minimized = $this->getMinimized()) {
                if (isset($minimized['path']) && file_exists($minimized['path'])) {
                    copy($minimized['path'],'app/Code/Main/Dashboard/desktop/minimized/'.$minimized['name']);
                    copy($minimized['path'],'../images/dashboard/desktop/minimized/'.$minimized['name']);                    
                    $app->setMinimizedIcon('/images/dashboard/desktop/mimimized/'.$minimized['name']);
                }
            }
            $app->save();
        }
    }
}