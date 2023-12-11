<?php
namespace Code\Main\Argus\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * Report related methods
 *
 * Methods to support the management of reports in the dashboard and with
 * reportico
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @since      File available since Release 1.0.0
 */
class Reports extends Model
{

    use \Code\Base\Humble\Event\Handler;

    private $source = false;
    private $xml    = false;
    
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
     * 
     */
    public function newProject() {
        $settings = new \Settings();
        $sources = [
            'config.php' => 'reportico/SAMPLE_PROJECT/config.php',
            'menu.php' =>   'reportico/SAMPLE_PROJECT/menu.php',
            'lang.php' =>   'reportico/SAMPLE_PROJECT/lang.php'
        ];        
        if ($project_name = $this->getProjectName()) {
            $dest_dir = 'reportico/projects/'.$project_name;
            @mkdir($dest_dir,0775,true);
            $srch = [
                '{$project_title}',
                '{$project_user}',
                '{$project_db_host}',
                '{$project_db}',
                '{$project_password}'
            ];
            $repl = [
                $project_name,
                $settings->getUserid(),
                $settings->getDBHost(),
                $settings->getDatabase(),
                $settings->getPassword()
            ];
            foreach ($sources as $dest => $source) {
                file_put_contents($dest_dir.'/'.$dest,str_replace($srch,$repl,file_get_contents($source)));
            }            
        }
    }
    
    /**
     * Based on number of components calculates optimal width
     * 
     * @param int $number_of_components
     * @return float
     */
    public function determineComponentWidth($number_of_components=4) {
        
        return (round(100/$number_of_components,1)-0);
    }
    
    /**
     * 
     */
    public function newReport() {
        $sources = [
            "report" => 'reportico/SAMPLE_PROJECT/report.xml'
        ];
        
        if ($report_name    = $this->getReportName()) {
            $project_data   = Argus::getEntity('argus/report_projects')->setId($this->getProjectId())->load();
            $output         = 'reporticon/projects/'.$project_data['project'].'/'.$report_name.'.xml';
            $srch = [
                '{$report_name}',
                '{$report_description}'
            ];
            $repl = [
                $report_name,
                $this->getReportDescription()
            ];
            file_put_contents($output,str_replace($srch,$repl,file_get_contents($sources['report'])));
        }
    }
    
    /**
     * Gets all the components, which are used for selecting parameters to us in reporting, defined under a particular namespace or module
     * 
     * @param type $namespace
     * @return array
     */
    private function fetchComponents($namespace=false) {
        $components = [];
        if ($namespace) {
            if ($root = Environment::getRoot($namespace)) {
                $source = $root.'/Reporting/Components';
                if (is_dir($source)) {
                    $dir = dir($source);
                    while ($entry = $dir->read()) {
                        if (($entry === '.') || ($entry === '..')) {
                            continue;
                        }
                        if ($xml = simplexml_load_file($source.'/'.$entry)) {
                            $components[substr($entry,0,strpos($entry,'.'))] = $xml;
                        }                        
                    }
                    $dir->close();
                }
            }
        }
        return $components;
    }
    
    /**
     * Loads the components belonging to a selected namespace as well as the default components stored in the Argus module
     * 
     * @param type $namespace
     * @return array
     */
    protected function loadComponents($namespace=false) {
        return $components = [
            'argus' => $this->fetchComponents('argus'),
            $namespace => $this->fetchComponents($namespace)
        ];
    }
    
    /**
     * Determines the file name of the report...
     * 
     * @TODO: Make sure this is only called once
     * 
     * @param type $root
     * @param type $name
     * @return type
     */
    private function fetchReportFilename($root,$name) {
        $file_name = false;
        $host      = $root.'/Reporting';
        if (is_dir($host)) {
            $dir = dir($host);
            while (($entry = $dir->read()) && !$file_name) {
                if (($entry === '.') || ($entry === '..') || (is_dir($host.'/'.$entry))) {
                    continue;
                }
                if ($xml = simplexml_load_file($host.'/'.$entry)) {
                    $this->setReportFilename($file_name = ((string)$xml->name === $name) ? $entry : false);
                }
            }
            $dir->close();            
        }
        return $file_name;
    }
    
    /**
     * Gets just the list of components a particular report is going to be using
     * 
     * @param type $namespace
     * @param type $report
     * @return array
     */
    protected function loadReportSelectionSetup($namespace,$report) {
        $selection = [];
        if ($root = Environment::getRoot($namespace)) {
            $source = $root.'/Reporting/'.$this->fetchReportFilename($root,$report);
            if (file_exists($source)) {
                if ($xml = simplexml_load_file($source)) {
                    $selection = $xml->selection;
                    $attr = $xml->resource[0]->attributes();
                    $this->setMethod($attr['method']);
                }
            }
        }
        return $selection;
    }
    
    /**
     * Gets just the list of components a particular report is going to be using
     * 
     * @param type $namespace
     * @param type $report
     * @return array
     */
    protected function loadGraphAreaSetup($namespace,$report) {
        $graphs = [];
        if ($root = Environment::getRoot($namespace)) {
            $this->source = $root.'/Reporting/'.$this->fetchReportFilename($root,$report);
            if (file_exists($this->source)) {
                if ($this->xml = simplexml_load_file($this->source)) {
                    $graphs = $this->xml->graphs;
                }
            }
        }
        return $graphs;
    }
        
    
    /**
     * Gets just the list of graphs a particular report is going to be using
     * 
     * @param type $namespace
     * @param type $report
     * @return array
     */
    protected function loadReportColumnsSetup() {
        //i used to do more here
        return $this->xml->columns;
    }    
    
    /**
     * Resolves which components are going to be rendered, either the ones from the namespaced module, or the ones in the default (Argus) module
     * 
     * @param type $namespace
     * @return type
     */
    public function setup($namespace=false,$report=false) {
        $layout     = [];
        $components = ($namespace = $namespace ? $namespace : (($this->getNamespace()) ? $this->getNamespace() : false)) ? $this->loadComponents($namespace) : [];
        foreach (($selection  = ($report = $report ? $report : (($this->getReport()) ? $this->getReport() : false)) ? $this->loadReportSelectionSetup($namespace,$report) : []) as $options) {
            foreach ($options as $node => $option) {
                if ($ns = isset($components[$namespace][$node]) ? $namespace : (isset($components['argus'][$node]) ? 'argus' : false)) {
                    $components[$ns][$node]->options = $option;
                    $layout[] = $components[$ns][$node];
                }
            }
        }
        $json = json_encode($layout);
        foreach ($layout = json_decode($json,TRUE) as $idx => $values) {
            foreach ($values as $node => $value) {
                if (is_array($value)) {
                    foreach ($value as $n => $val) {
                        if ($n === '@attributes') {
                            $layout[$idx][$node] = $val;
                            unset($layout[$idx][$node]['@attributes']);
                        }
                    }
                }
            }
        }
        return $layout;
    }
    
    /**
     * Looks for report XML layouts in a module identified by a namespace, and returns what reports are available
     * 
     * @param type $namespace
     * @return array
     */
    public function available($namespace=false) {
        $available = [];
        if ($namespace = $namespace ? $namespace : (($this->getNamespace()) ? $this->getNamespace() : false)) {
            if ($root = Environment::getRoot($namespace)) {
                $host = $root.'/Reporting';
                if (is_dir($host)) {
                    $dir = dir($host);
                    while ($entry = $dir->read()) {
                        if (($entry === '.') || ($entry === '..') || (is_dir($host.'/'.$entry))) {
                            continue;
                        }
                        if ($xml = simplexml_load_file($host.'/'.$entry)) {
                            $available[] = [
                                "name" => $xml->name,
                                "description" => $xml->description
                            ];
                        }
                    }
                    $dir->close();
                }
            }
        }
        return $available;
    }
    
    public function executeResource($graph=null) {
        $result = 'Didnt execute';
        $attr = $graph->attributes();
        if (isset($attr->resource)) {
            $model = Argus::getModel($this->getNamespace().'/model');
            if ($args  = isset($attr->arguments) ? (string)$attr->arguments : false) {
                foreach (explode(',',$args) as $arg) {
                    $method = 'set'.$this->underscoreToCamelCase($arg,true);
                    if (isset($_REQUEST[$arg])) {
                        $model->$method($_REQUEST[$arg]);
                    }
                }
            }
            $resource = (string)$attr->resource;
            $result = $model->setStyle(isset($attr->style) ? (string)$attr->style : '')->$resource();
        }
        return $result;
    }
    
    /**
     * Runs the report by calling the method associated to the service as defined in the /RPC/mapping.yaml file
     * 
     * @return iterator
     */
    protected function run($namespace,$action) {
        $namespace = $this->getNamespace();
        $action    = $this->getMethod();        
        $obj       = Argus::getModel($namespace.'/model');                      //I just need a model in that namespace... any model will do
        foreach ($this->_data as $var => $val) {
            $method = 'set'.$this->underscoreToCamelCase($var,true);
            $obj->$method($val);
        }
        return $obj->$action();
    }
    
    /**
     * Returns a value formatted using the filter passed to it
     * 
     * @param type $format
     * @param type $field
     * @return type
     */
    private function formatReportField($format=false,$field=false) {
        if ($format && $field) {
            switch (strtoupper($format)) {
                case "DATE" :
                    $field = date('m/d/Y',strtotime($field));
                    break;
                case "UCFIRST" :
                    $field = ucfirst($field);
                    break;
                case "UPPER" :
                    $field = strtoupper($field);
                    break;
                case "LOWER" :
                    $field = strtolower($field);
                    break;                
                default :
                    break;
            }
        }
        return $field;
    }
    
    /**
     * Takes the results of the run and then applies the layout specified in the report XML to reformat the report
     * 
     * @param type $namespace
     * @param type $report
     * @return type
     */
    protected function process($namespace=false,$report=false,$export=false) {
        $results   = [];        
        $headers   = [];        
        $action    = $this->getMethod();
        $graphs    = $this->loadGraphAreaSetup($namespace, $report);
        $layout    = $this->loadReportColumnsSetup();
        $data      = json_decode($this->run($namespace,$action),true);
        $first     = true;
        foreach ($data as $line) {
            $row = []; 
            foreach ($layout as $columns) { 
                foreach ($columns as $column) {
                    $attr   = $column->attributes();
                    $name   = (string)$attr->name;
                    $source = (string)$attr->source;
                    if ($first) {
                        $headers[] = $name;
                    }
                    if (isset($line[$source])) {
                        $row[$name] = $line[$source];
                        if (isset($attr->format) && $line[$source]) {
                            $row[$name] = $this->formatReportField((string)$attr->format,$line[$source]);
                        }
                        if (isset($attr->onempty) && $attr->onempty && !$line[$source]) {
                            $row[$name] = (string)$attr->onempty;
                        }
                        if (isset($attr->style) && !$export) {
                            $row[$name] = '<div style="'.$attr->style.'">'.$row[$name].'</div>';
                        }
                    } else {
                        $row[$name] = ($export) ? ' ' : '&nbsp;';
                    }
                }
                $first = false;
            }
            $results[] = $row;
        }
        $args = $this->fetch();
        $this->setModel(Argus::getModel($namespace.'/model'));
        $this->setHeaders($headers);
        $this->setGraphs($graphs);
        return $results;
    }

    /**
     * Just drives the display generation process... this has a view
     * 
     * @return iterator
     */
    public function display() {
        $namespace = $this->getNamespace();
        $report    = $this->getReport();
        $results   = $this->process($namespace,$report);
        return $results;
    }
    
    /**
     * Similar to the display action, this one just sets the proper headers to download this as a report
     * 
     * @return type
     */
    public function export() {
        $namespace = $this->getNamespace();
        $report    = $this->getReport();
        $results   = $this->process($namespace,$report,true);
        $report    = str_replace([' '],['_'],$report);
	header('Content-Disposition: attachment; filename="'.$report.'.csv"');
        return Argus::getHelper('argus/CSV')->toCSV($results);
    }
}