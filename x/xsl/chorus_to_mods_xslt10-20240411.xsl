<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns="http://www.loc.gov/mods/v3" 
    xmlns:xlink="http://www.w3.org/1999/xlink" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    xmlns:f="http://functions" 
    xmlns:ex="http://exslt.org/dates-and-times" 
    xmlns:func="http://exslt.org/functions" 
    xmlns:exsl="http://exslt.org/common" 
    xmlns:str="http://exslt.org/strings" 
    extension-element-prefixes="ex" 
    exclude-result-prefixes="xd xs f xlink xsi ex str func exsl">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:include href="commons/1.0/str.tokenize.function.xsl"/>
    
    <xsl:template match="/">
        <modsCollection>
            <xsl:for-each select="all/items/item">
                <mods xmlns="http://www.loc.gov/mods/v3" 
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="3.7" 
                    xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd" 
                    xmlns:xlink="http://www.w3.org/1999/xlink">
                    
                    <xsl:call-template name="item-info"/>
                    
                </mods>
            </xsl:for-each>
        </modsCollection>
    </xsl:template>
    
    <xsl:template name="item-info">
        <titleInfo>
            <title>
                <xsl:value-of select="title"/>
            </title>
        </titleInfo>
        
        <xsl:apply-templates select="authors"/>
        
        <typeOfResource>text</typeOfResource>
        <genre>article</genre>
        
        <xsl:call-template name="license-info"/>
        <xsl:call-template name="originInfo"/>
        <xsl:call-template name="host"/>        
        <xsl:apply-templates select="DOI"/>        
        <xsl:call-template name="extension"/>        
        <xsl:call-template name="recordInfo"/>
    </xsl:template>
    
    <xsl:template match="authors">
        <xsl:for-each select="item">
            <xsl:variable name="name-tokens" select="str:tokenize(author, ' ')"/>
            <xsl:variable name="given" select="normalize-space(substring-after(author, $name-tokens[1]))"/>
            <name type="personal">
                <xsl:if test="position() = 1">
                    <xsl:attribute name="usage">primary</xsl:attribute>
                </xsl:if>
                <namePart type="family">
                    <xsl:value-of select="$name-tokens[1]"/>
                </namePart>
                <namePart type="given">
                    <xsl:value-of select="$given"/>
                </namePart>
                <displayForm><xsl:value-of select="normalize-space($name-tokens[1])"/>, <xsl:value-of select="$given"/></displayForm>
                <role>
                    <roleTerm type="text">author</roleTerm>
                </role>
                <xsl:apply-templates select="affiliation"/>
            </name>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="affiliation">
        <xsl:if test="./text() != ''">
            <affiliation><xsl:value-of select="."/></affiliation>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="host">
        <relatedItem type="host">
            <titleInfo>
                <title>
                    <xsl:value-of select="journal_name"/>
                </title>
            </titleInfo>
            <originInfo>
                <publisher>
                    <xsl:value-of select="publisher"/>
                </publisher>
            </originInfo>
        </relatedItem>
    </xsl:template>
    
    
    <xsl:template match="DOI">
        <identifier type="doi">
            <xsl:value-of select="."/>
        </identifier>
        <identifier type="chorus">
            <xsl:value-of select="."/>
        </identifier>
        <location>
            <url displayLabel="Available from publisher's site">
                <xsl:value-of select="concat('https://dx.doi.org/', .)"/>
            </url>
        </location>
    </xsl:template>
    
    <xsl:template name="originInfo">
        <originInfo>
            <xsl:apply-templates select="published_print"/>
            <xsl:apply-templates select="published_online"/>
        </originInfo>
    </xsl:template>
    
    <xsl:template match="published_print">
        <xsl:if test="not(. = '')">
            <dateIssued encoding="w3cdtf" keyDate="yes">
                <xsl:call-template name="format-date">
                    <xsl:with-param name="dateStr" select="."/>
                </xsl:call-template>
            </dateIssued>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="published_online[not(../published_print)]">
        <xsl:if test="not(. = '')">
            <dateIssued encoding="w3cdtf" keyDate="yes">
                <xsl:call-template name="format-date">
                    <xsl:with-param name="dateStr" select="."/>
                </xsl:call-template>
            </dateIssued>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="published_online[../published_print]">
        <xsl:if test="not(. = '')">
            <dateOther encoding="w3cdtf" type="electronic">
                <xsl:call-template name="format-date">
                    <xsl:with-param name="dateStr" select="."/>
                </xsl:call-template>
            </dateOther>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="format-date">
        <xsl:param name="dateStr"/>
        <xsl:if test="not($dateStr = '')">
            <xsl:variable name="date-tokens" select="str:tokenize($dateStr, '/')"/>
            <xsl:choose>
                <xsl:when test="$date-tokens[3]">
                    <xsl:value-of select="
                        concat(
                        $date-tokens[last()], '-',
                        format-number($date-tokens[1], '00'), '-',
                        format-number($date-tokens[2], '00'))
                        "/>
                </xsl:when>
                <xsl:when test="$date-tokens[2]">
                    <xsl:value-of select="
                        concat(
                        $date-tokens[last()], '-',
                        format-number($date-tokens[1], '00'))
                        "/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$dateStr"/>
                </xsl:otherwise>
            </xsl:choose>            
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="license-info">
        <xsl:variable name="license-date">
            <xsl:call-template name="format-date">
                <xsl:with-param name="dateStr">
                    <xsl:value-of select="publicly_accessible_on_publisher_site"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="reuse-date">
            <xsl:call-template name="format-date">
                <xsl:with-param name="dateStr">
                    <xsl:value-of select="reuse_license_start_date"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        
        <accessCondition type="use and reproduction" displayLabel="CHORUS License Information">
            <note type="namespace">The content of this element is structured with CrossRef's AccessIndicators schema: https://data.crossref.org/schemas/AccessIndicators.xsd</note>
            <note type="definitions"> "VOR" stands for "Version of Record," "AM" for "Accepted Manuscript," and "TDM" for "text and data mining." </note>
            <program name="CHORUS">
                <free_to_read>
                    <xsl:attribute name="start-date">
                        <xsl:value-of select="$license-date"/>
                    </xsl:attribute>
                </free_to_read>
                <license_ref>
                    <xsl:attribute name="applies_to">
                        <xsl:value-of select="license_type"/>
                    </xsl:attribute>
                    <xsl:attribute name="start_date">
                        <xsl:value-of select="$license-date"/>
                    </xsl:attribute>
                    <xsl:value-of select="licenseUrl"/>
                </license_ref>
                <license_ref applies_to="reuse">
                    <xsl:attribute name="start_date">
                        <xsl:value-of select="$reuse-date"/>
                    </xsl:attribute>
                </license_ref>
            </program>
        </accessCondition>
        <accessCondition type="restriction on access"
            xlink:href="http://purl.org/eprint/accessRights/OpenAccess" displayLabel="Access Status">Open Access</accessCondition>
    </xsl:template>
    
    
    <xsl:template name="extension">
        <extension>
            <vendorName>CHORUS</vendorName>
            <workingDirectory>/data/metadata/staging/chorus</workingDirectory>
            <note type="agency_id">
                <xsl:value-of select="/all/agency_id"/>
            </note>
            <note type="agency_name">
                <xsl:value-of select="/all/agency_name"/>
            </note>
            <note type="breakdown_for"><xsl:value-of select="/breakdown_for"/></note>
            <xsl:apply-templates select="funders/item"/>            
        </extension>
    </xsl:template>
    
    <xsl:template match="funders/item">
        <funding-group>
            <award-group>
                <funding-source>
                    <name-content content-type="funder-name">
                        <xsl:value-of select="."/>
                    </name-content>
                </funding-source>
            </award-group>
        </funding-group>
    </xsl:template>
    
    <xsl:template name="recordInfo">
        <recordInfo>            
            <recordCreationDate><xsl:value-of  select="ex:date-time()"/></recordCreationDate>
            <recordOrigin>XML source generated via Python using CHORUS API JSON data; converted to MODS with chorus_to_mods.xsl</recordOrigin>
        </recordInfo>
    </xsl:template>
    
</xsl:stylesheet>