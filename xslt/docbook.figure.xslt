<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xmlns:archimate="http://www.archimatetool.com/archimate"
   xmlns:zenta="http://magwas.rulez.org/zenta"
   xmlns:saxon="http://saxon.sf.net/"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>

	<!--xsl:template match="element[@xsi:type='zenta:ZentaDiagramModel']" mode="figure">
		<figure>
			<title><xsl:value-of select="@name"/></title>
			<remark><xsl:copy-of select="documentation/(*|text())"/></remark>
			<mediaobject><imageobject><imagedata fileref="pics/{@id}.png"/></imageobject></mediaobject>
		</figure>
	</xsl:template-->

	<xsl:template match="element[@xsi:type='zenta:ZentaDiagramModel']" mode="figure">
		<figure>
			<title><xsl:value-of select="@name"/></title>
			<remark><xsl:copy-of select="documentation/(*|text())"/></remark>
			<mediaobjectco>
				<imageobjectco>
					<areaspec id="{@id}_map">
						<xsl:variable name="xmin" select="min(.//child/bounds/@x)"/>
						<xsl:variable name="ymin" select="min(.//child/bounds/@y)"/>
						<xsl:for-each select=".//child">
							<area units="other" otherunits="imagemap">
								<xsl:attribute name="id" select="@id"/>
								<xsl:attribute name="linkends" select="@zentaElement"/>
								<xsl:attribute name="coords" select="concat(
									bounds/@x+1-$xmin,',',
									bounds/@y+1-$ymin,',',
									(if(bounds/@width = -1 or not(exists(bounds/@width))) then 120 else bounds/@width)+bounds/@x+1-$xmin,',',
									(if(bounds/@height = -1 or not(exists(bounds/@height))) then 53 else bounds/@height)+bounds/@y+1-$ymin
								)
								"/>
							</area>
						</xsl:for-each>
					</areaspec>
					<imageobject>
						<imagedata fileref="pics/{@id}.png"/>
					</imageobject>
				</imageobjectco>
			</mediaobjectco>
		</figure>
	</xsl:template>
</xsl:stylesheet>