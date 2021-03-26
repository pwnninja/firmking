<html><head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="d_stylemain.css">
<script type="text/javascript" src="d_util.js"></script>
<script type="text/javascript" src="d_share.js"></script>
<script type="text/javascript" src="d_menu.js"></script>
<script type="text/javascript" src="forbidView.js"></script>
<title>无线接入控制</title>
<script>

function skip () { this.blur(); }

function checkmac()
{
	if (document.formWlAcAdd.mac.value != "" ){
		if (checkCloneMac(document.formWlAcAdd.mac) == false)
			return false;
			
		var all_str = "<% getCfg2General(1, "AccessControlList0"); %>";
		var entries = new Array();
		if(all_str.length){
			entries = all_str.split(";");

			//20090611 Gord # Maximum rules is 4
			if(entries.length == 8){
				alert("<#alert_118#>");
				return false;
			}

			for(i=0; i<entries.length; i++){
				if( isSameMac(document.formWlAcAdd.mac.value , entries[i] )){
					alert("<#alert_106#>");
					document.formWlAcAdd.mac.focus();
					return false;
				}
			}
		}
	}
	else
	{
	   alert("<#alert_36#>");
		return false;
	}

	return true;
}


function addClick()
{
	if(document.formWlAcAdd.mac.value)
	{
		if (!checkmac(document.formWlAcAdd.mac, 1))	{
			return false;
	  }
	//document.formWlAcAdd.mac.value = document.formWlAcAdd.mac.value.toLowerCase();
	}
	else
	{
		alert("MAc 地址不能为空！");
		return false;
	}
	if(document.formWlAcDel.totalNum.value == '20')
	{
		alert("无线访问控制列表规则数不超过20条!");
		return false;
	}

  create_backmask();
  document.getElementById("loading").style.display="";	

	return true;
}

function disableDelButton()
{
	disableButton(document.formWlAcDel.deleteSelFilterMac);
	disableButton(document.formWlAcDel.deleteAllFilterMac);
}

function enableAc()
{
  enableTextField(document.formWlAcAdd.mac);
}

function disableAc()
{
  disableTextField(document.formWlAcAdd.mac);
}

function onClickUpdateState()
{
	if(wlanDisabled || wlanMode == 1 || wlanMode ==2)
	{
		disableDelButton();
		disableButton(document.formWlAcAdd.reset);
		disableButton(document.formWlAcAdd.addFilterMac);
		disableCheckBox(document.formWlAcDel.wlanAcEnabled);
		disableAc();
	} 
	else
	{
		if (document.formWlAcDel.wlanAcEnabled.checked == true)
		{
			document.formWlAcDel.wlanAcEnabled.value = "1";
			enableButton(document.formWlAcAdd.reset);
			enableButton(document.formWlAcAdd.addFilterMac);
			enableAc();
		}
		else
		{
			document.formWlAcDel.wlanAcEnabled.value = "0";
			disableButton(document.formWlAcAdd.reset);
			disableButton(document.formWlAcAdd.addFilterMac);
			disableAc();
		}
	}
}
function updateState()
{
	if(wlanDisabled || wlanMode == 1 || wlanMode ==2)
	{
		disableDelButton();
		disableButton(document.formWlAcAdd.reset);
		disableButton(document.formWlAcAdd.addFilterMac);
		disableCheckBox(document.formWlAcDel.wlanAcEnabled);
		disableAc();
	} 
	else
	{
		if (document.formWlAcDel.wlanAcEnabled.value == "1") 
		{
			document.formWlAcDel.wlanAcEnabled.checked = true;
			enableButton(document.formWlAcAdd.reset);
			enableButton(document.formWlAcAdd.addFilterMac);
			enableAc();
		}
		else 
		{
			document.formWlAcDel.wlanAcEnabled.checked = false;
			disableButton(document.formWlAcAdd.reset);
			disableButton(document.formWlAcAdd.addFilterMac);
			disableAc();
		}
	}
}


function delACLEntryCheck()
{
	if ( deleteClick() == true){
		if (document.formWlAcDel.checkWPS2.value != 0){
			if (document.formWlAcDel.wlanAcEnabled.checked == true && document.formWlAcDel.totalNum.value == 1){
				//if (confirm("If ACL Mode is set to 'Allowed List' and ACL list has no entry, the WPS would be disabled.\nDo you sure?") == 0){
				if (confirm("如果打开无线访问控制功能 ，而且访问列表为空，WPS 功能将会被自动禁用。\n确定要修改吗?") == 0){
					return false;
				}
			}
		}
	} else {
		return false;
	}

	document.formWlAcDel.actrlFlag.value ="2";

 create_backmask();
 document.getElementById("loading").style.display="";	

	return true;
}

function  delEntryCheck()
{
	if (all_str.length)
	{
		if(document.formWlAcDel.aclist.length)
		{
			for(i=0;i<document.formWlAcDel.aclist.length;i++)   
			{ 
				if(document.formWlAcDel.aclist[i].checked)
					//return deleteClick();
					return delACLEntryCheck();
			}
		}
		else
		{
			if(document.formWlAcDel.aclist.checked)
				//return deleteClick();
				return delACLEntryCheck();
		}

		alert("请选择要删除的条目!"); 
		return false; 
	}
	else
	{
		alert("列表为空");
		return false;
	}
}

function deleteACLAllClick()
{
	if (document.formWlAcDel.checkWPS2.value != 0){
    	if (document.formWlAcDel.wlanAcEnabled.checked == true && document.formWlAcDel.totalNum.value > 0){
    		//if (confirm("If ACL Mode is set to 'Allowed List' and ACL list has no entry, the WPS would be disabled.\nDo you sure?") == 0){
    		if (confirm("如果打开无线访问控制功能 ，而且访问列表为空，WPS 功能将会被自动禁用。\n确定要修改吗?") == 0){
    			return false;
    		}
    	}
	}
	document.formWlAcDel.actrlFlag.value ="3";
	if (all_str.length)
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
	else
	{
		alert("列表为空");
		return false;
	}

}
function saveChanges()
{
	if (document.formWlAcDel.checkWPS2.value != 0){
    	if (document.formWlAcDel.wlanAcEnabled.checked == true ){//document.formWlAcDel.totalNum.value == 0
    		//if (confirm("If ACL Mode is set to 'Allowed List' and ACL list has no entry, the WPS would be disabled.\nDo you sure?") == 0){
    		if (confirm("如果打开无线访问控制功能 ，WPS 功能将会被自动禁用。\n确定要修改吗?") == 0){
    			return false;
    		}
    	}
    }
	document.formWlAcDel.actrlFlag.value ="1";
 create_backmask();
 document.getElementById("loading").style.display="";	

	return true;
}
</script>
</head>
<body>
<blockquote>

<script language="JavaScript">
	TabHeader="无线5G";
	SideItem="无线高级设置";
	HelpItem="wlctrl";
</script>
<script type='text/javascript'>
	mainTableStart();
	logo();
	TopNav();
	ThirdRowStart();
	Write_Item_Images();
	mainBodyStart();
</script>

<form action="/goform/form2Wl5Ac.cgi" method=POST name="formWlAcDel">
	<table id=box_header border=0 cellSpacing=0>
		<tr>
			<td class=topheader>
				无线访问控制
			</td>
		</tr>
		<tr>
			<td class=content>
				<p>
					开启无线访问控制模式后，只有下面列表中的MAC地址能够接入路由器。
				</p>
			</td>
		</tr>
	</table>
	<table id=body_header border=0 cellSpacing=0>
		<tr>
			<td class=topheader>无线网卡访问设置</td>
		</tr>
		
		<tr>
			<td>
				<br>&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="wlanAcEnabled" 
value="0"				onclick="onClickUpdateState()">打开无线访问控制
			</td>
		</tr>

		<tr>

			<td class=content>
				<table class=formlisting border=0>
				<tr class="form_label_row"><td class="form_label_col"><b>MAC 地址</b></td><td class="form_label_col"><b>选择</b></td></tr>
<script language="JavaScript" type="text/javascript">
    var i;
	var entries = new Array();
	var all_str = "<% getCfg2General(1, "AccessControlList0"); %>";

	if(all_str.length){
		entries = all_str.split(";");
		for(i=0; i<entries.length ; i++){
			document.write("<tr><td align=center width=\"45%\" bgcolor=\"#C0C0C0\"><font size=\"2\">");
			document.write(entries[i] +"</font></td>");
			document.write("<td align=center width=\"20%\" bgcolor=\"#C0C0C0\">");
			document.write("<input type=radio value=" + i + "  name=aclist >");

			document.write("</td></tr>\n");
		}
		document.write("<INPUT TYPE=\"HIDDEN\" NAME=\"totalNum\" VALUE=\"" + entries.length + "\">");

	}
	else
	{
		document.write("<INPUT TYPE=\"HIDDEN\" NAME=\"totalNum\" VALUE=\"0\">");
	}
</script>
				
<!--<INPUT TYPE="HIDDEN" NAME="totalNum" VALUE="0">	-->	
		

</table>				
			</td>
		</tr>
	</table>	
	
	<br>
	<p align="center">
	<INPUT TYPE="HIDDEN" NAME="actrlFlag" VALUE="">
	<INPUT TYPE="HIDDEN" NAME="checkWPS2" VALUE="<% getCfg2Zero(1, "WscModeOption"); %>">	<input type="submit" value="应用"  name="deleteApplySubmit" onClick="return saveChanges();">&nbsp;&nbsp;
	<input type="submit" value="删除所选条目" name="deleteSelFilterMac" onClick="return delEntryCheck()">&nbsp;&nbsp;
	<input type="submit" value="删除所有条目" name="deleteAllFilterMac" onClick="return deleteACLAllClick()">&nbsp;&nbsp;&nbsp;
	</p>
	<input type="hidden" name="tokenid" id="tokenid0" value="" >
</form>

<form action="goform/form2Wl5Ac.cgi" method=POST name="formWlAcAdd">
	<table id=body_header border=0 cellSpacing=0 style="display:none">
		<tr>
			<td class=topheader>无线接入控制模式</td>
		</tr>

		<tr>
			<td class=content align=center>
				<table class=formarea border="0" cellpadding="0" cellspacing="0" width="450">



				
					<tr>
						<td class=form_label_40>无线访问控制: &nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td><select size="1" name="wlanAcEnabled" onclick="updateState()">
							<option value=0 >禁用</option>
							<option value=1 >允许列表</option>
							<option value=2 >拒绝列表</option>
							</select>
						</td>						
					</tr>
				</table>				
			</td>
		</tr>
	</table>

	<p align=center  style="display:none">
	<input type="submit" value="应用" name="setFilterMode">&nbsp;&nbsp;
	</p>

	<table id=body_header border=0 cellSpacing=0>
		<tr>
			<td class=topheader style="display:none">无线接入控制设置</td>
		</tr>

		<tr>
			<td class=content align=center>
				<table class=formarea border="0" cellpadding="0" cellspacing="0" width="450">
				
					<tr>
						<td class=form_label_40>MAC 地址: &nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td><input type="text" name="mac" size="18" maxlength="17">
     &nbsp;&nbsp;(例如: 00:e0:86:71:05:02)
						</td>						
					</tr>
					
				</table>
			</td>
		</tr>
	</table>

	<p align=center>
	<input type="submit" value="添加" name="addFilterMac" onClick="return addClick()">&nbsp;&nbsp;
	<input type="reset" value="取消" name="reset">&nbsp;&nbsp;&nbsp;
	</p> 
	<input type="hidden" name="tokenid" id="tokenid1" value="" >
    <script>
    var tokenid = "<% getTokenidToRamConfig(); %>";
	console.log("[d_wl5actrl] tokenid ="+tokenid);
	
	for(var i=0;i<2;i++)
	    document.getElementById("tokenid"+i).setAttribute("value",tokenid);
    </script> 
</form>

<script>

var wlanDisabled = <% getCfg2Zero(1, "RadioOff"); %>;
wlanMode=0;
document.formWlAcDel.wlanAcEnabled.value="<% getCfg2Zero(1, "AccessPolicy0"); %>";

updateState();
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

