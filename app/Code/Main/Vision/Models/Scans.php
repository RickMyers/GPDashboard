<?php
namespace Code\Main\Vision\Models;
use Argus;
use Log;
use Environment;
/**
 * 
 * Vision related functions and methods
 *
 * Some helper methods to support vision related activities
 *
 * PHP version 7.0+
 *
 * @category   Utility
 * @package    Other
 * @author     Richard Myers rmyers@argusdentalvision.com
 * @since      File available since Release 1.0.0
 */
class Scans extends Model
{
    
    use \Code\Base\Humble\Event\Handler;
    
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
     * 
     * @param array $scans
     * @return array
     */
    public function preProcessUploadedScans($scans) {
        $processed = [];
        foreach ($scans as $scan) {
            if ($scan && isset($scan['path'])) {
                $seq = substr($scan['name'],2,4);
                if (!isset($processed[$seq])) {
                    $processed[$seq] = [];
                }
                $processed[$seq][] = $scan;
            }
        }
        return $processed;
    }

    /**
     * Given a particular status, sum up the number of screening/scanning forms with that status and attach the total to the event in a given field
     * 
     * @workflow use(process) configuration(/vision/forms/statuscount)
     * @param type $EVENT
     */
    public function countStatus($EVENT=false) {
        if ($EVENT!==false) {
            $data  = $EVENT->load(); 
            $cfg   = $EVENT->fetch();
            if (isset($cfg['status']) && isset($cfg['field'])) {
                $forms = Argus::getEntity('vision/consultation/forms')->setStatus($cfg['status'])->fetch();
                $EVENT->update([$cfg['field'] => count($forms)]);
            }
        }
    }
    
    /**
     * Will emit an event if there are screening forms waiting for review 
     * 
     * @workflow use(process,event)
     * @param type $EVENT
     */
    public function notifyOnSubmittedForms($EVENT=false) {
        if ($EVENT!==false) {
            $data  = $EVENT->load(); 
            $total = count($forms);
            $od    = [];
            foreach (Argus::getEntity('vision/consultation/forms')->setStatus('S')->fetch() as $form) {
                if (isset($form['reviewer']) && $form['reviewer']) {
                    $od[$form[$reviewer]] = isset($od[$form[$reviewer]]) ? $od[$form[$reviewer]]+1 : 1;
                }
            }
            if ($total) {
                $this->trigger('screeningFormsAvailable',__CLASS,['screening_forms'=>$total]);
            }
        }
    }
    
    /**
     * If a retina scan was uploaded, attaches it to the vision form.  NOW SUPPORTS MULTIPLE FILE UPLOADS, but s unique event is fired per image
     * 
     * @workflow use(EVENT);
     */
    public function attachRetinaScan() {
        $uid        = $this->getUid();
        $form_id    = $this->getFormId();
        $scans      = [];
        $scan       = $this->getScan();
        $ctr = 0;
        if (isset($scan['name']) && !is_array($scan['name'])) {
            $scans[] = [
                'name' => $scan['name'],
                'path' => $scan['path']
            ];
        } else {
            foreach ($scan['name'] as $val) {
                $scans[$ctr] = ['name'=>$val,'path'=>''] ;
                $ctr++;
            }
            $ctr = 0;
            foreach ($scan['path'] as $val) {
                $scans[$ctr]['path'] = $val;
                $ctr++;
            }
        }
        $scansets = $this->preProcessUploadedScans($scans);
        foreach ($scansets as $scans) {
            foreach ($scans as $scan) {
                $root   = '../../Scans/forms/'.$form_id;
                $image  = Argus::getHelper('argus/image');
                @mkdir($root,0775,true);
                @mkdir($root.'/tn',0775,true);
                $scans  = Argus::getEntity('vision/retina_scans');
                $id     = $scans->setFormId($form_id)->setFileName($scan['name'])->setAddedBy($uid)->save();
                $img    = $root.'/'.$id.'.jpg';
                $tn     = $root.'/tn/'.$id.'.jpg';
                @copy($scan['path'],$img);
                $image->setImage($img);
                $image->generateThumbnail($tn);
                $this->trigger('retinaScanAttached',
                    __CLASS__,
                    __METHOD__,
                    [
                        'added_by' => $uid,
                        'form_id'  => $form_id,
                        'scan_id'  => $id,
                        'filename' => $scan['name']
                    ]);
            }
        }
    }    
    
    /**
     * If a retina scan was uploaded, attaches it to the vision form.  Images have been base 64 encoded
     * 
     * @workflow use(EVENT);
     */
    public function attachEncryptedRetinaScans() {
        $uid        = $this->getUid();
        $form_id    = $this->getFormId();
        $scans      = $this->getScans();
        $ctr        = 0;
        $sms        = [];
        foreach ($scans as $name => $scan) {
            $root   = '../../Scans/forms/'.$form_id;
            $image  = Argus::getHelper('argus/image');
            @mkdir($root,0775,true);
            @mkdir($root.'/tn',0775,true);
            $s_orm  = Argus::getEntity('vision/retina/scans');
            $id     = $s_orm->setFormId($form_id)->setFileName($scan['source'])->setAddedBy($uid)->save();
            $img    = $root.'/'.$id.'.jpg';
            $tn     = $root.'/tn/'.$id.'.jpg';
            file_put_contents($img,base64_decode($scan['converted']));
            $image->setImage($img);
            $image->generateThumbnail($tn);
            $sms[] = [
                    'added_by' => $uid,
                    'form_id'  => $form_id,
                    'scan_id'  => $id,
                    "filename" => $scan['source']
                ];
        }
        if (count($sms)) {
            $this->trigger('retinaScansAttached',
                __CLASS__,
                __METHOD__,
                $sms
            );
        }
        

    }    

}