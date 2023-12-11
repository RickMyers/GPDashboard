<!DOCTYPE html>
<html>

<head>

  <meta charset="UTF-8">

  <title>Argus | Log-in</title>
    <link rel="shortcut icon" href="/images/argus/favicon.png" />
    <link rel='stylesheet' type='text/css' href='/css/theme' />
    <style type='text/css'>
        .create-password-card {
          padding: 40px;
          width: 274px;
          background-color: #F7F7F7;
          border-radius: 2px 0px 0px 2px;
          box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
          overflow: hidden;
          display: inline-block;
        }
        .create-password-card h1 {
          font-weight: 100;
          text-align: center;
          font-size: 2.3em;
        }
        .create-password-card input[type=submit] {
          width: 100%;
          display: block;
          margin-bottom: 10px;
          position: relative;
        }
        .create-password-card input[type=text], input[type=password] {
          height: 44px;
          font-size: 16px;
          width: 100%;
          margin-bottom: 10px;
          -webkit-appearance: none;
          background: #fff;
          border: 1px solid #d9d9d9;
          border-top: 1px solid #c0c0c0;
          padding: 0 8px;
          box-sizing: border-box;
          -moz-box-sizing: border-box;
        }
        .create-password-card input[type=text]:hover, input[type=password]:hover {
          border: 1px solid #b9b9b9;
          border-top: 1px solid #a0a0a0;
          -moz-box-shadow: inset 0 1px 2px rgba(0,0,0,0.1);
          -webkit-box-shadow: inset 0 1px 2px rgba(0,0,0,0.1);
          box-shadow: inset 0 1px 2px rgba(0,0,0,0.1);
        }
        .login {
          text-align: center;
          font-size: 14px;
          font-family: 'Arial', sans-serif;
          font-weight: 700;
          height: 36px;
          padding: 0 8px;
        }

        .create-password-submit {
          border: 0px;
          color: #fff;
          text-shadow: 0 1px rgba(0,0,0,0.1);
          background-color: #4d90fe;
        }
        .create-password-submit:hover {
          border: 0px;
          text-shadow: 0 1px rgba(0,0,0,0.3);
          background-color: #357ae8;
        }
        .create-password-card a {
          text-decoration: none;
          color: #666;
          font-weight: 400;
          text-align: center;
          display: inline-block;
          opacity: 0.6;
          transition: opacity ease 0.5s;
        }
        .create-password-card a:hover {
          opacity: 1; 
        }
        .create-password-help {
          width: 100%;
          text-align: center;
          font-size: 12px;
        }
        #slide {
            box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
        }
    </style>
    <script type='text/javascript' src='/js/jquery'></script>
    <script type='text/javascript' src='/js/common'></script>
    <script type='text/javascript'>
        var winTmr = null;
        var slides = {
            current: 1,
            max: 5,
            speed: 10000
        };
        function rollSlides() {
            var cs = '#slide'+slides.current;
            slides.current = +slides.current + 1;
            if (slides.current > slides.max) {
                slides.current = 1;
            }
            var ns = '#slide'+slides.current;
            $(cs).fadeOut();
            $(ns).fadeIn();
            window.setTimeout(rollSlides,slides.speed);
        }
        function resizeWindow() {
            $('#slide').height($E('create-password-card').offsetHeight);
            $('#create-password-area').css('top',((Math.round($(window).height()/2) - Math.round($('#create-password-card').height()/2)-50)+'px')); 
            $('#create-password-area').css('left',((Math.round($(window).width()/2) - Math.round($('#create-password-area').width()/2))+'px')); 
        }
        window.onload = function () {
            var parts = window.location.href.split('token=');
            if (!parts[1]) { 
                window.location.href = '/index.html?m=Invalid Password Create Attempt';
            }
            $('#token').val(parts[1]);
            if (window.location.href.indexOf('esb.') !== -1) {
                $E('site_logo').src = '/images/esb/esb.png';
            } else if (window.location.href.indexOf('ushc.') !== -1) {
                $E('site_logo').src = '/images/vision/ushc_banner.png'
            } else if (window.location.href.indexOf('argus') !== -1) {
                $E('site_logo').src = '/images/argus/logo.png';
            } else if (window.location.href.indexOf('excedis') !== -1) {
                $E('site_logo').src = '/images/hedis/excedis_blue.png';
            }
            new EasyEdits('/web/edits/createpassword.json','create-password');
            $E('create-password-error').innerHTML = "Welcome! Please create your new password below";
            resizeWindow();
            window.setTimeout(rollSlides,slides.speed);
        }
        $(window).resize(function () {
            resizeWindow();
        });
    </script>
</head>
<body>
    <div id="create-password-area" style="width: 980px; position: absolute; margin: 0px; padding: 0px">
        <div id='create-password-error' style='text-align: center; padding: 5px; font-family: sans-serif; font-size: 1.1em; color: #c00; font-weight: bolder;'>
            &nbsp;
        </div>
        <div id='create-password-card' class="create-password-card" style="display: inline-block">
            <center>
            <img id='site_logo' src=''  height='100' alt='logo' /><br /><br />
            </center>
            <form name='create-password-form' id='create-password-form' onsubmit='return false'  action='/argus/user/setfirstpassword' method='POST'>
                <input type="hidden" name="token" id='token' value="">
                <input type="password" name="user_password" id='user_password' placeholder="Password">
                <input type="password" name="confirm_password" id='confirm_password' placeholder="Confirm Password">
                <input type="submit" name="create-password-submit" id='create-password-submit' class="login create-password-submit" value="Create Password">
            </form>
            <div class="create-password-help">
              • <a href="mailto:support@aflacbenefitssolutions.com" onclick='' style='color: #990000'>Support Request</a> •
            </div>
        </div><div id="slide" style="position: relative; display: inline-block; width: 626px;   overflow: hidden; ">
            <img id='slide1' src='/images/argus/slide_1.jpg' style='position: absolute; top: 0px; left: 0px; height: 100%; box-shadow: 0 2px 2px rgba(0,0,0,0.3); border-radius: 0px 2px 2px 0px;'/>
            <img id='slide2' src='/images/argus/slide_2.jpg' style='display: none; position: absolute; top: 0px; left: 0px; height: 100%; box-shadow: 0 2px 2px rgba(0,0,0,0.3); border-radius: 0px 2px 2px 0px;'/>
            <img id='slide3' src='/images/argus/slide_3.jpg' style='display: none; height: 100%;  position: absolute; top: 0px; left: 0px; box-shadow: 0 2px 2px rgba(0,0,0,0.3); border-radius: 0px 2px 2px 0px;'/>
            <img id='slide4' src='/images/argus/slide_4.jpg' style='display: none; height: 100%;  position: absolute; top: 0px; left: 0px; box-shadow: 0 2px 2px rgba(0,0,0,0.3); border-radius: 0px 2px 2px 0px;'/>
            <img id='slide5' src='/images/argus/slide_5.jpg' style='display: none; height: 100%;  position: absolute; top: 0px; left: 0px; box-shadow: 0 2px 2px rgba(0,0,0,0.3); border-radius: 0px 2px 2px 0px;'/>
        </div>            
    </div>
</body>
</html>