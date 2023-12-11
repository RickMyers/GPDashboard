<!DOCTYPE html>
<html>

<head>

  <meta charset="UTF-8">

  <title> Argus | Log-in</title>
    <link rel="shortcut icon" href="/favicon.ico" />
    <link rel='stylesheet' type='text/css' href='/css/theme' />
    <style type='text/css'>

        .login-card {
          padding: 40px;
          width: 274px;
          background-color: #F7F7F7;
          border-radius: 2px 0px 0px 2px;
          box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
          overflow: hidden;
          display: inline-block;
        }

        .login-card h1 {
          font-weight: 100;
          text-align: center;
          font-size: 2.3em;
        }

        .login-card input[type=submit] {
          width: 100%;
          display: block;
          margin-bottom: 10px;
          position: relative;
        }

        .login-card input[type=text], input[type=password], select {
          height: 44px;
          font-size: 16px;
          width: 100%;
          margin-bottom: 10px;
          -webkit-appearance: none;
          background: #fff;
          border: 1px solid #d9d9d9;
          border-top: 1px solid #c0c0c0;
          /* border-radius: 2px; */
          padding: 0 8px;
          box-sizing: border-box;
          -moz-box-sizing: border-box;
        }

        .login-card input[type=text]:hover, input[type=password]:hover {
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

        .login-submit {
          /* border: 1px solid #3079ed; */
          border: 0px;
          color: #fff;
          text-shadow: 0 1px rgba(0,0,0,0.1);
          background-color: #4d90fe;
          /* background-image: -webkit-gradient(linear, 0 0, 0 100%,   from(#4d90fe), to(#4787ed)); */
        }

        .login-submit:hover {
          /* border: 1px solid #2f5bb7; */
          border: 0px;
          text-shadow: 0 1px rgba(0,0,0,0.3);
          background-color: #357ae8;
          /* background-image: -webkit-gradient(linear, 0 0, 0 100%,   from(#4d90fe), to(#357ae8)); */
        }

        .login-card a {
          text-decoration: none;
          color: #666;
          font-weight: 400;
          text-align: center;
          display: inline-block;
          opacity: 0.6;
          transition: opacity ease 0.5s;
        }

        .login-card a:hover {
          opacity: 1; 
        }

        .login-help {
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
            $('#slide').height($E('login-card').offsetHeight);
            $('#login-area').css('top',((Math.round($(window).height()/2) - Math.round($('#login-card').height()/2)-50)+'px')); 
            $('#login-area').css('left',((Math.round($(window).width()/2) - Math.round($('#login-area').width()/2))+'px')); 
        }
        window.onload = function () {
            new EasyEdits('/edits/dashboard/ipalogin','login');
            var loginMessage = window.location.href.split('?');
            if (loginMessage[1]) {
                var parts = loginMessage[1].split('&');
                var message = decodeURI(parts[0]).split('=');
                var next_page  = '/index.html';
                if (parts[1]) {
                    parts = parts[1].split('=');
                    next_page = parts[1];
                }
                $('#login-error').html(message[1].toString().replace('<', "&lt;").replace('>', "&gt;").replace("'", "&#39;").replace('"', "&#34;"));   
                $('#next_page').val(next_page);
            }
            resizeWindow();
            window.setTimeout(rollSlides,slides.speed);
        }
        $(window).resize(function () {
            resizeWindow();
        });

        
    </script>

</head>

<body>
    <div style="float: right; margin-right: 10px; font-size: 1.2em; color: #dd0000; font-weight: bolder">
        Questions?  Please call 877-710-5174 during business hours
    </div>
    <div id="login-area" style="width: 980px; position: absolute; margin: 0px; padding: 0px">
        <div id='login-error' style='text-align: center; padding: 5px; font-family: sans-serif; font-size: 1.1em; color: #c00; font-weight: bolder;'>
            &nbsp;
        </div>
        <div id='login-card' class="login-card" style="display: inline-block">
            <center>
            <img style="height: 62px; position: relative; " src="/images/dashboard/aflac_logo.png" />
            <!--img id='site_logo' src=''  height='100' alt='logo' /--><br /><br />
            </center>
            <form name='excedis-login-form' id='excedis-login-form' onsubmit='return false'  action='/dashboard/ipa/authenticate' method='POST'>
              <select name="ipa_id" id='ipa_id'>
                  <option value="">Select IPA</option>
                  {foreach from=$ipas->fetch() item=ipa}
                      <option value="{$ipa.id}">{$ipa.ipa}</option>
                  {/foreach}
              </select>
              <select name="location_id" id='location_id' >
                  <option value="">Select Location (Optional)</option>
              </select> <i></i>
              <input type="password" name="user_password" id='user_password' placeholder="Password"  autocomplete="off">
              <input type='hidden' name='then' id='next_page' value='' />
              <input type="submit" name="login-submit" id='login-submit' class="login login-submit" value="login">
            </form>
            <div class="login-help">
              <a href="mailto:support@aflacbenefitssolutions.com" onclick='' style='color: #990000'>Support Request</a> • <a href="/argus/user/recoverForm">Forgot Password</a>
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