<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:variable name="cal" select="document('../calendar.xml')"/>
	<xsl:template match="/">
		<div id="sidebar" class="sidebar">
			<!--div class="widget">
				<div class="title">迷你日历</div>
				
				<div class="fixed"></div>
			</div-->
			<div class="widget">
				<div class="title">广告赞助</div>

				<div class="fixed"></div>
			</div>
			<div class="widget">
				<div class="title">最近更新</div>
				<ul>
					<xsl:for-each select="$cal/descendant::post[position()&lt;6]">
						<li>
							<a href="{@id}.xml" title="『{title}』于{datetime/@year}-{datetime/@month}-{datetime/@day} {datetime/@time}发表">
								<xsl:value-of select="title"/>
							</a>
						</li>
					</xsl:for-each>
				</ul>
				<div class="fixed"></div>
			</div>
			<div class="widget">
				<div class="title">日志分类</div>
				<xsl:variable name="cats">
					<xsl:for-each select="$cal/descendant::post/category">
						<xsl:sort select="text()" order="descending" />
						<xsl:text>'</xsl:text>
						<xsl:value-of select="."/>
						<xsl:text>',</xsl:text>
					</xsl:for-each>
					<xsl:text>null</xsl:text>
				</xsl:variable>
				<script type="text/javascript">
					var cats = [
					<xsl:value-of select="$cats"/>];
					<![CDATA[
document.writeln('<ul>');
for (var i = 0; i < cats.length - 1; i++)
	if (cats[i] != cats[i+1])
		document.writeln('<li><a href="category.xml?' + cats[i] + '">'+ cats[i] + '</a></li>');
document.writeln('</ul>');
					]]>
				</script>
				<div class="fixed"></div>
			</div>
			<div class="widget">
				<div class="title" style="text-align:center">
					<a href="mgr.xml">后台管理</a>
				</div>
				<div class="fixed"></div>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
