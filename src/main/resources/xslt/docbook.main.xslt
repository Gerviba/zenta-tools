<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xmlns:archimate="http://www.archimatetool.com/archimate"
   xmlns:zenta="http://magwas.rulez.org/zenta"
   xmlns:saxon="http://saxon.sf.net/"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:param name="inconsistencyfile"/>
	<xsl:variable name="inconsistencies" select="document($inconsistencyfile)"/>
	<xsl:variable name="doc" select="/"/>

	<xsl:template match="zenta:enriched" mode="#all">
		<article version="5.0">
	    	<xsl:apply-templates select="*" mode="#current">
	    		<xsl:sort select="@name"/>
	    	</xsl:apply-templates>
	    	<section>
	    		<title>Deviations</title>
	    		<xsl:apply-templates select="$inconsistencies//data" mode="deviations"/>
	    	</section>
		</article>
	</xsl:template>

	<xsl:template match="@*|*|processing-instruction()|comment()" mode="#all">
	  <xsl:copy>
	    <xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()" mode="#current"/>
	  </xsl:copy>
	</xsl:template>

</xsl:stylesheet>

