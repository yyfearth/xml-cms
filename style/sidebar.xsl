<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:variable name="cal" select="document('../calendar.xml')"/>
	<xsl:template match="/">
		<div id="sidebar" class="sidebar">
			<div class="widget">
				<div class="title">迷你日历</div>
				
				<div class="fixed"></div>
			</div>
			<div class="widget">
				<div class="title">广告赞助</div>

				<div class="fixed"></div>
			</div>
			<div class="widget">
				<div class="title">最近更新</div>
				<ul>
					<xsl:for-each select="$cal/descendant::post[position()&lt;6]">
						<li><a href="{@id}.xml" title="{title}"><xsl:value-of select="title"/></a></li>
					</xsl:for-each>
				</ul>
				<div class="fixed"></div>
			</div>
			<div class="widget">
				<div class="title">
					<a href="mgr.xml">后台管理</a>
				</div>
				<div class="fixed"></div>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
