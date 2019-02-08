<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:epub="http://www.idpf.org/2007/ops"
                xmlns:dlxs="http://mlib.umich.edu/namespace/dlxs"
                xmlns:mlibxsl="http://www.mlib.umich.edu/namespace/mlibxsl"
                exclude-result-prefixes="xs xi tei marc html dlxs epub mlibxsl"
                version="2.0">

    <xsl:import href="hebtei2epub.xsl"/>

    <xsl:variable name="renditions" select="'fixed_scan fixed_ocr'"/>
    <xsl:variable name="rendList" select="tokenize($renditions, ' ')"/>

    <xsl:variable name="manifestItemList"
                  select="$imagesTable/html:tr[html:td[@class='source' and ends-with(string(),'.png')]]"/>
    <xsl:variable name="spineItemList" select="/tei:TEI/tei:text/tei:body//tei:p/tei:pb[exists(@n)]"/>

    <xsl:template match="tei:text">
        <xsl:param name="rendition"/>

        <xsl:variable name="textList" select="*"/>

        <xsl:element name="manifest" namespace="{$IDPF_URL}">

            <!-- Stylesheets -->
            <xsl:for-each select="$stylesList">
                <xsl:element name="item" namespace="{$IDPF_URL}">
                    <xsl:attribute name="id" select="concat('stylesheet',position())"/>
                    <xsl:attribute name="href" select="concat('styles',$FILE_SEPARATOR,.)"/>
                    <xsl:attribute name="media-type" select="'text/css'"/>
                </xsl:element>
            </xsl:for-each>

            <!-- Fonts -->
            <xsl:for-each select="$fontsList">
                <xsl:element name="item" namespace="{$IDPF_URL}">
                    <xsl:attribute name="id" select="concat('font',position())"/>
                    <xsl:attribute name="href" select="concat('fonts',$FILE_SEPARATOR,.)"/>
                    <xsl:attribute name="media-type" select="'application/vnd.ms-opentype'"/>
                </xsl:element>
            </xsl:for-each>

            <!-- Cover images -->
            <xsl:variable name="coverBasePath" select="$coverImageRow/html:td[@class='asset']"/>
            <xsl:element name="item" namespace="{$IDPF_URL}">
                <xsl:attribute name="id" select="'cover-image'"/>
                <xsl:attribute name="media-type" select="$coverImageRow/html:td[@class='mime-type']"/>
                <xsl:attribute name="href" select="concat('images',$FILE_SEPARATOR,$coverBasePath)"/>
            </xsl:element>
            <xsl:for-each select="$otherCoverRows">
                <xsl:element name="item" namespace="{$IDPF_URL}">
                    <xsl:attribute name="id" select="concat('cover',position(),'-image')"/>
                    <xsl:attribute name="media-type" select="./html:td[@class='mime-type']"/>
                    <xsl:attribute name="href" select="concat('images',$FILE_SEPARATOR,./html:td[@class='asset'])"/>
                </xsl:element>
            </xsl:for-each>

            <!-- Navigation -->
            <xsl:element name="item" namespace="{$IDPF_URL}">
                <xsl:attribute name="id" select="'toc'"/>
                <xsl:attribute name="href" select="concat('toc_', $rendition, '.xhtml')"/>
                <xsl:attribute name="media-type" select="'application/xhtml+xml'"/>
                <xsl:attribute name="properties" select="'nav'"/>
            </xsl:element>
             <xsl:if test="count($pgList) > 0">
                <xsl:element name="item" namespace="{$IDPF_URL}">
                    <xsl:attribute name="id" select="'pagelist'"/>
                    <xsl:attribute name="href" select="concat('pagelist_', $rendition, '.xhtml')"/>
                    <xsl:attribute name="media-type" select="'application/xhtml+xml'"/>
                </xsl:element>
            </xsl:if>
            <xsl:element name="item" namespace="{$IDPF_URL}">
                <xsl:attribute name="id" select="'chapterlist'"/>
                <xsl:attribute name="href" select="concat('chapterlist_', $rendition, '.xhtml')"/>
                <xsl:attribute name="media-type" select="'application/xhtml+xml'"/>
            </xsl:element>

            <!-- Included assets (images, etc.) -->
            <xsl:for-each select="$assetsTable/html:tr">
                <xsl:if test="./html:td[@class='cover-image']='no' and ./html:td[@class='inclusion']='yes'">
                    <xsl:element name="item" namespace="{$IDPF_URL}">
                        <xsl:attribute name="id" select="./html:td[@class='asset']"/>
                        <xsl:attribute name="href" select="concat('images',$FILE_SEPARATOR,./html:td[@class='asset'])"/>
                        <xsl:attribute name="media-type" select="./html:td[@class='mime-type']"/>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>

            <!-- HTML documents -->
            <!-- Cover page document -->
            <xsl:element name="item" namespace="{$IDPF_URL}">
                <xsl:attribute name="id" select="'cover'"/>
                <xsl:attribute name="href" select="concat('xhtml',$FILE_SEPARATOR,'cover.xhtml')"/>
                <xsl:attribute name="media-type" select="'application/xhtml+xml'"/>
            </xsl:element>
            <xsl:if test="$rendition ='fixed_scan'">
                <xsl:variable name="path" select="concat($epubXHTMLDir,'cover.xhtml')"/>
                <xsl:result-document href="{$path}" method="xml">
                    <xsl:element name="html" namespace="{$HTML_URL}">
                        <xsl:namespace name="epub" select="$OPS_URL"/>

                        <xsl:variable name="imgRow" select="mlibxsl:getImgNode($coverBasePath, $rendition)"/>
                        <xsl:variable name="width">
                            <xsl:choose>
                                <xsl:when test="exists($imgRow)">
                                    <xsl:value-of select="$imgRow/html:td[@class='width']"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'auto'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="height">
                            <xsl:choose>
                                <xsl:when test="exists($imgRow)">
                                    <xsl:value-of select="$imgRow/html:td[@class='height']"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'auto'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:call-template name="generateHtmlHead">
                            <xsl:with-param name="width" select="$width"/>
                            <xsl:with-param name="height" select="$height"/>
                        </xsl:call-template>
                        <xsl:element name="body" namespace="{$HTML_URL}">
                            <xsl:attribute name="class" select="'svg_cover'"/>

                            <xsl:element name="section" namespace="{$HTML_URL}">
                                <xsl:attribute name="id" select="'cover'"/>
                                <xsl:attribute name="class" select="'text-center'"/>
                                <xsl:attribute name="role" select="'doc-cover'"/>
                                <xsl:attribute name="epub:type" select="'cover'"/>

                                <xsl:element name="img" namespace="{$HTML_URL}">
                                    <xsl:attribute name="src" select="concat('..',$FILE_SEPARATOR,'images',$FILE_SEPARATOR,$coverBasePath)"/>
                                    <xsl:attribute name="class" select="'cover-image'"/>
                                    <xsl:attribute name="alt" select="concat('Cover image for book ', $dc-title-list[1])"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:result-document>
            </xsl:if>

            <xsl:for-each select="$textList">
                <xsl:apply-templates select=".">
                        <xsl:with-param name="rendition" select="$rendition"/>
                </xsl:apply-templates>
                <!--
                <xsl:if test="./html:td[@class='dest' and ends-with(string(),'.png')]">
                    <xsl:element name="item" namespace="{$IDPF_URL}">
                        <xsl:attribute name="id" select="concat('image',substring-before(./html:td[@class='dest'],'.png'))"/>
                        <xsl:attribute name="href" select="concat('images',$FILE_SEPARATOR,./html:td[@class='dest'])"/>
                        <xsl:attribute name="media-type" select="'image/png'"/>
                    </xsl:element>
                </xsl:if>
                -->
            </xsl:for-each>

        </xsl:element>

        <xsl:element name="spine" namespace="{$IDPF_URL}">
            <xsl:element name="itemref" namespace="{$IDPF_URL}">
                <xsl:attribute name="idref" select="'cover'"/>
            </xsl:element>
            <xsl:for-each-group select="$spineItemList" group-by="@dlxs:seq">
                <xsl:sort select="@dlxs:seq"/>

                <xsl:apply-templates select="." mode="spine"/>
            </xsl:for-each-group>
        </xsl:element>

    </xsl:template>

    <xsl:template match="tei:front|tei:body|tei:back">
        <xsl:param name="rendition"/>

        <xsl:choose>
            <xsl:when test="$rendition = 'fixed_scan'">
                <xsl:for-each-group select="$manifestItemList" group-by="html:td[@class='source']">
                    <xsl:sort select="html:td[@class='source']"/>

                    <xsl:apply-templates select=".">
                        <xsl:with-param name="rendition" select="$rendition"/>
                    </xsl:apply-templates>
                </xsl:for-each-group>
            </xsl:when>
            <xsl:when test="$rendition = 'fixed_ocr'">
                <xsl:for-each-group select="$pgList" group-by="@dlxs:seq">
                    <xsl:sort select="@dlxs:seq"/>

                    <xsl:apply-templates select=".">
                        <xsl:with-param name="rendition" select="$rendition"/>
                    </xsl:apply-templates>
                </xsl:for-each-group>
            </xsl:when>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="html:tr">
        <xsl:param name="rendition"/>

        <xsl:variable name="seq" select="substring-before(html:td[@class='source'],'.png')"/>

        <xsl:variable name="baseHtmlPath"
                      select="concat('xhtml', $FILE_SEPARATOR, $seq, '_', $rendition, '.xhtml')"/>

        <xsl:variable name="baseImgPath" select="concat('images', $FILE_SEPARATOR, $seq,'.png')"/>
        <xsl:variable name="imgSrc" select="concat('..', $FILE_SEPARATOR, $baseImgPath)"/>

        <xsl:variable name="path" select="concat($epubContentDir, $baseHtmlPath)"/>

        <xsl:result-document href="{$path}" method="xml">
            <xsl:element name="html" namespace="{$HTML_URL}">
                <xsl:variable name="imgRow" select="mlibxsl:getImgNode(concat($seq,'.png'), $rendition)"/>
                <xsl:variable name="width">
                    <xsl:choose>
                        <xsl:when test="exists($imgRow)">
                            <xsl:value-of select="$imgRow/html:td[@class='width']"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'auto'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="height">
                    <xsl:choose>
                        <xsl:when test="exists($imgRow)">
                            <xsl:value-of select="$imgRow/html:td[@class='height']"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'auto'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="generateHtmlHead">
                    <xsl:with-param name="width" select="$width"/>
                    <xsl:with-param name="height" select="$height"/>
                </xsl:call-template>
                <xsl:element name="body" namespace="{$HTML_URL}">
                    <xsl:element name="figure" namespace="{$HTML_URL}">
                        <xsl:attribute name="id">
                            <xsl:value-of select="concat('figure', position())"/>
                        </xsl:attribute>
                        <xsl:element name="img" namespace="{$HTML_URL}">
                            <xsl:attribute name="src">
                                <xsl:value-of select="$imgSrc"/>
                            </xsl:attribute>
                            <xsl:attribute name="alt">
                                <xsl:value-of select="concat('Page ',$seq)"/>
                            </xsl:attribute>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:result-document>

        <xsl:element name="item" namespace="{$IDPF_URL}">
            <xsl:attribute name="id" select="concat('xhtml',$seq)"/>
            <xsl:attribute name="href" select="$baseHtmlPath"/>
            <xsl:attribute name="media-type" select="'application/xhtml+xml'"/>
        </xsl:element>
        <xsl:element name="item" namespace="{$IDPF_URL}">
            <xsl:attribute name="id" select="concat('image',$seq)"/>
            <xsl:attribute name="href" select="$baseImgPath"/>
            <xsl:attribute name="media-type" select="'image/png'"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:p/tei:pb">
        <xsl:param name="rendition"/>

        <xsl:variable name="seq" select="@dlxs:seq"/>

        <xsl:variable name="baseHtmlPath"
                      select="concat('xhtml', $FILE_SEPARATOR, $seq, '_', $rendition, '.xhtml')"/>

        <xsl:variable name="path" select="concat($epubContentDir, $baseHtmlPath)"/>

        <xsl:result-document href="{$path}" method="xml">
            <xsl:element name="html" namespace="{$HTML_URL}">
                <xsl:element name="head" namespace="{$HTML_URL}">
                    <xsl:element name="meta" namespace="{$HTML_URL}">
                        <xsl:attribute name="name" select="'viewport'"/>
                        <xsl:attribute name="content" select="'width=auto,height=auto'"/>
                    </xsl:element>
                    <xsl:call-template name="insertStyles"/>
                </xsl:element>
                <xsl:element name="body" namespace="{$HTML_URL}">
                    <xsl:element name="div" namespace="{$HTML_URL}">
                        <xsl:attribute name="id" select="concat('text', position())"/>

                        <xsl:for-each select="../text()">
                            <xsl:if test="string-length(normalize-space(.)) > 0">
                                <xsl:analyze-string select="." regex="\n([^\n]+)\n">
                                    <xsl:matching-substring>
                                        <xsl:element name="p" namespace="{$HTML_URL}">
                                            <xsl:value-of select="regex-group(1)"/>
                                        </xsl:element>
                                    </xsl:matching-substring>
                                    <xsl:non-matching-substring>
                                        <xsl:if test="string-length(normalize-space(.)) != 0">
                                            <xsl:value-of select="normalize-space(.)"/>
                                        </xsl:if>
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:result-document>

        <xsl:element name="item" namespace="{$IDPF_URL}">
            <xsl:attribute name="id" select="concat('xhtml',$seq)"/>
            <xsl:attribute name="href" select="$baseHtmlPath"/>
            <xsl:attribute name="media-type" select="'application/xhtml+xml'"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:p/tei:pb" mode="spine">
        <xsl:element name="itemref" namespace="{$IDPF_URL}">
            <xsl:attribute name="idref" select="concat('xhtml',@dlxs:seq)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:head">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <xsl:template match="tei:hi">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="tei:biblScope">
        <xsl:choose>
            <xsl:when test="@unit='page'">
                <xsl:value-of select="concat('page ', .)"/>
            </xsl:when>
            <xsl:when test="@unit='para'">
                <xsl:value-of select="concat('para. ', .)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:bibl/tei:author">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <!--
    <xsl:template name="generate_nav">
        <xsl:param name="itemList"/>
        <xsl:param name="href"/>
        <xsl:param name="navType"/>
        <xsl:param name="navHeader"/>
        <xsl:param name="rendition"/>
        <xsl:param name="isHidden" select="'no'"/>

        <xsl:result-document href="{$href}" method="xml">
            <xsl:element name="html" namespace="{$HTML_URL}">
                <xsl:element name="head" namespace="{$HTML_URL}">
                    <xsl:element name="meta" namespace="{$HTML_URL}">
                        <xsl:attribute name="name" select="'viewport'"/>
                        <xsl:attribute name="content" select="'width=device-width,height=device-height'"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="body" namespace="{$HTML_URL}">
                    <xsl:element name="nav" namespace="{$HTML_URL}">
                        <xsl:namespace name="epub" select="$OPS_URL"/>
                        <xsl:attribute name="id" select="$navType"/>
                        <xsl:attribute name="epub:type" namespace="{$OPS_URL}" select="$navType"/>
                        <xsl:if test="$isHidden='yes'">
                            <xsl:attribute name="hidden" select="''"/>
                        </xsl:if>
                        <xsl:element name="h1" namespace="{$HTML_URL}">
                            <xsl:value-of select="$navHeader"/>
                        </xsl:element>

                        <xsl:choose>
                            <xsl:when test="$navType='toc'">
                                <xsl:call-template name="generateTOC">
                                    <xsl:with-param name="itemList" select="$itemList"/>
                                    <xsl:with-param name="rendition" select="$rendition"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="$navType='page-list'">
                                <xsl:call-template name="generatePGList">
                                    <xsl:with-param name="itemList" select="$itemList"/>
                                    <xsl:with-param name="rendition" select="$rendition"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="$navType='chapter-list'">
                                <xsl:call-template name="generateCHList">
                                    <xsl:with-param name="itemList" select="$itemList"/>
                                    <xsl:with-param name="rendition" select="$rendition"/>
                                </xsl:call-template>
                            </xsl:when>
                        </xsl:choose>

                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:result-document>

    </xsl:template>
    -->

    <xsl:template name="generateHtmlHead">
        <xsl:param name="width" required="yes"/>
        <xsl:param name="height" required="yes"/>

        <xsl:element name="head" namespace="{$HTML_URL}">
            <xsl:element name="meta" namespace="{$HTML_URL}">
                <xsl:attribute name="name" select="'viewport'"/>
                <xsl:attribute name="content" select="concat('width=',$width,',height=',$height)"/>
            </xsl:element>
            <xsl:call-template name="insertStyles"/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="generateContainerRenditionLabel">
        <xsl:param name="rendition"/>

        <xsl:attribute name="rendition:label" namespace="{$IDPF_RENDITION_URL}">
            <xsl:choose>
                <xsl:when test="$rendition = 'fixed_scan'">
                    <xsl:value-of select="'Page Scan'"/>
                </xsl:when>
                <xsl:when test="$rendition = 'fixed_ocr'">
                    <xsl:value-of select="'Text'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'(unknown)'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>

    <xsl:template name="generateContainerLayout">
        <xsl:attribute name="rendition:layout" namespace="{$IDPF_RENDITION_URL}">
            <xsl:value-of select="'pre-paginated'"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template name="generatePackageLayout">
        <xsl:element name="meta" namespace="{$IDPF_URL}">
            <xsl:attribute name="property" select="'rendition:layout'"/>
            <xsl:value-of select="'pre-paginated'"/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="generateTOC">
        <xsl:param name="itemList"/>
        <xsl:param name="rendition"/>
        <xsl:param name="init" select="'no'"/>

        <xsl:if test="($init='yes' and exists($coverImageRow)) or count($itemList) > 0">
            <xsl:element name="ol" namespace="{$HTML_URL}">
                <xsl:if test="$init='yes' and exists($coverImageRow)">
                    <xsl:element name="li" namespace="{$HTML_URL}">
                        <xsl:element name="a" namespace="{$HTML_URL}">
                            <xsl:attribute name="href"
                                           select="concat('xhtml', $FILE_SEPARATOR, 'cover.xhtml')"/>
                            <xsl:value-of select="'Cover'"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
                <xsl:for-each select="$itemList">
                    <xsl:variable name="div" select="."/>
                    <xsl:variable name="pbList" select="./tei:p[1][exists(./tei:pb)]"/>
                    <xsl:choose>
                        <xsl:when test="count($pbList) > 0">
                            <xsl:for-each-group select="$pbList" group-by="./tei:pb/@dlxs:seq">
                                <xsl:sort select="./tei:pb/@dlxs:seq"/>

                                <xsl:element name="li" namespace="{$HTML_URL}">
                                    <xsl:element name="a" namespace="{$HTML_URL}">
                                        <xsl:attribute name="href"
                                                       select="concat('xhtml', $FILE_SEPARATOR, $div/tei:p[1]/tei:pb/@dlxs:seq,'_', $rendition, '.xhtml')"/>
                                        <xsl:call-template name="genEntry">
                                            <xsl:with-param name="div" select="$div"/>
                                        </xsl:call-template>
                                    </xsl:element>

                                    <xsl:call-template name="generateTOC">
                                        <xsl:with-param name="itemList" select="$div/tei:div"/>
                                        <xsl:with-param name="rendition" select="$rendition"/>
                                    </xsl:call-template>
                                </xsl:element>
                            </xsl:for-each-group>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="li" namespace="{$HTML_URL}">
                                <xsl:call-template name="genEntry">
                                    <xsl:with-param name="div" select="$div"/>
                                </xsl:call-template>

                                <xsl:call-template name="generateTOC">
                                    <xsl:with-param name="itemList" select="$div/tei:div"/>
                                    <xsl:with-param name="rendition" select="$rendition"/>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>

                </xsl:for-each>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template name="generatePGList">
        <xsl:param name="itemList"/>
        <xsl:param name="rendition"/>

        <xsl:if test="count($itemList) > 0">
            <xsl:element name="ol" namespace="{$HTML_URL}">
                <xsl:for-each-group select="$itemList" group-by="@dlxs:seq">
                    <xsl:sort select="@dlxs:seq"/>

                    <xsl:element name="li" namespace="{$HTML_URL}">
                        <xsl:element name="a" namespace="{$HTML_URL}">
                            <xsl:attribute name="href" select="concat('xhtml/',@dlxs:seq,'_', $rendition, '.xhtml')"/>
                            <xsl:value-of select="@n"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each-group>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template name="generateCHList">
        <xsl:param name="itemList"/>
        <xsl:param name="rendition"/>

        <xsl:if test="count($itemList) > 0">
            <xsl:element name="ol" namespace="{$HTML_URL}">

                <xsl:for-each-group select="$itemList" group-by="./tei:p[1]/tei:pb/@dlxs:seq">
                    <xsl:sort select="./tei:p[1]/tei:pb/@dlxs:seq"/>

                    <xsl:variable name="seqGroup" select="current-group()"/>

                    <xsl:for-each select="$seqGroup">
                        <xsl:variable name="div" select="."/>

                        <xsl:element name="li" namespace="{$HTML_URL}">
                            <xsl:attribute name="class" select="@type"/>

                            <xsl:element name="span" namespace="{$HTML_URL}">
                                <xsl:call-template name="genEntry">
                                    <xsl:with-param name="div" select="$div"/>
                                </xsl:call-template>
                            </xsl:element>

                            <xsl:variable name="chPgList" select="./tei:p/tei:pb"/>
                            <xsl:if test="count($chPgList) > 0">
                                <xsl:element name="ol" namespace="{$HTML_URL}">
                                    <xsl:for-each-group select="$chPgList" group-by="@dlxs:seq">
                                        <xsl:sort select="@dlxs:seq"/>

                                        <xsl:element name="li" namespace="{$HTML_URL}">
                                            <xsl:element name="a" namespace="{$HTML_URL}">
                                                <xsl:attribute name="href"
                                                               select="concat('xhtml', $FILE_SEPARATOR, @dlxs:seq,'_', $rendition, '.xhtml')"/>
                                                <!--<xsl:value-of select="concat('xhtml', $FILE_SEPARATOR, @dlxs:seq,'_', $rendition, '.xhtml')"/>-->
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:for-each-group>
                                </xsl:element>
                            </xsl:if>

                            <xsl:call-template name="generateCHList">
                                <xsl:with-param name="itemList" select="./tei:div"/>
                                <xsl:with-param name="rendition" select="$rendition"/>
                            </xsl:call-template>

                        </xsl:element>
                    </xsl:for-each>
                </xsl:for-each-group>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template name="genEntry">
        <xsl:param name="div"/>

        <xsl:for-each select="$div/tei:head">
            <xsl:if test="position() > 1">
                <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:apply-templates select="."/>
        </xsl:for-each>
        <xsl:if test="string-length(normalize-space($div/tei:bibl)) > 0">
            <xsl:text> (</xsl:text>
            <xsl:apply-templates select="$div/tei:bibl/tei:author"/>
            <xsl:if test="string-length(normalize-space($div/tei:bibl/tei:biblScope)) > 0">
                <xsl:if test="string-length(normalize-space($div/tei:bibl/tei:author)) > 0">
                    <xsl:text>, </xsl:text>
                </xsl:if>
                <xsl:apply-templates select="$div/tei:bibl/tei:biblScope"/>
            </xsl:if>
            <xsl:text>)</xsl:text>
        </xsl:if>

    </xsl:template>

    <xsl:function name="mlibxsl:getImgNode">
        <xsl:param name="fileName"/>
        <xsl:param name="rendition"/>

        <xsl:choose>
            <xsl:when test="$rendition = 'fixed_scan'">
                <xsl:choose>
                    <xsl:when test="exists($imagesTable/html:tr/html:td[@class='source' and string()=$fileName])">
                        <xsl:sequence select="$imagesTable/html:tr[html:td[@class='source' and string()=$fileName]][1]"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>

        <xsl:sequence select="()"/>
    </xsl:function>

</xsl:stylesheet>