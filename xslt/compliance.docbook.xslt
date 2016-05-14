<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>

	<xsl:template match="component" mode="colspec">
		<colspec colname="{@name}"/>
	</xsl:template>

	<xsl:template match="component" mode="thead">
		<entry>
			<xsl:value-of select="description"/>
		</entry>
	</xsl:template>

	<xsl:template match="component" mode="entry">
		<entry>
			<xsl:copy-of select="@name"/>
			<xsl:choose>
				<xsl:when test="@passed='true'">
					<xsl:attribute name="role" select="'pass'"/>
					<para>pass</para>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="role" select="'fail'"/>
					<para>fail</para>
				</xsl:otherwise>
			</xsl:choose>
		</entry>
	</xsl:template>

	<xsl:template match="aspect">
		<row>
			<xsl:copy-of select="@name"/>
			<entry>
				<xsl:value-of select="description"/>
			</entry>
			<xsl:apply-templates select="component" mode="entry"/>
		</row>
	</xsl:template>

	<xsl:template match="compliancegroup">
		<section>
			<xsl:copy-of select="@id"/>
			<title><xsl:value-of select="@title"/></title>
			<table frame="all">
				<title><xsl:value-of select="@title"/></title>
				<tgroup>
					<xsl:attribute name="cols" select="@component_count+1"/>
					<colspec colname="aspect"/>
					<xsl:apply-templates select="aspect[1]/component" mode="colspec"/>
					<thead><row>
						<entry>Aspect</entry>
						<xsl:apply-templates select="aspect[1]/component" mode="thead"/>
					</row></thead>
					<tbody>
						<xsl:apply-templates select="aspect"/>
					</tbody>
				</tgroup>
			</table>
		</section>
	</xsl:template>

	<xsl:template match="compliance">
		<article>
			<title>Compliance check</title>
			<xsl:apply-templates select="compliancegroup"/>
		</article>
	</xsl:template>

	<xsl:template match="@*|*|processing-instruction()|comment()">
	  <xsl:copy>
	    <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()"/>
	  </xsl:copy>
	</xsl:template>

</xsl:stylesheet>

