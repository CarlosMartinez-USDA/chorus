<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.loc.gov/mods/v3" xmlns:f="http://functions" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:saxon="http://saxon.sf.net/" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="f saxon mods xd xlink xs xsi">
    <xsl:output method="xml" indent="yes" encoding="UTF-8" name="test"/>
   
    <xsl:include href="commons/params.xsl"/>
    <xd:doc scope="stylesheet" id="chorus_to_mods_test.xsl">
        <xd:desc>
            <xd:p><xd:b>CHORUS to MODS XML Transformation</xd:b></xd:p>
            <xd:p><xd:b>Created on: </xd:b>2021</xd:p>
            <xd:p><xd:b>Authored by: </xd:b>Paul Shih and Amanda Xu</xd:p>
            <xd:p><xd:b>Edited on: </xd:b>October 10, 2024</xd:p>
            <xd:p><xd:b>Edited by: </xd:b>Carlos Martinez III</xd:p>
            <xd:p><xd:b>Filename: </xd:b>chorus_to_mods_test.xsl</xd:p>
            <xd:p><xd:b>AMB Staff Note:</xd:b>This version requires more testing and discussion before moving to production.</xd:p>
            
            <xd:p><xd:b>FEATURED: Groups funders and funder identifiers.</xd:b></xd:p>
            <xd:ul>
                <xd:li><xd:p>(1) &lt;institution&gt; tag has either an organization name or acronym. - <xd:i>complete</xd:i></xd:p></xd:li>
                <xd:li><xd:p>(2) &lt;institution_id&gt; tags contain either a Digital Object Identifier (DOI) or a Research Organization Registry (ROR) id. - <xd:i>complete</xd:i></xd:p></xd:li>
                <xd:li><xd:p>(3) Verified accuracy of &lt;institution_id&gt; and &lt;institution&gt; pairings. - <xd:i>complete</xd:i></xd:p></xd:li>
                <xd:li><xd:p>(4) &lt;institution_id[@type attribute], only two values are valid (i.e., 'doi' or 'ror'). - <xd:i>complete</xd:i></xd:p></xd:li>
            </xd:ul>
            
            <xd:p><xd:b>Change log:</xd:b></xd:p>  
            <xd:ul>         
                <xd:li><xd:p>Added template to use &lt;publicly_accessible_on_publisher_site&gt; as the preprint date as date of publication when published_print and published_online are null. - 20241009 - cm3</xd:p></xd:li> 
                <xd:li><xd:p>To prevent inaccurate &lt;institution_id&gt; information, a call template counts the number of items present within the funders tag and the following-sibling::node(s). The most suitable funders template mode is applied when a condition is met. - 20241009 - cm3</xd:p></xd:li> 
                <xd:li><xd:p>Grouping &lt;institution&gt; with &lt;institution_id&gt; is accurate, yet also dependent that each sibling contain the same number of items. - 20241009 - cm3</xd:p></xd:li>
                <xd:li><xd:p>Corrected <xd:i>most</xd:i> errors resulting from pairing &lt;institution&gt; and &lt;institution_id&gt;. - 20241004 - cm3</xd:p></xd:li>
                <xd:li><xd:p>The DOI displayed within any &lt;institution_id&gt; tag. (e.g., '<xd:a href="https://doi.org">https://doi.org//10.#####/#######</xd:a>') - 20241004 - cm3</xd:p></xd:li>
                <xd:li><xd:p>DOI content contained with in &lt;funderIDs> tag was prefixed with hard coded text (i.e., https://doi.org/); creating a direct URI to the article. - 20241004 - cm3</xd:p></xd:li>
                <xd:li><xd:p>Removal of the hard coded text prevents concatenation errors . - 20240926 - cm3</xd:p></xd:li>
                <xd:li><xd:p>Conditionally tests institution identifiers make sure it doesn't start-with "http"; then ROR is tested to ensure it does not match the DOI pattern. - 20240925 - cm3 </xd:p></xd:li><xd:li><xd:p>Changed second accessCondition type to "restriction on access".  - 20240710 - cm3</xd:p></xd:li>
                <xd:li><xd:p>Added if tests to funding and accessCondition templates to prevent empty tags - 20240620 - cm3</xd:p></xd:li>
                <xd:li><xd:p>Added template creates &lt;accessCondition&gt; element and attributes. - 20240613 - cm3</xd:p></xd:li>
                <xd:li><xd:p>Funders template adds &lt;institution_id @type='doi'&gt;. - 20240430 - cm3</xd:p></xd:li>
                <xd:li><xd:p>Added A-file output. - 20240430 - cm3</xd:p></xd:li>
                <xd:li><xd:p>Authors' name template tokenized for first and last, substring-after for middleParts. - 20240418 - cm3</xd:p></xd:li>
                <xd:li><xd:p>Collection processing added (currently commented out). - 20240418 - cm3</xd:p></xd:li>
                <xd:li><xd:p>Upgraded XSLT version to 2.0. - 20240418 - cm3</xd:p></xd:li>
                <xd:li><xd:p>Change log added. - 20240418 - cm3</xd:p></xd:li>
            </xd:ul>
        </xd:desc>
    </xd:doc>

    <!-- 
        possible for institution and institution_id pairing 
        <xsl:key name="key_fund" match="unders|funderIDs|RORID" use="item"/>
        <xsl:key name="kFund" match="funders" use="item/position()"/>
        <xsl:key name="item_key" match="item" use="position()"/>
    -->  
    
    <xd:doc>
        <xd:desc>
            <xd:p><xd:b>Root template:</xd:b> Selects individual CHORUS XML and transforms then</xd:p>
        </xd:desc>
        <xd:param name="workingDirectory">parameter used for better readability</xd:param>
        <xd:param name="originalFilename">""</xd:param>
    </xd:doc>
    <xsl:template match="/">  
        <!-- archive file -->
        <xsl:param name="workingDirectory" select="substring-before(base-uri(),tokenize(base-uri(),'/')[last()])"/>
        <xsl:param name="originalFilename" select="replace(base-uri(),'(.*/)(.*)(\.xml)', '$2')"/>  
        <!-- archive file -->
        <xsl:result-document href="{$workingDirectory}/archive/A-{$originalFilename}_{position()}.xml" format="test">
            <xsl:copy-of select="." copy-namespaces="no"/>           
        </xsl:result-document>
        <!-- MODS files -->
        <xsl:choose>           
            <xsl:when test="count(//all) != 1">
                <!-- transform collections -->
                <xsl:result-document href="{$workingDirectory}/mods/N-{$originalFilename}_{position()}.xml" format="test">
                    <modsCollection xmlns="http://www.loc.gov/mods/v3" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd">
                        <xsl:for-each select="//all">
                            <mods version="3.7">
                                <xsl:call-template name="item-info"/>
                            </mods>
                        </xsl:for-each>
                    </modsCollection>
                </xsl:result-document>
            </xsl:when>         
            <xsl:otherwise>
                <xsl:result-document format="test" href="{$workingDirectory}/mods/N-{$originalFilename}_{position()}.xml">
                    <mods xmlns="http://www.loc.gov/mods/v3" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="3.7" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd">
                        <xsl:for-each select="all">
                            <xsl:call-template name="item-info"/>
                        </xsl:for-each>
                    </mods>
                </xsl:result-document>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xd:doc><xd:desc>item-info</xd:desc></xd:doc>
    <xsl:template name="item-info">       
        <titleInfo>
            <title><xsl:value-of select="title"/></title>
        </titleInfo>
        <xsl:apply-templates select="authors"/>
        <typeOfResource>text</typeOfResource>
        <genre>article</genre>
        <xsl:call-template name="originInfo"/>
        <xsl:call-template name="host"/>
        <xsl:apply-templates select="DOI"/>
        <xsl:call-template name="accessCondition"/>
        <xsl:call-template name="extension"/>
        <xsl:call-template name="recordInfo"/>
    </xsl:template>
 
    <xd:doc id="author" scope="component">
        <xd:desc>
            <xd:p><xd:b>(1)</xd:b> Tokenize &lt;author&gt;. Set non-breaking-whitespace as tokenization delimiter.</xd:p>
            <xd:p><xd:b>(2)</xd:b> Element is parsed into &lt;namePart&gt; and &lt;displayForm&gt; elements. </xd:p>
            <xd:p><xd:b>(3)</xd:b> The delimiter splits each name component into the following nameParts:</xd:p>
            <xd:p><xd:b>(4)</xd:b> name-tokens explained: </xd:p>
            <xd:ul>
                <xd:li><xd:p><xd:b>a. $name-tokens[1] - </xd:b>  is the $familyName</xd:p></xd:li>
                <xd:li><xd:p><xd:b>b. $name-tokens[2] - </xd:b>  is the first name, or part of the $givenName</xd:p></xd:li>
                <xd:li><xd:p><xd:b>c. $firstMiddle</xd:b> combines $names-token[2] and the rest of the string after it, for author's first name and middle initial</xd:p></xd:li>
                <xd:li><xd:p><xd:b>d. orcid_profile: &lt;xsl:with-param&gt; name="$first"&gt;</xd:b> uses seperate template to build profile. The authors given $first name is compared to $firstMiddle (which combines the first and middle initial). The conditional XPath statement tries both first only and first and middle combined to get a match with $first (within the &lt;orcid_profile&gt;).</xd:p></xd:li>
              </xd:ul>
        </xd:desc>
   </xd:doc>
    <xsl:template match="authors">
        <xsl:for-each select="item">
            <xsl:variable name="name-tokens" select="tokenize(author, ' ')"/> <!-- (1-3) -->
            <xsl:variable name="familyName" select="$name-tokens[1]"/> <!-- a. -->
            <xsl:variable name="firstMiddle" select="concat($name-tokens[2],substring-after(author, $name-tokens[2]))"/> <!-- b. and c.-->      
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
                    <xsl:with-param name="first" select="if (contains($firstMiddle, ' ')) then substring-before($firstMiddle, ' ') else if (matches($firstMiddle,'/^(.*\s.*){2,}$/')) then replace($firstMiddle,'(\w+)(\s+)?([A-Z]\.)','$1') else normalize-space($firstMiddle)"/>  <!-- d. -->
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
                <xsl:value-of select="."/>
            </affiliation>
        </xsl:if>
    </xsl:template>


    <xd:doc>
        <xd:desc><xd:p><xd:b>ORCID: </xd:b>Added for-each and conditional XPath</xd:p>
        </xd:desc>
        <xd:param name="last"/>
        <xd:param name="first"/>
    </xd:doc>
    <xsl:template name="orcid">
        <xsl:param name="last"/>
        <xsl:param name="first"/>
        <xsl:if test="($last != '') and ($first != '')">
           <xsl:for-each select="//all/orcid_profile[@type='list']/item[family=current()/$last and given=current()/$first]/ORCID">             
                <nameIdentifier type="{lower-case(name())}">
                    <xsl:value-of select="."/>
                </nameIdentifier>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xd:doc><xd:desc>host</xd:desc></xd:doc>
    <xsl:template name="host">
        <xsl:variable name="journal_from_DOI" select="replace(/all/DOI,'(10\.\d+/)(\w+)(.*)','$2')"/>
        <relatedItem type="host">
            <titleInfo>
                <title>
                   <xsl:choose>
                       <xsl:when test="journal_name=''"><xsl:value-of select="f:capitalize-first($journal_from_DOI)"/></xsl:when>
                       <xsl:otherwise><xsl:value-of select="journal_name"/></xsl:otherwise>
                   </xsl:choose>                    
                </title>
            </titleInfo>
            <originInfo>
                <publisher><xsl:value-of select="publisher"/></publisher>
            </originInfo>
        </relatedItem>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:capitalize-first</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:capitalize-first(XPath)</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>The f:capitalize-first function capitalizes the first character of $arg. If the first character is not a lowercase letter, $arg is left unchanged. It capitalizes only the first character of the entire string, not the first letter of every word<xd:i>f:capitalize-first</xd:i></xd:p>         </xd:desc>
        <xd:param name="arg"/>
    </xd:doc>
    <xsl:function name="f:capitalize-first" as="xs:string?" xmlns:f="http://functions">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:sequence select="concat(upper-case(substring($arg, 1,1)), substring($arg, 2,string-length($arg)))"/>
    </xsl:function>
    

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
    
 
    <xd:doc>
        <xd:desc><xd:p><xd:b>f:format-date()</xd:b></xd:p>
            <xd:p>Expects date format of MM/dd/YYYY </xd:p>
            <xd:p>Tokenizes forward slash in date string from parameter.</xd:p>
            <xd:p>Returns: YYYY-MM-dd w3cdtf format</xd:p>
        </xd:desc>
        <xd:param name="dateStr"/>
    </xd:doc>
    <xsl:function name="f:format-date">
        <xsl:param name="dateStr"/>
        <xsl:if test="not($dateStr = '')">
            <xsl:variable name="date-tokens" select="tokenize($dateStr, '/')"/>
            <xsl:sequence select="if (matches($date-tokens[3],'\d{4}'))
                then concat($date-tokens[last()], '-', format-number(number($date-tokens[2]), '00'), '-', format-number(number($date-tokens[1]), '00'))
                else if (matches($date-tokens[2],'\d{4}'))
                then concat($date-tokens[last()], '-', format-number(number($date-tokens[1]), '00'))
                else $dateStr"/>
        </xsl:if>
    </xsl:function>
    
    <!-- accessCondition -->
    <xd:doc id="accessCondition" scope="component">
        <xd:desc>Defined below are variables for creating and applying the appropriate license to a resource.</xd:desc>
        <xd:variable><xd:p><xd:b>nodes: </xd:b>Accesses the licenses.xml file</xd:p></xd:variable>
        <xd:variable><xd:p><xd:b>licenseURL: </xd:b>The XPath predicate filters out any URLs that render "null".</xd:p></xd:variable>
        <xd:variable><xd:p><xd:b>startDate: </xd:b>From reuse_license_start_date[@type='str'] to get start_date</xd:p></xd:variable>
        <xd:variable><xd:p><xd:b>label: </xd:b>Using an XPath predicate, compares the URL found in the node with the URLs contained within licenses.xml. When true the name of the license is returned as the value.</xd:p></xd:variable>
        <xd:vsriable><xd:p><xd:b>appliesTo:</xd:b>Uses XPath predicate to prevent "null" values, gets value from licesne_type</xd:p></xd:vsriable>
    </xd:doc>
    <xsl:template name="accessCondition">
        <xsl:if test="licenseUrl!=''">
            <xsl:variable name="nodes"><xsl:copy-of select="document('commons/licenses.xml')"/></xsl:variable>
            <xsl:variable name="licenseURL" select="licenseUrl[@type='str']"/>
            <xsl:variable name="startDate" select="f:format-date(reuse_license_start_date)"/> 
            <xsl:variable name="label" select="$nodes/accessRights/licenses/lic[u=$licenseURL]/a"/>
            <xsl:variable name="appliesTo" select="lower-case(license_type[@type='str'])"/>
            <!-- use and reproduction -->
            <accessCondition type="use and reproduction">
                <xsl:if test="$label!=''"><xsl:attribute name="displayLabel" select="$label"/></xsl:if>
                <program xmlns="https://data.crossref.org/schemas/AccessIndicators.xsd">
                    <license_ref>
                        <xsl:choose>
                            <xsl:when test="contains($licenseURL, '//creativecommons.org/')"><xsl:attribute name="applies_to">vor</xsl:attribute></xsl:when>
                            <xsl:otherwise>
                                <xsl:if test="$appliesTo!=''"><xsl:attribute name="applies_to"><xsl:value-of select="$appliesTo"/></xsl:attribute></xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="$startDate!=''"><xsl:attribute name="start_date" select="$startDate"/></xsl:if>
                        <xsl:value-of select="$licenseURL"/>
                    </license_ref>
                </program>
            </accessCondition>
            <!-- restriction on access -->
            <accessCondition type="restriction on access" xlink:href="http://purl.org/eprint/accessRights/OpenAccess" displayLabel="Access Status">Open Access</accessCondition>
        </xsl:if>
    </xsl:template>
    
       <xd:doc><xd:desc>originInfo</xd:desc></xd:doc>
       <xsl:template name="originInfo">
           <xsl:variable name="print" select="/all/published_print"/>
           <xsl:variable name="electronic" select="/all/published_online"/> 
           <xsl:variable name="preprint" select="/all/publicly_accessible_on_publisher_site"/>
           <xsl:variable name="reuse" select="/all/reuse_license_start_date"/>
           <originInfo>
               <xsl:apply-templates select="published_print"/>
               <xsl:apply-templates select="published_online"/>
               <xsl:if test="not($preprint = '') and ($print = '') and ($electronic = '')">
                   <xsl:apply-templates select="publicly_accessible_on_publisher_site"/>
               </xsl:if>
               <xsl:if test="not($reuse ='') and ($print = '') and ($electronic = '') and ($preprint = '')">
                   <xsl:apply-templates select="reuse_license_start_date"/>
               </xsl:if>
           </originInfo>
       </xsl:template>
    
    <xd:doc><xd:desc>published_print</xd:desc></xd:doc>
    <xsl:template match="published_print">
        <xsl:if test="not(. = '')">
            <dateIssued encoding="w3cdtf" keyDate="yes">
                <xsl:value-of select="f:format-date(.)"/>
            </dateIssued>
        </xsl:if>
    </xsl:template>
    
    <xd:doc><xd:desc>published_online</xd:desc></xd:doc>
    <xsl:template match="published_online">
        <xsl:variable name="print" select="/all/published_print"/>
        <xsl:choose>
            <xsl:when test="not(. = '') and ($print = '')">
                <dateIssued encoding="w3cdtf" keyDate="yes">
                    <xsl:value-of select="f:format-date(.)"/>
                </dateIssued>
            </xsl:when>
            <xsl:when test="not(. = '') and not($print = '')">
                <dateOther encoding="w3cdtf" type="electronic">
                    <xsl:value-of select="f:format-date(.)"/>
                </dateOther>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
 
    <!--   should preprint have ever be displayed as as
                <dateOther encoding="w3cdtf" type="preprint">
                given the chance there is a print date? 
                What if there is a "published_online" and a "publicly_accessible_on_publisher_site"
                but there is not a "published_print" date. 
                Is electronic the dateIssued?
             -->
    <xd:doc><xd:desc>publicly_accessible_on_publisher_site</xd:desc></xd:doc>
    <xsl:template match="publicly_accessible_on_publisher_site">
            <dateIssued encoding="w3cdtf" keyDate="yes">
                <xsl:value-of select="f:format-date(.)"/>
            </dateIssued>
    </xsl:template>
    
    <xd:doc><xd:desc>reuse_license_start_date</xd:desc></xd:doc>
    <xsl:template match="reuse_license_start_date">
          <dateIssued encoding="w3cdtf" keyDate="yes">
            <xsl:value-of select="f:format-date(.)"/>
        </dateIssued>
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
            <xsl:call-template name="execute_funders_template"/>
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
 
    <xd:doc>
        <xd:desc>
            <xd:p><xd:b>execute_funder_template:</xd:b></xd:p>
            <xd:p>Template parameters stores a count of &lt;item&gt; nodes contained  the within "three sibling" (funders, funderIDs, or RORID) nodes.</xd:p>
            <xd:p>One of three conditions is chosen based on their equivalency.</xd:p>
            <xd:p>More details are provided in the list below. The numbered list contains each template's mode name</xd:p>
            <xd:ul>
                <xd:li><xd:p><xd:b>(1) all_ids: </xd:b> ALL three sibling tags contain the same number of item tags, the funders will display both "doi" amd "ror" id.</xd:p></xd:li>
                <xd:li><xd:p><xd:b>(2) doi_only: </xd:b> If the number of funders and the number of DOI items is the same. The funder and the a link to the "doi" is provided.</xd:p></xd:li>
                <xd:li><xd:p><xd:b>(3) funders_only: </xd:b>Otherwise only the funders infomation is provided.</xd:p></xd:li>
<!--                <xd:li><xd:p><xd:b>(4) preliminary_reporting: </xd:b>The section commented below produces a report containing the number of items within each of the sibling tags.</xd:p></xd:li>-->
                <xd:li><xd:p>The funders item count is compared to both following-sibling::node()'s item count, the number is eauiov is equivalent to number of iteems to the count wthi the main , the XSLT developer knows that the institution name. </xd:p></xd:li>
            </xd:ul>
        </xd:desc> 
        <xd:param name="funder"/>
        <xd:param name="funderID"/>
        <xd:param name="RORIDs"/>
    </xd:doc>
    <xsl:template name="execute_funders_template">
        <xsl:param name="funder" select="count(funders/item)"/>
        <xsl:param name="funderID" select="count(funderIDs/item)"/>
        <xsl:param name="RORIDs" select="count(RORID/item)"/>   
        <xsl:choose>
            <xsl:when test="($funder = $funderID) and ($funder = $RORIDs)">
                <xsl:apply-templates select="funders" mode="all_ids"/> 
            </xsl:when>
            <xsl:when test="($funder = $funderID) and ($funder != $RORIDs)">
                <xsl:apply-templates select="funders" mode="doi_only"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="funders" mode="funders_only"/>
            </xsl:otherwise>
        </xsl:choose>  
       
         <!-- PRELIMINARY REPORTING TOOL: Counts the number of items contained with funders node. Then reports count of both following-sibling::node()
              TEMPLATE CONDTIONALLY EXECUTED:
                  (1) [Condition 1] When all three sibling nodes have an equal number of items. 
                  (2) [Condition 2] When funders and funderIDs have an equal number, but RORID does not.
                  (3) [Condition 3] If neither conidition is met the name/aconrym is displayed (without identifiers).
         
        <!-\- VARIABLE BUILDS REPORT -\->
               <xsl:variable name="report">
                    <xsl:text>&#10; &#160;</xsl:text>
                    <xsl:value-of select="concat('Funders: ', $funder)"/>
                    <xsl:text>&#10; &#160;</xsl:text>
                    <xsl:value-of select="concat('FunderIDs: ', $funderID)"/>
                    <xsl:text>&#10; &#160;</xsl:text>
                    <xsl:value-of select="concat('RORID: ', $RORIDs)"/>
                    <xsl:text>&#10; &#160;</xsl:text>
                </xsl:variable>
             
                <!-\- Produces Report to test item equivalence.
                Report is line with XML, see example below: 
                
          <!-/- <preliminary-report> 
                  Funders: 4
                  FunderIDs: 4
                  RORID: 4
               </preliminary-report>-/->
          
                  
                 <preliminary-report>
                    <xsl:value-of select="$report"/>
                </preliminary-report>
                 -\->-->
    </xsl:template>
    
    <xd:doc><xd:desc>breakdown_for</xd:desc></xd:doc>
    <xsl:template match="breakdown_for">
        <xsl:if test="not(. = '')">
            <note type="breakdown_for"><xsl:value-of select="."/></note>
        </xsl:if>
    </xsl:template>
    
    <!-- Conditional (1) "all_ids" -->
    <xd:doc><xd:desc><xd:p><xd:b>funders: </xd:b>&lt;institution&gt; name paired with &lt;institution_id&gt; (i.e., links to DOI and ROR id.)</xd:p></xd:desc></xd:doc>
    <xsl:template match="funders" mode="all_ids">
        <funding-group specific-use="crossref">
                <award-group> 
                    <funding-source>
                        <!-- institution -->
                    <xsl:for-each-group select="item" group-by="position()">
                            <xsl:variable name="i" select="current-grouping-key()"/>
                            <institution-wrap>
                                <institution>
                                    <xsl:value-of select="."/>                               
                                </institution>
                                <!-- institution_id -->
                                <xsl:for-each-group select="../following-sibling::node()" group-by="item[position()=$i]">
                                     <xsl:if test="current-grouping-key()!=' '">
                                         <institution_id type="{if (contains(.,'ror')) then 'ror' else if (matches(.,'10\.\d+/\d+')) then 'doi' else ''}">
                                             <xsl:value-of select="if (contains(current-grouping-key(),'ror')) then current-grouping-key() else if (starts-with(current-grouping-key(), '10.')) then concat('https://doi.org/', current-grouping-key()) else ''"/>
                                         </institution_id>
                                     </xsl:if>
                                </xsl:for-each-group>
                            </institution-wrap>
                        </xsl:for-each-group>
                    </funding-source>
                </award-group>
            </funding-group>
      </xsl:template>
    
   <!-- Conditional (2) "doi_only" -->  
    <xd:doc><xd:desc><xd:p><xd:b>funders: </xd:b>&lt;institution&gt; and &lt;institution_id&gt; (contain DOI) is displayed.</xd:p></xd:desc></xd:doc>
    <xsl:template match="funders" mode="doi_only">
        <funding-group specific-use="crossref">
            <award-group> 
                <funding-source>
                    <!-- institution -->
                    <xsl:for-each-group select="item" group-by="position()">
                        <xsl:variable name="i" select="current-grouping-key()"/>
                        <institution-wrap>                           
                            <institution>
                                <xsl:value-of select="."/>                               
                            </institution>
                            <!-- institution_id -->
                            <xsl:for-each-group select="../following-sibling::node()/item" group-by="item[position()=$i]">
                                <xsl:if test="matches(current-grouping-key(),'10\.\d+/\d++')">
                                    <institution_id type="doi"><xsl:value-of select="if (matches(.,'10\.\d+/\d+')) then concat('https://doi.org/', current-grouping-key()) else ''"/></institution_id>
                                </xsl:if>
                            </xsl:for-each-group>                                
                        </institution-wrap>
                    </xsl:for-each-group>
                </funding-source>
            </award-group>
        </funding-group>
    </xsl:template>
    
    <!-- Conditional (3) "funders_only" -->
    <xd:doc><xd:desc><xd:p><xd:b>funders: </xd:b>&lt;institution&gt; name only</xd:p></xd:desc></xd:doc>
    <xsl:template match="funders" mode="funders_only">
        <funding-group specific-use="crossref">
            <award-group> 
                <funding-source>
                    <!-- institution -->
                    <xsl:for-each select="item">
                        <institution-wrap>                           
                            <institution>
                                <xsl:value-of select="."/>                               
                            </institution>
                        </institution-wrap>
                    </xsl:for-each>
                </funding-source>
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
