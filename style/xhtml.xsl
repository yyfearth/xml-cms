<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="calendar.xsl" />

	<xsl:template match="xhtml">
		<xsl:copy-of select="/xhtml/node()" />
	</xsl:template>

	<xsl:template match="err|msg">
		<xsl:variable name="color">
			<xsl:choose>
				<xsl:when test="@color">
					<xsl:value-of select="@color" />
				</xsl:when>
				<xsl:when test="name(.)='err'">red</xsl:when>
				<xsl:when test="name(.)='msg'">blue</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<h1 style="color:{$color};text-align:center;margin-top:25px">
			<xsl:copy-of select="/err/node()|/msg/node()" />
		</h1>
		<xsl:if test="@href">
			<script type="text/javascript">
				<xsl:text>setTimeout("location.replace('</xsl:text>
				<xsl:value-of select="@href" />
				<xsl:text>')",2000)</xsl:text>
			</script>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
