var ads = {
	paras : {
		alimama_pid : "{id}",
		alimama_titlecolor : "0000FF",
		alimama_descolor : "000000",
		alimama_bgcolor : "FFFFFF",
		alimama_bordercolor : "E6E6E6",
		alimama_linkcolor : "008000",
		alimama_bottomcolor : "FFFFFF",
		alimama_anglesize : "0",
		alimama_bgpic : "0",
		alimama_icon : "0",
		alimama_sizecode : "22",
		alimama_width : 120,
		alimama_height : 240,
		alimama_type : 2
	},
	domains: /yyfearth.com|yyfearth.w44.08host.com/i,
	list : [{
		alimama_pid : "mm_10080744_272224_356175"
	}, {
		alimama_pid : "mm_10080744_272224_8104457"
	}]
};

function showad(id) {
	if (id == null) {
		if (location.search) {
			id = parseInt(location.search.substr(1));
			if (isNaN(id)) id = 0;
		} else id = 0;
	}
	var html = '<iframe id="fra_ad_' + id + '" src="about:blank" scrolling="no" frameborder="no" width="0px" height="0px"></iframe>';
	var ad_div = document.getElementById('ad_' + id);
	if (!ad_div) throw new Error('can not find container');
	ad_div.innerHTML = html;
	if (ads.list[id]) {// id is index
		for (var pni in ads.list[id])
			ads.paras[pni] = ads.list[id][pni];
	} else //id is directly alimama_pid
		ads.paras.alimama_pid = id;
	var adhtml = '<html style="overflow:hidden"><body style="margin:0px;overflow:hidden">';
	if (ads.domains.test(document.domain)) {
		adhtml += '<script type="text/javascript">';
		for (var pn in ads.paras)
			adhtml += pn + '="' + ads.paras[pn] + '";';
		adhtml += '</' +
	'script><script src="http://a.alimama.cn/inf.js" type="text/javascript"></' +
	'script></body></html>';
	} else adhtml += '<div style="position:absolute;top:0px;left:0px;width:' +
		(ads.paras.alimama_width - 2) + 'px;height:' +
		(ads.paras.alimama_height - 2) + 'px;background-color:#' +
		ads.paras.alimama_bgcolor + ';border:1px solid #' +
		ads.paras.alimama_bordercolor + ';font-size:10px"><center style="margin-top:' +
		(ads.paras.alimama_height / 2 - 10) + 'px">此域名广告已被屏蔽！</center></div>';
	var ifr = ad_div.firstChild || document.getElementById('fra_ad_' + id);
	if (ifr) {
		ifr.width = ads.paras.alimama_width;
		ifr.height = ads.paras.alimama_height;
		var ifr_doc = ifr.contentWindow.document || window.frames['fra_ad_' + id].document;
		if (ifr_doc) {
			ifr_doc.open("text/html","replace");
			ifr_doc.write(adhtml);
			ifr_doc.close();
		} else throw new Error('can not get iframe document');
	} else throw new Error('can not find iframe');
}