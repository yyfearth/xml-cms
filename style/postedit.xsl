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
							<span id="category_area" class="categories" title="编辑分类">
								<xsl:value-of select="$post/category" />
							</span>
							<input class="categories" id="category_field" maxlength="10" name="category" />
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
				<script type="text/javascript">
		<![CDATA[
var names = ['title', 'date', 'author', 'category', 'tags', 'summary', 'content'];
var theform = document.getElementById('editform');
var submit = document.getElementById('submit');
submit.disabled = true;

function alterField(name) {
	var area = document.getElementById(name + '_area');
	var field = document.getElementById(name + '_field');
	var istextfield = /input/i.test(field.nodeName);
	var display = area.style.display;
	field.style.display = 'none';
	area.style.cursor = 'pointer';
	area.onmouseover = function () {
		// this.style.border = '1px solid black';
		this.style.backgroundColor = '#eedd99';
	};
	area.onmouseout = function () {
		// this.style.border = 'none';
		this.style.backgroundColor = '';
	};
	field.onfocus = field.onchange = function () {
		if (istextfield) {
			field.size = field.value.replace(/[^\u0000-\u00ff]/g,"aa").length + 5;
		} else {
			field.style.overflowY = 'visible';
			field.style.height = field.scrollHeight + 'px';
			setTimeout(function () {
				field.style.height = field.scrollHeight + 'px';
			}, 100);
		}
	}
	area.onclick = function () {
		area.style.display = 'none';
		field.value = getXHtml(area.innerHTML);
		field.style.display = display;
		field.focus();
	};
	field.edt = false;
	field.onchange = function () {
		field.changed = true;
	}
	field.onblur = function () {
		if (field.value && (field.edt || field.changed && confirm('确定修改？'))) {
			area.innerHTML = field.value;
			if (!field.edt) {
				field.edt = true;
				delete field.changed;
				field.onchange = null;
				area.style.border = '1px dashed blue';
				submit.disabled = false;
			}
		}
		area.style.display = display;
		field.style.display = 'none';
	};
}

for (var i in names) alterField(names[i]);

theform.onsubmit = function () {
	for (var i in names) {
		var field = document.getElementById(names[i] + '_field');
		if (!field.edt) {
			field.value = '';
			field.disabled = true; // not submit
		}
	}
};

function getXHtml(str) {
	return str.replace(/^\s+|\s+$|\t+/g,'')
	.replace(/<[^<>]+>/gm, function(nodeHtml){
		if(nodeHtml.indexOf("/>")>-1 || nodeHtml.indexOf("</")>-1 ){
			return nodeHtml.toLowerCase();
		}

		//fix string has quot 's attribute.
		nodeHtml = nodeHtml.replace(/\w+="{1}[^"]*"{1}/gm,function(nodeAtt){
			var arr = nodeAtt.split('="');
			var attValue = arr[1].substr(0,arr[1].length-1);
			//attValue = xmlEscape(attValue);
			return arr[0].toLowerCase() + '="' + attValue + '"';
		});

		//fix not has quot 's attribute.
		nodeHtml = nodeHtml.replace(/ \w+=[^"> ]+/gm,function(nodeAtt){
			var n = nodeAtt.indexOf('=');
			var attName = nodeAtt.substring(0,n+1);
			var attValue = nodeAtt.substr(n+1);
			//attValue = xmlEscape(attValue);
			return attName.toLowerCase() + '"' + attValue + '"';
		});

		var nodeName;
		nodeHtml = nodeHtml.replace(/<\w+/gm,function(nn){
			nn = nn.toLowerCase();
			nodeName = nn.substr(1);
			return nn;
		});
		if(nodeName=="input"||nodeName=="hr"||nodeName=="br"||nodeName=="img"){
			if( nodeHtml.substr(nodeHtml.length-2) != "/>" ){
				nodeHtml = nodeHtml.substr(0,nodeHtml.length-1) + "/>";
			}
		}
		return nodeHtml;
	});
}
		]]>
				</script>
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
