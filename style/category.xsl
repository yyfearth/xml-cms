<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="frame.xsl" />
	<xsl:variable name="cal" select="document('../calendar.xml')"/>

	<xsl:template match="cat">
		<div id="cats">
			<xsl:for-each select="$cal/descendant::post">
				<xsl:sort select="@id" order="descending" data-type="number" />
				<xsl:apply-templates select="." />
			</xsl:for-each>
		</div>
		<script type="text/javascript">
		<![CDATA[
if (location.search) {
	var cat = decodeURIComponent(location.search.substr(1));
	document.title = cat + ' - XmlCMS';
	document.getElementById('curcat').innerHTML = cat;
	var posts = document.getElementsByName('post'), count = 0;
	if (!posts.length) // IE
		posts = document.getElementById('cats').childNodes;
	for (var i = 0; i < posts.length; i++) {
		if (posts[i].getAttribute('name') != 'post')
			continue;
		else if (posts[i].getAttribute('cat') == cat)
			count++;
		else
			posts[i].style.display = 'none';
	}
	if (!count) document.writeln('没有发现您需要的日志！');
}
		]]>
		</script>
	</xsl:template>

	<xsl:template match="post">
		<div id="{@id}" cat="{category}" class="post" name="post">
			<h2>
				<a title="{title}" href="{@id}.xml">
					<xsl:value-of select="title" />
				</a>
			</h2>
			<div class="content">
				<p class="under">
					<span class="date">
						<xsl:value-of select="concat(datetime/@year,'-',datetime/@month,'-',datetime/@day,' ',datetime/@time)" />
					</span>
					<span class="author">
						<xsl:value-of select="author" />
					</span>
					<span class="category" style="font-weight:bold">
						<xsl:value-of select="category" />
					</span>
					<xsl:if test="tag">
						<span class="tags">
							<xsl:for-each select="tag">
								<xsl:if test="position()!=1">, </xsl:if>
								<xsl:value-of select="." />
							</xsl:for-each>
						</span>
					</xsl:if>
				</p>
				<div class="fixed"></div>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="nav">
		<li class="page_item">
			<a class="home" title="所有" href="calendar.xml">所有</a>
		</li>
		<li class="page_item">
			<a title="分类" href="#cat" onclick="return false">分类</a>
		</li>
		<li class="current_page_item">
			<a href="#view" title="当前分类" onclick="return false" id="curcat">当前分类</a>
		</li>
	</xsl:template>

</xsl:stylesheet>
