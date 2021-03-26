if (HelpItem=='wizard'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br>' +
					'配置工作可采用“智能设置向导”来完成, '+
					'该向导将指导您通过一些简单的配置步骤使网络正常工作.<br><br>' +
					'<a href="d_helpsetup.asp#Wizard">更多帮助...</a>';

}else if (HelpItem=='lancfg'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br>' +
					'路由器的IP 地址与您登录web服务器的地址相同.<br><br>' +
					'<a href="d_helpsetup.asp#LAN">更多帮助...</a>';

}else if (HelpItem=='dhcpcfg'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br>' +
					'如果您已经在局域网中配置了其他的DHCP 服务器' +
					'或者您的计算机或设备使用手动获得IP地址的方式, 请禁用DHCP 服务器.<br><br>' +
					'<a href="d_helpsetup.asp#Dhcpd">更多帮助...</a>';

}else if (HelpItem=='dhcpipcfg'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br>' +
					'如果您的设备需要使用固定的IP地址,' +
					'请为这些设备增加静态DHCP IP地址绑定.<br><br>' +
					'<a href="d_helpsetup.asp#DhcpReserve">更多帮助...</a>';

}else if (HelpItem=='wanif'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br>' +
					'当您配置路由器为PPPoE方式时, 请确认选择了正确的 ' +
					'<b><font color="rgb(108,169,213)">广域网接入方式</font></b>.<br><br>' +
					'当您填写以下信息时: ' +
					'<b><font color="rgb(108,169,213)">用户名</font></b> 和 ' +
					'<b><font color="rgb(108,169,213)">密码</font></b> ,' +
					'请注意大小写. 主要的连接问题是由错误的' +
					'<b><font color="rgb(108,169,213)">用户名</font></b> 或 ' +
					'<b><font color="rgb(108,169,213)">密码</font></b> ' +
					'引起的.<br><br>' +
					'<a href="d_helpsetup.asp#Internet">更多帮助...</a>';

}else if (HelpItem=='wancfghelp2'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br>' +
					'IGMP (互联网组消息管理协议) 用于' +
					'管理多播组成员. 为了支持二层多媒体应用' +
					'(比如多媒体服务器,机顶盒,网络游戏等),' +
					'请使能"IGMP 代理(组播)" 功能.<BR><BR> '+
					'<a href="d_helpsetup.asp#Time">更多帮助...</a>';

}else if (HelpItem=='IPV6Set'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br>' +
  					'<p>当您配置路由器连接IPv6网络时，一定要从下拉菜单中选择正确的IPv6接入方式。如果您对选项不确定，请联系您的互联网服务提供商(ISP)；</p>' +
					'<p>如果您通过路由器访问IPv6网络出现故障，重新检查一下您在本页面的配置。如果需要，向您的ISP验证。</p><br><br>' +
					'<a href="d_helpsetup.asp#IPV6Set">更多帮助...</a>';

}





