<?php
namespace Code\Main\Argus\Models;
use Argus;
use Log;
use Environment;
/**
 *
 * Emailing Component
 *
 * see short description
 *
 * PHP version 7.2+
 *
 * @category   Logical Model
 * @package    Other
 * @author     Aaron Binder <abinder@argusdentalvision.com>
 * @copyright  2005-present Argus Dashboard
 * @license    https://humbleprogramming.com/license.txt
 * @version    <INSERT VERSIONING MECHANISM HERE />
 * @link       https://humbleprogramming.com/docs/class-Email.html
 * @since      File available since Release 1.0.0
 */
class Email extends Model
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
     * Sends an email through the default send method of the platform
     *
     * @param mixed $to
     * @param string $subject
     * @param string $body
     * @return boolean
     */ 
    public function sendEmail($to=false,$subject=false,$body=false,$from=false,$reply=false,$attachment=false) {
        $settings = \Environment::settings();
        $from = ($from ? $from : 'noreply@argusdentalvision.com');
        $reply = ($reply ? $reply : 'noreply@argusdentalvision.com');
        $mailer = new \PHPMailer;
        $mailer->isSMTP();
        $mailer->Host = $settings->getSmtpHost();
        $mailer->SMTPAuth = true;
        //$mailer->SMTPDebug = 4;
        $mailer->Username = $settings->getSmtpUserName();
        $mailer->Password = $settings->getSmtpPassword();
        $mailer->SMTPSecure = 'tls';
        $mailer->setFrom($from,'');
        $mailer->addAddress($to);
        $mailer->Subject = $subject;
        $mailer->addReplyTo($reply);
        $mailer->isHTML(true);
        $mailer->Body = $body;
        if (!$result = $mailer->send()) {
            \Log::error("Failed Sending Email: ".$mailer->ErrorInfo);
        }        
        return $result;
    }
    
}