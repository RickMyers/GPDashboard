var EasyEffects = [];
function EasyEffectsManager(objId)
{
	var obj = EasyEffects[objId];
	switch (obj.currentEffect)
	{
		case "transitionIn"		:	obj.fadeIn();
									break;
		case "transitionOut"	:	obj.fadeOut();
									break;
		case "slideLeft"		:	obj.slideLeft();
									break;
		case "slideRight"		:	obj.slideRight();
									break;
		case "slideUp"			:	obj.slideUp();
									break;
		case "slideDown"		:	obj.slideDown();
									break;
	    case "scrollUp"			:	obj.scrollUp();
									break;
	    case "scrollDown"		:	obj.scrollDown();
									break;
	    case "scrollRight"		:	obj.scrollToRight();
									break;
	    case "scrollLeft"		:	obj.scrollToLeft();
									break;
		case "shake"			:	obj.shake();
									break;
		case "spiralIn"			:	obj.spiralIn();
									break;
		case "spiralOut"		:	obj.spiralOut();
									break;
        case "expand"           :   obj.expand();
                                    break;
		default					:
									break;
	}
}
function EasyEffect(obj)
{
    var original = obj;
	if (typeof(obj)=="string")
		obj = document.getElementById(obj);
	if (!obj) {
		console.log("Effects: Couldn't resolve object - "+original);
		return null;
	}
	obj.enhanceId				= Math.random();
	EasyEffects[obj.enhanceId] 	= obj;
	obj.transition				= false;
	obj.sliding					= false;
	obj.timer					= null;
	obj.currentEffect 			= null;
	obj.currentOpacity 			= 0;
	obj.nextFunc 				= null;
	obj.slideIncrement			= 5
	obj.fadeSpeed				= 50;
	obj.slideSpeed				= 30;
	obj.scrollSpeed				= 70;
    obj.expandSpeed             = 60;
    obj.expandIncrement         = 5;
    obj.expandTo                = false;
	obj.scrollAmount			= 5;
	obj.scrollRepeat			= false;
	obj.fadedIn					= true;
	obj.shakeStartX				= 0;
	obj.shakeStartY				= 0;
    obj.slideToX                = 0;
    obj.slideToY                = 0;
	obj.shakeIt					= 60;
	obj.shakeCtr				= obj.shakeIt;
	obj.shakeSpeed				= 35;
	obj.shakeX					= 30;
	obj.shakeY					= 0;
	obj.shakeDirection			= 1;
    obj.dragNegative            = false;
	obj.DX						= 0;
	obj.DY						= 0;
	if (!window.addEventListener)
	{
		//obj.style.filter = "progid:DXImageTransform.Microsoft.Alpha(Opacity=100);";
	}
	/* -------------------------------------- */
	obj.set						= function (ao)
	{
		obj.innerHTML = ao.getResponse();
		ao.executeJavascript();
		return obj;
	}
	/* -------------------------------------- */
	obj.center					= function ()
	{
		obj.style.left = Math.floor((obj.offsetParent.offsetWidth - obj.offsetWidth)/2) + "px"
		return obj;
	}
	/* -------------------------------------- */
	obj.fadeIn 					= function (doAfter)
	{
		if (typeof(doAfter)!="function") doAfter= null;
		if (doAfter)
			obj.nextFunc = doAfter;
		if (obj.timer)
			window.clearTimeout(obj.timer);
		if (obj.currentEffect != "transitionIn"){
			if (!window.addEventListener)
				obj.style.filter ="progid:DXImageTransform.Microsoft.Alpha(opacity=100)";
			if (window.addEventListener) {
				obj.style.opacity = 0;
            } else {
				obj.filters.item("DXImageTransform.Microsoft.Alpha").Opacity= 0;
			}
			if (obj.style.display != "block")
				obj.style.display = "block"
			if (obj.style.visibility != "visible")
				obj.style.visibility = "visible";
		}
		obj.currentEffect = "transitionIn";
		if (!obj.transition) {
			obj.transition = true;
			if (window.addEventListener){
				obj.style.opacity = 0;
            } else {
				obj.filters.item("DXImageTransform.Microsoft.Alpha").Opacity= 0;
			}
			obj.currentOpacity = 0;
			obj.style.visibility = "visible";
		}
		if (obj.currentOpacity <1.0) {
			obj.currentOpacity += 0.1;
			if (window.addEventListener) {
				obj.style.opacity = obj.currentOpacity
			} else {
				obj.filters.item("DXImageTransform.Microsoft.Alpha").Opacity= obj.currentOpacity*100;
			}
			obj.timer = window.setTimeout("EasyEffectsManager('"+ obj.enhanceId +"')",obj.fadeSpeed);
		} else {
			obj.transition = false;
			obj.currentEffect = null;
			if (window.addEventListener) {
				obj.style.opacity = 1;
            } else {
				obj.filters.item("DXImageTransform.Microsoft.Alpha").Opacity= 100;
            }
			obj.fadedIn = true;
			obj.fadedOut = false;
			if (obj.nextFunc) {
				obj.nextFunc();
            }
			obj.nextFunc = null;
		}
		return obj;
	}
    /* -------------------------------------- */
    obj.setEvent = function (eventName,handler) {
        if (window.addEventListener) {
            eventName = (eventName == 'mousewheel') ? "DOMMouseScroll" : eventName; 
            obj.addEventListener(eventName,handler,false);
        } else {
            obj.attachEvent('on'+eventName,handler);
        }
    }
	/* -------------------------------------- */
	obj.fadeOut 	= function (doAfter)
	{
		if (typeof(doAfter)!="function") doAfter= null;
		if (doAfter)
			obj.nextFunc = doAfter;
		if (obj.currentEffect != "transitionOut")
		{
			if (!window.addEventListener)
				obj.style.filter ="progid:DXImageTransform.Microsoft.Alpha(opacity=100)";
			if (obj.style.display != "block")
				obj.style.display = "block"
			if (obj.style.visibility != "visible")
				obj.style.visibility = "visible";
		}
		obj.currentEffect = "transitionOut";
		if (!obj.transition)
		{
			obj.transition = true;
			if (window.addEventListener)
				obj.style.opacity = 1;
			else
				obj.filters.item("DXImageTransform.Microsoft.Alpha").Opacity= 0;
			obj.currentOpacity = 1;
		}
		if (obj.currentOpacity >0.0)
		{
			obj.currentOpacity -= 0.1;
			if (window.addEventListener)
				obj.style.opacity = obj.currentOpacity;
			else
				obj.filters.item("DXImageTransform.Microsoft.Alpha").Opacity= obj.currentOpacity*100;
			obj.timer = window.setTimeout("EasyEffectsManager('"+ obj.enhanceId +"')",obj.fadeSpeed);
		}
		else
		{
			obj.transition = false;
			obj.currentEffect = null;
			if (window.addEventListener)
				obj.style.opacity = 0;
			else
				obj.filters.item("DXImageTransform.Microsoft.Alpha").Opacity= 0;
			obj.fadedIn = false;
			obj.fadedOut = true;
			//obj.style.visibility = "hidden";
			if (obj.nextFunc)
				obj.nextFunc();
			obj.nextFunc = null;
		}
		return obj;
	}
    /* -------------------------------------- */
    obj.expand      = function (doAfter) {
		if (typeof(doAfter)!="function") doAfter= null;
		if (!obj.style.position)
			obj.style.position = "relative";
		if (doAfter)
			obj.nextFunc = doAfter;
		if ((obj.offsetHeight < (obj.expandTo ? obj.expandTo : obj.scrollHeight)))
		{
			obj.currentEffect = "expand";
			obj.style.height = (obj.offsetHeight + obj.expandIncrement) + "px";
			obj.timer = window.setTimeout("EasyEffectsManager('"+ obj.enhanceId +"')",obj.expandSpeed);
		}
		else
		{
			obj.currentEffect = null;
			if (obj.nextFunc)
				obj.nextFunc();
			obj.nextFunc = null;
		}
		return obj;
    }
    /* -------------------------------------- */
    obj.contract    = function (doAfter) {
		if (typeof(doAfter)!="function") doAfter= null;
		if (!obj.style.position)
			obj.style.position = "relative";
		if (doAfter)
			obj.nextFunc = doAfter;
		if ((obj.offsetHeight > 0))
		{
			obj.currentEffect = "contract";
			obj.style.height = (obj.offsetHeight - obj.expandIncrement) + "px";
			obj.timer = window.setTimeout("EasyEffectsManager('"+ obj.enhanceId +"')",obj.expandSpeed);
		}
		else
		{
			obj.currentEffect = null;
			if (obj.nextFunc)
				obj.nextFunc();
			obj.nextFunc = null;
		}
		return obj;
    }
    /* -------------------------------------- */
    obj.slideTo      = function (doAfter) {
		if (typeof(doAfter)!="function") doAfter= null;
		if (!obj.style.position)
			obj.style.position = "relative";
		if (doAfter)
			obj.nextFunc = doAfter;
		if ((obj.offsetLeft + obj.offsetWidth) > 0)
		{
			obj.currentEffect = "slideLeft";
			obj.style.left = (obj.offsetLeft - obj.slideIncrement) + "px";
			obj.timer = window.setTimeout("EasyEffectsManager('"+ obj.enhanceId +"')",obj.slideSpeed);
		}
		else
		{
			obj.currentEffect = null;
			if (obj.nextFunc)
				obj.nextFunc();
			obj.nextFunc = null;
		}
		return obj;
    }
	/* -------------------------------------- */
	obj.slideLeft 	= function (doAfter)
	{
		if (typeof(doAfter)!="function") doAfter= null;
		if (!obj.style.position)
			obj.style.position = "absolute";
		if (doAfter)
			obj.nextFunc = doAfter;
		if ((obj.offsetLeft + obj.offsetWidth) > 0)
		{
			obj.currentEffect = "slideLeft";
			obj.style.left = (obj.offsetLeft - obj.slideIncrement) + "px";
			obj.timer = window.setTimeout("EasyEffectsManager('"+ obj.enhanceId +"')",obj.slideSpeed);
		}
		else
		{
			obj.currentEffect = null;
			if (obj.nextFunc)
				obj.nextFunc();
			obj.nextFunc = null;
		}
		return obj;
	}
	/* -------------------------------------- */
	obj.slideUp		= function (doAfter)
	{
		if (typeof(doAfter)!="function") doAfter= null;
		if (!obj.style.position)
			obj.style.position = "absolute";
		if (doAfter)
			obj.nextFunc = doAfter;
		if ((obj.offsetTop + obj.offsetHeight > 0))
		{
			obj.currentEffect = "slideUp";
			obj.style.top = (obj.offsetTop - obj.slideIncrement) + "px";
			obj.timer = window.setTimeout("EasyEffectsManager('"+ obj.enhanceId +"')",obj.slideSpeed);
		}
		else
		{
			obj.currentEffect = null;
			if (obj.nextFunc)
				obj.nextFunc();
			obj.nextFunc = null;
		}
		return obj;
	}
	/* -------------------------------------- */
	obj.slideRight	= function (doAfter)
	{
		if (typeof(doAfter)!="function") doAfter= null;
		if (!obj.style.position)
			obj.style.position = "relative";
		if (doAfter)
			obj.nextFunc = doAfter;
		if ((obj.offsetLeft < 0))
		{
			obj.currentEffect = "slideRight";
			obj.style.left = (obj.offsetLeft + obj.slideIncrement) + "px";
			obj.timer = window.setTimeout("EasyEffectsManager('"+ obj.enhanceId +"')",obj.slideSpeed);
		}
		else
		{
			obj.currentEffect = null;
			if (obj.nextFunc)
				obj.nextFunc();
			obj.nextFunc = null;
		}
		return obj;
	}
	/* -------------------------------------- */
	obj.slideDown	= function (doAfter)
	{
		if (typeof(doAfter)!="function") doAfter = null;
		if (obj.currentEffect != "slideDown")
		{
			if (!obj.style.position)
				obj.style.position = "absolute";
			if ((!obj.style.visibility == "visible") || (!obj.style.visibility))
				obj.style.visibility = "visible";
			if ((!obj.style.display == "block") || (!obj.style.display))
				obj.style.display = "block";
		}

		if (doAfter)
			obj.nextFunc = doAfter;
		//if (obj.currentEffect != "slideDown")
			//obj.style.top = (-1 * obj.offsetHeight) +"px";
		if (obj.timer)
			window.clearTimeout(obj.timer);
		if ((obj.offsetTop < 0))
		{
			obj.currentEffect = "slideDown";
			if (obj.parentNode.offsetHeight < ((obj.offsetHeight + obj.offsetTop + (obj.slideIncrement+5))))
				obj.parentNode.style.height = (obj.offsetHeight + obj.offsetTop + (obj.slideIncrement+5))+"px"
			obj.style.top = (obj.offsetTop + obj.slideIncrement) + "px";
			obj.timer = window.setTimeout("EasyEffectsManager('"+ obj.enhanceId +"')",obj.slideSpeed);
		}
		else
		{
			obj.currentEffect = null;
			if (obj.nextFunc)
				obj.nextFunc();
			obj.nextFunc = null;
		}
		return obj;
	}
	/* -------------------------------------- */
	obj.dragAndDrop	= function (goNeg)
	{
        obj.dragNegative = (goNeg) ? true : false;
		obj.style.position = "relative";
		obj.onmousedown = obj.dragStart;
	}
	obj.dragStart	= function (evt)
	{
		evt = (evt) ? evt : ((window.event) ? event : null);
		document.body.style.cursor = "move";

		obj.DX	= evt.clientX - obj.offsetLeft;
		obj.DY	= evt.clientY - obj.offsetTop;
		document.onmousemove = obj.mouseMove;
		document.onmouseup	= obj.mouseUp;
		return false;
	}
	obj.mouseMove	= function (evt)
	{
		evt = (evt) ? evt : ((window.event) ? event : null);
		var nX = evt.clientX - obj.DX;
		var nY = evt.clientY - obj.DY
        obj.style.left = nX + 'px';
        obj.style.top  = nY + 'px';
		//obj.style.left	= ((!obj.dragNegative && (nX > 0)) ? nX : 0)+"px";
		//obj.style.top	= ((!obj.dragNegative && (nY > 0)) ? nY : 0)+"px";
		return false;
	}
	obj.mouseUp		= function (evt)
	{
		evt = (evt) ? evt : ((window.event) ? event : null);
		document.body.style.cursor = "";
		document.onmousemove = null;
		document.onmouseup	= null;
		return false;
	}
	/* -------------------------------------- */
	obj.scrollUp	= function (doAfter)
	{
		if (!obj.style.position)
			obj.style.position = "relative";
		if (doAfter)
			obj.nextFunc = doAfter;
		if (obj.currentEffect != "scrollUp")
		{
			obj.style.top = ((obj.parentNode.offsetHeight) ? obj.parentNode.offsetHeight : screen.availHeight) + "px";
		}
		if ((obj.offsetTop + obj.offsetHeight > 0))
		{
			obj.currentEffect = "scrollUp";
			obj.style.top = (obj.offsetTop - obj.scrollAmount) + "px";
			obj.timer = window.setTimeout("EasyEffectsManager('"+ obj.enhanceId +"')",obj.scrollSpeed);
		}
		else
		{
			if (obj.scrollRepeat)
			{
				obj.style.top = ((obj.parentNode.offsetHeight) ? obj.parentNode.offsetHeight : screen.availHeight) + "px";
				obj.timer = window.setTimeout("EasyEffectsManager('"+ obj.enhanceId +"')",obj.scrollSpeed);
			}
			else
			{
				obj.currentEffect = null;
				if (obj.nextFunc)
					obj.nextFunc();
				obj.nextFunc = null;
			}
		}
		return obj;
	}
	/* -------------------------------------- */
	obj.scrollDown	= function (doAfter)
	{
		if (!obj.style.position)
			obj.style.position = "absolute";
		if (doAfter)
			obj.nextFunc = doAfter;
		if (obj.currentEffect != "scrollDown")
		{
			obj.style.top = (obj.offsetHeight * -1) +"px";
		}
		if ((obj.offsetTop) < ((obj.parentNode.offsetHeight) ? obj.parentNode.offsetHeight : screen.availHeight) )
		{
			obj.currentEffect = "scrollDown";
			obj.style.top = (obj.offsetTop + obj.scrollAmount) + "px";
			obj.timer = window.setTimeout("EasyEffectsManager('"+ obj.enhanceId +"')",obj.scrollSpeed);
		}
		else
		{
			if (obj.scrollRepeat)
			{
				obj.style.top = (obj.offsetHeight * -1) +"px";
				obj.timer = window.setTimeout("EasyEffectsManager('"+ obj.enhanceId +"')",obj.scrollSpeed);
			}
			else
			{
				obj.currentEffect = null;
				if (obj.nextFunc)
					obj.nextFunc();
				obj.nextFunc = null;
			}
		}
		return obj;
	}
	/* -------------------------------------- */
	obj.scrollToRight	= function (doAfter)
	{
		if (!obj.style.position)
			obj.style.position = "absolute";
		if (doAfter)
			obj.nextFunc = doAfter;
		if (obj.currentEffect != "scrollRight")
		{
			obj.style.left = (obj.offsetWidth * -1) +"px";
		}
		if ((obj.offsetLeft) < ((obj.parentNode.offsetWidth) ? obj.parentNode.offsetWidth : screen.availWidth) )
		{
			obj.currentEffect = "scrollRight";
			obj.style.left = (obj.offsetLeft + 5) + "px";
			obj.timer = window.setTimeout("EasyEffectsManager('"+ obj.enhanceId +"')",obj.scrollSpeed);
		}
		else
		{
			if (obj.scrollRepeat)
			{
				obj.style.left = (obj.offsetWidth * -1) +"px";
				obj.timer = window.setTimeout("EasyEffectsManager('"+ obj.enhanceId +"')",obj.scrollSpeed);
			}
			else
			{
				obj.currentEffect = null;
				if (obj.nextFunc)
					obj.nextFunc();
				obj.nextFunc = null;
			}
		}
		return obj;
	}
	/* -------------------------------------- */
	obj.scrollToLeft	= function (doAfter)
	{
		if (!obj.style.position)
			obj.style.position = "absolute";
		if (doAfter)
			obj.nextFunc = doAfter;
		if (obj.currentEffect != "scrollLeft")
		{
			obj.style.left = (((obj.parentNode.offsetWidth) ? obj.parentNode.offsetWidth : screen.availWidth)+20) +"px";
		}
		if ((obj.offsetLeft) > (-1*obj.offsetWidth) )
		{
			obj.currentEffect = "scrollLeft";
			obj.style.left = (obj.offsetLeft - 5) + "px";
			obj.timer = window.setTimeout("EasyEffectsManager('"+ obj.enhanceId +"')",obj.scrollSpeed);
		}
		else
		{
			if (obj.scrollRepeat)
			{
				obj.style.left = (((obj.parentNode.offsetWidth) ? obj.parentNode.offsetWidth : screen.availWidth)+20) +"px";
				obj.timer = window.setTimeout("EasyEffectsManager('"+ obj.enhanceId +"')",obj.scrollSpeed);
			}
			else
			{
				obj.currentEffect = null;
				if (obj.nextFunc)
					obj.nextFunc();
				obj.nextFunc = null;
			}
		}
		return obj;
	}
	/* -------------------------------------- */
	obj.reflection	= function (nextFunc)
	{
		var canvasArea = $E(obj.id+"Reflection");
		if (!canvasArea)
		{
			var d = document.createElement('div');
			d.setAttribute("id",obj.id+"Reflection");
			d.setAttribute("style","position: relative; margin-left: auto; margin-right: auto");
			obj.parentNode.appendChild(d);
			canvasArea = $E(obj.id+"Reflection");
		}
		//canvasArea.style.position = "absolute";
	/*	canvasArea.style.top = (obj.offsetTop + obj.offsetHeight) + "px";
		canvasArea.style.left = obj.offsetLeft+"px"*/
		canvasArea.style.width = obj.offsetWidth+"px";
		canvasArea.style.display = "block";
		canvasArea.style.visibility = "visible";
		canvasArea.style.height = Math.round(obj.offsetHeight/2)+"px"
		if (!window.addEventListener)
		{
			canvasArea.style.height = "80px"; canvasArea.style.overflow = "hidden";
			var newHTML = '<img src="'+obj.src+'" width="'+obj.offsetWidth+'" style="filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=1) progid:DXImageTransform.Microsoft.Alpha(opacity=25, style=1, FinishOpacity=1, StartY=0, FinishY=10) filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=1) filter: progid:DXImageTransform.Microsoft.BasicImage(mirror=1)"/></div>';
			canvasArea.innerHTML = newHTML;
		}
		else
		{
			var mozCanvasId = canvasArea.id+"Image";
			canvasArea.innerHTML = '<canvas id="'+mozCanvasId+'"></canvas>';
			var mozCanvas = $E(mozCanvasId);
			var newSize = Math.round(obj.height/6);
			mozCanvas.width = obj.width; mozCanvas.height = newSize;
			var ctx = mozCanvas.getContext("2d");
			ctx.save();
			ctx.translate(0,obj.height);
			ctx.scale(1,-1);
			ctx.globalAlpha = .25;

			ctx.drawImage(obj, 0, 0, obj.width, obj.height);
			ctx.restore();
			ctx.globalCompositeOperation = "destination-out";
			var gradient = ctx.createLinearGradient(0, 0, 0, newSize);

			gradient.addColorStop(1, "rgba(255, 255, 255, 1.0)");
			gradient.addColorStop(0, "rgba(255, 255, 255, 0.01)");

			ctx.fillStyle = gradient;
			ctx.fillRect(0, 0, obj.width, newSize);
		}
   		if (nextFunc)
            nextFunc();
	}
	/* -------------------------------------- */
	obj.shake	= function (doAfter)
	{
		if (doAfter)
			obj.nextFunc = doAfter;
		if (obj.timer)
			window.clearTimeout(obj.timer);
		if (obj.style.display != "block")
			obj.style.display = "block";
		if (obj.currentEffect != "shake")
		{
			obj.shakeStartX = obj.offsetLeft;
			obj.shakeStartY = obj.offsetTop;
		}
		if (obj.shakeCtr > 0)
		{
			obj.shakeDirection = obj.shakeDirection * -1;
			obj.shakeCtr--; obj.currentEffect = "shake";
			obj.style.left = (obj.shakeStartX + (obj.shakeX + obj.shakeDirection * Math.round(obj.shakeX * (obj.shakeCtr/obj.shakeIt)))) + "px";
			obj.timer = window.setTimeout("EasyEffectsManager('"+ obj.enhanceId +"')",obj.shakeSpeed);
		}
		else
		{
			obj.style.left 	= obj.shakeStartX +"px";
			obj.style.top	= obj.shakeStartY + "px";
			obj.shakeCtr = obj.shakeIt;
			obj.currentEffect = null;
			if (obj.nextFunc)
				obj.nextFunc();
			obj.nextFunc = null;
		}
		return obj;
	}
	/* -------------------------------------- */
	obj.spiralIn = function ()
	{
		return obj;
	}
	/* -------------------------------------- */
	obj.spiralOut = function ()
	{
		return obj;
	}
	obj.xerox = function (what)
	{
		if (typeof(what)=="string")
			what = $E(what);
		if (what)
		{
			obj.style.width 	= what.offsetWidth+"px";
			obj.style.height 	= what.offsetHeight+"px";
			obj.style.top		= what.offsetTop+"px";
			obj.style.left		= what.offsetLeft+"px";
		}
		return obj;
	}
	obj.hide = obj.hideIt 	= function ()		{	obj.style.visibility = "hidden"; return obj;	}
	obj.show = obj.showIt 	= function ()		{	obj.style.visibility = "visible"; return obj;	}
	obj.opacity	= function (amt)
	{
		if (window.addEventListener)
			obj.style.opacity = amt/100;
		else
			obj.style.filter ="progid:DXImageTransform.Microsoft.Alpha(opacity="+amt+")";
	}
	obj.inverse	= function (nextFunc)
	{
		var mult = (obj.offsetTop>=0) ? 1 : -1;
		obj.style.top = (obj.offsetHeight * mult * -1) + "px"; // if its already less than zero, mult by -1 to make positive
   		if (nextFunc)
            nextFunc();
		return obj;
	}
	obj.remove	= function (nextFunc)
	{
		obj.style.display	= "none";
   		if (nextFunc)
           nextFunc();
		return obj;
 	}
	obj.manifest = function (nextFunc)
	{
        obj.style.opacity = '1';
 		obj.style.display = "block";
   		if (nextFunc)
            nextFunc();
		return obj;
	}
 	return obj;
}