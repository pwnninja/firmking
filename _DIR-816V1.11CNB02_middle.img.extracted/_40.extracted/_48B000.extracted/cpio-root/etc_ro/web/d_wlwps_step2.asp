<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>


<title>Wi-Fi保护设置</title>

<script>
var is_WPSEnabled="<% getCfgZero(1, "WscModeOption"); %>";
var is_WlanDisabled = '<% getCfgZero(1, "RadioOff"); %>';
var wscmethods = "<% getCfgGeneral(1, "WscConfMethods"); %>";
function check_pin_code(str)
{
	var i;
	var code_len;
		
	code_len = str.length;
	if (code_len != 8 && code_len != 4)
		return 1;

	for (i=0; i<code_len; i++) {
		if ((str.charAt(i) < '0') || (str.charAt(i) > '9'))
			return 2;
	}

	if (code_len == 8) {
		var code = parseInt(str, 10);
		if (!validate_pin_code(code))
			return 3;
		else
			return 0;
	}
	else
		return 0;
}
function setPinClicked(form)
{
	var ret;

	if(form.elements["peerPin"].disabled == true)
	{	
		alert('路由器PIN已被禁用.');
		return false;
	}
	ret = check_pin_code(form.elements["peerPin"].value);
	if (ret == 1) {
		alert('无效的PIN长度, 一般PIN有4或8个数字长.');
		form.peerPin.focus();		
		return false;
	}
	else if (ret == 2) {
		alert('无效的PIN, 必须为数字格式.');
		form.peerPin.focus();		
		return false;
	}
	else if (ret == 3) {
		if ( !confirm('Checksum failed! Use PIN anyway? ') ) {
			form.peerPin.focus();
			return false;
  		}
	}	
	return true;
}
</script>

</head>


<body>

<blockquote>


<script language="JavaScript">

	TabHeader="无线2.4G";
	SideItem="WPS设置";
	HelpItem="wlwps";
</script>

<script type='text/javascript'>

	mainTableStart();
	logo();
	TopNav();
	ThirdRowStart();
	Write_Item_Images();
	mainBodyStart();
</script>


<form action="/goform/form2Wsc.cgi" method=POST name="formWsc">

	<table id=box_header border=0 cellSpacing=0>

		<tr>

			<td class=topheader>

				添加WPS客户端
			</td>

		</tr>

		<tr>

			<td class=content>

				<p>

				  WPS代表Wi-Fi保护设置。您可以通过这一过程轻松地将无线客户端添加到网络，而无需进行任何具体的配置，例如SSID、安全模式和密码之类的配置。
				</p>

			</td>

		</tr>

	</table>


	<table id=body_header border=0 cellSpacing=0>

	<tr>

		<td class=topheader>

			选择设置方法:
		</td>

	</tr>

	<tr>

		<td class=content align=center>

			<table class=formarea border="0" cellpadding="0" cellspacing="0" width=100%>	

				<tr>

					<td>

						<input type="radio" value="enable" name="pinmode" checked>PIN码模式 

					</td>

				</tr>

				<tr>

					<td width="60%" style="padding-left:25px;">如果你的网卡支持WPS，请点击 '生成网卡的安全PIN码' ，然后在这里输入生成的PIN码。</td>

					<td>

                        &nbsp&nbsp&nbsp&nbsp
					</td>

					<td>

						<span>输入网卡的PIN代码:</span>

						<input type="text" name="peerPin" size="12" maxlength="8" value="">

					</td>

				</tr>

			</table>

		</td>

	</tr>

	</table>


	<p align=center>

	<input type="submit" value="开始PIN通信" name="setPIN"  onClick="return setPinClicked(document.formWsc)">

	</p>

	<INPUT TYPE="hidden" NAME="submit.htm?wlwps_step1.htm" VALUE="Send">

	<input type="hidden" name="tokenid"  value="<% getTokenidToRamConfig(); %>" >
</form>


<script>
	if ((is_WPSEnabled == "0") || (is_WlanDisabled == "1") ||((wscmethods !="0x268c") &&(wscmethods !="0x238c")) )
	{
		disableTextField(document.formWsc.peerPin);disableButton(document.formWsc.setPIN);
	}
		

</script>


<script type='text/javascript'>

	mainBodyEnd();
	ThirdRowEnd();
	Footer();
	mainTableEnd();
</script>


</blockquote>

</body>


</html>



