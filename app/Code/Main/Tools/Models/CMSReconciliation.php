<?php
namespace Code\Main\Tools\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * CMS related tool
 *
 * A collection of tools supporting CMS integration
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Client
 * @author     Richard Myers <rmyers@argusdentalvision.com>
 * @since      File available since Release 1.0.0
 */
class CMSReconciliation extends Tool implements ArgusTool
{

    use \Code\Base\Humble\Event\Handler;

    protected $_834_xref    = [];
    protected $_cms_xref    = [];
    protected $_members     = [];
    protected $_01_records  = [];
    protected $_02_record   = '';
    protected $_member      = [];
    protected $_accumulators = [
        "num_records" => 1, /* start at 1 because we will always have an 02 record */
        "num_subscribers" => 0,
        "num_dependents" => 0,
        "total_premium" => 0.0,
        "total_aptc"    => 0.0
    ];
    
    /**
     * Constructor
     */
    public function __construct() {
        \Event::register('argus','CMSReconciliationFileCreated','A reconciliation file has been created');
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
    
    
    public function report() {
    }
    
    
    /**
     * if row indicator is null then skip, else if false it is a constant, else map to column number
     * 
     * @param type $file
     */
    private function createReconciliationXref($file) {
        $rows = explode("\n",file_get_contents($file));
        $xref = [];
        foreach ($rows as $row) {
            $ind        = substr($row,1,3);
            $col        = ($ind==='___') ? null : (trim($ind) === '') ? false : ( (trim($ind) === '###') ? 'Accumulator' : (int)$ind);
            $name       = trim(substr($row,8,35));
            $layout     = explode(',',str_replace(['[',']'],['',''],trim(substr($row,44,28))));
            $xref[]     = [
                'FieldName'      => $name,
                'Column'         => $col,
                'Description'    => substr($row,72),
                'DataType'       => str_replace("'","",((isset($layout[0])) ? $layout[0] : '')),
                'Length'         => str_replace("'","",((isset($layout[1])) ? $layout[1] : '')),
                'Format'         => str_replace("'","",((isset($layout[2])) ? $layout[2] : '')),
                'Default'        => str_replace("'","",((isset($layout[3])) ? $layout[3] : ''))
            ];
        }
        return $xref;
    }
    
    /**
     * Generates an XREF file corresponding field name to the column it can be found in
     * 
     * @param type $file
     */
    private function create834Xref($file) {
        $rows = explode("\n",file_get_contents($file));
        $xref = [];
        foreach ($rows as $row) {
            $field  = trim(substr($row,5));
            $col    = (int)substr($row,0,3);
            $xref[$col] = $field;
        }
        return $xref;
    }
    
    /**
     * Load mapping files
     * 
     * @return boolean
     */
    public function initialize() {
        $xref_file = $this->_root().'/'.$this->getReconciliation01MapFile();
        if (file_exists($xref_file)) {
            $this->_01_xref = $this->createReconciliationXref($xref_file);
        } else {
            die("01 Reconciliation file not found: ".$xref_file."\n\n");
        }
        $xref_file = $this->_root().'/'.$this->getReconciliation02MapFile();
        if (file_exists($xref_file)) {
            $this->_02_xref = $this->createReconciliationXref($xref_file);
        } else {
            die("02 Reconciliation file not found: ".$xref_file."\n\n");
        }        
        $edi_834_xref = $this->_root().'/'.$this->getEDI834MapFile();
        if (file_exists($edi_834_xref)) {
            $this->_834_xref = $this->create834Xref($edi_834_xref);
        } else {
            die("EDI 834 XREF file not found: ".$edi_834_xref."\n\n");
        }        
        $member_file = $this->_root().'/'.$this->getArgusMemberFile();
        if (file_exists($member_file)) {
            $csv_util = Argus::getHelper('argus/CSV');
            $this->_members = $csv_util->toHashTable($member_file);
        }
        print("DONE\n");
        return true;
    }
    
    private function parseValue($member,$cms_xref) {
        $val = '';
        if ($cms_xref['Column'] === false) {
            //This is a constant
            switch ($cms_xref['DataType']) {
                case "String"   :
                    if ($cms_xref['Default']) {
                        $val = $cms_xref['Default'];
                    }
                    if ($cms_xref['Format']) {
                        $pad_char = ' ';
                        if ($cms_xref['Format'] == 'A') {
                            //nop
                        } else if ($cms_xref['Format'] == '#') {
                            $pad_char = '0';
                        }
                        $val = str_pad($val,$cms_xref['Length'],$pad_char);
                    }
                    break;
                case "Now"      :
                    $val = date($cms_xref['Format']);
                    break;
                default     :
                    $val    = "";
                    break;
            }
        } else if ($cms_xref['Column'] === null) {
            //skip, this is an empty field
        } else  if ($cms_xref['Column'] === 'Accumulator') {
            $val = $this->_accumulators[$cms_xref['Format']];
        } else {
            if ($cms_xref['Column']!==0) {
                $val = $member[strtoupper($this->_834_xref[$cms_xref['Column']])];
                switch ($cms_xref['DataType']) {
                    case "String"   :
                        if ($cms_xref['Format']) {
                            $pad_char = ' ';
                            if ($cms_xref['Format'] == 'A') {
                                //nop
                            } else if ($cms_xref['Format'] == '#') {
                                $pad_char = '0';
                            }
                            $val = str_pad($val,$cms_xref['Length'],$pad_char);
                        }
                        break;
                    case "Now"      :
                        $val = date($cms_xref['Format']);
                        break;
                    case "Date"     :
                        if (trim($val)) {
                            $val = date($cms_xref['Format'],strtotime($val));
                        }
                        break;
                    case "Dollars"  :
                        break;
                    default     :
                        $val    = "";
                        break;
                }
            }                
            //go get value from member and apply conversion routines
        }
        return $val;
    }
    
    /**
     * Processes the individual member records
     */
    protected function generate01Records() {
        $this->_01_records = [];
        foreach ($this->_members as $member) {
            if (!$this->_member) {
                $this->_member = $member;
            }
            $this->_accumulators['num_records']++;
            $this->_accumulators['num_subscribers']++;
            if (!trim($member['ID'])) {
                continue;
            }
            $record = [];
            foreach ($this->_01_xref as $cms_idx => $cms_xref) {
                $record[] = $this->parseValue($member,$cms_xref);
            }
            $this->_01_records[] = implode('|',$record);
        }
        
    }
    
    protected function generate02Record() {
        $record = [];
        foreach ($this->_02_xref as $cms_idx => $cms_xref) {
            $record[] = $this->parseValue($this->_member,$cms_xref);
        }
        $this->_02_record = implode('|',$record);
    }
    
    /**
     * Process Files
     * 
     * @return boolean
     */
    public function run() {
        $this->generate01Records();
        $this->generate02Record();
        print("GOT HERE\n");
        return true;
    }
    
    /**
     * Close Up
     * 
     * @return boolean
     */
    public function finalize() {
        $output = $this->getReconciliationFile();
        $this->_01_records[] = $this->_02_record;
        if ($output) {
            file_put_contents($this->_root().'/'.$output,implode("\n",$this->_01_records));
            $this->fire('Argus','CMSReconciliationFileCreated',[
                "reconciliation_file" => $this->_root().'/'.$output
            ]);            
        } else {
            throw new \Exception('Output file has not been specified');
        }
        return true;
    }
}