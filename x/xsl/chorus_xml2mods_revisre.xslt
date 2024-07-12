<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.loc.gov/mods/v3"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:f="http://functions"
    exclude-result-prefixes="xd xs f xlink xsi">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    
    <xsl:template match="/">
        <!--        <modsCollection>-->
        <!--            <xsl:for-each select="all/items/item">-->
        <!--                <mods xmlns="http://www.loc.gov/mods/v3"-->
        <!--                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="3.7"-->
        <!--                    xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd"-->
        <!--                    xmlns:xlink="http://www.w3.org/1999/xlink">-->
        
        <!--                    <xsl:call-template name="item-info"/>-->
        
        <!--                </mods>-->
        <!--            </xsl:for-each>-->
        <!--        </modsCollection>-->
        <xsl:for-each select="all">
            <xsl:result-document href="{replace(base-uri(),'(.*/)(.*)(\.xml)', '$1')}N-{replace(base-uri(),'(.*/)(.*)(\.xml)', '$2')}_{position()}.xml">
            <mods xmlns="http://www.loc.gov/mods/v3"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="3.7"
                xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd"
                xmlns:xlink="http://www.w3.org/1999/xlink">
                
                <xsl:call-template name="item-info"/>
            </mods>
            </xsl:result-document>
        </xsl:for-each>
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
        <xsl:call-template name="originInfo"/>
        <xsl:call-template name="host"/>
        <xsl:apply-templates select="DOI"/>
        <xsl:apply-templates select="licenseUrl"/>
        <xsl:call-template name="extension"/>
        <xsl:call-template name="recordInfo"/>
    </xsl:template>
    <xsl:template match="author">
        <xsl:analyze-string select="." regex="^(\w+)?\s(\w+)(\s[A-Z])?$">
            <xsl:matching-substring>              
                    <xsl:variable name="lastName" select="regex-group(1)"/>
                    <xsl:variable name="firstName">
                        <xsl:sequence select="if (regex-group(3)!='')
                            then concat(regex-group(2), regex-group(3),'.')
                            else regex-group(2)"/>
                    
                    </xsl:variable>
                    <xsl:if test="position()=1">
                        <xsl:attribute name="usage">primary</xsl:attribute>
                    </xsl:if>
                    <namePart type="family">
                       <xsl:value-of select="$lastName"/>
                    </namePart>
                    <namePart type="given">
                        <xsl:value-of select="$firstName"></xsl:value-of>
                    </namePart>
                    <displayForm>
                        <xsl:value-of select="concat($lastName,',&#xa0;', $firstName)"/>
                    </displayForm>
                
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    <xsl:template match="authors">
        <xsl:for-each select="item">
            <xsl:variable name="name-tokens" select="tokenize(author,'&#xa0;')"/>
            <xsl:variable name="given" select="normalize-space(substring-after(author, $name-tokens[1]))"/> 
            <xsl:variable name="last" select="$name-tokens[1]"/>
            <xsl:variable name="first" select="$name-tokens[2]"/>
           <!-- <name type="personal">
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
                
                <namePart><xsl:value-of select="author"/></namePart>-\\->
            
           -->
            <name type="personal">
            <xsl:apply-templates select="author"/>
           
            <role>
                    <roleTerm type="text">author</roleTerm>
                </role>
                <xsl:apply-templates select="affiliation"/>
                <xsl:call-template name="orcid">
                    <xsl:with-param name="first" select="$first"/>
                    <xsl:with-param name="last" select="$last"/>
                </xsl:call-template>
            </name>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="affiliation">
        <xsl:if test="./text() != ''">
            <affiliation><xsl:value-of select="."/></affiliation>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="orcid">
        <xsl:param name="last"/>
        <xsl:param name="first"/>
        <xsl:if test="not($last = '' and $first = '')">
            <xsl:for-each select="/all/orcid_profile/item">
                <xsl:if test="family[@type='str'] and family=$last and given=$first">
                    <nameIdentifier><xsl:value-of select="ORCID"/></nameIdentifier>
                </xsl:if>
            </xsl:for-each>
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
    
    <xsl:template match="licenseUrl">
        <xsl:if test="not(. = '')">
            <accessCondition type="use and reproduction" displayLabel="Resource is Open Access">
                <program>
                    <license_ref>http://purl.org/eprint/accessRights/OpenAccess</license_ref>
                </program>
            </accessCondition>
            <accessCondition type="use and reproduction" displayLabel="CHORUS License Information">
                <program xmlns="https://data.crossref.org/schemas/AccessIndicators.xsd">
                    <xsl:element name="license_ref">
                        <xsl:attribute name="applies_to">
                            <xsl:variable name="license_type" select="/all/license_type[@type='str']" />
                            <xsl:value-of select="$license_type"/>
                        </xsl:attribute>
                        <xsl:attribute name="start_date">
                            <xsl:variable name="access_date" select="/all/publicly_accessible_on_publisher_site[@type='str']" />
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="dateStr" select="$access_date"/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                    </xsl:element>
                    <xsl:element name="license_ref">
                        <xsl:attribute name="applies_to">reuse</xsl:attribute>
                        <xsl:attribute name="start_date">
                            <xsl:variable name="reuse_date" select="/all/reuse_license_start_date[@type='str']" />
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="dateStr" select="$reuse_date"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:element>
                </program>
            </accessCondition>
        </xsl:if>
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
    
    <xsl:template match="published_online">
        <xsl:variable name="print" select="/all/published_print"/>
        <xsl:choose>
            <xsl:when test="not(. = '') and ($print = '')">
                <dateIssued encoding="w3cdtf" keyDate="yes">
                    <xsl:call-template name="format-date">
                        <xsl:with-param name="dateStr" select="."/>
                    </xsl:call-template>
                </dateIssued>
            </xsl:when>
            <xsl:when test="not(. = '') and not($print = '')">
                <dateOther encoding="w3cdtf" type="electronic">
                    <xsl:call-template name="format-date">
                        <xsl:with-param name="dateStr" select="."/>
                    </xsl:call-template>
                </dateOther>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="format-date">
        <xsl:param name="dateStr"/>
        <xsl:if test="not($dateStr = '')">
            <xsl:variable name="date-tokens" select="tokenize($dateStr, '/')"/>
            <xsl:choose>
                <xsl:when test="$date-tokens[3]">
                    <xsl:value-of select="
                        concat(
                        $date-tokens[last()], '-',
                        format-number(number($date-tokens[1]), '00'), '-',
                        format-number(number($date-tokens[2]), '00'))
                        "/>
                </xsl:when>
                <xsl:when test="$date-tokens[2]">
                    <xsl:value-of select="
                        concat(
                        $date-tokens[last()], '-',
                        format-number(number($date-tokens[1]), '00'))
                        "/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$dateStr"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="extension">
        <extension>
            <vendorName>CHORUS</vendorName>
            <workingDirectory>/data/metadata/staging/chorus</workingDirectory>
            <xsl:apply-templates select="agency_id"/>
            <xsl:apply-templates select="agency_name"/>
            <xsl:apply-templates select="breakdown_for"/>
            <xsl:apply-templates select="funders"/>
        </extension>
    </xsl:template>
    
    <xsl:template match="agency_id">
        <xsl:if test="not(. = '')">
            <note type="agency_id">
                <xsl:value-of select="."/>
            </note>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="agency_name">
        <xsl:if test="not(. = '')">
            <note type="agency_name">
                <xsl:value-of select="."/>
            </note>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="breakdown_for">
        <xsl:if test="not(. = '')">
            <note type="breakdown_for">
                <xsl:value-of select="."/>
            </note>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="funders">
        <funding-group specific-use="crossref">
            <xsl:for-each select="item">
                <award-group>
                    <funding-source>
                        <institution-wrap>
                            <institution>
                                <xsl:value-of select="."/>
                            </institution>
                        </institution-wrap>
                    </funding-source>
                </award-group>
            </xsl:for-each>
        </funding-group>
    </xsl:template>
    
    <xsl:template name="recordInfo">
        <recordInfo>
            <recordCreationDate><xsl:value-of  select="current-dateTime()"/></recordCreationDate>
            <recordOrigin>XML source generated via Python using CHORUS API JSON data; converted to MODS with chorus_to_mods.xsl</recordOrigin>
        </recordInfo>
    </xsl:template>
    
</xsl:stylesheet>