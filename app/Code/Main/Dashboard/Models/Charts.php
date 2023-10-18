<?php
namespace Code\Main\Dashboard\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * Dashboard Charts
 *
 * Chart creation related stuff
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Framework
 * @author     Richard Myers <rmyers@argusdentalvision.com>
 * @copyright  2005-present Argus Dashboard
 * @since      File available since Release 1.0.0
 */
class Charts extends Model
{

    use \Code\Base\Humble\Event\Handler;
    private $templater = false;
    private $resource  = [];
    private $palette = [
        [
            "fillColor"             => "rgba(220,220,220,0.2)",
            "strokeColor"           => "rgba(220,220,220,1)",
            "pointColor"            => "rgba(220,220,220,1)",
            "pointStrokeColor"      => "#fff",
            "pointHighlightFill"    => "#fff",
            "pointHighlightStroke"  => "rgba(220,220,220,1)",
            "highlightFill"         => "rgba(220,220,220,0.75)",
            "highlightStroke"       => "rgba(220,220,220,1)",
            "scaleFontColor"        => "rgba(202,202,202,.8)"
        ],
        [
            "fillColor"             => "rgba(151,187,205,0.2)",
            "strokeColor"           => "rgba(151,187,205,1)",
            "pointColor"            => "rgba(151,187,205,1)",
            "pointStrokeColor"      => "#fff",
            "pointHighlightFill"    => "#fff",
            "pointHighlightStroke"  => "rgba(151,187,205,1)",
            "highlightFill"         => "rgba(151,187,205,0.75)",
            "highlightStroke"       => "rgba(151,187,205,1)",
            "scaleFontColor"        => "rgba(202,202,202,.8)"
        ],
        [
            "fillColor"             => "rgba(187,151,205,0.2)",
            "strokeColor"           => "rgba(187,151,205,1)",
            "pointColor"            => "rgba(187,151,205,1)",
            "pointStrokeColor"      => "#fff",
            "pointHighlightFill"    => "#fff",
            "pointHighlightStroke"  => "rgba(187,151,205,1)",
            "highlightFill"         => "rgba(187,151,205,0.75)",
            "highlightStroke"       => "rgba(187,151,205,1)",
            "scaleFontColor"        => "rgba(202,202,202,.8)"
        ],
        [
            "fillColor"             => "rgba(205,151,187,0.2)",
            "strokeColor"           => "rgba(205,151,187,1)",
            "pointColor"            => "rgba(205,151,187,1)",
            "pointStrokeColor"      => "#fff",
            "pointHighlightFill"    => "#fff",
            "pointHighlightStroke"  => "rgba(205,151,187,1)",
            "highlightFill"         => "rgba(205,151,187,0.75)",
            "highlightStroke"       => "rgba(205,151,187,1)",
            "scaleFontColor"        => "rgba(202,202,202,.8)"
        ]
    ];

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
     * Returns the known charts on a particular page
     *
     * @return array/iterator
     */
    public function fetch($namespace=false,$controller=false,$action=false) {
        $charts     = [];
        $namespace  = ($namespace)  ? $namespace    : Argus::_namespace();
        $controller = ($controller) ? $controller   : Argus::_controller();
        $action     = ($action)     ? $action       : Argus::_action();
        if ($namespace && $controller && $action) {
            $charts = Argus::getEntity('dashboard/chart/locations')->setNamespace($namespace)->setController($controller)->setAction($action)->fetch();
        }
        return $charts;
    }

    /**
     * Returns the charts as configured for the current user
     *
     * @return array/iterator
     */
    public function users($namespace=false,$controller=false,$action=false,$user_id=false) {
        $charts     = [];
        $namespace  = ($namespace)  ? $namespace    : Argus::_namespace();
        $controller = ($controller) ? $controller   : Argus::_controller();
        $action     = ($action)     ? $action       : Argus::_action();
        $user_id    = $user_id      ? $user_id      : Environment::whoAmI();
        if ($user_id) {
            $charts = Argus::getEntity('dashboard/user/charts')->setNamespace($namespace)->setController($controller)->setAction($action)->setUserId($user_id)->fetchChartData();
        }
        return $charts;
    }

    /**
     *
     * @param type $chart_id
     */
    private function fetchData($chart_id=false,$palette) {
        $dataset = '';
        if ($chart_id) {
            switch ($chart_id) {
                /* #######################################################################
                   # SAMPLE LINE CHART
                   ####################################################################### */
                case 1 :
                    $first  = true;
                    $data   = ["65, 59, 80, 81, 56, 55, 40","28, 48, 40, 19, 86, 27, 90"];
                    foreach ($data as $idx => $set) {
                        if (!$first) {
                            $dataset .= ",";
                        }
                        $first  = false;
                        $dataset .= <<<DATASET
                        {
                            "label": "Dataset",
                            "fillColor": "{$palette[$idx]['fillColor']}",
                            "strokeColor": "{$palette[$idx]['strokeColor']}",
                            "pointColor": "{$palette[$idx]['pointColor']}",
                            "pointStrokeColor": "{$palette[$idx]['pointStrokeColor']}",
                            "pointHighlightFill": "{$palette[$idx]['pointHighlightFill']}",
                            "pointHighlightStroke": "{$palette[$idx]['pointHighlightStroke']}",
                            "scaleFontColor": "{$palette[$idx]['scaleFontColor']}",
                            "data": [$set]
                        }
DATASET;
                    }
                    break;
                /* #######################################################################
                   # SAMPLE BAR CHART
                   ####################################################################### */
                case 2 :
                    $first  = true;
                    $data   = ["65, 59, 80, 81, 56, 55, 40","28, 48, 40, 19, 86, 27, 90"];
                    foreach ($data as $idx => $set) {
                        if (!$first) {
                            $dataset .= ",";
                        }
                        $first  = false;
                        $dataset .= <<<DATASET
                            {
                                "label": "Dataset",
                                "fillColor": "{$palette[$idx]['fillColor']}",
                                "strokeColor": "{$palette[$idx]['strokeColor']}",
                                "highlightFill": "{$palette[$idx]['highlightFill']}",
                                "highlightStroke": "{$palette[$idx]['highlightStroke']}",
                                "data": [$set]
                            }
DATASET;
                    }
                    break;
                /* #######################################################################
                   # SAMPLE PIE CHART
                   ####################################################################### */
                case 3 :
                    $first = true;
                    $data  = [
                        'Red'=>['value'=>300,'color'=>'#F7464A','highlight'=>'#FF5A5E'],
                        'Green'=>['value'=>50,'color'=>'#46BFBD','highlight'=>'#5AD3D1'],
                        'Yellow'=>['value'=>100,'color'=>'#FDB45C','highlight'=>'#FFC870']
                    ];
                    foreach ($data as $label => $set) {
                        if (!$first) {
                            $dataset .= ",";
                        }
                        $first   = false;
                        $dataset .= <<<DATASET
                        {
                            "value": {$set['value']},
                            "color": "{$set['color']}",
                            "highlight": "{$set['highlight']}",
                            "label": "{$label}"
                        }
DATASET;
                    }
                    break;
                /* #######################################################################
                   # RADAR SAMPLE CHART
                   ####################################################################### */
                case 4 :
                    $data  = ["65, 59, 90, 81, 56, 55, 40","28, 48, 40, 19, 96, 27, 100"];
                    $first = true;
                    foreach ($data as $idx => $set) {
                        if (!$first) {
                            $dataset .= ",";
                        }
                        $first = false;
                        $dataset = <<<DATASET
                        {
                            "label": "My First dataset",
                            "fillColor": "{$palette[$idx]['fillColor']}",
                            "strokeColor": "{$palette[$idx]['strokeColor']}",
                            "pointColor": "{$palette[$idx]['pointColor']}",
                            "pointStrokeColor": "{$palette[$idx]['pointStrokeColor']}",
                            "pointHighlightFill": "{$palette[$idx]['pointHighlightFill']}",
                            "pointHighlightStroke": "{$palette[$idx]['pointHighlightStroke']}",
                            "data": [{$set}]
                        }
DATASET;
                    }
                    break;
                default:
                    break;
            }
        }
        return $dataset;
    }
    
    /**
     * Gets the corresponding data via remote call (mapping.yaml) for the graph in question
     * 
     * @param array $chart
     * @return mixed
     */
    public function resource($chart=false) {
        $ns = $chart['chart_namespace'];
        if (!isset($this->resource[$ns])) {
            $this->resource[$ns] = Argus::getModel($ns.'/model');
        }
        $method = $chart['resource'];
        $this->resource[$ns]->setSessionId(true);
        $this->resource[$ns]->setLayer($chart['layer']);
        return $this->resource[$ns]->$method();
    }
    
    /**
     *
     * @param int $chart_id
     * @param type $area
     */
    public function render($chart=false) {
        $root = "lib/ChartTemplates/";
        if ($chart && $chart['layer']) {
            if (!$this->templater) {
                $this->templater = Environment::getInternalTemplater($root);
            }
            if (file_exists($source = $root.$chart['chart_id'].'.rain')) {
                $this->templater->assign('layer',$chart['layer']);
                $this->templater->assign('datasets',$this->fetchData($chart['chart_id'],$this->palette));
                return $this->templater->draw($chart['chart_id'],true);
            }
        }
    }

   /**
     * User has updated the charts they display on their dashboard
     * 
     * @workflow use(EVENT)
     */
    public function saveCharts() {
        $uid    = $this->getUserId();
        $charts = json_decode($this->getData(),true);
        $user_charts = Argus::getEntity('dashboard/user_charts');
        $locations = [
            'dashboard-chart-1'=>true,
            'dashboard-chart-2'=>true,
            'dashboard-chart-3'=>true,
            'dashboard-chart-4'=>true
        ];
        foreach ($charts as $location => $chart) {
            if (isset($locations[$location])) {
                $user_charts->reset()->setUserId($uid)->setNamespace($charts['namespace'])->setController($charts['controller'])->setAction($charts['action'])->setChartId($chart)->setLayer($location)->save();
            }
        }
    }

}