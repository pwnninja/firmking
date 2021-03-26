if (HelpItem=='firmwareupdate'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'<b>注意！</b>点击上传之后切勿打断软件'+
					'到路由器的发送以及路由器的重启过程。<br><br>' +
					'<a href="d_helpmain.asp#Upload">更多帮助...</a>';

} else if (HelpItem=='backuprestore'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
 					' 路由器正常工作之后应对其信息进行备份以便发生'+
 					'故障时使用。所备份的设置信息将作为一个文件保存'+
 					'在计算机上。用户可从该文件中对路由器设置进行恢复。<br><br>' +
					'<a href="d_helpmain.asp#Saveconf">更多帮助...</a>';

} else if (HelpItem=='reboot'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
 					'此页面可用来重启路由器。<br><br>' +
					'<a href="d_helpmain.asp#Reboot">更多帮助...</a>';

} else if (HelpItem=='password'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'<b>注意！</b>这里的密码不是您的ISP帐户密码，'+
					'而是登录路由器设置界面的管理密码。密码一定'+
					'要写下来并保存在安全的地方。如果不慎遗失'+
					'密码，只能将设备复位，并重新进行设置。<br><br>' +
					'<a href="d_helpmain.asp#Userconfig">更多帮助...</a>';

}else if (HelpItem=='datetime'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br>' +
					'保持路由器时钟同步很重要,'+
					'可以精确日志时间.<br><br>' +
					'<a href="d_helpmain.asp#Time">更多帮助...</a>';

}
