<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="frame.xsl" />
	<xsl:template match="mgr">
		<xsl:variable name="mgr" select="document('../mgr.php?req=admin')" />
		<xsl:choose>
			<xsl:when test="not($mgr)">
				<h1 style="color:red;text-align: center">错误：无法获取管理信息！</h1>
			</xsl:when>
			<xsl:when test="$mgr/err">
				<xsl:variable name="err" select="$mgr/err" />
				<xsl:choose>
					<xsl:when test="$err='not_login'">
						<p>
							<br />
							<br />
							<br />
						</p>
						<xsl:variable name="mgrts" select="document('../mgr.php?req=timestamp')" />
						<xsl:choose>
							<xsl:when test="$mgrts/err">
								<h1 style="color:red;text-align: center">
									错误：
									<xsl:value-of select="$mgr/err" />
								</h1>
							</xsl:when>
							<xsl:otherwise>
								<form id="login_form">
									<div  align="center">
										<table style="margin:10px">
											<caption>
												<h1>登　录</h1>
											</caption>
											<tr>
												<td>
													<lable for="username">用户名：</lable>
												</td>
												<td>
													<input type="text" id="username" name="username" tabindex="1" style="width:90%" />
												</td>
											</tr>
											<tr>
												<td>
													<lable for="password">密　码：</lable>
												</td>
												<td>
													<input type="password" id="password" name="password" tabindex="2" style="width:90%" />
												</td>
											</tr>
											<tr>
												<td><!--
													<input id="autologin" name="autologin" type="checkbox" style="vertical-align:middle" />
													<label for="autologin" style="padding:2px;vertical-align:middle">自动</label>-->
												</td>
												<td style="padding:10px">
													<input type="submit" value=" 登 录 " />　
													<input type="reset" value=" 重 填 " />
												</td>
											</tr>
										</table>
									</div>
								</form>
								<script type="text/javascript" src="script/mgr.js"></script>
								<script type="text/javascript">
									<xsl:value-of select="concat('mgr_login(',$mgrts/timestamp,');')" />
								</script>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<h1 style="color:red;text-align: center">
							错误：
							<xsl:value-of select="$mgr/err" />
						</h1>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="//newpost">
				<div id="mask" style="background-color:gray;filter:alpha(opacity=50);opacity:0.5;display:none;position:absolute;left:0px;top:0px;width:100%;height:100%;z-index:1000"></div>
				<form id="postform" action="mgr.php?act=add" method="post">
					<table style="margin: auto; width: 90%">
						<caption>
							<h1>新建日志</h1>
						</caption>
						<tr style="font-weight:bolder;">
							<td>标题：</td>
							<td>
								<input style="font-weight:bold;" id="title_field" name="title" maxlength="30" />
							</td>
						</tr>
						<tr>
							<td>时间：</td>
							<td>
								<input class="date" id="datetime_field" name="datetime" maxlength="20" value="当前日期时间"/>
							</td>
						</tr>
						<tr>
							<td>作者：</td>
							<td>
								<input class="author" id="author_field" name="author" maxlength="20"/>
							</td>
						</tr>
						<tr>
							<td>分类：</td>
							<td>
								<input class="category" id="category_field" maxlength="10" name="category" value="默认分类" />
							</td>
						</tr>
						<tr>
							<td>标签：</td>
							<td>
								<input class="tags" id="tags_field" name="tags" maxlength="100" />
							</td>
						</tr>
						<tr>
							<td colspan="2">概要：</td>
						</tr>
						<tr>
							<td colspan="2">
								<textarea class="summary" id="summary_field" name="summary" rows="5" style="width:90%"></textarea>
							</td>
						</tr>
						<tr>
							<td colspan="2">内容：</td>
						</tr>
						<tr>
							<td colspan="2">
								<textarea id="content_field" name="content" rows="10" style="width:90%"></textarea>
							</td>
						</tr>
						<tr>
							<td>
								<input type="submit" value=" 提交 "/>
							</td>
							<td>
								<input type="reset" value=" 清除 "/>
							</td>
						</tr>
					</table>
				</form>
				<script type="text/javascript" src="script/newpost.js"></script>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="admin" select="$mgr/admin" />
				<xsl:variable name="cal" select="document(concat('../calendar.xml?',generate-id()))" />
				<div>
					管理员：
					<xsl:value-of select="$admin" />
					<xsl:text> </xsl:text>
					<a href="mgr.php?act=logout">注销</a>
				</div>
				<xsl:choose>
					<xsl:when test="count($cal/descendant::post)>0">
						<script type="text/javascript" src="script/mgr.js"></script>
						<table name="postlist" style="margin:auto;border:1px solid white;">
							<caption>
								<h1>日志列表</h1>
							</caption>
							<thead>
								<tr>
									<th>
										<input id="chkall" type="checkbox" title="全选/清除" onclick="chkall()" />
									</th>
									<th style="min-width:60px">标题</th>
									<th style="min-width:60px">分类</th>
									<th>作者</th>
									<th>发布时间</th>
									<th>标签</th>
									<th style="width:60px">操作</th>
								</tr>
							</thead>
							<tfoot>
								<tr>
									<td>↑</td>
									<td>
										<a href="javascript:del()">删除所选</a>
									</td>
									<td colspan="2">
										<a href="newpost.xml">新建日志</a>
									</td>
								</tr>
							</tfoot>
							<tbody>
								<xsl:for-each select="$cal/descendant::post">
									<xsl:sort select="@id" order="descending" data-type="number" />
									<tr>
										<td>
											<input type="checkbox" id="chk_{@id}" />
										</td>
										<td>
											<a title="{title}" href="{@id}.xml">
												<xsl:value-of select="title" />
											</a>
										</td>
										<td>
											<xsl:value-of select="category" />
										</td>
										<td>
											<xsl:value-of select="author" />
										</td>
										<td>
											<xsl:value-of select="concat(datetime/@year,'-',datetime/@month,'-',datetime/@day,' ',datetime/@time)" />
										</td>
										<td>
											<xsl:for-each select="tag">
												<xsl:if test="position()!=1">, </xsl:if>
												<xsl:value-of select="." />
											</xsl:for-each>
										</td>
										<td>
											<a href="javascript:del('{@id}')">删除</a>
											<xsl:text> </xsl:text>
											<a href="mgr.php?act=edt&amp;id={@id}">编辑</a>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</xsl:when>
					<xsl:otherwise>
						<div align="center">
							<p>没有日志！</p>
							<a href="newpost.xml">新建日志</a>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
