<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="2.0"
	xmlns:saxon="http://saxon.sf.net/"
	xmlns:zenta="http://magwas.rulez.org/zenta"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes" omit-xml-declaration="yes"/>

	<xsl:template match="compliancecheck">
		<xsl:variable name="aspects_path" select="@aspects"/>
		<xsl:variable name="aspect_name" select="@aspect_name"/>
		<xsl:variable name="aspect_description" select="@aspect_description"/>
		<xsl:variable name="component_name" select="@component_name"/>
		<xsl:variable name="component_description" select="@component_description"/>
		<xsl:variable name="components_path" select="@components"/>
		<xsl:variable name="aspects">
			<xsl:for-each select="/">
				<xsl:copy-of select="saxon:evaluate($aspects_path)"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="components">
			<xsl:for-each select="/">
				<xsl:copy-of select="saxon:evaluate($components_path)"/>
			</xsl:for-each>
		</xsl:variable>
		<compliancegroup>
			<xsl:copy-of select="@title|@id"/>
			<xsl:attribute name="aspect_count" select="count($aspects/*)"/>
			<xsl:attribute name="component_count" select="count($components/*)"/>
			<xsl:for-each select="$aspects/*">
				<aspect>
					<xsl:variable name="aspectName" select="saxon:evaluate($aspect_name)"/>
					<xsl:variable name="aspectDescription" select="saxon:evaluate($aspect_description)"/>
					<xsl:attribute name="name" select="$aspectName"/>
					<description>
						<xsl:value-of select="$aspectDescription"/>
					</description>
					<xsl:for-each select="$components/*">
						<component>
							<xsl:variable name="componentName" select="saxon:evaluate($component_name)"/>
							<xsl:variable name="componentDescription" select="saxon:evaluate($component_description)"/>
							<xsl:variable name="baseName" select="concat($componentName,'.',$aspectName, '.report')"/>
							<xsl:variable name="fileName" select="concat('inputs/',$baseName)"/>
							<xsl:variable name="report" select="document($fileName)"/>
							<xsl:variable name="errors" select="$report//error"/>
							<xsl:attribute name="name" select="$componentName"/>
							<xsl:choose>
								<xsl:when test="exists($errors) or not(exists($report))">
									<xsl:attribute name="passed" select="'false'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="passed" select="'true'"/>
								</xsl:otherwise>
							</xsl:choose>
							<description>
								<xsl:value-of select="$componentDescription"/>
							</description>
							<errors>
								<xsl:copy-of select="$errors"/>
								<xsl:if test="not(exists($report))">
									<error>
										<xsl:attribute name="errorID" select="concat('nonexisting_',$baseName)"/>
										<xsl:attribute name="errorTitle" select="concat('No report for ',$componentName,'/',$aspectName)"/>
										<errorDescription>
											No report found for component
											<xsl:value-of select="concat($componentDescription, ' (', $componentName, ')')"/>, aspect
											<xsl:value-of select="concat($aspectDescription, ' (', $aspectName, ')')"/>. Expected filename:
											<xsl:value-of select="$fileName"/>
										</errorDescription>
									</error>
								</xsl:if>
							</errors>
						</component>
					</xsl:for-each>
				</aspect>
			</xsl:for-each>
		</compliancegroup>
	</xsl:template>

  <xsl:template match="/">
  	<compliance>
  		<xsl:apply-templates select="//compliancecheck"/>
  	</compliance>
  </xsl:template>

</xsl:stylesheet>

