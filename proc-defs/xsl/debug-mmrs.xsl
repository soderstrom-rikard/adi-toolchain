<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE stylesheet [
<!ENTITY newline "
">
<!ENTITY tab "  ">
<!ENTITY num "#">
<!ENTITY nbsp "#">
<!ENTITY sep ";">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" indent="no" encoding="UTF-8"/>
<xsl:strip-space elements="*"/>

<xsl:include href="replace-string.xsl" />

<xsl:template match="register-core-file|register-extended-file|vdsp-anomaly-dictionary">
	<xsl:apply-templates select="document(@name)"/>
</xsl:template>

<xsl:template match="register-extended-definitions/register|register-core-definitions/register">
	<xsl:if test="string-length(@bit-position) = 0">
	<xsl:if test="@type != 'CORE'">

	<xsl:call-template name="replace-string">
		<xsl:with-param name="text" select="@group" />
		<xsl:with-param name="from" select="'/'" />
		<xsl:with-param name="to"   select="'-'" />
	</xsl:call-template>

	<xsl:text>&sep;</xsl:text>
	<xsl:value-of select="@name"/>
	<xsl:text>&sep;</xsl:text>
	<xsl:value-of select="@read-address"/>
	<xsl:text>&sep;</xsl:text>
	<xsl:value-of select="@write-address"/>
	<xsl:text>&sep;</xsl:text>
	<xsl:value-of select="@bit-size"/>
	<xsl:text>&newline;</xsl:text>

	</xsl:if>
	</xsl:if>
</xsl:template>

<!--
<xsl:template match="window/register">
	<xsl:value-of select="ancestor::window/@name"/>
	<xsl:text>&sep;</xsl:text>
	<xsl:value-of select="@name"/>
	<xsl:text>&sep;</xsl:text>
	<xsl:value-of select="@read-address"/>
	<xsl:text>&sep;</xsl:text>
	<xsl:value-of select="@write-address"/>
	<xsl:text>&newline;</xsl:text>
</xsl:template>
-->

<!--
<xsl:template match="register">
	<xsl:value-of select="@name"/>
	<xsl:text>&sep;MOO</xsl:text>
</xsl:template>
-->

</xsl:stylesheet>
