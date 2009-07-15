<?xml version="1.0" encoding="utf-8"?>
<!-- atomic element -->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="post">
		<div class="post" id="{@id}">
			<h2>
				<xsl:choose>
					<xsl:when test="/post">
						<xsl:value-of select="title" />
					</xsl:when>
					<xsl:otherwise>
						<a title="{title}" href="{@id}.xml">
							<xsl:value-of select="title" />
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</h2>
			<div class="info">
				<span class="date">
					<xsl:value-of select="concat(datetime/@year,'-',datetime/@month,'-',datetime/@day,' ',datetime/@time)" />
				</span>
				<div class="fixed"></div>
			</div>
			<div class="content">
				<div class="summary">
					<xsl:copy-of select="summary/node()" />
				</div>
				<xsl:if test="not(/post) and summary">
					<p><a class="post-link" href="{@id}.xml">阅读全文...</a></p>
				</xsl:if>
				<xsl:if test="/post">
					<xsl:copy-of select="content/node()" />
				</xsl:if>
				<p class="under">
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
