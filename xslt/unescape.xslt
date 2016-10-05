<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:my="http://magwas.rulez.org/my"
	xmlns:structured="http://magwas.rulez.org/my"
	xmlns:zenta="http://magwas.rulez.org/zenta"
	xmlns:saxon="http://saxon.sf.net/"
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
	<xsl:variable name="escaped">
		<xsl:apply-templates select="*|@*|text()|processing-instruction()|comment()" mode="escapetag"/>
	</xsl:variable>
	<xsl:element name="{local-name()}">
	<xsl:call-template name="doc">
		<xsl:with-param name="str">
			<xsl:value-of select="$escaped"/>
		</xsl:with-param>
	</xsl:call-template>
	</xsl:element>
</xsl:template>

<xsl:template name="doc">
	<xsl:param name="str"/>
	<xsl:param name="level">0</xsl:param>
	<xsl:variable name="start" select="fn:substring-before($str,'&lt;')"/>
	<xsl:variable name="rest" select="fn:substring-after($str,'&lt;')"/>
	<xsl:variable name="fulltag" select="fn:substring-before($rest,'&gt;')"/>
	<xsl:variable name="tagparts" select="fn:tokenize($fulltag,'[  &#xA;]')"/>
	<xsl:variable name="ptag" select="$tagparts[1]"/>
	<xsl:variable name="tag" select="fn:replace($ptag,'^(.[^/]*)[/]*$','$1')"/>
	<xsl:variable name="aftertag" select="fn:substring-after($rest,'&gt;')"/>
	<xsl:variable name="intag" select="fn:substring-before($aftertag,fn:concat(fn:concat('&lt;/',$tag),'&gt;'))"/>
	<xsl:variable name="afterall" select="fn:substring-after($aftertag,fn:concat(fn:concat('&lt;/',$tag),'&gt;'))"/>
	<xsl:value-of select="$start"/>
	<xsl:choose>
	<xsl:when test="$tag">
		<xsl:variable name="currtag" select="$allowedtags/*[$tag = local-name()]"/>
		<xsl:if test="$currtag">
			<xsl:element name="{$currtag/local-name()}">
				<xsl:for-each select="$tagparts[position()>1]">
					<xsl:variable name="anstring" select="fn:replace(.,'^([^ &#xA;=]*)=.*$','$1')"/>
					<xsl:variable name="antag" select="$currtag/*[$anstring = local-name()]"/>
					<xsl:if test="$antag">
						<xsl:variable name="tagval" select="fn:replace(.,'^.*[^&#34;'']*[&#34;'']([^&#34;'']*)[&#34;''].*','$1')"/>
						<xsl:attribute name="{$antag/local-name()}">
							<xsl:value-of select="string($tagval)"/>
						</xsl:attribute>
					</xsl:if>
				</xsl:for-each>
				<xsl:if test="$intag">
					<xsl:call-template name="doc">
						<xsl:with-param name="str">
							<xsl:value-of select="$intag"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:if>
			</xsl:element>
		</xsl:if>
		<xsl:if test="$afterall">
			<xsl:call-template name="doc">
				<xsl:with-param name="str">
					<xsl:value-of select="$afterall"/>
				</xsl:with-param>
				<xsl:with-param name="level">
					<xsl:value-of select="$level + 1"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:when>
	<xsl:otherwise>
					<xsl:value-of select="$str"/>
	</xsl:otherwise>
	</xsl:choose>
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
