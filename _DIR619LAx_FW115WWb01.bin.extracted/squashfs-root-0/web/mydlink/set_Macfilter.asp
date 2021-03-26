<html>
<head>
<script language="JavaScript" type="text/javascript">
function check()
{
	var i, j;
	for(i = 0; i < 24; i++)
	{
		var mac = document.getElementById("mac_input_" + i).value.split(":");
		document.getElementById("mac_" + i).value = "";
		for(j = 0; j < mac.length; j++)
		{
			document.getElementById("mac_" + i).value += mac[j];
		}
	}
	document.forms.myform.submit();	
	return true;
}
</script>
</head>
<body>
<form name="myform" id="myform" action="/goform/form_macfilter"  method="post">
<input type="text" name="settingsChanged" value="1"/><br>
<br>
<input type="text" name="macFltMode" value="1"/><br>
<br>
<input type="text" name="entry_enable_0" value="1"/><br>
<input type="hidden" id="mac_0" name="mac_0" value=""/><br>
<input type="text" id="mac_input_0" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_0" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_0" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_0" value="Always"/><br>
<br>
<input type="text" name="entry_enable_1" value="1"/><br>
<input type="hidden" id="mac_1" name="mac_1" value=""/><br>
<input type="text" id="mac_input_1" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_1" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_1" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_1" value="Always"/><br>
<br>
<input type="text" name="entry_enable_2" value="1"/><br>
<input type="hidden" id="mac_2" name="mac_2" value=""/><br>
<input type="text" id="mac_input_2" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_2" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_2" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_2" value="Always"/><br>
<br>
<input type="text" name="entry_enable_3" value="1"/><br>
<input type="hidden" id="mac_3" name="mac_3" value=""/><br>
<input type="text" id="mac_input_3" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_3" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_3" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_3" value="Always"/><br>
<br>
<input type="text" name="entry_enable_4" value="1"/><br>
<input type="hidden" id="mac_4" name="mac_4" value=""/><br>
<input type="text" id="mac_input_4" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_4" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_4" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_4" value="Always"/><br>
<br>
<input type="text" name="entry_enable_5" value="1"/><br>
<input type="hidden" id="mac_5" name="mac_5" value=""/><br>
<input type="text" id="mac_input_5" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_5" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_5" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_5" value="Always"/><br>
<br>
<input type="text" name="entry_enable_6" value="1"/><br>
<input type="hidden" id="mac_6" name="mac_6" value=""/><br>
<input type="text" id="mac_input_6" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_6" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_6" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_6" value="Always"/><br>
<br>
<input type="text" name="entry_enable_7" value="1"/><br>
<input type="hidden" id="mac_7" name="mac_7" value=""/><br>
<input type="text" id="mac_input_7" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_7" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_7" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_7" value="Always"/><br>
<br>
<input type="text" name="entry_enable_8" value="1"/><br>
<input type="hidden" id="mac_8" name="mac_8" value=""/><br>
<input type="text" id="mac_input_8" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_8" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_8" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_8" value="Always"/><br>
<br>
<input type="text" name="entry_enable_9" value="1"/><br>
<input type="hidden" id="mac_9" name="mac_9" value=""/><br>
<input type="text" id="mac_input_9" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_9" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_9" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_9" value="Always"/><br>
<br>
<input type="text" name="entry_enable_10" value="1"/><br>
<input type="hidden" id="mac_10" name="mac_10" value=""/><br>
<input type="text" id="mac_input_10" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_10" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_10" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_10" value="Always"/><br>
<br>
<input type="text" name="entry_enable_11" value="1"/><br>
<input type="hidden" id="mac_11" name="mac_11" value=""/><br>
<input type="text" id="mac_input_11" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_11" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_11" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_11" value="Always"/><br>
<br>
<input type="text" name="entry_enable_12" value="1"/><br>
<input type="hidden" id="mac_12" name="mac_12" value=""/><br>
<input type="text" id="mac_input_12" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_12" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_12" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_12" value="Always"/><br>
<br>
<input type="text" name="entry_enable_13" value="1"/><br>
<input type="hidden" id="mac_13" name="mac_13" value=""/><br>
<input type="text" id="mac_input_13" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_13" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_13" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_13" value="Always"/><br>
<br>
<input type="text" name="entry_enable_14" value="1"/><br>
<input type="hidden" id="mac_14" name="mac_14" value=""/><br>
<input type="text" id="mac_input_14" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_14" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_14" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_14" value="Always"/><br>
<br>
<input type="text" name="entry_enable_15" value="1"/><br>
<input type="hidden" id="mac_15" name="mac_15" value=""/><br>
<input type="text" id="mac_input_15" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_15" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_15" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_15" value="Always"/><br>
<br>
<input type="text" name="entry_enable_16" value="1"/><br>
<input type="hidden" id="mac_16" name="mac_16" value=""/><br>
<input type="text" id="mac_input_16" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_16" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_16" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_16" value="Always"/><br>
<br>
<input type="text" name="entry_enable_17" value="1"/><br>
<input type="hidden" id="mac_17" name="mac_17" value=""/><br>
<input type="text" id="mac_input_17" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_17" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_17" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_17" value="Always"/><br>
<br>
<input type="text" name="entry_enable_18" value="1"/><br>
<input type="hidden" id="mac_18" name="mac_18" value=""/><br>
<input type="text" id="mac_input_18" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_18" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_18" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_18" value="Always"/><br>
<br>
<input type="text" name="entry_enable_19" value="1"/><br>
<input type="hidden" id="mac_19" name="mac_19" value=""/><br>
<input type="text" id="mac_input_19" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_19" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_19" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_19" value="Always"/><br>
<br>
<input type="text" name="entry_enable_20" value="1"/><br>
<input type="hidden" id="mac_20" name="mac_20" value=""/><br>
<input type="text" id="mac_input_20" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_20" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_20" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_20" value="Always"/><br>
<br>
<input type="text" name="entry_enable_21" value="1"/><br>
<input type="hidden" id="mac_21" name="mac_21" value=""/><br>
<input type="text" id="mac_input_21" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_21" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_21" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_21" value="Always"/><br>
<br>
<input type="text" name="entry_enable_22" value="1"/><br>
<input type="hidden" id="mac_22" name="mac_22" value=""/><br>
<input type="text" id="mac_input_22" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_22" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_22" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_22" value="Always"/><br>
<br>
<input type="text" name="entry_enable_23" value="1"/><br>
<input type="hidden" id="mac_23" name="mac_23" value=""/><br>
<input type="text" id="mac_input_23" value="00:21:91:8e:19:0f"/><br>
<input type="text" name="mac_hostname_23" maxlength="39" value="PC-123456"/><br>
<input type="text" name="mac_addr_23" value="00%3A21%3A91%3A8e%3A19%3A0f"/><br>
<input type="text" name="sched_name_23" value="Always"/><br>
<br>
<input type="button" value="Submit" onclick="check();"/><br>
</form>
</body>
</html>
