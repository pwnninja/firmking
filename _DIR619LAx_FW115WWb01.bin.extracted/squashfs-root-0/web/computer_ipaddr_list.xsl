<?xml version="1.0"?>
<!--
This XSLT stylesheet transforms an XML report of LAN hosts received from a CGI procedure
into an HTML display as appropriate for a specific UI.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="html" indent="yes"/>
<xsl:variable name="newline">
<xsl:text>
</xsl:text>
</xsl:variable>
<xsl:template match="/">
<select id="computer_list_ip_address_pulldown" name="computer_list_ip_address_pulldown" style="width: 150px;">
<xsl:attribute name="modified">ignore</xsl:attribute>
<xsl:value-of select="$newline"/>
<option value="-1">Computer Name</option>
<xsl:for-each select="dhcp_clients/client">
<xsl:choose>
<xsl:when test="string-length(host_name) > 0">
<option value="{ip_address}"><xsl:value-of select="host_name"/> (<xsl:value-of select="ip_address"/>)</option>
<xsl:value-of select="$newline"/>
</xsl:when>
<xsl:otherwise>
<option value="{ip_address}"><xsl:value-of select="ip_address"/></option>
<xsl:value-of select="$newline"/>
</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
</select>
</xsl:template>
</xsl:stylesheet>

