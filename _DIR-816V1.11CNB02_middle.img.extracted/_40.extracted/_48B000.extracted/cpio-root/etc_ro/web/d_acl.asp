
<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
<script type="text/javascript" src="forbidView.js"></script>
<title>访问控制</title>
<script>
var retPort=/^([0-9]|[:]){1,15}$/;
var retNum=/^[0-9]{1,15}$/;

function portInfo(startPort, endPort, srvName)
{
	this.startPort = startPort;
	this.endPort = endPort;
	this.srvName = srvName;
}
function lanAclip(selectindex,order)
{
	 this.selectindex=selectindex;
	 this.order=order;
}
var lanAclips = new Array();

function checkOpenPort(startport, endport)
{
	
}

function checkPort(port)
{
	portValue = parseInt(port);
	if ((portValue > 65535) || (portValue <= 0))
	{
		return false;
	}
	else
	{
		return true;
	}
}
function checkIpRange(startIp,endIp)
{
	if(getDigit(startIp,1)!=getDigit(endIp,1))
		return false;
	if(getDigit(startIp,2)!=getDigit(endIp,2))
		return false;
	if(getDigit(startIp,3)!=getDigit(endIp,3))
		return false;
	if(getDigit(startIp,4)>getDigit(endIp,4))
		return false;
	return true;
}

function OnHelp( page)
{
    HelpWin= window.open(page,"Help","toolbar=no,location=no,directories=no,   status=no,menubar=no,scrollbars=yes,resizable=yes,width=500,height=500");
}
function addClick()
{
    var acl_rules = '<% getCfgZero(1, "acl_rules"); %>';
    if (document.getElementById ("fromwanipid").style.display==""&&(document.formFilterEdit.aclIP.value!="0.0.0.0"&&!checkIP(  document.formFilterEdit.aclIP)))
    {
		document.formFilterEdit.aclIP.focus();
		return false;
    }
   
    if (document.formFilterEdit.aclIPend.value != "")
	{
	        if(document.formFilterEdit.aclIP.value=="0.0.0.0")
	        {
	       		alert("任意IP地址!请清除终止IP!");
	       		return false;
	       }
	       if ( !checkIP(document.formFilterEdit.aclIPend))
	         return false;    
	       if(!checkIpRange(document.formFilterEdit.aclIP.value,document.formFilterEdit.aclIPend.value))
	       {
	       	alert("IP地址范围中的起始IP必须小于或等于终止IP!");
	       	return false;
	       }
	}
	else
	{
	    if(document.formFilterEdit.wansetting.selectedIndex==1)
		{
	      alert("IP地址范围中的终止IP不能为空!");
	      return false;
	    }
	}
	
   if(document.formFilterEdit.interface.value == "lan")
    return true;
	var tcpPort=new Array(3);
	var i=0;
  if(document.formFilterEdit.localAcl_web.checked)
  {
		var patt2 = new RegExp("[wan,wanip]{0,1},web,([0-9]{1,5})","g");//(alert[^;]*)
		var result,flag = 0;
		while( (result = patt2.exec( acl_rules )) != null )
		{
			if(document.formFilterEdit.webport.value == result[1])
			{
					msg = 'web' + ' 服务重复!';
					alert(msg);
					return false;
			}
		}
		if (document.formFilterEdit.webport.value == '' || !retNum.test(document.formFilterEdit.webport.value) 
			|| false == checkPort(document.formFilterEdit.webport.value)) {
			msg = 'web' + document.formFilterEdit.webport.value + ' 非法!';
			alert(msg);
			return false;
	   }
	  tcpPort[i++]=document.formFilterEdit.webport.value;
  }
	  if(document.formFilterEdit.localAcl_ping.checked)
	  {
			if(acl_rules.match("wan,ping") || acl_rules.match("wanip,ping,0.0.0.0"))
			{
				msg = 'ping' + ' 服务重复!';
				alert(msg);
				return false;
			}
	  }  
		if(document.formFilterEdit.localAcl_telnet.checked) {
		if (document.formFilterEdit.telnetport.value == '' || !retNum.test(document.formFilterEdit.telnetport.value)
		|| false == checkPort(document.formFilterEdit.telnetport.value))
		
		{
			msg = 'telnet' + formFilterEdit.telnetport.value + ' 非法!';
			alert(msg);
			return false;
  		}
		tcpPort[i++]=document.formFilterEdit.telnetport.value;
  		}
		if(document.formFilterEdit.localAcl_tftp.checked){
			if (document.formFilterEdit.tftpport.value == '' || !retNum.test(document.formFilterEdit.tftpport.value) 
			|| false == checkPort(document.formFilterEdit.tftpport.value))
			{
				msg = 'tftp' + formFilterEdit.tftpport.value + ' is invalid!';
				alert(msg);
				return false;
	 		 }
  		}
		if(document.formFilterEdit.localAcl_ftp.checked){
			if (document.formFilterEdit.ftpport.value == '' || !retNum.test(document.formFilterEdit.ftpport.value) 
			|| false == checkPort(document.formFilterEdit.ftpport.value))		
			{
				msg = 'ftp' + formFilterEdit.ftpport.value + ' 非法!';
				alert(msg);
				return false;
	 		 }
		tcpPort[i++]=document.formFilterEdit.ftpport.value;
  		}
		if(document.formFilterEdit.localAcl_snmp.checked) {
		if (document.formFilterEdit.snmpport.value == '' || !retNum.test(document.formFilterEdit.snmpport.value)
		|| false == checkPort(document.formFilterEdit.snmpport.value))
		{
			msg = 'snmp' + formFilterEdit.snmpport.value + ' 非法!';
			alert(msg);
			return false;
  		}
  }
  //add by ramen 20090618
  //check tcp services 
  var m=0;
  for(m=0;m<i;m++)
  {
    var t=0;
	for(t=m+1;t<i;t++)
	   {
			if(tcpPort[t]==tcpPort[m])
			    {
				  alert("非法端口!多个服务占用此端口!");
				  return false;
				}
	   }
  }
//check udp services
	if(document.formFilterEdit.localAcl_tftp.checked&&document.formFilterEdit.localAcl_snmp.checked)
	{
		if(document.formFilterEdit.snmpport.value==document.formFilterEdit.tftpport.value)
		   {
					alert("非法端口!多个服务占用此端口!");
					return false;
		   }
	}
  return true;
}
function onClickAnyBtn()
{
	var objDiv = document.getElementById ("serviceTable");
	if(document.formFilterEdit.localAcl_any.checked==true)
	{
		objDiv.style.display = "none"; 
	}else
	  objDiv.style.display = "";  	  
	document.formFilterEdit.localAcl_web.checked=false;         
	document.formFilterEdit.localAcl_telnet.checked=false;
	document.formFilterEdit.localAcl_tftp.checked=false;         
	document.formFilterEdit.localAcl_ftp.checked=false;
	document.formFilterEdit.localAcl_snmp.checked=false;
	document.formFilterEdit.localAcl_web.checked=false;      
	document.formFilterEdit.localAcl_ping.checked=false; 	
}
function OnClickWebChk()
{
	var objDiv = document.getElementById ("webporttext");
	if(document.formFilterEdit.localAcl_web.checked==true&&document.formFilterEdit.interface.value=="wan")
	{
		objDiv.style.display = ""; 
	}else
	  objDiv.style.display = "none";  
	         
}
function OnClickTelnetChk()
{
	var objDiv = document.getElementById ("telnetporttext");
	if(document.formFilterEdit.localAcl_telnet.checked==true&&document.formFilterEdit.interface.value=="wan")
	{
		objDiv.style.display = ""; 
	}else
	  objDiv.style.display = "none";  
	         
}
function OnClickTftpChk()
{
	var objDiv = document.getElementById ("tftpporttext");
	if(document.formFilterEdit.localAcl_tftp.checked==true&&document.formFilterEdit.interface.value=="wan")
	{
		objDiv.style.display = ""; 
	}else
	  objDiv.style.display = "none";  
	         
}
function OnClickFtpChk()
{
	var objDiv = document.getElementById("ftpporttext");
	if (document.formFilterEdit.localAcl_ftp.checked==true && document.formFilterEdit.interface.value=="wan")
	{
		objDiv.style.display = "";
	} else
		objDiv.style.display = "none";
}
function OnClickSnmpChk()
{
	var objDiv = document.getElementById ("snmpporttext");
	if(document.formFilterEdit.localAcl_snmp.checked==true&&document.formFilterEdit.interface.value=="wan")
	{
		objDiv.style.display = ""; 
	}else
	  objDiv.style.display = "none";  
	         
}
function SelectInterface(type)
{
	if(document.formFilterEdit.interface.selectedIndex==0)//lan
	{
	 document.getElementById ("wanitfselectid").style.display="none";
   	 document.getElementById ("fromwanipid").style.display="";   	
   	 document.getElementById ("wansettingid").style.display="none";
   	 document.getElementById ("localanyid").style.display=""
   	 document.getElementById ("serviceTable").style.display="none"
   	 if(type==1) document.formFilterEdit.localAcl_any.checked=true; 
	}else //wan
	{
	 document.getElementById ("wanitfselectid").style.display="";
   	 document.getElementById ("fromwanipid").style.display="none";
   	 document.getElementById ("wansettingid").style.display="";
   	 document.getElementById ("localanyid").style.display="none"
   	 document.getElementById ("serviceTable").style.display=""
   	 document.formFilterEdit.localAcl_any.checked=false; 	

	}
	  if(type==1)       
	            	{
	            	document.formFilterEdit.aclIP.value='';
	            	document.getElementById ("webport").value = "";
	            	document.getElementById ("localAcl_web").checked = false;
	            	document.getElementById ("webporttext").style.display = "none";

	            	document.getElementById ("telnetport").value = "";
	            	document.getElementById ("localAcl_telnet").checked = false;
	            	document.getElementById ("telnetporttext").style.display = "none";

	            	document.getElementById ("tftpport").value = "";
	            	document.getElementById ("localAcl_tftp").checked = false;
	            	document.getElementById ("tftpporttext").style.display = "none";

	            	document.getElementById ("ftpport").value = "";
	            	document.getElementById ("localAcl_ftp").checked = false;
	            	document.getElementById ("ftpporttext").style.display = "none";

	            	document.getElementById ("snmpport").value = "";
	            	document.getElementById ("localAcl_snmp").checked = false;
	            	document.getElementById ("snmpporttext").style.display = "none";	  

	            	document.getElementById ("localAcl_ping").checked = false;
	            	}
	                  
	           
}
function wansettingchange()
{
    if(document.formFilterEdit.wansetting.selectedIndex==0)//interface
    {
    document.getElementById ("wanitfselectid").style.display="";
    document.getElementById ("fromwanipid").style.display="none";
 
	
    } else if(document.formFilterEdit.wansetting.selectedIndex==1)//ip address
    {
    document.getElementById ("wanitfselectid").style.display="none";
    document.getElementById ("fromwanipid").style.display="";
    document.getElementById ("iprangesecondip").style.display="inline";
     
    }
   
}

//#ifdef CONFIG_ALLOW_IP_MARK_LAN_INTERFACE
function lansettingchange()
{
	    if(document.formFilterEdit.lansetting.selectedIndex==1)//interface
	    {
		    document.getElementById ("lanitfselectid").style.display="";
		    document.getElementById ("fromwanipid").style.display="none";
		 
		
	    } else if(document.formFilterEdit.lansetting.selectedIndex==0)//ip address
	    {
		    document.getElementById ("lanitfselectid").style.display="none";
		    document.getElementById ("fromwanipid").style.display="";
	    }
   
}
//#endif

function localAclEnableCheck()
{
if(lanAclips.length<1&&document.formFilterEnable.aclEnable[0].checked==true)
{
 alert("您必须保证访问控制列表里面至少有一个局域网内部的电脑可以访问本路由器，\r\n 然后才能打开局域网接入控制能力!");
 document.formFilterEnable.aclEnable[1].checked=true;
 return false;
}
return true;
}

function LanWan(direction)
{
  if(direction == "0")
  {
    //LAN side
    document.getElementById("lanaclswitchid").style.display="";
    document.formFilterEdit.interface.value="lan";
 //#ifdef CONFIG_ALLOW_IP_MARK_LAN_INTERFACE
    if(document.getElementById("lansettingid"))
         document.getElementById("lansettingid").style.display="";
    if(document.getElementById("lanitfselectid"))
         document.getElementById("lanitfselectid").style.display="none";
//#endif
    document.getElementById("fromwanipid").style.display="";  
   	document.getElementById("localanyid").style.display="";
   	document.getElementById("wanitfselectid").style.display="none";
   	document.getElementById("wansettingid").style.display="none";
   	document.formFilterEdit.localAcl_any.checked=true;
document.getElementById ("iprangesecondip").style.display="inline";
   	if(document.formFilterEdit.localAcl_any.checked)
   	{
   	  document.getElementById("serviceTable").style.display="none";
    }else
    {
      document.getElementById("serviceTable").style.display="";
    }
  }
  if(direction == "1")
  {
    //WAN side
    document.getElementById("lanaclswitchid").style.display="none";
    document.formFilterEdit.interface.value="wan";
//#ifdef CONFIG_ALLOW_IP_MARK_LAN_INTERFACE
    if(document.getElementById("lansettingid"))
         document.getElementById("lansettingid").style.display="none";
    if(document.getElementById("lanitfselectid"))
         document.getElementById("lanitfselectid").style.display="none";
//#endif
    document.getElementById("fromwanipid").style.display="none";  
   	document.getElementById("localanyid").style.display="none";
   	document.getElementById("wanitfselectid").style.display="";   
    document.getElementById("wansettingid").style.display="";      
    document.formFilterEdit.localAcl_any.checked=false;
    document.getElementById("serviceTable").style.display="";
    document.getElementById ("iprangesecondip").style.display="none";
    	document.formFilterEdit.wansetting.selectedIndex=0;  
    document.getElementById ("wanitfselectid").style.display="";
    document.getElementById ("fromwanipid").style.display="none";
  }
  OnClickWebChk();
  OnClickTelnetChk();
  OnClickTftpChk();
  OnClickFtpChk();
  OnClickSnmpChk();
  onClickAnyBtn();
  return true;
}
function onLoad()
{
   // document.lanwancheck.noop.value="lan";
   if(document.lanwancheck.nop[0].checked==true)      
      LanWan(0); //lan    
    else
      LanWan(1);
    
}
function dwAcl(n, ip, ser, port, button)
{
	var strtd = "<TD class=form_label_col><b><p align=center><font size=\"2\"><b>";
	var str_td = "</b></font></p></b></TD>";

	dw("<TR>");
	dw( strtd + (n + 1) + str_td);
	dw( strtd + ip + str_td);
	dw( strtd + ser  + str_td);
	dw( strtd + port + str_td);
	dw( "<TD class=form_label_col><b><p align=center><INPUT TYPE=\"BUTTON\" VALUE=\"删除\" onClick=\"return LocalAclDelFunc( this.form," + n + ");\"></p></b></TD>");
	
	dw("</TR>");
}

</script>
</head>

<body onload="onLoad();">
<blockquote>

<script language="JavaScript">
	TabHeader="高级";
	SideItem="访问控制";
	HelpItem="Acl";
</script>
<script type='text/javascript'>
	mainTableStart();
	logo();
	TopNav();
	ThirdRowStart();
	Write_Item_Images();
	mainBodyStart();
</script>

<form name="lanwancheck">
	<table id=box_header border=0 cellSpacing=0>
		<tr>
			<td class=topheader>访问控制</td>
		</tr>
		
		<tr>
			<td class=content>
			<p>您可以指定在WAN端开启哪种服务.
 &nbsp;&nbsp;只有访问控制列表中的条目所指定类型的数据包才能进入AP路由器.
 &nbsp;&nbsp;只有您指定的IP或接口才能访问AP路由器上您所开放的服务.</p>
			</td>
		</tr>
	</table>

	<table id=body_header border=0 cellSpacing=0 style="display:none">
		<tr>
			<td class=topheader>访问控制配置 -- 方向选择</td>
		</tr>

		<tr>
			<td class=content align=center>
				<table class=formarea border="0" cellpadding="0" cellspacing="0" width="450">
					<tr>
						<td class=form_label_40>方向选择:&nbsp;&nbsp;</td>
						<td>
							<input type="radio" name="nop" value="lan" onClick="LanWan(0);">&nbsp;局域网&nbsp;&nbsp;&nbsp;&nbsp;						
							<input type="radio" name="nop" value="wan" checked onClick="LanWan(1);">&nbsp;广域网
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<input type="hidden" name="tokenid" id="tokenid0" value="" >
</form>
 
<form action="/goform/form2LocalAclenablecfg.cgi" method="POST" name="formFilterEnable">
<div id="lanaclswitchid" style="display:none">
	<table id=body_header border=0 cellSpacing=0>
		<tr>
			<td class=topheader>局域网访问控制开关</td>
		</tr>

		<tr>
			<td class=content align=center>
				<table class=formarea border="0" cellpadding="0" cellspacing="0" width="450">
					<tr>
						<td class=form_label_40>局域网访问控制开关:&nbsp;&nbsp;&nbsp;</td>		
						<td>
<td><font size=2><b><input type="radio" name="aclEnable" value="enable" >&nbsp;&nbsp;启用</b></font></td>
<td><font size=2><b><input type="radio" name="aclEnable" value="disable" checked>&nbsp;&nbsp;禁用 </b></font></td>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

	<p align=center>
	<input type="submit" value="应用" onClick="return localAclEnableCheck();">&nbsp;&nbsp;
	</p>
	<input type="hidden" NAME="submit.asp?d_acl.asp" value="Send">	
</div>
<input type="hidden" name="tokenid" id="tokenid1" value="" >
</form>

<form action="/goform/form2LocalAclEditcfg.cgi" method="POST" name="formFilterEdit">
	<table id=body_header border=0 cellSpacing=0>
		<tr>
			<td class=topheader>访问控制设置</td>
		</tr>

		<tr>
			<td class=content align=center>
				<table class=formarea border="0" cellpadding="0" cellspacing="0" width="450">
					<input type="hidden" NAME="enable" value="1">
					<input type="hidden" NAME="interface" value="lan">




					<tr id="wansettingid">
						<td class=form_label_40>广域网设置:</td>
						<td><select name='wansetting' size="1" style="width:200" ONCHANGE="wansettingchange();">
							<option value="0">WAN</option>
							<option value="1">IP地址</option>
							</select>
						</td>
					</tr>


					<tr id="fromwanipid" style="display:none">
						<td class=form_label_40>IP地址:</td>
						<td>
						<input type='text' size="15" name="aclIP">
						<div id="iprangesecondip" style="display:none">-
						<input type='text' size="15" name="aclIPend">(IP 0.0.0.0代表任意IP地址 )
						</td>
					</tr>

					<tr id="wanitfselectid" style="display:none">
						<td class=form_label_40 style="display:none">广域网接口:</td>
						<td style="display:none">
							<select name='fromwanitf' size="1" style="width:200"> 		
<OPTION VALUE="e2" SELECTED> e2</OPTION>
							<option value="any">所有</option>
							</select>
						</td>
					</tr>

					<tr>
						<td class=form_label_40>允许的服务:</td>
						<td></td>
					</tr>
					
					<tr id="localanyid">
						<td align=right>&nbsp;&nbsp;&nbsp;&nbsp;
						<input type="checkbox" name="localAcl_any" value="any" checked onClick="onClickAnyBtn();">
						</td>
						<td class=form_label_enabled>任意</td>
					</tr>

				</table>

				<div id="serviceTable" style="display:none">
				<table>
					<tr>
					<td >
					&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="localAcl_web" value="web" onClick="OnClickWebChk();">web &nbsp;
					</td>
					<td id="webporttext" style="display:none">
					端口:<INPUT TYPE="TEXT" value="80" NAME="webport" SIZE="5" MAXLENGTH="5" VALUE="" >
					</td>
					</tr>
					
					<tr style="display:none">
					<td >
					&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="localAcl_telnet" value="telnet" onClick="OnClickTelnetChk();">telnet &nbsp;
					</td>
					<td id="telnetporttext" style="display:none">
					端口:<INPUT TYPE="TEXT" value="23" NAME="telnetport" SIZE="5" MAXLENGTH="5" VALUE="" >
					</td>
					</tr>
					
					<tr style="display:none">
					<td >
					&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="localAcl_ftp" value="ftp" onClick="OnClickFtpChk();">ftp &nbsp;
					</td>
					<td id="ftpporttext" style="display:none">
					端口:<INPUT TYPE="TEXT" value="21" NAME="ftpport" SIZE="5" MAXLENGTH="5" VALUE="" >
					</td>
					</tr>
					
					<tr style="display:none">
					<td >
					&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="localAcl_tftp" value="tftp" onClick="OnClickTftpChk();">tftp &nbsp;
					</td>
					<td id="tftpporttext" style="display:none">
					端口:<INPUT TYPE="TEXT" value="69" NAME="tftpport" SIZE="5" MAXLENGTH="5" VALUE="" >
					</td>
					</tr>
					
					<tr style="display:none">
					<td >
					&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="localAcl_snmp" value="snmp" onClick="OnClickSnmpChk();">snmp &nbsp;
					</td>
					<td id="snmpporttext" style="display:none">
					端口:<INPUT TYPE="TEXT" value="161" NAME="snmpport" SIZE="5" MAXLENGTH="5" VALUE="" >
					</td>
					</tr>
					
					<tr>
					<td >
						&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="localAcl_ping" value="ping">ping
					</td>
					<td></td>
					</tr>
				</table>
				</div>		
				
			</td>
		</tr>
	</table>
	

	<p align=center>
	<input type="submit" value="添加" onClick="return addClick()">&nbsp;&nbsp;
	<input type="reset" value="取消" name="reset">&nbsp;&nbsp;
	<input type="hidden" NAME="submit.asp?d_acl.asp" value="Send">
	</p>
	<input type="hidden" name="tokenid" id="tokenid2" value="" >	
</form>

<form method=POST Action="/goform/form2LocalAcldel.cgi">
<INPUT TYPE="HIDDEN" NAME="acldel" VALUE="" >
<INPUT TYPE="HIDDEN" NAME="state" VALUE="" >
<INPUT TYPE="HIDDEN" NAME="aclindex" VALUE="" >

<BR>
	<table id=body_header border=0 cellSpacing=0>
		<tr>
			<td class=topheader>访问控制列表</td>
		</tr>

		<tr>
			<td class=content>
				<table class=formlisting border=0>
					<tr class=form_label_row>
						<td class=form_label_col>序号</td>
						<td class=form_label_col  style="display:none">方向</td>
						<td class=form_label_col>IP地址/接口</td>
						<td class=form_label_col>服务</td>
						<td class=form_label_col>端口</td>
						<td class=form_label_col>行为</td>
					</tr>
<script language="javascript">
/*
$acl_rules="
wan,web,80;
wan,ping;
wanip,web,80,10.10.1.11-10.10.1.13;
wanip,ping,10.10.1.11-10.10.1.13;
wanip,web,80,0.0.0.0;
wanip,ping,0.0.0.0;
"
*/
var acl_rules = '<% getCfgZero(1, "acl_rules"); %>';
var rules = acl_rules.split(";");
for(var i = 0; i < rules.length; i++)
{
	rule = rules[i].split(",");
	if(rule[0] == "wan")
	{
		if(rule[1] == "ping"){
			dwAcl(i , "WAN", rule[1], "--", rules[i]);
		}else{
			dwAcl(i , "WAN", rule[1], rule[2], rules[i]);
		}
	}else if(rule[0] == "wanip"){
		if(rule[1] == "ping"){
			dwAcl(i , rule[2], rule[1], "--", rules[i]);
		}else{
			dwAcl(i , rule[3], rule[1], rule[2], rules[i]);
		}
	}
}
</script>
				
				</table>
			</td>
		</tr>
	</table>
				
<script language="JavaScript">

function deleteAclip(id)
{
if(0){
if(lanAclips.length==1&&lanAclips[0].selectindex==id)
   {
   alert("您必须保证访问控制列表里面至少有一个局域网内部的电脑可以访问本路由器，\r\n 然后才能打开局域网接入控制能力!");
   return false;
   }
}
  return true;
}

function LocalAclDelFunc( form, aclindex)
{
  form.elements[2].value=aclindex;
  form.submit();
  create_backmask();
  document.getElementById("loading").style.display="";
  return true;

}

</script>
<input type="hidden" NAME="submit.asp?d_acl.asp" value="Send">
<input type="hidden" name="tokenid" id="tokenid3" value="" >
<script>
    var tokenid = "<% getTokenidToRamConfig(); %>";
	console.log("[d_acl] tokenid ="+tokenid);
	
	for(var i=0;i<4;i++)
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

