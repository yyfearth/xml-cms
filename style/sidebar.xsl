<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:variable name="cal" select="document('../calendar.xml')"/>
	<xsl:template match="/">
		<div id="sidebar" class="sidebar">
			<script type="text/javascript">
				<![CDATA[
if(/msie [0-5]\.|firefox\/1|mozilla\/[0-3]|opera\/[0-7]/i.test(navigator.userAgent))
	document.writeln('<div id="browserwarnning"><a href="browsers.html">您所使用的浏览器版本过低，可能无法正常的浏览本页面！如果想要浏览完整的效果，请更新或更换浏览器。</a></div>');
else if(/msie 6/i.test(navigator.userAgent))
	document.writeln('<div id="ie6notify"><a href="browsers.html">您所使用的 Microsoft Internet Explorer 6.0 浏览器，无法正确的处理本页面中某些细节，为了更好的浏览体验，更为了互联网应用的美好明天，强烈推荐您升级您的浏览器！</a></div>');
				]]>
			</script>
			<div class="widget">
				<div class="title">广告赞助</div>

				<div class="fixed"></div>
			</div>
			<div class="widget">
				<div class="title">迷你日历</div>
				<div id="minical"></div>
				<xsl:variable name="datecal">
					<xsl:for-each select="$cal//month">
						<xsl:sort select="concat(../@year,@month)" data-type="number" />
						<xsl:value-of select="concat(../@year,@month,':{')"/>
						<xsl:for-each select="day">
							<xsl:value-of select="@day"/>:
							<xsl:value-of select="count(./post)"/>
							<xsl:if test="not(position()=last())">,</xsl:if>
						</xsl:for-each>
						<xsl:text>}</xsl:text>
						<xsl:if test="not(position()=last())">,</xsl:if>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="curmonth">
					<xsl:choose>
						<xsl:when test="/month">
							<xsl:value-of select="concat(//@year,//@month)"/>
						</xsl:when>
						<xsl:when test="/post">
							<xsl:value-of select="concat(//datetime/@year,//datetime/@month)"/>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<script type="text/javascript">
					var curmonth =
					<xsl:value-of select="$curmonth"/>,
					datecal = {
					<xsl:value-of select="$datecal"/>};
					<![CDATA[
function prevmonth() {
	var y = Math.floor(curmonth/100), m = curmonth % 100 - 1;
	if (m == 0) { y--; m = 12 }
	curmonth = y * 100 + m;
	return showcal(curmonth);
}
function nextmonth() {
	var y = Math.floor(curmonth/100), m = curmonth % 100 + 1;
	if (m == 13) { y++; m = 1 }
	curmonth = y * 100 + m;
	return showcal(curmonth);
}
function showcal(cur) {
	var now = new Date(), nowstr = now.toDateString();
	if (!cur) cur = now.getFullYear() * 100 + now.getMonth() + 1;
	var y = Math.floor(cur/100), m = cur % 100;
	curmonth = y * 100 + m;
	var h = '<table><caption><a href="#" title="上月" onclick="return prevmonth()">&lt;</a> ' +
		((cur in datecal)? '<a href="' + cur + '.xml">' + y + '年' + m + '月</a>' : y + '年' + m + '月') +
		'<a href="#" title="下月" onclick="return nextmonth()">&gt;</a></caption>' +
		'<tr><th>日</th><th>一</th><th>二</th><th>三</th><th>四</th><th>五</th><th>六</th></tr>\n<tr>';
	var date = new Date(y,m-1,1);
	if (date.getDay()) h += '<td colspan="' + date.getDay() + '"></td>';
	for (var d = 1; d <= new Date(y,m,0).getDate(); d++) {
		date = new Date(y,m-1,d);
		if (date.getDay() == 0) h += '</tr><tr>';
		h += '<td ' + (
				(nowstr == date.toDateString())?
				'class="today" title="今天"' : ''
			) + '>' + (
				(cur in datecal && d in datecal[cur]) ?
				'<a href="' + cur + '.xml?' + d + '" title="' + d + ' 日 有 ' + datecal[cur][d] + ' 篇日志"> ' + d + '</a>'
				: d
			) + '</td>';
	}
	h += '</tr></table>';
	document.getElementById('minical').innerHTML = h;
	return false;
}
showcal(curmonth);
					]]>
				</script>
				<div class="fixed"></div>
			</div>
			<div class="widget">
				<div class="title">最近更新</div>
				<ul>
					<xsl:for-each select="$cal/descendant::post[position()&lt;6]">
						<li>
							<a href="{@id}.xml" title="『{title}』于{datetime/@year}-{datetime/@month}-{datetime/@day} {datetime/@time}发表">
								<xsl:value-of select="title"/>
							</a>
						</li>
					</xsl:for-each>
				</ul>
				<div class="fixed"></div>
			</div>
			<div class="widget">
				<div class="title">日志分类</div>
				<xsl:variable name="cats">
					<xsl:for-each select="$cal/descendant::post/category">
						<xsl:sort select="text()" order="descending" />
						<xsl:text>'</xsl:text>
						<xsl:value-of select="."/>
						<xsl:text>',</xsl:text>
					</xsl:for-each>
					<xsl:text>null</xsl:text>
				</xsl:variable>
				<script type="text/javascript">
					var cats = [
					<xsl:value-of select="$cats"/>];
					<![CDATA[
document.writeln('<ul>');
for (var i = 0; i < cats.length - 1; i++)
	if (cats[i] != cats[i+1])
		document.writeln('<li><a href="category.xml?' + cats[i] + '">'+ cats[i] + '</a></li>');
document.writeln('</ul>');
					]]>
				</script>
				<div class="fixed"></div>
			</div>
			<div class="widget">
				<div class="title" style="text-align:center">
					<a href="mgr.xml">后台管理</a>
				</div>
				<div class="fixed"></div>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
