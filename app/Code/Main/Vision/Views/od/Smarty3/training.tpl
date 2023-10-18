<video id="training_webinar" width="320" height="240" controls autoplay>
  <source src="/app/training.php?video=webinar" type="video/mp4">
Your browser does not support the video tag.
</video>
<script type="text/javascript">
    (function () {
        var win = Desktop.whoami('training_webinar',true);
        win.resize = (function (win) {
            return function () {
                $('#training_webinar').width(win.content.width()).height(win.content.height());
            }
        })(win);
    })();
</script>
