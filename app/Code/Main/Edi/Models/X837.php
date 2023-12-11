<?php
namespace Code\Main\Edi\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * 837 Related functionality
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Client
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @since      File available since Release 1.0.0
 */
class x837 extends Model
{

    use \Code\Base\Humble\Event\Handler;
    private $claim              = [];                                           //the output claim file
    private $document           = [];
    private $sections           = [
        'header'     => [
            'root'      => '/lib/EDI/837/header',
            'templater' => null,
            'template'  => 'default.rain'
        ],
        'transactionstart'   => [
            'root'      => '/lib/EDI/837/transactionstart',
            'templater' => null,
            'template'  => 'default.rain'
        ],
        'transactionend'   => [
            'root'      => '/lib/EDI/837/transactionend',
            'templater' => null,
            'template'  => 'default.rain'
        ],        
        'submitter'     => [
            'root'      => '/lib/EDI/837/submitter',
            'templater' => null,
            'template'  => 'default.rain'
        ],
        'receiver'      => [
            'root'      => '/lib/EDI/837/receiver',
            'templater' => null,
            'template'  => 'default.rain'
        ],
        'provider'      => [
            'root'      => '/lib/EDI/837/provider',
            'templater' => null,
            'template'  => 'default.rain'
        ],
        'subscriber'    => [
            'root'      => '/lib/EDI/837/subscriber',
            'templater' => null,
            'template'  => 'default.rain'
        ],
        'payor'         => [
            'root'      => '/lib/EDI/837/payor',
            'templater' => null,
            'template'  => 'default.rain'
        ],
        'claim'         => [
            'root'      => '/lib/EDI/837/claim',
            'templater' => null,
            'template'  => 'default.rain'
        ],
        'service'       => [
            'root'      => '/lib/EDI/837/service',
            'templater' => null,
            'template'  => 'default.rain'
        ],
        'footer'       => [
            'root'      => '/lib/EDI/837/footer',
            'templater' => null,
            'template'  => 'default.rain'
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
     * This method dynamically prepends the location of the ARGUS module to the section root and looks to see if we have a custom template for this payor. If so, it replaces the default template
     * 
     * @param type $payor
     * @return array
     */
    public function resolveTemplates($payor) {
        $root       = Environment::getRoot('edi');
        foreach ($this->sections as $idx => $section) {
            $this->sections[$idx]['root'] = $root.$section['root'];
            $custom_template = $payor.'.rain';
            if (file_exists($this->sections[$idx]['root'].'/'.$custom_template)) {
                $this->sections[$idx]['template'] = $custom_template;
            }
        }
        return $this->sections;
    }

    /**
     * This is the generation engine
     * 
     * @param iterator $section
     * @param templator $x837
     * @return string
     */
    protected function generation($section,$x837) {
        $templater =  Environment::getInternalTemplater($x837[$section->name()]['root'].'/','rain');
        $template  =  $x837[$section->name()]['template'];
        foreach ($section->defaults() as $var => $val) {
            $templater->assign($var,$val);                                      //reset defaults
        }
        foreach ($section->parameters() as $var => $val) {
            $templater->assign($var,$val);                                      //set to unique values
        }
        return str_replace(["\r","\n"],['',''],$templater->draw(str_replace('.rain','',$template),true));
    }
    
    /**
     * This is the control mechanism for the generation engine
     * 
     * @param type $providers
     * @param string $payor  -- identifies optional templates to use
     * @return $this
     */
    public function generate($providers=false,$payor='default') {
        $templates = $this->resolveTemplates($payor);
        $this->document[] = $this->generation($this->getHeader(),$templates);
        $manager = $this->getTransactionManager();
        foreach ($providers as $provider) {
            foreach ($provider->subscribers() as $subscriber) {
                $this->document[] = $manager->accumulate($this->generation($manager->reset(),$templates));
                $this->document[] = $manager->accumulate($this->generation($this->getSubmitter(),$templates));
                $this->document[] = $manager->accumulate($this->generation($this->getReceiver(),$templates));
                $this->document[] = $manager->accumulate($this->generation($provider,$templates));                
                $this->document[] = $manager->accumulate($this->generation($subscriber,$templates));
                $this->document[] = $manager->accumulate($this->generation($subscriber->payor(),$templates));
                foreach ($subscriber->claims() as $claim_number => $claim) {
                    $this->document[] = $manager->accumulate($this->generation($claim,$templates));
                    foreach ($claim->services() as $line_control_number =>  $service) {
                        $this->document[] = $manager->accumulate($this->generation($service,$templates));
                    }
                }
                $this->document[] = $manager->accumulate($this->generation($manager->close(),$templates));                            
            }
        }
        $this->document[] = $manager->accumulate($this->generation($this->getFooter(),$templates));
        $this->document   = implode('',$this->document);
        return $this;
    }
    
    /**
     * If you do not set a destination, this method will return the document instead
     * 
     * @param string $destination
     * @return boolean/data
     */
    public function write($destination=false) {
        $output = false;
        if ($destination = $destination ? $destination : $this->getDestination()) {
           $output = file_put_contents($destination,$this->document);
        } else {
            $output = $this->document;
        }
        return $output;
    }
}