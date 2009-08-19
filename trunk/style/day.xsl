<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="frame.xsl" />
	<xsl:import href="post.xsl" />
	<xsl:variable name="day" select="/day/@day" />
	<xsl:variable name="xml" select="concat('../',/day/@year,/day/@month,'.xml')" />

	<xsl:template match="/day">
		<xsl:for-each select="document($xml)//day[@day=$day]/post">
			<xsl:apply-templates select="." />
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
