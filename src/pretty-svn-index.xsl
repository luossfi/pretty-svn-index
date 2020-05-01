<?xml version="1.0" encoding="UTF-8" ?>
<!--
  ~ Pretty SVN Index - a good-looking theme for Subversion indexes
  ~ Copyright (C) 2020 Steff Lukas <steff.lukas@luossfi.org>
  ~
  ~ This program is free software: you can redistribute it and/or modify
  ~ it under the terms of the GNU General Public License as published by
  ~ the Free Software Foundation, either version 3 of the License, or
  ~ (at your option) any later version.
  ~
  ~ This program is distributed in the hope that it will be useful,
  ~ but WITHOUT ANY WARRANTY; without even the implied warranty of
  ~ MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  ~ GNU General Public License for more details.
  ~
  ~ You should have received a copy of the GNU General Public License
  ~ along with this program.  If not, see <https://www.gnu.org/licenses/>.
  -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
  <xsl:output method="html" indent="yes" encoding="utf-8"/>

  <!-- ====== Main Template ====== -->
  <xsl:template match="/svn">
    <html>
      <head>
        <meta name="viewport" content="width=device-width,initial-scale=1"/>
        <xsl:call-template name="head-title"/>
        <link rel="stylesheet" type="text/css" href="/css/normalize.css"/>
        <link rel="stylesheet" type="text/css" href="/css/fonts.css"/>
        <link rel="stylesheet" type="text/css" href="/css/fontawesome-free.css"/>
        <link rel="stylesheet" type="text/css" href="/css/pretty-svn-index.css"/>
      </head>
      <body>
        <div class="page-wrapper">
          <xsl:call-template name="page-header"/>
          <xsl:call-template name="page-main"/>
          <xsl:call-template name="page-footer"/>
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- ====== Major Page Part Templates ====== -->
  <xsl:template name="head-title">
    <title>
      <xsl:choose>
        <xsl:when test="index[@path and not(starts-with(@path, '/'))]">
          <xsl:apply-templates select="index" mode="repos-root"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="index" mode="title"/>
        </xsl:otherwise>
      </xsl:choose>
    </title>
  </xsl:template>

  <xsl:template name="page-header">
    <header>
      <xsl:choose>
        <xsl:when test="index[@path and not(starts-with(@path, '/'))]">
          <h1 class="with-icon-prefix">
            <span class="icon-prefix icon-repository" aria-hidden="true"/>
            <xsl:apply-templates select="index" mode="repos-root"/>
          </h1>
        </xsl:when>
        <xsl:otherwise>
          <h1 class="with-icon-prefix">
            <span class="icon-prefix icon-repository" aria-hidden="true"/>
            <xsl:apply-templates select="index" mode="title"/>
          </h1>
          <h2 class="with-icon-prefix">
            <span class="icon-prefix icon-path" aria-hidden="true"/>
            <xsl:apply-templates select="index" mode="path"/>
          </h2>
        </xsl:otherwise>
      </xsl:choose>
    </header>
  </xsl:template>

  <xsl:template name="page-main">
    <main>
      <ul>
        <xsl:apply-templates select="index/updir"/>
        <xsl:apply-templates select="index/dir">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="index/file">
          <xsl:sort select="@name"/>
        </xsl:apply-templates>
      </ul>
    </main>
  </xsl:template>

  <xsl:template name="page-footer">
    <footer>
      <p>
        <xsl:text>powered by </xsl:text>
        <xsl:element name="a">
          <xsl:attribute name="href">
            <xsl:value-of select="@href"/>
          </xsl:attribute>
          <xsl:attribute name="target">
            <xsl:text>_blank</xsl:text>
          </xsl:attribute>
          <xsl:text>Subversion</xsl:text>
        </xsl:element>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@version"/>
      </p>
      <p class="credits">made with
        <span class="icon-heart" aria-hidden="true"/>
        <span class="sr-only">love</span>
        by
        <a href="https://www.luossfi.org/" target="_blank">luOSSfi</a>
      </p>
    </footer>
  </xsl:template>

  <!-- ====== Building Blocks Templates ====== -->
  <xsl:template match="index" mode="repos-root">
    <xsl:value-of select="@path"/>
  </xsl:template>

  <xsl:template match="index" mode="title">
    <xsl:choose>
      <xsl:when test="@name or @base or @rev">
        <xsl:value-of select="@name"/>
        <xsl:if test="@base">
          <xsl:if test="@name">
            <xsl:text>: </xsl:text>
          </xsl:if>
          <xsl:value-of select="@base"/>
        </xsl:if>
        <xsl:if test="@rev">
          <xsl:if test="@base or @name">
            <xsl:text> @ </xsl:text>
          </xsl:if>
          <xsl:text>revision </xsl:text>
          <xsl:value-of select="@rev"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>n/a</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="index" mode="path">
    <xsl:choose>
      <xsl:when test="@path">
        <xsl:value-of select="@path"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>n/a</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="updir">
    <li class="with-icon-prefix">
      <span class="icon-prefix icon-folder" aria-hidden="true"/>
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="@href"/>
        </xsl:attribute>
        <xsl:attribute name="aria-label">
          <xsl:text>parent directory</xsl:text>
        </xsl:attribute>
        <xsl:text>../</xsl:text>
      </xsl:element>
    </li>
  </xsl:template>

  <xsl:template match="dir">
    <li class="with-icon-prefix">
      <span class="icon-prefix icon-folder" aria-hidden="true"/>
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="@href"/>
        </xsl:attribute>
        <xsl:attribute name="aria-label">
          <xsl:text>directory </xsl:text>
          <xsl:value-of select="@name"/>
        </xsl:attribute>
        <xsl:value-of select="@name"/>
        <xsl:text>/</xsl:text>
      </xsl:element>
    </li>
  </xsl:template>

  <xsl:template match="file">
    <li class="with-icon-prefix">
      <span class="icon-prefix icon-file" aria-hidden="true"/>
      <xsl:element name="a">
        <xsl:attribute name="href">
          <xsl:value-of select="@href"/>
        </xsl:attribute>
        <xsl:attribute name="aria-label">
          <xsl:text>file </xsl:text>
          <xsl:value-of select="@name"/>
        </xsl:attribute>
        <xsl:value-of select="@name"/>
      </xsl:element>
    </li>
  </xsl:template>
</xsl:stylesheet>
