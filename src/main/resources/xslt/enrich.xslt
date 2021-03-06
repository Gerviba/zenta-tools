<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:zenta="http://magwas.rulez.org/zenta"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>
	
	<xsl:include href="xslt/functions.xslt"/>

	<xsl:template match="zenta:model" mode="enrich">
		<xsl:variable name="changetypeResult">
			<xsl:apply-templates select="." mode="changetype"/>
		</xsl:variable>
		<xsl:variable name="enrich1Result">
		<xsl:apply-templates select="$changetypeResult" mode="enrich_run1"/>
		</xsl:variable>
		<xsl:apply-templates select="$enrich1Result" mode="enrich_run2"/>
	</xsl:template>
	
	<xsl:template match="zenta:model" mode="changetype">
		<zenta:enriched>
	    <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()" mode="changetype"/>
		</zenta:enriched>
	</xsl:template>

	<xsl:template match="@xsi:type" mode="changetype">
		<xsl:attribute name="xsi:type" select="
			if(current()/../@ancestor)
			then
				//element[@id=current()/../@ancestor]/@name
			else
				."/>
	</xsl:template>

	<xsl:function name="zenta:isTemplate">
		<xsl:param name="doc"/>
		<xsl:param name="element"/>
		<xsl:value-of select="$doc//element[property/@key='Template']//child/@zentaElement=$element/@id"/>
	</xsl:function>

	<xsl:template match="element" mode="changetype">
		<xsl:copy>
			<xsl:attribute name="template" select="zenta:isTemplate(/,.)"/>
		    <xsl:apply-templates select="@*|*|text()|processing-instruction()|comment()" mode="changetype"/>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="connection" mode="createValue">
		<value>
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="name" select="//element[@id=current()/@target]/@name"/>
		</value>
	</xsl:template>

	<xsl:template match="element" mode="createValue">
		<xsl:variable name="element" select="."/>
		<xsl:variable name="doc" select="/"/>		
		<xsl:variable name="definingRelations" select="zenta:getDefiningRelations($element,/)"/>
		<xsl:choose>
			<xsl:when test="$element/@template='true'">
				<xsl:for-each select="//connection[@source=current()/@id]">
					<xsl:apply-templates  select="." mode="createValue"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$definingRelations">
					<xsl:variable name="relations" select="$doc//connection[@source=$element/@id and @ancestor=current()/@id and @direction=current()/@direction]"/>
					<xsl:if test="$element/@template='false'">
						<xsl:copy-of select="zenta:checkRelationCount($element,.,$doc)"/>
					</xsl:if>
					<xsl:for-each select="$relations">
						<xsl:apply-templates select="." mode="createValue" />
					</xsl:for-each>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="element" mode="enrich_run2">
	  <xsl:copy>
	    <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()" mode="#current"/>
	    <xsl:apply-templates select="." mode="createValue"/>
	  </xsl:copy>
	</xsl:template>

	<xsl:template match="element[@source]" mode="enrich_run1">
		<xsl:copy-of select="zenta:buildConnection(.,1,/)"/>
		<xsl:copy-of select="zenta:buildConnection(.,2,/)"/>
	</xsl:template>

	<xsl:template match="@*|*|processing-instruction()|comment()" mode="#all">
	  <xsl:copy>
	    <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()" mode="#current"/>
	  </xsl:copy>
	</xsl:template>

</xsl:stylesheet>

