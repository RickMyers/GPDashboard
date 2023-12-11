<?php
namespace Code\Main\Edi\Models;
/**    
 *
 * Model Base Transfer Class
 *
 * All module business model classes must extend this class
 *
 * PHP version 5.5+
 *
 * LICENSE:
 *
 * @category   Model
 * @package    Edi
 * @author     Original Author <rmyers@aflacbenefitssolutions.com>
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    3.0.1
 */
class EDIModel extends Model
{
    protected $parameters = [];

    
    /**
     * Basic magic method for setting, with an option to encrypt the value before setting it.  If encrypted, the flag is disabled after setting
     * 
     * @param string $name
     * @param mixed $value
     * @return $this
     */
    public function __set($name,$value)   {
        $this->parameters[$name] = $value;
        return $this;
    }
        
    /**
     * We don't support the extended RPC functionality in an entity, so we are suppressing that here
     *
     * @param type $name
     * @return type
     */
    public function __get($name)   {
        $retval = null;
        if (!is_array($name)) {
            if (isset($this->parameters[$name])) {
                $retval = $this->parameters[$name];
            }
        }
        return $retval;
    }

    /**
     * This method overrides the similar method in the core model object.  We do so because we need to prevent "accidental" RPC behavior
     *
     * @param string $name
     * @param array $arguments
     * @return type
     */
    public function __call($name, $arguments){
        $result     = null;
        if (substr($name,0,3)=='get') {
            $result     = $this->__get($this->camelCaseToUnderscore(substr($name,3), true));
        } else if (substr($name,0,3)=='set') {
            $result     = $this->__set($this->camelCaseToUnderscore(substr($name,3), true),$arguments);
        }
        return $result;
    }    

        
    public function parameters() {
        return $this->parameters;
    }
}
?>
