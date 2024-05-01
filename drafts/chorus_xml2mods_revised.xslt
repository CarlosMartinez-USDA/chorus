<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:f="http://functions"
    exclude-result-prefixes="xd xs f xlink xsi">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xd:doc scope="stylesheet" id="chorus">
    <xd:desc><xd:p><xd:b>Created on: </xd:b>?</xd:p>
            <xd:p><xd:b>Authored by: </xd:b>?</xd:p>
            <xd:p><xd:b>Edited on: </xd:b>April 15, 2024</xd:p>
            <xd:p><xd:b>Edited by: </xd:b>Carlos Martinez III</xd:p>
            <xd:p><xd:i>chorus_xml2mods.xsl: </xd:i>CHORUS to MODS XML Transformation:</xd:p>
            <xd:p><xd:b>Change log:</xd:b></xd:p>
            <xd:ul>
                <xd:li><xd:p>Authors' name template tokenized for first ane last, substring-after for middleParts - 20240418 - cm3</xd:p></xd:li>
                <xd:li><xd:p>Collection processing added (currently commented out). - 20240418 - cm3</xd:p></xd:li>
                <xd:li><xd:p>Upgraded XSLT version to 2.0 - 20240418 - cm3</xd:p></xd:li>
                <xd:li><xd:p>Change log added. - 20240418 - cm3</xd:p></xd:li>
            </xd:ul>
    </xd:desc>
  </xd:doc>

    <xd:doc>
        <xd:desc>
            <xd:p><xd:b>Root template selects individual CHORUS XML.</xd:b></xd:p>
            <xd:p><xd:b>Uncomment collection processing lines when necessary.</xd:b></xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="/">
<!--         collection processsing -->
         <xsl:choose>
            <xsl:when test="count(all) != 1">
                <xsl:result-document href="{replace(base-uri(),'(.*/)(.*)(\.xml)', '$1')}N-{replace(base-uri(),'(.*/)(.*)(\.xml)', '$2')}_{position()}.xml">
                    <modsCollection xmlns="http://www.loc.gov/mods/v3"
                        xmlns:mods="http://www.loc.gov/mods/v3"
                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                        xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd">
                        <xsl:for-each select="//all">
                            <mods version="3.7">
                                <xsl:call-template name="item-info"/>
                            </mods>
                        </xsl:for-each>
                    </modsCollection>
                </xsl:result-document>
            </xsl:when>         
            <xsl:otherwise>
                <xsl:result-document
                    href="{replace(base-uri(),'(.*/)(.*)(\.xml)', '$1')}N-{replace(base-uri(),'(.*/)(.*)(\.xml)', '$2')}_{position()}.xml">
                    <mods xmlns="http://www.loc.gov/mods/v3" xmlns:mods="http://www.loc.gov/mods/v3"
                        xmlns:xlink="http://www.w3.org/1999/xlink"
                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="3.7"
                        xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd">
                        <xsl:for-each select="all">
                            <xsl:call-template name="item-info"/>
                        </xsl:for-each>
                    </mods>
                </xsl:result-document>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc><xd:desc>name item-info</xd:desc></xd:doc>
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
 <!-- 
    (1)Tokenize <author> element is parsed into <namePart> and <displayForm> elements.
    (2)Tokenization delimiter is a non-breaking-whitespace,and
      is split into the following nameParts:
        (a) $familyName = name-token[1] is the last name
        (b) $name-tokens[2] the first name
        (c) $given = concat($names-token[2] and everything after it.
    (3)This comment is for peer-review and should be removed afterwards.
    -->
    <xd:doc id="author" scope="component">
        <xd:desc>
            <xd:p><xd:b>name element</xd:b></xd:p>
            <xd:p><xd:b>namePart sub-element</xd:b></xd:p>
            <xd:ul>
                <xd:li><xd:p> $name-tokens[1] is the $familyName</xd:p></xd:li>
                <xd:li><xd:p> $name-tokens[2] is the first name, or part of the $givenName</xd:p></xd:li>
                <xd:li><xd:p> $givenName = combined $names-token[2] and the rest of the string after it.)</xd:p></xd:li></xd:ul>
        </xd:desc>
    </xd:doc>
    <xsl:template match="authors">
        <xsl:for-each select="item">
            <xsl:variable name="name-tokens" select="tokenize(author, ' ')"/>
            <xsl:variable name="last" select="$name-tokens[1]"/>
            <xsl:variable name="first" select="concat($name-tokens[2],' ',substring-after(author, $name-tokens[2]))"/>      
            <name type="personal">
                <xsl:if test="position() = 1">
                    <xsl:attribute name="usage">primary</xsl:attribute>
                </xsl:if>
                <namePart type="family">
                    <xsl:value-of select="$last"/>
                </namePart>
                <xsl:if test="matches($first,'[A-z]+\.?')"> <!-- add punctuation -->
                <xsl:variable name="givenName">
                    <xsl:sequence select="if (matches($first,'.*\s[A-Z]$'))
                                          then concat($first,'.')
                                          else $first"/>
                </xsl:variable>
                <namePart type="given">
                     <xsl:value-of select="$last"/>
                </namePart>
                <displayForm><xsl:value-of select="normalize-space(concat($last,', ',$first))"/></displayForm>          
                <role>
                    <roleTerm type="text">author</roleTerm>
                </role>
                <xsl:apply-templates select="affiliation"/>
                    <xsl:apply-templates select="orcid_profile[not(@type='null')]">
                        <xsl:with-param name="last" select="$last"/>
                        <xsl:with-param name="first" select="$first"/>
                    </xsl:apply-templates>
            </xsl:if>   
            </name>
        </xsl:for-each>
    </xsl:template>

    <xd:doc><xd:desc>match affiliation</xd:desc></xd:doc>
    <xsl:template match="affiliation">
        <xsl:if test="./text() != ''">
            <affiliation>
                <xsl:value-of select="."/>
            </affiliation>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="last"/>
        <xd:param name="first"/>
    </xd:doc>
    <xsl:template name="orcid">
        <xsl:param name="last"/>
        <xsl:param name="first"/>
        <xsl:if test="$last != '' and $first != ''">
            <xsl:for-each select="//all/orcid_profile/item">
              <xsl:if test="family[@type='str'] and family=$last and given=$first">
                <nameIdentifier>
                    <xsl:value-of select="ORCID"/>
                </nameIdentifier>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="orcid_profile[not(@type='null')]">
        <xsl:param name="last"/>
        <xsl:param name="first"/>
        <xsl:for-each select="//item[family=current()/$last]/node()">
           <xsl:copy-of select="ORCID"/>
        </xsl:for-each>
    </xsl:template>

    <xd:doc><xd:desc>name host</xd:desc></xd:doc>
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

    <xd:doc><xd:desc>match DOI</xd:desc></xd:doc>
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

    <xd:doc><xd:desc>match licenseUrl</xd:desc></xd:doc>
    <xsl:template match="licenseUrl">
        <xsl:if test="not(. = '')">
            <accessCondition type="use and reproduction" displayLabel="Resource is Open Access">
                <program>
                    <license_ref>http://purl.org/eprint/accessRights/OpenAccess</license_ref>
                </program>
            </accessCondition>
            <accessCondition type="use and reproduction" displayLabel="CHORUS License Information">
                <!-- <note type="namespace">The content of this element is structured with CrossRef's AccessIndicators schema: https://data.crossref.org/schemas/AccessIndicators.xsd</note>-->
                <!-- <note type="definitions"> "VOR" stands for "Version of Record," "AM" for "Accepted Manuscript," and "TDM" for "text and data mining." </note> -->
                <program xmlns="https://data.crossref.org/schemas/AccessIndicators.xsd">
                    <xsl:element name="license_ref">
                        <xsl:attribute name="applies_to">
                            <xsl:variable name="license_type"
                                select="/all/license_type[@type = 'str']"/>
                            <xsl:value-of select="$license_type"/>
                        </xsl:attribute>
                        <xsl:attribute name="start_date">
                            <xsl:variable name="access_date"
                                select="/all/publicly_accessible_on_publisher_site[@type = 'str']"/>
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="dateStr" select="$access_date"/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                    </xsl:element>
                    <xsl:element name="license_ref">
                        <xsl:attribute name="applies_to">reuse</xsl:attribute>
                        <xsl:attribute name="start_date">
                            <xsl:variable name="reuse_date"
                                select="/all/reuse_license_start_date[@type = 'str']"/>
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="dateStr" select="$reuse_date"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:element>
                </program>
            </accessCondition>
        </xsl:if>
    </xsl:template>

    <xd:doc><xd:desc>name originInfo</xd:desc></xd:doc>
    <xsl:template name="originInfo">
        <originInfo>
            <xsl:apply-templates select="published_print"/>
            <xsl:apply-templates select="published_online"/>
        </originInfo>
    </xsl:template>

    <xd:doc><xd:desc>match published_print</xd:desc></xd:doc>
    <xsl:template match="published_print">
        <xsl:if test="not(. = '')">
            <dateIssued encoding="w3cdtf" keyDate="yes">
                <xsl:call-template name="format-date">
                    <xsl:with-param name="dateStr" select="."/>
                </xsl:call-template>
            </dateIssued>
        </xsl:if>
    </xsl:template>

    <xd:doc><xd:desc>match published_online</xd:desc></xd:doc>
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

    <xd:doc>
        <xd:desc>format-date</xd:desc>
        <xd:param name="dateStr"/>
    </xd:doc>
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

    <xd:doc><xd:desc>name extension</xd:desc></xd:doc>
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

    <xd:doc><xd:desc>match agency_id</xd:desc></xd:doc>
    <xsl:template match="agency_id">
        <xsl:if test="not(. = '')">
            <note type="agency_id"><xsl:value-of select="."/></note>
        </xsl:if>
    </xsl:template>

    <xd:doc><xd:desc>match agency_name</xd:desc></xd:doc>
    <xsl:template match="agency_name">
        <xsl:if test="not(. = '')">
            <note type="agency_name"><xsl:value-of select="."/></note>
        </xsl:if>
    </xsl:template>

    <xd:doc><xd:desc>match breakdown_for</xd:desc></xd:doc>
    <xsl:template match="breakdown_for">
        <xsl:if test="not(. = '')">
            <note type="breakdown_for"><xsl:value-of select="."/></note>
        </xsl:if>
    </xsl:template>

    <xd:doc><xd:desc>match funders</xd:desc></xd:doc>
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

    <xd:doc><xd:desc>name recordInfo</xd:desc></xd:doc>
    <xsl:template name="recordInfo">
        <recordInfo>
            <recordCreationDate><xsl:value-of select="current-dateTime()"/></recordCreationDate>
            <recordOrigin><xsl:text>XML source generated via Python using CHORUS API JSON data; converted to MODS with chorus_to_mods.xsl</xsl:text></recordOrigin>
        </recordInfo>
    </xsl:template>

</xsl:stylesheet>
