<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:archimate="http://www.archimatetool.com/archimate"
	xmlns:zenta="http://magwas.rulez.org/zenta"
	xmlns:saxon="http://saxon.sf.net/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>

		
	<xsl:template match="element[@xsi:type!='zenta:ZentaDiagramModel']|connection[@name and @direction='1']" mode="varlistentry">
		<varlistentry>
			<term>
				<xsl:apply-templates select="." mode="elementTitle"/>
			</term>
			<listitem>
				<xsl:apply-templates select="." mode="elementDetails"/>
			</listitem>
		</varlistentry>
	</xsl:template>

	<xsl:template match="folder" mode="varlistList">
		<para>
			<xsl:if test="element[@xsi:type!='zenta:ZentaDiagramModel']|connection[@name and @direction='1']">
				<variablelist>
					<xsl:apply-templates select="element[@xsi:type!='zenta:ZentaDiagramModel']" mode="varlistentry"/>
					<xsl:apply-templates select="connection[@name and @direction='1']" mode="varlistentry"/>
				</variablelist>
			</xsl:if>
		</para>
	</xsl:template>

	<xsl:template match="folder" mode="varlist">
		<section>
			<xsl:copy-of select="@id"/>
			<title>
				<xsl:value-of select="@name"/>
			</title>
			<para>
				<xsl:copy-of select="documentation/(*|text())"/>
			</para>
			<para>
				<xsl:apply-templates select="element[@xsi:type='zenta:ZentaDiagramModel']" mode="figure"/>
			</para>
			<xsl:apply-templates select="folder" mode="varlist">
				<xsl:sort select="@name"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="." mode="varlistList"/>
		</section>
	</xsl:template>

</xsl:stylesheet>