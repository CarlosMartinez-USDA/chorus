# CHORUS to MODS XSLT 
Upon examining the source XML and the resulting MODS and then reviewing the XSLT, it became clear that this stylesheet version needed to be updated. The templates, functions, and processing instructions within the stylesheet also needed to be revised to prevent future transformation errors.  

## chorus_to_mods.xsl

The chorus_to_mods.xsl transforms XML metadata from CHORUS into MODS 3.7. 

Issue: recently empty author names have been appearing in the AGRICOLA sale filewith missing author information, and various other parts of the record were not correctly transformed into MODS. Subsequently, when the transformed MODS metadata was transformed back into MARCXML, the same missing values were present in the MARC records. 

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
                    <xsl:with-param name="first" select="$first"/> *updated*
 
                    <xsl:with-param name="first" select="if (contains($firstMiddle, ' ')) then substring-before($firstMiddle, ' ') else if 
                    (matches($firstMiddle,'/^(.*\s.*){2,}$/')) then replace($firstMiddle,'(\w+)(\s+)?([A-Z]\.)','$1') else normalize-space($firstMiddle)"/>
                   
                    <xsl:with-param name="last" select="$last"/>
                </xsl:call-template>
            </name>
        </xsl:for-each>
    </xsl:template>
```



  ### after and updated sections
#### $name-tokens positions
Chorus authors' name are separated by whitespace; thus, a whitespace can be used to tokenize each part of a name. The tokenization of these the `<author>` tag within the source XML lead to this consistent pattern.

10-10-2024 - orcid profile only uses the author's first name (not always the first name and middle initial), thus $firstMiddle was failing on several authors.
letter .d (below) provides more information about how this was resolved

1. name-tokens[1] = last name
2. name-tokens[2] = first name
3. name-tokens[3] using substring-after $name-tokens[2], able to gather the remaining parts of the authors given name.  
4. name-tokens explained:
 - $name-tokens[1] -  is the $familyName
 - $name-tokens[2] -  is the first name, or part of the $givenName			
 - $firstMiddle combines $names-token[2] and the rest of the string after it, for author's first name and middle initial
 - orcid_profile: &lt;xsl:with-param&gt; name="$first"> uses seperate template to build profile. The authors given $first name is compared to $firstMiddle (which combines the first and middle initial). The conditional XPath statement tries both first only and first and middle combined to get a match with $first (within the <orcid_profile>).

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
Eventually the ROR id section was uncommented and included for production output. 
Unfortunately, when orgnizations did not have both IDs present the hardcoded DOI link (i.e., https://doi.org/) was inaccurately concatenated. 
This first attempt to pair &lt;institution&&gt; with its respective &lt;institution_id&gt;'s resulted in error. 
 
The updated solution groups the institution with the institution_id. [Grouping](#grouping)
 ~~Adds institution_id type="doi (type="ror" is commented out)~~ 
 ```xml  
   ~~  <xd:doc><xd:desc>funders</xd:desc></xd:doc>
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
    </xsl:template>~~
   ```
## Grouping
```xml
  <!--  2024-10-09 AMB Team - Points for Discussion: 
        
        (1) Added <institution_ids>. Grouping with <institution> is position dependant! 
             - (i.e., Four funders items present, then four funderID and four RORID items MUST ALSO be present.)
             - Source XML honors this by creating placeholder tags for orgs when one of two valid identifiers is not available
             - see file [A-10.1097-dbp.0000000000001244.xml](https://github.com/CarlosMartinez-USDA/chorus/blob/master/x/xml/A-10.1097-dbp.0000000000001244.xml)

        (2) How should <insitution_id> display DOI? 
            -  <institution_id type="doi">10.13039/100000030</institution_id> (i.e., option 1)
            -  <institution_id type="doi">https://doi.org/10.13039/100000030</institution_id> (i.e., option 2) [x]
    -->
    
    <xd:doc><xd:desc><xd:p><xd:b>funders: </xd:b>Org name paired with DOI and ROR ids</xd:p></xd:desc></xd:doc>
    <xsl:template match="funders">
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
                                <xsl:if test="current-grouping-key()!=''">
                                    <institution_id type="{if (contains(.,'ror')) then 'ror' else if (matches(.,'10.\d+/\d+')) then 'doi' else ''}">
                                         <xsl:value-of select="if (matches(.,'10.\d+/\d+')) 
                                            then concat('https://doi.org/', current-grouping-key()) 
                                            else if (contains(current-grouping-key(), 'ror')) then current-grouping-key()
                                            else ''"/>                                        
                                    <institution_id>
                                </xsl:if>
                            </xsl:for-each-group>                                
                        </institution-wrap>
                    </xsl:for-each-group>
                </funding-source>
            </award-group>
        </funding-group>
    </xsl:template>
```
