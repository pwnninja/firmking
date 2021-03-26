<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
<title>Internet设置向导</title>

<script>
var ModemVer="<% getCfgGeneral(1, "ModeName"); %>";
var HardwareVer="<% getCfgGeneral(1, "HardwareVer"); %>";
var FirmwareVer="<% getCfgGeneral(1, "FirmwareVer"); %>";

function wizardStartBackFuc()
{
	document.location.href='d_wan.asp';
}
</script>
</head>

<body>
<blockquote>

<script language="JavaScript">
 TabHeader="设置";
 SideItem="Internet设置向导";
 HelpItem="wizard";
</script>
<script type='text/javascript'>
 mainTableStart();
 logo();
 TopNav();
 ThirdRowStart();
 Write_Item_Images();
 mainBodyStart();
</script>

<br>
<br>
<br>

<form action="/goform/form2WizardStep1.cgi" method=POST name="form2WizardStep1">
<script>
	if(!(("<% getCfgZero(1,"ApCliEnable");%>"==1)||("<% getCfg2Zero(1,"ApCliEnable");%>"==1))){
		document.writeln('<table border="0" cellpadding="0" cellspacing="0" width="502" align="center" class="setting_table">');
	}else{
		document.writeln('<table border="0" cellpadding="0" cellspacing="0" width="502" align="center" class="setting_table" disabled>');
	}
</script>
 <tbody>
  <tr>
   <td class="wizard_title" align="left" valign="middle" width="500">
    &nbsp&nbsp设置向导
   </td>
  </tr>
  <tr>
   <td colspan="2">
    <table border="0" cellpadding="0" cellspacing="0" width="502">
     <tbody>
      <tr>
       <td width="500">
        <br>
        <table border="0" cellpadding="0" cellspacing="0" align="center" width="410">
         <tbody>
          <tr>
           <td>
            本向导可设置上网所需的基本网络参数，请单击“下一步”继续。若要详细设置某项功能或参数，请单击“手动设置”。
           </td>
          </tr>
         </tbody>
        </table>
        <br>
       </td>
      </tr>
      <tr>
       <td class="wizard_tail" align="right" height="30" nowrap="nowrap">
	   
	   
	   	<script>
			if(!(("<% getCfgZero(1,"ApCliEnable");%>"==1)||("<% getCfg2Zero(1,"ApCliEnable");%>"==1))){
				document.writeln("&nbsp;<input type=\"submit\" name=\"wizardstep1_back\" value=\"手动设置\">");
				document.writeln("&nbsp;<input type=\"submit\" name=\"wizardstep1_next\" value=\"下一步\">");
			}else{
				document.writeln("&nbsp;<input type=\"submit\" name=\"wizardstep1_next_ignore_wan_setting\" value=\"下一步\" disabled>");
			}
		</script>
        <input type="hidden" name="submit.htm?d_wizard_step1_start.asp" value="Send">
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

<script type='text/javascript'>
 mainBodyEnd();
 ThirdRowEnd();
 Footer()
 mainTableEnd()
</script>

</blockquote>
</body>

</html>

