
var BLANK_VALID = true;
var BLANK_INVALID = false;
var SPACE_VALID = true;
var SPACE_INVALID = false
var SLASH_VALID = true;
var SLASH_INVALID = false;
var IS_MAC_FLT = true;
var IS_NOT_MAC_FLT = false;
var ERROR_ENCODE_URL = "(E)(R)(R)(O)(R)!!(R)(O)(R)(R)(E)";
var TYPE_NETWORK_ADDRESS = "NETWORK";
var TYPE_IP_ADDRESS = "IP";
var TYPE_BRCAST_ADDRESS = "BROADCAST";

//Frederick,070214	add disabling of all elements under 1 id given
DISABLED = true;
ENABLED = false;


function isHexaDigit(digit) {
   var hexVals = new Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
                           "A", "B", "C", "D", "E", "F", "a", "b", "c", "d", "e", "f");
   var len = hexVals.length;
   var i = 0;
   var ret = false;

   for ( i = 0; i < len; i++ )
      if ( digit == hexVals[i] ) break;

   if ( i < len )
      ret = true;

   return ret;
}

//Function Name: isValidKey(val,size[,fieldname])
//Description: check value entered is a valid key for wireless key
//Parameters: val : value to be checked
//			  size: size 13(128bit)|5(64bit)
//			  fieldname (optional): show error message if error encountered
//Output: true - no error	false: error
function isValidKey(val, size, fieldname) {
   var ret = false;
   var len = val.length;
   var dbSize = size * 2;

	var addcomment1 = "请输入13 个ASCII 字符或26 个十六进制数作为128比特WEP加密密钥.";
	var addcomment2 = "请输入5 个ASCII 字符或13 个十六进制数 作为64比特WEP加密密钥.";

   if ( len == size )
      ret = true;
   else if ( len == dbSize ) {
      for ( i = 0; i < dbSize; i++ )
         if ( isHexaDigit(val.charAt(i)) == false )
            break;
      if ( i == dbSize )
         ret = true;
   } else
      ret = false;

	if (fieldname != undefined) //show error message if fieldname is available
	   if (ret == false){
		if (size == 5)
			alertInvalid (fieldname,val,addcomment2);
		else if (size == 13)
			alertInvalid (fieldname,val,addcomment1);
	   }

   return ret;
}


function isValidHexKey(val, size) {
   var ret = false;
   if (val.length == size) {
      for ( i = 0; i < val.length; i++ ) {
         if ( isHexaDigit(val.charAt(i)) == false ) {
            break;
         }
      }
      if ( i == val.length ) {
         ret = true;
      }
   }

   return ret;
}


function isNameUnsafe(compareChar) {
// Jerry 20040628, @ . is allow
//   var unsafeString = "\"<>%\\^[]`\+\$\,='#&@.: \t";
   var unsafeString = "\"<>%\\^[]`\+\$\,='#&: \t;";

   if ( unsafeString.indexOf(compareChar) == -1 && compareChar.charCodeAt(0) > 32
        && compareChar.charCodeAt(0) < 123 )
      return false; // found no unsafe chars, return false
   else
      return true;
}

// Check if a name valid
//Frederick,060731	add fields and modify error checks
//check if the name is URL friendly
//Function Name: isValidName(name[,fieldname][,isblankvalid][,isSpaceValid])
//Description: Check that name contains no unnecessary characters
//Parameters: name, fieldname(optional): show error message when error encountered
//			isblankvalid: BLANK_VALID - allow empty values	| BLANK_INVALID(default) - don't allow empty values
//			isSpaceValid: SPACE_VALID - allow space characetrs | SPACE_INVALID(default) - don't allow space characters
//output: true:no error		false: error
function isValidName(name,fieldname,isblankvalid,isSpaceValid,isSlashValid) {
   var i = 0;
   var hasField = false;

	if (fieldname != undefined) hasField = true;

   if (name=="")
	if ((isblankvalid == undefined) || (isblankvalid == false))
	{
		if (hasField)	alertInvalid(fieldname,name);
		return false;
	}

   if ((isSpaceValid == undefined) || (isSpaceValid == false)){
	   for ( i = 0; i < name.length; i++ ) {
	      if ( isNameUnsafe(name.charAt(i)) == true )
		  {
			if (hasField)	alertInvalid(fieldname,name);
	         return false;
		  }
	   }
	}
	else
	{
	   for ( i = 0; i < name.length; i++ ) {
		      if ( isCharUnsafe(name.charAt(i)) == true ){
				if (hasField)	alertInvalid(fieldname,name);
        		 return false;
		   }
		}
	}

	if ( isSlashValid==SLASH_INVALID ){
		if ( name.indexOf("/") != -1 )
		{
			if (hasField)	alertInvalid(fieldname,name);
	    	return false;
		}
	}


   return true;
}

// same as is isNameUnsafe but allow spaces
function isCharUnsafe(compareChar) {
   var unsafeString = "\"<>%\\^[]`\+\$\,='#&@.:\t;";

   if ( unsafeString.indexOf(compareChar) == -1 && compareChar.charCodeAt(0) >= 32
        && compareChar.charCodeAt(0) < 123 )
      return false; // found no unsafe chars, return false
   else
      return true;
}



function isSameSubNet(lan1Ip, lan1Mask, lan2Ip, lan2Mask) {

   var count = 0;

   lan1a = lan1Ip.split('.');
   lan1m = lan1Mask.split('.');
   lan2a = lan2Ip.split('.');
   lan2m = lan2Mask.split('.');

   for (i = 0; i < 4; i++) {
      l1a_n = parseInt(lan1a[i], 10);
      l1m_n = parseInt(lan1m[i], 10);
      l2a_n = parseInt(lan2a[i], 10);
      l2m_n = parseInt(lan2m[i], 10);
      if ((l1a_n & l1m_n) == (l2a_n & l2m_n))
         count++;
   }
   if (count == 4)
      return true;
   else
      return false;
}

//Frederick,060731	add optional fieldname parameter
//Function Name: isValidIpAddress(address[,fieldname][,type])
//Description: Check that address entered is valid ip address
//Parameters: address, 	fieldname(optional): entering will show error message when encountered
//			  type: TYPE_NETWORK_ADDRESS:check network address | TYPE_IP_ADDRESS (default) check of type IP address
//output: true:no error		false:has error
function isValidIpAddress(address,fieldname,type) {
   var i = 0;
   var c = '';
   var hasfield = false;

   if (fieldname != undefined)	hasfield = true;


   if (address == "") {
       if (hasfield) alertInvalid(fieldname,address);
	   return false;
  }

   for (i = 0; i < address.length; i++) {
     c = address.charAt(i);
     if((c>='0'&&c<='9')||(c=='.'))
       continue;
     else
	 {
       if (hasfield) alertInvalid(fieldname,address);
	   return false;
  	  }
   }
   if ( address == '0.0.0.0' ||
        address == '255.255.255.255' )
	 {
       if (hasfield) alertInvalid(fieldname,address);
      return false;
	 }

   addrParts = address.split('.');

	//Frederick,060724	Make sure that everything is in decimal place
	for (i=0; i < addrParts.length; i++){
		addrParts[i] = parseInt(addrParts[i],10);
		addrParts[i] += "";
	}

   if ( addrParts.length != 4 ) 	 {
       if (hasfield) alertInvalid(fieldname,address);
		return false;
	}

   for (i = 0; i < 4; i++) {
      if (isNaN(addrParts[i]) || addrParts[i] =="")
	 {
       if (hasfield) alertInvalid(fieldname,address);
         return false;
	 }
      num = parseInt(addrParts[i],10);
      if ( num < 0 || num > 255 )
	 {
       if (hasfield) alertInvalid(fieldname,address);
         return false;
	 }
	  if (addrParts[i].length > 3)
	 {
       if (hasfield) alertInvalid(fieldname,address);
		return false;
	 }
   }

	if ((type == undefined) || (type==TYPE_IP_ADDRESS)){
	   if (parseInt(addrParts[0],10)==0||parseInt(addrParts[3],10)==0||parseInt(addrParts[0],10)==127||parseInt(addrParts[0],10)>223)
		 {
	       	if (hasfield) alertInvalid(fieldname,address);
   				return false;
		 }
	}else{
		if (type == TYPE_NETWORK_ADDRESS){
			if ((parseInt(addrParts[0],10)==0) || (parseInt(addrParts[0],10)==127)||parseInt(addrParts[0],10)>223)
			 {
		       	if (hasfield) alertInvalid(fieldname,address);
   					return false;
			 }
		}
	}

   return true;
}

function getLeftMostZeroBitPos(num) {
   var i = 0;
   var numArr = [128, 64, 32, 16, 8, 4, 2, 1];

   for ( i = 0; i < numArr.length; i++ )
      if ( (num & numArr[i]) == 0 )
         return i;

   return numArr.length;
}

function getRightMostOneBitPos(num) {
   var i = 0;
   var numArr = [1, 2, 4, 8, 16, 32, 64, 128];

   for ( i = 0; i < numArr.length; i++ )
      if ( ((num & numArr[i]) >> i) == 1 )
         return (numArr.length - i - 1);

   return -1;
}

//Function Name: isValidSubnetMask(mask[,fieldname])
//Description: Check if mask entered is valid subnet mask or not)
//Parameters: mask, fieldname(optional) shows error when encountered
//output: true:no error	false: has error
function isValidSubnetMask(mask,fieldname) {
   var i = 0, num = 0;
   var zeroBitPos = 0, oneBitPos = 0;
   var zeroBitExisted = false;
   var c = '';
   var hasField = false;

   if (fieldname != undefined) hasField = true;

   for (i = 0; i < mask.length; i++) {
     c = mask.charAt(i);
     if((c>='0'&&c<='9')||(c=='.'))
       continue;
     else
	 {
	   if (hasField) alertInvalid(fieldname,mask);
       return false;
	 }
   }
   if ( mask == '0.0.0.0' )
	 {
	   if (hasField) alertInvalid(fieldname,mask);
      return false;
	 }

   maskParts = mask.split('.');
   if ( maskParts.length != 4 )
	 {
	   if (hasField) alertInvalid(fieldname,mask);
		 return false; //Frederick 060503, this part is buggy, an entry of 255.255.255. will not be detected
	  }

	//Frederick, 060503	check that every single digit is not blank{
	for (i=0; i<maskParts.length; i++)
		if (maskParts[i].length < 1){
	   if (hasField) alertInvalid(fieldname,mask);
			return false;
		}
	//Frederick, 060503	check that every single digit is not blank}

   for (i = 0; i < 4; i++) {
      if ( isNaN(maskParts[i]) == true ){
	   if (hasField) alertInvalid(fieldname,mask);
         return false;
		}
      num = parseInt(maskParts[i]);
      if ( num < 0 || num > 255 )	 {
	   if (hasField) alertInvalid(fieldname,mask);
         return false;
		}
      if ( zeroBitExisted == true && num != 0 )	 {
	   if (hasField) alertInvalid(fieldname,mask);
         return false;
		}
      zeroBitPos = getLeftMostZeroBitPos(num);
      oneBitPos = getRightMostOneBitPos(num);
      if ( zeroBitPos < oneBitPos )	 {
	   if (hasField) alertInvalid(fieldname,mask);
         return false;
		}
      if ( zeroBitPos < 8 )
         zeroBitExisted = true;
   }
   if (parseInt(maskParts[0])==0)	 {
	   if (hasField) alertInvalid(fieldname,mask);
   	return false;
		}

   if (parseInt(maskParts[3])>=255)	 {
	   if (hasField) alertInvalid(fieldname,mask);
   	return false;
		}

   return true;
}

//Function NAme: isValidPort(port[,fieldname])
//description: Check if the port number entered is valid or not
//Parameters: port: single integer or range (xx:yy)
//			fieldname: fieldname of port to be checked, show alert if available
//output: true: no error	false: has error
function isValidPort(port,fieldname) {
   var fromport = 0;
   var toport = 100;
   var hasField = false;

   if (fieldname != undefined) hasField = true;

   portrange = port.split(':');
   if ( portrange.length < 1 || portrange.length > 2 ) {
	{
	   if (hasField) alertInvalid(fieldname,port);
       return false;
	}
   }
   if ( isNaN(portrange[0]) )
	{
	   if (hasField) alertInvalid(fieldname,port);
       return false;
	}
   //fromport = parseInt(portrange[0]);
   fromport = (portrange[0] * 1);
   if ( portrange.length > 1 ) {
       if ( isNaN(portrange[1]) )
		{
	   if (hasField) alertInvalid(fieldname,port);
          return false;
	    }
       //toport = parseInt(portrange[1]);
		toport = (portrange[1] * 1);
       if ( toport <= fromport )
		{
	   if (hasField) alertInvalid(fieldname,port);
           return false;
		}
   }

   if ( fromport < 1 || fromport > 65535 || toport < 1 || toport > 65535 )
	{
	   if (hasField) alertInvalid(fieldname,port);
       return false;
	}

   return true;
}

function isValidNatPort(port) {
   var fromport = 0;
   var toport = 100;

   portrange = port.split('-');
   if ( portrange.length < 1 || portrange.length > 2 ) {
       return false;
   }
   if ( isNaN(portrange[0]) )
       return false;
   //fromport = parseInt(portrange[0]);
	fromport = (portrange[0] * 1);
   if ( portrange.length > 1 ) {
       if ( isNaN(portrange[1]) )
          return false;
       //toport = parseInt(portrange[1]);
		toport = (portrange[1] * 1);
       if ( toport <= fromport )
           return false;
   }

   if ( fromport < 1 || fromport > 65535 || toport < 1 || toport > 65535 )
       return false;

   return true;
}


function isValidMacAddress(address,ismacflt,fieldname) {
   var c = '';
   var i = 0, j = 0;
   var hasField;
   var additionalComment = " 例如: 00:22:33:AA:BB:CC";

	if (fieldname != undefined) hasField = true;

   if ((ismacflt == undefined) || (ismacflt == false)){   //can also allow no input at all
   	if (( address.toLowerCase() == 'ff:ff:ff:ff:ff:ff' ) || ( address.toLowerCase() == '00:00:00:00:00:00' )){
			if (hasField) alertInvalid(fieldname,address,additionalComment);
			return false;
		}
	}

   addrParts = address.split(':');
   if ( addrParts.length != 6 ) {
		if (hasField) alertInvalid(fieldname,address,additionalComment);
		return false;
	}

   for (i = 0; i < 6; i++) {
      if ( addrParts[i] == '' ){
		if (hasField) alertInvalid(fieldname,address,additionalComment);
         return false;
	  }
	  //Frederick, 060523	one byte can consist of only 2 characters{
	  if (addrParts[i].length != 2){
		if (hasField) alertInvalid(fieldname,address,additionalComment);
		 return false;
	  }
	  //Frederick, 060523}
      for ( j = 0; j < addrParts[i].length; j++ ) {
         c = addrParts[i].toLowerCase().charAt(j);
         if ( (c >= '0' && c <= '9') ||
              (c >= 'a' && c <= 'f') )
            continue;
         else
		 {
			if (hasField) alertInvalid(fieldname,address,additionalComment);
            return false;
		 }
      }
   }

	//aids, add checking for multicast mac address
   if ((parseInt(addrParts[0], 16) % 2) == 1){
	if (hasField) alertInvalid(fieldname,address,additionalComment);
	return false;
   }

   return true;
}

function isValidMacFltAddress(address,fieldname) {
   var c = '';
   var i = 0, j = 0;
   var hasField = false;
   var additionalComment = " 例如: 00:22:33:AA:BB:CC";

   if (fieldname != undefined) hasField = true;

   addrParts = address.split(':');
   if ( addrParts.length != 6 ) return false;

   for (i = 0; i < 6; i++) {
      if ( addrParts[i] == '' )
	  {
	     alertInvalid(fieldname,address,additionalComment);
         return false;
	  }
	  //Frederick, 060523	one byte can consist of only 2 characters{
	  if (addrParts[i].length != 2)
	  {
	     alertInvalid(fieldname,address,additionalComment);
		 return false;
	  }
	  //Frederick, 060523}
      for ( j = 0; j < addrParts[i].length; j++ ) {
         c = addrParts[i].toLowerCase().charAt(j);
         if ( (c >= '0' && c <= '9') ||
              (c >= 'a' && c <= 'f') )
            continue;
         else
	     {
	     alertInvalid(fieldname,address,additionalComment);
            return false;
		 }
      }
   }

   return true;
}

var hexVals = new Array("0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
              "A", "B", "C", "D", "E", "F");
var unsafeString = "\"<>%\\^[]`\+\$\,'#&";
// deleted these chars from the include list ";", "/", "?", ":", "@", "=", "&" and #
// so that we could analyze actual URLs

function isUnsafe(compareChar)
// this function checks to see if a char is URL unsafe.
// Returns bool result. True = unsafe, False = safe
{
   if ( unsafeString.indexOf(compareChar) == -1 && compareChar.charCodeAt(0) > 32
        && compareChar.charCodeAt(0) < 123 )
      return false; // found no unsafe chars, return false
   else
      return true;
}

function decToHex(num, radix)
// part of the hex-ifying functionality
{
   var hexString = "";
   while ( num >= radix ) {
      temp = num % radix;
      num = Math.floor(num / radix);
      hexString += hexVals[temp];
   }
   hexString += hexVals[num];
   return reversal(hexString);
}

function reversal(s)
// part of the hex-ifying functionality
{
   var len = s.length;
   var trans = "";
   for (i = 0; i < len; i++)
      trans = trans + s.substring(len-i-1, len-i);
   s = trans;
   return s;
}


//Frederick, 060414	Add converting of special characters for URL encoding {
function convertSpclChar (compareChar) {

	var i_ctr = 0;
	var toConvertString = "\"<>%\\^[]`\+\$\,='#&: \t";
	var returnString = "";

	while (i_ctr < compareChar.length){

		if (toConvertString.indexOf(compareChar.charAt(i_ctr)) == -1)
			returnString = returnString + compareChar.charAt(i_ctr);
		else
			returnString = returnString + convert(compareChar.charAt(i_ctr));

		i_ctr++;
	}

	return returnString
}
//Frederick, 060414 Add converting of special characters for URL encoding }


//Frederick, 060503	Check if there's a ":" available or else don't allow post, issue of WinXP SP2{
//Function Name: checkFile(txtBox)
//Description: Check if the filename input is valid or not
//Parameters: txtBox : textbox containinig file path
//Output: true: no error	false: has error
function checkFile(txtBox)
{
//aids, 060719 fix for F/W upgrade linux.
var OS = GetBrowserOS();

	if (txtBox.length == 0)
	{
		alert("请输入有效的文件名.");
		return false;
	}

if (OS.indexOf("win")!=-1){

	if (txtBox.indexOf("\\\\")!=-1)
		return true;

	//check if a : is existing
	temp = txtBox.search(":");
	if (temp != 1)
	{
		alert("请输入有效的文件名.");
		return false;
	}
}

	return true;
}

//Frederick, 060503	Check if there's a ":" available or else don't allow post, issue of WinXP SP2}


function convert(val)
// this converts a given char to url hex form
{
   return  "%" + decToHex(val.charCodeAt(0), 16);
}


//Function Name: encodeUrl(val[,fieldname])
//Description: Encodes any special characers encountered to URL format
//Parameters: val, fieldname (optional) if available will show alert when error encountered
//Output: New encoded URL
//		  ERROR_ENCODE_URL : error encountered, non-ISO-8859-1 characters found
function encodeUrl(val,fieldname)
{
   var len     = val.length;
   var i       = 0;
   var newStr  = "";
   var original = val;
   var hasField = false;

   if (fieldname != undefined ) hasField = true;

   for ( i = 0; i < len; i++ ) {
//aids, 080123 exclude ASCII characters above 126
      if ( val.substring(i,i+1).charCodeAt(0) < 127 ) {
         // hack to eliminate the rest of unicode from this
         if (isUnsafe(val.substring(i,i+1)) == false)
            newStr = newStr + val.substring(i,i+1);
         else
            newStr = newStr + convert(val.substring(i,i+1));
      } else {
         // woopsie! restore.
         //alert ("Found a non-ISO-8859-1 character at position: " + (i+1) + ",\nPlease eliminate before continuing.");
         newStr = original;

		 if (hasField) {
			alertInvalid(fieldname,val);
			newStr = ERROR_ENCODE_URL;
		 }

         // short-circuit the loop and exit
         i = len;
      }
   }

   return newStr;
}

var markStrChars = "\"'";

// Checks to see if a char is used to mark begining and ending of string.
// Returns bool result. True = special, False = not special
function isMarkStrChar(compareChar)
{
   if ( markStrChars.indexOf(compareChar) == -1 )
      return false; // found no marked string chars, return false
   else
      return true;
}

// use backslash in front one of the escape codes to process
// marked string characters.
// Returns new process string
function processMarkStrChars(str) {
   var i = 0;
   var retStr = '';

   for ( i = 0; i < str.length; i++ ) {
      if ( isMarkStrChar(str.charAt(i)) == true )
         retStr += '\\';
      retStr += str.charAt(i);
   }

   return retStr;
}

// Web page manipulation functions

function showhide(element, sh)
{
    var status;
    if (sh == 1) {
        status = "block";
    }
    else {
        status = "none"
    }

	if (document.getElementById)
	{
		// standard
		document.getElementById(element).style.display = status;
	}
	else if (document.all)
	{
		// old IE
		document.all[element].style.display = status;
	}
	else if (document.layers)
	{
		// Netscape 4
		document.layers[element].display = status;
	}
}

// Load / submit functions

function getSelect(item)
{
	var idx;
	if (item.options.length > 0) {
	    idx = item.selectedIndex;
	    return item.options[idx].value;
	}
	else {
		return '';
    }
}

function setSelect(item, value)
{
	for (i=0; i<item.options.length; i++) {
        if (item.options[i].value == value) {
        	item.selectedIndex = i;
        	break;
        }
    }
}

function setCheck(item, value)
{
    if ( value == '1' ) {
         item.checked = true;
    } else {
         item.checked = false;
    }
}

function setDisable(item, value)
{
    if ( value == 1 || value == '1' ) {
         item.disabled = true;
    } else {
         item.disabled = false;
    }
}

function submitText(item)
{
	return '&' + item.name + '=' + item.value;
}

function submitSelect(item)
{
	return '&' + item.name + '=' + getSelect(item);
}


function submitCheck(item)
{
	var val;
	if (item.checked == true) {
		val = 1;
	}
	else {
		val = 0;
	}
	return '&' + item.name + '=' + val;
}

//add by alex, 08/31/05'

//Function Name: isInteger (val)
//Description: Check if the value entered is an integer or not
//Parameters: val
//output: true - no error	false - error
function isInteger(val)
{
	var i;

	val = val + ""; //need to convert to string because 0 is treat as ""

	if (val == "")
		return false;

	for (i=0; i<val.length; i++ )
	{
		ch = val.charAt(i);
		if( (ch==' ')||(ch=='\n')||(ch=='\t') )
			return false;
		if (isNaN(ch))
			return false;
	}

	return true;
}


//Frederick,060731	Add fieldname check and also support backward compatibility
//Function  Name: isInValidRange(s,low,high,fieldname(optional))
//Description: Check if s is in the range between low and high.
//Parameters:	s: value to be checked, low:starting range	high: ending range
//				fieldname (optional), if available will show an error message upon error encountered
//output: true - no error	false - has error
function isInValidRange(s,low,high,fieldname) {

	if((isInteger(s) == false)||(isNaN(s)==true))
	{
		if (fieldname != undefined) alertInvalid(fieldname,s);
		return false;

	}

	s = parseInt(s,10);


 	if(s<low||s>high){
		if (fieldname != undefined) alert (fieldname + " " + s + " 超出了范围 [" + low + "-" + high + "].");
    	return false;
	}
	else
		return true;

}

//add by koukai,2005/06/03

function isBlank(s) {
	var c;
	for(i=0;i<s.length;i++) {
		c = s.charAt(i);
		if( (c!=' ')&&(c!='\n')&&(c!='\t') )
	            return false;
	}
	return true;
}



function isValidName_Voice(raw)
{
	var i;
	var ch;

	if(raw == "")
	{
		return true;
	}
	else if(raw.length != 0)
	{
		for(i = 0; i<raw.length; i++)
		{
			ch = raw.charAt(i);
			if(ch.search(/[0-9]|[a-z]|[A-Z]|-/) == -1)  //modify by alex,08/30/2005
			{
				return false;
			}
		}
	}

	return true;

}


function isValidPassword(val)
{
    var ch;
    for(j = 0; j < val.length; j++)
    {
        ch = val.charAt(j);
        if (ch.search(/[0-9]|[a-z]|[A-Z]/) == -1)
            return false;
    }
    return true;
}




function isFormElements_UsedByAddress(name)
{
    var isExists = false;
    for(i=0; i<document.forms[0].elements.length;i++)
    {
        if(document.forms[0].elements[i].name == name)
        {
            isExists = true;
            break;
        }
    }
    if(document.forms[0].elements[i].value == "")
	{
		document.forms[0].elements[i].value = '0.0.0.0';
		return ('0.0.0.0');
	}
	else
    	return (document.forms[0].elements[i].value);
}

function isFormElements_Checked(name)
{
    var isExists = false;
    for(i=0; i<document.forms[0].elements.length;i++)
    {
        if(document.forms[0].elements[i].name == name)
        {
            isExists = true;
            break;
        }
    }
    if(document.forms[0].elements[i].checked == true)
		return true;
	else
    	return false;
}

function isFormElements(name)
{
    var isExists = false;
    for(i=0; i<document.forms[0].elements.length;i++)
    {
        if(document.forms[0].elements[i].name == name)
        {
            isExists = true;
            break;
        }
    }
    if(document.forms[0].elements[i].value == "")
	{
		document.forms[0].elements[i].value = 0;
		return (0);
	}
	else
    	return (document.forms[0].elements[i].value);
}


function SetFormElementsFocus(name)
{
    var isExists = false;
    for(i=0; i<document.forms[0].elements.length;i++)
    {
        if(document.forms[0].elements[i].name == name)
        {
            isExists = true;
            document.forms[0].elements[i].focus();
            break;
        }
    }

    return (isExists);
}


function isValidIPOrDomainName(str)
{
	var i;
	var str_array = str.split(".");

	for (i=0; i<str_array.length; i++ )
	{
		if (str_array[i] == "")
			return false;
	}
	for (i=0; i<str_array.length; i++ )
	{
		if (!isInteger(str_array[i]))
			break;
	}

	if (i == str_array.length)
	{
		if (str_array.length == 4)
		{
			if (!isValidIpAddress(str))
				return false;
		}
		else
			return false;
	}
	return true;
}



//Function Name: GetBrowserOS
//Description: Gets the current OS version and browser version of OS
//Parameters: none
//Output: <browser><OS>
function GetBrowserOS()
{

	var detect = navigator.userAgent.toLowerCase();
	var OS,browser,version,total,thestring, browseVer;

	if (do_checkstr('konqueror'))
	{
		browser = "Konqueror";
		OS = "Linux";
	}
	else if (do_checkstr('safari')) browser = "safa";
	else if (do_checkstr('omniweb')) browser = "omni";
	else if (do_checkstr('opera')) browser = "oper";
	else if (do_checkstr('webtv')) browser = "webt";
	else if (do_checkstr('icab')) browser = "icab";
	else if (do_checkstr('msie')) browser = "msie";
	//Frederick,060721	Add firefox detection
	else if(navigator.userAgent.indexOf("Firefox")!=-1){
		var versionindex=navigator.userAgent.indexOf("Firefox")+8
		if (parseInt(navigator.userAgent.charAt(versionindex))>=1)
		browser = "fire";
	}
	else if (!do_checkstr('compatible'))
	{
		browser = "nets"
	}
		else browser = "unknown";

	if (browser != "unknown")
		if (!OS)
		{
			if (do_checkstr('linux')) OS = "lin";
			else if (do_checkstr('x11')) OS = "uni";
			else if (do_checkstr('mac')) OS = "mac"
			else if (do_checkstr('win')) OS = "win"
			else OS = "unknown";
		}

	browseVer = browser + OS;

	return browseVer;
}


function do_checkstr(string)
{
	var detect = navigator.userAgent.toLowerCase();
	place = detect.indexOf(string) + 1;
	thestring = string;
	return place;
}





//Function Name:reencodeIP (IP)
//Description: Re-encodes IP address to make sure that it is in proper format *e.g. 0192.0168.1.1 -> 192.168.1.1
//Parameters: IP
//Output: IP
function reencodeIP (IP)
{
	var newIP = '';
	addrParts = IP.split('.');

	//Frederick,060724	Make sure that everything is in decimal place
	for (i=0; i < addrParts.length; i++)
		if (i == 3)
			newIP = newIP + parseInt(addrParts[i],10);
		else
			newIP = newIP + parseInt(addrParts[i],10) + '.';

	return newIP;
}




//Function Name:isOverlapModemIp(EndIp, StartIp, ModemIp)
//Description: Check if the StartIp and EndIp is overlapping ModemIp
//Parameters: EndIp, StartIp, ModemIp
//output: true - no error
//		  false - error
function isOverlapModemIp(EndIp, StartIp, ModemIp)
{
   addrEnd = EndIp.split('.');
   addrStart = StartIp.split('.');
   addrModem = ModemIp.split('.');
	E = parseInt(addrEnd[3],10) + 1;
    S = parseInt(addrStart[3],10) + 1;
	M = parseInt(addrModem[3],10) + 1;

	//it is assumed that end ip and start ip lie in the same subnet as checked by previous validation
	//check that modem ip it doesn't lie within ip range

	if ((S<=M) && (M<=E))
		return true;
	else
		return false;
}



//Add is invalid message
//Function Name: alertInvalid(fieldname, fieldvalue [,additional])
//Description: alerts invalid message containing fieldname and value
//Parameters: fieldname, fieldvalue, additional - Any additional comments to be added
//Output: MessageBox(invalid message)
function alertInvalid(fieldname, fieldvalue, additional)
{
	if (additional == undefined)
		alert (fieldname + " " + fieldvalue + " 无效.");
	else
		alert (fieldname + " " + fieldvalue + " 无效, " + additional + ".");
}

//Frederick,060731	Add isValidTime function
//Function name: isValidTime(time, fieldname)
//Description: Check if the time input in hh:mm is valid or not and returns the total number of mins
//Parameters: time (hh:mm), fieldname
//Output: -1 (error), integer (in mins)
function isValidTime(time,fieldname)
{

	var vals;
	var hasField = false;
	var hour, min;
	if (fieldname != undefined) hasField = true;

	vals = time.split(':');

	if (vals.length == 2){

		if (!isInteger(vals[0]) || !isInteger(vals[1])){
			if (hasField) alertInvalid(fieldname,time);
			return -1;
		}

		hour = parseInt(vals[0],10);
		min = parseInt(vals[1],10);

		if (!isInValidRange(hour,0,23)){
			if (hasField) alertInvalid(fieldname,time);
			return -1;
		}

		if (!isInValidRange(min,0,59)){
			if (hasField) alertInvalid(fieldname,time);
			return -1;
		}
	}
	else
	{
		if (hasField) alertInvalid(fieldname,time);
		return -1;
	}

	return (hour * 60 + min);
}


//Function Name: DoValidateIpRange(Subnet,Mask[,type])
//Description: Check if Subnet complies to Mask input for TYPE_IP_ADDRESS and TYPE_NETWORK_ADDRESS
//				check if Subnet + Mask is of type TYPE_BRCAST_ADDRESS
//Parameters: type <TYPE_IP_ADDRESS | TYPE_NETWORK_ADDRESS | TYPE_BRCAST_ADDRESS>
//				Default: TYPE_IP_ADDRESS
//Output: true - no error
//		  false - error
function DoValidateIpRange(Subnet, Mask, type)
{
  var Subadd = Subnet.match("^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$");
  var Maskadd = Mask.match("^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$");

	//do not do anything if required parameters are not specified
	if ((Subnet == "") || (Mask =="")) return true;

 var i;
  var error=false;
  var count = 0;

    var snm1a = 255;
    var snm2a = 255;
    var snm3a = 255;
    var snm4a = 255;

    var nw1a = 0;
    var nw2a = 0;
    var nw3a = 0;
    var nw4a = 0;

    var broad1a = 255;
    var broad2a = 255;
    var broad3a = 255;
    var broad4a = 255;

	arrSubadd = Subadd[0].split(".");
  	arrMask = Maskadd[0].split(".");

    snm1a = arrMask[0];
    snm2a = arrMask[1];
    snm3a = arrMask[2];
    snm4a = arrMask[3];

    var ck1a = arrSubadd[0];
    var ck2a = arrSubadd[1];
    var ck3a = arrSubadd[2];
    var ck4a = arrSubadd[3];

  	nw1a = eval(snm1a & ck1a);
	nw2a = eval(snm2a & ck2a);
	nw3a = eval(snm3a & ck3a);
	nw4a = eval(snm4a & ck4a);

	broad1a = ((nw1a) ^ (~ snm1a) & 255);
	broad2a = ((nw2a) ^ (~ snm2a) & 255);
	broad3a = ((nw3a) ^ (~ snm3a) & 255);
	broad4a = ((nw4a) ^ (~ snm4a) & 255);

	if ((type == undefined) || (type == TYPE_IP_ADDRESS)){
		if ((broad1a == arrSubadd[0]) && (broad2a == arrSubadd[1]) && (broad3a == arrSubadd[2]) && (broad4a == arrSubadd[3]))
		{
			//20070929 jeff  add the combination
			errVal = "IP地址:" + Subnet + " 和子网掩码:" + Mask;
			alertInvalid("",errVal," 请确认子网掩码.");

			return false;
		}

	}
	else if (type == TYPE_NETWORK_ADDRESS){
		var tempIP = nw1a + "." + nw2a + "." + nw3a + "." + nw4a;
		if (tempIP != Subnet){
			errVal = Subnet + " 和子网掩码: " + Mask;
			alertInvalid ("网络地址: ",errVal);
			//20070929 jeff  add the combination
			return false;
		}
	}
	else if (type == TYPE_BRCAST_ADDRESS){
		var tempIP = broad1a + "." + broad2a + "." + broad3a + "." + broad4a;
		if (tempIP != Subnet)
			return false;
	}



  return true;


}

function DoValidateNetworkIP(Subnet, Mask)
{
  var Subadd = Subnet.match("^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$");
  var Maskadd = Mask.match("^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$");

	//do not do anything if required parameters are not specified
	if ((Subnet == "") || (Mask =="")) return true;

 var i;
  var error=false;
  var count = 0;

    var snm1a = 255;
    var snm2a = 255;
    var snm3a = 255;
    var snm4a = 255;

    var nw1a = 0;
    var nw2a = 0;
    var nw3a = 0;
    var nw4a = 0;

    var broad1a = 255;
    var broad2a = 255;
    var broad3a = 255;
    var broad4a = 255;

	arrSubadd = Subadd[0].split(".");
  	arrMask = Maskadd[0].split(".");

    snm1a = arrMask[0];
    snm2a = arrMask[1];
    snm3a = arrMask[2];
    snm4a = arrMask[3];

    var ck1a = arrSubadd[0];
    var ck2a = arrSubadd[1];
    var ck3a = arrSubadd[2];
    var ck4a = arrSubadd[3];

  	nw1a = eval(snm1a & ck1a);
	nw2a = eval(snm2a & ck2a);
	nw3a = eval(snm3a & ck3a);
	nw4a = eval(snm4a & ck4a);

	broad1a = ((nw1a) ^ (~ snm1a) & 255);
	broad2a = ((nw2a) ^ (~ snm2a) & 255);
	broad3a = ((nw3a) ^ (~ snm3a) & 255);
	broad4a = ((nw4a) ^ (~ snm4a) & 255);

	var tempIP = nw1a + "." + nw2a + "." + nw3a + "." + nw4a;

	if (tempIP == Subnet){
		errVal = Subnet + " 和子网掩码: " + Mask;
		//20070929 jeff  add the combination
		alertInvalid ("IP 地址: ",errVal);
		return false;
	}

  return true;


}

//aids, 060810 for checking broadcast ip
function getBroadcastIP(HostIp, Mask)
{
  var Hostadd = HostIp.match("^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$");
  var Maskadd = Mask.match("^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$");
  var digits1, digits3;
  var result;
  var count = 0;

    var oct1a = 0;
    var oct2a = 0;
    var oct3a = 0;
    var oct4a = 0;

    var snm1a = 255;
    var snm2a = 255;
    var snm3a = 255;
    var snm4a = 255;

    var nw1a = 0;
    var nw2a = 0;
    var nw3a = 0;
    var nw4a = 0;

    var broad1a = 255;
    var broad2a = 255;
    var broad3a = 255;
    var broad4a = 255;

    digits1 = Hostadd[0].split(".");
    digits3 = Maskadd[0].split(".");

    oct1a = digits1[0];
    oct2a = digits1[1];
    oct3a = digits1[2];
    oct4a = digits1[3];

    snm1a = digits3[0];
    snm2a = digits3[1];
    snm3a = digits3[2];
    snm4a = digits3[3];

  	nw1a = eval(snm1a & oct1a);
	nw2a = eval(snm2a & oct2a);
	nw3a = eval(snm3a & oct3a);
	nw4a = eval(snm4a & oct4a);
	broad1a = ((nw1a) ^ (~ snm1a) & 255);
	broad2a = ((nw2a) ^ (~ snm2a) & 255);
	broad3a = ((nw3a) ^ (~ snm3a) & 255);
	broad4a = ((nw4a) ^ (~ snm4a) & 255);

	result = broad1a + "." + broad2a + "." + broad3a + "." + broad4a

  return result;
}

//rick, check date
function isDateValid(year, month, day)
{
	if (month == 2) {
		if ( ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0) )
		{
		  if(day > 29) return 0;
		}
		else
		{
		  if(day > 28) return 0;
		}
  }
  else if ((month == 4)||(month == 6)||(month == 9)||(month == 11))
  {
		  if(day > 30) return 0;
  }
  return 1;

}
//Function Name: isValidEmail(fieldvalue,[fieldname]))
//Description: Check if email address entered is valid
//Parameters: fieldvalue, fieldname
//Output: true - no error
//		  false - error
function isValidEmail(fieldvalue,fieldname){
	var hasField = false;
	if (fieldname != undefined) hasField = true;

	if (!isValidName(fieldvalue,fieldname,BLANK_INVALID,SPACE_INVALID)) return false;

	var tmpIndex = fieldvalue.indexOf('@');
	var dotIndex = fieldvalue.indexOf('.');

	if ((tmpIndex == -1) || (dotIndex == -1) || (tmpIndex == fieldvalue.length -1) || (dotIndex == fieldvalue.length -1)
		|| (tmpIndex == 0) || (dotIndex == 0)){
		if (hasField) alertInvalid (fieldname,fieldvalue);
		return false;
	}

	return true;
}


//Frederick,070214	add disabling of all elements under 1 id given
//Function name:changeBlockState(idname,status)
//Description: This function changes the disabled and color property of elements given under id
//	Input: idname : the id of the tag or DIV, must have id property
//		   status: ENABLED | DISABLED
function changeBlockState(idname,status){
	var i,currentcolor;
	var OS = GetBrowserOS();
	var tempelems = document.getElementById(idname).getElementsByTagName("*");

	if (status == false)
		currentcolor = "black";
	else
		currentcolor = "#aca899";

	for (i = 0; i < tempelems.length;i++){
		if (tempelems[i].disabled != undefined)
			tempelems[i].disabled = status;

	if (OS.indexOf("msie")!= -1){	//ie returns null, firefox uses undefined.....@#@%@^#@^
		if (tempelems[i].style.color)
			tempelems[i].style.color = currentcolor;
	}
	else{
		if (tempelems[i].style.color != undefined)
			tempelems[i].style.color = currentcolor;
		}
	}

	//Frederick,070226 disable the element itself
	var tempelems = document.getElementById(idname);
	if (tempelems.disabled != undefined)
		tempelems.disabled = status;

	if (OS.indexOf("msie")!= -1){	//ie returns null, firefox uses undefined.....@#@%@^#@^
		if (tempelems.style.color)
			tempelems.style.color = currentcolor;
	}
	else{
		if (tempelems.style.color != undefined)
			tempelems.style.color = currentcolor;
		}

}

function TcpIdToString(value){
 var tempVal = '';
 switch (value) {
         case '0':
            tempVal = 'TCP/UDP';
            break;
         case '1':
            tempVal = 'TCP';
            break;
         case '2':
            tempVal = 'UDP';
            break;
         case '3':
            tempVal = 'ICMP';
            break;
         default:
            tempVal = 'Any';
            break;
      }
return tempVal
}

//allison, 070419
//recheck IP range return value to indicate the failed factor
//Output: -1 - NETWORK_ERROR
//		    -2 - MASK_ERROR
//        -3 - NETWORK_MASK_ERROR
//			  -4 - BRCAST_ERROR
function DoValidateIpRangeCheck(Subnet, Mask, type)
{
  var Subadd = Subnet.match("^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$");
  var Maskadd = Mask.match("^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$");

	//do not do anything if required parameters are not specified
//	if ((Subnet == "") || (Mask =="")) return true;

   if(Subadd == null)
    return -1; //"NETWORK_ERROR"

   if(Maskadd == null)
    return -2;//"MASK_ERROR"


   for (i = 0; i < Subnet.length; i++) {
     c = Subnet.charAt(i);
     if((c>='0'&&c<='9')||(c=='.'))
       continue;
     else
       return -1; //"NETWORK_ERROR"
   }

   for (i = 0; i < Mask.length; i++) {
     c = Mask.charAt(i);
     if((c>='0'&&c<='9')||(c=='.'))
       continue;
     else
       return -2;//"MASK_ERROR"
   }


 var i;
  var error=false;
  var count = 0;

    var snm1a = 255;
    var snm2a = 255;
    var snm3a = 255;
    var snm4a = 255;

    var nw1a = 0;
    var nw2a = 0;
    var nw3a = 0;
    var nw4a = 0;

    var broad1a = 255;
    var broad2a = 255;
    var broad3a = 255;
    var broad4a = 255;

	  arrSubadd = Subadd[0].split(".");
  	arrMask = Maskadd[0].split(".");

    snm1a = arrMask[0];
    snm2a = arrMask[1];
    snm3a = arrMask[2];
    snm4a = arrMask[3];


    var ck1a = arrSubadd[0];
    var ck2a = arrSubadd[1];
    var ck3a = arrSubadd[2];
    var ck4a = arrSubadd[3];



  	nw1a = eval(snm1a & ck1a);
	nw2a = eval(snm2a & ck2a);
	nw3a = eval(snm3a & ck3a);
	nw4a = eval(snm4a & ck4a);

	broad1a = ((nw1a) ^ (~ snm1a) & 255);
	broad2a = ((nw2a) ^ (~ snm2a) & 255);
	broad3a = ((nw3a) ^ (~ snm3a) & 255);
	broad4a = ((nw4a) ^ (~ snm4a) & 255);

	if ((type == undefined) || (type == TYPE_IP_ADDRESS)){
		if ((broad1a == arrSubadd[0]) && (broad2a == arrSubadd[1]) && (broad3a == arrSubadd[2]) && (broad4a == arrSubadd[3]))
		{
//			errVal = "IP:" + Subnet + " Mask:" + Mask;
//			alertInvalid("",errVal,"Please check your subnet mask");
			return -2;//"MASK_ERROR"
		}

	}
	else if (type == TYPE_NETWORK_ADDRESS){
		var tempIP = nw1a + "." + nw2a + "." + nw3a + "." + nw4a;
		if (tempIP != Subnet){
//			errVal = Subnet + " Mask:" + Mask;
//			alertInvalid ("Network Address",errVal);
			return -3;//"NETWORK_MASK_ERROR"
		}
	}
	else if (type == TYPE_BRCAST_ADDRESS){
		var tempIP = broad1a + "." + broad2a + "." + broad3a + "." + broad4a;
		if (tempIP != Subnet)
			return -4;//"BRCAST_ERROR"
	}



  return true;
}

function valIsBroadcastIP(HostIp, Mask)
{
	var broadIP = getBroadcastIP(HostIp, Mask);
	var hostIPSplit = HostIp.split(".");
	var broadIPSlip = broadIP.split(".");

	var result = true;
	for (i = 0; i < 4; i++) {
		if (hostIPSplit[i] != broadIPSlip[i])
			result = false;
	}

	return result;

}

//Rick, 070507, check if End IP biger than Start IP
function isEndIpBigerStartIP(EndIp, StartIp)
{
   addrEnd = EndIp.split('.');
   addrStart = StartIp.split('.');

   valueS = eval(addrStart[0] * 16777216) + eval(addrStart[1] * 65536) + eval(addrStart[2] * 256) + eval(addrStart[3]);
   valueE = eval(addrEnd[0] * 16777216) + eval(addrEnd[1] * 65536) + eval(addrEnd[2] * 256) + eval(addrEnd[3]);

   if (valueE <= valueS)
      return false;
   return true;
}

var idxStr = '4';
function getMsgIndex() {
   var idxNum = parseInt(idxStr);
   if ( isNaN(idxNum) || idxNum < 0 || idxNum > 4 )
      idxNum = 4;

   return idxNum;
}

var count = 0;
var total = '100';
var interval;
var needReset = 1;

function reboot() {
   var loc = ' ';

   if ( getMsgIndex() != 2 )
   	{
     if(count < 20)
   	{
   	count ++;
	status="";
	if (document.getElementById)  // DOM3 = IE5, NS6
		document.getElementById('status').style.display = "inline";
	 else
	{
		if (document.layers == false) // IE4
			document.all.status.style.display = "inline";
	}
	if  (document.getElementById('uiStatus').innerHTML.length < 100)
		document.getElementById('uiStatus').innerHTML = document.getElementById('uiStatus').innerHTML + "|||||";
		document.getElementById('uiPercent').innerHTML = parseInt(((count / 20) * 100), 10) + '%';
	setTimeout('reboot()', interval);
   	  }
     else
		{
	var loc = '/wizard.asp';
	var code = 'location="' + loc + '"';
	eval(code);
		}
   	}
}

function frmLoad() {
var status;

   if (needReset== 1)
	{
	   	if (getMsgIndex() != 0  || 1 == 2)
	  		total=70;//rick, change to 70
	  	interval = total*50;
		reboot();
 }

   if (needReset == 0)
	status="visible";
   else
   	status="hidden";

    if (document.layers == false) // IE4
       document.all.back.style.visibility = status;
}

function frmUpload() {
var status;

   if (needReset== 1)
	{
	   	if (getMsgIndex() != 0  || 1 == 2)
	  		total=70;//rick, change to 70
	  	interval = total*100;
		reboot();
 }

   if (needReset == 0)
	status="visible";
   else
   	status="hidden";

    if (document.layers == false) // IE4
       document.all.back.style.visibility = status;
}


