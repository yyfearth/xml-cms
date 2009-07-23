<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="frame.xsl" />
	<xsl:template match="mgr">
		<xsl:variable name="mgr" select="document('../mgr.php?req=admin')" />
		<xsl:choose>
			<xsl:when test="not($mgr)">
				<h1 style="color:red;text-align: center">
					错误：无法获取管理信息！
				</h1>
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
												<h1>登 录</h1>
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
													<lable for="password">密 码：</lable>
												</td>
												<td>
													<input type="password" id="password" name="password" tabindex="2" style="width:90%" />
												</td>
											</tr>
											<tr>
												<td></td>
												<td style="padding:10px">
													<input type="submit" value="登录" />　
													<input type="reset" value="重填" />
												</td>
											</tr>
										</table>
									</div>
								</form>
								<script type="text/javascript" src="script/cipher.js"></script>
								<script type="text/javascript">
									var server_timestamp =
									<xsl:value-of select="$mgrts/timestamp" />;
									<![CDATA[
var timestamp = Date.parse(new Date())/1000;
server_timestamp = parseInt(server_timestamp);
if (!isNaN(server_timestamp) && Math.abs(timestamp - server_timestamp) > 30) {
	timestamp = server_timestamp;
	setInterval('timestamp++', 1000);
} else {
	timestamp = 0;
}

var theform = document.getElementById('login_form');
var username = document.getElementById('username');
var password = document.getElementById('password');
theform.onsubmit = function() {
	if (username.value.length < 3) {
		alert('请输入正确的用户名！')
		username.focus();
	} else if (password.value.length == 0) {
		alert('请输入密码！')
		password.focus();
	} else {
		username = username.value.toLowerCase();
		password = password.value;
		var ts = timestamp.toString();
		if (ts.length != 10)
			ts = (Date.parse(new Date()).toString()).substr(0, 10);
		var hash = lhex2b36(hmac_sha1(username + 'XmlCMS' + ts, sha1(password)) + ts);
		if (hash.length == 40)
			location.href = 'mgr.php?act=login&user=' + username + '&hash=' + hash;
		else
			alert('提交安全信息出错！');
	}
	return false;
}
username.focus();
								]]>
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
						<table name="postlist" style="margin:auto;border:1px solid white;">
							<caption>
								<h1>日志列表</h1>
							</caption>
							<thead>
								<tr>
									<th>
										<input id="chkall" type="checkbox" title="全选/清除" />
									</th>
									<th>标题</th>
									<th>分类</th>
									<th>作者</th>
									<th>发布时间</th>
									<th>标签</th>
									<th>操作</th>
								</tr>
							</thead>
							<tfoot>
								<tr>
									<td>↑</td>
									<td>
										<a href="javascript:del()">删除所选</a>
									</td>
									<td>
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
						<script type="text/javascript">
							<![CDATA[
var iptchkall = document.getElementById('chkall');
function chkall() {
	var val = iptchkall.checked;
	var ipt = document.getElementsByTagName('input');
	for (var i=0;i<ipt.length;i++) {
		var chk=ipt[i];
		if (chk.type == 'checkbox' && chk.id != 'chkall') {
			chk.checked = val;
			if (val)
				chk.onclick = function() { if(!this.checked) clrchkall(); };
			else
				chk.onclick = null;
		}
	}
}
iptchkall.onclick = chkall;
function clrchkall() {
	iptchkall.onclick = null;
	iptchkall.checked = false;
	iptchkall.onclick = chkall;
}
function del(id) {
	if (id == null) {
		var ipt = document.getElementsByTagName('input');
		var delids = [];
		for (var i = 0; i < ipt.length; i++) {
			var chk = ipt[i];
			if (chk.type == 'checkbox' && chk.id != 'chkall' && chk.checked) {
				delids.push(chk.id.match(/\d+/));
			}
		}
		if (delids.length) {
			if (confirm('确定删除所选的全部日志吗？'))
				location.href = "mgr.php?act=del&id=" + delids.join(',')
		} else alert ('没有选择任何日志！');
	} else {
		if (confirm('确定删除所选日志吗？'))
			location.href = "mgr.php?act=del&id=" + id;
	}
}
							]]>
						</script>
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
