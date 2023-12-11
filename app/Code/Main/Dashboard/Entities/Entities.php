<?php
namespace Code\Main\Dashboard\Entities;
use Argus;
use Log;
use Environment;
/**
 *
 * Table/Entity Framework related queries
 *
 * These queries actually reference the underlying framework
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Framework
 * @author     Rick Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2007-Present, Rick Myers <rick@humbleprogramming.com>
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Entities.html
 * @since      File available since Release 1.0.0
 */
class Entities extends Entity
{

    private $headers = [];
    
    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * 
     * @return type
     */
    public function namespaces() {
        $query = <<<SQL
           select distinct namespace
             from humble_entities
            order by namespace
SQL;
        return $this->query($query);
    }
    
    /**
     * 
     * 
     * @param type $namespace
     * @return type
     */
    public function moduleEntities($namespace=false) {
        $namespace = ($namespace) ? $namespace : $this->getNamespace();
        $query = <<<SQL
            select *
              from humble_entities
             where namespace = '{$namespace}'
             order by entity
SQL;
        return $this->query($query);
    }
    
    /**
     * 
     * @param type $namespace
     * @return type
     */
    public function list($namespace=false) {
        $namespace = ($namespace) ? $namespace : $this->getNamespace();
        $query = <<<SQL
           select '' as 'text', '' as 'value'
             from humble_entities
           union
           select entity as 'text', entity as 'value'
             from humble_entities
            where namespace = '{$namespace}'
SQL;
        return $this->query($query);
    }

    /**
     * 
     * 
     * @param type $iterator
     * @return type
     */
    public function headers($iterator=false) {
        if ($iterator) {
            $row = false;
            foreach ($iterator as $row) {
                break;
            }
            if ($row) {
                foreach ($row as $header => $stuff) {
                    $this->headers[] = $header; 
                }
            }
            return $iterator;
        } else {
            return $this->headers;
        }
    }
    
    /**
     * Dynamically constructs an entity reference and returns some rows
     * 
     * @return iterator
     */
    public function dynamicQuery() {
        $entity = Argus::getEntity($this->getNamespace()."/".$this->getEntity())->_rows($this->_rows())->_page($this->_page());
        $iterator = $this->headers($this->normalize($entity->fetch()));
        $this->_rowCount($entity->_rowCount());
        $this->_toRow($entity->_toRow());
        $this->_fromRow($entity->_fromRow());
        return $iterator;
    }
    
    /**
     * Returns just one of the rows of the table
     * 
     * @return array
     */
    public function editQuery() {
        if (($this->getNamespace() == 'humble') && ($this->getEntity() == 'users')) {
            return Argus::getEntity($this->getNamespace()."/".$this->getEntity())->setUid($this->getId())->load();
        } else {
            return Argus::getEntity($this->getNamespace()."/".$this->getEntity())->setId($this->getId())->load();
        }
    }
    
    /**
     * A generic save routine, can save any entity and field list
     * 
     * @return int
     */
    public function save() {
        if (($this->getNamespace() == 'humble') && ($this->getEntity() == 'users')) {
            $entity = Argus::getEntity($this->getNamespace()."/".$this->getEntity())->setId($this->getUid());
        } else {
            $entity = Argus::getEntity($this->getNamespace()."/".$this->getEntity())->setId($this->getId());
        }
        foreach ($fields = json_decode($this->getFields()) as $field => $value) {
            if ($field=='_id') {
                continue;
            }
            $method = 'set'.$this->underscoreToCamelCase($field,true);
            $entity->$method($value);
        }
        return $entity->save();
    }
    
    public function run() {
        $results = [];
        $not_allowed = ['drop','truncate','alter'];
        if ($query = $this->getQuery()) {
            foreach ($not_allowed as $command) {
                if (strpos(strtolower($query),$command)!==false) {
                    die('Command '.$command.' Is not allowed');
                }
            }
            $results = $this->headers($this->normalize($this->query($query)));
        }
        return $results;
    }
}