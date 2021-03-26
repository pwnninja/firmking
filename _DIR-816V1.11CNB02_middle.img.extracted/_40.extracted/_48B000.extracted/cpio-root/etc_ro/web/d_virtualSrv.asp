<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
<script type="text/javascript" src="forbidView.js"></script>
<title>虚拟服务器</title>
<SCRIPT>
//var curTblNum=0;
//curTblNum=3;
var lanip= "<% getCfgZero(1, "lan_ipaddr"); %>";
var lanmask= "<% getCfgZero(1, "lan_netmask"); %>";
var retPort=/^([0-9]|[:]){1,15}$/;
var retNum=/^[0-9]{1,15}$/;

function portInfo(startPort, endPort, srvName)
{
	this.startPort = startPort;
	this.endPort = endPort;
	this.srvName = srvName;
}
function serverType(name,protocol,port)
{
	this.name=name;
	this.protocol=protocol;
	this.port=port;
}
var servertypes = new Array();
servertypes[0]=new serverType("AUTH",6,113);
servertypes[1]=new serverType("DNS",17,53);
servertypes[2]=new serverType("FTP",6,21);
servertypes[3]=new serverType("IPSEC",17,500);
servertypes[4]=new serverType("POP3",6,110);
servertypes[5]=new serverType("PPTP",6,1723);
servertypes[6]=new serverType("SMTP",6,25);
servertypes[7]=new serverType("SSH",6,22);
servertypes[8]=new serverType("TELNET",6,23);
servertypes[9]=new serverType("TFTP",17,69);
servertypes[10]=new serverType("WEB",6,80);

function cbClick() {
	with ( document.addVrtSrv ) {
		var idx = srvname.selectedIndex;	
		for( var i=0;i<servertypes.length;i++)
		{
		  if(srvname.options[idx].value == servertypes[i].name)
			{
				inprt.value = servertypes[i].port;
				srvprt.value = servertypes[i].port;
				if(servertypes[i].protocol==6) protocol.selectedIndex = 0;
				if(servertypes[i].protocol==17)protocol.selectedIndex = 1;
				break;
			}
		}		
	}
}

function checkOpenPort(startport, endport)
{
	var openedPort = new Array();
	var rmtaccPort = new Array();
rmtaccPort[0]=new portInfo(520,520,"rip");
rmtaccPort[1]=new portInfo(80,80,"web");
rmtaccPort[2]=new portInfo(80,80,"web");
	
	for( var i=0; i<openedPort.length; i++ )
	{
		if( ((startport>=openedPort[i].startPort) && (startport<=openedPort[i].endPort)) ||
			((endport>=openedPort[i].startPort) && (endport<=openedPort[i].endPort)) ||
			((startport<=openedPort[i].startPort) && (endport>=openedPort[i].endPort)) )
		{
			alert("你指定的端口号已经被  "+openedPort[i].srvName+"("+openedPort[i].startPort+"-"+
				openedPort[i].endPort+")占用,请重新输入 !");
			return false;
		}
	}
	for ( var i=0; i<rmtaccPort.length; i++)
	{
		if ((startport<=rmtaccPort[i].startPort) && (endport>=rmtaccPort[i].endPort))
		{
			alert("该端口号已被远程访问占用.请输入其他的端口!");
			return false;
		}
	}
	
	return true;
}

function checkPortRules(){
	var portRules = "<% getCfgGeneral(1,"PortForwardRules"); %>";
	var ruleN = new Array();                                   //将所有规则分开
	ruleN = portRules.split(';');   
	var wanport = new Array();                                 //每一条规则
	var startwanport;
	var endwanport;
	with ( document.addVrtSrv ) {
		var waninprt = inprt.value;
		var invalue = waninprt.split(":");                     //将输入的端口分开
		//alert(invalue);                                        //打印输入的wan端口
		if (waninprt.match("[:]") == null) {                   //输入的wan端口号为单个
			
			var intwaninprt = parseInt(waninprt);              //将得到的wan端口解析为10进制
			
			if (ruleN.length == 0) return ture;
			
			for (var i = 0; i < ruleN.length; i++) {
				wanport[i] = ruleN[i].split(",");              //提取出每条规则
				
				startwanport = parseInt(wanport[i][5]);        //提取出已经输入的规则的wan端口号，10进制
				endwanport = parseInt(wanport[i][6]);
				
				if ((startwanport <= intwaninprt) && (intwaninprt <= endwanport)) {
					alert("该端口号已被占用!");
					return false;
				} 
			}
		} else {                          //输入的端口号是范围
			for (var i = 0; i < ruleN.length; i++) {
				wanport[i] = ruleN[i].split(",");    //提取出每条规则
				
				var wanport0 = parseInt(invalue[0]);
				var wanport1 = parseInt(invalue[1]);
				
				startwanport = parseInt(wanport[i][5]);        //提取出已经输入的规则的wan端口号，10进制
				endwanport = parseInt(wanport[i][6]);
				
				
				if ( ((startwanport <= wanport0 && wanport0 <= endwanport) && (startwanport <=wanport1 && wanport1 <= endwanport) ) ||
					 ((startwanport >= wanport0) && (startwanport <=wanport1 && wanport1 <= endwanport) ) ||
					 ((startwanport <= wanport0 && wanport0 <= endwanport) && (wanport1 >= endwanport) )  ||
					 ((startwanport >= wanport0 ) && (wanport1 >= endwanport) )
				) {
				
					alert("该端口号已被占用!");
					return false;
				} 
			}
		}
	}
	return true;
}

//判读外部端口是否存在范围重叠的情况。

function isSameWanPort(ext_port_s,ext_port_e)
{
    var ruleStrT = '<% getCfgZero(1, "acl_rules"); %>';
	//alert("ruleStrT="+ruleStrT+" ext_port_s="+ext_port_s+"ext_port_e="+ext_port_e);
	if(ruleStrT.length != 0)
	{
	    //alert("ruleStrT.length != 0");
		var i;
		var ruleTypeNum = 1;
		var rule = new Array;
		var rule1 = new Array;

		if(ruleStrT.indexOf(";") > 0)
			ruleTypeNum = ruleStrT.match(/;/g).length+1; // 规则种类数
       // alert("ruleTypeNum="+ruleTypeNum);
		rule = ruleStrT.split(";");
		for(i = 0; i < ruleTypeNum; i++)
		{	
			rule1 = rule[i].split(",");
			//alert("ruel1[1]="+rule1[1]+"rule1[2]="+rule1[2]);
			if(rule1[1] != "web")
			{
				continue;
			}
				
			if(ext_port_s>parseInt(rule1[2]))
			{
				continue;
			}
				
			if(ext_port_e<parseInt(rule1[2]))
			{
				continue;
			}
				
			return false;
	
		
		}
		
		return true;
	}


}

function btnApply() {
	with ( document.addVrtSrv ) {		
	//add by ramen 20090609 to check server name
	     if(radiosrv[1].checked){
	     	if(!checkSpecialChar(txtsrvname.value,1))
	     	   {
	     	   	alert("非法字符.请重新输入!");
	     	   	return false;
	     	   }
		
	     }
	//end by ramen

		//add at 20090805 to check wan ip
		fromwanitf.value="any";
		
		if ( inprt.value == '' || !retPort.test(inprt.value) ) {
			msg = '广域网端口号' + inprt.value + ' 非法.';	
			alert(msg);
			return false;
		}
	
		if ( srvprt.value == '' || !retPort.test(srvprt.value) ) {
    		msg = '局域网开放端口号' + srvprt.value + '非法.';
    		alert(msg);
    		return false;
   		}
		
		var inrangevalue = inprt.value;
		var invalue = inrangevalue.split(':');
		var startPort;
		var endPort;
		var wanOpenPortRange=0;
		var wanOpenPortRangeInterval=0;
		if(inrangevalue.match("[:]") == null)
		{
			startPort=parseInt(invalue[0]);
			endPort=parseInt(invalue[0]);
		}
		else
		{
			startPort=parseInt(invalue[0]);
			endPort=parseInt(invalue[1]);
			wanOpenPortRange=1;
			wanOpenPortRangeInterval=endPort-startPort;
		}
		if (startPort > endPort || startPort<1 || endPort>65535)
		{
			msg = '非法的广域网端口号!';
			alert(msg);
			return false;
		}
		
		if(protocol.selectedIndex == 0)
		{
		  if(!isSameWanPort(startPort, endPort))
		  {
		    alert("该WAN端口号已被远程访问占用.请输入其他的端口!");
		    return false;
		  }
		}
		//if ( !checkOpenPort(startPort, endPort) ) {
		//	inprt.focus();
		//	return false;
		//}
//add by ramen to support lan port range
		inrangevalue=srvprt.value;
		invalue = inrangevalue.split(':');
		if(inrangevalue.match("[:]") == null)
		{
			startPort=parseInt(invalue[0]);
			endPort=parseInt(invalue[0]);
		}
		else
		{
		    if(!wanOpenPortRange)
			     {
							msg = '非法的局域网开放端口范围!';
							alert(msg);
							return false;
				 }
			startPort=parseInt(invalue[0]);
			endPort=parseInt(invalue[1]);

		}

		if (startPort > endPort || startPort<1 || endPort>65535)
		{
			msg = '非法的局域网开放端口号!';
			alert(msg);
			return false;
		}
		if((endPort-startPort)&&(wanOpenPortRangeInterval!=(endPort-startPort))){
		   msg="局域网及广域网的端口范围长度必须一致!";
		   alert(msg);
		   return false;
		}

		if (!checkIP(srvaddr))
			return false;
		if(srvaddr.value == lanip)
		{
		alert("不能设置AP本身的 IP地址.请输入合法IP地址.");
		srvaddr.focus();
		return false;
		}

		if (!Lan1EqLan2(srvaddr.value, lanmask, lanip, lanmask)) {
			alert('无效的LAN侧IP地址，应该与LAN地址位于同一网段内.');
			srvaddr.focus();
			return false;
		}		
	}

	if (!checkPortRules()) return false;
	
	var curTblNum=document.getElementById('curTblNum');

	if(curTblNum.value >= 12)
	{
		alert('虚拟服务器列表规则条数不得超过12条！');
		return false;
	}

	create_backmask();
	document.getElementById("loading").style.display="";
}
</script>

</head>


<body>
<blockquote>

<script language="JavaScript">
	TabHeader="高级";
	SideItem="虚拟服务器";
	HelpItem="Virtual";
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
		<td class=topheader>虚拟服务器</td>
	</tr>
	<tr>
		<td class=content>
			<p>本页面使您可以配置一个虚拟服务器, 这样其他人就可以通过网关访问相应的服务了.
            </p>
		</td>
	</tr>
</table>
<br>
<form action="/goform/form2AddVrtsrv.cgi" method=POST name="addVrtSrv">
<table id=body_header border=0 cellSpacing=0>
	<tr>
		<td class=topheader>服务类型</td>
	</tr>
	<tr>
		<td class=content>
  			<table class="formarea" border="0" cellpadding="0" cellspacing="0" width="500">
    			<tr>
                    <td class="form_label_left">
                    <input type="radio" name="radiosrv" value="0" checked>通用服务名称
                    </td>
                    <td class='form_label_right'>
                    <select name='srvname' size="1" style="width:200" onChange='cbClick()'>
		            <option value="AUTH" selected>AUTH</option>
		            <option value="DNS">DNS</option>
		            <option value="FTP">FTP</option>
		            <option value="IPSEC">IPSEC</option>
		            <option value="POP3">POP3</option>
		            <option value="PPTP">PPTP</option>
		            <option value="SMTP">SMTP</option>
		            <option value="SSH">SSH</option>
		            <option value="TELNET">TELNET</option>
		            <option value="TFTP">TFTP</option>
		            <option value="WEB">WEB</option>
		            </select>
                    </td>
                </tr>
                <tr>
                    <td class='form_label_left'>
                    <input type="radio" name="radiosrv" value="1">用户自定义服务名称
                    </td>
                    <td class='form_label_right'>
                    <input type='text' size="15" name="txtsrvname" maxlength="15">
                    </td>
                </tr>
                <tr>
                    <td class='form_label_left'>
                    协议
                    </td>
                    <td class='form_label_right'>
                    <select name='protocol' size="1" style="width:200">
                    <option value="1">TCP</option>
                    <option value="2">UDP</option>
                    </select>
                    </td>
                </tr>
          
                <tr style="
display: none;			">
                    <td class='form_label_left'>
                    WAN设置
                    </td>
                    <td class='form_label_right'>
                    <select name='wansetting' size="1" style="width:200" ONCHANGE="wansettingchange();">
                    <option value="0">接口</option>
                    <option value="1">IP地址</option>
                    </select>
                    </td>
                </tr>
                <tr id="fromwanipid" style="
display: none;			">
                    <td class='form_label_left'>
                    WAN IP地址
                    </td>
                    <td class='form_label_right'>
                    <input type='text' size="15" name="fromwanip" maxlength="15">
                    </td>
                </tr>
                 
                <tr id="wanitfselectid" style="
display: none;			">
                    <td class='form_label_left'>
                    WAN接口
                    </td>
                    <td class='form_label_right'>
                    <select name='fromwanitf' size="1" style="width:200">
<OPTION VALUE="e2" SELECTED> e2</OPTION>
                    <option value="any">任意</option>
                    </select>
                    </td>
                </tr>
              
                <tr>
                    <td class='form_label_left'>
                   WAN端口
                    </td>
                    <td class='form_label_right'>
                    <input type='text' size="15" name="inprt">(例如5001:5010)
                    </td>
                </tr>
                <tr>
                    <td class='form_label_left'>
                    LAN口开放端口
                    </td>
                    <td class='form_label_right'>
                    <input type='text' size="15" name="srvprt">
                    </td>
                </tr>
                <tr>
                    <td class='form_label_left'>
                    LAN口IP地址
                    </td>
                    <td class='form_label_right'>
                    <input type='text' size="15" name="srvaddr" maxlength="15">
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<br>
<p align=center>
<INPUT TYPE="hidden" NAME="wanIpOrItf" VALUE="itf">
<input type="submit" value="应用" name="save" onClick="return btnApply();">
</p>
<input type="hidden" name="tokenid" id="tokenid0" value="" >
</form>
<form method=POST Action="/goform/form2naptitfdel.cgi">
<INPUT TYPE="HIDDEN" NAME="actiontype" VALUE="" >
<INPUT TYPE="HIDDEN" NAME="natitfcmd" VALUE="" >
<INPUT TYPE="HIDDEN" NAME="state" VALUE="" >
<INPUT TYPE="HIDDEN" NAME="itf1" VALUE="" >
<INPUT TYPE="HIDDEN" NAME="itf2" VALUE="" >
<INPUT TYPE="HIDDEN" NAME="wanport" VALUE="" >
<INPUT TYPE="HIDDEN" NAME="instnum" VALUE="" >
<table id=body_header border=0 cellSpacing=0>
	<tr>
		<td class=topheader>当前虚拟服务器列表</td>
	</tr>
	<tr>
		<td class=content>
  			<table class=formlisting border=0>
    			<tr class=form_label_row >
                    <td class='form_label_col'>
                    <b>服务名称</b>
                    </td>
                    <td class='form_label_col'>
                    <b>协议</b>
                    </td>
                    <td class='form_label_col'>
                    <b>本地IP地址</b>
                    </td>
                    <td class='form_label_col'>
                    <b>本地端口</b>
                    </td>
                    <td class='form_label_col' style="display: none;">
                    <b>WAN侧IP地址</b>
                    </td>
                    <td class='form_label_col'>
                    <b>WAN侧端口</b>
                    </td>
                    <td class='form_label_col'>
                    <b>状态</b>
                    </td>
                    <td class='form_label_col'>
                    <b>行为</b>
                    </td>
                </tr>
				<% showVrtsrvRulesASP(); %>
			</table>
        </td>
    </tr>
</table>
<input type="hidden" name="tokenid" id="tokenid1" value="" >
<script>
    var tokenid = "<% getTokenidToRamConfig(); %>";
	console.log("[d_virtualSrv] tokenid ="+tokenid);
	
	for(var i=0;i<2;i++)
	    document.getElementById("tokenid"+i).setAttribute("value",tokenid);
</script> 
</form>
<script language="JavaScript">
function natItfActionFunc( form , actiontype, instnum){
  form.elements[0].value=actiontype;
  form.elements[6].value=instnum;
  form.submit();
 create_backmask();
 document.getElementById("loading").style.display="";
}


/*
function natItfActionFunc( form , actiontype, natitfcmd, state, itf1, itf2,wanport,instnum){
  form.elements[0].value=actiontype;
  form.elements[1].value=natitfcmd;
  form.elements[2].value=state;
  form.elements[3].value=itf1;
  form.elements[4].value=itf2;
  form.elements[5].value=wanport;
  form.elements[6].value=instnum;
  form.submit();
}
*/
</script>
<script>
	     			 document.addVrtSrv.inprt.value = servertypes[0].port;
				document.addVrtSrv.srvprt.value = servertypes[0].port;
				if(servertypes[0].protocol==6) document.addVrtSrv.protocol.selectedIndex = 0;
				if(servertypes[0].protocol==17)document.addVrtSrv.protocol.selectedIndex = 1;
	
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


