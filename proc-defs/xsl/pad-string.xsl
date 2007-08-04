<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<!--
Whitespace pad functions
-->

<xsl:template name="pad-prepend">
<!-- recursive template to right justify and prepend-->
<!-- the value with whatever padChar is passed in   -->
	<xsl:param name="padChar"> </xsl:param>
	<xsl:param name="padVar"/>
	<xsl:param name="length"/>
	<xsl:choose>
		<xsl:when test="string-length($padVar) &lt; $length">
			<xsl:call-template name="pad-prepend">
				<xsl:with-param name="padChar" select="$padChar"/>
				<xsl:with-param name="padVar" select="concat($padChar,$padVar)"/>
				<xsl:with-param name="length" select="$length"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="substring($padVar,string-length($padVar) - $length + 1)"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="pad-append">
<!-- recursive template to left justify and append  -->
<!-- the value with whatever padChar is passed in   -->
	<xsl:param name="padChar"> </xsl:param>
	<xsl:param name="padVar"/>
	<xsl:param name="length"/>
	<xsl:choose>
		<xsl:when test="string-length($padVar) &lt; $length">
			<xsl:call-template name="pad-append">
				<xsl:with-param name="padChar" select="$padChar"/>
				<xsl:with-param name="padVar" select="concat($padVar,$padChar)"/>
				<xsl:with-param name="length" select="$length"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$padVar"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
