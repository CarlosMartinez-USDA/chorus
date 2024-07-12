<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="mods xlink"
	xmlns:marc="http://www.loc.gov/MARC21/slim">
	<!-- MODS v3 to MARC21Slim transformation ntra 2/20/04 -->
	<!-- updated on 06/13/2012 by Carol Dowling -->
	<!-- updated on 06/27/2012 by Chuck Schoppet changed order of 773 subfields -->
  <!-- fixed prepare_author template, 07/12/2012 Carol Dowling  -->
  <!-- removed author affiliations (100$u and 700$u), 08/14/2012 Carol Dowling  -->
  <!-- removed 700$c, 08/23/2012 Carol Dowling  -->
  <!-- added support for 016, 070, 072, 910, 930, 945, 946 and 974; fixed 100 and 700 04/23/2014 LC -->
  <!-- Pull 100, 700 names from displayForm only 2014-07-30 CWS -->
  <!-- Only test for w3cdtf in originInfo/dateIssued 2016-06-22 jgg -->
  <!-- Use local supporting documents 2016-08-02 CWS -->

  <!--<xsl:include href="file:///app/PubData/xsl-transformations/LibraryOfCongress/MARC21slimUtils.xsl"/> -->
  <xsl:include href="http://www.loc.gov/marcxml/xslt/MARC21slimUtils.xsl"/> 
  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
   </xsl:template>

  <xsl:template match="collection">
    <marc:collection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/MARC21/slim file:///app/PubData/xsl-transformations/LibraryOfCongress/MARC21slimUtils.xsl">
<!--    <marc:collection xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd"> -->
      <xsl:apply-templates/>
    </marc:collection>
  </xsl:template>
  <!-- 1/04 fix -->
  <!--<xsl:template match="targetAudience/listValue" mode="ctrl008">-->
  <xsl:template match="targetAudience[@authority='marctarget']" mode="ctrl008">
    <xsl:choose>
      <xsl:when test=".='adolescent'">d</xsl:when>
      <xsl:when test=".='adult'">e</xsl:when>
      <xsl:when test=".='general'">g</xsl:when>
      <xsl:when test=".='juvenile'">j</xsl:when>
      <xsl:when test=".='preschool'">a</xsl:when>
      <xsl:when test=".='specialized'">f</xsl:when>
      <xsl:otherwise>
        <xsl:text>|</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="typeOfResource" mode="leader">
    <xsl:choose>
      <xsl:when test="text()='text' and @manuscript='yes'">t</xsl:when>
      <xsl:when test="text()='text'">a</xsl:when>
      <xsl:when test="text()='cartographic' and @manuscript='yes'">f</xsl:when>
      <xsl:when test="text()='cartographic'">e</xsl:when>
      <xsl:when test="text()='notated music' and @manuscript='yes'">d</xsl:when>
      <xsl:when test="text()='notated music'">c</xsl:when>
      <!-- v3 musical/non -->
      <xsl:when test="text()='sound recording-nonmusical'">i</xsl:when>
      <xsl:when test="text()='sound recording'">j</xsl:when>
      <xsl:when test="text()='sound recording-musical'">j</xsl:when>
      <xsl:when test="text()='still image'">k</xsl:when>
      <xsl:when test="text()='moving image'">g</xsl:when>
      <xsl:when test="text()='three dimensional object'">r</xsl:when>
      <xsl:when test="text()='software, multimedia'">m</xsl:when>
      <xsl:when test="text()='mixed material'">p</xsl:when>
      <xsl:otherwise>
        <xsl:text>|</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="typeOfResource" mode="ctrl008">
    <xsl:choose>
      <xsl:when test="text()='text' and @manuscript='yes'">BK</xsl:when>
      <xsl:when test="text()='text'">
        <xsl:choose>
          <xsl:when test="../originInfo/issuance='monographic'">BK</xsl:when>
          <xsl:when test="../originInfo/issuance='continuing'">SE</xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="text()='cartographic' and @manuscript='yes'">MP</xsl:when>
      <xsl:when test="text()='cartographic'">MP</xsl:when>
      <xsl:when test="text()='notated music' and @manuscript='yes'">MU</xsl:when>
      <xsl:when test="text()='notated music'">MU</xsl:when>
      <xsl:when test="text()='sound recording'">MU</xsl:when>
      <!-- v3 musical/non -->
      <xsl:when test="text()='sound recording-nonmusical'">MU</xsl:when>
      <xsl:when test="text()='sound recording-musical'">MU</xsl:when>
      <xsl:when test="text()='still image'">VM</xsl:when>
      <xsl:when test="text()='moving image'">VM</xsl:when>
      <xsl:when test="text()='three dimensional object'">VM</xsl:when>
      <xsl:when test="text()='software, multimedia'">CF</xsl:when>
      <xsl:when test="text()='mixed material'">MM</xsl:when>
      <xsl:otherwise>
        <xsl:text>|</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="controlField008-24-27">
    <xsl:variable name="chars">
      <xsl:for-each select="genre[@authority='marc']">
        <xsl:choose>
          <xsl:when test=".='abstract of summary'">a</xsl:when>
          <xsl:when test=".='bibliography'">b</xsl:when>
          <xsl:when test=".='catalog'">c</xsl:when>
          <xsl:when test=".='dictionary'">d</xsl:when>
          <xsl:when test=".='directory'">r</xsl:when>
          <xsl:when test=".='discography'">k</xsl:when>
          <xsl:when test=".='encyclopedia'">e</xsl:when>
          <xsl:when test=".='filmography'">q</xsl:when>
          <xsl:when test=".='handbook'">f</xsl:when>
          <xsl:when test=".='index'">i</xsl:when>
          <xsl:when test=".='law report or digest'">w</xsl:when>
          <xsl:when test=".='legal article'">g</xsl:when>
          <xsl:when test=".='legal case and case notes'">v</xsl:when>
          <xsl:when test=".='legislation'">l</xsl:when>
          <xsl:when test=".='patent'">j</xsl:when>
          <xsl:when test=".='programmed text'">p</xsl:when>
          <xsl:when test=".='review'">o</xsl:when>
          <xsl:when test=".='statistics'">s</xsl:when>
          <xsl:when test=".='survey of literature'">n</xsl:when>
          <xsl:when test=".='technical report'">t</xsl:when>
          <xsl:when test=".='theses'">m</xsl:when>
          <xsl:when test=".='treaty'">z</xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:call-template name="makeSize">
      <xsl:with-param name="string" select="$chars"/>
      <xsl:with-param name="length" select="4"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="controlField008-30-31">
    <xsl:variable name="chars">
      <xsl:for-each select="genre[@authority='marc']">
        <xsl:choose>
          <xsl:when test=".='biography'">b</xsl:when>
          <xsl:when test=".='conference publication'">c</xsl:when>
          <xsl:when test=".='drama'">d</xsl:when>
          <xsl:when test=".='essay'">e</xsl:when>
          <xsl:when test=".='fiction'">f</xsl:when>
          <xsl:when test=".='folktale'">o</xsl:when>
          <xsl:when test=".='history'">h</xsl:when>
          <xsl:when test=".='humor, satire'">k</xsl:when>
          <xsl:when test=".='instruction'">i</xsl:when>
          <xsl:when test=".='interview'">t</xsl:when>
          <xsl:when test=".='language instruction'">j</xsl:when>
          <xsl:when test=".='memoir'">m</xsl:when>
          <xsl:when test=".='rehersal'">r</xsl:when>
          <xsl:when test=".='reporting'">g</xsl:when>
          <xsl:when test=".='sound'">s</xsl:when>
          <xsl:when test=".='speech'">l</xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:call-template name="makeSize">
      <xsl:with-param name="string" select="$chars"/>
      <xsl:with-param name="length" select="2"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="makeSize">
    <xsl:param name="string"/>
    <xsl:param name="length"/>
    <xsl:variable name="nstring" select="normalize-space($string)"/>
    <xsl:variable name="nstringlength" select="string-length($nstring)"/>
    <xsl:choose>
      <xsl:when test="$nstringlength&gt;$length">
        <xsl:value-of select="substring($nstring,1,$length)"/>
      </xsl:when>
      <xsl:when test="$nstringlength&lt;$length">
        <xsl:value-of select="$nstring"/>
        <xsl:call-template name="buildSpaces">
          <xsl:with-param name="spaces" select="$length - $nstringlength"/>
          <xsl:with-param name="char">|</xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$nstring"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="mods">
    <marc:record>
      <marc:leader>
        <!-- 00-04 -->
        <xsl:text>     </xsl:text>
        <!-- 05 -->
        <!-- changed by CD -->
        <!-- when Voyager bib_id exists, use 'c', otherwise 'n' -->
        <xsl:choose>
          <xsl:when test="recordInfo/recordIdentifier">
            <xsl:text>c</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>n</xsl:text>
          </xsl:otherwise>
        </xsl:choose>

        <!-- 06 -->
        <xsl:apply-templates mode="leader" select="typeOfResource[1]"/>
        <!-- 07 -->
        <xsl:choose>
          <xsl:when test="originInfo/issuance='monographic'">m</xsl:when>
          <xsl:when test="originInfo/issuance='continuing'">s</xsl:when>
          <xsl:when test="typeOfResource/@collection='yes'">c</xsl:when>
<!-- changed by CD -->
          <xsl:otherwise>a</xsl:otherwise>
        </xsl:choose>




        <!-- 08 -->
        <xsl:text> </xsl:text>
        <!-- 09 changed by CD -->
        <xsl:text>a</xsl:text>
        <!-- 10 -->
        <xsl:text>2</xsl:text>
        <!-- 11 -->
        <xsl:text>2</xsl:text>
        <!-- 12-16 -->
        <xsl:text>     </xsl:text>
        <!-- 17 changed by CD -->
        <xsl:text> </xsl:text>
        <!-- 18 changed by CD -->
        <xsl:text> </xsl:text>
        <!-- 19 -->
        <xsl:text> </xsl:text>
        <!-- 20-23 -->
        <xsl:text>4500</xsl:text>
      </marc:leader>
      <xsl:call-template name="controlRecordInfo"/>
      <xsl:if test="genre[@authority='marc']='atlas'">
        <marc:controlfield tag="007">ad||||||</marc:controlfield>
      </xsl:if>
      <xsl:if test="genre[@authority='marc']='model'">
        <marc:controlfield tag="007">aq||||||</marc:controlfield>
      </xsl:if>
      <xsl:if test="genre[@authority='marc']='remote sensing image'">
        <marc:controlfield tag="007">ar||||||</marc:controlfield>
      </xsl:if>
      <xsl:if test="genre[@authority='marc']='map'">
        <marc:controlfield tag="007">aj||||||</marc:controlfield>
      </xsl:if>
      <xsl:if test="genre[@authority='marc']='globe'">
        <marc:controlfield tag="007">d|||||</marc:controlfield>
      </xsl:if>
      <marc:controlfield tag="008">
        <xsl:variable name="typeOf008">
          <xsl:apply-templates mode="ctrl008" select="typeOfResource"/>
        </xsl:variable>
        <!-- 00-05 -->
        <xsl:choose>
          <!-- 1/04 fix -->
          <!-- changed by CD -->
          <!-- updated by CWS 2013/04/17 2014 -->
          <xsl:when test="recordInfo/recordCreationDate[@encoding='w3cdtf']">
            <xsl:value-of select="substring(recordInfo/recordCreationDate,3,2)"/>
            <xsl:value-of select="substring(recordInfo/recordCreationDate,6,2)"/>
            <xsl:value-of select="substring(recordInfo/recordCreationDate,9,2)"/>
          </xsl:when>
          <xsl:when test="recordInfo/recordCreationDate[@encoding='marc']">
            <xsl:value-of select="recordInfo/recordCreationDate[@encoding='marc']"/>
          </xsl:when>
          <xsl:when test="recordInfo/recordCreationDate">
            <xsl:value-of select="substring(recordInfo/recordCreationDate,3,2)"/>
            <xsl:value-of select="substring(recordInfo/recordCreationDate,6,2)"/>
            <xsl:value-of select="substring(recordInfo/recordCreationDate,9,2)"/>
          </xsl:when>
          <xsl:when test="extension/processingDate[@encoding='w3cdtf']">
            <xsl:value-of select="substring(extension/processingDate,3,2)"/>
            <xsl:value-of select="substring(extension/processingDate,6,2)"/>
            <xsl:value-of select="substring(extension/processingDate,9,2)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>      </xsl:text>
          </xsl:otherwise>
        </xsl:choose>




        <!-- 06 -->
        <xsl:choose>
          <xsl:when test="originInfo/issuance='monographic' and count(originInfo/dateIssued)=1">s</xsl:when>
          <!-- v3 questionable -->
          <xsl:when test="originInfo/dateIssued[@qualifier='questionable']">q</xsl:when>
          <xsl:when test="originInfo/issuance='monographic' and originInfo/dateIssued[@point='start'] and originInfo/dateIssued[@point='end']">m</xsl:when>
          <xsl:when test="originInfo/issuance='continuing' and originInfo/dateIssued[@point='end' and @encoding='marc']='9999'">c</xsl:when>
          <xsl:when test="originInfo/issuance='continuing' and originInfo/dateIssued[@point='end' and @encoding='marc']='uuuu'">u</xsl:when>
          <xsl:when test="originInfo/issuance='continuing' and originInfo/dateIssued[@point='end' and @encoding='marc']">d</xsl:when>
          <!-- changed by CD  -->
          <xsl:when test="not(originInfo/issuance) and string-length(originInfo/dateIssued[@encoding='w3cdtf'])= 4">s</xsl:when>
          <xsl:when test="not(originInfo/issuance) and string-length(originInfo/dateIssued[@encoding='w3cdtf'])&gt; 4">e</xsl:when>
          <!-- v3 copyright date-->
          <xsl:when test="originInfo/copyrightDate">s</xsl:when>
          <xsl:otherwise>|</xsl:otherwise>
        </xsl:choose>
        <!-- 07-14          -->
        <!-- CD Modified 07-10 and 11-14 to adhere to NAL indexing practices  -->
        <xsl:choose>
            <xsl:when test="string-length(originInfo/dateIssued[@encoding='w3cdtf'])= 10" >
            <xsl:value-of select="translate(originInfo/dateIssued, translate(originInfo/dateIssued,
              '0123456789', ''), '')"/>
          </xsl:when>
          <xsl:when test="string-length(originInfo/dateIssued[@encoding='w3cdtf'])= 7" >
            <xsl:value-of select="translate(originInfo/dateIssued, translate(originInfo/dateIssued,
              '0123456789', ''), '')"/><xsl:text>  </xsl:text>
          </xsl:when>
          <xsl:when test="string-length(originInfo/dateIssued[@encoding='w3cdtf'])= 4" >
            <xsl:value-of select="translate(originInfo/dateIssued, translate(originInfo/dateIssued,
              '0123456789', ''), '')"/><xsl:text>    </xsl:text>
          </xsl:when>
  <!--   2016-06-22 jgg     <xsl:otherwise>
            <xsl:text>          </xsl:text>  added 2 bytes for marc encoded dates JG 09/08/15
          </xsl:otherwise> -->
        </xsl:choose>
        <!-- 11-14 -->
<!--        <xsl:choose>
          <xsl:when test="originInfo/dateIssued[@point='end' and @encoding='marc']">
            <xsl:value-of select="originInfo/dateIssued[@point='end' and @encoding='marc']"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>    </xsl:text>
          </xsl:otherwise>
        </xsl:choose>    -->
        <!-- 15-17 -->
        <xsl:choose>
          <!-- v3 place -->
          <xsl:when test="originInfo/place/placeTerm[@type='code'][@authority='marccountry']">
            <!-- v3 fixed marc:code reference and authority change-->
            <xsl:value-of select="originInfo/place/placeTerm[@type='code'][@authority='marccountry']"/>
            <!-- 1/04 fix -->
            <xsl:if test="string-length(originInfo/place/placeTerm[@type='code'][@authority='marccountry'])=2">
              <xsl:text> </xsl:text>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>   </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <!-- 18-20 -->
        <xsl:text>|||</xsl:text>
        <!-- 21 -->
        <xsl:choose>
          <xsl:when test="$typeOf008='SE'">
            <xsl:choose>
              <xsl:when test="genre[@authority='marc']='database'">d</xsl:when>
              <xsl:when test="genre[@authority='marc']='loose-leaf'">l</xsl:when>
              <xsl:when test="genre[@authority='marc']='newspaper'">n</xsl:when>
              <xsl:when test="genre[@authority='marc']='periodical'">p</xsl:when>
              <xsl:when test="genre[@authority='marc']='series'">m</xsl:when>
              <xsl:when test="genre[@authority='marc']='web site'">w</xsl:when>
              <xsl:otherwise>|</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>|</xsl:otherwise>
        </xsl:choose>
        <!-- 22 -->
        <!-- 1/04 fix -->
        <xsl:choose>
          <xsl:when test="targetAudience[@authority='marctarget']">
            <xsl:apply-templates mode="ctrl008" select="targetAudience[@authority='marctarget']"/>
          </xsl:when>
          <xsl:otherwise>|</xsl:otherwise>
        </xsl:choose>
        <!-- 23 -->
        <xsl:choose>
          <xsl:when test="$typeOf008='BK' or $typeOf008='MU' or $typeOf008='SE' or $typeOf008='MM'">
            <xsl:choose>
              <xsl:when test="physicalDescription/form[@authority='marcform']='braille'">f</xsl:when>
              <xsl:when test="physicalDescription/form[@authority='marcform']='electronic'">s</xsl:when>
              <xsl:when test="physicalDescription/form[@authority='marcform']='microfiche'">b</xsl:when>
              <xsl:when test="physicalDescription/form[@authority='marcform']='microfilm'">a</xsl:when>
              <xsl:when test="physicalDescription/form[@authority='marcform']='print'">
                <xsl:text> </xsl:text>
              </xsl:when>
              <xsl:otherwise>|</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>|</xsl:otherwise>
        </xsl:choose>
        <!-- 24-27 -->
        <xsl:choose>
          <xsl:when test="$typeOf008='BK'">
            <xsl:call-template name="controlField008-24-27"/>
          </xsl:when>
          <xsl:when test="$typeOf008='MP'">
            <xsl:text>|</xsl:text>
            <xsl:choose>
              <xsl:when test="genre[@authority='marc']='atlas'">e</xsl:when>
              <xsl:when test="genre[@authority='marc']='globe'">d</xsl:when>
              <xsl:otherwise>|</xsl:otherwise>
            </xsl:choose>
            <xsl:text>||</xsl:text>
          </xsl:when>
          <xsl:when test="$typeOf008='CF'">
            <xsl:text>||</xsl:text>
            <xsl:choose>
              <xsl:when test="genre[@authority='marc']='database'">e</xsl:when>
              <xsl:when test="genre[@authority='marc']='font'">f</xsl:when>
              <xsl:when test="genre[@authority='marc']='game'">g</xsl:when>
              <xsl:when test="genre[@authority='marc']='numerical data'">a</xsl:when>
              <xsl:when test="genre[@authority='marc']='sound'">h</xsl:when>
              <xsl:otherwise>|</xsl:otherwise>
            </xsl:choose>
            <xsl:text>|</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>||||</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <!-- 28 -->
        <xsl:text>|</xsl:text>
        <!-- 29 -->
        <xsl:choose>
          <xsl:when test="$typeOf008='BK' or $typeOf008='SE'">
            <xsl:choose>
              <xsl:when test="genre[@authority='marc']='conference publication'">1</xsl:when>
              <xsl:otherwise>|</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$typeOf008='MP' or $typeOf008='VM'">
            <xsl:choose>
              <xsl:when test="physicalDescription/form='braille'">f</xsl:when>
              <xsl:when test="physicalDescription/form='electronic'">m</xsl:when>
              <xsl:when test="physicalDescription/form='microfiche'">b</xsl:when>
              <xsl:when test="physicalDescription/form='microfilm'">a</xsl:when>
              <xsl:when test="physicalDescription/form='print'">
                <xsl:text> </xsl:text>
              </xsl:when>
              <xsl:otherwise>|</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>|</xsl:otherwise>
        </xsl:choose>
        <!-- 30-31 -->
        <xsl:choose>
          <xsl:when test="$typeOf008='MU'">
            <xsl:call-template name="controlField008-30-31"/>
          </xsl:when>
          <xsl:when test="$typeOf008='BK'">
            <xsl:choose>
              <xsl:when test="genre[@authority='marc']='festschrift'">1</xsl:when>
              <xsl:otherwise>|</xsl:otherwise>
            </xsl:choose>
            <xsl:text>|</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>||</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <!-- 32 -->
        <xsl:text>|</xsl:text>
        <!-- 33 -->
        <xsl:choose>
          <xsl:when test="$typeOf008='VM'">
            <xsl:choose>
              <xsl:when test="genre[@authority='marc']='art originial'">a</xsl:when>
              <xsl:when test="genre[@authority='marc']='art reproduction'">c</xsl:when>
              <xsl:when test="genre[@authority='marc']='chart'">n</xsl:when>
              <xsl:when test="genre[@authority='marc']='diorama'">d</xsl:when>
              <xsl:when test="genre[@authority='marc']='filmstrip'">f</xsl:when>
              <xsl:when test="genre[@authority='marc']='flash card'">o</xsl:when>
              <xsl:when test="genre[@authority='marc']='graphic'">k</xsl:when>
              <xsl:when test="genre[@authority='marc']='kit'">b</xsl:when>
              <xsl:when test="genre[@authority='marc']='technical drawing'">l</xsl:when>
              <xsl:when test="genre[@authority='marc']='slide'">s</xsl:when>
              <xsl:when test="genre[@authority='marc']='realia'">r</xsl:when>
              <xsl:when test="genre[@authority='marc']='picture'">i</xsl:when>
              <xsl:when test="genre[@authority='marc']='motion picture'">m</xsl:when>
              <xsl:when test="genre[@authority='marc']='model'">q</xsl:when>
              <xsl:when test="genre[@authority='marc']='microscope slide'">p</xsl:when>
              <xsl:when test="genre[@authority='marc']='toy'">w</xsl:when>
              <xsl:when test="genre[@authority='marc']='transparency'">t</xsl:when>
              <xsl:when test="genre[@authority='marc']='videorecording'">v</xsl:when>
              <xsl:otherwise>|</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:when test="$typeOf008='BK'">
            <xsl:choose>
              <xsl:when test="genre[@authority='marc']='comic strip'">c</xsl:when>
              <xsl:when test="genre[@authority='marc']='fiction'">1</xsl:when>
              <xsl:when test="genre[@authority='marc']='essay'">e</xsl:when>
              <xsl:when test="genre[@authority='marc']='drama'">d</xsl:when>
              <xsl:when test="genre[@authority='marc']='humor, satire'">h</xsl:when>
              <xsl:when test="genre[@authority='marc']='letter'">i</xsl:when>
              <xsl:when test="genre[@authority='marc']='novel'">f</xsl:when>
              <xsl:when test="genre[@authority='marc']='short story'">j</xsl:when>
              <xsl:when test="genre[@authority='marc']='speech'">s</xsl:when>
              <xsl:otherwise>|</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>|</xsl:otherwise>
        </xsl:choose>
        <!-- 34 -->
        <xsl:choose>
          <xsl:when test="$typeOf008='BK'">
            <xsl:choose>
              <xsl:when test="genre[@authority='marc']='biography'">d</xsl:when>
              <xsl:otherwise>|</xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>|</xsl:otherwise>
        </xsl:choose>
        <!-- 35-37 -->
        <xsl:choose>
          <!-- v3 language -->
          <xsl:when test="language/languageTerm[@authority='iso639-2b']">
            <xsl:value-of select="language/languageTerm[@authority='iso639-2b']"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>|||</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <!-- 38-39 -->
        <!-- changed by CD -->
        <xsl:text>| </xsl:text>
      </marc:controlfield>
      <!-- 1/04 fix sort -->
      <xsl:call-template name="source"/>
      <xsl:apply-templates/>
      <xsl:if test="classification[@authority='lcc']">
        <xsl:call-template name="lcClassification"/>
      </xsl:if>
      <!-- LC note templates -->
      <xsl:call-template name="note910"/>
      <xsl:call-template name="note930"/>
      <xsl:call-template name="note945"/>
      <xsl:call-template name="note946"/>
      <xsl:call-template name="note974"/>
    </marc:record>
  </xsl:template>

  <xsl:template match="*"/>

  <!-- v3 language -->
  <xsl:template match="language/languageTerm[@authority='iso639-2b']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">041</xsl:with-param>
      <xsl:with-param name="ind1">0</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code='a'>
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- v3 language -->
  <xsl:template match="language/languageTerm[@authority='rfc3066']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">041</xsl:with-param>
      <xsl:with-param name="ind1">0</xsl:with-param>
      <xsl:with-param name="ind2">7</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code='a'>
          <xsl:value-of select="."/>
        </marc:subfield>
        <marc:subfield code='2'>rfc3066</marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- 1/04 fix -->
  <!--	<xsl:template match="targetAudience">
		<xsl:apply-templates/>
	</xsl:template>-->

  <!--<xsl:template match="targetAudience/otherValue"> -->
  <xsl:template match="targetAudience[not(@authority)] | targetAudience[@authority!='marctarget']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">521</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code='a'>
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="physicalDescription">
    <xsl:apply-templates/>
  </xsl:template>
  <!-- 1/04 fix -->
  <!--<xsl:template match="physicalDescription/extent">-->
  <xsl:template match="extent">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">300</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code='a'>
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="note[not(@type='statement of responsibility')]">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">
        <xsl:choose>
          <xsl:when test="@type='performers'">511</xsl:when>
          <xsl:when test="@type='venue'">518</xsl:when>
          <!-- JG add 504 note -->
          <xsl:when test="@type='bibliography'">504</xsl:when>
          <xsl:otherwise>500</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code='a'>
          <xsl:value-of select="."/>
        </marc:subfield>
        <!-- 1/04 fix: 856$u instead -->
        <!--<xsl:for-each select="@xlink:href">
					<marc:subfield code='u'>
						<xsl:value-of select="."/>
					</marc:subfield>
				</xsl:for-each>-->

      </xsl:with-param>
    </xsl:call-template>
    <xsl:for-each select="@xlink:href">
      <xsl:call-template name="datafield">
        <xsl:with-param name="tag">856</xsl:with-param>
        <xsl:with-param name="subfields">
          <marc:subfield code='u'>
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>
  <!-- 1/04 fix -->
  <!--<xsl:template match="note[@type='statement of responsibility']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">245</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code='c'>
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
-->
  <xsl:template match="accessCondition">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">
        <xsl:choose>
          <xsl:when test="@type='restrictionOnAccess'">506</xsl:when>
          <xsl:when test="@type='useAndReproduction'">540</xsl:when>
          <xsl:when test="@type='use and reproduction'">540</xsl:when>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code='a'>
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- 1/04 fix -->
  <xsl:template name="controlRecordInfo">
    <!--<xsl:template match="recordInfo">-->
    <xsl:for-each select="recordInfo/recordIdentifier">
      <marc:controlfield tag="001">
        <xsl:value-of select="."/>
      </marc:controlfield>
      <xsl:for-each select="@source">
        <marc:controlfield tag="003">
          <xsl:value-of select="."/>
        </marc:controlfield>
      </xsl:for-each>
    </xsl:for-each>
    <xsl:for-each select="recordInfo/recordChangeDate[@encoding='iso8601']">
      <marc:controlfield tag="005">
        <xsl:value-of select="."/>
      </marc:controlfield>
    </xsl:for-each>
  </xsl:template>
  <!-- v3 authority -->

  <xsl:template name="source">
<!-- modified by CD  <xsl:for-each select="recordInfo/recordContentSource[@authority='marcorg']">  -->
      <xsl:call-template name="datafield">
        <xsl:with-param name="tag">040</xsl:with-param>
        <xsl:with-param name="subfields">
          <marc:subfield code="a">AGL</marc:subfield>
        </xsl:with-param>
      </xsl:call-template>
<!--    </xsl:for-each>  -->
  </xsl:template>
  <!-- removed by CD  May want to include  -->
 <!--   <xsl:template match="genre[@authority!='marc' or not(@authority)]">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">655</xsl:with-param>
      <xsl:with-param name="ind2">7</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code='a'>
          <xsl:value-of select="."/>
        </marc:subfield>
        <xsl:for-each select="@authority">
          <marc:subfield code='2'>
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>  -->


  <!-- v3 geographicCode -->
  <xsl:template match="subject/geographicCode[@authority]">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">043</xsl:with-param>
      <xsl:with-param name="subfields">
        <xsl:for-each select="self::geographicCode[@authority='marcgac']">
          <marc:subfield code='a'>
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
        <xsl:for-each select="self::geographicCode[@authority='iso3166']">
          <marc:subfield code='c'>
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="originInfo">
    <!-- v3 place, and fixed "placeCode (v1?) -->
    <xsl:for-each select="place/placeTerm[@type='code'][@authority='iso3166']">
      <xsl:call-template name="datafield">
        <xsl:with-param name="tag">044</xsl:with-param>
        <xsl:with-param name="subfields">
          <marc:subfield code='c'>
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
    <!-- v3 dates -->
    <xsl:if test="dateModified|dateCreated|dateValid">
      <xsl:call-template name="datafield">
        <xsl:with-param name="tag">046</xsl:with-param>
        <xsl:with-param name="subfields">
          <xsl:for-each select="dateModified">
            <marc:subfield code='j'>
              <xsl:value-of select="."/>
            </marc:subfield>
          </xsl:for-each>
          <xsl:for-each select="dateCreated[@point='start']|dateCreated[not(@point)]">
            <marc:subfield code='k'>
              <xsl:value-of select="."/>
            </marc:subfield>
          </xsl:for-each>
          <xsl:for-each select="dateCreated[@point='end']">
            <marc:subfield code='l'>
              <xsl:value-of select="."/>
            </marc:subfield>
          </xsl:for-each>
          <xsl:for-each select="dateValid[@point='start']|dateValid[not(@point)]">
            <marc:subfield code='m'>
              <xsl:value-of select="."/>
            </marc:subfield>
          </xsl:for-each>
          <xsl:for-each select="dateValid[@point='end']">
            <marc:subfield code='n'>
              <xsl:value-of select="."/>
            </marc:subfield>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:for-each select="edition">
      <xsl:call-template name="datafield">
        <xsl:with-param name="tag">250</xsl:with-param>
        <xsl:with-param name="subfields">
          <marc:subfield code='a'>
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="frequency">
      <xsl:call-template name="datafield">
        <xsl:with-param name="tag">310</xsl:with-param>
        <xsl:with-param name="subfields">
          <marc:subfield code='a'>
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>

<!-- Removed by CD
      <xsl:call-template name="datafield">
      <xsl:with-param name="tag">260</xsl:with-param>
      <xsl:with-param name="subfields">   -->
        <!-- v3 place; changed to text  -->
<!--       <xsl:for-each select="place/placeTerm[@type='text']">
          <marc:subfield code='a'>
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
        <xsl:for-each select="publisher">
          <marc:subfield code='b'>
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
        <xsl:for-each select="dateIssued">
          <marc:subfield code='c'>
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
        <xsl:for-each select="dateCreated">
          <marc:subfield code='g'>
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>   -->
  </xsl:template>

  <xsl:template match="titleInfo[@type='abbreviated']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">210</xsl:with-param>
      <xsl:with-param name="ind1">1</xsl:with-param>
      <xsl:with-param name="subfields">
        <xsl:call-template name="titleInfo"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="titleInfo[@type='translated']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">242</xsl:with-param>
      <xsl:with-param name="ind1">1</xsl:with-param>
      <xsl:with-param name="ind2" select="string-length(nonSort)"/>
      <xsl:with-param name="subfields">
        <xsl:call-template name="titleInfo"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="titleInfo[@type='alternative']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">246</xsl:with-param>
      <xsl:with-param name="ind1">3</xsl:with-param>
      <xsl:with-param name="subfields">
        <xsl:call-template name="titleInfo"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="titleInfo[@type='uniform'][1]">
    <xsl:choose>
      <!-- v3 role -->
      <xsl:when test="../name/role/roleTerm[@type='text']='creator' or name/role/roleTerm[@type='code']='cre'">
        <xsl:call-template name="datafield">
          <xsl:with-param name="tag">240</xsl:with-param>
          <xsl:with-param name="ind1">1</xsl:with-param>
          <xsl:with-param name="ind2" select="string-length(nonSort)"/>
          <xsl:with-param name="subfields">
            <xsl:call-template name="titleInfo"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="datafield">
          <xsl:with-param name="tag">130</xsl:with-param>
          <xsl:with-param name="ind1" select="string-length(nonSort)"/>
          <xsl:with-param name="subfields">
            <xsl:call-template name="titleInfo"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- 1/04 fix: 2nd uniform title to 730 -->
  <xsl:template match="titleInfo[@type='uniform'][position()>1]">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">730</xsl:with-param>
      <xsl:with-param name="ind1" select="string-length(nonSort)"/>
      <xsl:with-param name="subfields">
        <xsl:call-template name="titleInfo"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- 1/04 fix -->

  <!--<xsl:template match="titleInfo[not(ancestor-or-self::subject)][not(@type)]">-->
  <xsl:template match="titleInfo[not(ancestor-or-self::subject)][not(@type)][1]">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">245</xsl:with-param>
      <xsl:with-param name="ind1">1</xsl:with-param>
      <xsl:with-param name="ind2" select="string-length(nonSort)"/>
      <xsl:with-param name="subfields">
        <xsl:call-template name="titleInfo"/>
        <!-- 1/04 fix -->
        <xsl:call-template name="stmtOfResponsibility"/>
        <xsl:call-template name="form"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="titleInfo[not(ancestor-or-self::subject)][not(@type)][position()>1]">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">246</xsl:with-param>
      <xsl:with-param name="ind1">3</xsl:with-param>
      <xsl:with-param name="subfields">
        <xsl:call-template name="titleInfo"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="abstract">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">520</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
        <xsl:for-each select="@xlink:href">
          <marc:subfield code="u">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="tableOfContents">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">505</xsl:with-param>
      <xsl:with-param name="ind1">0</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
        <xsl:for-each select="@xlink:href">
          <marc:subfield code="u">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="subject">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- 1/04 fix was 630 -->
  <xsl:template match="subject/heirarchialGeographic">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">752</xsl:with-param>
      <xsl:with-param name="subfields">
        <xsl:for-each select="country">
          <marc:subfield code="a">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
        <xsl:for-each select="state">
          <marc:subfield code="b">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
        <xsl:for-each select="county">
          <marc:subfield code="c">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
        <xsl:for-each select="city">
          <marc:subfield code="d">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="subject/cartographics">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">255</xsl:with-param>
      <xsl:with-param name="subfields">
        <xsl:for-each select="coordinates">
          <marc:subfield code="c">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
        <xsl:for-each select="scale">
          <marc:subfield code="a">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
        <xsl:for-each select="projection">
          <marc:subfield code="b">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="titleInfo">
    <xsl:for-each select="title">
      <marc:subfield code="a">
        <xsl:value-of select="../nonSort"/>
        <xsl:value-of select="."/>
        <!-- CD Need to add period at end of 245.  Shouldn't add if there is a $h.  Need to check for existing punctuation first.
               <xsl:text>.</xsl:text>  -->
      </marc:subfield>
    </xsl:for-each>
    <!-- 1/04 fix -->
    <xsl:for-each select="subTitle">
      <marc:subfield code="b">
        <xsl:value-of select="."/>
      </marc:subfield>
    </xsl:for-each>

    <!-- CD adds 245$h  -->
    <!-- JG modified 05/09/14 -->
    <xsl:choose>
    <xsl:when test="../physicalDescription/form[@authority='gmd']">
      <xsl:apply-templates select="form"/>
    </xsl:when>
      <xsl:otherwise>
      <marc:subfield code="h">
        <xsl:text>[electronic resource].</xsl:text>
      </marc:subfield>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:for-each select="partNumber">
      <marc:subfield code="n">
        <xsl:value-of select="."/>
      </marc:subfield>
    </xsl:for-each>

    <xsl:for-each select="partName">
      <marc:subfield code="p">
        <xsl:value-of select="."/>
      </marc:subfield>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="stmtOfResponsibility">
    <xsl:for-each select="following-sibling::note[@type='statement of responsibility']">
      <marc:subfield code='c'>
        <xsl:value-of select="."/>
      </marc:subfield>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="lcClassification">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">050</xsl:with-param>
      <xsl:with-param name="ind2">
        <xsl:choose>
          <xsl:when test="../recordInfo/recordContentSource='DLC' or ../recordInfo/recordContentSource='Library of Congress'">0</xsl:when>
          <xsl:otherwise>2</xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
      <xsl:with-param name="subfields">
        <xsl:for-each select="classification[@authority='lcc']">
          <marc:subfield code="a">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>

  </xsl:template>

  <!--<xsl:template match="classification[@authority='lcc']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">050</xsl:with-param>
			<xsl:with-param name="ind2">
				<xsl:choose>
				<xsl:when test="../recordInfo/recordContentSource='DLC' or ../recordInfo/recordContentSource='Library of Congress'">0</xsl:when>
				<xsl:otherwise>2</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="a">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
-->

  <xsl:template match="classification[@authority='ddc']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">082</xsl:with-param>
      <xsl:with-param name="ind1">0</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
        <xsl:for-each select="@edition">
          <marc:subfield code="2">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="classification[@authority='udc']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">080</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="classification[@authority='nlm']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">060</xsl:with-param>
      <xsl:with-param name="ind2">4</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="classification[@authority='sudocs']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">086</xsl:with-param>
      <xsl:with-param name="ind1">0</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="classification[@authority='candocs']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">086</xsl:with-param>
      <xsl:with-param name="ind1">1</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- LC nal classification  -->
  <xsl:template match="classification[@authority='nal']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">070</xsl:with-param>
      <xsl:with-param name="ind1">0</xsl:with-param>
      <xsl:with-param name="ind2">
        <xsl:text> </xsl:text>
      </xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- LC agricola identifier -->
  <xsl:template match="identifier[@type='agricola']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">016</xsl:with-param>
      <xsl:with-param name="ind1">7</xsl:with-param>
      <xsl:with-param name="ind2">
        <xsl:text> </xsl:text>
      </xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
        <marc:subfield code="2">
          <xsl:text>DNAL</xsl:text>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="identifier[@type='doi']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">024</xsl:with-param>
      <xsl:with-param name="ind1">7</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
        <marc:subfield code="2">
          <xsl:text>doi</xsl:text>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!--v3 location/url -->
<!-- Changed by CD -->
  <xsl:template match="location[url]">
    <xsl:for-each select="url">
      <xsl:choose>
        <xsl:when test="starts-with(text(), 'https://handle.nal.usda.gov')">
      <xsl:call-template name="datafield">
        <xsl:with-param name="tag">856</xsl:with-param>
        <xsl:with-param name="ind1">4</xsl:with-param>
        <xsl:with-param name="ind2">0</xsl:with-param>
        <xsl:with-param name="subfields">
          <marc:subfield code="u">
            <xsl:value-of select="."/>
          </marc:subfield>
          <marc:subfield code="y">
            <xsl:text>Available in NAL's Digital Repository</xsl:text>
          </marc:subfield>
          <!-- v3 displayLabel -->
          <xsl:for-each select="@displayLabel">
            <marc:subfield code="3">
              <xsl:value-of select="."/>
            </marc:subfield>
          </xsl:for-each>
          <xsl:for-each select="@dateLastAccessed">
            <marc:subfield code="z">
              <xsl:value-of select="concat('Last accessed: ',.)"/>
            </marc:subfield>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
        </xsl:when>

        <xsl:otherwise>
          <xsl:call-template name="datafield">
            <xsl:with-param name="tag">856</xsl:with-param>
            <xsl:with-param name="ind1">4</xsl:with-param>
            <xsl:with-param name="ind2">0</xsl:with-param>
            <xsl:with-param name="subfields">
              <marc:subfield code="u">
                <xsl:value-of select="."/>
              </marc:subfield>
              <marc:subfield code="y">
                <xsl:text>Available from publisher's Web site</xsl:text>
              </marc:subfield>
              <!-- v3 displayLabel -->
              <xsl:for-each select="@displayLabel">
                <marc:subfield code="3">
                  <xsl:value-of select="."/>
                </marc:subfield>
              </xsl:for-each>
              <xsl:for-each select="@dateLastAccessed">
                <marc:subfield code="z">
                  <xsl:value-of select="concat('Last accessed: ',.)"/>
                </marc:subfield>
              </xsl:for-each>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>

    <!-- CD Need to fix if we still want 'Internet resouce' (not NALT descriptor anymore)
      - currently will appear multiple times if there are multiple URLs
      - or we can let Nightly continue to add it.  -->
<!--    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">655</xsl:with-param>
      <xsl:with-param name="ind2">7</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code='a'>
          <xsl:text>Internet resource</xsl:text>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template> -->

  </xsl:template>


  <xsl:template match="identifier[@type='isbn']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">020</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="identifier[@type='isrc']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">024</xsl:with-param>
      <xsl:with-param name="ind1">0</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="identifier[@type='ismn']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">024</xsl:with-param>
      <xsl:with-param name="ind1">2</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="identifier[@type='issn']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">022</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="identifier[@type='issue number']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">028</xsl:with-param>
      <xsl:with-param name="ind1">0</xsl:with-param>
      <xsl:with-param name="ind2">0</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="identifier[@type='lccn']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">010</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

 <!-- CD adds local repository articleID  -->
  <xsl:template match="identifier[@type='local']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">974</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="identifier[@type='matrix number']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">028</xsl:with-param>
      <xsl:with-param name="ind1">1</xsl:with-param>
      <xsl:with-param name="ind2">0</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="identifier[@type='music publisher']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">028</xsl:with-param>
      <xsl:with-param name="ind1">3</xsl:with-param>
      <xsl:with-param name="ind2">0</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="identifier[@type='music plate']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">028</xsl:with-param>
      <xsl:with-param name="ind1">2</xsl:with-param>
      <xsl:with-param name="ind2">0</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="identifier[@type='sici']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">024</xsl:with-param>
      <xsl:with-param name="ind1">4</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="identifier[@type='uri']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">856</xsl:with-param>
      <xsl:with-param name="ind2">
        <xsl:text> </xsl:text>
      </xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="u">
          <xsl:value-of select="."/>
        </marc:subfield>
        <xsl:call-template name="mediaType"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="identifier[@type='upc']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">024</xsl:with-param>
      <xsl:with-param name="ind1">1</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="identifier[@type='videorecording']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">028</xsl:with-param>
      <xsl:with-param name="ind1">4</xsl:with-param>
      <xsl:with-param name="ind2">0</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="name">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">720</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="namePart"/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- v3 role-->
  <xsl:template match="name[@type='personal'][position()=1]">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">100</xsl:with-param>
      <xsl:with-param name="ind1">1</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
<!--          <xsl:call-template name="prepare_author" /> -->
          <!-- LC fixing 100 name field -->
          <xsl:value-of select="displayForm"/>
        </marc:subfield>
        <!-- v3 termsOfAddress -->
<!--        <xsl:for-each select="namePart[@type='termsOfAddress']">
          <marc:subfield code="c">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>-->
        <xsl:for-each select="namePart[@type='date']">
          <marc:subfield code="d">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
        <!-- v3 role -->
<!-- removed by CD       <xsl:for-each select="role/roleTerm[@type='text']">
          <marc:subfield code="e">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>  -->

<!--  removed by CD; problem with affiliations in WebVoyage  -->
  <!--   <xsl:for-each select="affiliation">
          <marc:subfield code="u">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>   -->
        <xsl:for-each select="description">
          <marc:subfield code="g">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- v3 role -->
  <xsl:template match="name[@type='corporate'][role/roleTerm[@type='text']='creator']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">110</xsl:with-param>
      <xsl:with-param name="ind1">2</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="namePart[1]"/>
        </marc:subfield>
        <xsl:for-each select="namePart[position()>1]">
          <marc:subfield code="b">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
        <!-- v3 role -->
        <xsl:for-each select="role/roleTerm[@type='text']">
          <marc:subfield code="e">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
        <xsl:for-each select="description">
          <marc:subfield code="g">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- v3 role -->
  <xsl:template match="name[@type='conference'][role/roleTerm[@type='text']='creator']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">111</xsl:with-param>
      <xsl:with-param name="ind1">2</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="namePart[1]"/>
        </marc:subfield>
        <!-- v3 role -->
        <xsl:for-each select="role/roleTerm[@type='code']">
          <marc:subfield code="4">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- v3 role -->
  <xsl:template match="name[@type='personal'][role/roleTerm[@type='text']!='creator' or not(role)][position()>1]">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">700</xsl:with-param>
      <xsl:with-param name="ind1">1</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
<!-- Removed by CWS  2014-07-30   <xsl:call-template name="prepare_author" /> -->
<!-- removed by CD
          <xsl:value-of select="namePart"/>  -->
          <!-- LC fixing 700 name -->
          <xsl:value-of select="displayForm"/>
        </marc:subfield>
        <!-- v3 termsofAddress -->
        <!--<xsl:for-each select="namePart[@type='termsOfAddress']">
          <marc:subfield code="c">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>-->
        <xsl:for-each select="namePart[@type='date']">
          <marc:subfield code="d">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
        <!-- v3 role -->
<!-- removed by CD
        <xsl:for-each select="role/roleTerm[@type='text']">
          <marc:subfield code="e">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>  -->
<!--  removed by CD; problem with affiliations in WebVoyage  -->
<!--     <xsl:for-each select="affiliation">
          <marc:subfield code="u">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>-->
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- v3 role -->
  <xsl:template match="name[@type='corporate'][role/roleTerm[@type='text']!='creator' or not(role)]">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">710</xsl:with-param>
      <xsl:with-param name="ind1">2</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <!-- 1/04 fix -->
          <xsl:value-of select="namePart[1]"/>
        </marc:subfield>
        <xsl:for-each select="namePart[position()>1]">
          <marc:subfield code="b">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
        <!-- v3 role -->
        <xsl:for-each select="role/roleTerm[@type='text']">
          <marc:subfield code="e">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
        <xsl:for-each select="description">
          <marc:subfield code="g">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- v3 role -->
  <xsl:template match="name[@type='conference'][role/roleTerm[@type='text']!='creator' or not(role)]">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">711</xsl:with-param>
      <xsl:with-param name="ind1">2</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="namePart[1]"/>
        </marc:subfield>
        <!-- v3 role -->
        <xsl:for-each select="role/roleTerm[@type='code']">
          <marc:subfield code="4">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="relatedItemNames">
    <xsl:if test="name">
      <marc:subfield code="a">
        <xsl:variable name="nameString">
          <xsl:for-each select="name">
            <xsl:value-of select="namePart[1][not(@type='date')]"/>
            <xsl:if test="namePart[position()&gt;1][@type='date']">
              <xsl:value-of select="concat(' ',namePart[position()&gt;1][@type='date'])"/>
            </xsl:if>
            <xsl:choose>
              <xsl:when test="role/roleTerm[@type='text']">
                <xsl:value-of select="concat(', ',role/roleTerm)"/>
              </xsl:when>
              <xsl:when test="role/roleTerm[@type='code']">
                <xsl:value-of select="concat(', ',role/roleTerm)"/>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>
          <xsl:text>, </xsl:text>
        </xsl:variable>
        <xsl:value-of select="substring($nameString, 1,string-length($nameString)-2)"/>
      </marc:subfield>
    </xsl:if>
  </xsl:template>

  <xsl:template name="authorityInd">
    <xsl:choose>
      <xsl:when test="@authority='lcsh'">0</xsl:when>
      <xsl:when test="@authority='lcshac'">1</xsl:when>
      <xsl:when test="@authority='mesh'">2</xsl:when>
<!--   changed by CD   <xsl:when test="@authority='csh'">3</xsl:when>
      JG changed 'nal' to 'atg'-->
      <xsl:when test="@authority='atg'">3</xsl:when>
      <xsl:when test="@authority='rvm'">6</xsl:when>
      <xsl:when test="@authority">7</xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
      <!-- v3 blank ind2 fix-->
    </xsl:choose>
  </xsl:template>

  <xsl:template match="subject[@authority='atg'][local-name(*[1])='topic']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">650</xsl:with-param>
<!-- changed by CD -->
      <xsl:with-param name="ind2">
        <xsl:call-template name="authorityInd"/>
      </xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="*[1]"/>
        </marc:subfield>
        <xsl:apply-templates select="*[position()>1]"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="subject[local-name(*[1])='titleInfo']">

    <!--	<xsl:template match="subject[@authority='lcsh'][title]">-->

    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">630</xsl:with-param>
      <xsl:with-param name="ind1">
        <xsl:value-of select="string-length(titleInfo/nonSort)"/>
      </xsl:with-param>
      <xsl:with-param name="ind2">
        <xsl:call-template name="authorityInd"/>
      </xsl:with-param>
      <xsl:with-param name="subfields">
        <xsl:for-each select="titleInfo">
          <xsl:call-template name="titleInfo"/>
        </xsl:for-each>
        <xsl:apply-templates select="*[position()>1]"/>

      </xsl:with-param>
    </xsl:call-template>

  </xsl:template>

  <xsl:template match="subject[local-name(*[1])='name']">
    <xsl:for-each select="*[1]">
      <xsl:choose>
        <xsl:when test="@type='personal'">
          <xsl:call-template name="datafield">
            <xsl:with-param name="tag">600</xsl:with-param>
            <xsl:with-param name="ind1">1</xsl:with-param>
            <xsl:with-param name="ind2">
              <xsl:call-template name="authorityInd"/>
            </xsl:with-param>
            <xsl:with-param name="subfields">
              <marc:subfield code="a">
                <xsl:value-of select="namePart"/>
              </marc:subfield>
              <!-- v3 termsofAddress -->
              <xsl:for-each select="namePart[@type='termsOfAddress']">
                <marc:subfield code="c">
                  <xsl:value-of select="."/>
                </marc:subfield>
              </xsl:for-each>
              <xsl:for-each select="namePart[@type='date']">
                <!-- v3 namepart/date was $a; fixed to $d -->
                <marc:subfield code="d">
                  <xsl:value-of select="."/>
                </marc:subfield>
              </xsl:for-each>
              <!-- v3 role -->
              <xsl:for-each select="role/roleTerm[@type='text']">
                <marc:subfield code="e">
                  <xsl:value-of select="."/>
                </marc:subfield>
              </xsl:for-each>
              <xsl:for-each select="affiliation">
                <marc:subfield code="u">
                  <xsl:value-of select="."/>
                </marc:subfield>
              </xsl:for-each>
              <xsl:apply-templates select="*[position()>1]"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@type='corporate'">
          <xsl:call-template name="datafield">
            <xsl:with-param name="tag">610</xsl:with-param>
            <xsl:with-param name="ind1">2</xsl:with-param>
            <xsl:with-param name="ind2">
              <xsl:call-template name="authorityInd"/>
            </xsl:with-param>
            <xsl:with-param name="subfields">
              <marc:subfield code="a">
                <xsl:value-of select="namePart"/>
              </marc:subfield>
              <xsl:for-each select="namePart[position()>1]">
                <marc:subfield code="a">
                  <xsl:value-of select="."/>
                </marc:subfield>
              </xsl:for-each>
              <!-- v3 role -->
              <xsl:for-each select="role/roleTerm[@type='text']">
                <marc:subfield code="e">
                  <xsl:value-of select="."/>
                </marc:subfield>
              </xsl:for-each>
              <!--<xsl:apply-templates select="*[position()>1]"/>-->
              <xsl:apply-templates select="ancestor-or-self::subject/*[position()>1]"/>

            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="@type='conference'">
          <xsl:call-template name="datafield">
            <xsl:with-param name="tag">611</xsl:with-param>
            <xsl:with-param name="ind1">2</xsl:with-param>
            <xsl:with-param name="ind2">
              <xsl:call-template name="authorityInd"/>
            </xsl:with-param>
            <xsl:with-param name="subfields">
              <marc:subfield code="a">
                <xsl:value-of select="namePart"/>
              </marc:subfield>
              <!-- v3 role -->
              <xsl:for-each select="role/roleTerm[@type='code']">
                <marc:subfield code="4">
                  <xsl:value-of select="."/>
                </marc:subfield>
              </xsl:for-each>
              <xsl:apply-templates select="*[position()>1]"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="subject[local-name(*[1])='geographic']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">651</xsl:with-param>
      <xsl:with-param name="ind2">
        <xsl:call-template name="authorityInd"/>
      </xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="*[1]"/>
        </marc:subfield>
        <xsl:apply-templates select="*[position()>1]"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="subject[local-name(*[1])='temporal']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">650</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="*[1]"/>
        </marc:subfield>
        <xsl:apply-templates select="*[position()>1]"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- v3 occupation -->
  <xsl:template match="subject/occupation">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">656</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

<!-- changed by CD
  <xsl:template match="subject/topic">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">653</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>  -->

  <xsl:template match="subject/temporal">
    <marc:subfield code="y">
      <xsl:value-of select="."/>
    </marc:subfield>
  </xsl:template>

  <xsl:template match="subject/geographic">
    <marc:subfield code="z">
      <xsl:value-of select="."/>
    </marc:subfield>
  </xsl:template>
  <!-- v3 physicalLocation -->
  <xsl:template match="location[physicalLocation]">
    <xsl:for-each select="physicalLocation">
      <xsl:call-template name="datafield">
        <xsl:with-param name="tag">852</xsl:with-param>
        <xsl:with-param name="subfields">
          <marc:subfield code="a">
            <xsl:value-of select="."/>
          </marc:subfield>
   <xsl:for-each select="shelfLocator">
     <marc:subfield code="i">
       <xsl:value-of select="."/>
     </marc:subfield>
   </xsl:for-each>
          <!-- v3 displayLabel -->
          <xsl:for-each select="@displayLabel">
            <marc:subfield code="3">
              <xsl:value-of select="."/>
            </marc:subfield>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <!-- LC: agricola subject -->
  <xsl:template match="subject[@authority='agricola']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">072</xsl:with-param>
      <xsl:with-param name="ind1">
        <xsl:text> </xsl:text>
      </xsl:with-param>
      <xsl:with-param name="ind2">
        <xsl:text>0</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="topic"/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

<!-- removed by CD  <xsl:template match="extension">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">887</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="a">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>  -->

  <!-- CD adds USDA affiliations  -->
  <xsl:template match="extension">
    <!-- CD adds 592 Publisher supplied data  -->
    <xsl:if test="vendorName">
        <xsl:call-template name="datafield">
          <xsl:with-param name="tag">592</xsl:with-param>
          <xsl:with-param name="subfields">
            <marc:subfield code="a">
              <xsl:text>Publisher supplied data</xsl:text>
            </marc:subfield>
          </xsl:with-param>
        </xsl:call-template>
    </xsl:if>

    <xsl:for-each select="affiliation">
      <xsl:if test="starts-with(text(), 'USDA ')">
        <xsl:call-template name="datafield">
         <xsl:with-param name="tag">910</xsl:with-param>
          <xsl:with-param name="subfields">
            <marc:subfield code="a">
             <xsl:text>USDA</xsl:text>
            </marc:subfield>
            <marc:subfield code="b">
             <xsl:value-of select="substring-after(text(), 'USDA ')"/>
             </marc:subfield>
          </xsl:with-param>
         </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>


  <!-- LC extension notes fields -->
  <!-- LC note 910 -->
  <!-- JG changed ind2 to blank -->
  <xsl:template name="note910" match="extension/note[@type='submissionSource']">
    <xsl:if test="extension/note[@type='submissionSource']">
    <xsl:variable name="note" select="extension/note[@type='submissionSource']"/>
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">910</xsl:with-param>
      <xsl:with-param name="ind1"><xsl:text> </xsl:text></xsl:with-param>
      <xsl:with-param name="ind2"><xsl:text> </xsl:text></xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code='a'>
          <xsl:value-of select="substring-before($note, '/')"/>
        </marc:subfield>
        <marc:subfield code='b'>
          <xsl:value-of select="substring-after($note, '/')"/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- LC note 930, bad string processiong functions in xslt 1.0, will code values be uniform?
  and follow the same string pattern?  -->
  <xsl:template name="note930" match="extension/note[@type='saleTape']">
    <xsl:if test="extension/note[@type='saleTape']">
    <xsl:variable name="note" select="extension/note[@type='saleTape']"/>
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">930</xsl:with-param>
      <xsl:with-param name="ind1"><xsl:text> </xsl:text></xsl:with-param>
      <xsl:with-param name="ind2"><xsl:text> </xsl:text></xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code='a'>
          <xsl:value-of select="substring($note, 1, 8)"/>
        </marc:subfield>
        <marc:subfield code='b'>
          <xsl:value-of select="substring($note, 10, 8)"/>
        </marc:subfield>
        <marc:subfield code='c'>
          <xsl:value-of select="substring($note, 19, 8)"/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- LC note 945, bad string processiong functions in xslt 1.0, will code values be uniform?
  and follow the same string pattern? -->
  <xsl:template name="note945" match="extension/note[@type='indexer']">
    <xsl:if test="extension/note[@type='indexer']">
    <xsl:variable name="note" select="extension/note[@type='indexer']"/>
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">945</xsl:with-param>
      <xsl:with-param name="ind1"><xsl:text> </xsl:text></xsl:with-param>
      <xsl:with-param name="ind2"><xsl:text> </xsl:text></xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code='a'>
          <xsl:value-of select="substring($note, 1, 3)"/>
        </marc:subfield>
        <marc:subfield code='d'>
          <xsl:value-of select="substring($note, 5, 3)"/>
        </marc:subfield>
        <marc:subfield code='e'>
          <xsl:value-of select="substring($note, 9, 10)"/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- LC note 946 -->
  <xsl:template name="note946" match="extension/note[@type='publicationSource']">
    <xsl:if test="extension/note[@type='publicationSource']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">946</xsl:with-param>
      <xsl:with-param name="ind1"><xsl:text> </xsl:text></xsl:with-param>
      <xsl:with-param name="ind2"><xsl:text> </xsl:text></xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code='a'>
          <xsl:value-of select="extension/note[@type='publicationSource']"/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!-- LC note 974 -->
  <xsl:template name="note974" match="extension/note[@type='ai']">
    <xsl:if test="extension/note[@type='ai']">
      <xsl:variable name="note" select="extension/note[@type='ai']"/>
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">974</xsl:with-param>
      <xsl:with-param name="ind1"><xsl:text> </xsl:text></xsl:with-param>
      <xsl:with-param name="ind2"><xsl:text> </xsl:text></xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code='a'>
          <xsl:value-of select="substring-before($note, ' Batch')"/>
        </marc:subfield>
        <marc:subfield code='b'>
          <xsl:value-of select="substring-after($note, ' ')"/>
        </marc:subfield>
      </xsl:with-param>
    </xsl:call-template>
    </xsl:if>
  </xsl:template>


  <!-- v3 isReferencedBy -->
  <xsl:template match="relatedItem[@type='isReferencedBy']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">510</xsl:with-param>
      <xsl:with-param name="subfields">
        <xsl:variable name="noteString">
          <xsl:for-each select="*">
            <xsl:value-of select="concat(.,', ')"/>
          </xsl:for-each>
        </xsl:variable>
        <marc:subfield code="a">
          <xsl:value-of select="substring($noteString, 1,string-length($noteString)-2)"/>
        </marc:subfield>
        <!--<xsl:call-template name="relatedItem76X-78X"/>-->
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  <!-- 1/04 fix -->
  <!--<xsl:template match="internetMediaType">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">856</xsl:with-param>
			<xsl:with-param name="ind2">2</xsl:with-param>
			<xsl:with-param name="subfields">
				<marc:subfield code="q">
					<xsl:value-of select="."/>
				</marc:subfield>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>	-->

  <xsl:template name="mediaType">
    <xsl:if test="../physicalDescription/internetMediaType">
      <marc:subfield code="q">
        <xsl:value-of select="../physicalDescription/internetMediaType"/>
      </marc:subfield>
    </xsl:if>
  </xsl:template>

  <xsl:template name="form">
    <xsl:if test="../physicalDescription/form[@authority='gmd']">
      <marc:subfield code="h">
        <xsl:value-of select="../physicalDescription/form[@authority='gmd']"/>
      </marc:subfield>
    </xsl:if>
  </xsl:template>

  <xsl:template match="relatedItem/identifier[@type='uri']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">856</xsl:with-param>
      <xsl:with-param name="ind2">2</xsl:with-param>
      <xsl:with-param name="subfields">
        <marc:subfield code="u">
          <xsl:value-of select="."/>
        </marc:subfield>
        <xsl:call-template name="mediaType"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="relatedItem[@type='series']">
    <!-- v3 build series type -->
    <xsl:for-each select="titleInfo">
      <xsl:call-template name="datafield">
        <xsl:with-param name="tag">440</xsl:with-param>
        <xsl:with-param name="subfields">
          <xsl:call-template name="titleInfo"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
    <xsl:for-each select="name">
      <xsl:call-template name="datafield">
        <xsl:with-param name="tag">
          <xsl:choose>
            <xsl:when test="@type='personal'">800</xsl:when>
            <xsl:when test="@type='corporate'">810</xsl:when>
            <xsl:when test="@type='conference'">811</xsl:when>
          </xsl:choose>
        </xsl:with-param>
        <xsl:with-param name="subfields">
          <marc:subfield code="a">
            <xsl:value-of select="namePart"/>
          </marc:subfield>
          <xsl:if test="@type='corporate'">
            <xsl:for-each select="namePart[position()>1]">
              <marc:subfield code="b">
                <xsl:value-of select="."/>
              </marc:subfield>
            </xsl:for-each>
          </xsl:if>
          <xsl:if test="@type='personal'">
            <xsl:for-each select="namePart[@type='termsOfAddress']">
              <marc:subfield code="c">
                <xsl:value-of select="."/>
              </marc:subfield>
            </xsl:for-each>
            <xsl:for-each select="namePart[@type='date']">
              <!-- v3 namepart/date was $a; fixed to $d -->
              <marc:subfield code="d">
                <xsl:value-of select="."/>
              </marc:subfield>
            </xsl:for-each>
          </xsl:if>
          <!-- v3 role -->
          <xsl:if test="@type!='conference'">
            <xsl:for-each select="role/roleTerm[@type='text']">
              <marc:subfield code="e">
                <xsl:value-of select="."/>
              </marc:subfield>
            </xsl:for-each>
          </xsl:if>
          <xsl:for-each select="role/roleTerm[@type='code']">
            <marc:subfield code="4">
              <xsl:value-of select="."/>
            </marc:subfield>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="relatedItem[not(@type)]">
    <!-- v3 was type="related" -->
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">787</xsl:with-param>
      <xsl:with-param name="ind1">0</xsl:with-param>
      <xsl:with-param name="subfields">
        <xsl:call-template name="relatedItem76X-78X"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="relatedItem[@type='preceding']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">780</xsl:with-param>
      <xsl:with-param name="ind1">0</xsl:with-param>
      <xsl:with-param name="ind2">0</xsl:with-param>
      <xsl:with-param name="subfields">
        <xsl:call-template name="relatedItem76X-78X"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="relatedItem[@type='succeeding']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">785</xsl:with-param>
      <xsl:with-param name="ind1">0</xsl:with-param>
      <xsl:with-param name="ind2">0</xsl:with-param>
      <xsl:with-param name="subfields">
        <xsl:call-template name="relatedItem76X-78X"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="relatedItem[@type='otherVersion']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">775</xsl:with-param>
      <xsl:with-param name="subfields">
        <xsl:call-template name="relatedItem76X-78X"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="relatedItem[@type='otherFormat']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">776</xsl:with-param>
      <xsl:with-param name="subfields">
        <xsl:call-template name="relatedItem76X-78X"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="relatedItem[@type='original']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">534</xsl:with-param>
      <xsl:with-param name="subfields">
        <xsl:call-template name="relatedItem76X-78X"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

<!-- modified by CD -->
  <xsl:template match="relatedItem[@type='host']">
    <xsl:choose>
      <xsl:when test="part/extent/start = part/extent/end">
        <xsl:call-template name="datafield">
          <xsl:with-param name="tag">300</xsl:with-param>
          <xsl:with-param name="subfields">
            <marc:subfield code='a'>p. <xsl:value-of select="part/extent/start"/>.</marc:subfield>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
        <xsl:when test="part/extent/end">
          <xsl:call-template name="datafield">
             <xsl:with-param name="tag">300</xsl:with-param>
              <xsl:with-param name="subfields">
               <marc:subfield code='a'>p. <xsl:value-of select="part/extent/start"/>-<xsl:value-of select="part/extent/end"/>.</marc:subfield>
              </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="datafield">
            <xsl:with-param name="tag">300</xsl:with-param>
            <xsl:with-param name="subfields">
              <marc:subfield code='a'>p. <xsl:value-of select="part/extent/start"/>.</marc:subfield>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>

 <!-- Changed by CD -->
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">773</xsl:with-param>
      <xsl:with-param name="ind1">0</xsl:with-param>
      <xsl:with-param name="subfields">
        <!-- v3 displaylabel -->
        <xsl:for-each select="@displaylabel">
          <marc:subfield code="3">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
        <xsl:call-template name="nal773"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>


  <xsl:template name="nal773">
      <xsl:for-each select="titleInfo">
      <xsl:for-each select="title">
        <xsl:choose>
          <xsl:when test="not(ancestor-or-self::titleInfo/@type)">
            <marc:subfield code="t">
              <xsl:value-of select="."/><xsl:text>.</xsl:text>
            </marc:subfield>
          </xsl:when>
          <xsl:when test="ancestor-or-self::titleInfo/@type='uniform'">
            <marc:subfield code="s">
              <xsl:value-of select="."/>
            </marc:subfield>
          </xsl:when>
          <xsl:when test="ancestor-or-self::titleInfo/@type='abbreviated'">
            <marc:subfield code="p">
              <xsl:value-of select="."/>
            </marc:subfield>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>

      <xsl:call-template name ="nalIssueInfo"/>

      <xsl:for-each select="../originInfo/publisher">
        <marc:subfield code="d">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:for-each>

    </xsl:for-each>
    <!-- 1/04 fix -->
    <xsl:call-template name="relatedItemNames"/>
    <!-- 1/04 fix -->
    <xsl:choose>
      <xsl:when test="@type='original'">
        <!-- 534 -->
        <xsl:for-each select="physicalDescription/extent">
          <marc:subfield code="e">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="@type!='original'">
        <xsl:for-each select="physicalDescription/extent">
          <marc:subfield code="h">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
    <!-- v3 displaylabel -->
    <xsl:for-each select="@displayLabel">
      <marc:subfield code="i">
        <xsl:value-of select="."/>
      </marc:subfield>
    </xsl:for-each>
    <xsl:for-each select="note">
      <marc:subfield code="n">
        <xsl:value-of select="."/>
      </marc:subfield>
    </xsl:for-each>
    <xsl:for-each select="identifier[not(@type)]">
      <marc:subfield code="o">
        <xsl:value-of select="."/>
      </marc:subfield>
    </xsl:for-each>
    <xsl:for-each select="identifier[@type='issn']">
      <marc:subfield code="x">
        <xsl:value-of select="."/>
      </marc:subfield>
    </xsl:for-each>
    <xsl:for-each select="identifier[@type='isbn']">
      <marc:subfield code="z">
        <xsl:value-of select="."/>
      </marc:subfield>
    </xsl:for-each>
    <!-- Changed by CD -->
    <marc:subfield code="7">nnas</marc:subfield>
    <xsl:for-each select="identifier[@type='local']">
      <xsl:if test="starts-with(text(), 'Journal:')">
      <marc:subfield code="9">
        <xsl:value-of select="substring-after(text(), 'Journal:')"/>
      </marc:subfield>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="note">
      <marc:subfield code="n">
        <xsl:value-of select="."/>
      </marc:subfield>
    </xsl:for-each>

  </xsl:template>


  <xsl:template name="nalIssueInfo">
<!--        <xsl:if test="part/text"> -->
      <xsl:for-each select="../part">
          <marc:subfield code="g">
            <xsl:for-each select ="text[@type='year']">
              <xsl:value-of select="."/>
            </xsl:for-each>

            <xsl:choose>
              <xsl:when test="text[@type='month']">
                <xsl:for-each select ="text[@type='month']">
                  <xsl:text> </xsl:text>
                     <xsl:choose>
                       <xsl:when test=".='1' or .='01' or .='January' or .='Jan.' or .='Jan'">Jan.</xsl:when>
                       <xsl:when test=".='2' or .='02' or .='February' or .='Feb.' or .='Feb'">Feb.</xsl:when>
                       <xsl:when test=".='3' or .='03' or .='March' or .='Mar.' or .='Mar'">Mar.</xsl:when>
                       <xsl:when test=".='4' or .='04' or .='April' or .='Apr.' or .='Apr'">Apr.</xsl:when>
                       <xsl:when test=".='5' or .='05' or .='May'">May</xsl:when>
                       <xsl:when test=".='6' or .='06' or .='June' or .='Jun.' or .='Jun'">June</xsl:when>
                       <xsl:when test=".='7' or .='07' or .='July' or .='Jul.' or .='Jul'">July</xsl:when>
                       <xsl:when test=".='8' or .='08' or .='August' or .='Aug.' or .='Aug'">Aug.</xsl:when>
                       <xsl:when test=".='9' or .='09' or .='September' or .='Sept.' or .='Sept'">Sept.</xsl:when>
                       <xsl:when test=".='10' or .='October' or .='Oct.' or .='Oct'">Oct.</xsl:when>
                       <xsl:when test=".='11' or .='November' or .='Nov.' or .='Nov'">Nov.</xsl:when>
                       <xsl:when test=".='12'or .='December' or .='Dec.'or .='Dec'">Dec.</xsl:when>
                     </xsl:choose>

                    <xsl:if test="../text[@type='day']">
                       <xsl:for-each select ="../text[@type='day']">
                          <xsl:text> </xsl:text>
                          <xsl:value-of select="text()"/>
                        </xsl:for-each>
                     </xsl:if>

                  <xsl:text>, </xsl:text>
                </xsl:for-each>
              </xsl:when>

              <xsl:when test="not(text[@type='month'])">
                <xsl:choose>
                   <xsl:when test="text[@type='season']">
                     <xsl:for-each select ="text[@type='season']">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="text()"/>
                        <xsl:text>, </xsl:text>
                     </xsl:for-each>
                   </xsl:when>

                  <xsl:otherwise>
                     <xsl:text>, </xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
             </xsl:when>

              <xsl:otherwise>
                <xsl:text>, </xsl:text>
              </xsl:otherwise>
            </xsl:choose>

 <!--         <xsl:if test="../detail[@type='volume']/number">
                <xsl:text>, </xsl:text>
              </xsl:if>  -->

            <xsl:if test="detail">
              <xsl:variable name="parts">
                <xsl:if test="detail[@type='volume']/number">
                  <xsl:for-each select ="detail[@type='volume']">
                    <xsl:value-of select="caption"/>
                  </xsl:for-each>
                <xsl:text> </xsl:text>
                <xsl:for-each select ="detail[@type='volume']">
                  <xsl:value-of select="number"/>
                </xsl:for-each>
                </xsl:if>
                <xsl:if test="detail[@type='issue']/number">
                  <xsl:for-each select ="detail[@type='issue']">
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="caption"/>
                    <xsl:text> </xsl:text>
                  </xsl:for-each>
                <xsl:for-each select ="detail[@type='issue']">
                  <xsl:value-of select="number"/>
                </xsl:for-each>
                </xsl:if>
              </xsl:variable>
     <xsl:value-of select="concat(substring($parts,1,string-length($parts)),'')"/>
            </xsl:if>
            </marc:subfield>
<!--        </xsl:if> -->

        <!-- v3 sici part/detail 773$q 	1:2:3<4-->
      </xsl:for-each>

  </xsl:template>

  <xsl:template match="relatedItem[@type='constituent']">
    <xsl:call-template name="datafield">
      <xsl:with-param name="tag">774</xsl:with-param>
      <xsl:with-param name="ind1">0</xsl:with-param>
      <xsl:with-param name="subfields">
        <xsl:call-template name="relatedItem76X-78X"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- v3 changed this to not@type -->
  <!--<xsl:template match="relatedItem[@type='related']">
		<xsl:call-template name="datafield">
			<xsl:with-param name="tag">787</xsl:with-param>
			<xsl:with-param name="ind1">0</xsl:with-param>
			<xsl:with-param name="subfields">
				<xsl:call-template name="relatedItem76X-78X"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
-->
  <xsl:template name="relatedItem76X-78X">
    <xsl:for-each select="titleInfo">
      <xsl:for-each select="title">
        <xsl:choose>
          <xsl:when test="not(ancestor-or-self::titleInfo/@type)">
            <marc:subfield code="t">
              <xsl:value-of select="."/><xsl:text>.</xsl:text>
            </marc:subfield>
          </xsl:when>
          <xsl:when test="ancestor-or-self::titleInfo/@type='uniform'">
            <marc:subfield code="s">
              <xsl:value-of select="."/>
            </marc:subfield>
          </xsl:when>
          <xsl:when test="ancestor-or-self::titleInfo/@type='abbreviated'">
            <marc:subfield code="p">
              <xsl:value-of select="."/>
            </marc:subfield>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>

      <xsl:for-each select="../originInfo/publisher">
        <marc:subfield code="d">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:for-each>

      <xsl:for-each select="partNumber">
        <marc:subfield code="g">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:for-each>
      <xsl:for-each select="partName">
        <marc:subfield code="g">
          <xsl:value-of select="."/>
        </marc:subfield>
      </xsl:for-each>
    </xsl:for-each>
    <!-- 1/04 fix -->
    <xsl:call-template name="relatedItemNames"/>
    <!-- 1/04 fix -->
    <xsl:choose>
      <xsl:when test="@type='original'">
        <!-- 534 -->
        <xsl:for-each select="physicalDescription/extent">
          <marc:subfield code="e">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
      </xsl:when>
      <xsl:when test="@type!='original'">
        <xsl:for-each select="physicalDescription/extent">
          <marc:subfield code="h">
            <xsl:value-of select="."/>
          </marc:subfield>
        </xsl:for-each>
      </xsl:when>
    </xsl:choose>
    <!-- v3 displaylabel -->
    <xsl:for-each select="@displayLabel">
      <marc:subfield code="i">
        <xsl:value-of select="."/>
      </marc:subfield>
    </xsl:for-each>
    <xsl:for-each select="note">
      <marc:subfield code="n">
        <xsl:value-of select="."/>
      </marc:subfield>
    </xsl:for-each>
    <xsl:for-each select="identifier[not(@type)]">
      <marc:subfield code="o">
        <xsl:value-of select="."/>
      </marc:subfield>
    </xsl:for-each>
    <xsl:for-each select="identifier[@type='issn']">
      <marc:subfield code="x">
        <xsl:value-of select="."/>
      </marc:subfield>
    </xsl:for-each>
    <xsl:for-each select="identifier[@type='isbn']">
      <marc:subfield code="z">
        <xsl:value-of select="."/>
      </marc:subfield>
    </xsl:for-each>
    <!-- Changed by CD -->
    <marc:subfield code="7">nnas</marc:subfield>
    <xsl:for-each select="identifier[@type='local']">
      <xsl:if test="starts-with(text(), 'Journal:')">
      <marc:subfield code="9">
        <xsl:value-of select="substring-after(text(), 'Journal:')"/>
      </marc:subfield>
      </xsl:if>
    </xsl:for-each>
    <xsl:for-each select="note">
      <marc:subfield code="n">
        <xsl:value-of select="."/>
      </marc:subfield>
    </xsl:for-each>
  </xsl:template>
  <!-- v3 not used?
		<xsl:variable name="leader06">
			<xsl:choose>
				<xsl:when test="typeOfResource='text'">
					<xsl:choose>
						<xsl:when test="@manuscript='yes'">t</xsl:when>
						<xsl:otherwise>a</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="typeOfResource='cartographic'">
					<xsl:choose>
						<xsl:when test="@manuscript='yes'">f</xsl:when>
						<xsl:otherwise>e</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="typeOfResource='notated music'">
					<xsl:choose>
						<xsl:when test="@manuscript='yes'">d</xsl:when>
						<xsl:otherwise>c</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="typeOfResource='sound recording'">j</xsl:when>
				<xsl:when test="typeOfResource='still image'">k</xsl:when>
				<xsl:when test="typeOfResource='moving image'">g</xsl:when>
				<xsl:when test="typeOfResource='three dimensional object'">r</xsl:when>
				<xsl:when test="typeOfResource='software, multimedia'">m</xsl:when>
				<xsl:when test="typeOfResource='mixed material'">p</xsl:when>
			</xsl:choose>
		</xsl:variable>
-->


  <xsl:template name="prepare_author">

    <xsl:choose>

    <xsl:when test="namePart[@type='family']">
       <xsl:value-of select="namePart[@type='family']"/>

       <xsl:if test="namePart[@type='given']|namePart[@type='middle']">
          <xsl:text>,</xsl:text>
       </xsl:if>

          <xsl:if test="namePart[@type='given']">
            <xsl:text> </xsl:text>
              <xsl:value-of select="namePart[@type='given']"/>
          </xsl:if>

         <xsl:if test="namePart[@type='middle']">
           <xsl:text> </xsl:text>
           <xsl:value-of select="namePart[@type='middle']"/>
         </xsl:if>

         <xsl:if test="namePart[@type='termsOfAddress']">
           <xsl:text> </xsl:text>
           <xsl:value-of select="namePart[@type='termsOfAddress']"/>
         </xsl:if>
    </xsl:when>

    <!-- not likely to happen, but just in case there is no family name -->
      <xsl:otherwise>
        <xsl:if test="namePart[@type='given']">
          <xsl:value-of select="namePart[@type='given']"/>
          <xsl:text> </xsl:text>
        </xsl:if>

        <xsl:if test="namePart[@type='middle']">
          <xsl:value-of select="namePart[@type='middle']"/>
          <xsl:text> </xsl:text>
        </xsl:if>

        <xsl:if test="namePart[@type='termsOfAddress']">
          <xsl:value-of select="namePart[@type='termsOfAddress']"/>
        </xsl:if>
      </xsl:otherwise>

    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
