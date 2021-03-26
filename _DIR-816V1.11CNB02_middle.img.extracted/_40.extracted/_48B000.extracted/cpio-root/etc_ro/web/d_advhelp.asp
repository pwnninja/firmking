if (HelpItem=='Acl'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'此页面指定在WAN端开启哪种服务。<br><br>' +
					'<a href="d_helpadv.asp#Acl">更多帮助...</a>';
} else if (HelpItem=='PortTriggering'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'端口触发表用于限制本地网络发出的特定类型的数据包到达因特网。使用这样的过滤器能有效的保护及限制你的本地网络。<br><br>' +
					'<a href="d_helpadv.asp#PortTriggering">更多帮助...</a>';
} else if (HelpItem=='Dmz'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'DMZ用来向广域网提供服务并且避免了本地主机被广域网的未经授权的进入。典型的DMZ有一些 广域网可以访问的设备, 比如web服务器, FTP服务器, SMTP(电子邮件)服务器和DNS服务器。<br><br>' +
					'<a href="d_helpadv.asp#DMZ">更多帮助...</a>';
} else if (HelpItem=='Url'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'此页面用来配置站点限制功能。您可以增加或删除被限制的关键字。此功能启用并增加限制关键字后可以阻止局域网用户访问带关键字的网站。<br><br>' +
					'<a href="d_helpadv.asp#Url">更多帮助...</a>';
} else if (HelpItem=='Filtering'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'利用IP端口过滤功能，可按照本地网络中具体用户的IP地址，限制这些用户对因特网进行访问。此外，还可以彻底阻止对某些因特网服务的使用。<br><br>' +
					'<a href="d_helpadv.asp#IPFiltering">更多帮助...</a>';
} else if (HelpItem=='Ddns'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'本页面用来配置在DynDNS.org, TZO和Oray上的动态DNS地址。您可以通过添加/删除来配置动态DNS。<br><br>' +
					'<a href="d_helpadv.asp#DDNS">更多帮助...</a>';
} else if (HelpItem=='Netsniper'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'本页面用于配置网络尖兵,正确配置可以使多台电脑通过此路由器共享宽带。<br><br>' +
					'<a href="d_helpadv.asp#Netsniper">更多帮助...</a>';
} else if (HelpItem=='Igmp'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'IGMP代理使系统可以通过标准的IGMP接口传输本地主机的消息。<br><br>' +
					'<a href="d_helpadv.asp#IGMP">更多帮助...</a>';
} else if (HelpItem=='Qos_tc'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'此页面为Qos设置页面。<br><br>' +
					'<a href="d_helpadv.asp#IPQosTC">更多帮助...</a>';
} else if (HelpItem=='Upnp'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'本页面用来配置UPnP. 系统将在后台执行。<br><br>' +
					'<a href="d_helpadv.asp#UPnP">更多帮助...</a>';
} else if (HelpItem=='Telnet'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'本页面用来配置Telnet. 系统将在后台执行。<br><br>' +
					'<a href="d_helpadv.asp#Telnet">更多帮助...</a>';
}else if (HelpItem=='Routing'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'本页面用来配置路由信息。您可以添加/删除IP路由。<br><br>' +
					'<a href="d_helpadv.asp#Route">更多帮助...</a>';
} else if (HelpItem=='Virtual'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'本页面使您可以配置虚拟服务器, 这样其他人可以通过网关访问相应的服务。<br><br>' +
					'<a href="d_helpadv.asp#VirtualSrv">更多帮助...</a>';
} else if (HelpItem=='Alg'){
  document.getElementById('helpLabel').innerHTML = '<b>帮助信息...</b> <br><br> ' +
					'本页面使您可以设置勾选每个基本安全选项。<br><br>' +
					'<a href="d_helpadv.asp#Alg">更多帮助...</a>';
}
