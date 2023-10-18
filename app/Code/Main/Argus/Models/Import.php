<?php
namespace Code\Main\Argus\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Import Database Methods
 *
 * see title
 *
 * PHP version 7.3+
 *
 * @category   Logical Model
 * @package    Dashboard
 * @author     Rick Myers <rmyers@argusdentalvision.com>
 * @copyright  2016-present Hedis Dashboard
 * @license    https://hedis.argusdentalvision.com/license.txt
 * @since      File available since Release 1.0.0
 */
class Import extends Model
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

    private function entryAlreadyExists($orm=false,$options=[],$row=[]) {
        
    }
    
    /**
     * 
     */
    public function processImportFile() {
        if ($file = $this->getApplyRules()) {
            if ($data_file = $this->getDataFile()) {
                $zip = new \ZipArchive();
                $zip->open('import_tmp/'.$data_file);
                $zip->extractTo('import_extract/');
                $zip->close();
                $data = json_decode(file_get_contents('import_extract/entities.json'),true);
                foreach (json_decode(file_get_contents($file['path']),true) as $namespace => $entities) {
                    foreach ($entities as $entity => $options) {
                        $orm = Argus::getEntity($namespace.'/'.$entity);
                        if (isset($data[$namespace][$entity])) {
                            $orm = Argus::getEntity($namespace.'/'.$entity);
                            foreach ($data[$namespace][$entity] as $row) {
                                if (isset($options['overwrite']) && !$options['overwrite']) {
                                    if ($this->entryAlreadyExists($orm,$options,$row)) {
                                        continue;
                                    }
                                }
                                $orm->reset();
                                foreach ($row as $field => $value) {
                                    $method = 'set'.$this->underscoreToCamelCase($field,true);
                                    $orm->$method($value);
                                }
                                $orm->save();
                            }
                        }

                    }
                    
                    $a = 1;
                }
                unlink('import_extract/entities.json');
            }
        }
    }
    /**
     * 
     */
    public function importDatabase() {
        if (($scheme = $this->getScheme()) && isset($scheme['path']) ) {
            $this->setScheme(file_get_contents($scheme['path']));
            if (Argus::getEntity('argus/user/roles')->setUserId($this->getUserId())->userHasRole('Webservice Access')) {
                if ($user = Argus::getEntity('humble/user_identification')->setId($this->getUserId())->load()) {
                    $this->setApiUserId(10980 - (int)$this->getUserId());
                    $this->setApiKey($user['api_key']);
                    $parts = explode('.',$scheme['name']);

                    if ($auth = json_decode($this->authenticationService(),true)) {
                        if ((int)$auth['RC']===0) {
                            $session_id = session_id(); 
                            session_id($auth['sessionId']);
                            $environment = Argus::getEntity('argus/servers')->setId($this->getEnvironment())->load();
                            session_id($session_id);
                            $service = $environment['service'];
                            ob_start();
                            print($this->setSessionId($auth['sessionId'])->$service());
                            $this->setFilename($parts[0].'_'.date('YmdHis').'.zip');
                            file_put_contents('import_tmp/'.$this->getFilename(),ob_get_flush());
                        } else {
                            $this->_notices(print_r($auth,true));
                        }
                    }
                }
            }
        }
    }
}