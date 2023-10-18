<?php
namespace Code\Main\Vision\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Invoice Methods
 *
 * Method for managing an invoice
 *
 * PHP version 7.3+
 *
 * @category   Logical Model
 * @package    Application
 * @author     Richard Myers <rmyers@argusdentalvision.com>
 * @copyright  2016-present Hedis Dashboard
 * @license    https://hedis.argusdentalvision.com/license.txt
 * @since      File available since Release 1.0.0
 */
class Invoice extends Model
{

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
     * Marks an invoice as complete and releases all forms to the respective PCP portal
     */
    public function complete() {
        
    }
    
    /**
     * Actually create the invoice, and save the initial members
     * 
     * @return json
     */
    public function create() {
        $invoice_id     = false;
        if ($invoice_id = Argus::getEntity('vision/invoices')->save()) {
            $invoice = Argus::getEntity('vision/invoice/forms');
            foreach ($this->getForms() as $form_id => $active) {
                if ($active) {
                    $invoice->reset()->setInvoiceId($invoice_id)->setFormId($form_id)->save();
                }
            }
        }
        return $invoice_id;
    }
    
    /**
     * The invoice has been paid, now release all forms to the respective PCP portal
     * 
     * @return int     number of forms released
     */
    public function paid() {
        $form   = Argus::getEntity('vision/consultation/forms');
        $ctr    = 0;
        foreach (Argus::getEntity('vision/invoice/forms')->setInvoiceId($this->getInvoiceId())->fetch() as $invoiced_form) {
            $form->reset()->setId($invoiced_form['form_id'])->setPcpPortalWithhold('N')->setStatus('C')->setClaimStatus('Y')->save();
            $ctr++;
        }
        return $ctr;
    }
}