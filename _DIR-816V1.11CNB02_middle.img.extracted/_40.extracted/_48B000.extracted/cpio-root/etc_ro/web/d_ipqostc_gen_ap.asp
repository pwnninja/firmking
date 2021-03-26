<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
<script type="text/javascript" src="forbidView.js"></script>
<TITLE>QoS设置</TITLE>
<STYLE type=text/css>
.STYLE1 {color: #FF0000}
</STYLE>
<SCRIPT language="javascript" type="text/javascript">
var lanip="192.168.1.1";
var lanmask="255.255.255.0";
var numReg=/^[0-9]+$/;

function getSumOfUpRateCeiling()
{
        var qosTbl=document.getElementById('qosTable');
        var rows=qosTbl.rows;
	var sumUpRateCeiling = 0;
	
        for(var i=2;i<rows.length;i++)
	{		
		sumUpRateCeiling += parseInt(rows[i].cells[4].innerText);
		//sumUpRateCeiling += parseInt(rows[i].cells[8].innerText); //because something display none
        }

	return sumUpRateCeiling;
}

function getSumOfDownRateCeiling()
{
  	var qosTbl=document.getElementById('qosTable');
        var rows=qosTbl.rows;
	var sumDownRateCeling = 0;

	for(var i=2;i<rows.length;i++)
	{		
		sumDownRateCeling += parseInt(rows[i].cells[5].innerText);
		//sumDownRateCeling += parseInt(rows[i].cells[9].innerText); //because something display none 
        }

	return sumDownRateCeling;
}

function on_apply_bandwidth()
{

	
	var total=parseInt(document.qostc.total.value);
	var downtotal=parseInt(document.qostc.downtotal.value);
    
	if(document.qostc.tcauto.checked==true)
	{
	  document.qostc.tcauto.value='1';
	}
	else
	{
	  document.qostc.tcauto.value='0';
	}
	
	if (document.qostc.tcauto.checked == false && document.qostc.total.value != "")
	{
		if(getSumOfUpRateCeiling() > total && total != 0)
		{
			alert("所有规则的上行最大带宽总和不能大于上行总带宽!");
			document.qostc.total.focus();
			return false;
		}
		
	}
	if (document.qostc.tcauto.checked == false && document.qostc.downtotal.value != "")
	{
		if(getSumOfDownRateCeiling() > downtotal && downtotal != 0)
		{
			alert("所有规则的下行最大带宽总和不能大于下行总带宽!");
			document.qostc.downtotal.focus();
			return false;
		}
	}
	
	
	if ( document.qostc.total.value!="" ) {
		if ( !numReg.exec( document.qostc.total.value )) 
		{
			alert("上行带宽无效!");
			document.qostc.total.focus();
			return false;
		}
	}	
	if ( document.qostc.downtotal.value!="" ) {
		if (!numReg.exec( document.qostc.downtotal.value )) 
		{
			alert("下行带宽无效!");
			document.qostc.downtotal.focus();
			return false;
		}
	}

	/*
	if ( document.qostc.pppoe.value!="" ) {
		if ( validateKey( document.qostc.pppoe.value ) == 0 ) {
			alert("PPPoE 接口带宽无效!");
			document.qostc.pppoe.focus();
			return false;
		}
	}

	if ( document.qostc.ipoa.value!="" ) {
		if ( validateKey( document.qostc.ipoa.value ) == 0 ) {
			alert("PPPoA 接口带宽无效!");
			document.qostc.ipoa.focus();
			return false;
		}
	}

	if ( document.qostc.ipoe.value!="" ) {
		if ( validateKey( document.qostc.ipoe.value ) == 0 ) {
			alert("IPoE 接口带宽无效!");
			document.qostc.ipoe.focus();
			return false;
		}
	}

	*/
	create_backmask();
	document.getElementById("loading").style.display="";
	return true;
}

function onSelProt()
{
	with(document.qostcrule) {
		if (proto.selectedIndex >= 2)
		{
			sport.disabled = false;
			dport.disabled = false;
		} else {
			sport.disabled = true;
			dport.disabled = true;
		}
	}
}

function on_Add()
{
	if (document.getElementById){  // DOM3 = IE5, NS6
		document.getElementById('tcrule').style.display = 'block';
	} else {
		if (document.layers == false) {// IE4
			document.all.tcrule.style.display = 'block';
		}
	}
	onSelProt();
}

function saveClick(rml)
{
	var lst = '';

	if (ruleStr.length)
	{
		var flag = 0;
		if (rml.length > 0) 
		{
			for (i = 0; i < rml.length; i++) 
			{
				if ( rml[i].checked == true )
				{
					lst += rml[i].value + ',';
					flag = 1;
				}
			}
		}
		else if ( rml.checked == true )
		{
			lst += rml.value+',';
			flag = 1;
		}
		document.qostcruledel.removeRuleList.value = lst;
		
		if (flag == 1)
		{
			if (!confirm('确定要删除该条目？'))
			{
				return false;
			}
			else
			{
				create_backmask();
				document.getElementById("loading").style.display="";
				return true;
			}
		}
		else if (flag == 0)
		{
			alert("请选择删除条目");
			return false;
		}
	}
	else
	{
		alert("规则列表为空！");
		return false;
	}	

}

//2015-02-27 linsd add the function to compare ip. 
function isSameLanIp(lanip)
{
    var ruleStrT = '<% getCfgZero(1, "ip_ctl_carrules"); %>';
	if(ruleStrT.length != 0)
	{
		var i;
		var ruleTypeNum = 0;
		var rule = new Array;
		var rule1 = new Array;

		if(ruleStrT.indexOf(";") > 0)
			ruleTypeNum = ruleStrT.match(/;/g).length; // 规则种类数
        //alert("ruleTypeNum="+ruleTypeNum);
		rule = ruleStrT.split(";");
		for(i = 0; i < ruleTypeNum; i++)
		{	
			rule1 = rule[i].split(",");
			//alert("ruel1[3]="+rule1[3] + " - lanip=" + lanip);

			if(lanip == rule1[3]) //compare src ip
			{
				return false;
			}
	
		
		}
		
		return true;
	}


}

function on_apply()
{
	var total=parseInt(document.qostc.total.value);
	var downtotal=parseInt(document.qostc.downtotal.value);

	with(document.qostcrule) 
	{
		
		if ((srcip.value=="") && (dstip.value=="") && (sport.value=="") && (dport.value=="") && 
			(proto.value==0))
		{
			alert("规则不完整,请重新填写!");
			return false;
		}

		if ( srcip.value!="" )
		{
			if (validateKey( srcip.value ) == 0 ||
				!checkDigitRange(srcip.value,2,0,255) ||
				!checkDigitRange(srcip.value,3,0,255) ||
				!checkDigitRange(srcip.value,4,0,254) ||
				!checkDigitRange(srcip.value,1,0,223) ) 
			{
				alert("无效的源IP地址!");
				srcip.focus();
				return false;
			}

			if(!isSameLanIp(srcip.value))
			{
				alert("重复的源IP地址!");
				srcip.focus();
				return false;			
			}
			
		}

		if(srcnetmask.value!="" )
		{
			if(!checkMask(srcnetmask))
			{
				return false;
			}
		}		

		if ( dstip.value!="" )
		{
			if (validateKey( dstip.value ) == 0 ||
				!checkDigitRange(dstip.value,2,0,255) ||
				!checkDigitRange(dstip.value,3,0,255) ||
				!checkDigitRange(dstip.value,4,0,254) ||
				!checkDigitRange(dstip.value,1,0,223) )
			{
				alert("无效的目的IP地址!");
				dstip.focus();
				return false;
			}
		}

		if(dstnetmask.value!="" )
		{
			if(!checkMask(dstnetmask))
			{
				return false;
			}
		}		

		if ( sport.value!="" )
		{
			var Sport=parseInt(sport.value);		
			if(!numReg.exec(sport.value )|| Sport <0 || Sport > 65536)
			{
				sport.focus();
				alert("源端口 "+ sport.value + " 无效!");

				return false;
			}
			
			if (Sport > 0 && Sport < 65535)
			{
				if (proto.value < 2) {
					sport.focus();
					alert("请指定 协议TCP/UDP!");
					return false;
				}
			}
		}

		if ( dport.value!="" )
		{
			var Dport=parseInt(dport.value);
			if(!numReg.exec(dport.value ) || Dport <0 || Dport > 65536)
			{
				dport.focus();
				alert("目的端口 "+ dport.value + " 无效!");
				return false;
			}
			if (Dport > 0 && Dport<65535)
			{
				if (proto.value < 2) {
					dport.focus();
					alert("请指定 协议TCP/UDP!");
					return false;
				}
			}
		}
		
		var UprateFloor=parseInt(uprateFloor.value);
		if(!numReg.exec(uprateFloor.value ) || UprateFloor<=0)
		{
			uprateFloor.focus();
			alert("请填入大于0的整数!");
			return false;
		}

		var UprateCeiling=parseInt(uprateCeiling.value);
		if(!numReg.exec(uprateCeiling.value ) || UprateCeiling<=0)
		{
			uprateCeiling.focus();
			alert("请填入大于0的整数!");
			return false;
		}

		if(total > 0 && UprateCeiling > total)
		{
			uprateCeiling.focus();
			alert("上行最大带宽不能大于上行总带宽!");
			return false;
		}		
		
		if(UprateFloor > UprateCeiling)
		{
			uprateFloor.focus();
			alert("上行最小带宽不能大于上行最大带宽!");
			return false;
		}
		
		var DownrateFloor=parseInt(downrateFloor.value);
		if(!numReg.exec(downrateFloor.value ) || DownrateFloor<=0)
		{
			downrateFloor.focus();
			alert("请填入大于0的整数!");
			return false;
		}
		
		var DownrateCeiling=parseInt(downrateCeiling.value);
		if(!numReg.exec(downrateCeiling.value ) || DownrateCeiling<=0)
		{
			downrateCeiling.focus();
			alert("请填入大于0的整数!");
			return false;
		}
		if(downtotal > 0 && DownrateCeiling > downtotal)
		{
			downrateCeiling.focus();
			alert("下行最大带宽不能大于下行总带宽!");
			return false;
		}		
		if(DownrateFloor > DownrateCeiling)
		{
			downrateFloor.focus();
			alert("下行最小带宽不能大于下行最大带宽!");
			return false;
		}
		if(total != 0 && (total - UprateCeiling) < getSumOfUpRateCeiling())
		{
			alert("所有规则的上行最大带宽总和不能大于上行总带宽!");
			return false;
		}
		if(downtotal !=0 && (downtotal - DownrateCeiling) < getSumOfDownRateCeiling())
		{
			alert("所有规则的下行最大带宽总和不能大于下行总带宽!");
			return false;
		}
		create_backmask();
		document.getElementById("loading").style.display="";
		return true;
	}
}
</SCRIPT>
</head>

<body>
<blockquote>

<script language="JavaScript">
	TabHeader="高级";
	SideItem="QoS设置";
	HelpItem="Qos_tc";
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
		<td class="topheader">QoS设置</td>
	</tr>
	<tr>
		<td class="content">
			<p> 此页面用于配置QoS带宽和规则.<br>
			</p>
		</td>
	</tr>
</table>
<form action="/goform/form2IPQoSTcRate" method=POST name=qostc>
<table id="body_header" border="0" cellSpacing="0">
	<tr>
		<td class="topheader">QoS设置</td>
	</tr>

	<tr>
		<td class="content" align="left">
			<table class="formarea" border="0" cellpadding="0" cellspacing="0" width="500">
				<tr>
					<td class="form_label_left">总带宽(0表示没有限制):
					</td>
					<td class="form_label_right">上行带宽
						<input type="text" name=total id=total size="6" maxlength="6" value="0">kbps
    					</td>
        				<td class="form_label_right">下行带宽
        					<input type="text" name=downtotal id=downtotal size="6" maxlength="6" value="0">kbps
    					</td>    
  				</tr>
			</table>
		</td>
	</tr>

	<tr style="display:none">
		<td class="content" align="left">
			<table class="formarea" border="0" cellpadding="0" cellspacing="0" width="500">
				<tr>
					<td class="form_label_left"><label>启用自动带宽:<input type="checkbox" name="tcauto" value ="0"  id="tcauto" 
					onclick="onClickTcAuto()" ></label>
					</td>
					<td class="form_label_right">&nbsp;
						
    					</td>
  				</tr>
			</table>
		</td>
	</tr>

</table>

<p align=center>
<input type="submit" name="applyItflimit" onClick="return on_apply_bandwidth();" value="应用">
<input type="hidden" value="Send" name="submit.htm?ipqostc_gen_ap.htm">
</p>
<input type="hidden" name="tokenid" id="tokenid0" value="" >
</form>

<form action="/goform/form2IPQoSTcDel" method=POST name=qostcruledel>
<div id="tcruletable" style="display:block">

<table id=body_header border=0 cellSpacing=0>
	<tr>
		<td class=topheader>QoS规则</td>
	</tr>
	<tr>
		<td class=content>
			<table id=qosTable class=formlisting border=0>
				<tr>
					<td align=center width="5%" rowspan="2" bgcolor="#808080"></td>
					<!--
					<td align=center width="5%" rowspan="2" bgcolor="#808080">协议</td>
	
					<td align=center width="5%" rowspan="2" bgcolor="#808080">源端口</td>
					<td align=center width="5%" rowspan="2" bgcolor="#808080">目的端口</td>
					-->	
					<td align=center width="15%" rowspan="2" bgcolor="#808080">源IP</td>
					<!--
					<td align=center width="15%" rowspan="2" bgcolor="#808080">目的 IP</td>
					-->
					<td align=center width="10%" colspan="2" bgcolor="#808080">最小带宽(Kbps)</td>
					<td align=center width="10%" colspan="2" bgcolor="#808080">最大带宽(Kbps)</td>
					<td align=center width="5%" rowspan="2" bgcolor="#808080">删除</td>
				</tr>
					<tr>
					<td align=center width="10%" bgcolor="#808080">上行</td>
					<td align=center width="10%" bgcolor="#808080">下行</td>
					<td align=center width="10%" bgcolor="#808080">上行</td>
					<td align=center width="10%" bgcolor="#808080">下行</td>
				</tr>

                <script language="JavaScript" type="text/javascript">
                var i,j;
                var PROTOCL = new Array("","ICMP","TCP","UDP","TCP/UDP");
				var ruleStr="<% getCfgGeneral(1, "ip_ctl_carrules");%>";
				var rule = new Array;
				var rule1 = new Array;
				if(ruleStr.length != 0)
			   {
				  if(ruleStr.indexOf(";") > 0)
				  	  ruleTypeNum = ruleStr.match(/;/g).length; // 规则种类数
				  rule = ruleStr.split(';');
				  
				 for(i=0;i<ruleTypeNum;i++)
				 {
				   
				    rule1=rule[i].split(',');
				    document.write("<tr>");
					document.write("<td align='center' bgcolor='#C0C0C0'><b><font size=2>"+(i+1)+"</font></b></td>");
					/*
					document.write("<td align='center' bgcolor='#C0C0C0'><b><font size=2>"+PROTOCL[rule1[0]]+"</font></b></td>");
					document.write("<TD align='center' bgcolor='#C0C0C0'><b><font size=2>"+rule1[1]+"</font></b></td>");
					document.write("<TD align='center' bgcolor='#C0C0C0'><b><font size=2>"+rule1[2]+"</font></b></td>");
					*/
					if(rule1[3].length==0)
					{
					 document.write("<TD align='center' bgcolor='#C0C0C0'><b><font size=2>"+" "+"</font></b></td>");
					}
					else
					{ 
					  document.write("<TD align='center' bgcolor='#C0C0C0'><b><font size=2>"+rule1[3]+"/"+rule1[4]+"</font></b></td>");
					}
					/*
					if(rule1[5].length==0)
					{
					  document.write("<TD align='center' bgcolor='#C0C0C0'><b><font size=2>"+" "+"</font></b></td>");
					}
					else
					{
					  document.write("<TD align='center' bgcolor='#C0C0C0'><b><font size=2>"+rule1[5]+"/"+rule1[6]+"</font></b></td>");
					}
					*/
					document.write("<TD align='center' bgcolor='#C0C0C0'><b><font size=2>"+rule1[7]+"</font></b></td>");
					document.write("<TD align='center' bgcolor='#C0C0C0'><b><font size=2>"+rule1[8]+"</font></b></td>");
					document.write("<TD align='center' bgcolor='#C0C0C0'><b><font size=2>"+rule1[9]+"</font></b></td>");
					document.write("<TD align='center' bgcolor='#C0C0C0'><b><font size=2>"+rule1[10]+"</font></b></td>");
				    document.write("<TD align='center' bgcolor='#C0C0C0'><b><input type='checkbox'name='removeQ' value='"+i+"'><b></td>");
					document.write("</tr>");
				
              }
		  }
         </script>
			</table>
		</td>
	</tr>
</table>
<br>
<p align=center>
    <input type="hidden" name=removeRuleList>
    <input type="button" class="button" onClick="on_Add()" value="添加规则">
    <input type="submit" name="save" onClick="return saveClick(this.form.removeQ);" value="删除">
</p>  

</div>
<input type="hidden" name="tokenid" id="tokenid1" value="">
</form>

<div id="tcrule" style="display:none">
<p></p>
<table cellSpacing="1" cellPadding="0" border="0">	
<form action="/goform/form2IPQoSTcAdd" method=POST name=qostcrule>

  <tr style="display:none">
    <td><font size=2>协议:</font></td>
    <td>
      <select name="proto" onChange="return onSelProt()">
        <option value="0">不指定</option>
        <option value="1">ICMP</option>
        <option value="2">TCP </option>
        <option value="3">UDP </option>
        <option value="4">TCP/UDP</option>
      </select>
    </td>
  </tr>

  <tr>
    <td><font size=2>源IP:</font></td>
    <td><input type="text" name="srcip" size="20" maxlength="46" style="width:150px"></td>

    <td style="display:none"><font size=2>源子网掩码:</font></td>
    <td style="display:none"><input type="text" name="srcnetmask" size="20" maxlength="46" style="width:150px"></td>

  </tr>

  <tr style="display:none">
    <td><font size=2>目的 IP:</font></td>
    <td><input type="text" name="dstip" size="20" maxlength="46" style="width:150px"></td>
    <td><font size=2>目的子网掩码:</font></td>
    <td><input type="text" name="dstnetmask" size="20" maxlength="46" style="width:150px"></td>
  </tr>
  <tr style="display:none">
    <td><font size=2>源端口:</font></td>
    <td><input type="text" name="sport" size="5" maxlength="5" style="width:80px"></td>
    <td><font size=2>目的端口:</font></td>
    <td><input type="text" name="dport" size="5"  maxlength="5" style="width:80px"></td>
  </tr>

  <tr>
    <td><font size=2>上行最小带宽:</font></td>
    <td><input type="text" name="uprateFloor" size="6" style="width:80px">kb/s</td>
    <td><font size=2>上行最大带宽:</font></td>
    <td><input type="text" name="uprateCeiling" size="6" style="width:80px">kb/s</td>    
  </tr>
  <tr>
    <td><font size=2>下行最小带宽:</font></td>
    <td><input type="text" name="downrateFloor" size="6" style="width:80px">kb/s</td>
    <td><font size=2>下行最大带宽</font></td>
    <td><input type="text" name="downrateCeiling" size="6" style="width:80px">kb/s</td>    
  </tr>  
</table>
<br>
<p align=center>
<input type="submit" name="addRule" value="添加规则" onClick="return on_apply();" style="width:80px">
</p>
</div>
<input type="hidden" value="Send" name="submit.htm?d_ipqostc_gen_ap.htm">
<input type="hidden" name="tokenid" id="tokenid2" value="" >
<script>
    var tokenid = "<% getTokenidToRamConfig(); %>";
	console.log("[d_ipqostc_gen_ap] tokenid ="+tokenid);
	
	for(var i=0;i<3;i++)
	    document.getElementById("tokenid"+i).setAttribute("value",tokenid);
</script> 
</form>
</DIV>
<script>
	mainBodyEnd();
	ThirdRowEnd();
	Footer()
	mainTableEnd()
</script>
</blockquote>
 <script>

window.onload = function() {
	var uptotalStr="<% getCfgGeneral(1, "ip_ctl_uptotal"); %>";
	var dowtotalStr="<% getCfgGeneral(1, "ip_ctl_downtotal"); %>";
	var auto_en="<% getCfgGeneral(1, "ip_ctl_auto"); %>";
	var tcruletable = document.getElementById('tcruletable');
	var tcrule = document.getElementById('tcrule');
	var tcauto = document.getElementById('tcauto');
	var uptotal = document.getElementById('total');
	var downtol = document.getElementById('downtotal');
	
	if(auto_en=='1')
	{
	  tcauto.checked=true;
	  tcauto.value='1';
	}
	else
	{
	  tcauto.checked=false;
	  tcauto.value='0';
	}
	
	if(uptotalStr.length>0)
	{
	  uptotal.value=uptotalStr;
	}
	else
	{
	  uptotal.value='0';
	}
	
	if(dowtotalStr.length>0)
	{
	  downtol.value=dowtotalStr;
	}
	else
	{
	  downtol.value='0';
	}
	/*
	tcauto.onclick = function() {
		turn(this);
	}
	dispatchEvent('click', tcauto);
	*/
	onClickTcAuto();

}

function onClickTcAuto()
{
	var tcruletable = document.getElementById('tcruletable');
	var tcrule = document.getElementById('tcrule');
	var tcauto = document.getElementById('tcauto');
	if (tcauto.checked == true) {
		tcruletable.style.display = 'none';
		tcrule.style.display = 'none';
	} else {
		tcruletable.style.display = 'block';
	}

}
function turn(ele) {
	if (ele.checked) {
		tcruletable.style.display = 'none';
		tcrule.style.display = 'none';
	} else {
		tcruletable.style.display = 'block';
	}
}  

function dispatchEvent(type, ele) {
	ele = typeof ele == 'string' ? document.getElementById(ele) : ele;
	type = type || 'click';	
	if (document.createEvent) {
		var evt = document.createEvent("Events"); 
		evt.initEvent(type, true, true);
		ele.dispatchEvent(evt);
	} else {
		ele.fireEvent('on'+type);
	}
}

</script>
</body>
</html>

