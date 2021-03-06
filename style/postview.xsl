<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="frame.xsl" />
	<xsl:import href="post.xsl" />

	<xsl:template name="nav">
		<li class="page_item">
			<a class="home" title="所有" href="calendar.xml">所有</a>
		</li>
		<xsl:variable name="dt" select="post/datetime" />
		<li class="page_item">
			<a title="{$dt/@year}年" href="calendar.xml?{$dt/@year}">
				<xsl:value-of select="concat($dt/@year,'年')" />
			</a>
		</li>
		<li class="page_item">
			<a title="{$dt/@month}月" href="{$dt/@year}{$dt/@month}.xml">
				<xsl:value-of select="concat($dt/@month,'月')" />
			</a>
		</li>
		<li class="page_item">
			<a title="{$dt/@day}日" href="{$dt/@year}{$dt/@month}.xml?{$dt/@day}">
				<xsl:value-of select="concat($dt/@day,'日')" />
			</a>
		</li>
		<li class="current_page_item">
			<a href="#view" title="浏览" onclick="return false">
				<xsl:value-of select="concat($dt/@time,'日志')" />
			</a>
		</li>
	</xsl:template>

</xsl:stylesheet>
