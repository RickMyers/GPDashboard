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
 * @author     Original Author <rmyers@argusdentalvision.com>
 * @copyright  2007-present, Humbleprogramming.com
 * @license    https://humbleprogramming.com/license.txt
 * @version    3.0.1
 */
class EDIModel extends Model
{
    protected $parameters = [];
    
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
        $token      = substr($name,3);
        $token{0}   = strtolower($token{0});
        if (substr($name,0,3)=='get') {
            $name       = strtolower(preg_replace('/([a-z])([A-Z])/', '$1_$2', $token));
            $result     = $this->__get($name);
        }
        return $result;
    }    

        
    public function parameters() {
        return $this->parameters;
    }
}
?>
