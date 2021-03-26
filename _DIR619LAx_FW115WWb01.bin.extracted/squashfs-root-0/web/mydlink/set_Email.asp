<html>
<head>
</head>
<body>
<form name="myform" action="/goform/form_emailsetting" method="post">
<table>
<tr><td><input type="text" name="settingsChanged" value="1"></td><td>settingsChanged</td></tr>
<tr><td><input type="text" name="config.log_to_syslog" value="true"></td><td>config.log_to_syslog "true" or "false" (Enable Logging To Syslog Server)</td></tr>
<tr><td><input type="text" name="config.log_syslog_addr" value="192.168.0.33"></td><td>config.log_syslog_addr Syslog Server IP Address</td></tr>
<tr><td><input type="text" name="log_opt_system" value="true"></td><td>log_opt_system "true" or "false" (Log Type:system)</td></tr>
<tr><td><input type="text" name="log_opt_dropPackets" value="true"></td><td>log_opt_dropPackets "true" or "false" (Log Type: Firewall & Security)</td></tr>
<tr><td><input type="text" name="log_opt_SysActivity" value="true"></td><td>log_opt_SysActivity "true" or "false" (Log Type: Router Status)</td></tr>
<tr><td><input type="text" name="config.smtp_email_addr" value="to@163.com"></td><td>config.smtp_email_addr Email Address</td></tr>
<tr><td><input type="text" name="config.smtp_email_subject" value="my email"></td><td>config.smtp_email_subject Email Subject</td></tr>
<tr><td><input type="text" name="config.smtp_email_from_email_addr" value="from@163.com"></td><td>config.smtp_email_from_email_addr Sender Email Address</td></tr>
<tr><td><input type="text" name="config.smtp_email_server_addr" value="smtp.163.com"></td><td>config.smtp_email_server_addr SMTP Server/IP Address</td></tr>
<tr><td><input type="text" name="config.smtp_email_acc_name" value="usrname"></td><td>config.smtp_email_acc_name User Name</td></tr>
<tr><td><input type="text" name="config.smtp_email_pass" value="pass"></td><td>config.smtp_email_pass Password</td></tr>
<tr><td><input type="text" name="config.smtp_email_enable_smtp_auth" value="true"></td><td>config.smtp_email_enable_smtp_auth "true" or "false"(enable Authentication eamil)</td></tr>
<tr><td><input type="text" name="config.smtp_email_action" value="false"></td><td>config.smtp_email_action "true" or "false"(Send eamil)</td></tr>
<tr><td><input type="text" name="config.smtp_email_port" value="888"></td><td>config.smtp_email_port Email send port</td></tr>
<tr><td><input type="text" name="config.smtp_email_secret" value="false"></td><td>config.smtp_email_secret "true" or "false"(Send eamil format)</td></tr>
<input type="submit" value="Submit" />
</table>
</form>
</body>
</html>
