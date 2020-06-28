<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" doctype-system="about:legacy-compat"/>

  <xsl:param name="img-width-1" select="number('2500')"/> <!-- That's about the resolution of my Samsung S7 Edge -->
  <xsl:param name="img-width-2" select="number('1000')"/> <!-- That's about the resolution of my Samsung S7 Edge -->
  <xsl:param name="slug"/>

  <xsl:variable name="meta" select="document('../htdocs/meta.xml')/pages"/>

  <xsl:variable name="taxonomies" select="document('../taxonomies.xml')/root"/>

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
      <meta name="theme-color" content="#000000"/>
      <link rel="stylesheet" type="text/css" href="../layout/style.css?v=28"/>
      <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Merriweather"/>
      <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Archivo+Narrow"/>

      <script type="text/javascript" src="../layout/enhance.js?v=4"></script>

      <xsl:apply-templates select="child::node() | child::processing-instruction()" />
    </head>
  </xsl:template>

  <xsl:template match="body">
    <body id="top" class="js-scroll-up-detection-with-threshold js-noscript" data-scroll-up-threshold-pixels-per-second="1000" data-scroll-up-threshold-milliseconds="100">
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
            <div class='site-footer-index'>
              <xsl:call-template name="footer-taxonomy">
                <xsl:with-param name="taxonomy-root" select="$taxonomies/project"/>
                <xsl:with-param name="taxonomy-title">Projects</xsl:with-param>
              </xsl:call-template>
              <xsl:call-template name="footer-taxonomy">
                <xsl:with-param name="taxonomy-root" select="$taxonomies/scale"/>
                <xsl:with-param name="taxonomy-title">Scale</xsl:with-param>
              </xsl:call-template>
              <xsl:call-template name="footer-taxonomy">
                <xsl:with-param name="taxonomy-root" select="$taxonomies/scope"/>
                <xsl:with-param name="taxonomy-title">Scope</xsl:with-param>
              </xsl:call-template>
            </div>
            <p class='site-footer__license'><a href="http://creativecommons.org/licenses/by-nc-sa/2.5/" rel="license">Copyleft</a>: you can share this content as long as you copy it right; that means that you must tell where it's from (from me) and that you have to ask permission first if you want to use my content commercially.</p>
            <p class='site-footer__colophon'><a href="https://github.com/bigsmoke/sapienshabitat/" rel="colophon">Colophon</a>: this website is open source; all the details about its technical design, the full file history and current drafts are freely accessible on-line.</p>
          </div>
        </footer>
      </div> <!-- .site-container -->

      <script>
        <xsl:text disable-output-escaping="yes">
          document.body.classList.remove('js-noscript');
        </xsl:text>
      </script>
    </body>
  </xsl:template>

  <xsl:template match="aside" mode="insert">
    <xsl:param name="taxonomy-term"/>
    <xsl:param name="taxonomy-value"/>
    <aside id="{$taxonomy-term}">
      <xsl:copy-of select="attribute::*"/>
      <div class="insert__content">
        <xsl:apply-templates select="child::node() | child::processing-instruction()"/>
      </div>
      <nav class="insert__sibling-nav">
        <div class="insert__sibling-scroll">
          <span class="insert__sibling-scroll-icon js-triggerHorizontalScrollingOfArticleListInInsert" data-scroll-direction="left">
            <svg class="insert__sibling-scroll-icon-svg" version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
              <polygon points="0,50 100,100 100,0" fill="currentColor"/>
            </svg>
          </span>
        </div>
        <ul class="insert__sibling-list js-horizontallyScrollableArticleListInInsert">
          <xsl:for-each select="$meta/page[published and taxonomy/child::node()[name(.) = $taxonomy-term] = $taxonomy-value]">
            <xsl:sort select="date"/>
            <li>
              <xsl:attribute name="class">
                <xsl:text>insert__sibling-article</xsl:text>
                <xsl:if test="slug = $this-article-meta/slug">
                  <xsl:text> insert__sibling-article--this</xsl:text>
                </xsl:if>
              </xsl:attribute>
              <a class="insert__sibling-link" href="/{slug}/">
                <div class="insert__sibling-date">
                  <xsl:apply-templates select="date" mode="article-footer"/>
                </div>
                <div class="insert__sibling-title">
                  <xsl:value-of select="title"/>
                </div>
                <div class="insert__sibling-author-container">
                  <div class="insert__sibling-author-initials">
                    <xsl:value-of select="author-initials"/>
                  </div>
                </div>
              </a>
            </li>
          </xsl:for-each>
        </ul>
        <div class="insert__sibling-scroll">
          <span class="insert__sibling-scroll-icon js-triggerHorizontalScrollingOfArticleListInInsert" data-scroll-direction="right">
            <svg class="insert__sibling-scroll-icon-svg" version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
              <polygon points="0,0 100,50 0,100" fill="currentColor"/>
            </svg>
          </span>
        </div>
      </nav>
    </aside>
  </xsl:template>

  <xsl:template name="footer-taxonomy">
    <xsl:param name="taxonomy-root"/>
    <xsl:param name="taxonomy-title"/>
    <xsl:variable name="taxonomy-name" select="name($taxonomy-root)"/>

    <div class='site-footer-taxonomy'>
      <h5 class='site-footer-taxonomy__title'>
        <xsl:value-of select="$taxonomy-title"/>
      </h5>
      <ul class='site-footer-taxonomy__terms'>
        <xsl:for-each select="$taxonomy-root/*">
          <xsl:sort select="sort" data-type="number"/>
          <xsl:variable name="taxonomy-term-name" select="name()"/>
          <li class='site-footer-taxonomy__term' data-taxonomy-term="{$taxonomy-term-name}">
            <h6 class='site-footer-taxonomy__term-title'>
              <xsl:value-of select="title"/>
            </h6>
            <ul class='site-footer-taxonomy__articles'>
              <xsl:for-each select="$meta/page[taxonomy/*[name()=$taxonomy-name][text()=$taxonomy-term-name]]">
                <xsl:sort select="published"/>
                <xsl:if test="not(draft) or draft='False'">
                  <li class='site-footer-taxonomy__article'>
                    <a class="site-footer-taxonomy__article-link" href="/{slug}/">
                      <xsl:value-of select="title"/>
                    </a>
                  </li>
                </xsl:if>
              </xsl:for-each>
            </ul>
          </li>
        </xsl:for-each>
      </ul>
    </div>
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

  <xsl:template name="find-side-by-side-position">
    <xsl:variable name="first-preceding-non-figure" select="preceding-sibling::*[not(self::figure and contains(img/@class, 'semi-text-width'))][1]"/>
    <xsl:value-of select="count(preceding-sibling::*)
      - count($first-preceding-non-figure/preceding-sibling::* | $first-preceding-non-figure)
      + number('1')"
    />
  </xsl:template>

  <xsl:template match="figure">
    <xsl:variable name="class" select="img/attribute::class"/>
    <xsl:variable name="side-by-side" select="contains($class, 'semi-text-width')"/>
    <xsl:variable name="side-by-side-position">
      <xsl:call-template name="find-side-by-side-position"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$side-by-side and $side-by-side-position = number('2')">
        <!-- Ignore the second of each pair of figure.semi-text-width siblings. -->
      </xsl:when>
      <xsl:otherwise>
        <div class="figure__container figure__container--{$class}">
          <!-- Process the first of the two figure.semi-text-width siblings: -->
          <xsl:apply-templates select="." mode="figure"/>

          <xsl:if test="$side-by-side and $side-by-side-position = number('1')">
            <!-- Process the second of the two figure.semi-text-width siblings: -->
            <xsl:apply-templates select="following-sibling::*[position()=1 and name(.)='figure']" mode="figure"/>

            <xsl:if test="not(following-sibling::*[position()=1 and name(.)='figure'])">
              <xsl:message terminate="no">Second sibling of `figure.semi-text-width` pair not found.</xsl:message>
            </xsl:if>
          </xsl:if>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="figure" mode="figure">
    <!-- Matches non-semi-text-width figures and is called by name from the figure__container -->
    <figure>
      <xsl:copy-of select="attribute::*"/>

      <xsl:attribute name="class">
        <xsl:text>figure figure--</xsl:text>
        <xsl:value-of select="img/attribute::class"/>
      </xsl:attribute>

      <xsl:attribute name="style">
        <xsl:text>--image-aspect-ratio: </xsl:text>
        <xsl:value-of select="number(img/@width) div number(img/@height)"/>
        <xsl:text>;</xsl:text>
      </xsl:attribute>

      <xsl:apply-templates select="child::node() | child::processing-instruction()" mode="figure"/>
    </figure>
  </xsl:template>

  <xsl:template match="img" mode="figure">
    <xsl:if test="not(@width)">
      <xsl:message terminate="yes">
        &lt;img width/&gt; missing for <xsl:value-of select="@src"/>.
      </xsl:message>
    </xsl:if>

    <xsl:if test="not(@height)">
      <xsl:message terminate="yes">
        &lt;img height/&gt; missing for <xsl:value-of select="@src"/>.
      </xsl:message>
    </xsl:if>

    <img>
      <xsl:apply-templates select="attribute::*" mode="figure"/>

      <xsl:attribute name="class">
        <xsl:text>figure__img figure__img--</xsl:text>
        <xsl:value-of select="attribute::class"/>
      </xsl:attribute>

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
      <xsl:apply-templates select="child::node() | child::processing-instruction()"/>
    </img>
  </xsl:template>

  <xsl:template match="img/@*" mode="figure">
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="img/@width | img/@height" mode="figure"/>

  <xsl:template match="figcaption" mode="figure">
    <figcaption>
      <xsl:copy-of select="attribute::*"/>

      <xsl:attribute name="class">
        <xsl:text>figure__figcaption figure__figcaption--</xsl:text>
        <xsl:value-of select="../img/@class"/>
      </xsl:attribute>

      <xsl:apply-templates select="child::node() | child::processing-instruction()"/>
    </figcaption>
  </xsl:template>

  <xsl:template match="iframe[starts-with(@src, 'https://www.youtube.com/embed/')]">
    <xsl:if test="not(@data-aspect-ratio)">
      <xsl:message terminate="yes">`data-aspect-ratio` attribute required for video embeds.</xsl:message>
    </xsl:if>

    <div class="video__container">
      <figure class="video__figure" style="--video-aspect-ratio: {@data-aspect-ratio};">
        <div class="video__aspect-rationer" style="--video-aspect-ratio: {@data-aspect-ratio};">
          <iframe class="video__iframe" style="--video-aspect-ratio: {@data-aspect-ratio};">
            <xsl:apply-templates select="attribute::*"/>
          </iframe>
        </div>
        <!--
        <xsl:if test="@title">
          <figcaption class="video__figcaption">
            <xsl:value-of select="@title"/>
          </figcaption>
        </xsl:if>
        -->
      </figure>
    </div>
  </xsl:template>

  <xsl:template match="iframe[starts-with(@src, 'https://www.youtube.com/embed/')]/@src">
    <xsl:attribute name="src">
      <xsl:value-of select="."/>
      <xsl:text>?hl=1</xsl:text>
      <xsl:text>&amp;iv_load_policy=3</xsl:text>
      <xsl:text>&amp;rel=0</xsl:text>
      <xsl:text>&amp;controls=0</xsl:text>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="processing-instruction('project-insert')">
    <xsl:variable name="project" select="$this-article-meta/taxonomy/project"/>
    <xsl:if test="$this-article-meta/insert[item=$project]">
      <xsl:apply-templates select="document(concat('../blocks/', $project, '/block.xhtml5'))/aside" mode="insert">
        <xsl:with-param name="taxonomy-term">project</xsl:with-param>
        <xsl:with-param name="taxonomy-value" select="$project"/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template>

  <xsl:template match="processing-instruction('scope-insert')">
    <xsl:variable name="scope" select="$this-article-meta/taxonomy/scope"/>
    <xsl:if test="$this-article-meta/insert[item=$scope]">
      <xsl:apply-templates select="document(concat('../blocks/', $scope, '/block.xhtml5'))/aside" mode="insert">
        <xsl:with-param name="taxonomy-term">scope</xsl:with-param>
        <xsl:with-param name="taxonomy-value" select="$scope"/>
      </xsl:apply-templates>
    </xsl:if>
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
