<video id="tech_training_webinar" width="320" height="240" controls autoplay>
  <source src="/app/training.php?video=tech_training" type="video/mp4">
Your browser does not support the video tag.
</video>
<script type="text/javascript">
    (function () {
        var win = Desktop.whoami('tech_training_webinar',true);
        win.resize = (function (win) {
            return function () {
                $('#tech_training_webinar').width(win.content.width()).height(win.content.height());
            }
        })(win);
    })();
</script>
