<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="frame.xsl" />
	<xsl:import href="post.xsl" />
	<xsl:variable name="upd" select="document(concat('../lastupdate.xml?',generate-id()))/post" />

	<xsl:template match="/day">
		<xsl:choose>
			<xsl:when test="$upd/@id">
				<xsl:variable name="day" select="$upd/@day" />
				<xsl:variable name="id" select="$upd/@id" />
				<xsl:variable name="xml" select="concat('../',$upd/@year,$upd/@month,'.xml')" />
				<xsl:variable name="latestxml" select="concat('../',$id,'.xml')" />
				<xsl:for-each select="document($xml)//day[@day=$day]/post">
					<xsl:choose>
						<xsl:when test="position()=1">
							<a href="{$id}.xml">最近更新</a>
							<xsl:apply-templates select="document($latestxml)/post" />
							<p>
								<a class="post-link" href="{$id}.xml">完整信息...</a>
							</p>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="." />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<h1 style="text-align:center;margin-top:25px">没有创建日志！</h1>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="nav">
		<xsl:if test="$upd/@id">
			<li class="page_item">
				<a class="home" title="所有" href="calendar.xml">所有</a>
			</li>
			<li class="page_item">
				<a title="年" href="{$upd/@year}.xml">
					<xsl:value-of select="concat($upd/@year,'年')" />
				</a>
			</li>
			<li class="page_item">
				<a title="月" href="{$upd/@year}{$upd/@month}.xml">
					<xsl:value-of select="concat($upd/@month,'月')" />
				</a>
			</li>
			<li class="page_item">
				<a title="日" href="{$upd/@year}{$upd/@month}{$upd/@day}.xml">
					<xsl:value-of select="concat($upd/@day,'日')" />
				</a>
			</li>
			<li class="current_page_item">
				<a href="#view" title="最近一天" onclick="return false">
					<xsl:value-of select="concat($upd/@time,'最近一天')" />
				</a>
			</li>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
