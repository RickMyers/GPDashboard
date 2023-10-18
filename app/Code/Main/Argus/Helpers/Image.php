<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

namespace Code\Main\Argus\Helpers;

class Image extends Helper
{
    private $image          = null;
    private $imageHeight    = 0;
    private $imageWidth     = 0;
    private $extension      = '';

    public function __construct() {
        parent::__construct();
    }

    //--------------------------------------------------------------------------
    //
    //--------------------------------------------------------------------------
    public function getClassName()
    {
        return __CLASS__;
    }

    //--------------------------------------------------------------------------------------------------
    // Resizes to a new height
    //--------------------------------------------------------------------------------------------------
    public function resize($newH=1248) {
        if ($this->image) {
            $newH = (is_numeric($newH)) ? $newH : 1248;
            if ($this->imageHeight && $newH) {
                if ($this->imageHeight > $newH) {
                    $ratio 				= $newH / $this->imageHeight;
                    $newW 				= floor($this->imageWidth * $ratio);
                    $tmp_img			= imagecreatetruecolor($newW,$newH);
                    imagecopyresampled($tmp_img,$this->image,0,0,0,0,$newW,$newH,$this->imageWidth,$this->imageHeight);
                    $this->image 		= $tmp_img;
                    $this->imageWidth 	= imageSX($this->image);
                    $this->imageHeight 	= imageSY($this->image);
                }
            }
        }
    }

    //--------------------------------------------------------------------------------------------------
    // flip on horizontal axis
    //--------------------------------------------------------------------------------------------------
    public function crop($startX,$startY,$endX,$endY) {
        if ($this->image) {
            $canvas             = imagecreatetruecolor($endX-$startX, $endY-$startY);
            imagecopy($canvas,$this->image,0,0,$startX,$startY,$endX,$endY);
            $this->image        = $canvas;
            $this->imageWidth 	= imageSX($this->image);
            $this->imageHeight 	= imageSY($this->image);
        }
    }

    //--------------------------------------------------------------------------------------------------
    // flip on horizontal axis
    //--------------------------------------------------------------------------------------------------
    public function flip() {
        if ($this->image) {

        }
    }

    //--------------------------------------------------------------------------------------------------
    // flip on vertical axis
    //--------------------------------------------------------------------------------------------------
    public function mirror() {
        if ($this->image) {

        }
    }

    //--------------------------------------------------------------------------------------------------
    //
    //--------------------------------------------------------------------------------------------------
    public function rotate($degrees) {
        if ($this->image) {
            $this->image	= imagerotate($this->image, $degrees, 0);
        }
    }

    //--------------------------------------------------------------------------------------------------
    //
    //--------------------------------------------------------------------------------------------------
    public function generateThumbnail($output,$type='jpg',$newH=250) {
        if ($this->image) {
            $ratio 				= $newH / $this->imageHeight;
            $newW 				= $this->imageWidth * $ratio;
            $tmp_img			= ImageCreateTrueColor($newW,$newH);
            imagecopyresampled($tmp_img,$this->image,0,0,0,0,$newW,$newH,$this->imageWidth,$this->imageHeight);
            switch ($type) {
                case "jpg"  :   
                case "jpeg" :   imagejpeg($tmp_img,$output);
                                break;
                case "bmp"  :   image2wbmp($tmp_img,$output);
                                break;
                case "png"  :   imagepng($tmp_img,$output);
                                break;
                case "gif"  :   imagegif($tmp_img,$output);
                                break;
                default     :   break;
            }
        }
    }

    //--------------------------------------------------------------------------------------------------
    //
    //--------------------------------------------------------------------------------------------------
    public function writePNG($file=false) {
        $didit = false;
        if ($this->image && $file) {
            $didit = imagepng($this->image,$file);
        }
        return $didit;
    }

    //--------------------------------------------------------------------------------------------------
    //
    //--------------------------------------------------------------------------------------------------
    public function writeJPG($file=false) {
        $didit = false;
        if ($this->image && $file) {
            $didit = imagejpeg($this->image,$file);
        }
        return $didit;
    }

    //--------------------------------------------------------------------------------------------------
    //
    //--------------------------------------------------------------------------------------------------
    public function writeGIF($file=false) {
        $didit = false;
        if ($this->image && $file) {
            $didit = imagegif($this->image,$file);
        }
        return $didit;
    }

    //--------------------------------------------------------------------------------------------------
    //
    //--------------------------------------------------------------------------------------------------
    public function write($file=false) {
        //based on file extension, write out image
    }

    //--------------------------------------------------------------------------------------------------
    // Getters/Setters
    //--------------------------------------------------------------------------------------------------
    public function setImage($arg=false) {
        if ($arg) {
            $this->setLocation($arg);
            $this->image        = imagecreatefromstring($imageSource = file_get_contents($arg));
            $p = explode('.',$arg);
            $this->extension    = $p[count($p)-1];
            $this->imageWidth 	= imageSX($this->image);
            $this->imageHeight 	= imageSY($this->image);
            return $imageSource;
        }

    }

    /* --------------------------------- */
    public function fetch($arg=false) {
        if ($arg) {
            return $this->setImage($arg);
        }
    }

    /* --------------------------------- */
    public function setSource($arg=false) {
        $this->image = null;
        if ($arg) {
            $this->image        = @imagecreatefromstring($arg);
            if ($this->image) {
                $this->imageWidth 	= imageSX($this->image);
                $this->imageHeight 	= imageSY($this->image);
            }
        }
        return ($this->image !== null);
    }

    /*
     * From http://www.programmierer-forum.de/function-imagecreatefrombmp-laeuft-mit-allen-bitraten-t143137.htm
     */
    public function convertFromBMPToJPG($filename) {
        // version 1.00
        if (!($fh = fopen($filename, 'rb'))) {
            trigger_error('imagecreatefrombmp: Can not open ' . $filename, E_USER_WARNING);
            return false;
        }
        // read file header
        $meta = unpack('vtype/Vfilesize/Vreserved/Voffset', fread($fh, 14));
        // check for bitmap
        if ($meta['type'] != 19778) {
            trigger_error('imagecreatefrombmp: ' . $filename . ' is not a bitmap!', E_USER_WARNING);
            return false;
        }
        // read image header
        $meta += unpack('Vheadersize/Vwidth/Vheight/vplanes/vbits/Vcompression/Vimagesize/Vxres/Vyres/Vcolors/Vimportant', fread($fh, 40));
        // read additional 16bit header
        if ($meta['bits'] == 16) {
            $meta += unpack('VrMask/VgMask/VbMask', fread($fh, 12));
        }
        // set bytes and padding
        $meta['bytes'] = $meta['bits'] / 8;
        $meta['decal'] = 4 - (4 * (($meta['width'] * $meta['bytes'] / 4)- floor($meta['width'] * $meta['bytes'] / 4)));
        if ($meta['decal'] == 4) {
            $meta['decal'] = 0;
        }
        // obtain imagesize
        if ($meta['imagesize'] < 1) {
            $meta['imagesize'] = $meta['filesize'] - $meta['offset'];
            // in rare cases filesize is equal to offset so we need to read physical size
            if ($meta['imagesize'] < 1) {
                $meta['imagesize'] = @filesize($filename) - $meta['offset'];
                if ($meta['imagesize'] < 1) {
                    trigger_error('imagecreatefrombmp: Can not obtain filesize of ' . $filename . '!', E_USER_WARNING);
                    return false;
                }
            }
        }
        // calculate colors
        $meta['colors'] = !$meta['colors'] ? pow(2, $meta['bits']) : $meta['colors'];
        // read color palette
        $palette = array();
        if ($meta['bits'] < 16) {
            $palette = unpack('l' . $meta['colors'], fread($fh, $meta['colors'] * 4));
            // in rare cases the color value is signed
            if ($palette[1] < 0) {
                foreach ($palette as $i => $color) {
                    $palette[$i] = $color + 16777216;
                }
            }
        }
        // create gd image
        $im = imagecreatetruecolor($meta['width'], $meta['height']);
        $data = fread($fh, $meta['imagesize']);
        $p = 0;
        $vide = chr(0);
        $y = $meta['height'] - 1;
        $error = 'imagecreatefrombmp: ' . $filename . ' has not enough data!';
        // loop through the image data beginning with the lower left corner
        while ($y >= 0) {
            $x = 0;
            while ($x < $meta['width']) {
                switch ($meta['bits']) {
                    case 32:
                    case 24:
                        if (!($part = substr($data, $p, 3))) {
                            trigger_error($error, E_USER_WARNING);
                            return $im;
                        }
                        $color = unpack('V', $part . $vide);
                        break;
                    case 16:
                        if (!($part = substr($data, $p, 2))) {
                            trigger_error($error, E_USER_WARNING);
                            return $im;
                        }
                        $color = unpack('v', $part);
                        $color[1] = (($color[1] & 0xf800) >> 8) * 65536 + (($color[1] & 0x07e0) >> 3) * 256 + (($color[1] & 0x001f) << 3);
                        break;
                    case 8:
                        $color = unpack('n', $vide . substr($data, $p, 1));
                        $color[1] = $palette[ $color[1] + 1 ];
                        break;
                    case 4:
                        $color = unpack('n', $vide . substr($data, floor($p), 1));
                        $color[1] = ($p * 2) % 2 == 0 ? $color[1] >> 4 : $color[1] & 0x0F;
                        $color[1] = $palette[ $color[1] + 1 ];
                        break;
                    case 1:
                        $color = unpack('n', $vide . substr($data, floor($p), 1));
                        switch (($p * 8) % 8) {
                            case 0:
                                $color[1] = $color[1] >> 7;
                                break;
                            case 1:
                                $color[1] = ($color[1] & 0x40) >> 6;
                                break;
                            case 2:
                                $color[1] = ($color[1] & 0x20) >> 5;
                                break;
                            case 3:
                                $color[1] = ($color[1] & 0x10) >> 4;
                                break;
                            case 4:
                                $color[1] = ($color[1] & 0x8) >> 3;
                                break;
                            case 5:
                                $color[1] = ($color[1] & 0x4) >> 2;
                                break;
                            case 6:
                                $color[1] = ($color[1] & 0x2) >> 1;
                                break;
                            case 7:
                                $color[1] = ($color[1] & 0x1);
                                break;
                        }
                        $color[1] = $palette[ $color[1] + 1 ];
                        break;
                    default:
                        trigger_error('imagecreatefrombmp: ' . $filename . ' has ' . $meta['bits'] . ' bits and this is not supported!', E_USER_WARNING);
                        return false;
                }
                imagesetpixel($im, $x, $y, $color[1]);
                $x++;
                $p += $meta['bytes'];
            }
            $y--;
            $p += $meta['decal'];
        }
        fclose($fh);
        if ($filename) {
            imagejpeg($im,$filename);
        }
        return ;
    }

    public function getImage()          {   return $this->image;                }
    public function getImageHeight()    {   return $this->imageHeight;          }
    public function getImageWidth()     {   return $this->imageWidth;           }
    public function getImageExtension() {   return $this->extension;            }

}
?>