<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.loc.gov/mods/v3" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:f="http://functions" xmlns:saxon="http://saxon.sf.net/" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="f saxon mods xd xlink xs xsi">
    <xsl:output method="xml" indent="yes" encoding="UTF-8" saxon:next-in-chain="fix_characters.xsl"/>
    <xsl:output method="xml" indent="yes" encoding="UTF-8" name="archive-original"/>
    <xsl:include href="commons/params.xsl"/>     
 
    <xd:doc scope="stylesheet" id="chorus">
        <xd:desc><xd:p><xd:b>CHORUS to MODS XML Transformation:</xd:b></xd:p>
            <xd:p><xd:b>Created on: </xd:b>?</xd:p>
            <xd:p><xd:b>Authored by: </xd:b>?</xd:p>
            <xd:p><xd:b>Edited on: </xd:b>May 9, 2024</xd:p>
            <xd:p><xd:b>Edited by: </xd:b>Carlos Martinez III</xd:p>
            <xd:p><xd:b>Filename: </xd:b><xd:i>chorus_to_mods.xsl</xd:i></xd:p>
            <xd:p><xd:b>Change log:</xd:b></xd:p>
            <xd:ul>
                <xd:li><xd:p>Changed outputs for production server - 20240509 - cm3</xd:p></xd:li>
                <xd:li><xd:p>Funders template adds &lt;institution_id @type='doi'&gt;. - 20240430 - cm3</xd:p></xd:li>
                <xd:li><xd:p>Added a-file output. - 20240430 - cm3</xd:p></xd:li>
                <xd:li><xd:p>Authors' name template tokenized for first ane last, substring-after for middleParts. - 20240418 - cm3</xd:p></xd:li>
                <xd:li><xd:p>Collection processing added (currently commented out). - 20240418 - cm3</xd:p></xd:li>
                <xd:li><xd:p>Upgraded XSLT version to 2.0. - 20240418 - cm3</xd:p></xd:li>
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
        <!-- archive -->
        <xsl:result-document href="file:///{$workingDir}A-{replace($originalFilename, '(.*/)(.*)(\.xml)', '$2')}_{position()}.xml" format="archive-original">            
            <xsl:copy-of select="." copy-namespaces="no"/>           
        </xsl:result-document>
        <!-- mods-->
        <xsl:choose>
            <xsl:when test="count(all) != 1">
                <modsCollection xmlns="http://www.loc.gov/mods/v3" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd">
                    <xsl:for-each select="//all">
                        <mods version="3.7">
                            <xsl:call-template name="item-info"/>
                        </mods>
                    </xsl:for-each>
                </modsCollection>
            </xsl:when>
      <xsl:otherwise>
        <mods version="3.7">
            <xsl:for-each select="all">
                <xsl:call-template name="item-info"/>
            </xsl:for-each>
        </mods>
      </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xd:doc><xd:desc>item-info</xd:desc></xd:doc>
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
 
    <xd:doc id="author" scope="component">
        <xd:desc>
            <xd:p><xd:b>(1)</xd:b> Tokenize &lt;author&gt;. Set non-breaking-whitespace as tokenizationdelimiter.</xd:p>
            <xd:p><xd:b>(2)</xd:b> Element is parsed into &lt;namePart&gt; and &lt;displayForm&gt; elements. </xd:p>
            <xd:p><xd:b>(3)</xd:b> The delimiter splits each name component into the following nameParts:</xd:p>
            <xd:ul>
                <xd:li><xd:p><xd:b>a.</xd:b> $name-tokens[1] is the $familyName</xd:p></xd:li>
                <xd:li><xd:p><xd:b>b.</xd:b> $name-tokens[2] is the first name, or part of the $givenName</xd:p></xd:li>
                <xd:li><xd:p><xd:b>c.</xd:b> $givenName = combined $names-token[2] and the rest of the string after it.)</xd:p></xd:li>
            </xd:ul>
        </xd:desc>
    </xd:doc>
    <xsl:template match="authors">
        <xsl:for-each select="item">
            <xsl:variable name="name-tokens" select="tokenize(author, ' ')"/>
            <xsl:variable name="familyName" select="$name-tokens[1]"/>
            <xsl:variable name="firstMiddle" select="concat($name-tokens[2],substring-after(author, $name-tokens[2]))"/>      
            <name type="personal">
                <xsl:if test="position() = 1">
                    <xsl:attribute name="usage">primary</xsl:attribute>
                </xsl:if>
                <namePart type="family">
                    <xsl:value-of select="$familyName"/>
                </namePart>
                <xsl:if test="matches($firstMiddle,'[A-z]+\.?')"> <!-- add punctuation -->
                <xsl:variable name="givenName">  
                    <xsl:sequence select="if (matches($firstMiddle,'^.*\s[A-Z]$') and not(ends-with($firstMiddle,'.')))
                                          then concat($firstMiddle,'.')
                                          else $firstMiddle"/>
                </xsl:variable>
                <namePart type="given">
                     <xsl:value-of select="normalize-space($givenName)"/>
                </namePart>
                    <displayForm><xsl:value-of select="normalize-space(concat($familyName,',&#xa0;',$givenName))"/></displayForm>
                    <xsl:apply-templates select="affiliation"/>
                <role>
                    <roleTerm type="text">author</roleTerm>
                </role>
                <xsl:call-template name="orcid">
                    <xsl:with-param name="first" select="$firstMiddle"/>
                    <xsl:with-param name="last" select="$familyName"/>
                </xsl:call-template>
                </xsl:if>   
            </name>
        </xsl:for-each>
    </xsl:template>
    
    <xd:doc><xd:desc>affiliation</xd:desc></xd:doc>
    <xsl:template match="affiliation">
        <xsl:if test="./text() != ''">
            <affiliation>
                <xsl:choose>
                    <xsl:when test="starts-with(., 'From')">
                        <xsl:value-of select="replace(.,'(From\s)(the )?(.*)','$3')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </affiliation>
        </xsl:if>
    </xsl:template>

    <xd:doc>
    <xd:desc>
        <xd:p>orcid</xd:p>
        <xd:p>updated 20240418
        added for-each and conditional XPath</xd:p>
    </xd:desc>
    <xd:param name="last"/>
    <xd:param name="first"/>
    </xd:doc>
    <xsl:template name="orcid">
        <xsl:param name="last"/>
        <xsl:param name="first"/>
        <xsl:if test="($last != '') and ($first != '')">
            <xsl:for-each select="//all/orcid_profile/item[family=current()/$last]/ORCID">             
                <nameIdentifier type="{lower-case(name())}">
                    <xsl:value-of select="."/>
                </nameIdentifier>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <xd:doc><xd:desc>host</xd:desc></xd:doc>
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

    <xd:doc><xd:desc>DOI</xd:desc></xd:doc>
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

    <xd:doc><xd:desc>licenseUrl</xd:desc></xd:doc>
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
                            <xsl:variable name="license_type" select="/all/license_type[@type = 'str']"/>
                            <xsl:value-of select="$license_type"/>
                        </xsl:attribute>
                        <xsl:attribute name="start_date">
                            <xsl:variable name="access_date" select="/all/publicly_accessible_on_publisher_site[@type = 'str']"/>
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="dateStr" select="$access_date"/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                    </xsl:element>
                    <xsl:element name="license_ref">
                        <xsl:attribute name="applies_to">reuse</xsl:attribute>
                        <xsl:attribute name="start_date">
                            <xsl:variable name="reuse_date" select="/all/reuse_license_start_date[@type = 'str']"/>
                            <xsl:call-template name="format-date">
                                <xsl:with-param name="dateStr" select="$reuse_date"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:element>
                </program>
            </accessCondition>
        </xsl:if>
    </xsl:template>

    <xd:doc><xd:desc>originInfo</xd:desc></xd:doc>
    <xsl:template name="originInfo">
        <originInfo>
            <xsl:apply-templates select="published_print"/>
            <xsl:apply-templates select="published_online"/>
        </originInfo>
    </xsl:template>

    <xd:doc><xd:desc>published_print</xd:desc></xd:doc>
    <xsl:template match="published_print">
        <xsl:if test="not(. = '')">
            <dateIssued encoding="w3cdtf" keyDate="yes">
                <xsl:call-template name="format-date">
                    <xsl:with-param name="dateStr" select="."/>
                </xsl:call-template>
            </dateIssued>
        </xsl:if>
    </xsl:template>

    <xd:doc><xd:desc>published_online</xd:desc></xd:doc>
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

    <xd:doc><xd:desc>extension</xd:desc></xd:doc>
    <xsl:template name="extension">
        <extension>
            <vendorName>CHORUS</vendorName>
            <workingDirectory><xsl:value-of select="$workingDir"/></workingDirectory>
            <originalFile><xsl:value-of select="$originalFilename"/></originalFile>
            <xsl:apply-templates select="agency_id"/>
            <xsl:apply-templates select="agency_name"/>
            <xsl:apply-templates select="breakdown_for"/>
            <xsl:apply-templates select="funders"/>
        </extension>
    </xsl:template>

    <xd:doc><xd:desc>agency_id</xd:desc></xd:doc>
    <xsl:template match="agency_id">
        <xsl:if test="not(. = '')">
            <note type="agency_id"><xsl:value-of select="."/></note>
        </xsl:if>
    </xsl:template>

    <xd:doc><xd:desc>agency_name</xd:desc></xd:doc>
    <xsl:template match="agency_name">
        <xsl:if test="not(. = '')">
            <note type="agency_name"><xsl:value-of select="."/></note>
        </xsl:if>
    </xsl:template>

    <xd:doc><xd:desc>breakdown_for</xd:desc></xd:doc>
    <xsl:template match="breakdown_for">
        <xsl:if test="not(. = '')">
            <note type="breakdown_for"><xsl:value-of select="."/></note>
        </xsl:if>
    </xsl:template>
    
 <xd:doc><xd:desc>funders</xd:desc></xd:doc>
    <xsl:template match="funders[following-sibling::node()]">
        <xsl:variable name="axis" select="following-sibling::node()"/>
        <funding-group specific-use="crossref">
            <award-group>
                <xsl:for-each select="item">
                    <funding-source>
                        <institution-wrap>                   
                            <institution>
                                <xsl:value-of select="."/>                               
                            </institution>                         
                            <xsl:variable name="pos" select="position()"/>
                            <institution_id type="doi">                                 
                                <xsl:value-of select="concat('https://doi.org/',subsequence(../$axis/item[$pos],1,1))"/>
                            </institution_id>
                            <!--<institution_id type="ror">                                 
                                <xsl:value-of select="subsequence(../$axis/item[$pos],2,2)"/>
                            </institution_id>  -->
                        </institution-wrap>
                    </funding-source>
                </xsl:for-each>
            </award-group>
        </funding-group>
    </xsl:template>
   
   
   
    <xd:doc><xd:desc>recordInfo</xd:desc></xd:doc>
    <xsl:template name="recordInfo">
        <recordInfo>
            <recordCreationDate><xsl:value-of select="current-dateTime()"/></recordCreationDate>
            <recordOrigin><xsl:text>XML source generated via Python using CHORUS API JSON data; converted to MODS with chorus_to_mods.xsl</xsl:text></recordOrigin>
        </recordInfo>
    </xsl:template>

</xsl:stylesheet>
