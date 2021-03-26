<html>
<head>
</head>
<script language="JavaScript" type="text/javascript">
function page_submit()
{
	for (i = 0; i < 25; i++) {
		var mac_array = myform["mac_addr_" + i].value.split(":");
		myform["mac_" + i].value = "";
		for(var j=0;j<mac_array.length;j++)
		{
			myform["mac_" + i].value += mac_array[j];					
		}	
	}
}
</script>
<body>
<form name="myform" action="/goform/form_wlan_acl" method="post">
<input type="text" name="settingsChanged" value="1"/>

<input type="text" name="macFltMode" value="0"/>

<input type="text" name="entry_enable_0" value="1"/>
<input type="text" name="mac_addr_0" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_0" value=""/>

<input type="text" name="entry_enable_1" value="1"/>
<input type="text" name="mac_addr_1" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_1" value=""/>

<input type="text" name="entry_enable_2" value="1"/>
<input type="text" name="mac_addr_2" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_2" value=""/>

<input type="text" name="entry_enable_3" value="1"/>
<input type="text" name="mac_addr_3" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_3" value=""/>

<input type="text" name="entry_enable_4" value="1"/>
<input type="text" name="mac_addr_4" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_4" value=""/>

<input type="text" name="entry_enable_5" value="1"/>
<input type="text" name="mac_addr_5" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_5" value=""/>

<input type="text" name="entry_enable_6" value="1"/>
<input type="text" name="mac_addr_6" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_6" value=""/>

<input type="text" name="entry_enable_7" value="1"/>
<input type="text" name="mac_addr_7" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_7" value=""/>

<input type="text" name="entry_enable_8" value="1"/>
<input type="text" name="mac_addr_8" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_8" value=""/>

<input type="text" name="entry_enable_9" value="1"/>
<input type="text" name="mac_addr_9" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_9" value=""/>

<input type="text" name="entry_enable_10" value="1"/>
<input type="text" name="mac_addr_10" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_10" value=""/>

<input type="text" name="entry_enable_11" value="1"/>
<input type="text" name="mac_addr_11" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_11" value=""/>

<input type="text" name="entry_enable_12" value="1"/>
<input type="text" name="mac_addr_12" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_12" value=""/>

<input type="text" name="entry_enable_13" value="1"/>
<input type="text" name="mac_addr_13" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_13" value=""/>

<input type="text" name="entry_enable_14" value="1"/>
<input type="text" name="mac_addr_14" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_14" value=""/>

<input type="text" name="entry_enable_15" value="1"/>
<input type="text" name="mac_addr_15" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_15" value=""/>

<input type="text" name="entry_enable_16" value="1"/>
<input type="text" name="mac_addr_16" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_16" value=""/>

<input type="text" name="entry_enable_17" value="1"/>
<input type="text" name="mac_addr_17" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_17" value=""/>

<input type="text" name="entry_enable_18" value="1"/>
<input type="text" name="mac_addr_18" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_18" value=""/>

<input type="text" name="entry_enable_19" value="1"/>
<input type="text" name="mac_addr_19" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_19" value=""/>

<input type="text" name="entry_enable_20" value="1"/>
<input type="text" name="mac_addr_20" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_20" value=""/>

<input type="text" name="entry_enable_21" value="1"/>
<input type="text" name="mac_addr_21" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_21" value=""/>

<input type="text" name="entry_enable_22" value="1"/>
<input type="text" name="mac_addr_22" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_22" value=""/>

<input type="text" name="entry_enable_23" value="1"/>
<input type="text" name="mac_addr_23" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_23" value=""/>

<input type="text" name="entry_enable_24" value="1"/>
<input type="text" name="mac_addr_24" value="00:21:91:8e:19:0f"/>
<input type="hidden" name="mac_24" value=""/>

<input type="submit" value="Submit" onclick="page_submit();"/>
</form>
</body>
</html>
