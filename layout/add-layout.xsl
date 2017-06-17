<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" doctype-system="about:legacy-compat"/>

  <xsl:variable name="taxonomies" select="document('../taxonomies.xml')/root"/>

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

      <link rel="stylesheet" type="text/css" href="../../layout/style.css"/>
      <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Merriweather"/>
      <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Archivo+Narrow"/>

      <xsl:apply-templates select="child::node() | child::processing-instruction()" />
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

        <div class="site-header__butterfly-container">
          <img class="site-header__butterfly-img" src="../../layout/Butterfly-vulcan-papillon-vulcain-vanessa-atalanta-2.png"/>
        </div>

        <xsl:apply-templates select="child::node() | child::processing-instruction()"/>

        <footer class='site-footer' role='banner'>
          <div class='site-footer__deco'>
            <img class='site-footer__deco-pic' src="../../layout/mushroom-2279552_1920.png"/>
          </div>
          <div class='site-footer__content'>
            <p class='site-footer__license'><a href="http://creativecommons.org/licenses/by-nc-sa/2.5/" rel="license">Copyleft</a>: you can share this content as long as you copy it right; that means that you must tell where it's from (from me) and that you have to ask permission first if you want to use my content commercially.</p>
            <p class='site-footer__colophon'><a href="https://github.com/bigsmoke/sapienshabitat/" rel="colophon">Colophon</a>: this website is open source; all the details about its technical design, the full file history and current drafts are freely accessible on-line.</p>
          </div>
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
