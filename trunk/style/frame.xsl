<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output encoding="utf-8" version="1.1" method="html"
		indent="yes" omit-xml-declaration="yes" doctype-public="-//W3C//DTD XHTML 1.1//EN"
		doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" />
	<xsl:template match="/">
		<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh-hans">
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
				<title>XmlCMS</title>
				<!-- style START -->
				<link rel="stylesheet" href="theme/style.css" type="text/css" media="screen" />
				<!--[if IE 6]> <link rel="stylesheet" href="theme/ie6.css" type="text/css" media="screen" /> <![endif]-->
				<!-- style END -->
				<link rel="index" title="XmlCMS" href="http://yyfearth.com/XmlCMS" />
				<link rel="shortcut icon" href="images/XmlCMS.ico" type="image/x-icon" />
				<link rel="icon" href="images/XmlCMS.gif" type="image/x-icon" />
			</head>
			<body>
				<!-- wrap START -->
				<div id="wrap">
					<!-- container START -->
					<div id="container">
						<!-- header START -->
						<div id="header">
							<div id="caption">
								<h1 id="title">
									<a href="http://yyfearth.com/XmlCMS">XmlCMS</a>
								</h1>
								<div id="tagline">基于XML+XSL的CMS</div>
							</div>
							<!-- navigation START -->
							<div id="navigation">
								<ul id="menus">
									<xsl:call-template name="nav" />
								</ul>
							</div>
							<!-- navigation END -->
						</div>
						<!-- header END -->
						<!-- content START -->
						<div id="content">
							<!-- main START -->
							<div id="main">
								<xsl:if test="/post">
									<p>
										<a href="javascript:history.back()">返回</a>
									</p>
								</xsl:if>
								<xsl:apply-templates />
								<xsl:if test="/post">
									<p>
										<a href="javascript:history.back()">返回</a>
									</p>
								</xsl:if>
							</div>
							<!-- main END -->
							<div id="sidebar" class="sidebar">
								<div class="content">
									<p align="center">侧边栏留用</p>
									<p align="center">
										<a href="mgr.xml">后台管理</a>
									</p>
								</div>
							</div>
							<div class="fixed"></div>
						</div>
						<!-- content END -->
						<!-- footer START -->
						<div id="footer">
							<a id="gotop" href="#top" onclick="document.body.scrollTop=document.documentElement.scrollTop=0;return false;">置顶</a>
							<div id="copyright">版权所有 ® 2009 yyfearth.com</div>
						</div>
						<!-- footer END -->
					</div>
					<!-- container END -->
				</div>
				<!-- wrap END -->
			</body>
		</html>
	</xsl:template>

	<xsl:template name="nav">
		<xsl:choose>
			<xsl:when test="/post">
				<li class="page_item">
					<a class="home" title="所有" href="calendar.xml">所有</a>
				</li>
				<xsl:variable name="dt" select="post/datetime" />
				<li class="page_item">
					<a title="{$dt/@year}年" href="{$dt/@year}.xml">
						<xsl:value-of select="concat($dt/@year,'年')" />
					</a>
				</li>
				<li class="page_item">
					<a title="{$dt/@year}{$dt/@month}月" href="{$dt/@year}{$dt/@month}.xml">
						<xsl:value-of select="concat($dt/@month,'月')" />
					</a>
				</li>
				<li class="page_item">
					<a title="{$dt/@year}{$dt/@month}{$dt/@day}日" href="{$dt/@year}{$dt/@month}{$dt/@day}.xml">
						<xsl:value-of select="concat($dt/@day,'日')" />
					</a>
				</li>
				<li class="current_page_item">
					<a href="#view" title="浏览" onclick="return false">
						<xsl:value-of select="concat($dt/@time,'日志')" />
					</a>
				</li>
			</xsl:when>
			<xsl:when test="/day">
				<li class="page_item">
					<a class="home" title="所有" href="calendar.xml">所有</a>
				</li>
				<li class="page_item">
					<a title="{day/@year}年" href="{day/@year}.xml">
						<xsl:value-of select="concat(day/@year,'年')" />
					</a>
				</li>
				<li class="page_item">
					<a title="{day/@year}{day/@month}月" href="{day/@year}{day/@month}.xml">
						<xsl:value-of select="concat(day/@month,'月')" />
					</a>
				</li>
				<li class="current_page_item">
					<a title="日">
						<xsl:value-of select="concat(day/@day,'日')" />
					</a>
				</li>
			</xsl:when>
			<xsl:when test="/month">
				<li class="page_item">
					<a class="home" title="所有" href="calendar.xml">所有</a>
				</li>
				<li class="page_item">
					<a title="年" href="{month/@year}.xml">
						<xsl:value-of select="concat(month/@year,'年')" />
					</a>
				</li>
				<li class="current_page_item">
					<a title="月">
						<xsl:value-of select="concat(month/@month,'月')" />
					</a>
				</li>
			</xsl:when>
			<xsl:when test="/year">
				<li class="page_item">
					<a class="home" title="所有" href="calendar.xml">所有</a>
				</li>
				<li class="current_page_item">
					<a title="年">
						<xsl:value-of select="concat(year/@year,'年')" />
					</a>
				</li>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="upd" select="document(concat('../lastupdate.xml?',generate-id()))/post" />
				<xsl:if test="$upd/@id">
					<li class="page_item">
						<xsl:if test="/calendar">
							<xsl:attribute name="class">current_page_item</xsl:attribute>
						</xsl:if>
						<a class="home" title="所有" href="calendar.xml">所有</a>
					</li>
					<li class="page_item">
						<a title="最近一年" href="{$upd/@year}.xml">最近一年</a>
					</li>
					<li class="page_item">
						<a title="最近一月" href="{$upd/@year}{$upd/@month}.xml">最近一月</a>
					</li>
					<li class="page_item">
						<a href="latestday.xml" title="最近一天">最近一天</a>
					</li>
					<li class="page_item">
						<a title="最新一篇日志" href="{$upd/@id}.xml">最新一篇日志</a>
					</li>
					<!--li><a class="lastmenu" href="javascript:void(0);"></a></li-->
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
