<!DOCTYPE html>
<html>

    <head>

      <meta charset="UTF-8">

      <title>Argus | New Password</title>
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

            .login-card input[type=text], input[type=password] {
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

            .new-password-submit {
              /* border: 1px solid #3079ed; */
              border: 0px;
              color: #fff;
              text-shadow: 0 1px rgba(0,0,0,0.1);
              background-color: #4d90fe;
              /* background-image: -webkit-gradient(linear, 0 0, 0 100%,   from(#4d90fe), to(#4787ed)); */
            }

            .new-password-submit:hover {
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
                new EasyEdits('/edits/argus/newpassword','newpassword');
                var loginMessage = window.location.href.split('?message=');
                if (loginMessage[1]) {
                    loginMessage[1] = decodeURI(loginMessage[1]);
                    $('#login-error').html(loginMessage[1]).substr(8).toString().replace('<', "&lt;").replace('>', "&gt;").replace("'", "&#39;").replace('"', "&#34;");
                }
                resizeWindow();
                window.setTimeout(rollSlides,slides.speed);
                window.setTimeout(function () {
                    alert("Hello!\n\nYou need to change your password. Please use the form on this page to set your new password.\n\nThe password must be at least 8 characters long and contain both letters and numbers.\n\nThank You!");
                },500);
            }
            $(window).resize(function () {
                resizeWindow();
            });
        </script>
    </head>

    <body>
        <div id="login-area" style="width: 980px; position: absolute; margin: 0px; padding: 0px">
            <div id='login-error' style='text-align: center; padding: 5px; width: 270px; font-family: sans-serif; font-size: 1.1em; color: #c00; font-weight: bolder;'>
                
            </div>
            <div style="background-color: #F7F7F7; padding: 10px 20px; font-size: 1.1em">
                <b>Password Rules</b>:<br /><br />
                Password must be at least 8 characters in length,  contain upper and lower case letters, at least one number, and one of the following special characters: (@#$%^&*()_)<br />
            </div>
            <div id='login-card' class="login-card" style="display: inline-block">
                <center>
                <img src='/images/argus/argus_logo.png' style="height: 62px"  /><br />
                </center>
                <div style="align: left; font-family: sans-serif; font-size: 18px; padding-top: 4px; padding-bottom: 8px; font-weight: bold; overflow: hidden">
                    {$user->getEmail()}
                </div>
                <form name='argus-new-password-form' id='argus-new-password-form' onsubmit='return false'  action='/argus/user/newpassword' method='POST'>
                    <input type="hidden"   name="token" id="token" value="{$token}" />
                    {if (isset($clearReset))}
                        <input type="hidden"   name="clearReset" id="clearReset" value="{$clearReset}" />
                    {/if}
                    <input type="hidden"   name="email" id="email" value="{$user->getEmail()}" />
                    <input type="password" name="confirm" id='confirm' placeholder="Password" autocomplete="off">
                    <input type="password" name="password" id='password' placeholder="Confirm Password" autocomplete="off">
                    <input type="submit"   name="new-password-submit" id='new-password-submit' class="login new-password-submit" value=" Update Password ">
                </form>
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