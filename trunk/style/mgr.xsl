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

function core_sha1(x, len) {
	/* append padding */
	x[len >> 5] |= 0x80 << (24 - len % 32);
	x[((len + 64 >> 9) << 4) + 15] = len;

	var w = Array(80);
	var a = 1732584193;
	var b = -271733879;
	var c = -1732584194;
	var d = 271733878;
	var e = -1009589776;

	for (var i = 0; i < x.length; i += 16) {
		var olda = a;
		var oldb = b;
		var oldc = c;
		var oldd = d;
		var olde = e;

		for (var j = 0; j < 80; j++) {
			if (j < 16) w[j] = x[i + j];
			else w[j] = rol(w[j - 3] ^ w[j - 8] ^ w[j - 14] ^ w[j - 16], 1);
			var t = safe_add(safe_add(rol(a, 5), sha1_ft(j, b, c, d)),
                       safe_add(safe_add(e, w[j]), sha1_kt(j)));
			e = d;
			d = c;
			c = rol(b, 30);
			b = a;
			a = t;
		}

		a = safe_add(a, olda);
		b = safe_add(b, oldb);
		c = safe_add(c, oldc);
		d = safe_add(d, oldd);
		e = safe_add(e, olde);
	}
	return Array(a, b, c, d, e);

}

function sha1_ft(t, b, c, d) {
	if (t < 20) return (b & c) | ((~b) & d);
	if (t < 40) return b ^ c ^ d;
	if (t < 60) return (b & c) | (b & d) | (c & d);
	return b ^ c ^ d;
}

function sha1_kt(t) {
	return (t < 20) ? 1518500249 : (t < 40) ? 1859775393 :
         (t < 60) ? -1894007588 : -899497514;
}

function core_hmac_sha1(key, data) {
	var bkey = str2binb(key);
	if (bkey.length > 16) bkey = core_sha1(bkey, key.length * 8);

	var ipad = Array(16), opad = Array(16);
	for (var i = 0; i < 16; i++) {
		ipad[i] = bkey[i] ^ 0x36363636;
		opad[i] = bkey[i] ^ 0x5C5C5C5C;
	}

	var hash = core_sha1(ipad.concat(str2binb(data)), 512 + data.length * 8);
	return core_sha1(opad.concat(hash), 512 + 160);
}

function safe_add(x, y) {
	var lsw = (x & 0xFFFF) + (y & 0xFFFF);
	var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
	return (msw << 16) | (lsw & 0xFFFF);
}

function rol(num, cnt) {
	return (num << cnt) | (num >>> (32 - cnt));
}

function str2binb(str) {
	var bin = Array();
	var mask = (1 << 8) - 1;
	for (var i = 0; i < str.length * 8; i += 8)
		bin[i >> 5] |= (str.charCodeAt(i / 8) & mask) << (32 - 8 - i % 32);
	return bin;
}

function binb2hex(binarray) {
	var hex_tab = 0 ? "0123456789ABCDEF" : "0123456789abcdef";
	var str = "";
	for (var i = 0; i < binarray.length * 4; i++) {
		str += hex_tab.charAt((binarray[i >> 2] >> ((3 - i % 4) * 8 + 4)) & 0xF) +
           hex_tab.charAt((binarray[i >> 2] >> ((3 - i % 4) * 8)) & 0xF);
	}
	return str;
}

function lhex2b36(hex) {
	var b36 = '';
	for (var i = 0; i < hex.length; i += 10) {
		var v = parseInt(hex.substr(i, 10), 16);
		v = isNaN(v) ? '00000000' : v.toString(36);
		if (v.length < 8) {
			v = '0000000' + v;
			v = v.substr(v.length - 8, 8);
		}
		b36 += v.substr(v.length - 8, 8);
	}
	return b36;
}

function sha1(s) { return binb2hex(core_sha1(str2binb(s), s.length * 8)); }
function hmac_sha1(key, data) { return binb2hex(core_hmac_sha1(key, data)); }

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
