<?php
$admin = array ('admin'=>'b025373b15978dfb71eae3696d7d91869000515c');

//$xml = str_replace( array ('<', '>'), array ('&lt;', '&gt;'), $this->saveXML());

class Post {
	public $id = null, $post = null, $year, $month, $day, $title, $xml, $empty = true;

	public function __construct($post = null) {
		if (gettype($post) == 'array') {
			$this->create($post);
		} else {
			$this->create();
		}
	}

	private function getParam($name, $default, $array) {
		if (array_key_exists($name, $array) && strlen($array[$name]))
			return self::xmlStringSafe($array[$name]);
		else return $default;
	}

	private function getXmlParam($name, $array) {
		if (array_key_exists($name, $array) && strlen($array[$name])) {
			$val = $array[$name];
			$xml = new DOMDocument('1.0', 'utf-8');
			if (!$xml->loadXML("<$name>$val</$name>"))
				$val = self::xmlStringSafe($val);
			return "<$name>$val</$name>";
		} else return '';
	}

	private function sortcut() {
		$this->id = $this->post['id'];
		$this->year = $this->post->datetime['year'];
		$this->month = $this->post->datetime['month'];
		$this->day = $this->post->datetime['day'];
		$this->title = $this->post->title;
	}

	public function create($params_array = null) { // $params_array = $_POST
	// $param_array = array('title'=>$title,'author'=>$author,...);
		if($params_array != null) {
		// param preprocess
			if (!array_key_exists('title', $params_array) ||
				!array_key_exists('author', $params_array))
				throw new Exception('bad_post_submit');
			$title =  self::xmlStringSafe($params_array['title']);
			$author = self::xmlStringSafe($params_array['author']);
			$category = $this->getParam('category', '默认分类', $params_array);
			$tags = $this->getParam('tags', '', $params_array);
			// parse datetime: str (YYYY-MM-dd hh:mm:ss) or now
			$datetime = strtotime($this->getParam('datetime', 'now', $params_array));
			if (!$datetime) $datetime = strtotime('now');
			$id = date("YmdHis", $datetime);
			$year = date("Y", $datetime);
			$month = date("m", $datetime);
			$day = date("d", $datetime);
			$time = date("H:i:s", $datetime);
			// tags
			if ($tags != null && strlen($tags) > 0) {
				$tagxml = '';
				foreach (split(',\s*', $tags) as $tag)
					$tagxml .= "<tag>$tag</tag>";
				$tags = $tagxml;
			} else $tags = '';
			// summary
			$summary = $this->getXmlParam('summary', $params_array);
			// content
			$content = $this->getXmlParam('content', $params_array);
			$this->empty = false;
		} else {
			$title = '';
			$datetime = '';
			$author = '';
			$category = '';
			$tags = '';
			$summary = '';
			$content = '';
			$this->empty = true;
		}
		// build xml
		try {
			$this->xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?><?xml-stylesheet href=\"style/postview.xsl\" type=\"text/xsl\"?><post id=\"$id\"><title>$title</title><datetime year=\"$year\" month=\"$month\" day=\"$day\" time=\"$time\"/><author>$author</author><category>$category</category>$tags$summary$content</post>";
			$this->post = simplexml_load_string($this->xml);
			$this->sortcut(); // shortcut
		} catch (Exception $e) {
			throw new Exception('build_xml_err');
		}
		return $this; // simplexml obj
	}

	public function save() {
		$this->post->asXML($this->id.'.xml');
	}

	/*public function xmlexist() {
		if (!$this->id) {
			throw new Exception('post_not_created');
		}
		return file_exists($this->id.'.xml');
	}

	public function validate() {
		if ($this->id == null) {
			throw new Exception('post_not_created');
		}
		$xml = new DOMDocument('1.0', 'utf-8');
		$xml->appendChild(dom_import_simplexml($this));
		return $xml->schemaValidate('schema/post.xsd');
	}*/

	public function writexml() {
		$this->save();
	}

	public static function xmlStringSafe($str) {
		return str_replace(array('<', ">"), array('&lt;', "&gt;"), $str);
	}

	public static function del($id) {
		if (file_exists($id.'.xml')) {
			unlink($id.'.xml');
		}
	}

}

class Calendar extends DOMDocument {
	public $xmlfile = 'calendar.xml';
	private $root = null, $xpath = null;

	public function __construct() {
		parent::__construct('1.0', 'utf-8');
		//$this->formatOutput = true; // nicely formats
		if (!@$this->load($this->xmlfile)) {
			$this->root = $this->createElement('calendar');
			$this->appendChild($this->root);
		} else {
			$this->root = $this->documentElement;
		}
		$this->xpath = new DOMXPath($this);
	}

	private function createYearNode($year) {
		$yearnode = $this->createElement('year');
		$yearnode->setAttribute('year', $year); // @year
		$this->root->insertBefore($yearnode, $this->root->firstChild);
		return $yearnode;
	}

	private function getYearNode($year, $createnew) {
		$yearnode = $this->xpath->query("//year[@year='$year']");
		if ($yearnode->length) {
			return $yearnode->item(0);
		} else {
			if ($createnew) {
				return $this->createYearNode($year);
			} else {
				return false;
			}
		}
	}

	private function createMonthNode($year, $month) {
		$yearnode = $this->getYearNode($year, true);
		$monthnode = $this->createElement('month');
		$monthnode->setAttribute('month', $month); // @month
		$yearnode->insertBefore($monthnode, $yearnode->firstChild);
		return $monthnode;
	}

	private function getMonthNode($year, $month, $createnew) {
		$monthnode = $this->xpath->query("//year[@year='$year']/month[@month='$month']");
		if ($monthnode->length) {
			return $monthnode->item(0);
		} else {
			if ($createnew) {
				return $this->createMonthNode($year, $month);
			} else {
				return false;
			}
		}

	}

	private function createDayNode($year, $month, $day) {
		$monthnode = $this->getMonthNode($year, $month, true);
		$daynode = $this->createElement('day');
		$daynode->setAttribute('day', $day); // @day
		$monthnode->insertBefore($daynode, $monthnode->firstChild);
		return $daynode;
	}

	private function getDayNode($year, $month, $day, $createnew) {
		$daynode = $this->xpath->query("//year[@year='$year']/month[@month='$month']/day[@day='$day']");
		if ($daynode->length) {
			return $daynode->item(0);
		} else {
			if ($createnew) {
				return $this->createDayNode($year, $month, $day);
			} else {
				return false;
			}
		}
	}

	public function exists($post) { // chk id
		$id = $post->id;
		return ($this->xpath->evaluate("count(/descendant::post[@id='$id'])") > 0);
	}

	public function titleDuplicate($post) { // chk title
		$title = $post->title;
		return ($this->xpath->evaluate("count(/descendant::post[title='$title'])") > 0);
	}

	public function add($post) { // main method
		if ($this->exists($post)) {
			throw new Exception('post_exists');
		} elseif ($this->titleDuplicate($post)) {
			throw new Exception('title_duplicate');
		}
		// build datetime
		$year = $post->year;
		$month = $post->month;
		$day = $post->day;
		// create postheader clone post
		$postheader = $this->importNode(dom_import_simplexml($post->post), true);
		// remove content & summary to get produce postheader
		$postheader->removeChild($postheader->lastChild);
		$postheader->removeChild($postheader->lastChild);
		// search node to nested
		$daynode = $this->getDayNode($year, $month, $day, true);
		// insert new post
		$daynode->insertBefore($postheader, $daynode->firstChild);
		// save post.xml
		$post->writexml();
		// create year.xml
		$this->createYear($year);
		// update month.xml
		$month = new Month($year, $month);
		$month->add($post, true);
		// update lastupdate.xml
		$this->lastupdate();
		// save calendar.xml
		$this->writexml();
	}

	public function del($id) { // main method
		if (strlen($id) != 14)
			throw new Exception('bad_id:$id');
		$post = $this->xpath->query("/descendant::post[@id='$id']");
		if ($post->length) {
			$post = $post->item(0);
			$day = $post->parentNode;
			$day->removeChild($post);
			$month = $day->parentNode;
			$year = $month->parentNode;
			if($day->childNodes->length == 0) { // empty entry do clear
				if ($this->xpath->evaluate('count(descendant::post)', $year) == 0) {
				// del year.xml months.xml days.xml posts.xml
					$this->delYear($year);
				} elseif ($this->xpath->evaluate('count(descendant::post)', $month) == 0) {
				// del month.xml days.xml posts.xml
					$year->removeChild($month);
					$m = new Month($year->getAttribute('year'), $month->getAttribute('month'));
					$m->del();
				} else {
					$month->removeChild($day);
					$m = new Month($year->getAttribute('year'), $month->getAttribute('month'));
					$m->del($day->getAttribute('day'));
				}
			} else Post::del($id); // only del post
			// save this xml
			$this->writexml();
			// update lastupdate.xml
			$this->lastupdate();
		} else {
			throw new Exception('post_not_exist');
		}
	}

	public function writexml() {
		$this->save($this->xmlfile);
	}

	public function getxml() {
		$this->saveXML();
	}

	public function lastupdate() { // only get
		$nodes = $this->xpath->query('/descendant::post[not(@id</descendant::post/@id)]');
		// $nodes = $this->getElementsByTagName('post');
		if (!$nodes->length) {
			simplexml_load_string("<?xml version=\"1.0\" encoding=\"utf-8\"?>
<?xml-stylesheet href=\"style/lastupdate.xsl\" type=\"text/xsl\"?>
<post/>")->asXML('lastupdate.xml');
			return null;
		} else {
			$lastpost = simplexml_import_dom($nodes->item(0));
			$id = $lastpost['id'];
			$year = $lastpost->datetime['year'];
			$month = $lastpost->datetime['month'];
			$day = $lastpost->datetime['day'];
			simplexml_load_string("<?xml version=\"1.0\" encoding=\"utf-8\"?>
<?xml-stylesheet href=\"style/lastupdate.xsl\" type=\"text/xsl\"?>
<post year=\"$year\" month=\"$month\" day=\"$day\" id=\"$id\"/>")->asXML('lastupdate.xml');
			return array('id'=>$id, 'year'=>$year, 'month'=>$month, 'day'=>$day);
		}
	}

	public function createYear($year) {
		$file = $year.'.xml';
		if (!file_exists($file)) {
			$xml = new DOMDocument('1.0', 'utf-8');
			$xml->appendChild( new DOMProcessingInstruction('xml-stylesheet',
				'href="style/year.xsl" type="text/xsl"'));
			$node = $xml->createElement('year');
			$node->setAttribute('year', $year); // @year
			$xml->appendChild($node);
			$xml->save($file);
		}
	}

	public function delYear($year) {
		if($year instanceof DOMNode) {
			$yearnode = $year;
			$year = $yearnode->getAttribute('year');
		} else {
			if (strlen($year) != 4)
				throw new Exception("bad_year:$year");
			$yearnode = $this->getYearNode($year);
		}
		if ($yearnode)
			$yearnode->parentNode->removeChild($yearnode);
		foreach (glob("$year*.xml") as $filename)
			unlink($filename);
	}
}

class Month extends DOMDocument {
	public $xmlfile = null;
	public $year, $month;
	private $root = null, $xpath = null;

	public function __construct($year, $month = null) {
		parent::__construct('1.0', 'utf-8');
		if ($year instanceof Post) {
			$month = $year->month;
			$year = $year->year;
		}
		if (strlen($year) != 4 || strlen($month) != 2)
			throw new Exception('month:bad_date');
		$this->xmlfile = $year.$month.'.xml';
		$this->year = $year;
		$this->month = $month;
		if (!@$this->load($this->xmlfile)) {
			$this->appendChild( new DOMProcessingInstruction('xml-stylesheet',
				'href="style/month.xsl" type="text/xsl"'));
			$monthnode = $this->createElement('month');
			$monthnode->setAttribute('year', $this->year); // @year
			$monthnode->setAttribute('month', $this->month); // @month
			$this->appendChild($monthnode);
		}
		$this->root = $this->documentElement;
		$this->xpath = new DOMXPath($this);
	}

	public function add($post, $auto) { // main method
	// check datetime
		$year = $post->year;
		$month = $post->month;
		$day = $post->day;
		if ($year != $this->year || $month != $this->month) {
			throw new Exception('datetime_mismatch');
		}
		// clone post
		$postsummary = $this->importNode(dom_import_simplexml($post->post), true);
		// remove content to get produce postsummary
		$postsummary->removeChild($postsummary->lastChild);
		// find day to nested
		$daynode = $this->xpath->query("//day[@day='$day']");
		if ($daynode->length) {
			$daynode = $daynode->item(0);
		} else {
		// create
			$daynode = $this->createElement('day');
			$daynode->setAttribute('day', $day); // @year
			$this->root->insertBefore($daynode, $this->root->firstChild);
		}
		$daynode->insertBefore($postsummary, $daynode->firstChild);
		// create day xml
		$this->createDayXML($year, $month, $day);
		// save this xml
		$this->writexml();
	}

	public function del($id = null) { // main method
		if ($id == null) { // del this month
		// del month.xml days.xml posts.xml
			foreach (glob($this->year.$this->month."*.xml") as $filename)
				unlink($filename);
		} else {
			$post = $this->xpath->query("//post[@id='$id']");
			if ($post->length) {
				$post = $post->item(0);
				$day = $post->parentNode;
				$day->removeChild($post);
				if($day->childNodes->length == 0) { // empty day to clear
					$day = $this->root->removeChild($day);
					$this->deleteDayXML($day->getAttribute('day')); // del day.xml
				}
				Post::del($id); // del post.xml
				// save this xml
				$this->writexml();
			}
		}
	}

	public function writexml() {
		$this->save($this->xmlfile);
	}

	public function createDayXML($day) {
		$file = $this->year.$this->month.$day.'.xml';
		if (!file_exists($file)) {
			$xml = new DOMDocument('1.0', 'utf-8');
			$xml->appendChild( new DOMProcessingInstruction('xml-stylesheet',
				'href="style/day.xsl" type="text/xsl"'));
			$node = $xml->createElement('day');
			$node->setAttribute('year', $this->year); // @year
			$node->setAttribute('month', $this->month); // @month
			$node->setAttribute('day', $day); // @day
			$xml->appendChild($node);
			$xml->save($file);
		}
	}

	public function deleteDayXML($year, $month, $day) {
		$file = $year.$month.$day.'.xml';
		if (file_exists($file)) {
			unlink($file);
		}
	}

}


function lhex2b36($hex) {
	$b36 = '';
	foreach (str_split($hex, 10) as $v)
		$b36 .= str_pad(base_convert($v, 16, 36), 8, '0', STR_PAD_LEFT);
	return $b36;
}

function lb362hex($b36) {
	$hex = '';
	foreach (str_split($b36, 8) as $v)
		$hex .= str_pad(base_convert($v, 36, 16), 10, '0', STR_PAD_LEFT);
	return $hex;
}

/*if (array_key_exists('session_id', $_COOKIE))
 session_id($_COOKIE['session_id']);*/

function printxml($xml, $die = false) {
	echo '<?xml version="1.0" encoding="utf-8" ?>
<?xml-stylesheet href="style/xhtml.xsl" type="text/xsl"?>';
	if (!$die) echo $xml;
	else die($xml);
}

if (isset ($_COOKIE['session_id']) &&
	strlen($_COOKIE['session_id']) == 32)
	session_id($_COOKIE['session_id']);
@session_start();
header ("Content-type: text/xml"); //XML
header ("Expires: Mon,26 Jul 1997 05:00:00 GMT"); // Date in the past
header ("Last-Modified: ".gmdate("D, d M Y H:i:s")." GMT"); // always modified
header ("Cache-Control: no-cache, must-revalidate"); // HTTP/1.1
header ("Pragma: no-cache"); // HTTP/1.0
if (array_key_exists('req', $_GET)) {
	switch($_GET['req']) {
		case 'admin':
			if (!isset ($_SESSION['admin'])) {
				echo '<err>not_login</err>';
			} else {
				$admin = $_SESSION['admin'];
				echo "<admin>$admin</admin>";
			}
			break;
		case 'timestamp':
			$timestamp = time();
			echo "<timestamp>$timestamp</timestamp>";
			break;
		default:
			echo "<err>bad_req</err>";
	}
} elseif (isset ($_GET['act'])) {
	switch($_GET['act']) {
		case 'login':
			if (!array_key_exists('user',$_GET) ||
				!array_key_exists('hash',$_GET)) {
				printxml ('<err>错误的请求！</err>', true);
			}
			$user = strtolower($_GET['user']);
			if (array_key_exists($user, $admin)) {
				$ps = $admin[$user];
				$hash = lb362hex($_GET['hash']);
				$ts = intval(substr($hash, 40, 10));
				if (abs(time()-$ts) > 100) {
					printxml ('<err href="mgr.xml">登录信息已经失效！</err>');
				} else {
					$cp = hash_hmac('sha1', $ps, $user.'XmlCMS'.$ts).$ts;
					if ($cp == $hash) {
						$_SESSION['admin'] = $user;
						setcookie('session_id', session_id());
						printxml ('<xhtml><h1 align="center" style="margin-top:25px">登录成功！</h1>
						<script type="text/javascript">
							setTimeout("location.replace(\'mgr.xml\')",1000)
						</script></xhtml>');
					} else {
						printxml ('<err href="mgr.xml">密码错误！</err>');
					}
				}
			} else {
				printxml ('<err href="mgr.xml">用户名错误</err>');
			}
			break;
		case 'logout':
			if (isset ($_SESSION['admin'])) {
				unset($_SESSION['admin']);
				//session_destroy();
				setcookie('session_id');
				printxml ('<msg href="mgr.xml">注销成功！</msg>');
			} else {
				printxml ( '<err href="mgr.xml">未登录</err>');
			}
			break;
		case 'add':
			if (!isset ($_SESSION['admin']))
				printxml ('<err href="mgr.xml">管理员未登录</err>', true);
			try {
				$post = new Post($_POST);
				$calendar = new Calendar();
				$calendar->add($post, true);
				printxml ('<msg href="mgr.xml">日志添加成功！</msg>');
			} catch (Exception $e) {
				switch ($e->getMessage()) {
					case 'post_exists':
						$msg = "日志已经存在或日期时间重复！";
						break;
					case 'title_duplicate':
						$msg = "标题不能重复！";
						break;
					default:
						$msg = $e->getMessage();
				}
				printxml ("<err href='javascript:history.back()'>$msg</err>");
			}
			break;
		case 'del':
			if (!isset ($_SESSION['admin']))
				printxml ('<err href="mgr.xml">管理员未登录</err>', true);
			if (isset ($_GET['id']) || $_GET['id']) {
				try {
					$calendar = new Calendar();
					foreach (split(',', $_GET['id']) as $id)
						$calendar->del($id);
					printxml ('<msg href="mgr.xml">日志删除成功！</msg>');
				} catch (Exception $e) {
					switch ($e->getMessage()) {
						case 'post_not_exist':
							$msg = "要删除的日志不存在！";
							break;
						default:
							$msg = $e->getMessage();
					}
					printxml ("<err href='javascript:history.back()'>$msg</err>");
				}
			} else {
				printxml ("<err href='mgr.xml'>没有要删除的日志！</err>");
			}
			break;
		case 'edt':
			if (!isset ($_SESSION['admin']))
				printxml ('<err href="mgr.xml">管理员未登录</err>', true);
			if (isset ($_GET['id']) || $_GET['id'])
				echo '<?xml version="1.0" encoding="utf-8" ?>
<?xml-stylesheet href="style/postedit.xsl" type="text/xsl"?>
<post id="'.$_GET['id'].'"/>';
			else printxml ("<err href='mgr.xml'>没有要编辑的日志！</err>");
			break;
		case 'mod':
			if (!isset ($_SESSION['admin']))
				printxml ('<err href="mgr.xml">管理员未登录</err>', true);
			if (!isset ($_POST['date']) || !$_POST['date']) {
				// is mod not upd

				break; // break here
			} // else goto upd
		case 'upd':
			if (!isset ($_SESSION['admin']))
				printxml ('<err href="mgr.xml">管理员未登录</err>', true);
			
			break;
		default:
			printxml ("<err>bad_act</err>");
	}
} else {
	echo "<err>no_req</err>";
}
?>
