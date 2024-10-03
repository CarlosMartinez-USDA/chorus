<xsl:package
  name="http://example.org/some-name"
  package-version="1.0"
  version="3.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:f="http://example.org/some-name">
  <xsl:mode 
  <xsl:template match="/all/authors/item/affiliation" mode="aff">
    <affiliation>
    <xsl:value-of select="tokenize(.,';')"/>
    </affiliation>
   </xsl:template>
</xsl:package>