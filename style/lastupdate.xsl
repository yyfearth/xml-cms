<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:import href="frame.xsl" />
	<xsl:import href="post.xsl" />

	<xsl:template match="/post">
		<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="zh-hans">
			<head>
				<meta http-equiv="refresh" content="0;url={@id}.xml" />
			</head>
		</html>
	</xsl:template>
</xsl:stylesheet>
