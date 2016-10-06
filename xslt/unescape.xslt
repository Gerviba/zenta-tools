<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:my="http://magwas.rulez.org/my"
	xmlns:structured="http://magwas.rulez.org/my"
	xmlns:zenta="http://magwas.rulez.org/zenta"
	xmlns:saxon="http://saxon.sf.net/"
	xmlns:zentatools="java:org.rulez.magwas.zentatools.XPathFunctions"
>
<xsl:param name="escapemode">unescape</xsl:param>

<xsl:include href="xslt/functions.xslt"/>

<xsl:variable name="allowedtags">
<xpath/>
<b/><i/><u/><del/>
<a><class/><href/></a>
<itemizedlist/>
<listitem/>
<variablelist/>
<varlistentry/>
<term/>
<para/>
<li/>
<ul/>
<ol><type/></ol>
<br/>
<p/>
<only><role/></only>
<include><file/></include>
<div><class/></div>
<table><class/></table>
<tr><class/></tr>
<th><class/></th>
<td><class/></td>
</xsl:variable>


<xsl:template match="/" priority="-3">
	<xsl:variable name="doc_with_tags">
		<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="unescape"/>
	</xsl:variable>
	<xsl:for-each select="$doc_with_tags">
		<xsl:apply-templates select="*|text()|processing-instruction()|comment()" mode="applyxpath"/>		
	</xsl:for-each>
</xsl:template>

<xsl:template match="@*|*|processing-instruction()|comment()" mode="escape unescape escapetag applyxpath">
	<xsl:copy>
		<xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()" mode="#current"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="xpath" mode="applyxpath">
	<xsl:variable name="expr" select="."/>
	<xsl:variable name="id" select="ancestor::element/@id"/>
	<xsl:for-each select="//element[@id=$id]">
		<xsl:copy-of select="saxon:evaluate($expr)"/>
	</xsl:for-each>
</xsl:template>

<xsl:template match="element" mode="unescape">
	<xsl:copy>
		<xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()" mode="#current"/>
		<xsl:if test="not(documentation)">
			<xsl:apply-templates select="//element[@id=current()/@ancestor]/documentation" mode="unescape"/>
		</xsl:if>
	</xsl:copy>
</xsl:template>

<xsl:template match="documentation|purpose" mode="escape">
	<xsl:element name="{local-name()}">
		<xsl:apply-templates mode="escapedoc"/>
	</xsl:element>
</xsl:template>

<xsl:template match="documentation|purpose" mode="unescape">
	<xsl:copy>
		<xsl:message>before</xsl:message>
		<xsl:message select="."/>
		<xsl:copy-of select="zentatools:unescape(.)/root/(*|@*|text()|processing-instruction()|comment())"/>
		<xsl:message>after</xsl:message>
	</xsl:copy>
</xsl:template>


    <xsl:template match="*" mode="escapedoc escapetag" priority="1">
        <!-- Begin opening tag -->
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="name()"/>

        <!-- Attributes -->
        <xsl:for-each select="@*">
            <xsl:text> </xsl:text>
            <xsl:value-of select="name()"/>
            <xsl:text>='</xsl:text>
            <xsl:call-template name="escape-xml">
                <xsl:with-param name="text" select="."/>
            </xsl:call-template>
            <xsl:text>'</xsl:text>
        </xsl:for-each>

        <!-- End opening tag -->
        <xsl:text>&gt;</xsl:text>

        <!-- Content (child elements, text nodes, and PIs) -->
        <xsl:apply-templates select="node()" mode="#current" />

        <!-- Closing tag -->
        <xsl:text>&lt;/</xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:text>&gt;</xsl:text>
    </xsl:template>

    <xsl:template match="text()" mode="escapedoc">
        <xsl:call-template name="escape-xml">
            <xsl:with-param name="text" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="processing-instruction()" mode="escapedoc">
        <xsl:text>&lt;?</xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:text> </xsl:text>
        <xsl:call-template name="escape-xml">
            <xsl:with-param name="text" select="."/>
        </xsl:call-template>
        <xsl:text>?&gt;</xsl:text>
    </xsl:template>

    <xsl:template name="escape-xml">
        <xsl:param name="text"/>
        <xsl:if test="$text != ''">
            <xsl:variable name="head" select="substring($text, 1, 1)"/>
            <xsl:variable name="tail" select="substring($text, 2)"/>
									<xsl:value-of select="$head"/>
            <xsl:call-template name="escape-xml">
                <xsl:with-param name="text" select="$tail"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
