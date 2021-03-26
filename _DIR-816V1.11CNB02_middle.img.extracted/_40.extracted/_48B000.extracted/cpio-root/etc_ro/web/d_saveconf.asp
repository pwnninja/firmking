<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
<title>备份设置</title>
<script>
var uploadClick=0;
function resetClick()
{
   if ( !confirm('您确定要还原到默认配置吗?') ) {
	return false;
  }
  else
	return true;
}
function sendClicked()
{
	if (document.getElementById('download_image_file').value == "") {
		alert('请选择配置文件!');
		return false;
	}
	
	if (!confirm('您确定要更新配置文件?'))
		return false;
	else
	{
		if(uploadClick==0)
		{
			uploadClick=1;
		}
		else
		{
			alert("请求正在进行中, 请稍候!");
			return false;
		}
		return true;
	}
}

</script>

</head>
<body>
<blockquote>

<script language="JavaScript">
	TabHeader="维护";
	SideItem="备份设置";
	HelpItem="backuprestore";
</script>
<script type='text/javascript'>
	mainTableStart();
	logo();
	TopNav();
	ThirdRowStart();
	Write_Item_Images();
	mainBodyStart();
</script>	

<table id=box_header border=0 cellSpacing=0>
	<tr>
		<td class=topheader>备份设置</td>
	</tr>
	<tr>
		<td class=content>
			<p>您可以将路由器配置文件保存到硬盘上或者从配置文件恢复路由器配置.
            </p>
		</td>
	</tr>
</table>
<br>

<form action="/cgi-bin/ExportSettings.cgi" method=POST name="saveConfig">
<table id=body_header border=0 cellSpacing=0>
	<tr>
		<td class=topheader>保存配置到文件</td>
	</tr>
	<tr>
		<td class="content" align="center">
			<input type="submit" value="保存..." name="submit.htm?saveconf.htm">
		</td>
	</tr>
</table>
<input type="hidden" name="tokenid" id="tokenid0" value="" > 
</form>

<form action="/cgi-bin/upload_settings.cgi" method=POST enctype="multipart/form-data" name="upload">
<table id=body_header border=0 cellSpacing=0>
    <tr>
		<td class=topheader>从文件恢复配置</td>
	</tr>
	<tr>
		<td class="content" align="left">
			<input type="file" id="download_image_file" name="download_image_file" size=30>
			<input type="submit" value="上传" name="send" onClick="return sendClicked()">
			<INPUT TYPE="hidden" NAME="submit" VALUE="Send">
		</td>
	</tr>
</table>
<input type="hidden" name="tokenid" id="tokenid1" value="" > 
<script>
    var tokenid = "<% getTokenidToRamConfig(); %>";
	console.log("[d_saveconf] tokenid ="+tokenid);
	
	for(var i=0;i<2;i++)
	    document.getElementById("tokenid"+i).setAttribute("value",tokenid);
</script> 
</form>

<script type='text/javascript'>
	mainBodyEnd();
	ThirdRowEnd();
	Footer()
	mainTableEnd()
</script>

</blockquote>
</body>
</html>

