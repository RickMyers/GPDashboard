<?php
namespace Code\Main\Dashboard\Models;
use Argus;
use Log;
use Environment;
/**
 *
           ,-.
       ,--' ~.).
     ,'         `.
    ; (((__   __)))
    ;  ( (#) ( (#)
    |   \_/___\_/|
   ,"  ,-'    `__".
  (   ( ._   ____`.)--._        _
   `._ `-.`-' \(`-'  _  `-. _,-' `-/`.
    ,')   `.`._))  ,' `.   `.  ,','  ;
  .'  .     `--'  /     ).   `.      ;
 ;     `-        /     '  )         ;
 \                       ')       ,'
  \                     ,'       ;
   \               `~~~'       ,'
    `.                      _,'
hjw   `.                ,--'
        `-._________,--'

QUACK!
 * System/Application methods
 *
 * Diagnostic related methods
 *
 * PHP version 7.3+
 *
 * @category   Other
 * @package    Dashboard
 * @author     Rick Myers <rmyers@argusdentalvision.com>
 * @copyright  2016-present Hedis Dashboard
 * @license    https://hedis.argusdentalvision.com/license.txt
 * @since      File available since Release 1.0.0
 */
class System extends Model
{

  //  use Spatie\Async\Pool;
    
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

    public function SQLDBCheck() {
        return "Ok";
    }
    
    public function NoSQLCheck() {
        return "Ok";
    }
    
    public function CacheCheck() {
        return "Ok";
    }
    
    public function DWHCheck() {
        return "Ok";
    }
    
    public function EmailCheck() {
        return "Ok";
    }

    /**
     * Message relay
     */
    public function broadcast() {
        $data = ($this->getData()) ? $this->getData() : [];
        if (!is_array($data)) {
            $data = json_encode($data);
        }
        if ($event = $this->getEvent()) {
            $pool = Pool::create();
            $pool->add(function ()  {
                Argus::emit($event,$data);
            })->then(function ($output) {
                // Handle success
            })->catch(function (Throwable $exception) {
                // Handle exception
            });
        }
    }
}