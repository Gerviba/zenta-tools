<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:archimate="http://www.archimatetool.com/archimate"
	xmlns:zenta="http://magwas.rulez.org/zenta"
	xmlns:saxon="http://saxon.sf.net/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>

	<xsl:template match="element[@xsi:type!='zenta:ZentaDiagramModel']"
		mode="elementDetails">
		<para>
			<xsl:value-of select="concat(zenta:capitalize(zenta:articledName(.,'any')),' is ', zenta:articledName(//element[@id=current()/@ancestor],'no'),'.')"/>
		</para>
		<para>
			<xsl:copy-of select="documentation/(*|text())"/>
		</para>
		<para>
		<xsl:if test="value">
			connections:
			<itemizedlist>
				<xsl:for-each select="value">
					<listitem>
						<xsl:variable name="atleast">
							<xsl:if test="number(@minOccurs) > 0">
								<xsl:value-of select="if (number(@minOccurs) > 0) then concat('at least ',@minOccurs,' ') else ''"/>
							</xsl:if>
						</xsl:variable>
						<xsl:variable name="atmost">
								<xsl:value-of select="if (number(@maxOccurs) > 0) then concat('at most ',@maxOccurs,' ') else '' "/>
						</xsl:variable>
						<xsl:variable name="numbers" select="if ($atmost!='' and $atleast!='') then concat($atleast,'and ',$atmost) else concat($atleast,$atmost)"/>
						<xsl:value-of select="../@name"/>
						<xsl:value-of select="concat(' ',
								zenta:relationName(.),' ',
								if (@template='true') then $numbers else ''
								)"/>
						<link linkend="{@target}">
							<xsl:value-of select="@name"/>
						</link>
					</listitem>
				</xsl:for-each>
			</itemizedlist>
		</xsl:if>
		</para>
	</xsl:template>

	<xsl:template match="connection[@name and @direction='1']"
		mode="elementDetails">
		<para>
			<xsl:value-of select="concat(zenta:capitalize(zenta:articledName(.,'any')),' is ', zenta:articledName(//connection[@id=current()/@ancestor and @direction='1'],'no'),'.')"/>
		</para>
		<para>
			<xsl:copy-of select="documentation/(*|text())"/>
		</para>
	</xsl:template>
</xsl:stylesheet>