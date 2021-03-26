<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
<script type="text/javascript" src="forbidView.js"></script>
<title>端口触发</title>

<SCRIPT language=javascript>
TOTAL_ROW = 8;
remain = 31;
var appName = "";
NO_SEL_MSG = '请选择某一项应用';
RE_ALL_MSG = '请输入正确的匹配及相关端口';

function initValue()
{
	var portTrigEn = "<% getCfgZero(1, "PortTriggerEnable"); %>";
	if(portTrigEn == "1") {
		document.form2Trigger.pt_status[0].checked = true;   // 启用
	} else {
	  document.form2Trigger.pt_status[1].checked = true;	 // 禁用
	}
}

function saveClick()
{
	if(document.form2Trigger.pt_status[0].checked == true) {
		document.form2Trigger.pt_status.value = 1;   	// 启用
	} else {
		document.form2Trigger.pt_status.value = 0;		// 禁用
	}
	document.form2Trigger.submit();
	create_backmask();
	document.getElementById("loading").style.display="";
	return true;
}

function isValidPort(port) {
   var fromport = 0;
   var toport = 100;

   portrange = port.split(':');
   if ( portrange.length < 1 || portrange.length > 2 ) {
       return false;
   }
   if ( isNaN(portrange[0]) )
       return false;
   fromport = parseInt(portrange[0]);
   
   if ( portrange.length > 1 ) {
       if ( isNaN(portrange[1]) )
          return false;
       toport = parseInt(portrange[1]);
       if ( toport <= fromport )
           return false;      
   }
   
   if ( fromport < 1 || fromport > 65535 || toport < 1 || toport > 65535 )
       return false;
   
   return true;
}

function clearAll()
{
   with (document.form2PortriggerRule) {
      for (i = 0; i < TOTAL_ROW; i++) {
         matchPort_s[i].value = matchPort_e[i].value = relatePort_s[i].value = relatePort_e[i].value = "";
         protocol[i].value = oProto[i].value = 1;
				 //dir[i].value = 1;
      }
   }
}

function appSelect(v)
{
   clearAll();
   with (document.form2PortriggerRule) {
      switch(v) {
      case '0':
         AppName.selectedIndex = 0;
         AppName.options[0].value = "0";
         appName = "";
         break;                                  //trigger   open
      case "Aim Talk":   //  Aim Talk                   TCP 4099,  TCP 5191
         appName = "Aim Talk";
         matchPort_s[0].value = matchPort_e[0].value = 4099;
         relatePort_s[0].value = relatePort_e[0].value = 5191;
				 protocol[0].value = oProto[0].value = 1;
         break;
      case "Asheron's Call":  // Asheron's Call                UDP 9000-9013, UDP 9000-9013
         appName = "Asheron's Call";
         matchPort_s[0].value = relatePort_s[0].value = 9000;
         matchPort_e[0].value = relatePort_e[0].value = 9013;
         protocol[0].value = oProto[0].value = 2;
         break;
      case "Calista IP Phone":  //Calista IP Phone               TCP 5190, UDP 3000
         appName = "Calista IP Phone";
         matchPort_s[0].value = matchPort_e[0].value = 5190;
         relatePort_s[0].value = relatePort_e[0].value = 3000;
         protocol[0].value = 1;
				 oProto[0].value = 2;
         break;
      case "Delta Force (Client/Server)":  //Delta Force (Client/Server)    UDP 3568, BOTH 3100-3999
         appName = "Delta Force (Client/Server)";
         matchPort_s[0].value = matchPort_e[0].value = 3568;
         protocol[0].value = 2;
         relatePort_s[0].value = 3100;
         relatePort_e[0].value = 3999;
         oProto[0].value = 3;
         break;
      case "ICQ":  //ICQ                            UDP 4000, TCP 20000-20059
         appName = "ICQ";
         matchPort_s[0].value = matchPort_e[0].value = 4000;
         protocol[0].value = 2;
         relatePort_s[0].value = 20000;
         relatePort_e[0].value = 20059;
				 oProto[0].value = 1;
         break;
      case "Napster":  //Napster                        TCP 6699, TCP 6699, 6697, 4444, 5555, 6666, 7777, 8888
         appName = "Napster";
         matchPort_s[0].value = matchPort_e[0].value = matchPort_s[1].value = matchPort_e[1].value = matchPort_s[2].value = matchPort_e[2].value = 
         matchPort_s[3].value = matchPort_e[3].value = matchPort_s[4].value = matchPort_e[4].value = matchPort_s[5].value = matchPort_e[5].value = 
         matchPort_s[6].value = matchPort_e[6].value = 6699;
         relatePort_s[0].value = relatePort_e[0].value = 6699;
         relatePort_s[1].value = relatePort_e[1].value = 6697;
         relatePort_s[2].value = relatePort_e[2].value = 4444;
         relatePort_s[3].value = relatePort_e[3].value = 5555;
         relatePort_s[4].value = relatePort_e[4].value = 6666;
         relatePort_s[5].value = relatePort_e[5].value = 7777;
         relatePort_s[6].value = relatePort_e[6].value = 8888;
				 protocol[0].value = oProto[0].value = 1;
				 protocol[1].value = oProto[1].value = 1;
				 protocol[2].value = oProto[2].value = 1;
				 protocol[3].value = oProto[3].value = 1;
				 protocol[4].value = oProto[4].value = 1;
				 protocol[5].value = oProto[5].value = 1;
				 protocol[6].value = oProto[6].value = 1;
         break;
      case "Net2Phone":   // Net2Phone                      UDP 6801, UDP 6801
         appName = "Net2Phone";
         matchPort_s[0].value = matchPort_e[0].value = 6801;
         protocol[0].value = 1;
         relatePort_s[0].value = relatePort_e[0].value = 6801;
         oProto[0].value = 2;
         break;
      case "QuickTime 4 Client":  //  QuickTime 4 Client             TCP 554, UDP 6970-32000 // 2). TCP 554, BOTH 6970-7000
         appName = "QuickTime 4 Client";
         matchPort_s[0].value = matchPort_e[0].value = matchPort_s[1].value = matchPort_e[1].value = 554;
         relatePort_s[0].value = relatePort_s[1].value = 6970;
         relatePort_e[0].value = 32000;
         relatePort_e[1].value = 7000;
         protocol[0].value = protocol[1].value =1;
         oProto[0].value=oProto[1].value = 2;
         break;
      case "Rainbow Six/RogueSpear":   // Rainbow Six/Rogue Spear        TCP 2346, BOTH 2436-2438
         appName = "Rainbow Six/Rogue Spear";
         matchPort_s[0].value = matchPort_e[0].value = 2346;
         relatePort_s[0].value = 2436;
         relatePort_e[0].value = 2438;
				 protocol[0].value =1;
         oProto[0].value = 3;
         break;
      default:
         alert('选中项不支持');
      }
   }  
}

function radioClick()
{
   with (document.form2PortriggerRule) {
      if (radiosrv[0].checked == true)
         txtAppName.value = '';
   }
   appSelect("0");
}

function btnApply()
{
   var loc = "";
   with ( document.form2PortriggerRule)
   {
      if (radiosrv[0].checked == true)
      {
				if (encodeURI(appName) == '') {
					alert(NO_SEL_MSG);
					return;
				}
				appName=appName.replace(/(^\s*)/g, ""); 
				appName=appName.replace(/(\s*$)/g, ""); 
				//appName=appName.split(/\s+/,1);
				//appName=appName.replace(/(\s)/g, "&nbsp;");
      }
      else
      {
				if (encodeURI(txtAppName.value) == '') {     
				  alert('请输入一个应用程序名字');
				  return;
				}
		    /*
				if(!checkSpecialCharForURL(txtAppName.value, 1))
				{
					alert("服务名称非法!");
					txtAppName.focus();
					return;		
				}
				*/
				txtAppName.value=txtAppName.value.replace(/(^\s*)/g, ""); 
				txtAppName.value=txtAppName.value.replace(/(\s*$)/g, ""); 
				//txtAppName.value=txtAppName.value.split(/\s+/,1);
				//txtAppName.value=(txtAppName.value).replace(/(\s)/g, "&nbsp;");
      }

      for (i = 0; i < TOTAL_ROW; i++) {
         if (matchPort_s[i].value == "" && matchPort_e[i].value == "" && relatePort_s[i].value == "" && relatePort_e[i].value == "")
            break;
         if (matchPort_s[i].value == "" || matchPort_e[i].value == "" || relatePort_s[i].value == "" || relatePort_e[i].value == "") {
            alert(RE_ALL_MSG);
            return;
         }
      }
      if (i == 0) {
         alert(RE_ALL_MSG);
         return;
      }
      if (i > remain) {
         remain = i - remain;
         alert('xxxx' + remain);
         remain = 31;
         return;
      }
      
      var eCount = i;    
      for (i = 0; i < eCount; i++) {
         if ( isValidPort(matchPort_s[i].value) == false ) {
            alert('起始触发端口"' + matchPort_s[i].value + '"非法.');
            return;
         }
         if ( isValidPort(matchPort_e[i].value) == false ) {
            alert('终止触发端口"' + matchPort_e[i].value + '"非法.');
            return;
         }
         if ( isValidPort(relatePort_s[i].value) == false ) {
            alert('起始相关端口"' + relatePort_s[i].value + '"非法.');
            return;
         }
         if ( isValidPort(relatePort_e[i].value) == false ) {
            alert('终止相关端口"' + relatePort_e[i].value + '"非法.');
            return;
         }
         var tS = parseInt(matchPort_s[i].value);
         var tE = parseInt(matchPort_e[i].value);
         if (tS > tE) {
            alert('开放端口范围[' + tS + '-' + tE + ']非法.');
            return;
         }
         var oS = parseInt(relatePort_s[i].value);
         var oE = parseInt(relatePort_e[i].value);
         if ( oS > oE ) {
            alert('相关端口范围[' + oS + '-' + oE + ']非法.');
            return;
         }
      }
      subnum.value = i;
   }
	 document.form2PortriggerRule.submit();
	 create_backmask();
	document.getElementById("loading").style.display="";
}
</script>
<link href="d_stylemain.css" rel="stylesheet" type="text/css">
</head>

<body onLoad="initValue()">
<blockquote>

<script language="JavaScript">
	TabHeader="高级";
	SideItem="端口触发";
	HelpItem="PortTriggering";
</script>
<script type='text/javascript'>
	mainTableStart();
	logo();
	TopNav();
	ThirdRowStart();
	Write_Item_Images();
	mainBodyStart();
</script>

<table id="box_header" border=0 cellSpacing=0>
	<tr>
		<td class="topheader">端口触发</td>
	</tr>
	<tr>
		<td class="content">
			<p>端口触发表用于限制本地网络发出的特定类型的数据包到达因特网.使用这样的过滤器能有效的保护及限制你的本地网络。</p>
		</td>
	</tr>
</table>


<form action="/goform/form2NatPortriggerStatus.cgi" method=POST name="form2Trigger">
<table id="body_header" border="0" cellSpacing="0">
	<tr>
		<td class="topheader">端口触发状态</td>
	</tr>
	<tr>
		<td class="content" align="left">
			<table class="formarea" border="0" cellpadding="0" cellspacing="0" width="500">
				<tr>
					<td class="form_label_left"><b>端口触发:</b></td>
					<td class="form_label_right">
						<input type="radio" name="pt_status" value="1">启用&nbsp;&nbsp;
						<input type="radio" name="pt_status" value="0">禁用&nbsp;&nbsp;
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<br>
<p align=center>
<input type="submit" value="应用" onClick="return saveClick()">&nbsp;&nbsp;
<input type="hidden" NAME="submit.asp?d_nat_portrigger.asp" value="Send">
</p>
<input type="hidden" name="tokenid" id="tokenid0" value="" >
</form>

<form action="/goform/form2PortriggerRule.cgi" method=POST name="form2PortriggerRule">
<table id="body_header" border="0" cellSpacing="0">
	<tr>
		<td class="topheader">服务类型</td>
	</tr>
	<tr>
		<td class="content" align="left">
			<table class="formarea" border="0" cellpadding="0" cellspacing="0" width="500">
				<tr>
					<td class="form_label_radio" style="text-align:left"><input type="radio" name="radiosrv" value="0" onClick="radioClick();" checked>通用服务名称:</td>
					<td>
						<select onchange=appSelect(this.value) size=1 name=AppName> 
          		<option value=0 selected>请选择</option>
							<option value="Aim Talk">Aim Talk</option>
							<option value="Asheron's Call">Asheron's Call</option>
							<option value="Calista IP Phone">Calista IP Phone</option>
							<option value="Delta Force (Client/Server)">Delta Force (Client/Server)</option>
							<option value="ICQ">ICQ</option>
							<option value="Napster">Napster</option>
							<option value="Net2Phone">Net2Phone</option>
							<option value="QuickTime 4 Client">QuickTime 4 Client</option> 
							<option value="Rainbow Six/RogueSpear">Rainbow Six/RogueSpear</option>
						</select>
					</td>
				</tr>

				<tr>
					<td class="form_label_radio" style="text-align:left; width:220px"><input type="radio" name="radiosrv" value="1">用户自定义服务名称:</td>
					<td><input type="text" size="30" name="txtAppName" maxlength="32" onKeyUp="value=value.replace(/[\W]/g,'')"></td>
				</tr>
			</table>
			<br>
			<table class="formarea" border="0" cellpadding="0" cellspacing="0" width="610">
				<TR align=left>
					<TD class=hd>起始匹配端口</TD>
					<TD class=hd>终止匹配端口</TD>
					<TD class=hd>触发协议</TD>
					<TD class=hd>起始相关端口</TD>
					<TD class=hd>终止相关端口</TD>
					<TD class=hd>开放协议</TD>
					<!-- <TD class=hd>NAT类型</TD> -->
				</TR>
				<script language="JavaScript" type="text/javascript">
					var i;
					for(i = 0; i < 8; i++)
					{
						document.write("<TR>");
						document.write("<TD><INPUT size=7 name=matchPort_s></TD>");
						document.write("<TD><INPUT size=7 name=matchPort_e></TD>");
						document.write("<TD>");
						document.write("<SELECT name=protocol>");
						document.write("<OPTION value=2 selected>UDP</OPTION>");
						document.write("<OPTION value=1>TCP</OPTION>");
						document.write("<OPTION value=3>TCP/UDP</OPTION>");
						document.write("</SELECT>");
						document.write("</TD> ");
						document.write("<TD><INPUT size=7 name=relatePort_s></TD>");
						document.write("<TD><INPUT size=7 name=relatePort_e></TD>");
						document.write("<TD>");
						document.write("<SELECT name=oProto>");
						document.write("<OPTION value=2 selected>UDP</OPTION>");
						document.write("<OPTION value=1>TCP</OPTION>");
						document.write("<OPTION value=3>TCP/UDP</OPTION>");
						document.write("</SELECT>");
						document.write("</TD>");
						/*
						document.write("<TD>");
						document.write("<SELECT name=dir>");
						document.write("<OPTION value=1 selected>上行</OPTION>");
						document.write("<OPTION value=0 >下行</OPTION>");
						document.write("</SELECT>");
						document.write("</TD>");
						*/
						document.write("</TR>");
					}
				</script>
			</table>
		</td>
	</tr>
</table>
<p align=center>
<input type="button" value="应用" name="save" onClick="return btnApply();">&nbsp;&nbsp;
<input name="subnum" type="hidden" value="">
</p>
<input type="hidden" name="tokenid" id="tokenid1" value="" >
</form>

<form name="currentList" method=POST action="/goform/form2PortriggerRuleDelete.cgi">
	<input type="hidden" name="ruleType" value="">
	<input type="hidden" name="rule" value="">
	<table id="body_header" border="0" cellspacing="0">
		<tr>
			<td class="topheader">当前端口触发表</td>
		</tr>
		<tr>
			<td class="content" align="left">
				<table class="formlisting" border="0" cellpadding="0" cellspacing="0" width="500">
					<tr class="form_label_row">
						<td class="form_label_col">服务名称</td>
						<td class="form_label_col">触发协议</td>
						<!-- <td class="form_label_col">方向</td> -->
						<td class="form_label_col">匹配端口</td>
						<td class="form_label_col">开放协议</td>
						<td class="form_label_col">相关端口</td>
						<td class="form_label_col">动作</td>
					</tr>
					<script language="JavaScript" type="text/javascript">
						var PROTOCL = new Array("","TCP","UDP","TCP/UDP");
						var DIRECTION = new Array("下行","上行");
						//var ruleStr="Dialpad|1|7175,7175,1,51200,51201,1|7175,7175,1,51210,51210,1|;Napster|1|6699,6699,1,6699,6699,1,1|6699,6699,1,6697,6697,1,1|6699,6699,1,4444,4444,1,1|6699,6699,1,5555,5555,1,1|6699,6699,1,6666,6666,1,1|6699,6699,1,7777,7777,1,1|6699,6699,1,8888,8888,1,1|";
						var ruleStr="<% getCfgGeneral(1, "PortTriggerRules"); %>";
			  		if(ruleStr.length != 0)
			  		{
				  		var i,j;
				  		var ruleTypeNum = 1;
				  		var rule = new Array;
				  		var rule1 = new Array;
							var rule2 = new Array;

				  		if(ruleStr.indexOf(";") > 0)
				  			ruleTypeNum = ruleStr.match(/;/g).length+1; // 规则种类数

				  		rule = ruleStr.split(';');
				  		for(i = 0; i < ruleTypeNum; i++)
				  		{
								var ruleNum = rule[i].match(/\|/g).length - 2;
								
								rule1 = rule[i].split('|');
								for(j = 0; j < ruleNum; j++)
								{
									rule2 = rule1[j+2].split(',');
									document.write("<tr>");
									document.write("<td align='center' bgcolor='#C0C0C0'><b>"+rule1[0]+"</b></td>");
									document.write("<td align=\"center\" bgcolor=\"#C0C0C0\"><b>"+PROTOCL[rule2[2]]+"</b></td>");
									/* document.write("<td align=\"center\" bgcolor=\"#C0C0C0\"><b>"+DIRECTION[rule2[6]]+"</b></td>");*/
									document.write("<td align=\"center\" bgcolor=\"#C0C0C0\"><b>"+rule2[0]+"-"+rule2[1]+"</b></td>");
									document.write("<td align=\"center\" bgcolor=\"#C0C0C0\"><b>"+PROTOCL[rule2[5]]+"</b></td>");
									document.write("<td align=\"center\" bgcolor=\"#C0C0C0\"><b>"+rule2[3]+"-"+rule2[4]+"</b></td>");
									document.write("<td align=\"center\" bgcolor=\"#C0C0C0\"><b><input type='button' value='删除' onClick=\"natPortriggerActionFunc("+ i + "," + j +");\"></b></td>");
									document.write("</tr>");
								}
							}
						}
					</script>
				</table>
			</td>
		</tr>
	</table>
	<br>
	<input type="hidden" name="submit.asp?d_nat_portrigger.asp" value="Send" >
	<input type="hidden" name="tokenid" id="tokenid2" value="" >
    <script>
    var tokenid = "<% getTokenidToRamConfig(); %>";
	console.log("[d_nat_portrigger] tokenid ="+tokenid);
	
	for(var i=0;i<3;i++)
	    document.getElementById("tokenid"+i).setAttribute("value",tokenid);
    </script> 
</form>

<script language="JavaScript">
function natPortriggerActionFunc(n,m)
{
  document.currentList.ruleType.value = n;
  document.currentList.rule.value = m;
  document.currentList.submit();
  create_backmask();
  document.getElementById("loading").style.display="";
}

</script>
<script type='text/javascript'>
	mainBodyEnd();
	ThirdRowEnd();
	Footer()
	mainTableEnd()
</script>

</blockquote>
</body>
</html>


