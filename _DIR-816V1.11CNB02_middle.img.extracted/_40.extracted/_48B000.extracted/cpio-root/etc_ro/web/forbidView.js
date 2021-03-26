function create_backmask()
{
	var sWidth,sHeight;
	sWidth=window.screen.width;
	sHeight=window.screen.height + 100;

	var bgObj=document.createElement("div");
	bgObj.setAttribute('id','bgDiv');
	bgObj.style.position="absolute";
	bgObj.style.top="0";
	if(s){clearInterval(s);}
	s= setInterval(change_show,3);
	bgObj.style.opacity = 0.6;
	bgObj.style.background="#FFFFFF"	//"#cccccc";
	//bgObj.style.filter="progid:DXImageTransform.Microsoft.Alpha(style=3,opacity=25,finishOpacity=75)";
	//bgObj.style.opacity=0.6;
	bgObj.style.left="0";
	bgObj.style.width=sWidth + "px";
	bgObj.style.height=sHeight + "px";
	bgObj.style.zIndex = "10000";
	bgObj.innerHTML="<iframe style=\"position:absolute; visibility:inherit; top:0px; left:0px; width:"+sWidth+"px;height:"+sHeight+"px;\"></iframe>";
	document.body.appendChild(bgObj);
}

function remove_backmask()
{
//	var bgObj = $("bgDiv");
//	document.body.removeChild(bgObj);
	setElementHide("bgDiv", true);
	setElementHide("loading", true);
}

function $(d){return document.getElementById(d);}
var s;
var u = 0;
function change_show(){
   var obj = $("bgDiv");
   var loader = $("loading");
   u=u+1;
   obj.style.filter = "Alpha(Opacity=" + u + ")";
   loader.style.filter = "Alpha(Opacity=" + u + ")";
   obj.style.opacity = u/100;
   loader.style.opacity = u/100;
   if(u>=80){
    clearInterval(s);
    u=0;
   }
   document.getElementById("loading").style.zIndex = "10001";
}

document.write('<div id="loading" style="display: none; left:50%; top:30%; width:10%; position:absolute;"><br><#Processing...#><br><#Please,wait.#><br><br><img src="images/load.gif" /><br><br></div>');
