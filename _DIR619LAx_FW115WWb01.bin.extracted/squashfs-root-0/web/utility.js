/*
 * I18N language selection
 */
var lang_form;
var i18n_xslt_processor;
var i18n_xml_data_fetcher;
var i18n_is_data_ready = false;
var i18n_is_xslt_ready = false;
var i18n_xml_data; // This will be an XMLDocument
function i18n_xslt_is_ready(xmlDoc)
{
	i18n_is_xslt_ready = true;
	i18n_refresh_list();
}
function i18n_data_is_ready(xmlDoc)
{
	i18n_xml_data = xmlDoc.getDocument();
	i18n_is_data_ready = true;
	i18n_refresh_list();
}
function i18n_refresh_list()
{
if (!(i18n_is_xslt_ready && i18n_is_data_ready)) {
	return;
}
var parent = document.getElementById("i18n_language_selection");
	parent.innerHTML = "";
	i18n_xslt_processor.transform(i18n_xml_data, window.document, parent);
	i18n_language_selector(lang_form.i18n_language.value);
}

function i18n_language_selector(lang)
{
	//lang_form.i18n_language_select.options[lang].selected = true;
	var langs = lang_form.i18n_language_select;
	langs.value = lang;
}

function i18n_change_language(lang)
{
	var num=new Date().getTime();

	lang_form.i18n_language.value = lang;
	lang_form.currTime.value = num;
	lang_form.nextPage.value = "/"+getLocationPage(location.href);
	//lang_form.nextPage.value = location.href;
	//alert(lang_form.nextPage.value);
	lang_form.submit();
}
function assign_i18n(){
	i18n_xslt_processor = new xsltProcessingObject(i18n_xslt_is_ready, null, null, "../i18n_language_codes.xsl");
	i18n_xml_data_fetcher = new xmlDataObject(i18n_data_is_ready, null, null, "../languages.xml");
	i18n_xslt_processor.retrieveData();
	i18n_xml_data_fetcher.retrieveData();
}
function assign_firmware_version(global_fw_minor_version,fw_extend_ver,fw_minor){
/*
if (global_fw_minor_version < 10) {
		global_fw_minor_version = "0" + global_fw_minor_version;
		//document.getElementById("fw_minor_head").innerHTML = global_fw_minor_version;
}
*/
fw_minor = global_fw_minor_version + fw_extend_ver;
document.getElementById("fw_minor_head").innerHTML = fw_minor;
global_fw_minor_version = fw_minor; // save to for device info use
}
function jump_if()
{
	return true; /* no check. force return true */
for (var i = 0, l = document.forms.length; i < l; i++) {
if (is_form_modified(document.forms[i].id)) {
if (!confirm (sw("txtInternetStr1"))){
	return false;
}
	return true;
}
}
	return true;
}

function RenderWarnings()
{
watcher_warnings_check("<?xml version='1.0'?><xml><\/xml>");
document.getElementById("loader_container").style.display = "none";
}
		//
// 2007.04.17
// Simple Port Range Check, No comma
	function CheckCheck_PortRangeSimple(range,port)
	{
		var p;
		var r = range;
//		alert(range);
			
		p = r.indexOf('-');
		if( p == -1) {
			// no -
			var i;			
			i = parseInt(range);			
			if( i == port) {
			    return true;
			}	
		}
		else {
			// find -
			var i1,i2;
			var rr;
			rr = r.substring(0,p);
			i1 = parseInt(rr);
			rr = r.substring(p+1,r.length);
			i2 = parseInt(rr);
			
			//alert(i1 + ' ' + i2);
			if( i1 > i2) {
				var temp;
				temp = i2;
				i2 = i1;
				i1 = temp;
			}
			//alert(i1 + ' ' + i2);
			if( (i1 <= port) && (port <= i2)) {
				return true;
			}		
		}
		return false;
	}
// input  range(incuding ,) like 1-2,3-99,200,...
	function CheckCheck_PortRange(range,port)
	{
	
		var r=range;
		while(1) {
											
			var s;
			var p;
			
			p = r.indexOf(',');
			
			//alert(r+" "+ p);

			if( p == -1) {
				// no ,
				// r is number or -
				if( CheckCheck_PortRangeSimple(r,port)) {
					return true;		
				}						
				// process last
				break;						
			}	
			else {
				// find ,
				var rr;
				rr = r.substring(0,p);
				//alert(rr);
				if( CheckCheck_PortRangeSimple(rr,port)) {
					return true;			
				}
				r = r.substring(p+1,r.length);
				//alert(r);
			}		
		};
		return false;
	}
function print_copyright(){		
document.write("<div id=\"copyright\">"+sw("txtCopyright")+" &copy; 2009-2012 D-Link Corporation"+sw("txtAllRightreserved")+"</div>");		
}
/*
 * schedule_populate_select_without_always()
 *	Add options from the schedule_options array to a specified <select> but skip "Always".
 */
function schedule_populate_select_without_always(select_id, schedule_options)
{
	/*
	 * Clear existing options as we are now going to refresh the list
	 */
	select_id.options.length = 0;

	var k = schedule_options.length;
	/* Overrun may occurs in an array if there is a comma but no ending elements. */
	if (!schedule_options[k - 1]) {
		k--;
	}
	for (var i = 1; i < k; i++) {
		select_id.options.add(new Option(schedule_options[i].text, schedule_options[i].value));
	}
}

/*
 * schedule_details()
 *	Return a string describing the currently selected schedule in a specified <select>.
 */
function schedule_details(select_id, without_always, txtEveryDay, txtAllDay,txtAM,txtPM, days, schedule_options)
{
	
	var str = "";
	var idx = select_id.selectedIndex;

	if (select_id.value === "") {
		return "";
	}
	if (select_id.value == "Always" || select_id.value == "Never") {
		return select_id.options[idx].text;
	}

	idx += (without_always ? 1 : 0);

	/* Compute week days. */
	var bits = parseInt(schedule_options[idx].days, 10);
	if (bits === 127) {
		str = txtEveryDay;
	} else {
		for (var i = 0; i < 7; i++) {
			if (bits & (1 << i)) {
				str += days[i] + " ";
			}
		}
	}

	/* Compute times. */
	var stime = parseInt(schedule_options[idx].stime, 10);
	var etime = parseInt(schedule_options[idx].etime, 10);
	if (stime === 0 && etime === 86400) {
		return str + txtAllDay;
	}

	var m = Math.floor(stime / 60);
	var h = Math.floor(m / 60);
	m = m - h * 60;
	var sh;
	var sm = m * 1;
	var sampm;
	if (h < 12) {
		if (h === 0) {
			sh = 12;
		} else {
			sh = h;
		}
		sampm = txtAM;
	} else {
		if (h != 12) {
			sh = h - 12;
		} else {
			sh = h;
		}
		sampm = txtPM;
	}

	m = Math.floor (etime / 60);
	h = Math.floor (m / 60);
	m = m - h * 60;
	var eh;
	var em = m * 1;
	var eampm;
	if (h < 12) {
		if (h === 0) {
			eh = 12;
		} else {
			eh = h;
		}
		eampm = txtAM;
	} else {
		if (h != 12) {
			eh = h - 12;
		} else {
			eh = h;
		}
		eampm = txtPM;
	}

	if (sh < 10) {
		sh = "0" + sh;
	}
	if (sm < 10) {
		sm = "0" + sm;
	}
	if (eh < 10) {
		eh = "0" + eh;
	}
	if (em < 10) {
		em = "0" + em;
	}
	return str + sh + ':' + sm + ' ' + sampm + ' - ' + eh + ':' + em + ' ' + eampm;
}

/*
 * schedule_populate_select()
 *	Add options from the schedule_options array to a specified <select>.
 */
function schedule_populate_select(select_id)
{
	/** Clear existing options as we are now going to refresh the list*/
	select_id.options.length = 0;
	var k = schedule_options.length;
	/* Overrun may occurs in an array if there is a comma but no ending elements. */
	if (!schedule_options[k - 1]) {
		k--;
	}
	for (var i = 0; i < k; i++) {
		select_id.options.add(new Option(schedule_options[i].text, schedule_options[i].value));
	}
}
/* ingress_filter_populate_select(), Add options from the ingress_filter_options array to a specified <select>. */
function ingress_filter_populate_select(select_id)
{
	/** Clear existing options as we are now going to refresh the list*/
	select_id.options.length = 0;
	var k = ingress_filter_options.length;
	/* Overrun may occurs in an array if there is a comma but no ending elements. */
	if (!ingress_filter_options[k - 1]) {
		k--;
	}
	for (var i = 0; i < k; i++) {
		select_id.options.add(new Option(ingress_filter_options[i].text, ingress_filter_options[i].value));
	}
}
/** Cancel and reset changes to the page.*/
function page_cancel()
{
/* no check. force return true */
//if (is_form_modified("mainform") && confirm (sw("txtAbandonAallChanges"))) 
{
	if(get_by_id("mainform")){
		reset_form("mainform");
		if(get_by_id("RsvdIPform"))
				reset_form("RsvdIPform");
	}else if(get_by_id("formWlan")){
		reset_form("formWlan");
		reset_form("formWDS");
		reset_form("formWPS");
	}
	page_load();
}
}
function Write_footerContainer(){
document.write("<table id=\"footer_container\" border=\"0\" cellspacing=\"0\" summary=\"\">");
document.write("<tr><td><img src=\"../Images/img_wireless_bottom.gif\" width=\"114\" height=\"35\" alt=\"\" />");
document.write("</td><td>&nbsp;</td></tr></table></td></tr></table>");
}
function validateStartEndIp(lanip, startip, endip, mask, flag)
{
var i1,i2,i3;
var l1, l2, l3, l4;
var s1,s2,s3,s4;
var m1, m2, m3, m4;
var tmp1, tmp2, tmp3, tmp4;
var lip, sip, eip, mip;
var x1;
var x2;
i1=lanip.indexOf('.');
i2=lanip.indexOf('.',(i1+1));
i3=lanip.indexOf('.',(i2+1));
lip = hex(lanip.substring(0,i1)) + hex(lanip.substring((i1+1),i2)) +hex(lanip.substring((i2+1),i3))+hex(lanip.substring((i3+1),lanip.length));
lip = '0x'+lip;
//alert(lip);
i1=startip.indexOf('.');
i2=startip.indexOf('.',(i1+1));
i3=startip.indexOf('.',(i2+1));
sip = hex(startip.substring(0,i1)) + hex(startip.substring((i1+1),i2)) +hex(startip.substring((i2+1),i3))+hex(startip.substring((i3+1),startip.length));
sip = '0x'+sip;
//alert(sip);
i1=endip.indexOf('.');
i2=endip.indexOf('.',(i1+1));
i3=endip.indexOf('.',(i2+1));
eip = hex(endip.substring(0,i1)) + hex(endip.substring((i1+1),i2)) +hex(endip.substring((i2+1),i3))+hex(endip.substring((i3+1),endip.length));
eip = '0x'+eip;
//alert(eip);
i1=mask.indexOf('.');
i2=mask.indexOf('.',(i1+1));
i3=mask.indexOf('.',(i2+1));
mip = hex(mask.substring(0,i1)) + hex(mask.substring((i1+1),i2)) +hex(mask.substring((i2+1),i3))+hex(mask.substring((i3+1),mask.length));
mip = '0x'+mip;

//alert(mip);
//check lan ip
if(flag ==0){
	if(lip >= sip && lip <= eip)
		return false;
	return 1;	
}
//check static dhcp ip
if(flag ==1){
	x1 = checkSubnet(lanip,mask, startip);
	if(x1 == false)
		return 0;
	if(!(lip >= sip && lip <= eip))
		return 2;
	return 1;
}
if(flag ==2){
	x1 = checkSubnet(lanip,mask, startip);
	if(x1 == false)
		return 0;	
	if(!(lip >= sip && lip <= eip))
		return 0;
	return 1;	
}
if(flag ==3){
	m1= getDigit(mask, 1);
	m2= getDigit(mask, 2);
	m3= getDigit(mask, 3);
	m4= getDigit(mask, 4);
	l1= getDigit(lanip, 1);
	l2= getDigit(lanip, 2);
	l3= getDigit(lanip, 3);
	l4= getDigit(lanip, 4);
	s1= getDigit(startip, 1);
	s2= getDigit(startip, 2);
	s3= getDigit(startip, 3);
	s4= getDigit(startip, 4);
	if(m1 !=0){
		tmp1 = s1 & m1;
		l1 = (~m1 & l1) | tmp1;
		
	}
	if(m2 !=0){
		tmp2 = s2 & m2;
		l2 = (~m2 & l2) | tmp2;
	}
	if(m3 !=0){
		tmp3 = s3 & m3;
		l3 = (~m3 & l3) | tmp3;
	}
	if(m4 !=0){
		tmp4 = s4 & m4;
		l4 = (~m4 & l4) | tmp4;
	}

	x2= l1+"."+l2+"."+l3+"."+l4;
	//alert(x2);
	i1=x2.indexOf('.');
	i2=x2.indexOf('.',(i1+1));
	i3=x2.indexOf('.',(i2+1));
	x1 = hex(x2.substring(0,i1)) + hex(x2.substring((i1+1),i2)) +hex(x2.substring((i2+1),i3))+hex(x2.substring((i3+1),x2.length));
	x1 = '0x'+x1;
	if(!(x1 >= sip && x1 <= eip))
		return 0;
	return 1;	
}
}
function addr_obj(addr, e_msg, allow_zero, is_network){
	this.addr = addr;
	this.e_msg = e_msg;
	this.allow_zero = allow_zero;
	this.is_network = is_network;
}


function hex(val)
{
	var h = (val-0).toString(16);
	if(h.length==1) h='0'+h;
	return h.toUpperCase();
}							     
function getDigit(str, num)
{
  i=1;
  if ( num != 1 ) {
  	while (i!=num && str.length!=0) {
		if ( str.charAt(0) == '.' ) {
			i++;
		}
		str = str.substring(1);
  	}
  	if ( i!=num )
  		return -1;
  }
  for (i=0; i<str.length; i++) {
  	if ( str.charAt(i) == '.' ) {
		str = str.substring(0, i);
		break;
	}
  }
  if ( str.length == 0)
  	return -1;
  d = parseInt(str, 10);
  return d;
}

function checkSubnet(ip, mask, client)
{
  ip_d = getDigit(ip, 1);
  mask_d = getDigit(mask, 1);
  client_d = getDigit(client, 1);
  if ( (ip_d & mask_d) != (client_d & mask_d ) ){
	return false;
}
  ip_d = getDigit(ip, 2);
  mask_d = getDigit(mask, 2);
  client_d = getDigit(client, 2);
  if ( (ip_d & mask_d) != (client_d & mask_d ) ){
	return false;
}
  ip_d = getDigit(ip, 3);
  mask_d = getDigit(mask, 3);
  client_d = getDigit(client, 3);
  if ( (ip_d & mask_d) != (client_d & mask_d ) ){
	return false;
}
  ip_d = getDigit(ip, 4);
  mask_d = getDigit(mask, 4);
  client_d = getDigit(client, 4);
  if ( (ip_d & mask_d) != (client_d & mask_d ) ){
	return false;
}
  return true;
}
function strAnsi2Unicode(asContents)
{
    var len1=asContents.length;
    var temp="";
    var chrcode;
    for(var i=0;i<len1;i++)
    {
        var varasc=asContents.charCodeAt(i);
        if(varasc>127)
        {
            chrcode=AnsiToUnicode((varasc<<8)+asContents.charCodeAt(++i));
        }
        else
        {
            chrcode=varasc;
        }
        temp+=String.fromCharCode(chrcode);
    }
    return temp;
}
function decode_base64(input)
{
  var keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
  var output = "";
  var chr1, chr2, chr3 = "";
  var enc1, enc2, enc3, enc4 = "";
  var i = 0;

      if(input.length%4!=0)
      {
                return "";
      }
  var base64test = /[^A-Za-z0-9\+\/\=]/g;
      if (base64test.exec(input))
      {
                return "";
      }

  do {
     enc1 = keyStr.indexOf(input.charAt(i++));
     enc2 = keyStr.indexOf(input.charAt(i++));
     enc3 = keyStr.indexOf(input.charAt(i++));
     enc4 = keyStr.indexOf(input.charAt(i++));

     chr1 = (enc1 << 2) | (enc2 >> 4);
     chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
     chr3 = ((enc3 & 3) << 6) | enc4;

             output = output + String.fromCharCode(chr1);

     if (enc3 != 64) {
                    output+=String.fromCharCode(chr2);
     }
     if (enc4 != 64) {
                    output+=String.fromCharCode(chr3);
     }

     chr1 = chr2 = chr3 = "";
     enc1 = enc2 = enc3 = enc4 = "";

  } while (i < input.length);

  return strAnsi2Unicode(output);
}

							     
function encode_base64(psstr) {
   		return encode(psstr,psstr.length); 
}

function encode (psstrs, iLen) {
	 var map1="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
   var oDataLen = (iLen*4+2)/3;
   var oLen = ((iLen+2)/3)*4;
   var out='';
   var ip = 0;
   var op = 0;
   while (ip < iLen) {
      var xx = psstrs.charCodeAt(ip++);
      var yy = ip < iLen ? psstrs.charCodeAt(ip++) : 0;
      var zz = ip < iLen ? psstrs.charCodeAt(ip++) : 0;
      var aa = xx >>> 2;
      var bb = ((xx &   3) << 4) | (yy >>> 4);
      var cc = ((yy & 0xf) << 2) | (zz >>> 6);
      var dd = zz & 0x3F;
      out += map1.charAt(aa);
      op++;
      out += map1.charAt(bb);
      op++;
      out += op < oDataLen ? map1.charAt(cc) : '='; 
      op++;
      out += op < oDataLen ? map1.charAt(dd) : '='; 
      op++; 
   }
   return out; 
}	

function displayOnloadPage(msg)
{
if(msg == "Setting saved.")
{
	document.getElementById("maincontent").style.display = "none";
	document.getElementById("rebootcontent").style.display = "block";
}
else
{
	document.getElementById("maincontent").style.display = "block";
	document.getElementById("rebootcontent").style.display = "none";								
}
}

function getLocationPage(locationURL)
{
	//http://192.168.0.1/Basic/Internet.asp?t=1221035106822
	//alert(locationURL);
	var url_1= locationURL.split("//");
	//alert(url_1[1]);
	//192.168.0.1/Basic/Internet.asp?t=1221035106822
	var url_2= url_1[1].split("?");
	//192.168.0.1/Basic/Internet.asp
	//alert(url_2[0]);
	var url_3= url_2[0].split("/");
	
	//alert(url_1.length);
	//alert(url_2.length);
	
	var last_url="";
	
	for(var i=1; i<url_3.length; i++)
	{
		//alert(url_2[i]);
		//last_url = last_url+"/";
		last_url = last_url+url_3[i];
		if(i+1 < url_3.length)
			last_url = last_url+"/";
	}
	
	//alert(last_url);
	return last_url;
	
}

function do_reboot()
{
	document.forms["rebootdummy"].next_page.value=getLocationPage(location.href);
	document.forms["rebootdummy"].act.value="do_reboot";
	document.forms["rebootdummy"].submit();
}
function no_reboot()
{
	document.forms["rebootdummy"].next_page.value=getLocationPage(location.href)+"?t="+new Date().getTime();
	document.forms["rebootdummy"].submit();
}
var days = new Array(	sw("txtSun"),sw("txtMon"),sw("txtTue"),sw("txtWed"),sw("txtThu"),sw("txtFri"),sw("txtSat"));				     						          						      
var days_in_month = ['31', '28', '31', '30', '31', '30', '31', '31', '30', '31', '30', '31'];
function strchk_unicode(str)
{
	var strlen=str.length;
	if(strlen>0)
	{
		var c = '';
		for(var i=0;i<strlen;i++)
		{
			c = escape(str.charAt(i));
			if(c == '%B7')
				return true;
			if(c.charAt(0) == '%' && c.charAt(1)=='u')
				return true;
		}
	}
	return false;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// if the characters of "char_code" is in following ones: 0~9, A~Z, a~z, some control key and TAB.
function __is_comm_chars(char_code)
{
	if (char_code == 0)  return true;						/* some control key. */
	if (char_code == 8)  return true;						/* TAB */
	if (char_code >= 48 && char_code <= 57)  return true;	/* 0~9 */
	if (char_code >= 65 && char_code <= 90)  return true;	/* A~Z */
	if (char_code >= 97 && char_code <= 122) return true;	/* a~z */
	
	return false;
}
function __is_char_in_string(target, pattern)
{
	var len = pattern.length;
	var i;
	for (i=0; i<len; i++)
	{
		if (target == pattern.charCodeAt(i)) return true;
	}
	return false;
}
//if the evt is in the allowed characters.
function __is_evt_in_allow_chars(evt, allow_comm_chars, allow_chars)
{
	var char_code;
	var i;

	if (navigator.appName == 'Netscape'){char_code=evt.which;	}
	else								{char_code=evt.keyCode;	}

	if (allow_comm_chars == "1" && __is_comm_chars(char_code)==true) return true;
	if (allow_chars.length > 0 && __is_char_in_string(char_code, allow_chars)==true) return true;

	return false;
}
//if the characters of "str" are all in the allowed "allow_chars".
function __is_str_in_allow_chars(str, allow_comm_chars, allow_chars)
{
	var char_code;
	var i;

	for (i=0; i<str.length; i++)
	{
		char_code=str.charCodeAt(i);
		if (allow_comm_chars == "1" && __is_comm_chars(char_code) == true) continue;
		if (allow_chars.length > 0 && __is_char_in_string(char_code, allow_chars) == true) continue;
		return false;
	}
	return true;
}
//if the characters of "str" are all in the denied "deny_chars".
function __is_str_in_deny_chars(str, deny_comm_chars, deny_chars)
{
	var char_code;
	var i;

	for (i=0; i<str.length; i++)
	{
		char_code=str.charCodeAt(i);
		if (deny_comm_chars == "1" && __is_comm_chars(char_code) == true) continue;
		if (deny_chars.length > 0 && __is_char_in_string(char_code, deny_chars) == false) continue;
		return true;
	}
	return false;
}
// -------------------------------------------------------------
// this function is used to check if the inputted string include all "invalid chars" or not.
function is_include_special_chars(str,denychars)
{
	if (__is_str_in_deny_chars(str, 1, denychars)) 
	{
		alert(sw("txtCannotIncludeInvalidchar")+": \n"+denychars+" ");			
		return true;
	}
	return false;
}
function strchk_url(str)
{
	if (__is_str_in_allow_chars(str, 1, "/.:_-?&=%")) return true;
	return false;
}

function strchk_hostname_dhcp(str)
{
        if (__is_str_in_allow_chars(str, 1, "_-")) return true;
        return false;
}

function strchk_hostname(str)
{
	if (__is_str_in_allow_chars(str, 1, "._-")) return true;
	return false;
}

function strchk_emailname(str)
{
        if (__is_str_in_allow_chars(str, 1, "._-+@%*?!\\")) return true;
        return false;
}
function strchk_app_name(str)
{
	if (__is_str_in_allow_chars(str, 1, "._-\ ")) return true;
	return false;
}
function strchk_email(str)
{
	if (__is_str_in_allow_chars(str, 1, "._-@")) return true;
	return false;
}

function evtchk_url(evt)
{
	if (__is_evt_in_allow_chars(str, 1, "/.:_-?&=")) return true;
	return false;
}

function evtchk_hostname(evt)
{
	if (__is_evt_in_allow_chars(str, 1, "._-")) return true;
	return false;
}

function evtchk_email(evt)
{
	if (__is_evt_in_allow_chars(str, 1, "._-@")) return true;
	return false;
}

// this function is used to check if the "str" is a decimal number or not.
function is_digit(str)
{
	if (str.length==0) return false;
	for (var i=0;i < str.length;i++)
	{
		if (str.charAt(i) < '0' || str.charAt(i) > '9') return false;
	}
	return true;
}

// convert dec integer string
function decstr2int(str)
{
	var i = -1;
	if (is_digit(str)==true) i = parseInt(str, [10]);
	return i;
}

// vi: set sw=4 ts=4: ************************ ip.js start *************************************

// convert to MAC address string to array.
// myMAC[0] contains the orginal ip string. (dot spereated format).
// myMAC[1~6] contain the 6 parts of the MAC address.
function get_mac(m)
{
	var myMAC=new Array();
	if (m.search(":") != -1)    var tmp=m.split(":");
	else                        var tmp=m.split("-");

	for (var i=0;i <= 6;i++) myMAC[i]="";
	if (m != "")
	{
		for (var i=1;i <= tmp.length;i++) myMAC[i]=tmp[i-1];
		myMAC[0]=m;
	}
	return myMAC;
}

// convert to ip address string to array.
// myIP[0] contains the orginal ip string. (dot spereated format).
// myIP[1~4] contain the 4 parts of the ip address.
function get_ip(str_ip)
{
	var myIP=new Array();

	myIP[0] = myIP[1] = myIP[2] = myIP[3] = myIP[4] = "";
	if (str_ip != "")
	{
		var tmp=str_ip.split(".");
		for (var i=1;i <= tmp.length;i++) myIP[i]=tmp[i-1];
		myIP[0]=str_ip;
	}
	else
	{
		for (var i=0; i <= 4;i++) myIP[i]="";
	}
	return myIP;
}

//Get DHCP range_ip
function get_host_range_ip(ip,mask)
{
	var ipaddr = new Array();
	var submask = new Array();
	ipaddr = get_ip(ip);
	submask = get_ip(mask);
	var ip_range = new Array();
	ip_range[0] = (ipaddr[4] & submask[4])+1;
	ip_range[1] = ip_range[0]+(submask[4] ^ 255)-2;
	return ip_range;
}

// return netmask array according to the class of the ip address.
function generate_mask(str)
{
	var mask = new Array();
	var IP1 = decstr2int(str);

	mask[0] = "0.0.0.0";
	mask[1] = mask[2] = mask[3] = mask[4] = "0";

	if		(IP1 > 0 && IP1 < 128)
	{
		mask[0] = "255.0.0.0";
		mask[1] = "255";
	}
	else if	(IP1 > 127 && IP1 < 191)
	{
		mask[0] = "255.255.0.0";
		mask[1] = "255";
		mask[2] = "255";
	}
	else
	{
		mask[0] = "255.255.255.0";
		mask[1] = "255";
		mask[2] = "255";
		mask[3] = "255";
	}
	return mask;
}

// construct a IP array
function generate_ip(str1, str2, str3, str4)
{
	var ip = new Array();

	ip[1] = (str1=="") ? "0" : decstr2int(str1.value);
	ip[2] = (str2=="") ? "0" : decstr2int(str2.value);
	ip[3] = (str3=="") ? "0" : decstr2int(str3.value);
	ip[4] = (str4=="") ? "0" : decstr2int(str4.value);
	ip[0] = ip[1]+"."+ip[2]+"."+ip[3]+"."+ip[4];
	return ip;
}

// return IP array of network ID
function get_network_id(ip, mask)
{
	var id = new Array();
	var ipaddr = get_ip(ip);
	var subnet = get_ip(mask);

	id[1] = ipaddr[1] & subnet[1];
	id[2] = ipaddr[2] & subnet[2];
	id[3] = ipaddr[3] & subnet[3];
	id[4] = ipaddr[4] & subnet[4];
	id[0] = id[1]+"."+id[2]+"."+id[3]+"."+id[4];
	return id;
}

// return IP array of host ID
function get_host_id(ip, mask)
{
	var id = new Array();
	var ipaddr = get_ip(ip);
	var subnet = get_ip(mask);

	id[1] = ipaddr[1] & (subnet[1] ^ 255);
	id[2] = ipaddr[2] & (subnet[2] ^ 255);
	id[3] = ipaddr[3] & (subnet[3] ^ 255);
	id[4] = ipaddr[4] & (subnet[4] ^ 255);
	id[0] = id[1]+"."+id[2]+"."+id[3]+"."+id[4];
	return id;
}

// return IP array of Broadcast IP address
function get_broadcast_ip(ip, mask)
{
	var id = new Array();
	var ipaddr = get_ip(ip);
	var subnet = get_ip(mask);

	id[1] = ipaddr[1] | (subnet[1] ^ 255);
	id[2] = ipaddr[2] | (subnet[2] ^ 255);
	id[3] = ipaddr[3] | (subnet[3] ^ 255);
	id[4] = ipaddr[4] | (subnet[4] ^ 255);
	id[0] = id[1]+"."+id[2]+"."+id[3]+"."+id[4];
	return id;
}

function is_valid_port_str(port)
{
	return is_in_range(port, 1, 65535);
}

// return true if the port is valid.
function is_valid_port(obj)
{
	if (is_valid_port_str(obj.value)==false)
	{
		field_focus(obj, '**');
		return false;
	}
	return true;
}

function is_valid_port_range_str(port1, port2)
{
	if (is_blank(port1)) return false;
	if (!is_valid_port_str(port1)) return false;
	if (is_blank(port2)) return false;
	if (!is_valid_port_str(port2)) return false;
	var i = parseInt(port1, [10]);
	var j = parseInt(port2, [10]);
	if (i > j) return false;
	return true;
}

// return true if the port range is valid.
function is_valid_port_range(obj1, obj2)
{
	return is_valid_port_range_str(obj1.value, obj2.value);
}
// if min <= value <= max, than return true,
// otherwise return false.
function is_in_range(str_val, min, max)
{
	var d = decstr2int(str_val);
	if ( d > max || d < min ) return false;
	return true;
}
// return true if the IP address is valid.
function is_valid_ip(ipaddr, optional)
{
	var ip = get_ip(ipaddr);
	if (optional!=0 && is_blank(ipaddr)) return true;
	if (is_in_range(ip[1], 1, 223)==false) return false;
	if (decstr2int(ip[1]) == 127) return false;
	if (is_in_range(ip[2], 0, 255)==false) return false;
	if (is_in_range(ip[3], 0, 255)==false) return false;
	if (is_in_range(ip[4], 0, 255)==false) return false;

	ip[0] = parseInt(ip[1],[10])+"."+parseInt(ip[2],[10])+"."+parseInt(ip[3],[10])+"."+parseInt(ip[4],[10]);
	if (ip[0] != ipaddr) return false;

	return true;
}
//Kwest++, 2008/06/06,check if IP address is valid according to IP address and Netmask.
function is_valid_ip2(ipaddr, netmask,ipaddr2)
{
	var ip_broadcast = get_broadcast_ip(ipaddr, netmask);
	var ip_network = get_network_id(ipaddr, netmask);//jana added
	//if(ip_broadcast[0] == ipaddr) return false; //jana removed
	if(ip_broadcast[0] == ipaddr || ip_network[0] == ipaddr) return false; //jana added
	if(typeof(ipaddr2) != "undefined")
	{
		var ip_network2 = get_network_id(ipaddr2, netmask);	
		if(ip_network[0] != ip_network2[0])
			return false;
	}
	return true;
}
//Ella++, 2008/01/11, fix ip netmask bug temporarily.
function is_valid_gateway(ipaddr, netmask, gateway, optional)
{
	var ip = get_ip(gateway);
	var ip_broadcast = get_broadcast_ip(ipaddr, netmask);
	var ip_networkid = get_network_id(ipaddr, netmask);

	if (optional!=0 && is_blank(gateway)) return true;
	if (is_in_range(ip[1], 1, 223)==false) return false;
	if (decstr2int(ip[1]) == 127) return false;
	if (is_in_range(ip[2], 0, 255)==false) return false;
	if (is_in_range(ip[3], 0, 255)==false) return false;
	//if (is_in_range(ip[4], 1, 255)==false) return false;
	if (is_in_range(ip[4], 0, 255)==false) return false;//gold change

	ip[0] = parseInt(ip[1],[10])+"."+parseInt(ip[2],[10])+"."+parseInt(ip[3],[10])+"."+parseInt(ip[4],[10]);
	if (ip[0] != gateway) return false;

	if(ip_networkid[0] == gateway) return false;
	if(ip_broadcast[0] == gateway) return false;
	
	return true;
	
}
// return true if the network address is valid.
function is_valid_network(ipaddr, mask)
{
	var ip = get_network_id(ipaddr, mask);
	if (ip[0] != ipaddr)	return false;
	return true;
}

// return false if the value is not a valid netmask value.
function __is_mask(str)
{
	d = decstr2int(str);
	if (d==0 || d==128 || d==192 || d==224 || d==240 || d==248 || d==252 || d==254 || d==255) return true;
	return false;
}

// return true if the netmask is valid.
function is_valid_mask(mask)
{
   var sMask=mask.split(".");
   
   if (sMask.length!=4) return false;
   
   for(var i=0; i< sMask.length; i++)
   {
      if (!is_digit(sMask[i])) return false;
      if (parseInt(sMask[i],10) < 0 || parseInt(sMask[i],10) > 255) return false;
   }

   for (var i =0 ; i< sMask.length; i++)
      sMask[i] = parseInt(sMask[i], 10);
   
   U32ip = sMask[0]*0x1000000+sMask[1]*0x10000+sMask[2]*0x100+sMask[3];

   if(U32ip==0) return false;
		
   for(var i=0; i<32;i++)
   {
      if(U32ip & (0x1<<i))
      {
         var myvalue = Math.pow(2,i)-1;
         myvalue = Math.pow(2,32) -1 -myvalue;
			
         if (myvalue == U32ip)
   			return true;	
         else
            return false;
      }
   }
	
   return false;
}
function is_hexdigit(str)
{

if (str.length==0) return false;

for (var i=0;i < str.length;i++)
{
	if (str.charAt(i) <= '9' && str.charAt(i) >= '0') 
		continue;
	if (str.charAt(i) <= 'F' && str.charAt(i) >= 'A') 
		continue;
	if (str.charAt(i) <= 'f' && str.charAt(i) >= 'a') 
		continue;
		
	return false;
}
return true;
}

function is_valid_mac(mac)
{
	if (mac.length > 2)
		return false;
		
	return is_hexdigit(mac);
}

function verify_mac(macValue, macObj)
{
	
	mac = get_mac(macValue);
	if(parseInt(mac[1],16) % 2)
		return false;
	for (j=1;j<=6;j++)
	{		
		if (!is_valid_mac(mac[j]))
		{
			return false;
		}
		if (mac[j].length == 1) mac[j] = "0"+mac[j];
	}
	if(macObj)
		macObj.value = mac[1]+":"+mac[2]+":"+mac[3]+":"+mac[4]+":"+mac[5]+":"+mac[6];
		
	return true;
}

function fucCheckNumDot(NUM) 
{ 
	var i,j,strTemp; 
	strTemp="0123456789."; 
	if ( NUM.length== 0) 
		return false;
	for (i=0;i<NUM.length;i++) 
	{ 
		j=strTemp.indexOf(NUM.charAt(i)); 
		if (i==0 && NUM.charAt(0)==".")
		{
			//˵ÃµÚ»¸öûÊ×
			return false;
		}
		if (j==-1) 
		{ 
			//˵ÃÓ×·ûÊ× 
			return false; 
		} 
	} 
	//˵ÃÊÊ× 
	return true; 
}

function is_valid_mac_str(mac)
{
	var tmp_mac=get_mac(mac);
	var cmp_mac="";
	var cmp_mac1="";
	var i, sub_mac, sub_dec_mac;
	for(i=1;i<=6;i++)
	{
		sub_mac=eval("tmp_mac["+i+"]");
		sub_dec_mac=hexstr2int(sub_mac);
		if(sub_dec_mac>255 ||sub_dec_mac<0)	return false;
		else if(sub_dec_mac<=15)
		{
			cmp_mac +="0"+sub_dec_mac.toString(16);
			cmp_mac1+="0"+sub_dec_mac.toString(16);
		}
		else
		{
			cmp_mac +=sub_dec_mac.toString(16);
			cmp_mac1+=sub_dec_mac.toString(16);
		}
		if(i!=6)
		{
			cmp_mac +=":";
			cmp_mac1+="-";
		}
	}
	if(cmp_mac!=mac.toLowerCase() && cmp_mac1!=mac.toLowerCase())	return false;
	return true;
}

// *********************************** ip.js stop *************************************

function select_index(obj, val)
{
    var i=0;
    for(i=0; i<obj.length;i++)
    {
        if(eval("obj["+i+"].value")==val)
        {
            obj.selectedIndex=i;
            break;
        }
    }
}











