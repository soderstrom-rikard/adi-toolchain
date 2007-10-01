<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE stylesheet [
<!ENTITY newline "
">
<!ENTITY tab "\t">
<!ENTITY num "#">
<!ENTITY nbsp " ">
<!ENTITY sep ";">
<!ENTITY file "generate-def-headers.xsl">
<!ENTITY cpp "BFIN_DEF">
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" indent="no" encoding="UTF-8"/>
<xsl:strip-space elements="*"/>

<xsl:include href="string.xsl"/>

<xsl:variable name="padlen">30</xsl:variable>

<xsl:template match="visualdsp-proc-xml|visualdsp-core-xml|visualdsp-extended-xml">
	<xsl:variable name="cppdefine">
		<xsl:call-template name="replace-string">
			<xsl:with-param name="text" select="concat('__&cpp;_',substring-before(@name,'.xml'),'__')" />
			<xsl:with-param name="from" select="'-'" />
			<xsl:with-param name="to"   select="'_'" />
		</xsl:call-template>
	</xsl:variable>

	<xsl:text>/* DO NOT EDIT THIS FILE&newline;</xsl:text>
	<xsl:text> * Automatically generated by &file;&newline;</xsl:text>
	<xsl:text> * DO NOT EDIT THIS FILE&newline;</xsl:text>
	<xsl:text> */&newline;</xsl:text>
	<xsl:text>&newline;</xsl:text>
	<xsl:value-of select="concat('#ifndef ',$cppdefine,'&newline;')"/>
	<xsl:value-of select="concat('#define ',$cppdefine,'&newline;')"/>
	<xsl:text>&newline;</xsl:text>
	<xsl:apply-templates select="*"/>
	<xsl:text>&newline;</xsl:text>
	<xsl:value-of select="concat('#endif /* ',$cppdefine,' */&newline;')"/>
</xsl:template>

<xsl:template match="register-core-file|register-extended-file|vdsp-anomaly-dictionary">
<!--
	<xsl:apply-templates select="document(@name)"/>
-->
	<xsl:value-of select="concat('#include &quot;',substring-before(@name,'.xml'),'_def.h&quot;&newline;&newline;')"/>
</xsl:template>

<xsl:template match="register">
	<xsl:if test="string-length(@bit-position) = 0">
	<xsl:if test="string-length(@read-address) != 0">

	<!-- #define <MMR> <address> -->
	<xsl:text>#define </xsl:text>
	<xsl:call-template name="pad-append">
		<xsl:with-param name="padChar" select="' '" />
		<xsl:with-param name="padVar"  select="@name" />
		<xsl:with-param name="length"  select="$padlen" />
	</xsl:call-template>
	<xsl:value-of select="concat(' ',@read-address)"/>

	<xsl:if test="string-length(@description) != 0">
	<xsl:text> /* </xsl:text>
	<xsl:value-of select="@description"/>
	<xsl:text> */</xsl:text>
	</xsl:if>

	<xsl:text>&newline;</xsl:text>

	</xsl:if>
	</xsl:if>

<xsl:if test="1 = 0">
	<xsl:if test="string-length(@bit-position) != 0">
	<xsl:if test="contains(@name,'.') = false">

	<xsl:variable name="regname">
		<xsl:if test="starts-with(@name,@parent) = false">
			<xsl:value-of select="concat(@parent,'_')"/>
		</xsl:if>
		<xsl:value-of select="@name"/>
	</xsl:variable>

	<!-- #define <MMR>_<BIT NAME>_P <BIT POSITION> -->
	<xsl:text>#define </xsl:text>
	<xsl:call-template name="pad-append">
		<xsl:with-param name="padChar" select="' '" />
		<xsl:with-param name="padVar"  select="concat($regname,'_P')" />
		<xsl:with-param name="length"  select="$padlen" />
	</xsl:call-template>
	<xsl:value-of select="concat(' ',@bit-position)"/>

	<xsl:if test="string-length(@description) != 0">
	<xsl:text> /* </xsl:text>
	<xsl:value-of select="@description"/>
	<xsl:text> */</xsl:text>
	</xsl:if>

	<xsl:text>&newline;</xsl:text>

	<!-- #define <MMR>_<BIT NAME> MASK(<BIT POSITION>) -->
	<xsl:text>#define </xsl:text>
	<xsl:call-template name="pad-append">
		<xsl:with-param name="padChar" select="' '" />
		<xsl:with-param name="padVar"  select="$regname" />
		<xsl:with-param name="length"  select="$padlen" />
	</xsl:call-template>
	<xsl:value-of select="concat(' MK_BMSK_(',$regname,'_P)')"/>
	<xsl:text>&newline;</xsl:text>

	</xsl:if>
	</xsl:if>
</xsl:if>
</xsl:template>

<xsl:template match="memory-segment">
	<!-- For now, only extract memory regions for Core A -->
	<xsl:if test="string-length(@core) = 0 or @core = 'P0'">

	<xsl:variable name="memdefine">
		<xsl:choose>
			<xsl:when test="@description = 'Scratchpad SRAM'">
				<xsl:text>L1_SRAM_SCRATCH</xsl:text>
			</xsl:when>
			<xsl:when test="@description = 'MMR registers'">
				<xsl:text>SYSMMR_BASE</xsl:text>
			</xsl:when>
			<xsl:when test="@description = 'Instruction Bank A SRAM'">
				<xsl:text>L1_ISRAM</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>NOFUN</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:if test="$memdefine != 'NOFUN'">
	<xsl:value-of select="concat('#define ',$memdefine,' ',@start,' /* ',@start,' -> ',@end,' ',@description,' */&newline;')"/>
	<xsl:value-of select="concat('#define ',$memdefine,'_SIZE (',@end,' - ',@start,' + 1)&newline;')"/>
	</xsl:if>

	</xsl:if>
</xsl:template>

</xsl:stylesheet>
