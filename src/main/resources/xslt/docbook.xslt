<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xmlns:archimate="http://www.archimatetool.com/archimate"
   xmlns:zenta="http://magwas.rulez.org/zenta"
   xmlns:saxon="http://saxon.sf.net/"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:include href="xslt/functions.xslt"/>
	<xsl:include href="docbook.local.xslt"/>
	<xsl:include href="xslt/docbook.figure.xslt"/>
	<xsl:include href="xslt/docbook.elementtitle.xslt"/>
	<xsl:include href="xslt/docbook.elementdetails.xslt"/>
	<xsl:include href="xslt/docbook.deviations.xslt"/>
	<xsl:include href="xslt/docbook.tabled.xslt"/>
	<xsl:include href="xslt/docbook.varlist.xslt"/>
	<xsl:include href="xslt/docbook.main.xslt"/>
	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>
</xsl:stylesheet>
