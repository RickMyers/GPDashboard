<?php
namespace Code\Main\Argus\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * DB and Table Creator Utility
 *
 * see title
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Core
 * @author     Rick Myers <rmyers@aflac.com>
 */
class DBCreator extends Model
{

    use \Code\Base\Humble\Event\Handler;

    //Recommended lengths for fields rather than using varchar
    private $rec_lengths = [
        8,16,32,64,128,255,1024
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
     * Recommends a field length, based on some arbitrary BS
     * 
     * @param type $field
     * @return type
     */
    public function recommend($max) {
        $rec    = 0;
        for ($i = 0; $i < count($this->rec_lengths); $i++) {
            if ($rec = ($max < $this->rec_lengths[$i] ? $this->rec_lengths[$i] : $rec) ) {
                break;
            }
        }
        return $rec;
    }
    
    /**
     * Spins through all rows and all data calculating max size of field so I can "recommend" a size larger than that
     * 
     * @param type $arr
     * @return type
     */
    public function analyze($arr) {
        $lengths = [];
        foreach ($arr as $row) {
            foreach ($row as $key => $value) {
                if ($key) {
                    $lengths[$key] = ($len = strlen($value)) > ($lengths[$key] ?? 0) ? $len : $lengths[$key]; //splodey head mode
                }
            }
        }
        return $lengths;
    }
    
    
    /**
     * Builds the create table query SQL
     * 
     * @param type $namespace
     * @param type $name
     * @param type $fields
     * @param type $lengths
     */
    protected function createTable($namespace,$name,$lengths) {
        $db   = \Singleton::getMySQLAdapter();
        $db->rawQuery('drop table '.$namespace.'_'.$name);
        $sql  = 'create table '.$namespace.'_'.$name.' ( '."\n";
        $sql  .= ' id int not null auto_increment, '."\n";
        foreach ($lengths as $field => $len) {
            $sql.= ' `'.$field.'` char('.$this->recommend($len).') default null,'."\n";
        }
        $sql  .= ' modified timestamp default current_timestamp,'."\n";
        $sql  .= ' primary key (id) )';
        $db->rawQuery($sql);   //shouldn't do this but oh well
    }
    
    /**
     * Builds the bulk insert query SQL
     * 
     * @param type $namespace
     * @param type $name
     * @param type $data
     */
    protected function populateTable($namespace,$name,$fields,$data) {
        $db    = \Singleton::getMySQLAdapter();
        $top1  = 'insert into '.$namespace.'_'.$name.' ( ';
        $top2  = '';
        foreach ($fields as $field => $len) {
            $top2 .= (($top2) ? ',' : '')."`".addslashes($field)."`";
        }
        $top3 = ' ) '."\n".' VALUES '."\n";
        $ctr  = 0; $comma=false; $rows = '';
        foreach ($data as $idx => $row) {
            $dat  = '';
            $rows .= $comma ? ',(' : '(';
            foreach ($row as $value) {
                $dat .= ($dat ? ',': '')."'".addslashes($value). "'";
            }
            $rows .= $dat. ')'."\n";
            $comma = $idx;
            if ($ctr++ > 200) {
                $db->rawQuery($top1.$top2.$top3.$rows);
                $comma = false; $rows  = '';
            }
        }
        if ($ctr <= 200) {
            $db->rawQuery($top1.$top2.$top3.$rows);
        }
    }
    
    public function create() {
        $name       = $this->getTableName();
        $namespace  = $this->getNamespace();
        $creator    = Argus::getHelper('argus/CSV');
        if ($csv    = $this->getCsv()) {
            if ($csv['path'] ?? false) {
                $data = $creator->loadCSV($csv['path'],true);
                $this->createTable($namespace,$name,$fields = $this->analyze($data));
                $this->populateTable($namespace,$name,$fields,$data);
            }
        }
    }
}