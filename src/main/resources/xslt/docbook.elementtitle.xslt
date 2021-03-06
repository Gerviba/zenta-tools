<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:archimate="http://www.archimatetool.com/archimate"
	xmlns:zenta="http://magwas.rulez.org/zenta"
	xmlns:saxon="http://saxon.sf.net/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>

	<xsl:template match="element[@xsi:type!='zenta:ZentaDiagramModel' and @xsi:type!='zenta:SketchModel']" mode="elementTitle">
		<anchor id="{@id}"/>
		<xsl:value-of select="@name"/>
	</xsl:template>

	<xsl:template match="connection[@name and @direction='1']" mode="elementTitle">
		<anchor id="{@id}"/>
		<xsl:value-of select="@name"/>
	</xsl:template>
</xsl:stylesheet>

