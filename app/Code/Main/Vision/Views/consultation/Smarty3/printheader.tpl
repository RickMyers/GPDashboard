
<!--
 /$$$$$$$  /$$$$$$$  /$$$$$$ /$$   /$$ /$$$$$$$$       /$$$$$$$$ /$$$$$$  /$$$$$$$  /$$      /$$
| $$__  $$| $$__  $$|_  $$_/| $$$ | $$|__  $$__/      | $$_____//$$__  $$| $$__  $$| $$$    /$$$
| $$  \ $$| $$  \ $$  | $$  | $$$$| $$   | $$         | $$     | $$  \ $$| $$  \ $$| $$$$  /$$$$
| $$$$$$$/| $$$$$$$/  | $$  | $$ $$ $$   | $$         | $$$$$  | $$  | $$| $$$$$$$/| $$ $$/$$ $$
| $$____/ | $$__  $$  | $$  | $$  $$$$   | $$         | $$__/  | $$  | $$| $$__  $$| $$  $$$| $$
| $$      | $$  \ $$  | $$  | $$\  $$$   | $$         | $$     | $$  | $$| $$  \ $$| $$\  $ | $$
| $$      | $$  | $$ /$$$$$$| $$ \  $$   | $$         | $$     |  $$$$$$/| $$  | $$| $$ \/  | $$
|__/      |__/  |__/|______/|__/  \__/   |__/         |__/      \______/ |__/  |__/|__/     |__/
-->
<!DOCTYPE html>
<html>
<head>
    <link rel='stylesheet' href='/css/bootstrap?cachebust='/>
    <link rel="stylesheet" href="/css/jqueryui?cachebust=" />
    <style type="text/css" media="screen, print">
        
        .block {
            display: inline-block; color: #000000
        }
        .field-block {
            white-space: nowrap; margin-right: 1px; margin-bottom: 1px; display: inline-block
        }
        .form-row {
            overflow: hidden; width: 100%; clear: both; white-space: nowrap
        }
        .form-field {
            background-color: #dfdfdf; border: 1px solid transparent; padding: 2px; border-radius: 3px; border-bottom-color: #999
        }
        .form-field:focus {
            background-color: lightcyan; border-bottom-color: #000000
        }
        .diagnosis_codes_header {
            text-align: center; font-weight: bolder; text-decoration: underline
        }
        .diagnosis_codes_cell {
            overflow: hidden;
        }
        
        .thelabel {

        }
        
        .secondlabel {
           font-weight: normal !important;
           font-size: 14px;
        }
        
        .clickedboxer {
            background-color: #ffff00 !important;
            display: inline;
        }
        .makeinvisible {
            visibility: visible;
        }
        .makevisible{
            visibility: visible;
        }
        </style>        
        <script type="text/javascript" src='/js/jquery?cachebust='></script>
        <script type='text/javascript' src='/js/bootstrap?cachebust='></script>
        <script type='text/javascript' src='/js/common?cachebust='></script>
        <script type='text/javascript' src='/js/print?cachebust='></script>
        <script type='text/javascript' src='/js/widgets?cachebust='></script>
        <script type='text/javascript'>
            {assign var=tab_id value=$manager->browserTabId()}
            EasyAjax.always.add('browser_tab_id','{$tab_id}')
            EasyAjax.always.add('csrf_buster','{$manager->csrfBuster($tab_id)}');
            EasyAjax.always.add('session_user_id','{$user->getUid()}');
        </script>
    </head>
    <body style="overflow: hidden">
    <div id="vision-form-tab">
