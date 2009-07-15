<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="frame.xsl" />

	<xsl:template match="calendar">
		<xsl:if test="count(year)=0">
			<h2 align="center">没有日志</h2>
		</xsl:if>
		<xsl:for-each select="year">
			<xsl:sort select="@year" order="descending" data-type="number" />
			<xsl:apply-templates select="." />
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="/calendar/year">
		<div class="year">
			<a href="{@year}.xml">
				<xsl:value-of select="concat(@year,'年')" />
			</a>
			<xsl:for-each select="month">
				<xsl:sort select="@month" order="descending" data-type="number" />
				<xsl:apply-templates select="." />
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template match="month">
		<div class="month">
			<xsl:if test="not(/month) and count(day/post)>1">
				<a href="{../@year}{@month}.xml">
					<xsl:value-of select="concat(@month,'月')" />
				</a>
			</xsl:if>
			<xsl:for-each select="day">
				<xsl:sort select="@day" order="descending" data-type="number" />
				<xsl:apply-templates select="." />
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template match="day">
		<div class="day">
			<xsl:if test="not(/day) and count(post)>1">
				<a href="{../@year}{../../@year}{../@month}{@day}.xml">
					<xsl:value-of select="concat(@day,'日')" />
				</a>
			</xsl:if>
			<xsl:for-each select="post">
				<xsl:sort select="datetime/@time" order="descending" />
				<xsl:apply-templates select="." />
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template match="post">
		<div id="{@id}" class="post">
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
					<span class="categories">
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

</xsl:stylesheet>
