<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.loc.gov/mods/v3" xmlns:date="http://exslt.org/dates-and-times" xmlns:f="http://functions" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
    extension-element-prefixes="date" exclude-result-prefixes="f mods xd xlink xs xsi">
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:key name="name" match="*/item" use="text()" />
    
    <xd:doc scope="stylesheet" id="chorus_to_mods_20250721.xsl">
        <xd:desc>
            <xd:p><xd:b></xd:b></xd:p>
            <xd:p><xd:b>Created on: </xd:b>Aug 31, 2021</xd:p>
            <xd:p><xd:b>Authors: </xd:b>Paul Shih and Amanda Xu</xd:p>
            <xd:p><xd:b>Editors: </xd:b>Carlos Martinez III, Amanda Xu and Rachel Donahue</xd:p>
            <xd:p><xd:b>Filename: </xd:b>chorus_to_mods.xsl</xd:p>
           
            <xd:p><xd:b>Change log:</xd:b></xd:p>  
            <xd:ul>
                <xd:li><xd:p><xd:b>1.30</xd:b> Removed "str" exslt extension. Failed transformation using Saxon 6.5.5. - 20250721 - cm3 </xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.29</xd:b> Added and edited logic for &lt;dateIssued&gt; and &lt;dateOther&gt; to include "publicly_accessible_on_publisher_site" for preprints - 20250627 - cm3</xd:p></xd:li> 
                <xd:li><xd:p><xd:b>1.28</xd:b> Added call-template with:params to verify first and last from orcid profile - 20250627 - cm3</xd:p></xd:li> 
                <xd:li><xd:p><xd:b>1.27</xd:b> Changed root template to use apply-templates select="/all" instead of named template. - 20250627 - cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.26</xd:b> Removed str:tokenize from author template, used substring-before and substring-after instead - 20250627 - cm3</xd:p></xd:li>     
                <xd:li><xd:p><xd:b>1.25</xd:b> Reworked accessCondition template using call-templates instead of functions - 20250627 - cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.24</xd:b> Improved funders template by using Meunchian grouping to group funding institution names and ids accurately. This method also prevents duplicate funder entries from being created. - 20250627 - cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.23</xd:b> Unable to get str:tokenize() EXSLT function to work reliably. Built tokenize-dates template to improvise for XSLT 1.0 inability to tokenize items via regular expression - 20250627 - cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.22</xd:b> This stylesheet was downgraded from XSLT version 2.0 to 1.0. - 20250625 - cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.21</xd:b> Changed if test to for-each to select multiple affliations per author. - 20241221 - cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.20</xd:b> Corrected typos, suggested pubDate patterns, tested and reviewed - 20241021 - axu</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.19</xd:b> When journal_title is unavailable, use publisher name or extract it from DOI. - 20241011 - cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.18</xd:b> f:date:format-date required reordering of tokens to achieve wc3dtf. 20241011 - cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.17</xd:b> Added template to use &lt;reuse_license_start_date&gt; as second preferred date option for preprint source XML (these resources have not been published). - 20241011 - cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.16</xd:b> Added template to use &lt;publicly_accessible_on_publisher_site&gt; as the preprint date as date of publication when published_print and published_online are null. - 20241009 - cm3</xd:p></xd:li> 
                <xd:li><xd:p><xd:b>1.15</xd:b> To prevent inaccurate &lt;institution_id&gt; inforfmation, a call template counts the number of items present within the funders tag and the followingsibling::node(s). The most suitable funders template mode is applied when a condition is met. -20241009- axu</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.14</xd:b> Grouping &lt;institution&gt; with &lt;institution_fid&gt; is accurate, yet also dependent that each sibling contain the same number of items. -20241009- cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.13</xd:b> Corrected <xd:i>most</xd:i> errors resulting from fpairing &lt;institution&gt; and &lt;institution_id&gt;. -20241004- cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.12</xd:b> The DOI displayed within any &lt;institution_id&gt; tag. (e.g., '<xd:a href="https://doi.org">https://doi.org//10.#####/#######</xd:a>') -20241004- cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.11</xd:b> DOI content contained with in &lt;funderIDs> tag wfas prefixed with hard coded text (i.e., https://doi.org/); creating a direct URI to the article. -20241004- cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.10</xd:b> Removal of the hard coded text prevents concatenatfion errors . -20240926- cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.09</xd:b> Conditionally tests institution identifiers make sfure it doesn't start with "http"; then ROR is tested to ensure it does not match the DOI pattern. -20240925- cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.08</xd:b> Changed second accessCondition type to "restriction on access".  -20240710- cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.07</xd:b> Added if tests to funding and accessCondition tempflates to prevent empty tags -20240620- cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.06</xd:b> Added template creates &lt;accessCondition&gt; elefment and attributes. -20240613- cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.05</xd:b> Funders template adds &lt;institution_id @type='dofi'&gt;. -20240430- cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.04</xd:b> Added A-file output.-20240418- cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.03</xd:b> Authors' name template str:tokenized for first andf last, substring-after for middleParts. -20240418- cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.02</xd:b> Collection processing added (currently commented ofut). -20240418- cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.01</xd:b> Upgraded XSLT version to 2.0. -20240418- cm3</xd:p></xd:li>
                <xd:li><xd:p><xd:b>1.00</xd:b> Change log added. -20240418- cm3</xd:p></xd:li>
            </xd:ul>
        </xd:desc>
    </xd:doc>
    
    <xd:doc>
        <xd:desc>
            <xd:p><xd:b>Root template:</xd:b> Selects individual CHORUS XML and transforms then</xd:p>
        </xd:desc>
    </xd:doc>
        <xsl:template match="/">  
        <!-- MODS files -->
        <xsl:for-each select="/all">
            <mods xmlns="http://www.loc.gov/mods/v3" 
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="3.7" 
                xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd" 
                xmlns:xlink="http://www.w3.org/1999/xlink">
                <!-- 1.27 -->
              <xsl:apply-templates select="/all"/>
           </mods>
        </xsl:for-each>
    </xsl:template>
    
    <xd:doc><xd:desc>item-info</xd:desc></xd:doc>
    <xsl:template match="/all">       
        <titleInfo>
            <title><xsl:value-of select="title"/></title>
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
 
      <xd:doc><xd:desc>authors</xd:desc></xd:doc>
    <xsl:template match="authors">
        <xsl:for-each select="item">
        <xsl:if test="not(contains(author, 'undefined'))">
            <!-- 1.26 -->
                <xsl:variable name="familyName" select="substring-before(author,' ')"/>
                <xsl:variable name="givenName" select="substring-after(author,' ')"/>
                    <name type="personal">
                <xsl:if test="position() = 1">
                    <xsl:attribute name="usage">primary</xsl:attribute>
                </xsl:if>
                <namePart type="family">
                    <xsl:value-of select="$familyName"/>
                </namePart>
                <namePart type="given">
                     <xsl:value-of select="normalize-space($givenName)"/>
                </namePart>
                    <displayForm>
                        <xsl:value-of select="normalize-space(concat($familyName,', ',$givenName))"/>
                    </displayForm> 
                    <xsl:apply-templates select="affiliation"/>
                <role>
                    <roleTerm type="text">author</roleTerm>
                </role>
                        <!--1.28-->
                <xsl:call-template name="orcid">
                    <xsl:with-param name="first">
                        <xsl:choose>
                            <xsl:when test="contains($givenName, ' ')">
                                <xsl:value-of select="substring-before($givenName, ' ')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$givenName"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>                       
                    <xsl:with-param name="last" select="$familyName"/>
                </xsl:call-template>
            </name> 
                    </xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xd:doc><xd:desc>affiliation</xd:desc></xd:doc>
    <xsl:template match="affiliation">
        <!-- 20241224 cm3 changed if test to for-each -->
        <xsl:for-each select="./text()">
            <affiliation>
                <xsl:value-of select="."/>
            </affiliation>
        </xsl:for-each>
    </xsl:template>
 
    <xd:doc>
        <xd:desc><xd:p><xd:b>ORCID: </xd:b>The orcid template is called within the author template. Added for-each and predicates to XPath</xd:p></xd:desc>
        <xd:param name="last"/>
        <xd:param name="first"/>
    </xd:doc>
    <xsl:template name="orcid">
        <xsl:param name="last"/>
        <xsl:param name="first"/>
           <xsl:for-each select="/all/orcid_profile/item">
               <!-- 1.28 -->
                <xsl:if test="family=$last and given=$first">
                    <nameIdentifier>
                        <xsl:attribute name="type">
                            <xsl:call-template name="lower-case">
                                <xsl:with-param name="text" select="name(ORCID)"/>
                            </xsl:call-template>
                        </xsl:attribute>
                        <xsl:value-of select="ORCID"/>
                    </nameIdentifier>
                </xsl:if>
            </xsl:for-each>
    </xsl:template>

    <xd:doc><xd:desc>host</xd:desc></xd:doc>
    <xsl:template name="host">
        <relatedItem type="host">
            <xsl:if test="not(journal_name = '')">
            <titleInfo>
                <title><xsl:value-of select="journal_name"/></title>
            </titleInfo>
            </xsl:if>
            <originInfo>
                <publisher><xsl:value-of select="publisher"/></publisher>
            </originInfo>
        </relatedItem>
    </xsl:template>

    <xd:doc><xd:desc>DOI</xd:desc></xd:doc>
    <xsl:template match="DOI">
        <identifier type="doi"><xsl:value-of select="."/></identifier>
        <identifier type="chorus"><xsl:value-of select="."/></identifier>
        <location>
            <url displayLabel="Available from publisher's website"><xsl:value-of select="concat('https://dx.doi.org/', .)"/></url>
        </location>       
    </xsl:template>    
                    <!--1.25-->
    <xd:doc><xd:desc> accessCondition </xd:desc></xd:doc>
    <xsl:template match="licenseUrl">
        <xsl:variable name="appliesTo">
            <xsl:call-template name="lower-case">
                <xsl:with-param name="text" select="../license_type"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="startDate">
            <xsl:call-template name="tokenize-dates">
                <xsl:with-param name="dateString" select="../reuse_license_start_date"/>
                <xsl:with-param name="delimiter" select="'/'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <!-- Handle the case where license - type is open - access -->
            <xsl:when test="@type = 'str'">
                <accessCondition type="use and reproduction">
                    <!-- Set the displayLabel by mapping the URL to a friendly name -->
                    <xsl:attribute name="displayLabel">
                        <xsl:choose>
                            <xsl:when test="contains(., 'by-nc/4.0')">Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)</xsl:when>
                            <xsl:when test="contains(., 'by/4.0')">Creative Commons Attribution 4.0 International (CC BY 4.0)</xsl:when>
                            <xsl:when test="contains(., 'by-sa/4.0')">Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0)</xsl:when>
                            <xsl:when test="contains(., 'by-nc-sa/4.0')">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)</xsl:when>
                            <xsl:when test="contains(., 'by-nd/4.0')">Creative Commons Attribution-NoDerivatives 4.0 International (CC BY-ND 4.0)</xsl:when>
                            <xsl:when test="contains(., 'by-nc-nd/4.0')">Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)</xsl:when>
                            <xsl:otherwise>
                                <!-- Fallback if the license is not in our list -->
                                <xsl:value-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    <program xmlns="https://data.crossref.org/schemas/AccessIndicators.xsd">
                        <license_ref>
                            <xsl:if test="not($appliesTo = '')">
                                <xsl:attribute name="applies_to">
                                    <xsl:value-of select="$appliesTo"/>
                                </xsl:attribute>
                            </xsl:if><xsl:if test="not($startDate = '')">
                                <xsl:attribute name="start_date">
                                    <xsl:value-of select="$startDate"/>
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="."/>
                        </license_ref>
                    </program>
                </accessCondition>
                <accessCondition type="restriction on access"
                    xlink:href="http://purl.org/eprint/accessRights/OpenAccess"
                    displayLabel="Access Status">Open Access</accessCondition>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    
    <xd:doc><xd:desc>originInfo</xd:desc></xd:doc>
    <xsl:template name="originInfo">
        <originInfo>
            <xsl:choose>
                <xsl:when test="published_print[@type='str'] or published_online[@type='str']">
                    <xsl:apply-templates select="published_print"/>
                    <xsl:apply-templates select="published_online"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="publicly_accessible_on_publisher_site"/>
                </xsl:otherwise>
            </xsl:choose>
        </originInfo>
    </xsl:template>
    
    <xd:doc><xd:desc>published_print</xd:desc></xd:doc>
    <xsl:template match="published_print">
        <xsl:if test="not(. = '')">
            <dateIssued encoding="w3cdtf" keyDate="yes">
                <xsl:call-template name="tokenize-dates">
                    <xsl:with-param name="dateString" select="."/>
                    <xsl:with-param name="delimiter" select="'/'"/>
                </xsl:call-template>
            </dateIssued>
        </xsl:if>
    </xsl:template>
    
    <xd:doc><xd:desc>published_online</xd:desc></xd:doc>
    <xsl:template match="published_online[not(../published_print[@type='str'])]">
        <xsl:if test="not(. = '')">
            <dateIssued encoding="w3cdtf" keyDate="yes">
                <xsl:call-template name="tokenize-dates">
                    <xsl:with-param name="dateString" select="."/>
                    <xsl:with-param name="delimiter" select="'/'"/>
                </xsl:call-template>
            </dateIssued>
        </xsl:if>
    </xsl:template>
    <xd:doc><xd:desc>published_online (electronic)</xd:desc></xd:doc>
    <xsl:template match="published_online[../published_print[@type='str']]">
        <xsl:if test="not(. = '')">
            <dateOther encoding="w3cdtf" type="electronic">
                <xsl:call-template name="tokenize-dates">
                    <xsl:with-param name="dateString" select="."/>
                    <xsl:with-param name="delimiter" select="'/'"/>
                </xsl:call-template>
            </dateOther>
        </xsl:if>
    </xsl:template>
    
    
    <xd:doc><xd:desc>publicly_accessible_on_publisher_site</xd:desc></xd:doc>
    <xsl:template match="publicly_accessible_on_publisher_site">
        <dateIssued encoding="w3cdtf" keyDate="yes">
            <xsl:call-template name="tokenize-dates">
                <xsl:with-param name="dateString" select="."/>
                <xsl:with-param name="delimiter" select="'/'"/>
            </xsl:call-template>
        </dateIssued>
    </xsl:template>
    
  
    <xd:doc><xd:desc>reuse_license_start_date</xd:desc></xd:doc>
    <xsl:template match="reuse_license_start_date">
        <dateIssued encoding="w3cdtf" keyDate="yes">
            <xsl:call-template name="tokenize-dates">
                <xsl:with-param name="dateString" select="."/>
                <xsl:with-param name="delimiter" select="'/'"/>
            </xsl:call-template>
        </dateIssued>
    </xsl:template>
    
    <xd:doc><xd:desc>extension</xd:desc></xd:doc>
    <xsl:template name="extension">
        <extension>
            <vendorName>CHORUS</vendorName>
            <workingDirectory>/data/metadata/staging/chorus</workingDirectory>
            <xsl:apply-templates select="agency_id"/>
            <xsl:apply-templates select="agency_name"/>
            <xsl:apply-templates select="breakdown_for"/>
            <xsl:apply-templates select="funders" />
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
    
    <!--1.24-->
    <xd:doc><xd:desc>funders</xd:desc></xd:doc>
    <xsl:template match="funders">
        <funding-group>
            <xsl:for-each select="item[generate-id()=generate-id(key('name',text())[1])]">
                <xsl:variable name="i" select="position()"/>
                <award-group>
                    <funding-source>
                        <institution>
                            <xsl:value-of select="."/>
                        </institution>
                        <xsl:for-each select="../following-sibling::node()/item[generate-id()=generate-id(key('name',text())[1])][$i]">
                            <institution-id>
                                <xsl:choose>
                                    <xsl:when test="starts-with(.,'10.')">
                                        <xsl:attribute name="institution-id-type">doi</xsl:attribute>
                                        <xsl:value-of select="concat('https://doi.org/',.)"/>
                                    </xsl:when>
                                    <xsl:when test="contains(.,'ror')">
                                        <xsl:attribute name="institution-id-type">ror</xsl:attribute>
                                        <xsl:value-of select="."/>
                                    </xsl:when>
                                </xsl:choose>
                            </institution-id>
                        </xsl:for-each>
                    </funding-source>
                </award-group>
            </xsl:for-each>
        </funding-group>
    </xsl:template>
    
    <xd:doc><xd:desc>recordInfo</xd:desc></xd:doc>
    <xsl:template name="recordInfo">
        <recordInfo>
            <recordCreationDate><xsl:value-of select="date:date-time()"/></recordCreationDate>
            <recordOrigin><xsl:text>XML source generated via Python using CHORUS API JSON data; converted to MODS with chorus_to_mods.xsl</xsl:text></recordOrigin>
        </recordInfo>
    </xsl:template>

<!-- CALL TEMPLATES (i.e., XSLT 1.0 functions) 
        1. lower-case - external variable translates capitalized text into lower-case.
        2. upper-case (commented out, not in use)
        3. tokenize-dates - "/" delimiter is used to split date strings into tokens, then substring-before and substring-after are used for selection.
 -->
    
    <!-- use for upper() and  lower() -->
    <xsl:variable name="lower-case" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="upper-case" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
   
    <xd:doc>
        <xd:desc>lower-case</xd:desc>
        <xd:param name="text"/>
    </xd:doc>
    <xsl:template name="lower-case">
        <xsl:param name="text"/> 
        <xsl:value-of select="translate($text, $upper-case, $lower-case)" />
    </xsl:template>

    <!--<xd:doc>
        <xd:desc/>
        <xd:param name="text"/>
    </xd:doc>
    <xsl:template name="upper-case">
        <xsl:param name="text"/> 
        <xsl:value-of select="translate($text, $lower-case, $upper-case)" />
    </xsl:template>
-->
    
    <!-- 1.23-->
    <xd:doc>     
        <xd:desc><xd:p><xd:b>"tokenize-dates": </xd:b> call-template used to split various formats of date strings into ISO 8601 format. </xd:p>
            <xd:p>
                <xd:b>Tokens explained:</xd:b>
                <xd:ul>
                    <xd:li><xd:p><xd:b>token1: </xd:b>preEvalToken1 checks if zero-padding is required to create the double digit <xd:b>month</xd:b>.</xd:p></xd:li>
                    <xd:li><xd:p><xd:b>token2: </xd:b>if token3 is empty then token2 is four digit <xd:b>year</xd:b></xd:p></xd:li>
                    <xd:li><xd:p><xd:b>token3: </xd:b>if token3 is NOT empty then token3 is four digit <xd:b>year</xd:b></xd:p></xd:li>
                    <xd:li><xd:p><xd:b>token4: </xd:b>preEvalToken4 to check for zero-padding on two digit <xd:b>day</xd:b>.</xd:p></xd:li>
                </xd:ul>
            </xd:p>
        </xd:desc>
        <xd:param name="dateString"><xd:p>input param used to collect date string</xd:p></xd:param>
        <xd:param name="delimiter"><xd:p>forward-slash</xd:p></xd:param>
    </xd:doc>
    <xsl:template name="tokenize-dates">
        <xsl:param name="dateString"/>
        <xsl:param name="delimiter"/>
        <xsl:variable name="token1">
            <!-- if single digit, add "0" in front -->
            <xsl:variable name="preEvalToken1" select="substring-before($dateString, $delimiter)"/>
            <xsl:choose>
                <xsl:when test="string-length($preEvalToken1) = 1"> <!-- if 1-9 add 0 before it -->
                    <xsl:value-of select="concat('0',$preEvalToken1)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$preEvalToken1"/> <!-- if greater than 9, already double digit, do nothing -->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>            
        <xsl:variable name="token2" select="substring-after($dateString, $delimiter)"/>
        <xsl:variable name="token3" select="substring-after($token2,$delimiter)"/>
        <xsl:variable name="token4">
            <!-- same as token1 -->
            <xsl:variable name="preEvalToken4" select="substring-before($token2,$delimiter)"/>
            <xsl:choose>
                <xsl:when test="string-length($preEvalToken4) = 1">
                    <xsl:value-of select="concat('0',$preEvalToken4)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$preEvalToken4"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- process tokens -->
        <xsl:choose>
            <!-- two delimiters (e.g., YYYY/MM/dd)  -->
            <xsl:when test="not($token3='')">
                <xsl:value-of select="concat($token3,'-' ,$token1,'-', $token4)"/>
            </xsl:when>
            <!-- one delimiter (e.g., YYYY/MM)-->
            <xsl:when test="$token3 = '' and string-length($token2 > 2)">
                <xsl:value-of select="concat($token2,'-',$token1)"/>
            </xsl:when>
        </xsl:choose>        
    </xsl:template>

    
</xsl:stylesheet>