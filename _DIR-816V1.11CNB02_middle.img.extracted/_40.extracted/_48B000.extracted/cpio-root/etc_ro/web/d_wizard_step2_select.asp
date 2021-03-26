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
</script>
</head>
<body>
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
<form action="/goform/form2WizardStep2.cgi" method=POST name="form2WizardStep2">
<table width="502" cellspacing="0" cellpadding="0" border="0" align="center" class="setting_table">
 <tbody>
  <tr>
   <td width="500" valign="middle" align="left" class="wizard_title">
    &nbsp&nbsp设置向导-上网方式
   </td>
  </tr>
  <tr>
   <td colspan="2">
    <table width="502" cellspacing="0" cellpadding="0" border="0">
     <tbody>
      <tr>
       <td width="500">
        <br>
        <table width="430" align="center" cellspacing="0" cellpadding="0" border="0"
        class="space">
         <tbody>
          <tr>
           <td>
            本向导提供三种最常见的上网方式供选择。若为其它上网方式，请在“设置”中“Internet设置”进行设置。
           </td>
          </tr>
         </tbody>
        </table>
        <table width="430" align="center" cellspacing="0" cellpadding="0" border="0"
        class="space">
         <tbody>
          <tr>
           <td class="clk">
            <input type="radio" value="2" name="wizardstep2_wantype" checked>
            PPPoE（ADSL虚拟拨号）
           </td>
          </tr>
          <tr>
           <td class="clk">
            <input type="radio" value="1" name="wizardstep2_wantype">
            动态IP（以太网宽带，自动从网络服务商获取IP地址）
           </td>
          </tr>
          <tr>
           <td class="clk">
            <input type="radio" value="0" name="wizardstep2_wantype">
            静态IP（以太网宽带，网络服务商提供固定IP地址）
           </td>
          </tr>
         </tbody>
        </table>
        <br>
       </td>
      </tr>
      <tr>
       <td height="30" align="right" class="wizard_tail">
        &nbsp;
        <input type="submit" name="wizardstep2_back" value="上一步">
        &nbsp;
        <input type="submit" name="wizardstep2_next" value="下一步">
        &nbsp;
        <input type="hidden" name="submit.htm?d_wizard_step2_select.asp" value="Send">
       </td>
      </tr>
     </tbody>
    </table>
   </td>
  </tr>
 </tbody>
</table>
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
</body>
</html>

