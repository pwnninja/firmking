<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<title>
 Wireless Router
</title>
<style type="text/css">
 .login {position:absolute;left:50%;margin-left:-421px !important;margin-left:-421px;width:842px;height:526px;text-align:left; background:#ffffff;}
 .copywright{font-size: 14px;text-align:center; height:30px;}
.Table1 {
 BORDER-BOTTOM: #ff6f00 1px solid; BORDER-LEFT: #ff6f00 1px solid; MARGIN-TOP: 30px; WIDTH: 550px; BORDER-COLLAPSE: collapse; BACKGROUND: #f1f1f1; HEIGHT: 270px; MARGIN-LEFT: 150px; BORDER-TOP: #ff6f00 1px solid; BORDER-RIGHT: #ff6f00 1px solid
}
.Table1 TD.lable {
 FONT: bold 9pt Arial,Helvetica,sans-serif; COLOR: #003366
}

</style>
<script>
var ModemVer="<% getCfgGeneral(1, "ModeName"); %>";
var HardwareVer="<% getCfgGeneral(1, "HardwareVer"); %>";
var FirmwareVer="<% getCfgGeneral(1, "FirmwareVer"); %>";
var wtime = 2;
function timerStart()
{
 if (wtime >= 0)
 {
  wtime--;
  setTimeout("timerStart()",7000);
 }
 else
 {
  document.form2WizardStep6.submit();
 }
}
</script>
</head>
<body id="login_body">
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
 <form action="/goform/form2WizardStep6.cgi" method=POST name="form2WizardStep6">
    <table class="Table1">
       <tbody>
         <tr>
          <td class="letterBg">&nbsp;</td>
         </tr>
         <tr>
          <td height="240">
           <table>
            <tbody>
             <tr>
              <td width="980" align="center">正在保存设置并生效</td>
             </tr>
             <tr>
              <td width="980" align="center">请等待 ... </td>
             </tr>
            </tbody>
           </table>
          </td>
         </tr>
   <tr>
    <td>
     <input type="hidden" name="submit.htm?d_wizard_step6_wait.asp" value="Send">
    </td>
   </tr>
     </tbody>
    </table>
 <script>
 timerStart();
 </script>
<input type="hidden" name="tokenid"  value="<% getTokenidToRamConfig(); %>" >
 </form>
    <div class="loginBottom"> </div>
    <div id="lang_copyright" class="copywright">
2008-2017 D-Link公司，版权所有。    </div>
</div>
</body>
</html>

