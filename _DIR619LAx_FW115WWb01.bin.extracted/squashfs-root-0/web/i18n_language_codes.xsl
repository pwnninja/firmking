<?xml version="1.0"?>
<!--
	This XSLT stylesheet transforms an XML document of the following form 
	into the <option>s of a <select> control
	<languages>
		<language name="XX">Language</language>
		...
	</languagesl>
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml">
	<xsl:output method="xml" indent="no"/>
	<xsl:template match="/">
		<select id="i18n_language_select" onchange="i18n_change_language(this.value)">
			<option value="EN">English</option>
			<xsl:apply-templates/>
		</select>
	</xsl:template>

	<xsl:template match="language">
		<option>
			<xsl:attribute name="value"><xsl:value-of select="@code"/></xsl:attribute>
			<xsl:choose>
				<xsl:when test="string-length(@name) &gt; 0"><xsl:value-of select="@name"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="@code"/></xsl:otherwise>
			</xsl:choose>
		</option>
	</xsl:template>

</xsl:stylesheet>
