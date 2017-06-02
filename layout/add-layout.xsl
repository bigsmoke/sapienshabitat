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

  <xsl:template match="head">
    <head>
      <xsl:copy-of select="attribute::*"/>

      <link rel="stylesheet" type="text/css" href="../../layout/style.css" />
    </head>
  </xsl:template>

  <xsl:template match="body">
    <body>
      <div class="site-container">
        <xsl:copy-of select="attribute::*"/>

        <header class='site-header' role='banner'>
          <h1 class='site-header__title'>Sapiens Habitat</h1>
          <span class='site-header__title-slogan-separator'> – </span>
          <h2 class='site-header__slogan'>Smart habitats for thinking humans</h2>
          <span class='site-header__terminator'> – </span>
        </header>

        <xsl:apply-templates select="child::node() | child::processing-instruction()"/>

        <footer class='site-footer' role='banner'>
        </footer>
      </div> <!-- .site-container -->
    </body>
  </xsl:template>

  <xsl:template match="article">
    <article>
        <xsl:copy-of select="attribute::*"/>

        <div class="article-header">
          <h1 class="article-header__title"><xsl:apply-templates select="h1/child::node()"/></h1>
        </div>

        <div class="article-body">
          <xsl:apply-templates select="(child::node() | child::processing-instruction())[not(name(.)='h1')]"/>
        </div>
    </article>
  </xsl:template>

  <xsl:template match="figure" name="figure">
    <figure>
        <xsl:copy-of select="attribute::*"/>
        <xsl:copy-of select="img/attribute::class"/>

        <xsl:apply-templates select="child::node() | child::processing-instruction()"/>
    </figure>
  </xsl:template>

  <xsl:template match="figure[contains(img/@class, 'semi-text-width')]"/>

  <xsl:template match="figure[contains(img/@class, 'semi-text-width')][./following-sibling::*[position()=1 and name(.)='figure']]">
    <div class="side-by-side-figure__container">
      <xsl:call-template name="figure" /> 

      <xsl:for-each select="following-sibling::*[position()=1 and name(.)='figure']">
        <xsl:call-template name="figure" /> 
      </xsl:for-each>
    </div>
  </xsl:template>

</xsl:stylesheet>
