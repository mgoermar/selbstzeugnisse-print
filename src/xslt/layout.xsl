<xsl:transform version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:attribute-set name="heading">
    <xsl:attribute name="page-break-before">always</xsl:attribute>
    <xsl:attribute name="line-height">150%</xsl:attribute>
    <xsl:attribute name="font-size">14pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="space-after">0.5em</xsl:attribute>
    <xsl:attribute name="keep-with-next">always</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="subheading" use-attribute-sets="heading">
    <xsl:attribute name="page-break-before">auto</xsl:attribute>
    <xsl:attribute name="font-size">12pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="subsubheading" use-attribute-sets="heading">
    <xsl:attribute name="page-break-before">auto</xsl:attribute>
    <xsl:attribute name="font-size">12pt</xsl:attribute>
    <xsl:attribute name="font-weight">400</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="label">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="paragraph">
    <xsl:attribute name="space-after">0.5em</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="footnote">
    <xsl:attribute name="font-size">8pt</xsl:attribute>
    <xsl:attribute name="font-weight">400</xsl:attribute>
    <xsl:attribute name="line-height">125%</xsl:attribute>
  </xsl:attribute-set>
</xsl:transform>
