<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:archimate="http://www.archimatetool.com/archimate"
	xmlns:zenta="http://magwas.rulez.org/zenta"
	xmlns:saxon="http://saxon.sf.net/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>

	<xsl:template match="element[@xsi:type='zenta:ZentaDiagramModel']" mode="tablerow">
		<row><entry namest="c1" nameend="c2"><para>
			<xsl:apply-templates select="." mode="figure"/>
		</para></entry></row>
	</xsl:template>

	<xsl:template match="folder" mode="elementtable">
		<table class="elementtable">
			<tgroup cols="2"><colspec colname="c1"/><colspec colname="c2"/>
				<tbody>
					<xsl:apply-templates select="element[@xsi:type='zenta:ZentaDiagramModel']" mode="tablerow"/>
					<xsl:apply-templates select="element[@xsi:type!='zenta:ZentaDiagramModel']" mode="tablerow"/>
					<xsl:apply-templates select="connection[@name and @direction='1']" mode="tablerow"/>
				</tbody>
			</tgroup>
		</table>
	</xsl:template>

	<xsl:template match="folder">
		<section>
			<xsl:copy-of select="@id"/>
			<title>
				<xsl:value-of select="@name"/>
			</title>
			<para>
				<xsl:copy-of select="documentation/(*|text())"/>
			</para>
			<xsl:apply-templates select="folder"/>
			<xsl:apply-templates select="." mode="elementtable"/>
		</section>
	</xsl:template>

	<xsl:template match="element[@xsi:type!='zenta:ZentaDiagramModel']|connection[@name and @direction='1']" mode="tablerow">
		<row>
			<entry class="starter">
				<xsl:apply-templates select="." mode="elementTitle"/>
			</entry>
			<entry class="documentation">
				<xsl:apply-templates select="." mode="elementDetails"/>
			</entry>
		</row>
	</xsl:template>

</xsl:stylesheet>