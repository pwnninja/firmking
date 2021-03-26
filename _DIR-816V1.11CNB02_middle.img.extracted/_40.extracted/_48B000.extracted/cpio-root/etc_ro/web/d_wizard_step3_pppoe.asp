<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<title>
 Wireless Router
</title>

<script>
var ModemVer="<% getCfgGeneral(1, "ModeName"); %>";
var HardwareVer="<% getCfgGeneral(1, "HardwareVer"); %>";
var FirmwareVer="<% getCfgGeneral(1, "FirmwareVer"); %>";
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
 if(document.form2WizardStep3Pppoe.show_pppoe_usrname.value.length == 0)
 {
  alert('错误!帐号不能为空!');
  document.form2WizardStep3Pppoe.show_pppoe_usrname.focus();
  return false;
 }
 else
 {
  if(!checkSpecialChar(document.form2WizardStep3Pppoe.show_pppoe_usrname.value, 1))
  {
   alert('pppoe帐号中有非法字符!');
   document.form2WizardStep3Pppoe.show_pppoe_usrname.focus();
   return false;
  }
 }
 if(document.form2WizardStep3Pppoe.pppoe_psword.value.length == 0)
 {
  alert('口令不能为空,请重新输入.');
  document.form2WizardStep3Pppoe.pppoe_psword.focus();
  return false;
 }
 else
 {
  if(!checkSpecialChar(document.form2WizardStep3Pppoe.pppoe_psword.value, 1))
  {
   alert('pppoe口令中有非法字符!');
   document.form2WizardStep3Pppoe.pppoe_psword.focus();
   return false;
  }
 }
 if (document.form2WizardStep3Pppoe.pppoe_psword.value != document.form2WizardStep3Pppoe.confirm.value)
 {
  alert('口令不一致,请确认.');
  document.form2WizardStep3Pppoe.pppoe_psword.focus();
  return false;
 }
 
 document.form2WizardStep3Pppoe.pppoe_usrname.value = Base64.Encode(document.form2WizardStep3Pppoe.show_pppoe_usrname.value)

	if (document.form2WizardStep3Pppoe.pppoe_psword.value != "********")
	{
		document.form2WizardStep3Pppoe.pppoe_psword.value = Base64.Encode(document.form2WizardStep3Pppoe.pppoe_psword.value)
		document.form2WizardStep3Pppoe.confirm.value = Base64.Encode(document.form2WizardStep3Pppoe.confirm.value)
	}

 document.form2WizardStep3Pppoe.show_pppoe_usrname.disabled = true;
 
 return true;
}
var statuscheckpppoeuser="0";var wtime;
function timerStart()
{
 if (wtime >= 0)
 {
  document.form2WizardStep3Pppoe.checkpppoeuser.value = '检测中, 剩余'+wtime+'秒';
  document.form2WizardStep3Pppoe.checkpppoeuser.disabled = true;
  document.form2WizardStep3Pppoe.wizardstep3pppoe_back.disabled = true;
  document.form2WizardStep3Pppoe.wizardstep3pppoe_next.disabled = true;
  wtime--;
  setTimeout("timerStart()",1000);
 }
 else
 {
  document.form2WizardStep3Pppoe.checkpppoeuser.disabled = false;
  document.form2WizardStep3Pppoe.wizardstep3pppoe_back.disabled = false;
  document.form2WizardStep3Pppoe.wizardstep3pppoe_next.disabled = false;
  document.form2WizardStep3Pppoe.checkpppoeuser.value = "帐号检测";
  document.form2WizardStep3Pppoe.statuscheckpppoeuser.value = "2";
  document.form2WizardStep3Pppoe.submit();
 }
}
function onClickCheckPppoeUser()
{
 if(true == saveChanges())
 {
  document.form2WizardStep3Pppoe.statuscheckpppoeuser.value = "1";
  document.form2WizardStep3Pppoe.submit();
  return true;
 }
 else
 {
  return false;
 }
}
function postload()
{
 if('1' == document.form2WizardStep3Pppoe.statuscheckpppoeuser.value)
 {
  wtime = 10;
  timerStart();
 }
 else if('11' == document.form2WizardStep3Pppoe.statuscheckpppoeuser.value)
 {
  document.getElementById("id_noconnected").style.display = 'block';
 }
 else if('12' == document.form2WizardStep3Pppoe.statuscheckpppoeuser.value)
 {
  document.getElementById("id_noack").style.display = 'block';
 }
 else if('13' == document.form2WizardStep3Pppoe.statuscheckpppoeuser.value)
 {
  document.getElementById("id_notpass").style.display = 'block';
 }
 else if('14' == document.form2WizardStep3Pppoe.statuscheckpppoeuser.value)
 {
  document.getElementById("id_pass").style.display = 'block';
 }
 else
 {
  document.form2WizardStep3Pppoe.statuscheckpppoeuser.value = "0";
 }
}

function InitValue()
{
	if ( "<% getCfgGeneral(1, "wan_pppoe_user_encode"); %>" != "")
	{
		document.form2WizardStep3Pppoe.show_pppoe_usrname.value = Base64.Decode("<% getCfgGeneral(1, "wan_pppoe_user_encode"); %>");
	}
}

</script>
</head>
<body onload="InitValue()">
<div class="login">
<table class="productInfo" border="0" cellpadding="0" cellspacing="0" width="100%">
 <tr>
  <td align="left" height="30" bgcolor="#404343" colspan="1">&nbsp;&nbsp;&nbsp;&nbsp;产品页面:
<script>
  document.write(ModemVer);
</script>
  </td>
  <td align="right" height="30" bgcolor="#404343" colspan="2">硬件版本:
<script>
  document.write(HardwareVer);
</script>
&nbsp;&nbsp;&nbsp;&nbsp;固件版本:
<script>
  document.write(FirmwareVer);
</script>
  &nbsp;&nbsp;&nbsp;&nbsp;
  </td>
 </tr>
</table>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
 <tr>
  <td align="left"><a href="http://www.dlink.com.cn/" target="_blank"><img src="d_head_01.gif" border="0"></a></td>
  <td background="d_head_02.gif" width="600"></td>
  <td align="right"><img src="d_head_03.gif"></td>
 </tr>
</table>
<br>
<br>
<br>
<form action="/goform/form2WizardStep3Pppoe.cgi" method=POST name="form2WizardStep3Pppoe">
<table width="502" cellspacing="0" cellpadding="0" border="0" align="center" class="setting_table">
 <tbody>
  <tr>
   <td width="500" valign="middle" align="left" class="wizard_title">
    &nbsp&nbsp设置向导
   </td>
  </tr>
  <tr>
   <td colspan="2">
    <table width="502" cellspacing="0" cellpadding="0" border="0">
     <tbody>
      <tr>
       <td width="500">
        <br>
        <table width="400" align="center" cellspacing="0" cellpadding="0" border="0"
        class="space">
         <tbody>
          <tr>
           <td>
            请在下框中填入网络服务商提供的PPPOE上网帐号及口令，如遗忘请咨询网络服务商。
           </td>
          </tr>
         </tbody>
        </table>
        <table width="400" align="center" border="0" class="space">
         <tbody>
          <tr>
           <td width="86">
            上网账号：
           </td>
           <td width="304">
            <input type="text" maxlength="64" size="25" value="" id="show_acc" class="text" name="show_pppoe_usrname">
			<input type="hidden" maxlength="64" size="25" value="" id="acc" class="text" name="pppoe_usrname">
           </td>
          </tr>
          <tr>
           <td>
            上网口令：
           </td>
           <td>
            <input type="password" maxlength="256" size="25" value="<% getPPPoePass(); %>" id="psw" class="text" name="pppoe_psword">
           </td>
          </tr>
          <tr>
           <td>
            确认口令：
           </td>
           <td>
            <input type="password" maxlength="256" size="25" value="<% getPPPoePass(); %>" id="confirm" class="text" name="confirm">
           </td>
          </tr>
          <tr><td><br></td></tr>
          <tr style="display:none">
           <td>
            <script>
            document.writeln('<input type=\"text\" name=\"statuscheckpppoeuser\" maxlength=\"64\" size=\"25\" value=\"'+statuscheckpppoeuser+'\">');
            </script>
           </td>
          </tr>
          <tr style="display:none" >
           <td>
            <input type="submit" name="checkpppoeuser" value="帐号检测" onClick="return onClickCheckPppoeUser()">
           </td>
           <td id="id_noconnected" style="display:none">
            <p style="color:red">
            检测到WAN口没有正确连接，请重新确认WAN口网线已经插好，并确认WAN口灯是亮的。
            </p>
           </td>
           <td id="id_noack" style="display:none">
            <p style="color:red">
            PPPOE服务器无响应，请您确认WAN口是否连接到您网络服务商的网络中。
            </p>
           </td>
           <td id="id_notpass" style="display:none">
            <p style="color:red">
            帐号或口令错误，请您输入正确的上网帐号和口令，如遗忘请咨询网络服务商。
            </p>
           </td>
           <td id="id_pass" style="display:none">
            <p style="color:red">
            帐号和口令有效。
            </p>
           </td>
          </tr>
         </tbody>
        </table>
        <br>
       </td>
      </tr>
      <tr>
       <td height="30" align="right" class="wizard_tail">
        <input type="submit" name="wizardstep3pppoe_back" value="上一步">
        &nbsp;
        <input type="submit" name="wizardstep3pppoe_next" value="下一步" onClick="return saveChanges()">
        &nbsp;
       </td>
      </tr>
     </tbody>
    </table>
   </td>
  </tr>
 </tbody>
</table>
<input type="hidden" name="submit.htm?d_wizard_step3_pppoe.asp" value="Send">
<input type="hidden" name="tokenid"  value="<% getTokenidToRamConfig(); %>" >
</form>
<br>
<br>
<br>
<div class="loginBottom">
</div>
<div class="copywright">
2008-2017 D-Link公司，版权所有。</div>
</div>
<script>
postload();
</script>
</body>
</html>

