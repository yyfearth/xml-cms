var mask = document.getElementById('mask');
var theform = document.getElementById('postform');
var title = document.getElementById('title_field');
var author = document.getElementById('author_field');
var datetime = document.getElementById('datetime_field');
var summary = document.getElementById('summary_field');
var content = document.getElementById('content_field');
String.prototype.size = function() {
	return this.replace(/[^\x00-\xff]/g, "rr").length;
};
theform.onsubmit = function() {
	mask.style.display = 'block';
	if (title.value.size() < 3) {
		alert('请输入正确的标题！')
		title.focus();
	} else if (author.value.size() < 3) {
		alert('请输入正确的作者名！')
		author.focus();
	} else if (summary.value.length == 0) {
		alert('请输入概要！')
		summary.focus();
	} else if (content.value.length == 0) {
		alert('请输入内容！')
		content.focus();
	} else {
		if (/[^\x00-\xff]/.test(datetime.value))
			datetime.value = 'now';
		return ture;
	}
	mask.style.display = 'none';
	return false;
};

summary.onblur = function () {
	if (summary.value)
		summary.value = getXHtml(summary.value);
};
content.onblur = function () {
	if (content.value)
		content.value = getXHtml(content.value);
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