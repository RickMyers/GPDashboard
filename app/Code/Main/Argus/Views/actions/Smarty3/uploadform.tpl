<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>HTML5 Template</title>
        <meta name="description" content="">
        <meta name="author" content="Argus Dental and Vision">

        <meta property="og:title" content="add title">
        <meta property="og:type" content="website">
        <meta property="og:url" content="https://hedis.argusdentalvision.com/">
        <meta property="og:description" content="add description">
        <!--meta property="og:image" content="image.png"-->

        <link rel="icon" href="/favicon.ico">
        <link rel="icon" href="/favicon.svg" type="image/svg+xml">
        <!--link rel="apple-touch-icon" href="/apple-touch-icon.png"-->

        <link rel="stylesheet" type="text/css" href="/css/bootstrap">
        <link rel="stylesheet" type="text/css" href="/css/common">
        <script src="/js/jquery"></script>
        <script src="/js/common"></script>
        <script type="text/javascript">
            function shipTheFiles(files) {
                let fp = { };
                for (let i in files) {
                    fp[files[i].source] = files[i].converted;
                }
                (new EasyAjax('/vision/scans/send')).add('files',JSON.stringify(fp)).then(function (response) {
                    console.log(response);
                }).post();
            }
            let fileInput       = false;
            let files           = false;
            $(window).ready(function() {
                fileInput   = document.getElementById('upload_file');
                document.getElementById('upload_button').addEventListener('click', async(event) =>  {
                    files = fileInput.files;
                    let fp = { }
                    for (let i in files){ 
                        if (files[i].lastModified) {
                            fp[i] = {
                                reader: new FileReader(),
                                source: files[i].name,
                                converted: false
                            }
                        }
                    }
                    for (i in fp) {
               //         console.log(files[i]);
                        fp[i].reader.readAsBinaryString(files[i]);
                        fp[i].reader.onload = (function (num) {
                                                //num num closure
                                                return function (event) {
                                                    fp[num].converted = btoa(event.target.result);
                                                    let isDone = true;
                                                    for (let j in fp) {
                                                        isDone = isDone && fp[j].converted;
                                                    }
                                                    if (isDone) {
                                                        shipTheFiles(fp);
                                                    }
                                                };
                            
                        })(i);
                    }
                });
                //i have to do a promise... once all files have been converted, time to send them to the server
            });
        </script>
    </head>

    <body>
        <br /><br />
        <form name="sample_upload_form" id="sample_upload_form" onsubmit="return false">
            <input type="file" id="upload_file" multiple="true" name="upload_file" /><input type="button" id="upload_button" value=" Upload " />
        </form>
    </body>
</html>
