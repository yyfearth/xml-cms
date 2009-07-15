<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="calendar.xsl" />
	
	<xsl:variable name="all" select="document('../calendar.xml')"/>
	<xsl:variable name="year" select="/year/@year"/>

	<xsl:template match="/year">
		<xsl:for-each select="$all//year[@year=$year]/month">
			<xsl:apply-templates select="." />
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>
