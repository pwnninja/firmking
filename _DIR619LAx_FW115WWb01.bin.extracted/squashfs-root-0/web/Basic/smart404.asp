<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<HTML>

<head>

<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta http-equiv="content-type" content="text/html; charset=<% getLangInfo("charset");%>" />
<link rel="stylesheet" rev="stylesheet" href="style.css" type="text/css" />
<link rel="stylesheet" rev="stylesheet" href="<% getInfo("substyle");%>" type="text/css" />
<script type="text/javascript" src="../ubicom.js"></script>
<script type="text/javascript" src="../xml_data.js"></script>
<% getLangInfo("LangPath");%>
<script type="text/javascript" src="../navigation.js"></script>
<script type="text/javascript" src="../utility.js"></script>
<script type="text/javascript">
function web_timeout()
{
	setTimeout('do_timeout()','<%getIndexInfo("logintimeout");%>'*60*1000);
}

function template_load()
{

<% getFeatureMark("MultiLangSupport_Head_script");%>

lang_form = document.forms.lang_form;

if ("" === "") {

assign_i18n();

lang_form.i18n_language.value = "<%getLangInfo("langSelect")%>";
}

<% getFeatureMark("MultiLangSupport_Tail_script");%>

var global_fw_minor_version = "<%getInfo("fwVersion")%>";

var fw_extend_ver = "";			

var fw_minor;

assign_firmware_version(global_fw_minor_version,fw_extend_ver,fw_minor);

var hw_version="<%getInfo("hwVersion")%>";

var productModel="<%getInfo("productModel")%>";

document.getElementById("hw_version_head").innerHTML = hw_version;

document.getElementById("product_model_head").innerHTML = productModel;

RenderWarnings();

}
</script>

<script type="text/javascript">
function init()
{
var DOC_Title= sw("txtTitle")+" : "+sw("txtLogin");
document.title = DOC_Title;	
}
</script>

</head>

<body onload="template_load();init();web_timeout();">

<TABLE id=___01 border=0 cellSpacing=0 cellPadding=0 width=836 height=551>

  <TBODY>

  <TR>

    <TD bgColor=#e6e6e6 height=14 colSpan=3>&nbsp;</TD></TR>

  <TR>

    <TD bgColor=#e6e6e6 height=537 rowSpan=2 width=23>&nbsp;</TD>

    <TD>

      <TABLE id=___ border=0 cellSpacing=0 cellPadding=0 width=786 height=539>

        <TBODY>

        <TR>

          <TD rowSpan=10 width=78>&nbsp;</TD>

          <TD height=35 colSpan=7>&nbsp;</TD></TR>

        <TR>

          <TD width=120><STRONG><FONT 

            face="Arial, Helvetica, sans-serif"><FONT color=#66ccff 

            size=6><SCRIPT language=javascript type=text/javascript>ddw("txtSmart404Oops");</SCRIPT></FONT></FONT></STRONG></TD>

          <TD height=45 colSpan=6>&nbsp;</TD></TR>

        <TR>

          <TD height=13 colSpan=7>&nbsp;</TD></TR>

        <TR>
          	<TD height=35 colSpan=7>
			<FONT color=#808080 size=6>
				<FONT color=#999999 size=6 face="Arial, Helvetica, sans-serif">
				<SCRIPT language=javascript type=text/javascript>ddw("txtSmart404RequestFail");</SCRIPT>
				</FONT>
			</FONT>
		</TD>
	</TR>

        <TR><TD height=38 colSpan=7>&nbsp;</TD></TR>

        <TR>
          	<TD colSpan=5><IMG alt="" src="../Images/smart_head.jpg" width=606 height=128></TD>
        	  <TD height=128 colSpan=2>&nbsp;</TD>
	</TR>

        <TR>
          	<TD height="20" colSpan=5 align="center">
			<FONT color=#808080 size=2>
				<FONT color=#999999 size=2 face="Arial, Helvetica, sans-serif">
				<SCRIPT language=javascript type=text/javascript>ddw("txtSmart404INetFailed");</SCRIPT>
				</FONT>
			</FONT>
		</TD>
          	<TD  colSpan=2>&nbsp;</TD>
	</TR>


        <TR><TD height=13 colSpan=7>&nbsp;</TD></TR><TR>

          <TD colSpan=5>
            <P><FONT color=#999999 size=2 face="Verdana, Arial, Helvetica, sans-serif">
		<SCRIPT language=javascript type=text/javascript>ddw("txtSmart404Suggestions");</SCRIPT>
		</FONT>
	     </P>
		<FONT color=#999999 size=2>
	            <OL style="FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif">

              <LI><SCRIPT language=javascript type=text/javascript>ddw("txtSmart404Suggestion1");</SCRIPT> 

              <LI><SCRIPT language=javascript type=text/javascript>ddw("txtSmart404Suggestion21");</SCRIPT> 

              <LI><SCRIPT language=javascript type=text/javascript>ddw("txtSmart404Suggestion3");</SCRIPT></LI></OL></FONT></TD>

          <TD height=86 colSpan=2>&nbsp;</TD></TR>

        <TR>

          <TD height=48 colSpan=3>&nbsp;</TD>

          <TD rowSpan=2 colSpan=3><IMG alt="" src="../Images/smart_head_1.jpg" width=229 height=75></TD>

          <TD height=75 rowSpan=2 width=46>&nbsp;</TD></TR>

        <TR>

          <TD height=2 colSpan=2>&nbsp;</TD>

          <TD height=2 width=305><FONT size=1 

            face="Arial, Helvetica, sans-serif"><A 

            href="http://www.dlink.com/"><SCRIPT language=javascript>print_copyright();</SCRIPT>

            </A></FONT></TD></TR></TBODY></TABLE></TD>

    <TD bgColor=#e6e6e6 height=537 rowSpan=2 width=27>&nbsp;</TD></TR>

  <TR>

    <TD bgColor=#e6e6e6 height=32 

width=782>&nbsp;</TD></TR></TBODY></TABLE></body>
