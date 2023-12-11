<?php
/**
 * This is the app branded central factory, which extends the frameworks Abstract Factory class.
 * 
 * It's a good place to put application functionality that is needed everywhere.
 */
    require_once "autoload.php";
    class Argus extends \Humble {

        public static function template($resource=false) {
            $resource = explode('/',$resource);
            /**
             * o if only one resource value, look in defaults
             * o if 2, then look in subfolder
             * o if 2 and not found, look in defaults
             * o return empty string if nothing found
             */
        }
        
        /**
         * Fetches the email template associated to an alias
         * 
         * @param string $alias
         * @return string
         */
        public static function emailTemplate($alias=false,$tostring=false) {
            $template = '';
            if ($alias) {
                if ($data = Argus::getEntity('argus/email_templates')->setTemplate($alias)->load(true)) {
                    if (file_exists('lib/resources/email/templates/'.$data['filename'].".rain")) {
                        if ($tostring) {
                            $template = file_get_contents('lib/resources/email/templates/'.$data['filename']);
                        } else {
                            $template = $data['filename'];
                        }
                    } else {
                        $template = "Error, the file [".$data['filename']."] associated to email alias [".$alias."] was not found";
                    }
                } else {
                    $template = "Error, there is no email template for alias [".$alias."]";
                }
            } else {
                $template = "Error, no alias passed to retrieve an email template";
            }
            return $template;
        }

        /**
         * Returns the tools framework with the dependency injected into it
         * 
         * @param type $alias
         */
        public static function tool($alias) {
            $framework  = false;
            if ($data   = Argus::getEntity('argustools/inventory')->setName($alias)->load(true)) {
                if ($framework = Argus::getModel('argustools/framework')) {
                    $framework->_dependency(Argus::getModel('argustools/'.$data['class']));
                    $framework->_authorization($data['auth_required']);
                    $framework->_description($data['description']);
                    $framework->_role($data['role_required']);
                } else {
                    print("no dice");
                }
            } else {
                die("\nThe tool ".$alias." has no record in our inventory.  Please update the inventory with this tools information.\n");
            }
            return $framework;
        }
        
        public static function fetchWidget($identifier) {
            $widget  = '';
            if ($identifier) {
                $tpl =  'lib/resources/widgets/'.$identifier.'.html';
                $widget = (file_exists($tpl)) ? file_get_contents($tpl) : ''; 
            }
            return $widget;
        }
        
        /**
         * Gets a reference to an entity that will be accessing a Microsoft SQL Server DBO rather than a MySQL Entity.
         * 
         * @param string $identifier
         * @return \class
         */
        public static function getMSEntity($identifier) {
            $instance   = null;
            $class      = false;
            $virtual    = false;
            $entity     = explode('/',$identifier);
            if (count($entity) === 1) {
                $entity[]  = $entity[0];
                $entity[0] = self::_namespace();
            }
            $module     = self::getModule($identifier);
            if ($module) {
                $st         = explode('_',$entity[1]);
                foreach ($st as $idx => $term) {
                    $st[$idx] = ucfirst($term);
                }
                $ast        = implode('/',$st);
                $dir        = str_replace("_","/",$module['entities'])."/".$ast;
                $str        = "Code/{$module['package']}/{$dir}";
                $class      = file_exists($str.".php") ? $str : false;
               
                if (!$class) {
                    $instance = new class(str_replace('/','\\','\\'.$str)) extends Code\Main\Argus\Entities\MSEntity {
                        private $anon_class = null;
                        public function __construct($a) {
                            parent::__construct();
                            $this->anon_class = $a;
                        }
                        public function getClassName() {
                            return $this->anon_class;
                        }
                    };
                } else {
                    $class      = str_replace('/','\\','\\'.$str);
                    $instance   = new $class();
                }
                $instance->_prefix($module['prefix'])->_namespace($entity[0])->_entity($entity[1])->_isVirtual(!$class);
            }
            return $instance;            
        }
        
        /**
         * Just gets the FPDF php PDF creation class
         * 
         * @return \FPDF
         */
        public static function getPDFWriter() {
            require_once('fpdf/fpdf.php');
            return new FPDF();
        }
        
        /**
         * Relays an event to the Node.js Signaling Hub
         * 
         * @param string $eventName
         * @param array $data
         * @return boolean
         */
        public static function emit($eventName,$data=[]) {
            $success = false;
            if ($server = file_get_contents('../../socketserver.txt')) {
                $data['event'] = $eventName;
                $ch = curl_init($server.'/emit');
                curl_setopt($ch, CURLOPT_POST,1);
                curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($data,'','&'));
                curl_setopt($ch, CURLOPT_HEADER, 1);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
                curl_setopt($ch, CURLOPT_TIMEOUT, 10);
                curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20100101 Firefox/7.0.12011-10-16");        
                curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
                curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, false);        
                $res        = curl_exec($ch);
                $info       = curl_getinfo($ch);
                $success    = ($info && isset($info['http_code']) && (($info['http_code'] == '200') || ($info['http_code'] == '100')));
            }
        }
        
        /**
         * Based on value(s) passed in, will find a report layout and return it as an XML STD Class Object. If you only pass in one value, it takes as namespace the current namespace
         * 
         * @param string $identifier
         * @return object
         */
        public static function reportLayout($identifier) {
            $namespace  = self::_namespace();
            $identifier = explode('/',$identifier);
            $layout     = null;
            if (count($identifier) === 1) {
                $report = $identifier[0];
            } else {
                $namespace  = $identifier[0];
                $report     = $identifier[1];
            }
            if ($module = self::getModule($namespace)) {
                $base   = Environment::getRoot($namespace);
                if (file_exists($layout = $base.'/Reports/'.$report.'.xml')) {
                    $layout = simplexml_load_file($layout);
                }
            }
            return $layout;
        }
        
        /**
         * Adhoc report generator... a bigger dataset can be whittled down to a smaller one with better column names
         * 
         * @param array $data
         * @param array $layout
         * @return array
         */
        public static function report($data=[],$layout=[],$convert=false) {
            $layout     = (is_string($layout)) ? self::reportLayout($layout) : $layout; 
            if ($convert) {
                $data       = self::getHelper('argus/CSV')->arrayToHash($data);
            }
            $results    = []; 
            $columns    = [];
            if (isset($layout->columns)) {
                foreach ($layout->columns as $node) {
                    foreach ($node as $nodename => $column) {
                        $attributes = $column->attributes();
                        $key = (string)$attributes->source;
                        $columns[$key] = [];
                        foreach ($attributes as $col=>$val) {
                            $columns[$key][$col] = (string)$val;
                        }
                    }
                }
            }
            foreach ($columns as $source => $column) {
                $row[] = $column['name'];
            }
            $results[] = $row;
            foreach ($data as $line) {
                $row = [];
                foreach ($columns as $source => $column) {
                    $row[] = (isset($line[$source])) ? ((isset($column['ifempty']) && ($column['ifempty']) && ($line[$source]==='') ) ? $column['ifempty'] : $line[$source]) : '';
                }
                $results[] = $row;
            }
            return $results;
        }
        
        /**
         * 
         * 
         * @param type $identifier
         */
        public static function importLayouts($identifier=false) {
            $results = '';
            if ($identifier) {
                $identifier = explode('/',$identifier);
                if ($module = Argus::getModule($identifier[0])) {
                    $root = Environment::getRoot($identifier[0]);
                    if (file_exists($root.'/lib/Eligibility/Import/'.$identifier[1].'.xml')) {
                        $results = simplexml_load_file($root.'/lib/Eligibility/Import/'.$identifier[1].'.xml');
                    } else {
                        throw new Exception("Member Import Map '".$identifier[0].'/'.$identifier[1]."' Not Found",16);
                    }
                }
            }
            return $results;
        }
        
        /**
         * 
         * @param type $namespace
         * @param type $event
         */
        public static function eventServices($namespace=false,$event=false) {
            $events = [];
            if ($namespace && $event) {
                if ($module = Argus::getModule($namespace)) {
                    
                }
            }
            return $events;
        }
        
        /**
         * Microsoft Word Document Parser
         * 
         * @return \PhpOffice\PhpWord\PhpWord
         */
        public static function MSWordParser($file='') {
            return new \PhpOffice\PhpWord\PhpWord($file);
        }
    }
?>