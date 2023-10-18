<style type="text/css">
	.zoomSlider	{ background-color: lightcyan; border: 1px solid #aaf; -moz-border-radius: 3px }
        .zoomPointer    { height: 20px }
        .zoomStop       { font-weight: bold; font-family: tahoma, sans-serif; font-size: 8pt }
        .spriteContainerShadow_analyzer {
            position: absolute; left: 50%; margin-left: -250px; border-radius: 4px; height: 45px; bottom: 25px; opacity: .5; width: 500px; background-color: #bbb
        }
        #whiteboardImageAnalyzer-{$window_id} {
            height: 100%; margin: 0px auto
        }
        .whiteboardImageAnalyzerSlider {
            position: absolute; left: 50%; margin-left: -200px; height: 38px; bottom: 20px; width: 400px;
        }
</style>
<div id='retina-scan-header-{$window_id}' style='height: 25px; background-color: rgba(50,50,50,.4); position: relative; z-index: 999'>
    <table style='width: 100%'>
        <tr>
            <td align='center'><span class='shadowButton'>Form</span></td>
            <td align='center'>
                <a href="#" style='font-size: 1.1em; font-weight: bold; color: blue' onclick="$E('whiteboardImageAnalyzer-{$window_id}').src='/images/vision/scans/scan029.jpg'; return false">Image 1</a>
            </td>
            <td align='center'>
                <a href="#"  style='font-size: 1.1em; font-weight: bold; color: blue' onclick="$E('whiteboardImageAnalyzer-{$window_id}').src='/images/vision/scans/scan034.jpg';  return false">Image 2</a>
            </td>
        </tr>
    </table>
</div>
<div id='retina-scan-body-{$window_id}' style='height: 25px; position: relative;'>
    <img id='whiteboardImageAnalyzer-{$window_id}' onselectstart="return false" src='/images/vision/scans/scan034.jpg' ondragstart="return false" style="position: absolute; top: 0px; left: 0px; margin-left: auto; margin-right: auto"  />
    <div id='spriteContainerShadow_analyzer' >&nbsp;</div>
    <div class='whiteboardImageAnalyzerSlider' id='scan-{$window_id}'></div>
</div>
<div id='retina-scan-footer-{$window_id}' style='height: 25px; background-color: rgba(50,50,50,.4); position: relative; z-index: 999'>
</div>

<script type='text/javascript'>
    (function () {
        var win = Desktop.window.list['{$window_id}'];
        win.resize = (function () {
            return function () {
                $('#retina-scan-body-{$window_id}').height(win.content.offsetHeight - ($E('retina-scan-header-{$window_id}').offsetHeight + $E('retina-scan-footer-{$window_id}').offsetHeight) );
        }
        })();
        if (!$E('whiteboardImageAnalyzer-{$window_id}').fadeIn) {
            (EasyEffect('whiteboardImageAnalyzer-{$window_id}')).dragAndDrop();
        }

        sliderControl.init();
        var slider = new Slider('scan-{$window_id}',400,12,"analyzerSlider-{$window_id}");
        slider.addStop("zs100-{$window_id}","100%").addStop("zs200-{$window_id}","200%").setInclusive(true).addStop("zs300-{$window_id}","300%").addStop("zs400-{$window_id}","400%").addStop("zs500-{$window_id}","500%").addStop("zs600-{$window_id}","600%").addStop("zs700-{$window_id}","700%").addStop("zs800-{$window_id}","800%").setStopText("'").setMaxScale(800);
        slider.setInclusive(true).setSlideClass("zoomSlider").addPointer("zrs_arrow-{$window_id}","/images/vision/slider.png",'','zoomPointer');
        slider.setLabelClass('zoomStop');
        slider.setOnSlide(function (slider,slide,fromleft) {
            var img = $E('whiteboardImageAnalyzer-{$window_id}');
            img.style.height = (+Sliders[slide.id].getValue()+100)+"%";
            if ((+img.offsetLeft + img.offsetWidth < 0) || (+img.offsetTop + img.offsetHeight < 0)) {
                img.style.top = "0px";
                img.style.left = "0px";
            }
        });
       slider.render();
       $E('scan-{$window_id}').style.position = 'absolute';
    })();
</script>