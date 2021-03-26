<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
<title>用户帐户配置</title>

<SCRIPT>
selected=0;

function includeSpace(str)
{
  for (var i=0; i<str.length; i++) {
  	if ( str.charAt(i) == ' ' ) {
	  return true;
	}
  }
  return false;
}

function includeSpecialKey(str)
{
  for (var i=0; i<str.length; i++) {
  	if (( str.charAt(i)== ' ' ) || ( str.charAt(i)== '%' )
	|| ( str.charAt(i)== '\\' ) || ( str.charAt(i)== '\'' )  	
  	|| ( str.charAt(i)== '?' )
        ||( str.charAt(i)== '&' ) ||( str.charAt(i)== '"' )) {
	  return true;
	}
  }
  
  return false;
}

function includeChinese(str)
{
	for (var i=0; i<str.length; i++) {
		if (str.charCodeAt(i) > 128) {
			return true;
		}
	}

	return false;
}

function saveChanges()
{
	if(document.userconfig.show_username.value.length == 0) 
	{
		alert('错误!用户名不能为空!');
		document.userconfig.show_username.focus();
		return false;
	}
	else
	{
		if(includeSpecialKey(document.userconfig.show_username.value))
		{
			alert('非法的用户名,不能包含特殊字符:" ", "%", "\\", "\'", "?", "&", """ .');
			document.userconfig.show_username.focus();
			return false;
		}

		if(includeChinese(document.userconfig.show_username.value))
		{
			alert('非法的用户名,不能包含汉字');
			document.userconfig.show_username.focus();
			return false;		
		}
	}

/*
	if(document.userconfig.newpass.value.length == 0) 
	{
		alert('新密码不能为空,请重新输入.');
		document.userconfig.newpass.focus();
		return false;
	}
	else 
*/
	if(document.userconfig.newpass.value.length > 29) 
	{
		alert('新密码长度不能超过30个字符,请重新输入.');
		document.userconfig.newpass.focus();
		return false;
	}
	else if(document.userconfig.newpass.value.length < 6) 
	{
		alert('新密码长度不能少于6个字符,请重新输入.');
		document.userconfig.newpass.focus();
		return false;
	}
	else
	{
		if(includeSpecialKey(document.userconfig.newpass.value)) 
		{
			alert('非法的密码,不能包含特殊字符:" ", "%", "\\", "\'", "?", "&", """ .');
			document.userconfig.newpass.focus();
			return false;
		}

		if(includeChinese(document.userconfig.newpass.value))
		{
			alert('非法的密码,不能包含汉字');
			document.userconfig.newpass.focus();
			return false;		
		}		
	}

	if (document.userconfig.newpass.value != document.userconfig.confpass.value) 
	{
		alert('新密码和确认密码不一样,请确认.');
		document.userconfig.newpass.focus();
		return false;
	}
		
	//
	if (document.userconfig.show_username.value != "")
	{
		document.userconfig.username.value = Base64.Encode(document.userconfig.show_username.value);
	}
	
	if (document.userconfig.newpass.value != "")
	{
		document.userconfig.newpass.value = Base64.Encode(document.userconfig.newpass.value);
		document.userconfig.confpass.value = Base64.Encode(document.userconfig.confpass.value);
	}
	
	document.userconfig.show_username.disabled = true;

	return true;
}

function modifyClick()
{
	if (!selected) {
		alert("请选择一项修改!");
		return false;
	}

	if (document.userconfig.oldpass.value != "")
	{
		document.userconfig.oldpass.value = Base64.Encode(document.userconfig.oldpass.value);
	}
	if (document.userconfig.oldpass.value != document.userconfig.hiddenpass.value) {
		alert('旧密码不正确.');
		document.userconfig.oldpass.focus();
		return false;
	}
	
	return saveChanges();
}

function delClick()
{
	if(!selected)
	{
		alert("选择一项删除!");
		return false;
	}
	if(document.userconfig.show_username.value == "admin")
	{
		alert("不能删除admin!");
		return false;
	}
	if(document.userconfig.show_username.value == "user")
	{
		alert("不能删除user!");
		return false;
	}
	
	if (document.userconfig.show_username.value != "")
	{
		document.userconfig.username.value = Base64.Encode(document.userconfig.show_username.value);
	}
	
	if (document.userconfig.newpass.value != "")
	{
		document.userconfig.newpass.value = Base64.Encode(document.userconfig.newpass.value);
		document.userconfig.confpass.value = Base64.Encode(document.userconfig.confpass.value);
	}
	
	document.userconfig.show_username.disabled = true;
	
	return true;
}

function postEntry(user, priv, pass)
{
	document.userconfig.privilege.value = priv;

	if (user != "")
	{
		user = Base64.Decode(user);
	}

	if (user == "Admin" || user == "user"){
	document.userconfig.privilege.disabled = true;
	//document.userconfig.show_username.disabled = true;
	}else
	document.userconfig.privilege.disabled = false;
	document.userconfig.oldpass.disabled = false;
	document.userconfig.show_username.value = user;
	document.userconfig.hiddenpass.value = pass;
	selected = 1;
}

function disablePriv()
{
	document.userconfig.privilege.value = 0;
	document.userconfig.privilege.disabled = true;
}

function resetConfig()
{
//	disablePriv();
	document.userconfig.privilege.value = 0;
	document.userconfig.privilege.disabled = false;
	document.userconfig.oldpass.disabled = true;
}

function checkAction()
{
//	disablePriv();
//	if (document.userconfig.hiddenpass.value.length == 0)
	if (!selected)
		document.userconfig.oldpass.disabled = true;
}
</SCRIPT>
</head>

<BODY>
<blockquote>

<script language="JavaScript">
	TabHeader="维护";
	SideItem="用户帐户配置";
	HelpItem="password";
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
		<td class=topheader>用户帐户配置</td>
	</tr>
	<tr>
		<td class=content>
			<p>此页面用来增加用户帐户以访问路由器的Web服务器。
            </p>
		</td>
	</tr>
</table>
<br>
<form action="/goform/form2userconfig.cgi" method=POST name="userconfig">
<table id=body_header border=0 cellSpacing=0>
	<tr>
		<td class=topheader>配置</td>
	</tr>
    <tr>
		<td class="content" align="left">
  			<table class="formarea" border="0" cellpadding="0" cellspacing="0" width="500">
    			<tr>
    				<td class='form_label_left' width="20%">
                    用户名:
                    </td>
                    <td class='form_label_right'>
                    <input type="text" name="show_username" size="20" maxlength="29" style="width:150px">
					<input type="hidden" name="username" size="20" maxlength="29" style="width:150px">
                    </td>
    			</tr>
                <tr>
    				<td class='form_label_left' width="20%">
                    特权级:
                    </td>
                    <td class='form_label_right'>
                    <select size="1" name="privilege" disabled>
<option value="2">Root</option>
                    </select>
                    </td>
    			</tr>
                <tr>
    				<td class='form_label_left' width="20%">
                    旧密码:
                    </td>
                    <td class='form_label_right'>
                    <input type="password" name="oldpass" size="20" maxlength="36">
                    </td>
    			</tr>
                <tr>
    				<td class='form_label_left' width="20%">
                    新密码:
                    </td>
                    <td class='form_label_right'>
                    <input type="password" name="newpass" size="20" maxlength="36">
                    </td>
    			</tr>
                <tr>
    				<td class='form_label_left' width="20%">
                    确认密码:
                    </td>
                    <td class='form_label_right'>
                    <input type="password" name="confpass" size="20" maxlength="36">
                    </td>
    			</tr>
			</table> 
		</td>
	</tr>
</table>
<br>
<p align=center>
<!--input type="submit" value="增加" name="adduser" onClick="return saveChanges()"-->
<input type="submit" value="修改" name="modify" onClick="return modifyClick()">
<input type="submit" value="删除" name="deluser" onClick="return delClick()">
<input type="reset" value="取消" name="reset" onClick="resetConfig()">
</p>

<table id=body_header border=0 cellSpacing=0>
	<tr>
		<td class=topheader>用户帐户列表</td>
	</tr>
    <tr>
        <td class=content>
  			<table class=formlisting border=0>
                <tr class=form_label_row>
                    <td class='form_label_col' width="20%">
                    选择
                    </td>
                    <td class='form_label_col' width="50%">
                    用户名
                    </td>
                    <td class='form_label_col' width="30%">
                    特权级
                    </td>
                </tr>
<tr class=form_label_row><td class="form_label_col" width="20%" ><input type="radio" name="select" value="s0" onClick="postEntry('<% getCfgGeneral(1, "Login_encode"); %>', '2', '<% getCfgGeneral(1, "Password_encode"); %>')"> </td>
<td class="form_label_col" width="50%" >
<script type='text/javascript'>
if ("<% getCfgGeneral(1, "Login_encode"); %>" != "")
{
	var show_login = Base64.Decode("<% getCfgGeneral(1, "Login_encode"); %>");
	dw(show_login);
}
</script>
</td>
<td class="form_label_col" width="30%" >root</td></tr>
<!--tr class=form_label_row><td class="form_label_col" width="20%" ><input type="radio" name="select" value="s2" onClick="postEntry('user', '2', 'user')"> </td>
<td class="form_label_col" width="50%" >user</td>
<td class="form_label_col" width="30%" >root</td></tr>
<tr class=form_label_row><td class="form_label_col" width="20%" ><input type="radio" name="select" value="s3" onClick="postEntry('8', '2', '8')"> </td>
<td class="form_label_col" width="50%" >8</td>
<td class="form_label_col" width="30%" >root</td></tr-->
            </table>
        </td>
    </tr>
</table>
<input type="hidden" name="hiddenpass">
<input type="hidden" NAME="submit.htm?userconfig.htm" VALUE="Send">
<script>
	checkAction();
</script> 
<input type="hidden" name="tokenid"  value="<% getTokenidToRamConfig(); %>" >
</form>

<script type='text/javascript'>
	mainBodyEnd();
	ThirdRowEnd();
	Footer()
	mainTableEnd()
</script>

<blockquote>
</body>
</html>




