<?php
namespace Code\Main\Vision\Entities\Invoice;
use Argus;
use Log;
use Environment;
/**
 *
 * Invoice Forms methods
 *
 * Methods around managing forms on an invoice
 *
 * PHP version 7.2+
 *
 * @category   Entity
 * @package    Application
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @copyright  2007-Present, Rick Myers <rick@humbleprogramming.com>
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Forms.html
 * @since      File available since Release 1.0.0
 */
class Forms extends \Code\Main\Vision\Entities\Entity
{

    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * Gets some related member information for each member on the invoice
     * 
     * @return iterator
     */
    public function invoiceFormData() {
        $results = [];
        if ($invoice_id = $this->getId() ? $this->getId() : ($this->getInvoiceId() ? $this->getInvoiceId() : false)) {
            $query = <<<SQL
                select a.*, b.member_name, b.member_id, b.screening_client, b.event_date
                  from vision_invoice_forms as a
                  left outer join vision_consultation_forms as b
                    on a.form_id = b.id
                 where a.invoice_id = '{$invoice_id}'
SQL;
            $results = $this->query($query);
        }
        return $results;
    }
    
    /**
     * Gets information about the potential members to create an invoice 
     * 
     * @param type $json
     * @return type
     */
    public function memberData($json=false) {
        $ids = []; $members = [];
        foreach (json_decode($json) as $form => $use) {
            if ($use) {
                $ids[] = $form;
            }
        }
        if ($ids) {
            $members = Argus::getEntity('vision/consultation/forms')->idIn($ids)->fetch(true);
        }
        return $members;
    }
 }