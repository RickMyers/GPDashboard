<?php
namespace Code\Main\Argus\Helpers;
use Argus;
use Log;
use Environment;
/**
 *
 * MSOffice Methods
 *
 * see description
 *
 * PHP version 7.2+
 *
 * @category   Utility
 * @package    Application
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2005-present Hedis Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    1.0.0
 * @link       https://humbleprogramming.com/docs/class-MSOffice.html
 * @since      File available since Release 1.0.0
 */
class MSOffice extends Helper
{

    protected $data = [];
    
    /**
     * Constructor
     * 
        if (!$xml) {
            echo "Failed loading XML<br /><br />";
            foreach(libxml_get_errors() as $error) {
                echo "\t", $error->message."<br />";
            }
        }     
     */
    public function __construct() {
        parent::__construct();
        libxml_use_internal_errors(true);
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
     * Recursion is fun -- NOT
     * 
     * @param type $node
     */
    private function recurseNode($node=false) {
        if ($node) {
            foreach ($node as $n => $ode) {
                if (is_string($ode)) {
                    if ($n !== 'style') {
                        $this->data[] = [$n=>$ode];
                    }
                } else {
                    $this->recurseNode($ode);
                }
            }
            
        }
    }
    
    /**
     * Tries to rip the text portion out of the document and return it as JSON
     * 
     * @return JSON
     */
    public function docxToJson() {
        if ($doc = $this->getDoc()) {
            if ($input  = file_exists($doc['path']) ? $doc['path'] : false) {
                $file   = \PhpOffice\PhpWord\IoFactory::load($input);
                $writer = \PhpOffice\PhpWord\IOFactory::createWriter($file,'HTML');
                $cnv    = [ '<?xml version="1.0"?>' ];
                $writer->save($input);        
                foreach (explode("\n",file_get_contents($input)) as $idx => $line) {
                    if (($idx === 0) || ($idx === 1)) {
                        continue;
                    }
                    $search = [
                      '&nbsp;'
                    ];
                    $replace = [
                        ''
                    ];
                    $cnv[] = str_replace($search,$replace,$line);
                }
                $this->recurseNode($stuff = json_decode(json_encode(simplexml_load_string(implode("",$cnv))),true));
            }
        }
        return json_encode($this->data);
    }
}