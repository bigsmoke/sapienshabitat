<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" doctype-system="about:legacy-compat"/>

  <xsl:template match="/">
    <xsl:apply-templates select="child::node() | child::processing-instruction()"/>
  </xsl:template>

  <xsl:template match="*">
    <xsl:element name="{name(.)}">
      <xsl:copy-of select="attribute::*"/>

      <xsl:apply-templates select="child::node() | child::processing-instruction()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="comment() | processing-instruction()">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="body">
    <body>
      <div class="site-container">
        <xsl:copy-of select="attribute::*"/>

        <header class='site-header' role='banner'>
          <h1 class='site-header__title'>Sapiens Habitat</h1>
          <span class='site-header__title-slogan-separator'>–</span>
          <h2 class='site-header__slogan'>Smart habitats for thinking humans</h2>
        </header>

        <xsl:apply-templates select="child::node() | child::processing-instruction()"/>

        <footer class='site-footer' role='banner'>
        </footer>
      </div> <!-- .site-container -->
    </body>
  </xsl:template>

</xsl:stylesheet>
