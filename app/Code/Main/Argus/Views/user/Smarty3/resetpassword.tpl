<!DOCTYPE html>
<html>

    <head>

      <meta charset="UTF-8">

      <title>Argus | New Password</title>
        <link rel="shortcut icon" href="/images/argus/favicon.png" />
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
            /* border-radius: 3px; */
            /* -webkit-user-select: none;
              user-select: none; */
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
        </style>
        <script type='text/javascript' src='/js/jquery'></script>
        <script type='text/javascript' src='/js/common'></script>
        <script type='text/javascript'>
            var winTmr = null;
            
            function resizeWindow() {
                $('#login-area').css('top',((Math.round($(window).height()/2) - Math.round($('#login-card').height()/2)-50)+'px')); 
                $('#login-area').css('left',((Math.round($(window).width()/2) - Math.round($('#login-area').width()/2))+'px')); 
            }
            $(window).ready(function () {
                new EasyEdits('/edits/argus/newpassword','newpassword');
                var loginMessage = window.location.href.split('?message=');
                if (loginMessage[1]) {
                    $('#login-error').html(decodeURI(loginMessage[1]).substr(8).toString().replace('<', "&lt;").replace('>', "&gt;").replace("'", "&#39;").replace('"', "&#34;"));   
                }
                resizeWindow();
                alert('Hello!\n\nThis is either your first time logging in or your password needs to be update. \n\nPlease take a moment and set your new password here');
            });
            $(window).resize(function () {
                resizeWindow();
            });
        </script>
    </head>

    <body>
        <div id="login-area" style="width: 980px; position: absolute; margin: 0px; padding: 0px">
            <div id='login-error' style='text-align: center; padding: 5px; width: 270px; font-family: sans-serif; font-size: 1.1em; color: #c00; font-weight: bolder;'>
                
            </div>
            <div id='login-card' class="login-card" style="display: inline-block">
                <center>
                <img src='/images/argus/logo.png'  /><br />
                </center>
                <div style="align: left; font-family: sans-serif; font-size: 18px; padding-top: 4px; padding-bottom: 8px; font-weight: bold; overflow: hidden">
                    {$user->getEmail()}
                </div>
                <form name='argus-new-password-form' id='argus-new-password-form' onsubmit='return false'  action='/argus/user/newpassword' method='POST'>
                    <input type="hidden"   name="email" id="email" value="{$user->getEmail()}" />
                    <input type="password" name="confirm" id='confirm' placeholder="Password" autocomplete="off">
                    <input type="password" name="password" id='password' placeholder="Confirm Password" autocomplete="off">
                    <input type="submit"   name="new-password-submit" id='new-password-submit' class="login new-password-submit" value=" Update Password ">
                </form>
            </div><div id="boxofinfo" style="position: relative; display: inline-block; width: 626px;   overflow: hidden; ">
                <p>The password should be 8 characters long, and should include: \ln-1 uppercase character \ln-1 lowercase character \ln-1 numeric character \ln-1 special character</p>
            </div>            
        </div>
    </body>

</html>