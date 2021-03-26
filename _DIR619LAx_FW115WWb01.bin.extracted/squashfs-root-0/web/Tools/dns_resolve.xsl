<?xml version="1.0"?>
<!--
This XSLT stylesheet transforms an XML report host ping received from a CGI procedure
into an HTML display as appropriate for a specific UI.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
<xsl:output method="text" indent="no" /> 
<xsl:template match="/">
<xsl:apply-templates/>
</xsl:template>
<xsl:template match="dns_resolve">
<xsl:for-each select="*">
<xsl:if test=". != '0.0.0.0'">
<xsl:if test="position()=last()">
<xsl:value-of select="."/>
</xsl:if>
</xsl:if>
</xsl:for-each>
</xsl:template>
<xsl:template match="text()" priority="-1" />
</xsl:stylesheet>