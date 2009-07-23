<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="frame.xsl" />
	<xsl:variable name="postxml" select="document(concat('../',//@id,'.xml?',generate-id()))" />
	<xsl:template match="post">
		<xsl:choose>
			<xsl:when test="$postxml">
				<xsl:variable name="post" select="$postxml/post" />
				<div class="post">
					<p>
						<h1 align="center">修改编辑模式</h1>
					</p>
					<form id="editform" action="mgr.php?act=mod&amp;id={$post/@id}" method="post">
						<h2>
							<div id="title_area" name="title" title="编辑标题">
								<xsl:value-of select="$post/title" />
							</div>
							<input style="font-weight:bolder;font-size:100%" id="title_field" name="title" maxlength="30" />
						</h2>
						<div class="info">
							<span id="date_area" class="date" title="编辑日期时间">
								<xsl:value-of select="concat($post/datetime/@year,'-',$post/datetime/@month,'-',$post/datetime/@day,' ',$post/datetime/@time)" />
							</span>
							<input class="date" id="date_field" name="datetime" maxlength="20" />
							<div class="fixed"></div>
							<span id="author_area" class="author" title="编辑作者">
								<xsl:value-of select="$post/author" />
							</span>
							<input class="author" id="author_field" name="author" maxlength="20" />
							<div class="fixed"></div>
							<span id="category_area" class="category" title="编辑分类">
								<xsl:value-of select="$post/category" />
							</span>
							<input class="category" id="category_field" maxlength="10" name="category" />
							<div class="fixed"></div>
							<xsl:variable name="tags">
								<xsl:for-each select="$post/tag">
									<xsl:if test="position()!=1">, </xsl:if>
									<xsl:value-of select="." />
								</xsl:for-each>
							</xsl:variable>
							<span id="tags_area" class="tags" style="min-width:30px" title="编辑标签">
								<xsl:value-of select="$tags" />
							</span>
							<input class="tags" id="tags_field" name="tags" maxlength="100" />
							<div class="fixed"></div>
						</div>
						<div class="content">
							<div id="summary_area" class="summary" title="编辑概要">
								<xsl:copy-of select="$post/summary/node()" />
							</div>
							<textarea class="summary" id="summary_field" name="summary" style="width:90%;"></textarea>
							<div id="content_area" title="编辑内容">
								<xsl:copy-of select="$post/content/node()" />
							</div>
							<textarea id="content_field" name="content" style="width:90%;"></textarea>
							<div class="fixed"></div>
						</div>
						<div>
							<input id="submit" type="submit" value=" 提交修改 " />
							<input type="button" value=" 放弃修改 " onclick="history.back()" />
						</div>
					</form>
				</div>
				<script type="text/javascript" src="script/postedit.js"></script>
			</xsl:when>
			<xsl:otherwise>
				<h1 style="color:red;text-align:center;margin-top:25px">无法载入原日志信息！</h1>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="nav">
		<li class="page_item">
			<a class="home" title="所有" href="calendar.xml">所有</a>
		</li>
		<li class="current_page_item">
			<a href="#edit" title="编辑日志" onclick="return false">编辑日志</a>
		</li>
	</xsl:template>
</xsl:stylesheet>
