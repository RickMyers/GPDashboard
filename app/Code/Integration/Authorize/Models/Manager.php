<?php
namespace Code\Integration\Authorize\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * Authorize.net related data structure(s).  Multiple ways are supported for populating the data structures
 *
 * We use this class too build the data structures that will be needed to complete calls to Authorize.net
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Richard Myers <rmyers@aflacbenefitssolutions.com>
 * @since      File available since Release 1.0.0
 */
class Manager extends Model
{

    use \Code\Base\Humble\Event\Handler;
    
    private $_credentials           = [];
    private $_mode                  = false;
    private $_payment               = [];
    private $_lineItems             = [];
    private $_tax                   = [];
    private $_duty                  = [];
    private $_shipping              = [];
    private $_amount                = 0;
    private $_customer              = [];
    private $_billTo                = [];
    private $_shipTo                = [];
    private $_paymentSchedule       = [];
    private $_trialAmount           = '0.00';
    private $_transactionSettings   = [];
    private $_userFields            = [];
    private $_poNumber              = false;
    private $_refId                 = false;
    private $credentialSource       = ['test' => 'Authorize.net Sandbox Authentication',
                                       'prod' => 'Authorize.net Authentication'];
    
    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
        $this->_RPC(false);         //while building the data structure, turn off elevated 'gets' to prevent unnecessary work
        $this->_mode('test');
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
     * By default, we are going to use the test sandbox
     * 
     * @param string $mode
     * @return $this
     */
    public function _mode($mode=null) {
        if ($mode !== null) {
            $this->_mode = strtolower($mode);
            return $this;
        }
        return $this->_mode;
    }
    
    /**
     * Builds the specific section of the transaction data structure
     * 
     * @return boolean
     */
    public function setCredentials($name=false,$transactionKey) {
        $cred = [ 
                "name"            => $name,
                "transactionKey"  => $transactionKey 
        ];
        return $this->_credentials($cred);
    }
    
    /**
     * There's a Byte Order Mark on some UTF8 strings.  This removes it if it is present.   To be honest, I have no idea what a BOM is used for
     * 
     * @param UTF8-String $text
     * @return UTF8-String
     */
    public function remove_utf8_bom($text)  {
        $bom  = pack('H*','EFBBBF');
        return  preg_replace("/^$bom/", '', $text);
    }     
    
    /**
     * Builds the specific section of the transaction data structure
     * 
     * @return boolean
     */
    public function setPayment($cardNumber,$expirationDate,$cardCode=false) {
        $card_data = ['cardNumber'=>$cardNumber];
        $card_data['expirationDate'] = $expirationDate;
        if ($cardCode) {
            $card_data['cardCode'] = $cardCode;
        }
        return $this->_payment(["creditCard"=>$card_data]);
    }
    
    /**
     * 
     * @param type $interval
     * @param type $startDate
     * @param type $total
     * @param type $trial
     */
    public function setPaymentSchedule($interval=[],$startDate=false,$total=12,$trial=1) {
        $schedule = [
            "interval"  => $interval,
            "startDate" => $startDate,
            "totalOccurrences" => (string)$total
        ];
        return $this->_paymentSchedule($schedule);
    }
    
    /**
     * Builds the specific section of the transaction data structure
     * 
     * @return boolean
     */
    public function setLineItems($itemId,$name="Item",$description='Item',$quantity=1,$unitPrice=0.00) {
        $line_item = [
            "itemId"        => $itemId,
            "name"          => $name,
            "description"   => $description,
            "quantity"      => $quantity,
            "unitPrice"     => $unitPrice
        ];
        $this->_amount($unitPrice);
        return $this->_lineItems($line_item);
    }
    
    /**
     * Builds the specific section of the transaction data structure
     * 
     * @return boolean
     */
    public function setTax($amount,$name="Taxed Amount",$description="Taxed Amount") {
        $tax = [
            "amount"        => $amount,
            "name"          => $name,
            "description"   => $description
        ];
        return $this->_tax($tax);
    }
    
    /**
     * Builds the specific section of the transaction data structure
     * 
     * @return boolean
     */
    public function setDuty($amount,$name="Duty Name",$description="Duty Description") {
        $duty = ["amount"       => $amount,
                 "name"         => $name,
                 "description"  => $description];
        return $this->_duty($duty);
    }
    
    /**
     * Builds the specific section of the transaction data structure
     * 
     * @return boolean
     */
    public function setShipping($amount,$name="Shipping Name",$description="Shipping Description") {
        $shipping = ["amount"       => $amount,
                     "name"         => $name,
                     "description"  => $description];        
        return $this->_shipping($shipping);
    }
    
  //  public function setRefId($id) {
  //      return $this->_refId($id);
  //  }
    
    /**
     * Builds the specific section of the transaction data structure
     * 
     * @return boolean
     */
    public function setCustomer($id) {
        return $this->_customer($id);
    }
    
    /**
     * Builds the specific section of the transaction data structure
     * 
     * @return boolean
     */
    public function setBillTo($firstName,$lastName,$company='',$address='',$city='',$state='',$zip='',$country='USA') {
        $address = [
            "firstName" => $firstName,
            "lastName"  => $lastName,
            "company"   => $company,
            "address"   => $address,
            "city"      => $city,
            "state"     => $state,
            "zip"       => $zip,
            "country"   => $country
        ];
        return $this->_billTo($address);
    }
    
    /**
     * Builds the specific section of the transaction data structure
     * 
     * @return boolean
     */
    public function setShipTo($firstName,$lastName,$company='',$address,$city,$state,$zip,$country='USA') {
        $address = [
            "firstName" => $firstName,
            "lastName"  => $lastName,
            "company"   => $company,
            "address"   => $address,
            "city"      => $city,
            "state"     => $state,
            "zip"       => $zip,
            "country"   => $country
        ];
        return $this->_shipTo($address);    
    }

    /**
     * Builds the specific section of the transaction data structure
     * 
     * @return boolean
     */
    public function setTransactionSettings() {
        return $this;
    }
    
    /**
     * Builds the specific section of the transaction data structure
     * 
     * @return boolean
     */
    public function setUserFields($field,$val) {
        $user_field = [
            "name"  => $field,
            "value" => $val
        ];
        return $this->_userFields($user_field);
    }
    
    /**
     * Mutator for purchase order number
     * 
     * @param string $poNumber
     * @return mixed
     */
    public function setPoNumber($poNumber) {
        return $this->_poNumber($poNumber);
    }
    
    /**
     * Sets the section data specifically
     * 
     * @param type $credentials
     * @return $this
     */
    public function _credentials($credentials=false) {
        if ($credentials) {
            $this->_credentials = $credentials;
            return $this;
        } else {
            //nop
        }
        return $this->_credentials;
    }
    
    /**
     * If value is passed in, tallies up the line item amounts, otherwise returns the current amount
     * 
     * @param type $amt
     * @return $this
     */
    protected function _amount($amt=false) {
        if ($amt===false) {
            return $this->_amount;
        }
        $this->_amount+=$amt;
        return $this;
    }
    
    /**
     * Sets the section data specifically
     * 
     * @param type $credentials
     * @return $this
     */    
    public function _payment($payment=false) {
        if ($payment) {
            $this->_payment = $payment;
            return $this;
        }
        return $this->_payment;
    }
    
    /**
     * Sets the section data specifically
     * 
     * @param string $poNumber
     * @return $this
     */    
    public function _poNumber($poNumber=false) {
        if ($poNumber) {
            $this->_poNumber = $poNumber;
            return $this;
        }
        return $this->_poNumber;
    }
        
    
    /**
     * Sets the section data specifically
     * 
     * @param type $credentials
     * @return $this
     */    
    public function _lineItems($lineItem=false) {
        if ($lineItem) {
            if (!$this->_lineItems) {
                $this->_lineItems = ['lineItem'=>[]];
            }
            $this->_lineItems['lineItem'][] = $lineItem;
            return $this;
        }
        return $this->_lineItems;
    }
    
    /**
     * Sets the section data specifically
     * 
     * @param type $credentials
     * @return $this
     */    
    public function _tax($tax=false) {
        if ($tax) {
            $this->_tax = $tax;
            return $this;
        }
        return $this->_tax;
    }
    
    /**
     * Sets the section data specifically
     * 
     * @param type $credentials
     * @return $this
     */    
    public function _duty($duty=false) {
        if ($duty) {
            $this->_duty = $duty;
            return $this;
        }
        return $this->_duty;
    }   
    
    /**
     * Sets the section data specifically
     * 
     * @param type $credentials
     * @return $this
     */    
    public function _shipping($shipping=false) {
        if ($shipping) {
            $this->_shipping = $shipping;
            return $this;
        }
        return $this->_shipping;
    }
    
    /**
     * Sets the section data specifically
     * 
     * @param type $credentials
     * @return $this
     */    
    public function _customer($customer=false) {
        if ($customer) {
            if (!$this->_customer) {
                $this->_customer = ['id'=>''];
            }
            $this->_customer['id'] = $customer;
            return $this;
        }
        return $this->_customer;
    }  

    /**
     * Sets the section data specifically
     * 
     * @param type $credentials
     * @return $this
     */    
    public function _refId($id=false) {
        if ($id) {
            $this->_refId = $id;
            return $this;
        }
        return $this->_refId;
    }  
    
    /**
     * Sets the section data specifically
     * 
     * @param type $credentials
     * @return $this
     */    
    public function _billTo($billTo=false) {
        if ($billTo) {
            $this->_billTo = $billTo;
            return $this;
        }
        return $this->_billTo;
    }  
    
    /**
     * Sets the section data specifically
     * 
     * @param type $shipto
     * @return $this
     */    
    public function _shipTo($shipTo=false) {
        if ($shipTo) {
            $this->_shipTo = $shipTo;
            return $this;
        }
        return $this->_shipTo;
    }  

    /**
     * Sets the section data specifically
     * 
     * @param type $trialAmount
     * @return $this
     */        
    public function _trialAmount($amount=false) {
        if ($amount) {
            $this->_trialAmount = $amount;
            return $this;
        }
        return $this->_trialAmount;
    }  
    
    /**
     * Sets the section data specifically
     * 
     * @param type $schedule
     * @return $this
     */        
    public function _paymentSchedule($schedule=false) {
        if ($schedule) {
            $this->_paymentSchedule = $schedule;
            return $this;
        }
        return $this->_paymentSchedule;
    }      
    
    /**
     * Sets the section data specifically
     * 
     * @param type $credentials
     * @return $this
     */    
    public function _transactionSettings($transactionSettings=false) {
        if ($transactionSettings) {
            $this->_transactionSettings = $transactionSettings;
            return $this;
        }
        return $this->_transactionSettings;
    }
    
    /**
     * Sets the section data specifically
     * 
     * @param type $credentials
     * @return $this
     */    
    public function _userFields($userField=false) {
        if ($userField) {
            if (!$this->_userFields) {
                $this->userFields = ['userField'];
            }
            $this->_userFields['userField'][] = $userField;
            return $this;
        }
        return $this->_userFields;
    }
    
    /**
     * Removes any unneeded transaction elements
     * 
     * @param type $transaction
     * @return type
     */
    protected function filterTransaction($data) {
        foreach ($data as $var => $val) {
            if (is_array($val)) {
                $data[$var] = $this->filterTransaction($val);
                if (!$data[$var]) {
                    unset($data[$var]);
                }
            } else {
                if (!$val && ($val !== 0)) {
                    unset($data[$var]);
                }
            }
        }
        return $data;
    }
    
    /**
     * Builds the request transaction data structure
     * 
     * @param string $type
     * @return array
     */
    protected function buildRequestTransaction($type) {
        return [
            "merchantAuthentication" => $this->_credentials(),
            "refId" => $this->_refId(),
            "transactionRequest" => [
                "transactionType"   => $type,
                "amount"            =>  $this->_amount(),
                "payment"           =>  $this->_payment(),
                "lineItems"         =>  $this->_lineItems(),
                "tax"               =>  $this->_tax(),
                "duty"              =>  $this->_duty(),
                "refTransId"        =>  $this->_refTransId(),
                "shipping"          =>  $this->_shipping(),
                "poNumber"          =>  $this->_poNumber,
                "billTo"            =>  $this->_billTo(),
                "shipTo"            =>  $this->_shipTo(),
                "customerIP"        =>  Environment::myIPAddress(),
                "transactionSettings" => $this->_transactionSettings()
            ]
        ];
        
    }
    
    /**
     * We support authorize (do you have enough money for this transaction) and capture (actually do the debit) transactions
     * 
     * @param string $type
     * @return JSON
     */
    public function transaction($type='authorize') {
        switch (strtoupper($type)) {
            case "CAPTURE"  :
                $type = 'authCaptureTransaction';
                break;
            default         :
                //$type = 'authOnlyTransaction';
                $type = 'authCaptureTransaction';
                break;
        }
        return $this->_RPC(true)->setCreateTransactionRequest($this->filterTransaction($this->buildRequestTransaction($type)))->getCreditCardTransaction();
    }

    /**
     * Voids a transaction amount through our Authorize.net module
     * 
     * @return JSON
     */
    public function void() {
        return $this->_RPC(true)->setCreateTransactionRequest($this->filterTransaction($this->buildRequestTransaction('voidTransaction')))->getVoidedTransaction();
    }
    
    /**
     * Refunds a transaction amount through our Authorize.net module
     * 
     * @return JSON
     */
    public function refund() {
        return $this->_RPC(true)->setCreateTransactionRequest($this->filterTransaction($this->buildRequestTransaction('refundTransaction')))->getRefundedTransaction();
    }

    /**
     * Builds the recurring billing transaction data structure
     * @param string $type
     * @return array
     */
    protected function buildARBSubscriptionRequest($name) {
        return [
            "merchantAuthentication" => $this->_credentials(),
            "refId" => $this->getReferenceId(),
            "subscription" => [
                "name"            => $name,
                "paymentSchedule" => $this->_paymentSchedule(),
                "amount"          => $this->getAmount(),
                "payment"         => $this->_payment(),
                "billTo"          => $this->_billTo()
            ]
        ];
    }

    /**
     * Builds the recurring billing transaction data structure
     * @param string $type
     * @return array
     */
    protected function buildARBGetSubscriptionRequest() {
        return [
            "merchantAuthentication" => $this->_credentials(),
            "refId" => $this->getReferenceId(),
            "subscriptionId" => $this->getSubscriptionId()
        ];
    }    
    
    /**
     * Based on the field data in the passed event, will go to Authorize.net and set up recurring billing
     * 
     * @param event $EVENT
     */
    public function recurringBillingSubscription($name) {
        return $this->_RPC(true)->setARBCreateSubscriptionRequest($this->filterTransaction($this->buildARBSubscriptionRequest($name)))->getCreateBillingSubscription();
    }

    
    /**
     * Builds the recurring billing transaction data structure
     * 
     * @param string $name
     * @return array
     */
    protected function buildARBRequestTransaction($name) {
        return [
            "refId" => $this->getReferenceId(),
            "subscription" => [
                "name"            => $name,
                "paymentSchedule" => $this->_paymentSchedule(),
                "amount"          => $this->getAmount(),
                "trialAmount"     => $this->_trialAmount(),
                "payment"         => $this->_payment(),
                "billTo"          => $this->_billTo()
            ]
        ];
    }    
    
    /**
     * Will schedule a recurring billing schedule
     * 
     * @workflow use(process) configuration(/authorize/transaction/recurring)
     * @param type $EVENT
     */
    public function createSubscription($EVENT=false) {
        $source     = $EVENT->load();
        $cfg        = $EVENT->fetch();
        //$action     = $cfg['action'];
        $mode       = $cfg['mode'];
        $result     = 'billing_subscription';                                   //default result field in case one isn't set
        $event      = ['result' => 'Error'];                                    //define a default response incase things are FUBAR
        if (isset($source[$cfg['field']])) {
            $this->_mode($mode);
            $data   = $source[$cfg['field']];
            $result = (isset($cfg['result']) && $cfg['result']) ? $cfg['result'] : $result;
            $event['result'] = 'Unknown Error';  
            if ($response = $this->remove_utf8_bom(
                $this->setReferenceId($data['application-id'])
                    ->setCredentials($cfg['merchant_id'],$cfg['transaction_key'])
                    ->setBillTo($data['payment']['credit-card']['name']['first'],$data['payment']['credit-card']['name']['last'])
                    ->setAmount($data['payment']['charges']['recurring'])
                    ->setPayment($data['payment']['credit-card']['number'],$data['payment']['credit-card']['expiration']['year'].'-'.str_pad($data['payment']['credit-card']['expiration']['month'],2,'0',STR_PAD_LEFT))
                    ->setPaymentSchedule(['length' => '12', 'unit'=>'months'],$data['start-date'],'12','1')
                    ->recurringBillingSubscription('MP Subscription'))) {
                $response = json_decode($response,true); 
                $entry = Argus::getEntity('argus/online_applications')->setApplicationId($data['application-id']);
                $entry->load(true);
                $entry->setSubscriptionId((isset($response['subscriptionId']) ? $response['subscriptionId'] : null))->save();
                $event  = [
                    'subscribed'  => ((isset($response['messages'])) ? $response['messages']['resultCode'] : false),
                    'request'   => $this->getARBSubscriptionRequest(),
                    'result'    => $response
                ];                
            }
           $EVENT->update([$result=>$event],true);
        }
    }
    
    /**
     * This will check to see what kind of payment we are processing, and will return true if it is a credit card payment based transaction
     * 
     * @workflow use(decision) configuration(/authorize/transaction/paymenttype)
     * @param type $EVENT
     * @return boolean
     */
    public function isCreditCardPayment($EVENT=false) {
        $creditCardPayment = true;
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            
        }
        return $creditCardPayment;
    }
    
    /**
     * Performs a payment authorization request with Authorize.net.  Authorization only, no capture.
     * 
     * @workflow use(process) configuration(/authorize/transaction/authorization)
     * @param type $EVENT
     */
    public function authorization($EVENT=false) {
        $authorized = false;
        $data       = $EVENT->load();
        $cfg        = $EVENT->fetch();
        $mode       = 'test';
        $app        = $data[$cfg['field']];                                                             //Pull from the extract, not the raw data
        $event      = ['result' => 'Error'];                                                            //define a default
        $authCode   = '';
        if ($card       = isset($app['payment']['credit-card']) ? $app['payment']['credit-card'] : false) { 
            $mm         = str_pad($card['expiration']['month'],2,0,STR_PAD_LEFT);                       //we get passed a single digit for month, we need to make it two digits
            $yy         = substr($card['expiration']['year'],strlen($card['expiration']['year'])-2,2);  //we get passed a 4 digit year, we only need the last two digits
            $this->_refId(isset($app['refId']) && $app['refId'] ? $app['refId'] : '');
            $this->_mode($mode)->setCredentials($cfg['merchant_id'],$cfg['transaction_key'])->setBillTo($card['first-name'],$card['last-name'],'','','','','')->setPayment($card['number'],$mm.$yy,'123')->setLineItems('testapp','Insurance','Dental Insurance','1',$app['payment']['charges']['initial']);
            if (isset($app['addresses']['home']) && ($addr = $app['addresses']['home'])) {
                $this->setBillTo($card['first-name'],$card['last-name'],'',$addr['address1'],$addr['city'],$addr['state'],$addr['zip-code']);
            }
            $outcome = ['result'=>'Severe Error', 'authorizationCode'=>false, 'response'=>'', 'request'=>''];         //Set to worst case results
            if ($authorized = $this->remove_utf8_bom($this->transaction('AUTH'))) {
                $data = json_decode($authorized,true);                                                              //ok, we got a result, not a severe error now, but set default to unknown error
                $outcome['result'] = 'Unknown Error';                                     
                if (isset($data['transactionResponse']) && isset($data['transactionResponse']['responseCode'])) {
                    $authCode   = $data['transactionResponse']['authCode'];                                         //ok, getting better, we got a readable response, start setting event attributes to returned values
                    switch ($data['transactionResponse']['responseCode']) {
                        case    "1" :
                            $result = 'Approved';
                            break;
                        case    "2" : 
                            $result = 'Declined';
                            break;
                        case    "3" :
                            $result = 'Error';
                            break;
                        case    "4" :
                            $result = 'Held for Review';
                            break;
                        default     :
                            $result  = 'Error';
                            break;
                    }
                }
                $outcome  = [
                    'response'          => ((isset($data['transactionResponse'])) ? $data['transactionResponse'] : $authorized),
                    'authorizationCode' => $authCode,
                    'result'            => $result
                ];
            }
            $outcome = array_merge($outcome,
                [
                    'request'        => $this->getCreateTransactionRequest()
                ]);
        }
        $EVENT->update(['authorize'=>$outcome],true);
    }
    
    /**
     * Performs a call to authorize.net to see if there's enough money on the card or to actually debit the card depending on what is passed in
     * 
     * @workflow use(process) configuration(/authorize/transaction/authorization)
     * @return boolean
     */
    public function authorizePayment($EVENT=false) {
        $authorized = false;
        $data       = $EVENT->load();
        $cfg        = $EVENT->fetch();
        $action     = $cfg['action'];
        $authCode   = '';
        $mode       = 'Auth';
        $app        = $data[$cfg['field']];                                                             //Pull from the extract, not the raw data
        $event      = ['result' => 'Error'];                                                            //define a default
        if ($app_id     = $app['application-id']) {                                                     //we really only have this value to uniquely identify the transaction, so we use it everywhere we can
            $card       = $app['payment']['credit-card'];
            $mm         = str_pad($card['expiration']['month'],2,0,STR_PAD_LEFT);                       //we get passed a single digit for month, we need to make it two digits
            $yy         = substr($card['expiration']['year'],strlen($card['expiration']['year'])-2,2);  //we get passed a 4 digit year, we only need the last two digits
            $home       = $app['addresses']['home'];
            $bill       = $app['addresses']['billing'];
            $street     = ($home['address1'])   ? $home['address1'] : $bill['address1'];                //use credit card address if available, else use person address
            $city       = ($home['city'])       ? $home['city']     : $bill['city'];                    //use credit card address if available, else use person address
            $state      = ($home['state'])      ? $home['state']    : $bill['state'];                   //use credit card address if available, else use person address
            $zip        = (isset($home['zip-code']))   ? $home['zip-code'] : (isset($bill['zip-code']) ? $bill['zip-code'] : '');                     //use credit card address if available, else use person address
            $subscriber = $app['subscriber'];
            
            $this->_mode($mode)->setCredentials($cfg['merchant_id'],$cfg['transaction_key'])->setBillTo($subscriber['first-name'],$subscriber['last-name'],'',$street,$city,$state,$zip)->setPayment($card['number'],$mm.$yy,'123')->setLineItems($app_id,'Insurance','Dental Insurance','1',$app['payment']['charges']['initial'])->setUserFields('alderaId','')->setReferenceId($app_id)->setCustomer($app_id)->setPoNumber($app_id);
            $outcome = ['result'=>'Severe Error', 'application_id'=>'', 'authorizationCode'=>false, 'response'=>'', 'request'=>''];         //Set to worst case results
            if ($authorized = $this->remove_utf8_bom($this->transaction($action))) {
                $data = json_decode($authorized,true);                                                              //ok, we got a result, not a severe error now, but set default to unknown error
                $result = 'Unknown Error';                                     
                if (isset($data['transactionResponse']) && isset($data['transactionResponse']['responseCode'])) {
                    $authCode   = $data['transactionResponse']['authCode'];                                         //ok, getting better, we got a readable response, start setting event attributes to returned values
                    switch ($data['transactionResponse']['responseCode']) {
                        case    "1" :
                            $result = 'Approved';
                            break;
                        case    "2" : 
                            $result = 'Declined';
                            break;
                        case    "3" :
                            $result = 'Error';
                            break;
                        case    "4" :
                            $result = 'Held for Review';
                            break;
                        default     :
                            $result  = 'Error';
                            break;
                    }
                }
                $outcome  = [
                    'response'          => ((isset($data['transactionResponse'])) ? $data['transactionResponse'] : $authorized),
                    'authorizationCode' => $authCode,
                    'result'            => $result
                ];
                //$entry = Argus::getEntity('argus/online_apps')->setApplicationId($data['application-id']);
                //$entry->load(true);
                //$entry->setSubscriptionId($data['something'])->save();

            }
            $outcome = array_merge($outcome,
                [
                    'request'        => $this->getCreateTransactionRequest(),
                    'application_id' => $app_id,
                    'applicant'      => $subscriber['last-name'].', '.$subscriber['first-name']
                ]);
        }
        $EVENT->update(['authorize'=>$outcome],true);
    }
    
    /**
     * Based on the field data in the passed event, will go to Authorize.net and get subscription information
     * 
     * @param event $EVENT
     */
    public function BillingSubscription($name) {
        return $this->_RPC(true)->setARBGetSubscriptionRequest($this->buildARBGetSubscriptionRequest())->getBillingSubscription();
    }    
    
    
    /**
     * Builds the data structure that we need to send to Authorize.net to update a subscription with an Aldera member ID
     * 
     * @return array
     */
    protected function buildUpdateSubscriptionRequest() {
        return [
            "merchantAuthentication" => $this->_credentials(),
            "refId" => $this->_refId(),
            "subscriptionId" => $this->getSubscriptionId(),
            "subscription" => [
                "customer"        => $this->_customer()
            ]
        ];
    }
    
    /**
     * Provides the choreography of steps needed to invoke the RPC that actually updates the Authorize.net subscription
     * 
     * @return type
     */
    protected function updateBillingSubscription() {
        return $this->_RPC(true)->setARBUpdateSubscriptionRequest($this->filterTransaction($this->buildUpdateSubscriptionRequest()))->getUpdateBillingSubscription();
    }
    
    /**
     * Will update an Authorize.net user information with some custom data taken from the event and specified by the configuration
     * 
     * @workflow use(process) configuration(/authorize/transaction/updatesubscription)
     * @param event $EVENT
     */
    public function updateSubscription($EVENT=null) {
        if ($EVENT!==false) {
            $data       = $EVENT->load();
            $cfg        = $EVENT->fetch();
            $result     = isset($cfg['result']) ? $cfg['result'] : 'update_subscription_result';         //provides a default if it wasn't set            
            $extract    = (isset($cfg['appextract'])) ? $data[$cfg['appextract']] : ['application-id'=>false];  //This better be there
            $results    = json_encode(['status'=>'Error','message'=>'Did not have required information']);
            if (isset($data[$cfg['field']]) && isset($data[$cfg['subscription']])) {
                //print_r($data);
                $mem_data       = $data[$cfg['field']];
                $sub_data       = $data[$cfg['subscription']];
                $ref_id         = $extract['application-id'];
                $subscriptionId = $sub_data['result']['subscriptionId'];
                $memberId       = (isset($mem_data[0]['Aldera']->SubscriberAddResult->MemberID)) ? $mem_data[0]['Aldera']->SubscriberAddResult->MemberID : false;
                if ($memberId && $subscriptionId) {
                    $results = $this->remove_utf8_bom($this->setCredentials($cfg['merchant_id'],$cfg['transaction_key'])->setRefId($ref_id)->setSubscriptionId($subscriptionId)->_customer($memberId)->updateBillingSubscription());                 
                }
            }
            $EVENT->update([$result=>['request' => $this->getARBUpdateSubscriptionRequest(),'response'=>json_decode($results)]],true);
        }
    }
    
    /**
     * Returns true if the subscription was able to be created
     * 
     * @workflow use(decision) configuration(/authorize/transaction/subscribed)
     * @param object $EVENT
     * @return boolean
     */
    public function subscriptionCreated($EVENT=false) {
        $created = false;
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            if (isset($data[$cfg['field']])) {
                $data    = $data[$cfg['field']];
                $created = (isset($data['subscribed']) && ($data['subscribed'] == 'Ok'));
            }
        }
        return $created;
    }
    
    /**
     * Returns true if the subscription was actually updated by a previous step
     * 
     * @workflow use(decision) configuration(/authorize/transaction/updated)
     * @param object $EVENT
     * @return boolean
     */
    public function subscriptionUpdated($EVENT=false) {
        $updated = false;
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
            if (isset($cfg['field']) && $cfg['field'] && isset($data[$cfg['field']])) {
                $data    = $data[$cfg['field']]['response'];
                $updated = (isset($data->messages->resultCode) && ($data->messages->resultCode == 'Ok'));
            }
        }
        return $updated;
    }
    
    /**
     * Returns true if the payment was approved
     * 
     * @workflow use(decision)
     * @param object $EVENT
     * @return boolean
     */
    public function paymentApproved($EVENT=false) {
        $approved = false;
        if ($EVENT!==false) {
            $data     = $EVENT->load();
            $approved = (isset($data['authorize']) && isset($data['authorize']['result']) && ($data['authorize']['result'] == 'Approved'));
        }
        return $approved;
    }
    
    /**
     * Returns the results of the payment authorization attempt as a JSON string
     * 
     * @workflow use(process)
     * @param type $EVENT
     */
    public function echoPaymentAuthorizationResults($EVENT=false) {
        $results = [
            'RC' => 12,
            'message' => 'Unable to locate results from authorization attempt'
        ];
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $results = isset($data['authorize']['response']) ? $data['authorize']['response'] : $results;
        }
        print(json_encode($results));
    }
    
    /**
     * Returns true if the payment was approved
     * 
     * @workflow use(decision)
     * @param object $EVENT
     * @return boolean
     */
    public function paymentDeclined($EVENT=false) {
        $declined = false;
        if ($EVENT!==false) {
            $data     = $EVENT->load();
            $declined = (isset($data['authorize']) && isset($data['authorize']['result']) && ($data['authorize']['result'] == 'Declined'));
        }
        return $declined;
    }    
    
    /**
     * A transaction has been refunded
     * 
     * @workflow use(process) configuration(/authorize/transaction/refund)
     */
    public function refundTransaction() {
        $this->fire(
                'authorize',
                'transactionRefunded',
                [
                    
                ]);
    }
    
    /**
     * 
     * 
     * @workflow use(process) configuration(/authorize/transaction/void)
     */
    public function voidTransaction() {
       
        $this->fire(
                'authorize',
                'transactionVoided',
                [
                    
                ]);
    }

  
}