<?php
namespace Code\Main\Argus\Models;
use Argus;
use Log;
use Environment;
/**    
 *
 * Argus Custom Notification Class
 *
 * In support of sending data via email, text, etc
 *
 * PHP version 7.0+
 *
 * @category   Logical Model
 * @package    Client
 * @author     Richard Myers <rmyers@argusdentalvision.com>
 * @copyright  2005-present Argus Dental and Vision
 * @since      File available since Release 1.0.0
 */
class Notification extends Model
{

    use \Code\Base\Humble\Event\Handler;
    /**
     * Constructor
     */
    public function __construct() {
        parent::__construct();
    }

    /**
     * All Classes are required to have this method
     *
     * @return system
     */
    public function getClassName() {
        return __CLASS__;
    }
    
    /**
     * Sends an email through the default send method of the platform
     *
     * @param mixed $to
     * @param string $subject
     * @param string $body
     * @return boolean
     */
    public function sendEmail($to=false,$subject=false,$body=false,$from=false,$reply=false,$attachment=false) {
        $settings = new \Settings();
        $from = ($from ? $from : 'webmaster@argusdentalvision.com');
        $reply = ($reply ? $reply : 'noreply@argusdentalvision.com');
        $mailer = new \PHPMailer;
        $mailer->isSMTP();
        $mailer->Host = $settings->getSmtpHost();
        $mailer->SMTPAuth = true;
//        $mailer->SMTPDebug = 2;
        $mailer->Username = $settings->getSmtpUserName();
        $mailer->Password = $settings->getSmtpPassword();
        $mailer->SMTPSecure = 'tls';
        $mailer->setFrom($from,'');
        if (strpos($to,';')) {
            foreach (explode(';',$to) as $address) {
                $mailer->addAddress($address);
            }
        } else {
            $mailer->addAddress($to);
        }
        if ($attachment) {
            if (is_array($attachment)) {
                $mailer->addStringAttachment($attachment['data'],$attachment['filename']);
            } else {
                if (file_exists($attachment)) {
                    $parts = explode('/',str_replace("\\","/",$attachment));
                    $mailer->addAttachment($attachment,$parts[count($parts)-1]);
                } else {
                    $mailer->addStringAttachment($attachment,'attachment.txt');
                }
            }
        }
        $mailer->Subject = $subject;
        $mailer->addReplyTo($reply);
        $mailer->isHTML(true);
        $mailer->Body = $body;
        if (!$mailer->send()) {
            \Log::error("Failed Sending Email: ".$mailer->ErrorInfo);
        }
        return $mailer->ErrorInfo;
    }

    /**
     * Custom email handler using the RAIN templating enging
     * 
     * @workflow use(notification) configuration(/argus/notification/rainemail)
     * @param type $EVENT
     * @return boolean
     */
    public function rainBasedEmail($EVENT=false) {
        $emailed = false;
        if ($EVENT!==false) {
            $data   = $EVENT->load();   //get the original event data, it should have information by now
            $cfg    = $EVENT->fetch();
            if (isset($cfg['email_template']) && isset($cfg['recipients']) && ($cfg['recipients'])) {
                @mkdir('tpl/cache',0775,true);
                $tpl = Environment::getInternalTemplater('tpl');
                $template_file = 'tpl/'.md5($cfg['email_template']).'.rain';
                file_put_contents($template_file,$cfg['email_template']);
                foreach ($data as $key => $value) {
                    $tpl->assign($key,$value);
                }
                $template = $tpl->draw(md5($cfg['email_template']),true);
                unlink($template_file);   
                $recipient = ($cfg['recipients_source']=='field') ? $data[trim($cfg['recipients'])] : $data['recipients'];
                $subject   = ($cfg['subject_source']=='field')    ? $data[trim($cfg['subject'])] : $data['subject'];
                $emailed   = Argus::getModel('argus/email')->sendEmail($recipient,$subject,$template,'noreply@argusdentalvision.com');
            }
        }
        return ($emailed !== false);
    }
    
    
    /**
     * Argus custom notification handler
     * 
     * @workflow use(notification) configuration(/argus/notification/email)
     * @param type $EVENT
     * @return boolean
     */
    public function email($EVENT=false) {
        $emailed = false;
        if ($EVENT!==false) {
            $data   = $EVENT->load();   //get the original event data, it should have information by now
            $cfg    = $EVENT->fetch();
            if (isset($cfg['email_template']) && isset($cfg['recipients']) && ($cfg['recipients'])) {
                $emailed = Argus::getModel('argus/email')->sendEmail($cfg['recipients'],$cfg['subject'],Argus::getHelper('paradigm/str')->translate($cfg['email_template'],$data),'noreply@argusdentalvision.com');
            }
        }
        return ($emailed !== false);
    }
    
    /**
     * Argus custom notification handler
     * 
     * @workflow use(notification) configuration(/argus/notification/eventemail)
     * @param type $EVENT
     * @return boolean
     */
    public function emailFromEvent($EVENT=false) {
        $emailed = false;
        if ($EVENT!==false) {
            $data   = $EVENT->load();   //get the original event data, it should have information by now
            $cfg    = $EVENT->fetch();
            $base   = ($cfg['event_node']) ? $data[$cfg['event_node']] : $data;
            if (isset($cfg['recipients']) && isset($cfg['subject'])) {
                $str = Argus::getHelper('paradigm/str');
                $body = $str->translate($base[$cfg['body']],$data);
                $body = $str->translate($body,$data);
                $emailed = $this->sendEmail($base[$cfg['recipients']],$base[$cfg['subject']],$body,false,false,isset($base[$cfg['attachment']]) && $base[$cfg['attachment']] ? $base[$cfg['attachment']] : false);
            }
        }
        return ($emailed !== false);
    }    
    
    /**
     * Argus custom notification handler
     * 
     * @workflow use(notification) configuration(/argus/notification/text)
     * @param type $EVENT
     * @return boolean
     */
    public function text($EVENT=false) {
        $texted = false;
        if ($EVENT!==false) {
            $data = $EVENT->load();
            $cfg  = $EVENT->fetch();
        }
        return $texted;
    }
    
    /**
     * Just writes a timestamp to a file for testing purposes
     * 
     * @workflow use(process)
     * @param type $EVENT
     */
    public function writeTimestamp($EVENT=false) {
        if ($EVENT!==false) {
            file_put_contents('last_triggered.txt',date('m/d/Y H:i:s'));
        }
    }
    
}