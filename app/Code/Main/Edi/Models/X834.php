<?php
namespace Code\Main\Edi\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * EDI x834 Generation methods
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 */
class X834 extends Model
{

    use \Code\Base\Humble\Event\Handler;
    
    /**
     * This method takes an 834 file and breaks it out into the header, body, and footer sections.  This is the first step to turning the 834 into a template
     * 
     * @param type $file
     */
    public function split834($file=false,$file_qualifier='edi') {
        $header  = [];
        $body    = [];
        $footer  = [];    
        $markers = [ 
            'header' => [
                'ISA' => true,
                'GS'  => true,
                'ST'  => true,
                'BGN' => true,
                'N1'  => true
            ],
            'footer' => [
                'IEA' => true,
                'SE'  => true,
                'GE'  => true
            ]
        ];

        foreach (explode('~',file_get_contents($file)) as $row) {
            $segments = explode('*',$row);
            if (isset($markers['header'][$segments[0]])) {
                $header[] = $row;
            } else if (isset($markers['footer'][$segments[0]])) {
                $footer[] = $row;
            } else {
                $body[] = $row;
            }
        }

        file_put_contents($file_qualifier.'_header',implode("\n",$header));
        file_put_contents($file_qualifier.'_body',implode("\n",$body));
        file_put_contents($file_qualifier.'_footer',implode("\n",$footer));    
    }
    
    /**
     * Generic section handler
     * 
     * @param type $rain
     * @param type $template
     * @param type $data
     * @return type
     */
    protected function generateSection($rain,$template,$data) {
        foreach ($data as $field => $value) {
            $rain->assign($field,$value);
        }
        return $rain->draw($template,true);    
    }
    
    /**
     * https://www.youtube.com/watch?v=6jJkdRaa04g
     * 
     * @param type $template
     * @param type $data
     * @return type
     */
    public function generate($template='default',$data=[]) {
        $root       = Environment::getRoot('edi').'/lib/EDI/834/';
        $header     = file_exists($root.'header/'.$template.'.rain') ? $template : 'default';
        $body       = file_exists($root.'body/'.$template.'.rain')   ? $template : 'default';
        $footer     = file_exists($root.'footer/'.$template.'.rain') ? $template : 'default';
        $document   = $this->generateSection(Environment::getInternalTemplater($root.'header/'),$header,$data[0]);
        foreach ($data as $member) {
            $document .= $this->generateSection(Environment::getInternalTemplater($root.'body/'),$body,$member);
        }
        return $document.$this->generateSection(Environment::getInternalTemplater($root.'footer/'),$footer,array_merge($data[0],['segments'=>count(explode("\n",$document))]));
    }
}