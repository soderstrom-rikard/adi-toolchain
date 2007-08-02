<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!--
reusable replace-string function
http://aspn.activestate.com/ASPN/Cookbook/XSLT/Recipe/65426
-->
<xsl:template name="replace-string">
	<xsl:param name="text"/>
	<xsl:param name="from"/>
	<xsl:param name="to"/>

	<xsl:choose>
		<xsl:when test="contains($text, $from)">
			<xsl:variable name="before" select="substring-before($text, $from)"/>
			<xsl:variable name="after" select="substring-after($text, $from)"/>
			<xsl:variable name="prefix" select="concat($before, $to)"/>

			<xsl:value-of select="$before"/>
			<xsl:value-of select="$to"/>
			<xsl:call-template name="replace-string">
				<xsl:with-param name="text" select="$after"/>
				<xsl:with-param name="from" select="$from"/>
				<xsl:with-param name="to" select="$to"/>
			</xsl:call-template>
		</xsl:when>

		<xsl:otherwise>
			<xsl:value-of select="$text"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>
</xsl:stylesheet>
