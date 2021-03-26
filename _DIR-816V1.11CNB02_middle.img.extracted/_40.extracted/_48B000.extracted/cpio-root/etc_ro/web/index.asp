<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<META HTTP-EQUIV="pragma" CONTENT="no-cache">
<title>无线路由</title>
<script language="javascript" src="d_util.js"></script>
<script>

//Frederick, 060605 Add function to close window without warning{
function closeWindow(){

	var currBrowser;
	currBrowser = GetBrowserOS();

	switch(currBrowser)
	{
		case "msiewin": //ie windows
		case "msiemac": //ie mac
		case "netslin": //mozilla linux
				window.opener = self;
				window.close();
				break;
		case "netswin": //netscape windows
		case "firelin": //firefox linux
		case "firewin": //firefox windows
		case "firemac": //firefox mac
				window.open('','_parent','');
				window.close();
				break;
		default:
				window.opener = self;
				window.close();
				break;
	}

}
//Frederick, 060605}

function op() {}
</script>

</head>
<blockquote>
<frameset rows="0,*" frameborder="0" framespacing="0">
  <frame name="fPanel" src="" scrolling="auto" marginwidth="0" marginheight="0">
<frame name="main" src="d_wizard_step1_start.asp">
  <noframes>
  <body bgcolor="#008080">
  <p>This page uses frames, but your browser doesn't support them.</p>
  </body>
  </noframes>
</frameset>
</blockquote>
</html>

