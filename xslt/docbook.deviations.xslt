<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:archimate="http://www.archimatetool.com/archimate"
	xmlns:zenta="http://magwas.rulez.org/zenta"
	xmlns:saxon="http://saxon.sf.net/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>

	<xsl:template match="issue"	mode="deviations">
		<para>
			related issue:
			<ulink url="{@url}">
				<xsl:value-of select="summary"/>
			</ulink>
			status:
			<xsl:value-of select="@status"/>
		</para>
	</xsl:template>

	<xsl:template match="entry" mode="deviations">
		<varlistentry>
			<term>
				<anchor><xsl:attribute name="id" select="@errorID"/></anchor>
				<xsl:value-of select="saxon:evaluate(
					../../check/@errortitlestring,
					.,
					$doc)"/>
				<ulink url="#{@errorID}">.</ulink>
			</term>
			<listitem>
				<para>
					<xsl:copy-of select="saxon:evaluate(
						../../check/@errordescription,
						.,
						$doc)"/>
				</para>
				<xsl:copy-of select="zenta:errorIssue(.,$issues)"/>
			</listitem>
		</varlistentry>
	</xsl:template>

	<xsl:template match="data" mode="deviations">
   			<section>
   				<title><xsl:value-of select="check/@title"/></title>
   				<xsl:choose>
    				<xsl:when test="onlyinput/entry|onlymodel/entry">
		    			<variablelist>
			    			<xsl:apply-templates select="onlyinput/entry|onlymodel/entry" mode="deviations"/>
		    			</variablelist>
		    		</xsl:when>
		    		<xsl:otherwise>
		    			<para>No deviations in this section.</para>
		    		</xsl:otherwise>
	    		</xsl:choose>
   			</section>
	</xsl:template>
</xsl:stylesheet>
