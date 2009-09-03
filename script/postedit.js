var names = ['title', 'date', 'author', 'category', 'tags', 'summary', 'content'];
var theform = document.getElementById('editform');
var submit = document.getElementById('submit');
submit.disabled = true;
function intval(v) {
	var i = parseInt(v.toString());
	return isNaN(i)?0:i;
}
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
	field.onfocus = function () {
		if (istextfield) {
			field.size = field.value.replace(/[^\u0000-\u00ff]/g,"aa").length + 5;
		} else if (Math.abs(intval(field.style.height) - field.scrollHeight) > 6) {
			field.style.overflowY = 'visible';
			field.style.height = field.scrollHeight + 'px';
			/*setTimeout(function () {
				field.style.height = field.scrollHeight + 'px';
			}, 100);*/
		}
	}
	area.onclick = function () {
		area.style.display = 'none';
		field.value = getXHtml(area.innerHTML);
		field.style.display = display;
		field.focus();
	};
	field.edt = false;
	field.changed = false;
	field.onchange = function () {
		field.changed = true;
		field.onfocus();
	};
	if ('onpropertychange' in field) { // ie
		field.onpropertychange = function () {
			if (window.event.propertyName == 'value'
				&& field.style.display != 'none')
				field.onchange();
		};
	} else if (field.addEventListener) {
		field.addEventListener("input", field.onchange, false);
	}
	field.onkeydown = function (e) {
		var keynum;
		if(window.event) { // IE
			keynum = window.event.keyCode;
		} else if (e.keyCode) {
			keynum = e.keyCode;
		} else {
			keynum = e.which;
		}
		switch (keynum) {
			case 13: // enter
				if (istextfield) {
					field.alter(field.changed);
					return false;
				}
				break;
			case 27: // esc
				field.alter(false);
				break;
		}
		return true;
	};
	field.alter = function (c) {
		if (c) {
			area.innerHTML = field.value;
			if (!field.edt) {
				field.edt = true;
				area.style.border = '1px dashed blue';
				submit.disabled = false;
			}
		} else field.changed = false;
		area.style.display = display;
		field.style.display = 'none';
	};
	field.onblur = function () {
		field.alter(field.value && (field.edt || field.changed && confirm('确定修改？')));
	};
}

for (var i in names) alterField(names[i]);

theform.onsubmit = function () {
	if (submit.disabled) return false;
	for (var i in names) {
		var field = document.getElementById(names[i] + '_field');
		if (!field.edt) {
			field.value = '';
			field.disabled = true; // not submit
		}
	}
	return true;
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
