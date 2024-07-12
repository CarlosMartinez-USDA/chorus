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
   
    <xd:doc scope="stylesheet" id="chorus">
        <xd:desc>
            <xd:p><xd:b>Created </xd:b>? ? ????</xd:p>
            <xd:p><xd:b>Authored by: </xd:b>Ying Li</xd:p>
            <xd:p><xd:b>Edited on: </xd:b>April 15, 2024</xd:p>
            <xd:p><xd:b>Edited by: </xd:b>Carlos Martinez III</xd:p>
            <xd:ul>
                <xd:p><xd:b>chorus_xml2mods.xsl</xd:b>XSLT to transforms CHORUS XML to MODS.</xd:p>                
                <xd:p><xd:i>Listed below:</xd:i></xd:p>
                <xd:li>
                    <xd:p><xd:b>Issue #1</xd:b>: three source XML files reference two different
                        dtds. Listed below: <xd:li>
                            <xd:p>DOCTYPE article PUBLIC "-//Atypon//DTD Atypon Systems Archival NLM
                                DTD Suite v2.2.0 20090301//EN" "archivearticle.dtd"</xd:p>
                        </xd:li>
                        <xd:li>
                            <xd:p>DOCTYPE article PUBLIC "-//NLM//DTD JATS (Z39.96) Journal
                                Publishing DTD v1.1 20151215//EN"
                                "JATS-journalpublishing1.dtd"</xd:p>
                        </xd:li>
                        <xd:p>In order to keep the archival reporduction of the source document as
                            true as possible variation for any DTD that is present in the source it
                            is copied to the arhival copy </xd:p>
                        <xd:a
                            href="https://jats.nlm.nih.gov/publishing/1.1/JATS-journalpublishing1.dtd"
                            ><xd:i>NISO JATS DTD version 1.1</xd:i></xd:a>. The <xd:a
                                href="../jats_to_mods_30.xsl">jats_to_mods_30.xsl</xd:a> reproduces the
                        <xd:i>a-file</xd:i> metadata with the incorrect DTD, thus rendering an
                        invalid, archival copy of the source metadata. </xd:p>
                    <xd:p><xd:b>Solution</xd:b>: Added an output statement containing the system and public ids to the correct version of the JATS publishing DTD to render valid archival metadata</xd:p>
                </xd:li>
                <xd:li>
                    <xd:p><xd:b>Issue #2</xd:b>: avma's metadata rendered two mods
                        <xd:i>dateIssued</xd:i> tags containing a <xd:i>keyDate</xd:i> attribute and its corresponding value set to "yes" (e.g., <xd:i>keyDate</xd:i>="yes")</xd:p>
                    <xd:p><xd:b>Solution</xd:b>: This stylesheet uses the named template <xd:a docid="avma_originInfo">avma_originInfo</xd:a> to choose only one date based on the conditions contained therein.</xd:p>
                </xd:li>
                <xd:li>
                    <xd:p><xd:b>Issue #3:</xd:b>Text type tags appearing within the <xd:i>mods:relatedItem/part</xd:i> subelements correspond with the <xd:i>dateIssued</xd:i> tag. Thus, similar logic to select the <xd:i>dateIssued</xd:i> tag is applied to a named template, <xd:a docid="avma_modsPart">avma_modsPart</xd:a>. </xd:p>
                    <xd:p><xd:b>Solution: </xd:b> Applying similar conditional logic this stylesheet chooses the corresponding date to the <xd:i>dateIssued</xd:i> tag.</xd:p>
                    <xd:p><xd:b>For example:</xd:b></xd:p>
                    <![CDATA[avma_originInfo:
                    <originInfo>
                        <dateIssued encoding="w3cdtf" keyDate="yes">2020-09-30</dateIssued>
                    </originInfo>]]>
                    <xd:p><xd:b>Corresponds with:</xd:b></xd:p>
                    <![CDATA[avma_modsPart:
                    <part>
                        <text type="year">2020</text>
                        <text type="month">09</text>
                        <text type="day">30</text>
                    </part>]]>
                </xd:li>
            </xd:ul>
            <xd:ul>
                <xd:p><xd:b>Revision:</xd:b> </xd:p>
                <xd:li>
                    <xd:a docid="avma-authors-name-info">avma-authors-name-info</xd:a> has been edited to used an XPath expression to match aff[@id] (i.e. the affiliation) to xref/@rid (i.e., author's name id) using the <xd:i>current() function</xd:i>.
                    <xd:p><xd:b>XPath expression :</xd:b> (e.g., //aff[@id=current()/xref/@rid]) </xd:p>
                    <xd:p><xd:b>Revision: </xd:b>used for-each and the //aff[@id="current()/xref/@rid] to prevent empty affiliation tag form being created.</xd:p>
                </xd:li>
            </xd:ul>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="/">
        <xsl:choose>
    <!-- modsCollection -->
      <xsl:when test="all[position() > 1]">
          <xsl:result-document href="{replace(base-uri(),'(.*/)(.*)(\.xml)', '$1')}N-{replace(base-uri(),'(.*/)(.*)(\.xml)', '$2')}_{position()}.xml">  
       <modsCollection xmlns="http://www.loc.gov/mods/v3"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd">
                <xsl:for-each select="all">
                    <mods version="3.7">    
                        <xsl:call-template name="item-info"/>
                    </mods>
                </xsl:for-each>
            </modsCollection>
          </xsl:result-document>
      </xsl:when>
      <xsl:otherwise> 
          <!-- mods -->
        <xsl:for-each select="all[position() &lt; 2">
            <xsl:result-document href="{replace(base-uri(),'(.*/)(.*)(\.xml)', '$1')}N-{replace(base-uri(),'(.*/)(.*)(\.xml)', '$2')}_{position()}.xml">
            <mods xmlns="http://www.loc.gov/mods/v3"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="3.7"
                xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd"
                xmlns:xlink="http://www.w3.org/1999/xlink">                
                <xsl:call-template name="item-info"/>
            </mods>
            </xsl:result-document>
        </xsl:for-each>
      </xsl:otherwise>
        </xsl:choose>
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
   
    <xsl:template match="authors">
        <xsl:for-each select="item">
            <xsl:variable name="name-tokens" select="tokenize(author,'&#xa0;')"/>
            <xsl:variable name="given" select="normalize-space(substring-after(author, $name-tokens[1]))"/> 
            <xsl:variable name="last" select="$name-tokens[1]"/>
            <xsl:variable name="first" select="$name-tokens[2]"/>
            <name type="personal">
                    <xsl:if test="author[position() = 1]">
                        <xsl:attribute name="usage">primary</xsl:attribute>
                    </xsl:if>
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
  
    <!-- 
         (1)This comment is for peer-review and should be removed afterwards.
         (2)This new template parses <author> into <namePart> elements.
         (3)The analyze-string processing instruction allows integration of both 
            new and old parsing methods. Using the substring sub-elements: 
           (a) matching-substring takes advantage of the regex attribute to more accurately
               parse and puntuate author names.
           (b) non-matching-substring: uncomments the author name section and updates the tokenize function 
               to XPath 2.0.
           (c) Combined, both elements offer a seamless solution for variation in author names. 
        
    <xsl:template match="author">
        <xsl:analyze-string select="." regex="^(\S+)\s(\S+)(\s[A-Z])?\.?$">
            <!-- regex assumes last<space>first<space>[?]middleInitial[?]-->
            <xsl:matching-substring>              
                <xsl:variable name="lastName" select="regex-group(1)"/>
                <xsl:variable name="firstName">
                    <xsl:sequence select="if (regex-group(3)!='')
                        then concat(regex-group(2), regex-group(3),'.')
                        else regex-group(2)"/>                
                </xsl:variable>
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
            <xsl:non-matching-substring>
                <!-- previous method re-enabled
                     removed $given variable
                     replaced $first to accomodate middle initial names
                     upgraded XPath functions
                     added non-breaking whitespace -->
                <xsl:variable name="name-tokens" select="tokenize(., '&#xa0;')"/>
                <xsl:variable name="lastName" select="$name-tokens[1]"/>
                <xsl:variable name="firstName" select="if ($name-tokens[3]!='')
                                                   then concat($name-tokens[2],'&#xa0;',translate($name-tokens[3],'.',''),'.')
                                                   else $name-tokens[2]"/>
                <namePart type="family"><xsl:value-of select="$lastName"/></namePart>
                   <xsl:choose>
                       <xsl:when test="$name-tokens[3]!=''">
                           <namePart type="given"><xsl:value-of select="$firstName"/></namePart>
                           <displayForm><xsl:value-of select="normalize-space(concat($lastName,'&#xa0;',$firstName))"/></displayForm>
                       </xsl:when>
                       <xsl:otherwise>
                           <namePart type="given"><xsl:value-of select="$firstName"/></namePart>
                           <displayForm><xsl:value-of select="normalize-space(concat($lastName,'&#xa0;',$firstName))"/></displayForm>
                       </xsl:otherwise>
                    </xsl:choose>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template match="affiliation">
        <xsl:if test="./text() != ''">
            <affiliation><xsl:value-of select="."/></affiliation>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="orcid">
        <xsl:param name="last"/>
        <xsl:param name="first"/>
        <xsl:if test="($last != '') and ($first != '')">
            <xsl:for-each select="/all/orcid_profile/item">
<!--                <xsl:if test="family[@type='str'] and family=$last and given=$first">-->
                    <nameIdentifier><xsl:value-of select="ORCID"/></nameIdentifier>
                <!--</xsl:if>-->
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