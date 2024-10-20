- [CHORUS to MODSXSLT](#chorus-to-mods-xslt)
    -   [chorus_xml2mods.xslt](#chorus_xml2modsxslt)
    -   [XSLT Declaration](#xslt-declaration)
        -   [before](#before)
        -   [after](#after)
    -   [Root template](#root-template)
        -   [after](#after-1)
    -   [authors template](#authors-template)
        -   [before](#before-2)
        -   [after](#after-2)
    -   [ORCID template](#orcid-template)
        -   [before](#before-3)
        -   [after](#after-3)
    -   [Funders template](#funders-template)
        -   [before](#before-4)
        -   [after](#after-4)
  -   [xsl-for-each-group](#xsl-for-each-group)


# CHORUS to MODS XSLT 
Upon examining the source XML and the resulting MODS and then reviewing the XSLT, it became clear that this stylesheet version needed to be updated. The templates, functions, and processing instructions within the stylesheet also needed to be revised to prevent future transformation errors.  

## chorus_xml2mods.xslt
The chorus_to_mods.xsl transforms XML metadata from CHORUS into MODS 3.7. Recently, records appeared with missing author information, and various other parts of the record were not correctly transformed into MODS. Subsequently, when the transformed MODS metadata was transformed back into MARCXML, the same missing values were present in the MARC records. 

Updates are discussed below and in order as they would appear upon viewing any XSLT document:
[XSLT Declaration](#XSLT_Declaration)

The updates to this stylesheet are listed below: 

- Upgraded the XLST version from 1.0 to 2.0
- Removed XSLT 1.0 extension namespaces and functions from within the stylesheelk;

## XSLT Declaration

### before
```xml 
<?xml version="1.0" encoding="UTF-8"?>
updgraded: <xsl:stylesheet version="1.0 [replaced with] 2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.loc.gov/mods/v3"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
removed:        xmlns:f="http://functions"
removed:        xmlns:ex="http://exslt.org/dates-and-times"
removed:        xmlns:func="http://exslt.org/functions"
removed:        xmlns:exsl="http://exslt.org/common"
removed:        xmlns:str="http://exslt.org/strings"
removed:        extension-element-prefixes="ex"
updated:        exclude-result-prefixes="xd xs f xlink xsi ex str func exsl">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

removed:   <xsl:include href="commons/1.0/str.tokenize.function.xsl"/> 
```
### after
```xml
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.loc.gov/mods/v3"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:f="http://functions"
    exclude-result-prefixes="xd xs f xlink xsi">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
   ```

## Root template
#### before
```xml
  <xsl:template match="/">
  reconfigured & uncommented 
    uncommented:    <!-- <modsCollection>-->
    uncommented:   <!--  <xsl:for-each select="all/items/item">-->
    uncommented:    <!--  <mods xmlns="http://www.loc.gov/mods/v3"-->
    uncommented:    <!--        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="3.7"-->
    uncommented:        <!--    xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd"-->
    uncommented:      <!--      xmlns:xlink="http://www.w3.org/1999/xlink">-->
    uncommented: <!--                  <xsl:call-template name="item-info"/>-->
        
    uncommented:        <!--                </mods>-->
    uncommented:       <!--            </xsl:for-each>-->
    uncommented:     <!--        </modsCollection>-->
        <xsl:for-each select="all">
            <mods xmlns="http://www.loc.gov/mods/v3"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="3.7"
                xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd"
                xmlns:xlink="http://www.w3.org/1999/xlink">
                
                <xsl:call-template name="item-info"/>
            </mods>
        </xsl:for-each>
    </xsl:template>
 ```   

### after
 - Reconfigured XSLT to handle multiple CHORUS XML. 	
    -  Uncommented modsCollection and related sub-elements 
    - added `<xsl:choose>`PI and `<xsl:when test="count(all) != 1">
	 - Any document containing more than one `<all>`tag could be combined and transformed into a modsCollection. 
	 - The `<xsl:otherwise>` expects the usual standalone	CHORUS XML. 
```xml
<xsl:template match="/">
            <!-- collection processsing -->
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
                    <!-- standalone -->
                    <xsl:result-document href="{replace(base-uri(),'(.*/)(.*)(\.xml)', '$1')}N-{replace(base-uri(),'(.*/)(.*)(\.xml)', '$2')}_{position()}.xml">
                        <mods xmlns="http://www.loc.gov/mods/v3"
                            xmlns:mods="http://www.loc.gov/mods/v3"
                            xmlns:xlink="http://www.w3.org/1999/xlink"
                            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="3.7"
                            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd">
                            <xsl:call-template name="item-info"/>
                        </mods>
                    </xsl:result-document>
                </xsl:otherwise>
            </xsl:choose>
         </xsl:template>
  ```
 
## authors template
 ### before
  ```xml
        <xsl:template match="authors">
        <xsl:for-each select="item">
            <xsl:variable name="name-tokens" select="str:tokenize(author, ' ')"/>
            <!-- <xsl:variable name="given" select="normalize-space(substring-after(author, $name-tokens[1]))"/> -->
            <xsl:variable name="last" select="$name-tokens[1]"/>
            <xsl:variable name="first" select="$name-tokens[2]"/>
            <name type="personal">
                <xsl:if test="position() = 1">
                    <xsl:attribute name="usage">primary</xsl:attribute>
                </xsl:if>
                <!--                <namePart type="family">-->
                <!--                    <xsl:value-of select="$name-tokens[1]"/>-->
                <!--                </namePart>-->
                <!--                <namePart type="given">-->
                <!--                    <xsl:value-of select="$given"/>-->
                <!--                </namePart>-->
                <!--                <displayForm><xsl:value-of select="normalize-space($name-tokens[1])"/>, <xsl:value-of select="$given"/></displayForm> -->
                
                <namePart><xsl:value-of select="author"/></namePart>
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
```    
  
  ### after
#### $name-tokens positions
Chorus authors' name are separated by whitespace; thus, a whitespace can be used to tokenize each part of a name. The tokenization of these the `<author>` tag within the source XML lead to this consistent pattern. 
1. name-tokens[1] = last name
2. name-tokens[2] = first name
3. name-tokens[3] using substring-after $name-tokens[2], able to gather the remaining parts of the authors given name.  

 ```xml
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
                <xsl:variable name="givenName">  <!-- adds punctuation -->
                    <xsl:sequence select="if (matches($firstMiddle,'^.*[A-Z]$') and not(ends-with($firstMiddle,'.')))
                                          then concat($firstMiddle,'.')
                                          else $firstMiddle"/>
                </xsl:variable>
                <namePart type="given">
                     <xsl:value-of select="substring-before($givenName,' ')"/>
                </namePart>
                    <displayForm><xsl:value-of select="normalize-space(concat($familyName,',&#xa0;',$givenName))"/></displayForm>          
                <role>
                    <roleTerm type="text">author</roleTerm>
                </role>
                <xsl:apply-templates select="affiliation"/>
                <xsl:call-template name="orcid">
                    <xsl:with-param name="first" select="$firstMiddle"/>
                    <xsl:with-param name="last" select="$familyName"/>
                </xsl:call-template>
                </xsl:if>   
            </name>
        </xsl:for-each>
    </xsl:template>
  ```

Another issue with correcting the authors' name was punctuating names that had one or more initials in it, but lacked the proper punctuatation marks. 
Take the following example:
```xml
 <name type="personal" usage="primary">
         <namePart type="family">Maria</namePart>
         <namePart type="given">Naomi I</namePart>
         <displayForm>Maria, Naomi I</displayForm>
         <role>
            <roleTerm type="text">author</roleTerm>
         </role>
 ```
 
 Adding conditional expressions within the XPath allows for names with unpunctuated initials to be corrected. 
 ```xml
  <name type="personal" usage="primary">
         <namePart type="family">Maria</namePart>
         <namePart type="given">Naomi  I.</namePart>
         <dispSlayForm>Maria, Naomi I.</displayForm>
         <role>
            <roleTerm type="text">author</roleTerm>
         </role>`
```
   
 
## ORCID template
The ORCID ID template was also updated to correct the mapping into the author name template.
### before
 ```xml
        <xsl:param name="last"/>
      <xsl:param name="first"/>
      <xsl:if test= "not($last = '' and $first = '')">
          <xsl:for-each select="/all/orcid_profile/item">
              <xsl:if test="family[@type='str'] and family=$last and given=$first">
                  <nameIdentifier><xsl:value-of select="ORCID"/></nameIdentifier>
              </xsl:if>
          </xsl:for-each>
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
```

### after
The ORCID was mapped incorrectly into the a call-template with param instruction within the author name template.
```xml  
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
```  
## Funders template

The funders template leveraged institution identifiers in the source metadata. 
### before
Prior to the last update the name of the funding organization, award od 
  ```xml  
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
```    
  ### after
 Former
 Adds institution_id type="doi (type="ror" is commented out) 
 ```xml  
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
   ```
   ## xsl-for-each-group

   ```` xml
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
                <xd:li><xd:p><xd:b>(4) preliminary_reporting: </xd:b>The section commented below produces a report containing the number of items within each of the sibling tags.</xd:p></xd:li>
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
       
         <!-- PRELIMINARY REPORTING TOOL: Counts the number of items contained with funders node. 
         Then reports the number of items within the funders node and the number of items within
          the following-sibling::node()s
         
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
       
