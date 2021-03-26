<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
<title>固件升级</title>
<script>
var uploadClick=0;
function sendClicked()
{
	var upgrade_name = document.getElementById('download_image_file').value;
	if ( upgrade_name == "")
	{
		alert("升级文件不能为空!");
		return false;
	}
	if (!confirm('你确定想要更新软件版本吗?'))
		return false;
	else
	{
		if(uploadClick==0)
		{
			uploadClick=1;
		}
		else
		{
			alert("请求进行中，请稍等片刻!");
			return false;
		}
		return true;
	}
}

</script>
</head>
<BODY>
<blockquote>

<script language="JavaScript">
	TabHeader="维护";
	SideItem="固件升级";
	HelpItem="firmwareupdate";
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
		<td class=topheader>固件升级</td>
	</tr>
	<tr>
		<td class=content>
			<p>您可以使用本页面为路由器升级一个新的软件版本. 请注意, 在升级过程中请不要断电, 
 这样可能会使系统崩溃.
 <p>提示:在升级完毕后系统会自动重启.
            </p>
		</td>
	</tr>
</table>
<br>

<form action="/cgi-bin/upload.cgi" method=POST enctype="multipart/form-data" name="password">
<table id=body_header border=0 cellSpacing=0>
	<tr>
		<td class=topheader>选择文件</td>
	</tr>
	<tr>
		<td class="content" align="left">
			<input type="file" id="download_image_file" name="download_image_file" size=60>
		</td>
	</tr>
	<tr>
		<td>&nbsp;&nbsp;<input type="checkbox" name="resetdefault" value="nop" >版本升级完成后自动恢复出厂配置
		</td>
	</tr>	
</table>
<br>
<p align=center>
<input type="submit" value="上传" name="send" onClick="return sendClicked()">&nbsp;&nbsp;
<input type="reset" value="取消" name="reset">
<INPUT TYPE="hidden" NAME="submit" VALUE="Send"> 
</p>
<input type="hidden" name="tokenid"  value="<% getTokenidToRamConfig(); %>" >
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

