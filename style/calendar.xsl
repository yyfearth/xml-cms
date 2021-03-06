<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="frame.xsl" />

	<xsl:template match="calendar">
		<xsl:if test="count(year)=0">
			<h2 align="center">没有日志</h2>
		</xsl:if>
		<div id="calendar">
			<xsl:for-each select="year">
				<xsl:sort select="@year" order="descending" data-type="number" />
				<xsl:apply-templates select="." />
			</xsl:for-each>
		</div>
		<script type="text/javascript">
		<![CDATA[
if (/^\??\d{4}(#|$)/.test(location.search)) {
	var year = location.search.substr(1);
	document.title = year + ' - XmlCMS';
	document.getElementById('menus').innerHTML =
		'<li class="page_item"><a class="home" title="所有" href="calendar.xml">所有</a></li>' +
		'<li class="current_page_item"><a title="' + year + '年">' + year + '年</a></li>';
	var years = document.getElementsByName('year'), count = 0;
	if (!years.length) // IE
		years = document.getElementById('calendar').childNodes;
	for (var i = 0; i < years.length; i++) {
		if (years[i].getAttribute('name') != 'year')
			continue;
		else if (years[i].getAttribute('year') == year)
			count++;
		else
			years[i].style.display = 'none';
	}
	if (!count) document.writeln('没有发现您需要的日志！');
}
		]]>
		</script>
	</xsl:template>

	<xsl:template match="year">
		<div class="year" name="year" year="{@year}">
			<span style="float:right;color:#999999">
				<xsl:value-of select="concat('(共 ',count(descendant::post),' 篇)')" />
			</span>
			<a href="?{@year}">
				<xsl:value-of select="concat(@year,'年')" />
			</a>
			<xsl:variable name="showmonth" select="count(month[count(day/post)>1])>0"/>
			<xsl:for-each select="month">
				<xsl:sort select="@month" order="descending" data-type="number" />
				<div class="month">
					<xsl:if test="$showmonth">
						<span style="float:right;color:#999999">
							<xsl:value-of select="concat('(共 ',count(descendant::post),' 篇)')" />
						</span>
						<a href="{../@year}{@month}.xml">
							<xsl:value-of select="concat(@month,'月')" />
						</a>
					</xsl:if>
					<xsl:apply-templates select="." />
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template match="month">
		<xsl:variable name="showday" select="count(day[count(post)>1])>0"/>
		<xsl:for-each select="day">
			<xsl:sort select="@day" order="descending" data-type="number" />
			<div class="day">
				<xsl:if test="$showday">
					<span style="float:right;color:#999999">
						<xsl:value-of select="concat('(共 ',count(descendant::post),' 篇)')" />
					</span>
					<a href="{../../@year}{../@month}.xml?{@day}">
						<xsl:value-of select="concat(@day,'日')" />
					</a>
				</xsl:if>
				<xsl:apply-templates select="." />
			</div>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="day">
		<xsl:for-each select="post">
			<xsl:sort select="datetime/@time" order="descending" />
			<xsl:apply-templates select="." />
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="post">
		<div id="{@id}" class="post">
			<h2>
				<a title="{title}" href="{@id}.xml">
					<xsl:value-of select="title" />
				</a>
			</h2>
			<div class="content">
				<span class="date">
					<xsl:value-of select="concat(datetime/@year,'-',datetime/@month,'-',datetime/@day,' ',datetime/@time)" />
				</span>
				<span class="author">
					<xsl:value-of select="author" />
				</span>
				<span class="category">
					<a href="category.xml?{category}" title="{category}">
						<xsl:value-of select="category" />
					</a>
				</span>
				<xsl:if test="tag">
					<span class="tags">
						<xsl:for-each select="tag">
							<xsl:if test="position()!=1">, </xsl:if>
							<xsl:value-of select="." />
						</xsl:for-each>
					</span>
				</xsl:if>
			</div>
			<div class="fixed"></div>
		</div>
	</xsl:template>

</xsl:stylesheet>
