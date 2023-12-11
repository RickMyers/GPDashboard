<?php
namespace Code\Main\Argus\Helpers;
use Argus;
use Log;
use Environment;
/**
 *
 * Member Import Helper
 *
 * *see title
 *
 * PHP version 7.2+
 *
 * @category   Utility
 * @package    Other
 * @author     Richard Myers rmyers@aflacbenefitssolutions.com
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    1.0.0
 * @link       https://humbleprogramming.com/docs/class-Import.html
 * @since      File available since Release 1.0.0
 */
class Import extends Helper
{

    private $store      = [];
    private $dupes      = [];
    private $entities   = [];
    private $xref       = [];
    private $record     = [];
    
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
     * Breaks a string up into an array based on a delimiter and then returns the desired index of the array.
     * 
     * @param string $val
     * @param array $args
     * @return mixed
     */
    private function splitValue($val,$args) {
        $delim = (isset($args['delimiter'])) ? $args['delimiter'] : ',';
        $index = (isset($args['index'])) ? (int)$args['index'] - 1 : 0;
        $results = explode($delim,$val);
        return trim(isset($results[$index]) ? $results[$index] : '');
    }
    
    
    /**
     * If you don't have an active relationship, will create one.  If it changes, then terms the previous one and creates a new one
     * 
     * we need to do the following:
          check to see if you have a relationship with another PCP...
          if so, then expire that one and create a new relationship
          else just create a new relationship

     * @param type $date
     * @param type $args
     */
    private function activeRelationship($date,$args) {
        if ($relationship_type  = (isset($args->relationshipType)  ? (string)$args->relationshipType : ($this->getRelationshipType() ? $this->getRelationshipType() : false))) {
            $relation           = Argus::getEntity('argus/relationship_dates');
            $member_id          = isset($this->store['member_id'])   ? $this->store['member_id']   : ($this->getMemberId() ? $this->getMemberId() : false);
            $relation_id        = isset($this->store['relation_id']) ? $this->store['relation_id'] : ($this->getRelationId() ? $this->getRelationId() : false);
            if (($member_id) && ($relation_id)) {
                if (count($relation_data = $relation->setMemberId($member_id)->setRelationId($relation_id)->setRelationshipType($relationship_type)->load(true))) {
                    if ($relation_data['effective_end_date']) {
                        $relation->setEffectiveEndDate(null)->setEffectiveStartDate($date)->save(); //need to re-establish relationship if there's an end-effective-date
                    }
                } else {
                    $relations = $relation->reset()->setMemberId($member_id)->setRelationshipType($relationship_type)->fetch();
                    foreach ($relations as $prev_relation) {
                        if (!$prev_relation['effective_end_date']) {
                            $relation->reset()->setId($prev_relation['id'])->setEffectiveEndDate($date)->save(); //if no end-effective-date, then we term it and save
                        }
                    }
                    $relation->reset()->setMemberId($member_id)->setRelationId($relation_id)->setRelationshipType($relationship_type)->setEffectiveStartDate($date)->save();
                }
            }
        }
        return false;  /* For this validator, we are going to manage the saving of the values, so we don't want the normal import process to work here */
    }
    
    /**
     * We are going to basically build a xref of an entity for comparison later
     * 
     * @param type $namespace
     * @param type $entity
     * @param type $field
     */
    public function xrefEntity($namespace=false,$entity=false,$field=false) {
        if ($namespace && $entity && $field) {
            if (!isset($this->xref[$namespace])) {
                $this->$namespace = [];
            }
            if (!isset($this->xref[$namespace][$entity])) {
                $this->xref[$namespace][$entity] = [];
            }
            foreach (Argus::getEntity($namespace.'/'.$entity)->fetch() as $row) {
                $row['hash'] = MD5(implode(",",$row));                          //this is used for comparison purposes later.  If new hash matches this one, don't bother with update
                if (isset($row[$field])) {
                    if (isset($this->xref[$namespace][$entity][$row[$field]])) {
                        $this->dupes[$row[$field]] = $row;
                    } else {
                        $this->xref[$namespace][$entity][$row[$field]] = $row;
                    }
                }
            }
        }
    }
    
    /**
     * This builds a cache of entity objects rather than instantiating a new entity object per iteration.  Big improvement in performance
     * 
     * @param type $namespace
     * @param type $entity
     * @return type
     */
    protected function initializeEntity($namespace=false,$entity=false) {
        if (!isset($this->entities[$namespace])) {
            $this->entities[$namespace] = [];
        }
        if (!isset($this->entities[$namespace][$entity])) {
            $this->entities[$namespace][$entity] = Argus::getEntity($namespace.'/'.$entity);
        }
        return $this->entities[$namespace][$entity]->reset();
    }

    /**
     * Updates a file with information about the progress of the upload/import
     * 
     * @param type $file
     * @param type $row
     * @param type $rows
     */
    private function updateProgressFile($file,$row,$rows) {
        file_put_contents($file,json_encode(['rows'=>$rows,'row'=>$row,'percent'=>round(($row/$rows) * 100),'RC'=>'0']));
    }
    
    /**
     * Will return the "record" of what was imported.  What is recorded is determined by an attribute on the column in the import layout XML
     * 
     * @return array
     */
    public function getImportRecord() {
        return $this->record;
    }
    
    /**
     * Assigns a value to the stored (cached) variable
     * 
     * @param type $at
     * @param type $row
     */
    protected function processAssign($at=false,$row=false) {
        if ($at && ($attr = $at->attributes())) {
            if (isset($attr->var) && isset($attr->value)) {
                $this->store[(string)$attr->var] = (string)$attr->value;
            }
        }
    }
    
    /**
     * If Processing, simplified
     * 
     * @param type $node
     * @param type $row
     */
    protected function processIf($node,$row) {
        $var = false; $val = false;
        $attr = $node->attributes();
        if (isset($attr->var)) {
            $var = (string)$attr->var;
        }
        if (isset($attr->eq)) {
            $val = (string)$attr->eq;
        }
        if (($var!==false) && ($val!==false)) {
            if (isset($row[$var]) && ($row[$var] == $val)) {
                if (isset($node->then)) {
                    foreach ($node->then as $n => $a1) {
                        foreach ($a1 as $n => $a) {
                            $this->processNode($n,$a,$row);
                        }
                    }
                }
            } else {
                if (isset($node->else)) {
                    foreach ($node->else as $n1 => $a1) {
                        foreach ($a1 as $n => $a) {
                            $this->processNode($n,$a,$row);
                        }
                    }
                }
            }
        }
    }
    
    /**
     * Handles the kinds of nodes we allow in the XML that aren't related to Entity fields
     * 
     * @param type $node
     * @param type $attr
     * @param type $row
     */
    protected function processNode($node=false,$attr=false,$row) {
        switch (strtolower($node)) {
            case "if"   :
                $this->processIf($attr,$row);
                break;
            case "assign" : 
                $this->processAssign($attr,$row);
                break;
            default     :
                break;
        }
    }
    
    /**
     * Handles the actual parsing of the eligibility file
     * 
     * @param type $source
     * @param type $map
     */
    public function processEligibilityFile($health_plan_id,$source=false,$map=false,$progressFile=false) {
        if ($source && $map) {
            $totalRows = count($source);
            $this->store['health_plan_id'] = $health_plan_id;
            foreach ($source as $rowCtr => $row) {
                if ($progressFile && ($rowCtr % 20 === 0)) {
                    $this->updateProgressFile($progressFile,$rowCtr,$totalRows);
                }
                foreach ($map as $entity_data) {
                    $attr       = $entity_data->attributes();
                    $entity     = $this->initializeEntity((string)$attr->namespace,(string)$attr->class);
                    $store      = (isset($attr->store))     ? (string)$attr->store : false;
                    $use        = (isset($attr->use))       ? explode(",",(string)$attr->use) : false;
                    $validate   = (isset($attr->validate))  ? (string)$attr->validate  : false;
                    foreach ($entity_data as $node => $cols) {
                        $colAttr = $cols->attributes();
                        if (strtolower((string)$node) !== 'column') {
                            $this->processNode($node,$cols,$row);
                            continue;
                        }
                        $method  = 'set'.$this->underscoreToCamelCase((string)$colAttr->name,true);
                        $name    = false; $func = false; $val = false; $args = []; $format = false; $default = false; 
                        $record  = (isset($colAttr->record) && (strtoupper((string)$colAttr->record) == 'Y'));
                        foreach ($cols as $idx => $data) {
                            $dataAttr = $data->attributes();
                            switch ($idx) {
                                case "source"   :
                                    $name = (string)$dataAttr->name;
                                    if ($default = (isset($dataAttr->default)) ? (string)$dataAttr->default : false) {
                                        switch (strtolower($default)) {
                                            case "now"  :
                                                $row[$name]    = date('Y-m-d H:i:s');
                                                break;
                                            default     :
                                                break;
                                        }
                                    }
                                    $format   = (isset($dataAttr->format))   ? (string)$dataAttr->format    : false;
                                    break;
                                case "transform" :
                                    $func = (string)$dataAttr->name;
                                    foreach ($data->argument as $arg) {
                                        $argAttr = $arg->attributes();
                                        $args[(string)$argAttr->name] = (string)$argAttr->value;
                                    }
                                    break;
                                default         :
                                    break;
                            }
                        }
                        if (isset($row[$name])) {
                            $val = trim($row[$name]);
                        } else {
                            continue;
                        }
                        if ($func) {
                            $val = $this->$func($val,$args);
                        }     
                        if ($format) {
                            switch (strtolower($format)) {
                                case 'date'      : 
                                    $val    = date('Y-m-d',strtotime($val));
                                    break;
                                case 'timestamp' :
                                    $val    = date('Y-m-d H:i:s',strtotime($val));
                                    break;
                                case 'metaphone' :
                                    $val    = metaphone(trim(substr($val,0,6)));
                                    break;
                                default          :
                                    break;
                            }
                        }
                        if ($record) {
                            if (!isset($this->record[$name])) {
                                $this->record[$name] = [];
                            }
                            $this->record[$name][] = $val;
                        }
                        $entity->$method($val);
                    }
                    if ($use) {
                        foreach ($use as $field) {
                            $method = 'set'.$this->underscoreToCamelCase($field,true);
                            $entity->$method($this->store[$field]);
                        }
                    }
                    $entity->setModified(date('Y-m-d H:i:s'));
                    //we are going to "validate" this. If true, then we save, otherwise we skip
                    if ($validate) {
                        if ($this->$validate($val,$attr)) {
                            //DRY?
                            if ($store) {
                                $this->store[$store] = $entity->save();
                            } else {
                                $entity->save();
                            }                           
                        }
                    } else {                    
                        if ($store) {
                            $this->store[$store] = $entity->save();
                        } else {
                            $entity->save();
                        }
                    }
                }
            }
            if ($progressFile) {
                $this->updateProgressFile($progressFile,$totalRows,$totalRows);
            }
        }
    }
}