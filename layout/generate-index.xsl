<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <!--
    This stylesheet serves to create a plain index page, which will then be
	  further processed by add-layout.xsl. The plain XHTML5 page created is
	  thus comparable to the plain XHTML5 created from the page.markdown source
	  file.
  -->

  <xsl:output method="xml"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>Index</title>
      </head>

      <body>
        <article>
          <h1>Index</h1>

          <xsl:apply-templates select="pages"/>
        </article>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="pages">
    <h2>Articles</h2>

    <ul>
      <xsl:for-each select="page">
        <xsl:sort select="title" order="ascending"/>

        <xsl:if test="not(draft) or draft='False'">
          <li>
            <a href="/{slug}/">
              <xsl:value-of select="title"/>
            </a>
          </li>
        </xsl:if>
      </xsl:for-each>
    </ul>
  </xsl:template>

</xsl:stylesheet>

<!-- vim: set tabstop=2 shiftwidth=2 expandtab: -->
