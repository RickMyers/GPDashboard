<?php
namespace Code\Clients\Prestige\Models;
use Humble;
use Log;
use Environment;
/**
 *
 * Reconciliation Methods
 *
 * Logic in support of the reconciling things for prestige
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Client
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @link       https://jarvis.enicity.com/docs/class-&&MODULE&&.html
 * @since      File available since Release 1.0.0
 */
class Reconciliation extends Model
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
     * If available, will return the complete contents of a CSV file
     *
     * @param array $file
     * @return boolean
     */
    private function loadCSV($file) {
        $data = false;
        if ($file && isset($file['path'])) {
            $data = [];
            if (($handle = fopen($file['path'], "r")) !== FALSE) {
                while (($data[] = fgetcsv($handle, 0, ",")) !== FALSE) {  }
                fclose($handle);
            }
        }
        return $data;
    }
    
    /**
     * The Prestige Provider Reconciliation Report Has Been Run
     *
     * @workflow use(event)
     * @return boolean
     */
    public function report() {
        $reconciled     = false;
        if (($argus_providers = $this->loadCSV($this->getArgusProviders())) && ($prestige_providers = $this->loadCSV($this->getPrestigeProviders()))) {

        }
        $this->trigger('prestigeReconciliationReportRun',__CLASS__,__METHOD__,[

        ]);
        return $reconciled;
    }

}