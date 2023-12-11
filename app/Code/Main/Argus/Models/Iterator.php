<?php
namespace Code\Main\Argus\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Limited SQL Server Support
 *
 * Due to the use of SQL Server, we are going to only provide a bit of
 * support
 *
 * PHP version 7.2+
 *
 * @category   Logical Model
 * @package    Client
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Iterator.html
 * @since      File available since Release 1.0.0
 */
class Iterator extends \Code\Base\Humble\Models\Iterator
{

    
    public function override($dataset=[]) {
        $this->array = $dataset;
    }
    
    public function set($dataset=false) {
        $rows = [];
        while ($row = sqlsrv_fetch_array( $dataset, SQLSRV_FETCH_ASSOC)) {
            $rows[] = $row;
        }
        return parent::set($rows);
    }

}