<style type="text/css">
	.zoomSlider		{ background-color: lightcyan; border: 1px solid #aaf; -moz-border-radius: 3px }
        .zoomPointer    { height: 20px }
        .zoomStop       { font-weight: bold; font-family: tahoma, sans-serif; font-size: 8pt }
</style>
<!--div style="width: 480px; height: 40px; margin-top: 10px; margin-left: auto; margin-right: auto;" id="whiteboardImageAnalyzerSlider"> </div-->

<style type='text/css'>
    #spriteContainerShadow_analyzer {
        position: absolute; left: 50%; margin-left: -250px; border-radius: 4px; height: 45px; bottom: 25px; opacity: .5; width: 500px; background-color: #bbb
    }
    #whiteboardImageAnalyzer {
        height: 100%; margin: 0px auto
    }
    #whiteboardImageAnalyzerSlider {
        position: absolute; left: 50%; margin-left: -200px; height: 38px; bottom: 20px; width: 400px;
    }
</style>
<img id='whiteboardImageAnalyzer' onselectstart="return false" ondragstart="return false" style="margin-left: auto; margin-right: auto" src="http://www.cloud-it.com/users/13/favorites/photos/4139069089_0bd3dc2637.jpg" />
<div id='spriteContainerShadow_analyzer' >&nbsp;</div>
<div id='whiteboardImageAnalyzerSlider'></div>
<script type='text/javascript'>
    Desktop.window.list['cloud-it-analyzer'].content.style.overflow = 'hidden';
    if (!$E('whiteboardImageAnalyzer').fadeIn) {
        (EasyEffect('whiteboardImageAnalyzer')).dragAndDrop();
    }
    sliderControl.init();
    var slider = new Slider('whiteboardImageAnalyzerSlider',400,12,"analyzerSlider");
    slider.addStop("zs100","100%").addStop("zs200","200%").setInclusive(true).addStop("zs300","300%").addStop("zs400","400%").addStop("zs500","500%").addStop("zs600","600%").addStop("zs700","700%").addStop("zs800","800%").setStopText("'").setMaxScale(800);
    slider.setInclusive(true).setSlideClass("zoomSlider").addPointer("zrs_arrow","/images/whiteboard/clipart/slider.png",'','zoomPointer');
    slider.setLabelClass('zoomStop');
    slider.setOnSlide(function (slider,slide,fromleft) {
        var img = $E('whiteboardImageAnalyzer');
        img.style.height = (+Sliders[slide.id].getValue()+100)+"%";
        if ((+img.offsetLeft + img.offsetWidth < 0) || (+img.offsetTop + img.offsetHeight < 0)) {
            img.style.top = "0px";
            img.style.left = "0px";
        }
    });
    slider.render();
   $E('whiteboardImageAnalyzerSlider').style.position = 'absolute';
</script>