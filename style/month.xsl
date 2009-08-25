<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="frame.xsl" />
	<xsl:import href="post.xsl" />

	<xsl:template match="/month">
		<xsl:variable name="showday" select="count(day[count(post)>1])>0"/>
		<xsl:for-each select="day">
			<xsl:sort select="@day" order="descending" data-type="number" />
			<div class="day" name="daydiv" day="{@day}">
				<xsl:if test="$showday">
					<a href="?{@day}">
						<xsl:value-of select="concat(@day,'日')" />
					</a>
					<span style="float:right;color:#999999">
						<xsl:value-of select="concat('(共 ',count(descendant::post),' 篇)')" />
					</span>
				</xsl:if>
				<xsl:apply-templates select="." />
			</div>
		</xsl:for-each>
		<script type="text/javascript">
			<![CDATA[
if (/^\??\d{2}(#|$)/.test(location.search)) {
	var day = location.search.substr(1);
	document.title = day + ' - XmlCMS';
	var html = document.getElementById('menus').innerHTML;
	document.getElementById('menus').innerHTML = html.replace('current_page_item', 'page_item') +
		'<li class="current_page_item"><a title="' + day + '日">' + day + '日</a></li>';
	var days = document.getElementsByName('daydiv'), count = 0;
	for (var i = 0; i < days.length; i++) {
		if (days[i].getAttribute('day') == day)
			count++;
		else
			days[i].style.display = 'none';
	}
	if (!count) document.writeln('没有发现您需要的日志！');
}
			]]>
		</script>
	</xsl:template>

	<xsl:template match="day">
		<xsl:for-each select="post">
			<xsl:sort select="datetime/@time" order="descending" />
			<xsl:apply-templates select="." />
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="nav">
		<li class="page_item">
			<a class="home" title="所有" href="calendar.xml">所有</a>
		</li>
		<li class="page_item">
			<a title="{month/@year}年" href="calendar.xml?{month/@year}">
				<xsl:value-of select="concat(month/@year,'年')" />
			</a>
		</li>
		<li class="current_page_item">
			<a title="{month/@month}月" href="{month/@year}{month/@month}.xml">
				<xsl:value-of select="concat(month/@month,'月')" />
			</a>
		</li>
	</xsl:template>

</xsl:stylesheet>
