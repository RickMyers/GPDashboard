<!DOCTYPE html>
<html>

<head>

  <meta charset="UTF-8">

  <title>Argus | Register</title>
    <link rel="shortcut icon" href="/images/argus/favicon.png" />
    <link rel='stylesheet' type='text/css' href='/css/theme' />
    <style type='text/css'>

        .register-card {
          padding: 40px;
          width: 274px;
          background-color: #F7F7F7;
          border-radius: 2px 0px 0px 2px;
          box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
          overflow: hidden;
          display: inline-block;
        }

        .register-card h1 {
          font-weight: 100;
          text-align: center;
          font-size: 2.3em;
        }

        .register-card input[type=submit] {
          width: 100%;
          display: block;
          margin-bottom: 10px;
          position: relative;
        }

        .register-card input[type=text], input[type=password] {
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

        .register-card input[type=text]:hover, input[type=password]:hover {
          border: 1px solid #b9b9b9;
          border-top: 1px solid #a0a0a0;
          -moz-box-shadow: inset 0 1px 2px rgba(0,0,0,0.1);
          -webkit-box-shadow: inset 0 1px 2px rgba(0,0,0,0.1);
          box-shadow: inset 0 1px 2px rgba(0,0,0,0.1);
        }

        .register {
          text-align: center;
          font-size: 14px;
          font-family: 'Arial', sans-serif;
          font-weight: 700;
          height: 36px;
          padding: 0 8px;
        }

        .register-submit {
          /* border: 1px solid #3079ed; */
          border: 0px;
          color: #fff;
          text-shadow: 0 1px rgba(0,0,0,0.1);
          background-color: #4d90fe;
          /* background-image: -webkit-gradient(linear, 0 0, 0 100%,   from(#4d90fe), to(#4787ed)); */
        }

        .register-submit:hover {
          /* border: 1px solid #2f5bb7; */
          border: 0px;
          text-shadow: 0 1px rgba(0,0,0,0.3);
          background-color: #357ae8;
          /* background-image: -webkit-gradient(linear, 0 0, 0 100%,   from(#4d90fe), to(#357ae8)); */
        }

        .register-card a {
          text-decoration: none;
          color: #666;
          font-weight: 400;
          text-align: center;
          display: inline-block;
          opacity: 0.6;
          transition: opacity ease 0.5s;
        }

        .register-card a:hover {
          opacity: 1; 
        }

        .register-help {
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
            $('#slide').height($E('register-card').offsetHeight);
            $('#register-area').css('top',((Math.round($(window).height()/2) - Math.round($('#register-card').height()/2)-50)+'px')); 
            $('#register-area').css('left',((Math.round($(window).width()/2) - Math.round($('#register-area').width()/2))+'px')); 
        }
        window.onload = function () {
            new EasyEdits('/edits/argus/register','register-form');
            resizeWindow();
            window.setTimeout(rollSlides,slides.speed);
        }
        $(window).resize(function () {
            resizeWindow();
        });

        
    </script>

</head>

<body>
    <div id="register-area" style="width: 1280px; position: absolute; margin: 0px; padding: 0px">
        <div id='register-error' style='text-align: center; padding: 5px; width: 1280px; font-family: sans-serif; font-size: 1.1em; color: #c00; font-weight: bolder;'>
            Please fill in as much of the information as you can, with the amber background fields being required, and click "Register".
        </div>
        <div id='register-card' class="register-card" style="display: inline-block">
            <center>
                <img src='/images/argus/logo.png'  height='50' /><br /><br />
            </center>
            <form name='register-form' id='register-form' onsubmit='return false' action='/argus/user/register' method='POST'>
                <input placeholder="E-Mail" type="text" name='email' value="" id='email' /><br />
                <input placeholder="Password" autocomplete='off' type="password" name='password' id='password' /><br />
                <input placeholder="Confirm Password" type="password" name='confirm' id='confirm' /><br />
                <input placeholder="First Name" type="text" name='first_name' id='first_name' /><br />
                <input placeholder="Last Name" type="text" name='last_name' id='last_name' /><br />
                <input placeholder="Nick Name (If preferred)" type="text"  name='name' id='name' />
                <input type='button' class="register register-submit" name='register-submit' id='register-submit' value="Register" />
            </form>
        </div><div id="slide" style="position: relative; display: inline-block; width: 900px;   overflow: hidden; ">
            <img id='slide1' src='/images/argus/slide_1.jpg' style='position: absolute; top: 0px; left: 0px; height: 100%; box-shadow: 0 2px 2px rgba(0,0,0,0.3); border-radius: 0px 2px 2px 0px;'/>
            <img id='slide2' src='/images/argus/slide_2.jpg' style='display: none; position: absolute; top: 0px; left: 0px; height: 100%; box-shadow: 0 2px 2px rgba(0,0,0,0.3); border-radius: 0px 2px 2px 0px;'/>
            <img id='slide3' src='/images/argus/slide_3.jpg' style='display: none; height: 100%;  position: absolute; top: 0px; left: 0px; box-shadow: 0 2px 2px rgba(0,0,0,0.3); border-radius: 0px 2px 2px 0px;'/>
            <img id='slide4' src='/images/argus/slide_4.jpg' style='display: none; height: 100%;  position: absolute; top: 0px; left: 0px; box-shadow: 0 2px 2px rgba(0,0,0,0.3); border-radius: 0px 2px 2px 0px;'/>
            <img id='slide5' src='/images/argus/slide_5.jpg' style='display: none; height: 100%;  position: absolute; top: 0px; left: 0px; box-shadow: 0 2px 2px rgba(0,0,0,0.3); border-radius: 0px 2px 2px 0px;'/>
        </div>            
    </div>
    
    
    </body>
</html>
