<html>
<head>
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

<body>
	<table border="0" cellpadding="3" cellspacing="0"  width="100%">
		<tr>
			<td>
				<center>
					<h1>重要的更新</h1>
				</center>
			</td>
		</tr>

		<tr>
			<td>
				<p>为了避免和您的网络提供商IP地址发生冲突, 路由器的IP地址已经更新到
<% getCfgToHTML(1, "lan_ipaddr"); %>				。</p>
			</td>
		</tr>

		<tr>
			<td>
				<p>您下次设置本界面请键入<a href='http://
<% getCfgToHTML(1, "lan_ipaddr"); %>	'>
<% getCfgToHTML(1, "lan_ipaddr"); %>	</a>。</p>
			</td>
		</tr>

		<tr>
			<td>
				<p>你必须更新路由器设置中所有与IP地址相关服务的IP地址，例如端口映射等。</p>
			</td>
		</tr>
	</table>
</body>
</html>
