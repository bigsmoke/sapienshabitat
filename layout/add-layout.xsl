<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" doctype-system="about:legacy-compat"/>

  <xsl:param name="img-width-1" select="number('2500')"/> <!-- That's about the resolution of my Samsung S7 Edge -->
  <xsl:param name="img-width-2" select="number('1000')"/> <!-- That's about the resolution of my Samsung S7 Edge -->
  <xsl:param name="slug"/>

  <xsl:variable name="meta" select="document('../htdocs/meta.xml')/pages"/>

  <xsl:variable name="this-article-meta" select="$meta/page[slug=$slug]"/>

  <xsl:template match="/">
    <xsl:apply-templates select="child::node() | child::processing-instruction()"/>
  </xsl:template>

  <xsl:template match="*">
    <xsl:element name="{name(.)}">
      <xsl:copy-of select="attribute::*"/>

      <xsl:apply-templates select="child::node() | child::processing-instruction()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="attribute::*">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="comment() | processing-instruction()">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="head">
    <head>
      <xsl:copy-of select="attribute::*"/>

      <meta name="viewport" content="width=device-width, initial-scale=1"/>
      <link rel="stylesheet" type="text/css" href="../layout/style.css?v=25"/>
      <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Merriweather"/>
      <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Archivo+Narrow"/>

      <script type="text/javascript" src="../layout/enhance.js?v=1"></script>

      <xsl:apply-templates select="child::node() | child::processing-instruction()" />
    </head>
  </xsl:template>

  <xsl:template match="body">
    <body id="top" class="scroll-up-detection-with-threshold" data-scroll-up-threshold-delta="5">
      <div class="site-container">
        <xsl:copy-of select="attribute::*"/>

        <header class='site-header' role='banner'>
          <div class="site-header__white-background">
            <h1 class='site-header__title'><a class='site-header__title-link' href="/">Sapiens Habitat</a></h1>
            <span class='site-header__title-slogan-separator'> – </span>
            <h2 class='site-header__slogan'>Smart habitats for thinking humans</h2>
            <span class='site-header__terminator'> – </span>
          </div>

          <div class="site-header__butterfly-container">
            <img class="site-header__butterfly-img" src="../../layout/Butterfly-vulcan-papillon-vulcain-vanessa-atalanta-2.png"/>
          </div>
        </header>

        <a href="#top" class="back-to-top__link" title="⤒ Back to top of page"><span class="back-to-top__icon">⤒</span></a>

        <main>
          <xsl:apply-templates select="child::node() | child::processing-instruction()"/>
        </main>

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

      <div class="article-footer">
        <xsl:apply-templates select="$this-article-meta/date" mode="article-footer"/>
        <xsl:apply-templates select="$this-article-meta/author" mode="article-footer"/>
      </div>
    </article>
  </xsl:template>

  <xsl:template match="date" mode="article-footer">
    <xsl:variable name="month_number" select="substring-before(substring-after(., '-'), '-')"/>
    <div class="article-footer__date-wrapper">
      <time datetime="{.}" class="article-footer__date">
        <span class="article-footer__month">
          <span class="article-footer__month-name-short">
            <xsl:choose>
              <xsl:when test="$month_number = '01'">
                <xsl:text>Jan</xsl:text>
              </xsl:when>
              <xsl:when test="$month_number = '02'">
                <xsl:text>Feb</xsl:text>
              </xsl:when>
              <xsl:when test="$month_number = '03'">
                <xsl:text>Mar</xsl:text>
              </xsl:when>
              <xsl:when test="$month_number = '04'">
                <xsl:text>Apr</xsl:text>
              </xsl:when>
              <xsl:when test="$month_number = '05'">
                <xsl:text>May</xsl:text>
              </xsl:when>
              <xsl:when test="$month_number = '06'">
                <xsl:text>Jun</xsl:text>
              </xsl:when>
              <xsl:when test="$month_number = '07'">
                <xsl:text>Jul</xsl:text>
              </xsl:when>
              <xsl:when test="$month_number = '08'">
                <xsl:text>Aug</xsl:text>
              </xsl:when>
              <xsl:when test="$month_number = '09'">
                <xsl:text>Sep</xsl:text>
              </xsl:when>
              <xsl:when test="$month_number = '10'">
                <xsl:text>Oct</xsl:text>
              </xsl:when>
              <xsl:when test="$month_number = '11'">
                <xsl:text>Nov</xsl:text>
              </xsl:when>
              <xsl:when test="$month_number = '12'">
                <xsl:text>Dec</xsl:text>
              </xsl:when>
            </xsl:choose>
          </span>
          <span class="article-footer__date-part-seperator"><xsl:text>-</xsl:text></span>
          <span class="article-footer__month-day">
            <xsl:value-of select="substring-after(substring-after(., '-'), '-')"/>
          </span>
        </span>
        <span class="article-footer__date-part-seperator"><xsl:text>-</xsl:text></span>
        <span class="article-footer__year">
          <xsl:value-of select="substring-before(., '-')"/>
        </span>
      </time>
    </div>
  </xsl:template>

  <xsl:template match="author" mode="article-footer">
    <div class="article-footer__author">
      <xsl:value-of select="." />
    </div>
  </xsl:template>

  <xsl:template match="figure" name="figure">
    <figure>
      <xsl:copy-of select="attribute::*"/>
      <xsl:copy-of select="img/attribute::class"/>

      <xsl:apply-templates select="child::node() | child::processing-instruction()"/>
    </figure>
  </xsl:template>

  <xsl:template match="figure[contains(img/@class, 'semi-text-width')][./following-sibling::*[position()=1 and name(.)='figure']]">
    <div class="side-by-side-figure__container">
      <xsl:call-template name="figure" /> 

      <xsl:for-each select="following-sibling::*[position()=1 and name(.)='figure']">
        <xsl:call-template name="figure" /> 
      </xsl:for-each>
    </div>
  </xsl:template>

  <xsl:template match="figure[contains(img/@class, 'semi-text-width')][./preceding-sibling::*[position()=1 and name(.)='figure']]"/>

  <xsl:template match="img">
    <img>
      <xsl:copy-of select="attribute::*"/>
      <xsl:if test="@width">
        <xsl:attribute name="srcset">
          <xsl:choose>
            <xsl:when test="number(@width) &gt; number('1000')">
              <xsl:text>img-1000w/</xsl:text>
              <xsl:value-of select="@src"/>
              <xsl:text> 1000w</xsl:text>
              <xsl:if test="number(@width) &gt; number('500')">
                <xsl:text>, img-500w/</xsl:text>
                <xsl:value-of select="@src"/>
                <xsl:text> 500w</xsl:text>
              </xsl:if>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@src"/>
              <xsl:text> </xsl:text>
              <xsl:value-of select="@width"/>
              <xsl:text>w</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="sizes">
          <xsl:choose>
            <xsl:when test="contains(@class, 'semi-text-width')">
              <xsl:text>(min-width: 648px) 50vw 80ex</xsl:text>
            </xsl:when>
            <xsl:when test="contains(@class, 'text-width')">
              <xsl:text>80ex</xsl:text>
            </xsl:when>
            <xsl:when test="contains(@class, 'narrow')">
              <xsl:text>20ex</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message terminate="yes">Unspecified image format!</xsl:message>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="child::node() | child::processing-instruction()"/>
    </img>
  </xsl:template>

  <xsl:template match="processing-instruction('article-index')">
    <div class="article-index__container">
      <h2>Articles</h2>

      <ul class="article-index__list">
        <xsl:for-each select="$meta/page">
          <xsl:sort select="title" order="ascending"/>

          <xsl:if test="(not(draft) or draft='False') and (not(in_index) or in_index='True')">
            <li class="article-index__item">
              <xsl:apply-templates select="date" mode="article-index"/>

              <a href="/{slug}/" class="article-index__article-link">
                <cite class="article-index__article-title">
                  <xsl:value-of select="title"/>
                </cite>
              </a>
            </li>
          </xsl:if>
        </xsl:for-each>
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="date" mode="article-index">
    <xsl:variable name="month_number" select="substring-before(substring-after(., '-'), '-')"/>
    <time datetime="{.}" class="article-index__date">
      <span class="article-index__month">
        <span class="article-index__month-name-short">
          <xsl:choose>
            <xsl:when test="$month_number = '01'">
              <xsl:text>Jan</xsl:text>
            </xsl:when>
            <xsl:when test="$month_number = '02'">
              <xsl:text>Feb</xsl:text>
            </xsl:when>
            <xsl:when test="$month_number = '03'">
              <xsl:text>Mar</xsl:text>
            </xsl:when>
            <xsl:when test="$month_number = '04'">
              <xsl:text>Apr</xsl:text>
            </xsl:when>
            <xsl:when test="$month_number = '05'">
              <xsl:text>May</xsl:text>
            </xsl:when>
            <xsl:when test="$month_number = '06'">
              <xsl:text>Jun</xsl:text>
            </xsl:when>
            <xsl:when test="$month_number = '07'">
              <xsl:text>Jul</xsl:text>
            </xsl:when>
            <xsl:when test="$month_number = '08'">
              <xsl:text>Aug</xsl:text>
            </xsl:when>
            <xsl:when test="$month_number = '09'">
              <xsl:text>Sep</xsl:text>
            </xsl:when>
            <xsl:when test="$month_number = '10'">
              <xsl:text>Oct</xsl:text>
            </xsl:when>
            <xsl:when test="$month_number = '11'">
              <xsl:text>Nov</xsl:text>
            </xsl:when>
            <xsl:when test="$month_number = '12'">
              <xsl:text>Dec</xsl:text>
            </xsl:when>
          </xsl:choose>
        </span>
        <span class="article-index__date-part-seperator"><xsl:text>-</xsl:text></span>
        <span class="article-index__month-day">
          <xsl:value-of select="substring-after(substring-after(., '-'), '-')"/>
        </span>
      </span>
      <span class="article-index__date-part-seperator"><xsl:text>-</xsl:text></span>
      <span class="article-index__year">
        <xsl:value-of select="substring-before(., '-')"/>
      </span>
    </time>
  </xsl:template>

</xsl:stylesheet>

<!-- vim: set tabstop=2 shiftwidth=2 expandtab: -->
