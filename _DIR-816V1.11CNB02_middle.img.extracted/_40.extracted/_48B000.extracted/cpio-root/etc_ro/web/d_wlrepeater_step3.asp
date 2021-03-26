<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
<script type="text/javascript" src="forbidView.js"></script>

<title>设置完成</title>
<script>
var lanip="<% getLanIp(); %>";
var lanmask="<% getLanNetmask(); %>";
function saveChanges()
{
	if (!checkIP(document.WlRepeaterFinish.ip))
	{
		alert("非法的IP地址！");
		return false;
	}

	if (!checkMaskSpecial(document.WlRepeaterFinish.mask))
	{
		alert("非法的地址掩码！");
		return false;
	}
	if(document.WlRepeaterFinish.ip.value != lanip || document.WlRepeaterFinish.mask.value != lanmask)
	{	
		var msg='局域网IP地址或子网掩码改变将导致您可能无法继续访问路由器。\n'
				+'您应释放并更新PC的IP地址来继续配置。\n'
				+'并且原来的静态路由规则将被全部清空。\n'
				+'您确定要更改局域网IP地址或子网掩码吗?';
		
		if (!confirm(msg))
			return false;
	}
	else
	{
		document.WlRepeaterFinish.action = "goform/form2RepeaterFinish.cgi";	
	}
	create_backmask();
	document.getElementById("loading").style.display="";	
	return true;
}
</script>

</head>
<body>
<blockquote>

<script language="JavaScript">
	TabHeader="无线2.4G";
	SideItem="无线中继";
	HelpItem="wlrepeater";
</script>
<script type='text/javascript'>
	mainTableStart();
	logo();
	TopNav();
	ThirdRowStart();
	Write_Item_Images();
	mainBodyStart();
</script>

<form action="goform/form2lansetup.cgi" method=POST name="WlRepeaterFinish">
<table id="body_header" border=0 cellSpacing=0>
	<tr>
		<td class="topheader">设置完成</td>
	</tr>
	<tr>
		<td class=content>
			<p>第三步: 点击"完成"保存配置.</p>
		</td>
	</tr>
	<tr>
		<td>
			<p style="color:red">
&nbsp&nbsp&nbsp&nbsp强烈建议您修改本地网关的IP地址以避免与中心AP的IP地址冲突(例如中心AP的IP为192.168.1.1时，可将本地网关IP地址修改为192.168.1.2)。
			</p>
		</td>
	</tr>
    <tr>
    	<td class="content" align="left">
        	<table class=formarea border="0" cellpadding="0" cellspacing="0" width="500">
				<tr>
					<td class=form_label_left>IP地址:</td>
					<td class=form_label_right><input type="text" name="ip" size="15" maxlength="15" value="<% getLanIp(); %>" ></td>
				</tr>
				<tr>
					<td class=form_label_left>子网掩码:</td>
					<td class=form_label_right><input type="text" readonly="1"  name="mask" size="15" maxlength="15" value="<% getLanNetmask(); %>" ></td>
				</tr> 
			</table>
		</td>
	</tr>
</table>

	<p align=center>
	<input type=submit value="完成" name=wlrepeaterfinish onClick="return saveChanges()">&nbsp;
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

