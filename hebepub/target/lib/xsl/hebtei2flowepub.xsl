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

    <xsl:variable name="renditions" select="'flow'"/>
    <xsl:variable name="rendList" select="tokenize($renditions, ' ')"/>

    <xsl:variable name="valueMaps">
        <xsl:element name="valueMaps">
            <xsl:element name="map">
                <xsl:attribute name="type" select="'type2role'"/>

                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'abstract'"/>
                    <xsl:value-of select="'doc-abstract'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'acknowledgments'"/>
                    <xsl:value-of select="'doc-acknowledgments'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'appendix'"/>
                    <xsl:value-of select="'doc-appendix'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'bibliography'"/>
                    <xsl:value-of select="'doc-bibliography'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'chapter'"/>
                    <xsl:value-of select="'doc-chapter'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'conclusion'"/>
                    <xsl:value-of select="'doc-conclusion'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'cover'"/>
                    <xsl:value-of select="'doc-cover'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'epilogue'"/>
                    <xsl:value-of select="'doc-epilogue'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'glossary'"/>
                    <xsl:value-of select="'doc-glossary'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'index'"/>
                    <xsl:value-of select="'doc-index'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'introduction'"/>
                    <xsl:value-of select="'doc-introduction'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'part'"/>
                    <xsl:value-of select="'doc-part'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'preface'"/>
                    <xsl:value-of select="'doc-preface'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'prologue'"/>
                    <xsl:value-of select="'doc-prologue'"/>
                </xsl:element>
            </xsl:element>
            <xsl:element name="map">
                <xsl:attribute name="type" select="'type2epubtype'"/>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'abstract'"/>
                    <xsl:value-of select="'abstract'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'acknowledgments'"/>
                    <xsl:value-of select="'acknowledgments'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'appendix'"/>
                    <xsl:value-of select="'appendix'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'audios'"/>
                    <xsl:value-of select="'loa'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'backmatter'"/>
                    <xsl:value-of select="'backmatter'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'bibliography'"/>
                    <xsl:value-of select="'bibliography'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'bodymatter'"/>
                    <xsl:value-of select="'bodymatter'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'chapter'"/>
                    <xsl:value-of select="'chapter'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'conclusion'"/>
                    <xsl:value-of select="'conclusion'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'copyright'"/>
                    <xsl:value-of select="'copyright-page'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'copyright-page'"/>
                    <xsl:value-of select="'copyright-page'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'cover'"/>
                    <xsl:value-of select="'cover'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'dedication'"/>
                    <xsl:value-of select="'dedication'"/>
                </xsl:element>
                <xsl:element name="division">
                    <xsl:attribute name="key" select="'division'"/>
                    <xsl:value-of select="'division'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'epilogue'"/>
                    <xsl:value-of select="'epilogue'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'figures'"/>
                    <xsl:value-of select="'loi'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'footnote'"/>
                    <xsl:value-of select="'footnote'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'footnotes'"/>
                    <xsl:value-of select="'footnotes'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'frontmatter'"/>
                    <xsl:value-of select="'frontmatter'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'glossary'"/>
                    <xsl:value-of select="'glossary'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'index'"/>
                    <xsl:value-of select="'index'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'introduction'"/>
                    <xsl:value-of select="'introduction'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'pagebreak'"/>
                    <xsl:value-of select="'pagebreak'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'part'"/>
                    <xsl:value-of select="'part'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'preface'"/>
                    <xsl:value-of select="'preface'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'prologue'"/>
                    <xsl:value-of select="'prologue'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'section'"/>
                    <xsl:value-of select="'subchapter'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'subchapter'"/>
                    <xsl:value-of select="'subchapter'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'table'"/>
                    <xsl:value-of select="'table'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'tables'"/>
                    <xsl:value-of select="'lot'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'titlepage'"/>
                    <xsl:value-of select="'titlepage'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'toc'"/>
                    <xsl:value-of select="'toc'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'videos'"/>
                    <xsl:value-of select="'lov'"/>
                </xsl:element>
                <xsl:element name="entry">
                    <xsl:attribute name="key" select="'volume'"/>
                    <xsl:value-of select="'volume'"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:variable>

    <xsl:template match="tei:text">
        <xsl:param name="rendition"/>

        <xsl:variable name="textList" select="*"/>

        <xsl:element name="manifest" namespace="{$IDPF_URL}">

            <!-- Stylesheets -->
            <!--
            <xsl:element name="item" namespace="{$IDPF_URL}">
                <xsl:attribute name="id" select="'css_stylesheet'"/>
                <xsl:attribute name="href" select="$cssBasePath"/>
                <xsl:attribute name="media-type" select="'text/css'"/>
            </xsl:element>
            -->
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
            <!--
           <xsl:if test="not(empty($coverpageSourceList))">
               <xsl:variable name="coverLgNode" select="$coverpageSourceList[ends-with(lower-case(text()),'-lg.jpg')]"/>

               <xsl:element name="item" namespace="{$IDPF_URL}">
                   <xsl:attribute name="id" select="'cover-image'"/>
                   <xsl:attribute name="media-type" select="'image/jpeg'"/>
                   <xsl:attribute name="href">
                       <xsl:choose>
                           <xsl:when test="exists($coverLgNode)">
                               <xsl:value-of select="concat('images',$FILE_SEPARATOR,$coverLgNode)"/>
                           </xsl:when>
                           <xsl:otherwise>
                               <xsl:value-of select="concat('images',$FILE_SEPARATOR,$coverpageSourceList[1])"/>
                           </xsl:otherwise>
                       </xsl:choose>
                   </xsl:attribute>
               </xsl:element>

               <xsl:choose>
                   <xsl:when test="exists($coverLgNode)">
                       <xsl:for-each select="$coverpageSourceList[not(ends-with(lower-case(text()),'-lg.jpg'))]">
                           <xsl:element name="item" namespace="{$IDPF_URL}">
                               <xsl:attribute name="id" select="concat('cover',position(),'-image')"/>
                               <xsl:attribute name="href" select="concat('images',$FILE_SEPARATOR,.)"/>
                               <xsl:attribute name="media-type" select="'image/jpeg'"/>
                           </xsl:element>
                       </xsl:for-each>
                   </xsl:when>
                   <xsl:otherwise>
                       <xsl:for-each select="$coverpageSourceList[position() > 1]">
                           <xsl:element name="item" namespace="{$IDPF_URL}">
                               <xsl:attribute name="id" select="concat('cover',position(),'-image')"/>
                               <xsl:attribute name="href" select="concat('images',$FILE_SEPARATOR,.)"/>
                               <xsl:attribute name="media-type" select="'image/jpeg'"/>
                           </xsl:element>
                       </xsl:for-each>
                   </xsl:otherwise>
               </xsl:choose>
           </xsl:if>
           -->
            <xsl:element name="item" namespace="{$IDPF_URL}">
                <xsl:attribute name="id" select="'cover-image'"/>
                <xsl:attribute name="media-type" select="$coverImageRow/html:td[@class='mime-type']"/>
                <xsl:attribute name="href" select="concat('images',$FILE_SEPARATOR,$coverImageRow/html:td[@class='asset'])"/>
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
            <xsl:element name="item" namespace="{$IDPF_URL}">
                <xsl:attribute name="id" select="'chapterlist'"/>
                <xsl:attribute name="href" select="concat('chapterlist_', $rendition, '.xhtml')"/>
                <xsl:attribute name="media-type" select="'application/xhtml+xml'"/>
            </xsl:element>
            <xsl:if test="count($pgList) > 0">
                <xsl:element name="item" namespace="{$IDPF_URL}">
                    <xsl:attribute name="id" select="'pagelist'"/>
                    <xsl:attribute name="href" select="concat('pagelist_', $rendition, '.xhtml')"/>
                    <xsl:attribute name="media-type" select="'application/xhtml+xml'"/>
                </xsl:element>
            </xsl:if>

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
            <xsl:element name="item" namespace="{$IDPF_URL}">
                <xsl:attribute name="id" select="'cover'"/>
                <xsl:attribute name="href" select="concat('xhtml',$FILE_SEPARATOR,'cover.xhtml')"/>
                <xsl:attribute name="media-type" select="'application/xhtml+xml'"/>
            </xsl:element>
            <xsl:for-each select="$textList">
                <xsl:variable name="textElem" select="."/>
                <xsl:variable name="divList" select="./tei:div"/>

                <xsl:choose>
                    <xsl:when test="not(empty($textElem)) and count($divList) = 0">
                        <xsl:variable name="id" select="local-name($textElem)"/>
                        <xsl:variable name="href" select="concat('xhtml',$FILE_SEPARATOR,local-name($textElem),'.xhtml')"/>
                        <xsl:element name="item" namespace="{$IDPF_URL}">
                            <xsl:attribute name="id" select="$id"/>
                            <xsl:attribute name="href" select="$href"/>
                            <xsl:attribute name="media-type" select="'application/xhtml+xml'"/>

                            <!-- IC assets now includeded in epub
                            <xsl:if test="exists($textElem//tei:figure[@type='ic'])">
                                <xsl:attribute name="properties" select="'remote-resources'"/>
                            </xsl:if>
                            -->
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="$divList">
                            <xsl:variable name="id" select="mlibxsl:generateHtmlId(.)"/>
                            <xsl:variable name="href" select="concat('xhtml',$FILE_SEPARATOR,mlibxsl:generateHtmlPath(.,position()+1),'.xhtml')"/>
                            <xsl:element name="item" namespace="{$IDPF_URL}">
                                <xsl:attribute name="id" select="$id"/>
                                <xsl:attribute name="href" select="$href"/>
                                <xsl:attribute name="media-type" select="'application/xhtml+xml'"/>

                                <!-- IC assets now includeded in epub
                                <xsl:if test="exists(.//tei:figure[@type='ic'])">
                                    <xsl:attribute name="properties" select="'remote-resources'"/>
                                </xsl:if>
                                -->
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:for-each>
        </xsl:element>

        <xsl:element name="spine" namespace="{$IDPF_URL}">
            <xsl:element name="itemref" namespace="{$IDPF_URL}">
                <xsl:attribute name="idref" select="'cover'"/>
            </xsl:element>
            <!-- Uncomment if the toc should be added to book.
                Question would be proper location within spine.
            <xsl:element name="itemref" namespace="{$IDPF_URL}">
                <xsl:attribute name="idref" select="'toc'"/>
            </xsl:element>
             -->
            <xsl:for-each select="$textList">
                <xsl:variable name="textElem" select="."/>
                <xsl:variable name="divList" select="./tei:div"/>

                <xsl:choose>
                    <xsl:when test="not(empty($textElem)) and count($divList) = 0">
                        <xsl:variable name="id" select="local-name($textElem)"/>
                        <xsl:element name="itemref" namespace="{$IDPF_URL}">
                            <xsl:attribute name="idref" select="$id"/>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="$divList">
                            <xsl:variable name="id" select="mlibxsl:generateHtmlId(.)"/>
                            <xsl:element name="itemref" namespace="{$IDPF_URL}">
                                <xsl:attribute name="idref" select="$id"/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:for-each>
        </xsl:element>

        <!-- Cover page document -->
        <xsl:variable name="path" select="concat($epubXHTMLDir,'cover.xhtml')"/>
        <xsl:result-document href="{$path}" method="xml">
            <xsl:element name="html" namespace="{$HTML_URL}">
                <xsl:namespace name="epub" select="$OPS_URL"/>

                <xsl:call-template name="generateHtmlHead">
                    <xsl:with-param name="divType" select="'cover'"/>
                </xsl:call-template>
                <xsl:element name="body" namespace="{$HTML_URL}">
                    <xsl:attribute name="class" select="'svg_cover'"/>

                    <xsl:element name="section" namespace="{$HTML_URL}">
                        <xsl:attribute name="id" select="'cover'"/>
                        <xsl:attribute name="class" select="'text-center'"/>
                        <xsl:attribute name="role" select="'doc-cover'"/>
                        <xsl:attribute name="epub:type" select="'cover'"/>

                        <xsl:element name="img" namespace="{$HTML_URL}">
                            <xsl:attribute name="src" select="concat('..',$FILE_SEPARATOR,'images',$FILE_SEPARATOR,$coverImageRow/html:td[@class='asset'])"/>
                            <xsl:attribute name="class" select="'cover-image'"/>
                            <xsl:attribute name="alt" select="concat('Cover image for book ', $dc-title-list[1])"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:result-document>

        <!-- Division documents -->
        <xsl:for-each select="$textList">
            <xsl:variable name="textElem" select="."/>
            <xsl:variable name="divList" select="./tei:div"/>

            <xsl:choose>
                <xsl:when test="not(empty($textElem)) and count($divList) = 0">
                    <xsl:variable name="path" select="concat($epubXHTMLDir,local-name($textElem),'.xhtml')"/>
                    <xsl:call-template name="generateHtml">
                        <xsl:with-param name="divElem" select="$textElem"/>
                        <xsl:with-param name="path" select="$path"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="$divList">
                        <xsl:variable name="divElem" select="."/>

                        <xsl:variable name="path" select="concat($epubXHTMLDir,mlibxsl:generateHtmlPath($divElem,position()+1),'.xhtml')"/>
                        <xsl:call-template name="generateHtml">
                            <xsl:with-param name="divElem" select="$divElem"/>
                            <xsl:with-param name="path" select="$path"/>
                        </xsl:call-template>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>

    </xsl:template>

    <xsl:template match="tei:front|tei:body|tei:back|tei:dedicat|tei:preface
        |tei:titlePage|tei:listBibl">

        <xsl:element name="section" namespace="{$HTML_URL}">
            <xsl:if test="exists(@xml:id)">
                <xsl:attribute name="id" select="@xml:id"/>
            </xsl:if>
            <xsl:attribute name="epub:type" namespace="{$OPS_URL}">
                <xsl:choose>
                    <xsl:when test="local-name() = 'front'">
                        <xsl:value-of select="'frontmatter'"/>
                    </xsl:when>
                    <xsl:when test="local-name() = 'body'">
                        <xsl:value-of select="'bodymatter'"/>
                    </xsl:when>
                    <xsl:when test="local-name() = 'back'">
                        <xsl:value-of select="'backmatter'"/>
                    </xsl:when>
                    <xsl:when test="local-name() = 'dedicat'">
                        <xsl:value-of select="'dedication'"/>
                    </xsl:when>
                    <xsl:when test="local-name() = 'listBibl'">
                        <xsl:value-of select="'bibliography'"/>
                    </xsl:when>
                    <xsl:when test="local-name() = 'titlePage'">
                        <xsl:value-of select="'titlepage'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="local-name()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:div">
        <!--
        <xsl:element name="section" namespace="{$HTML_URL}">
            <xsl:attribute name="id" select="mlibxsl:generateHtmlId(.)"/>

            <xsl:if test="exists(@type)">
                <xsl:variable name="epubType" select="mlibxsl:mapDivType2Value('type2epubtype',@type)"/>
                <xsl:if test="string-length($epubType) > 0">
                    <xsl:attribute name="epub:type" select="$epubType"/>
                </xsl:if>

                <xsl:variable name="role" select="mlibxsl:mapDivType2Value('type2role',@type)"/>
                <xsl:if test="string-length($role) > 0">
                    <xsl:attribute name="role" select="$role"/>
                </xsl:if>
            </xsl:if>

            <xsl:apply-templates/>
        </xsl:element>
        -->
        <xsl:element name="section" namespace="{$HTML_URL}">
            <xsl:attribute name="id" select="mlibxsl:generateHtmlId(.)"/>

            <xsl:if test="exists(@type)">
                <xsl:variable name="epubType" select="mlibxsl:mapDivType2Value('type2epubtype',@type)"/>
                <xsl:if test="string-length($epubType) > 0">
                    <xsl:attribute name="epub:type" select="$epubType"/>
                </xsl:if>

                <xsl:variable name="role" select="mlibxsl:mapDivType2Value('type2role',@type)"/>
                <xsl:if test="string-length($role) > 0">
                    <xsl:attribute name="role" select="$role"/>
                </xsl:if>
            </xsl:if>

            <!--
            <xsl:if test="exists(@dlxs:status)">
                <xsl:attribute name="class" select="@dlxs:status"/>
            </xsl:if>
            -->
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:titlePart">

        <xsl:variable name="hname">
            <xsl:choose>
                <xsl:when test="@type='main'">
                    <xsl:value-of select="'h1'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'h2'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:element name="{$hname}" namespace="{$HTML_URL}">
            <xsl:attribute name="class" select="concat(local-name(),' text-center')"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:div/tei:head">
        <xsl:choose>
            <!-- Condition needed to remove "[Epigraph]" heading from
                within heb99016.0001.001 epub. Heading is left in TOC.
            <xsl:when test="@dlxs:status = 'nodisplay'"></xsl:when>
            -->
            <xsl:when test="count(./tei:bibl[@type!='para']) >= 1">
                <xsl:element name="header" namespace="{$HTML_URL}">
                    <xsl:attribute name="class" select="'text-center'"/>
                    <xsl:if test="exists(@xml:id)">
                        <xsl:attribute name="id" select="@xml:id"/>
                    </xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:head" mode="toc">
        <xsl:value-of select="./*[local-name() !='bibl' or @type != 'para']"/>
    </xsl:template>

    <xsl:template match="tei:list/tei:head">

        <xsl:element name="h1" namespace="{$HTML_URL}">
            <xsl:attribute name="class" select="'listhead'"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:list[not(exists(@type)) or @type='nomarker' or @type='bulleted']">
        <xsl:choose>
            <xsl:when test="exists(./tei:head)">
                <xsl:element name="section" namespace="{$HTML_URL}">
                    <xsl:apply-templates select="./tei:head"/>
                    <xsl:call-template name="insertUnorderedList">
                        <xsl:with-param name="listNode" select="."/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="insertUnorderedList">
                    <xsl:with-param name="listNode" select="."/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:list">
        <xsl:choose>
            <xsl:when test="exists(./tei:head)">
                <xsl:element name="section" namespace="{$HTML_URL}">
                    <xsl:apply-templates select="./tei:head"/>
                    <xsl:call-template name="insertOrderedList">
                        <xsl:with-param name="listNode" select="."/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="insertOrderedList">
                    <xsl:with-param name="listNode" select="."/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:item">

        <xsl:element name="li" namespace="{$HTML_URL}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:table">

        <xsl:element name="table" namespace="{$HTML_URL}">
            <xsl:if test="exists(@xml:id)">
                <xsl:attribute name="id" select="@xml:id"/>
            </xsl:if>
            <xsl:if test="exists(@border)">
                <xsl:attribute name="border" select="@border"/>
            </xsl:if>

            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:table/tei:head">

        <xsl:element name="caption" namespace="{$HTML_URL}">
            <xsl:attribute name="class" select="local-name()"/>

            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:row">

        <xsl:element name="tr" namespace="{$HTML_URL}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:cell">

        <xsl:element name="td" namespace="{$HTML_URL}">
            <xsl:variable name="classValueCnt">
                <xsl:choose>
                    <xsl:when test="exists(@colspan)">
                        <xsl:value-of select="count(@*)-1"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="count(@*)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="exists(@colspan)">
                <xsl:attribute name="colspan" select="@colspan"/>
            </xsl:if>
            <xsl:if test="$classValueCnt > 0">
                <xsl:attribute name="class">
                    <xsl:for-each select="@*">
                        <xsl:if test="name(.) != 'colspan'">
                            <xsl:value-of select="."/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:app">

        <xsl:element name="div" namespace="{$HTML_URL}">
            <xsl:attribute name="class" select="'app'"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:castGroup | tei:castList">

        <xsl:element name="ul" namespace="{$HTML_URL}">
            <xsl:attribute name="class" select="local-name()"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:castItem">

        <xsl:element name="li" namespace="{$HTML_URL}">
            <xsl:attribute name="class" select="local-name()"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:l">

        <xsl:element name="p" namespace="{$HTML_URL}">
            <xsl:attribute name="class">
                <xsl:value-of select="'verseline'"/>
                <xsl:if test="@rend = 'indent'">
                    <xsl:value-of select="' indent'"/>
                </xsl:if>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:lg">

        <xsl:element name="div" namespace="{$HTML_URL}">
            <xsl:attribute name="class" select="'linegroup'"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:lg/tei:head">

        <xsl:element name="p" namespace="{$HTML_URL}">
            <xsl:attribute name="class" select="'linegrouphead'"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:caesura">

        <xsl:element name="br" namespace="{$HTML_URL}">
            <xsl:attribute name="class" select="local-name()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:lb">

        <xsl:element name="br" namespace="{$HTML_URL}"/>
    </xsl:template>

    <xsl:template match="tei:note/tei:pCURRENT[1]">
        <xsl:element name="p" namespace="{$HTML_URL}">
            <xsl:value-of select="concat(../@n,'. ')"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:note/tei:p[1]">
        <xsl:variable name="childList" select="./*[local-name()='figure' or local-name()='list' or local-name()='table' or local-name()='q' or local-name()='epigraph']"/>
        <xsl:choose>
            <xsl:when test="count($childList) > 0">
                <xsl:element name="div" namespace="{$HTML_URL}">
                    <xsl:if test="exists(@xml:id)">
                        <xsl:attribute name="id" select="@xml:id"/>
                    </xsl:if>
                    <xsl:if test="exists(../@n)">
                        <xsl:value-of select="concat(../@n,'. ')"/>
                    </xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="p" namespace="{$HTML_URL}">
                    <xsl:if test="exists(@xml:id)">
                        <xsl:attribute name="id" select="@xml:id"/>
                    </xsl:if>
                    <xsl:if test="exists(../@n)">
                        <xsl:value-of select="concat(../@n,'. ')"/>
                    </xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:noteCURRENT">
        <xsl:choose>
            <xsl:when test="exists(tei:p)">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="p" namespace="{$HTML_URL}">
                    <xsl:if test="exists(@xml:id)">
                        <xsl:attribute name="id" select="@xml:id"/>
                    </xsl:if>
                    <xsl:attribute name="class" select="local-name()"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:note">
        <xsl:element name="div" namespace="{$HTML_URL}">
            <xsl:if test="exists(@xml:id)">
                <xsl:attribute name="id" select="@xml:id"/>
            </xsl:if>
            <xsl:attribute name="class" select="local-name()"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:caption|tei:docAuthor|tei:docImprint
        |tei:epilogue|tei:original|tei:prologue|tei:dateline
        |tei:set|tei:wit|tei:postscript|tei:salute|tei:signed
        |tei:biblFull|tei:classDecl|tei:catRef|tei:langUsage
        |tei:keywords|tei:title|tei:trailer">

        <xsl:element name="p" namespace="{$HTML_URL}">
            <xsl:if test="exists(@xml:id)">
                <xsl:attribute name="id" select="@xml:id"/>
            </xsl:if>
            <xsl:attribute name="class">
                <xsl:value-of select="local-name()"/>
                <xsl:choose>
                    <xsl:when test="exists(@dlxs:align)">
                        <xsl:value-of select="concat(' ',@dlxs:align)"/>
                    </xsl:when>
                    <xsl:when test="exists(align)">
                        <xsl:value-of select="concat(' ',align)"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>

            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:publisher|tei:pubPlace">

        <xsl:variable name="elemName">
            <xsl:choose>
                <xsl:when test="local-name(..) = 'docImprint'">
                    <xsl:value-of select="'span'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'p'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{$elemName}" namespace="{$HTML_URL}">
            <xsl:if test="exists(@xml:id)">
                <xsl:attribute name="id" select="@xml:id"/>
            </xsl:if>
            <xsl:attribute name="class" select="local-name()"/>
            <xsl:if test="count(./preceding-sibling::*) > 0">
                <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:bibl">
        <xsl:choose>
            <xsl:when test="@type='para'"></xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="insertHeading">
                    <xsl:with-param name="headNode" select="."/>
                    <xsl:with-param name="level" select="0"/>
                </xsl:call-template>

                <!--
                <xsl:element name="p" namespace="{$HTML_URL}">
                    <xsl:if test="exists(@xml:id)">
                        <xsl:attribute name="id" select="@xml:id"/>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="exists(@type)">
                            <xsl:attribute name="class" select="@type"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="class" select="local-name()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:apply-templates/>
                </xsl:element>
                -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:div/tei:head/tei:bibl">
        <xsl:if test="@type!='para'">
            <xsl:if test="count(./preceding-sibling::*[local-name()='bibl' and @type!='para']) > 0">
                <xsl:text> </xsl:text>
            </xsl:if>

            <xsl:call-template name="insertHeading">
                <xsl:with-param name="headNode" select="."/>
                <xsl:with-param name="level">
                    <xsl:choose>
                        <xsl:when test="exists(ancestor::tei:div[1]/@dlxs:level)">
                            <xsl:value-of select="ancestor::tei:div[1]/@dlxs:level"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:call-template>

        </xsl:if>
    </xsl:template>

    <xsl:template match="tei:list/tei:head/tei:bibl">
        <xsl:if test="@type!='para'">
            <xsl:if test="count(./preceding-sibling::*[local-name()='bibl' and @type!='para']) > 0">
                <xsl:text> </xsl:text>
            </xsl:if>

            <xsl:apply-templates/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tei:descrip">

        <xsl:element name="p" namespace="{$HTML_URL}">
            <xsl:attribute name="class" select="'descript'"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:biblScope">

        <xsl:element name="p" namespace="{$HTML_URL}">
            <xsl:attribute name="class" select="local-name()"/>
            <xsl:if test="exists(@unit)">
                <xsl:attribute name="title" select="@unit"/>
            </xsl:if>

            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:pKeep">

        <xsl:element name="p" namespace="{$HTML_URL}">
            <xsl:if test="exists(@xml:id)">
                <xsl:attribute name="id" select="@xml:id"/>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:pCURRENT">
        <xsl:variable name="node" select="."/>
        <xsl:variable name="childList" select="$node/text()|*"/>
        <xsl:variable name="blockList" select="$childList[local-name()='figure' or local-name()='list' or local-name()='table' or local-name()='q' or local-name()='epigraph']"/>
        <xsl:choose>
            <xsl:when test="count($blockList) > 0">
                <xsl:for-each select="$blockList">
                    <xsl:choose>
                        <xsl:when test="position()=1">
                            <xsl:variable name="blockNdxList" select="index-of($childList,.)"/>
                            <xsl:variable name="seqPrevNdx" select="1"/>
                            <xsl:variable name="seqEndNdx" select="subsequence($blockNdxList,1,1)"/>
                            <xsl:if test="$seqEndNdx > $seqPrevNdx">
                                <xsl:element name="p" namespace="{$HTML_URL}">
                                    <xsl:choose>
                                        <xsl:when test="local-name($node/..)='note'">
                                            <xsl:if test="exists($node/../@xml:id)">
                                                <xsl:attribute name="id" select="$node/../@xml:id"/>
                                            </xsl:if>
                                            <xsl:if test="exists($node/../@n)">
                                                <xsl:value-of select="concat($node/../@n,'. ')"/>
                                            </xsl:if>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:if test="exists($node/@xml:id)">
                                                <xsl:attribute name="id" select="$node/@xml:id"/>
                                            </xsl:if>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:apply-templates select="subsequence($childList,$seqPrevNdx, $seqEndNdx - $seqPrevNdx)"/>
                                </xsl:element>
                            </xsl:if>
                            <xsl:apply-templates select="subsequence($childList,$seqEndNdx,1)"/>
                            <xsl:if test="position() = last() and count($childList) > $seqEndNdx">
                                <xsl:element name="p" namespace="{$HTML_URL}">
                                    <xsl:apply-templates select="subsequence($childList,$seqEndNdx + 1)"/>
                                </xsl:element>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="prevBlockList" select="index-of($childList,subsequence($blockList,position()-1,1))"/>
                            <xsl:variable name="pNdx" select="subsequence($prevBlockList,1,1)"/>
                            <xsl:variable name="cList" select="subsequence($childList,$pNdx + 1)"/>
                            <xsl:variable name="blockNdxList" select="index-of($cList,.)"/>
                            <xsl:variable name="seqPrevNdx" select="1"/>
                            <xsl:variable name="seqEndNdx" select="subsequence($blockNdxList,1,1)"/>
                            <xsl:if test="$seqEndNdx > $seqPrevNdx">
                                <xsl:element name="p" namespace="{$HTML_URL}">
                                    <xsl:apply-templates select="subsequence($cList,$seqPrevNdx, $seqEndNdx - $seqPrevNdx)"/>
                                </xsl:element>
                            </xsl:if>
                            <xsl:apply-templates select="subsequence($cList,$seqEndNdx,1)"/>
                            <xsl:if test="position() = last() and count($cList) > $seqEndNdx">
                                <xsl:element name="p" namespace="{$HTML_URL}">
                                    <xsl:apply-templates select="subsequence($cList,$seqEndNdx + 1)"/>
                                </xsl:element>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="p" namespace="{$HTML_URL}">
                    <xsl:choose>
                        <xsl:when test="local-name($node/..)='note'">
                            <xsl:if test="exists($node/../@xml:id)">
                                <xsl:attribute name="id" select="$node/../@xml:id"/>
                            </xsl:if>
                            <xsl:if test="exists($node/../@n)">
                                <xsl:value-of select="concat($node/../@n,'. ')"/>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="exists($node/@xml:id)">
                                <xsl:attribute name="id" select="$node/@xml:id"/>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:p">
        <xsl:variable name="childList" select="./*[local-name()='figure' or local-name()='list' or local-name()='table' or local-name()='q' or local-name()='epigraph']"/>
        <xsl:choose>
            <xsl:when test="count($childList) > 0">
                <xsl:element name="div" namespace="{$HTML_URL}">
                    <xsl:if test="exists(@xml:id)">
                        <xsl:attribute name="id" select="@xml:id"/>
                    </xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="p" namespace="{$HTML_URL}">
                    <xsl:if test="exists(@xml:id)">
                        <xsl:attribute name="id" select="@xml:id"/>
                    </xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:fw|tei:rs">

        <xsl:element name="p" namespace="{$HTML_URL}">
            <xsl:attribute name="class" select="local-name()"/>
            <xsl:if test="exists(@type)">
                <xsl:attribute name="title" select="@type"/>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:gloss">

        <xsl:element name="dd" namespace="{$HTML_URL}">
            <xsl:attribute name="class" select="local-name()"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:term">

        <xsl:element name="dt" namespace="{$HTML_URL}">
            <xsl:attribute name="class" select="local-name()"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:emph">

        <xsl:element name="i" namespace="{$HTML_URL}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:hi[@rend='b' or @rend='bold']">
        <xsl:param name="rendition"/>

        <xsl:element name="b" namespace="{$HTML_URL}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:hi[@rend='i' or @rend='italic']">

        <xsl:element name="i" namespace="{$HTML_URL}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:hi[@rend='strike']">

        <xsl:element name="del" namespace="{$HTML_URL}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:hi[@rend='sup']">

        <xsl:element name="sup" namespace="{$HTML_URL}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:hi[@rend='supbold']">

        <xsl:element name="sup" namespace="{$HTML_URL}">
            <xsl:element name="b" namespace="{$HTML_URL}">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:hi[@rend='supund']">

        <xsl:element name="sup" namespace="{$HTML_URL}">
            <xsl:element name="u" namespace="{$HTML_URL}">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:hi[@rend='sub']">

        <xsl:element name="sub" namespace="{$HTML_URL}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:hi[@rend='und']">

        <xsl:element name="u" namespace="{$HTML_URL}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:hi[@rend='bolditalic']">

        <xsl:element name="b" namespace="{$HTML_URL}">
            <xsl:element name="i" namespace="{$HTML_URL}">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:hi[@rend='italicsunderlined']">

        <xsl:element name="u" namespace="{$HTML_URL}">
            <xsl:element name="i" namespace="{$HTML_URL}">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:hi[@rend='boldund']">

        <xsl:element name="b" namespace="{$HTML_URL}">
            <xsl:element name="u" namespace="{$HTML_URL}">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:hi[@rend='greek' or @rend='greek-und' or @rend='arabic']">

        <xsl:element name="span" namespace="{$HTML_URL}">
            <xsl:attribute name="class" select="@rend"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:performance|tei:sp|tei:argument|tei:group|tei:refsdecl
        |tei:opener|tei:closer|tei:cit|tei:taxonomy">

        <xsl:element name="div" namespace="{$HTML_URL}">
            <xsl:if test="exists(@xml:id)">
                <xsl:attribute name="id" select="@xml:id"/>
            </xsl:if>
            <xsl:attribute name="class" select="local-name()"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:notesStmt">

        <xsl:element name="div" namespace="{$HTML_URL}">
            <xsl:attribute name="epub:type" namespace="{$OPS_URL}" select="'footnote'"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:foreign">

        <xsl:element name="span" namespace="{$HTML_URL}">
            <xsl:attribute name="class" select="local-name()"/>
            <xsl:if test="exists(@xml:lang)">
                <xsl:attribute name="xml:lang" select="@xml:lang"/>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:gap">

        <xsl:element name="span" namespace="{$HTML_URL}">
            <xsl:attribute name="class" select="local-name()"/>
            <xsl:if test="exists(@reason) or exists(@extent)">
                <xsl:attribute name="title">
                    <xsl:choose>
                        <xsl:when test="exists(@reason) and exists(@extent)">
                            <xsl:value-of select="concat(@reason,' ',@extent)"/>
                        </xsl:when>
                        <xsl:when test="exists(@reason)">
                            <xsl:value-of select="@reason"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="@extent"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:ptr">

        <xsl:element name="a" namespace="{$HTML_URL}">
            <xsl:if test="exists(@target)">

                <xsl:variable name="target" select="mlibxsl:mapTarget(@target)"/>
                <!--
                <xsl:message>@target=<xsl:value-of select="@target"/>,target=<xsl:value-of select="$target"/></xsl:message>
                -->
                <xsl:variable name="anchorNode" select="//*[@xml:id=$target][1]"/>
                <xsl:choose>
                    <xsl:when test="exists($anchorNode)">
                        <xsl:variable name="href" select="mlibxsl:genReference($anchorNode)"/>
                        <xsl:attribute name="href" select="$href"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message><xsl:value-of select="local-name()"/>: ID <xsl:value-of select="$target"/> does not exist.</xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="not(exists(@type))">
                    <xsl:attribute name="class" select="'footnote'"/>
                </xsl:when>
            </xsl:choose>

            <xsl:value-of select="@n"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!--
    <xsl:template match="tei:refCURRENT">

        <xsl:element name="a" namespace="{$HTML_URL}">
            <xsl:choose>
                <xsl:when test="exists(@type)">
                    <xsl:attribute name="class" select="@type"/>
                    <xsl:choose>
                        <xsl:when test="@type='url' and exists(@dlxs:url)">
                            <xsl:attribute name="href" select="@dlxs:url"/>
                        </xsl:when>
                        <xsl:when test="exists(@source) and (@type='pdf' or @type='video' or @type='audio')">
                            <xsl:variable name="asset" select="mlibxsl:genLinkReference(@source)"/>
                            <xsl:variable name="href">
                                <xsl:choose>
                                    <xsl:when test="exists($asset)">
                                        <xsl:value-of select="$asset/html:td[@class='link']"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="concat('https://quod.lib.umich.edu/a/acls/images/',@source)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:attribute name="href" select="$href"/>
                        </xsl:when>
                        <xsl:when test="exists(@target)">
                            <xsl:variable name="target" select="mlibxsl:mapTarget(@target)"/>
                            <xsl:variable name="anchorNode" select="//*[@xml:id=$target][1]"/>
                            <xsl:attribute name="href" select="mlibxsl:genReference($anchorNode)"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="exists(@target)">
                    <xsl:variable name="target" select="mlibxsl:mapTarget(@target)"/>
                    <xsl:variable name="anchorNode" select="//*[@xml:id=$target][1]"/>
                    <xsl:attribute name="href" select="mlibxsl:genReference($anchorNode)"/>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>
    -->

    <xsl:template match="tei:ref">

        <xsl:variable name="asset" select="mlibxsl:genAssetReference(@source)"/>
        <xsl:variable name="embedMarkup">
            <xsl:choose>
                <!-- No viewer for PDF currently. Continue to link to asset page. -->
                <xsl:when test="@type != 'pdf' and exists($asset)">
                    <xsl:value-of select="$asset/html:td[@class='embed-markup']" disable-output-escaping="yes"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="''"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$embedMarkup != ''">
                <xsl:element name="div" namespace="{$HTML_URL}">
                    <xsl:if test="exists(@xml:id)">
                        <xsl:attribute name="id" select="@xml:id"/>
                    </xsl:if>
                    <xsl:value-of select="$embedMarkup" disable-output-escaping="yes"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="a" namespace="{$HTML_URL}">
                    <xsl:choose>
                        <xsl:when test="exists(@type)">
                            <xsl:attribute name="class" select="@type"/>
                            <xsl:choose>
                                <xsl:when test="@type='url' and exists(@dlxs:url)">
                                    <xsl:attribute name="href" select="@dlxs:url"/>
                                </xsl:when>
                                <xsl:when test="exists(@source) and (@type='pdf' or @type='video' or @type='audio')">
                                    <xsl:variable name="href">
                                        <xsl:choose>
                                            <xsl:when test="exists($asset)">
                                                <xsl:value-of select="$asset/html:td[@class='link']"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat('https://quod.lib.umich.edu/a/acls/images/',@source)"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:attribute name="href" select="$href"/>
                                </xsl:when>
                                <xsl:when test="exists(@target)">
                                    <xsl:variable name="target" select="mlibxsl:mapTarget(@target)"/>
                                    <xsl:variable name="anchorNode" select="//*[@xml:id=$target][1]"/>
                                    <xsl:attribute name="href" select="mlibxsl:genReference($anchorNode)"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:when test="exists(@target)">
                            <xsl:variable name="target" select="mlibxsl:mapTarget(@target)"/>
                            <xsl:variable name="anchorNode" select="//*[@xml:id=$target][1]"/>
                            <xsl:attribute name="href" select="mlibxsl:genReference($anchorNode)"/>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:apply-templates select="node()"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:rdg|tei:speaker|tei:stage|tei:s|tei:seg|tei:abbr
        |tei:expan|tei:add|tei:change|tei:corr|tei:del|tei:sic|tei:supplied
        |tei:unclear|tei:alias|tei:classCode|tei:label|tei:milestone
        |tei:name|tei:num|tei:soCalled|tei:time">

        <xsl:element name="span" namespace="{$HTML_URL}">
            <xsl:if test="exists(@xml:id)">
                <xsl:attribute name="id" select="@xml:id"/>
            </xsl:if>
            <xsl:attribute name="class" select="local-name()"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:pb">
        <xsl:element name="span" namespace="{$HTML_URL}">
            <xsl:attribute name="id">
                <xsl:choose>
                    <xsl:when test="exists(@xml:id)">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:when>
                    <xsl:when test="exists(@n)">
                        <xsl:value-of select="concat('pb_',@n)"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="class" select="'page'"/>
            <xsl:attribute name="role" select="'doc-pagebreak'"/>
            <xsl:attribute name="epub:type" namespace="{$OPS_URL}" select="'pagebreak'"/>

            <xsl:if test="exists(@n)">
                <xsl:attribute name="aria-label" select="@n"/>
                <xsl:value-of select="concat('Page ',@n,' &#8594; ')"/>
            </xsl:if>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:anchor">

        <xsl:element name="span" namespace="{$HTML_URL}">
            <xsl:if test="exists(@xml:id)">
                <xsl:attribute name="id" select="@xml:id"/>
            </xsl:if>
            <xsl:attribute name="class" select="local-name()"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:runhead">

        <xsl:element name="p" namespace="{$HTML_URL}">
            <xsl:attribute name="class" select="local-name()"/>
            <xsl:if test="exists(@type)">
                <xsl:attribute name="title" select="@type"/>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:epigraph">

        <xsl:element name="blockquote" namespace="{$HTML_URL}">
            <xsl:if test="exists(@xml:id)">
                <xsl:attribute name="id" select="@xml:id"/>
            </xsl:if>
            <xsl:attribute name="class" select="local-name()"/>

            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:epigraph/tei:q">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:q">

        <xsl:element name="blockquote" namespace="{$HTML_URL}">
            <xsl:if test="exists(@xml:id)">
                <xsl:attribute name="id" select="@xml:id"/>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@type='epiq'">
                    <xsl:attribute name="class" select="'epigraph'"/>
                </xsl:when>
                <xsl:when test="exists(@type) and @type !='block'">
                    <xsl:attribute name="class" select="@type"/>
                </xsl:when>
            </xsl:choose>

            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <!--
    <xsl:template match="tei:figureCURRENT">

        <xsl:variable name="figure" select="."/>

        <xsl:choose>
            <xsl:when test="@type='ic2'">
                <xsl:element name="iframe" namespace="{$HTML_URL}">
                    <xsl:attribute name="src" select="tei:graphic/@url"/>
                    <xsl:attribute name="style"
                                   select="'overflow:hidden; border-width:0; left:0; top:0; width:100%; height:100%; position:absolute;'"/>
                    <xsl:if test="exists(@xml:id)">
                        <xsl:attribute name="id" select="@xml:id"/>
                    </xsl:if>
                    <xsl:attribute name="class">
                        <xsl:value-of select="'figure'"/>
                        <xsl:if test="exists(@type)">
                            <xsl:value-of select="concat(' ',@type)"/>
                        </xsl:if>
                    </xsl:attribute>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="figure" namespace="{$HTML_URL}">
                    <xsl:if test="exists(@xml:id)">
                        <xsl:attribute name="id" select="@xml:id"/>
                    </xsl:if>
                    <xsl:attribute name="class">
                        <xsl:value-of select="'figure'"/>
                        <xsl:if test="exists(@type)">
                            <xsl:value-of select="concat(' ',@type)"/>
                        </xsl:if>
                    </xsl:attribute>

                    <xsl:element name="img" namespace="{$HTML_URL}">
                        <xsl:attribute name="class" select="'figure-image'"/>
                        <xsl:choose>
                            <xsl:when test="$figure/@type='ic2'">
                                <xsl:attribute name="src" select="$figure/@url"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="src" select="concat('..',$FILE_SEPARATOR,'images',$FILE_SEPARATOR,$figure/@dlxs:entity,'.jpg')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="exists($figure/tei:figDesc)">
                                <xsl:attribute name="alt" select="$figure/tei:figDesc"/>
                            </xsl:when>
                            <xsl:when test="exists($figure/tei:head)">
                                <xsl:attribute name="alt" select="$figure/tei:head"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="alt" select="$figure/@dlxs:entity"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>

                    <xsl:apply-templates/>

                    <xsl:variable name="lgRefPath" select="concat($figure/@dlxs:entity,'-lg')"/>
                    <xsl:variable name="refPath" select="$figure/@dlxs:entity"/>

                    <xsl:variable name="lgLink" select="mlibxsl:genLinkReference($lgRefPath)"/>
                    <xsl:variable name="link" as="element()*">
                        <xsl:choose>
                            <xsl:when test="exists($lgLink)">
                                <xsl:sequence select="$lgLink"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="mlibxsl:genLinkReference($refPath)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="lgAsset" select="mlibxsl:genAssetReference($lgRefPath)"/>
                    <xsl:variable name="asset" as="element()*">
                        <xsl:choose>
                            <xsl:when test="exists($lgAsset)">
                                <xsl:sequence select="$lgAsset"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:sequence select="mlibxsl:genAssetReference($refPath)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="href">
                        <xsl:choose>
                            <xsl:when test="exists($link) and normalize-space($link/html:td[@class='link']) != ''">
                                <xsl:value-of select="normalize-space($link/html:td[@class='link'])"/>
                            </xsl:when>
                            <xsl:when test="exists($asset)">
                                <xsl:value-of select="concat('https://quod.lib.umich.edu/a/acls/images/',$asset/html:td[@class='asset'])"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="''"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:if test="$href != ''">
                        <xsl:element name="span" namespace="{$HTML_URL}">
                            <xsl:attribute name="class" select="'figcaption'"/>
                            <xsl:element name="a" namespace="{$HTML_URL}">
                                <xsl:attribute name="href" select="$href"/>
                                <xsl:attribute name="target" select="'_blank'"/>
                                <xsl:value-of select="'View Asset'"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    -->

    <xsl:template match="tei:figure">

        <xsl:variable name="figure" select="."/>

        <xsl:variable name="lgRefPath" select="concat($figure/@dlxs:entity,'-lg')"/>
        <xsl:variable name="refPath" select="$figure/@dlxs:entity"/>

        <xsl:variable name="lgAsset" select="mlibxsl:genAssetReference($lgRefPath)"/>
        <xsl:variable name="asset" as="element()*">
            <xsl:choose>
                <xsl:when test="exists($lgAsset)">
                    <xsl:sequence select="$lgAsset"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="mlibxsl:genAssetReference($refPath)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="embedMarkup">
            <xsl:choose>
                <xsl:when test="exists($asset)">
                    <xsl:value-of select="$asset/html:td[@class='embed-markup']" disable-output-escaping="yes"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="''"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$embedMarkup != ''">
                <xsl:variable name="title" select="$asset/html:td[@class='title']"/>
                <xsl:element name="div" namespace="{$HTML_URL}">
                    <xsl:if test="exists(@xml:id)">
                        <xsl:attribute name="id" select="@xml:id"/>
                    </xsl:if>
                    <xsl:value-of select="$embedMarkup" disable-output-escaping="yes"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="href">
                    <xsl:choose>
                        <xsl:when test="exists($asset) and normalize-space($asset/html:td[@class='link']) != ''">
                            <xsl:value-of select="normalize-space($asset/html:td[@class='link'])"/>
                        </xsl:when>
                        <xsl:when test="exists($asset)">
                            <xsl:value-of select="concat('https://quod.lib.umich.edu/a/acls/images/',$asset/html:td[@class='asset'])"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="''"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:element name="figure" namespace="{$HTML_URL}">
                    <xsl:if test="exists(@xml:id)">
                        <xsl:attribute name="id" select="@xml:id"/>
                    </xsl:if>
                    <xsl:attribute name="class">
                        <xsl:value-of select="'figure'"/>
                        <xsl:if test="exists(@type)">
                            <xsl:value-of select="concat(' ',@type)"/>
                        </xsl:if>
                    </xsl:attribute>

                    <xsl:element name="img" namespace="{$HTML_URL}">
                        <xsl:attribute name="class" select="'figure-image'"/>
                        <xsl:choose>
                            <xsl:when test="$figure/@type='ic2'">
                                <xsl:attribute name="src" select="$figure/@url"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!--
                                <xsl:attribute name="src" select="concat('..',$FILE_SEPARATOR,@url)"/>
                                -->
                                <xsl:attribute name="src" select="concat('..',$FILE_SEPARATOR,'images',$FILE_SEPARATOR,$figure/@dlxs:entity,'.jpg')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="exists($figure/tei:figDesc)">
                                <xsl:attribute name="alt" select="$figure/tei:figDesc"/>
                            </xsl:when>
                            <xsl:when test="exists($figure/tei:head)">
                                <xsl:attribute name="alt" select="$figure/tei:head"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="alt" select="$figure/@dlxs:entity"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>

                    <xsl:apply-templates/>

                    <xsl:if test="$href != ''">
                        <xsl:element name="span" namespace="{$HTML_URL}">
                            <xsl:attribute name="class" select="'figcaption'"/>
                            <xsl:element name="a" namespace="{$HTML_URL}">
                                <xsl:attribute name="href" select="$href"/>
                                <xsl:attribute name="target" select="'_blank'"/>
                                <xsl:value-of select="'View Asset'"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:figure/tei:head">
        <xsl:element name="span" namespace="{$HTML_URL}">
            <xsl:attribute name="class" select="'figcaption'"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:figure/tei:graphicOLD">
        <xsl:element name="img" namespace="{$HTML_URL}">
            <xsl:choose>
                <xsl:when test="../@type='ic'">
                    <xsl:attribute name="src" select="@url"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="src" select="concat('..',$FILE_SEPARATOR,@url)"/>
                    <!--
                     <xsl:attribute name="src" select="concat('..',$FILE_SEPARATOR,'images',$FILE_SEPARATOR,../@dlxs:entity,'-lg.jpg')"/>
                    -->
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="exists(../tei:figDesc)">
                    <xsl:attribute name="alt" select="../tei:figDesc"/>
                </xsl:when>
                <xsl:when test="exists(../tei:head)">
                    <xsl:attribute name="alt" select="../tei:head"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="alt" select="../@entity"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template match="html:tr">
        <xsl:element name="item" namespace="{$IDPF_URL}">
            <xsl:attribute name="id" select="concat('image',html:td[@class='source'])"/>
            <xsl:attribute name="href" select="concat('images',$FILE_SEPARATOR,html:td[@class='dest'])"/>
            <xsl:attribute name="media-type" select="'image/jpeg'"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:titlePage/tei:docTitle">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='245']">
        <xsl:call-template name="generateDCMetadata">
            <xsl:with-param name="metadataName" select="'dc:title'"/>
            <xsl:with-param name="metadataValue" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author[@dlxs:type='alt']">
        <xsl:call-template name="generateDCMetadata">
            <xsl:with-param name="metadataName" select="'dc:contributor'"/>
            <xsl:with-param name="metadataValue" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author[not(exists(@dlxs:type))]">
        <xsl:call-template name="generateDCMetadata">
            <xsl:with-param name="metadataName" select="'dc:creator'"/>
            <xsl:with-param name="metadataValue" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblFull/tei:notesStmt/tei:note[@type='url']">
        <xsl:call-template name="generateDCMetadata">
            <xsl:with-param name="metadataName" select="'dc:source'"/>
            <xsl:with-param name="metadataValue" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblFull/tei:publicationStmt/tei:publisher">
        <xsl:call-template name="generateDCMetadata">
            <xsl:with-param name="metadataName" select="'dc:publisher'"/>
            <xsl:with-param name="metadataValue" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/tei:p">
        <xsl:call-template name="generateDCMetadata">
            <xsl:with-param name="metadataName" select="'dc:rights'"/>
            <xsl:with-param name="metadataValue" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblFull/tei:publicationStmt/tei:date">
        <xsl:param name="metadataNS"/>
        <xsl:call-template name="generateDCMetadata">
            <xsl:with-param name="metadataName" select="'dc:date'"/>
            <xsl:with-param name="metadataValue" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblFull/tei:publicationStmt/tei:pubPlace">
        <xsl:param name="metadataNS"/>

        <xsl:call-template name="generateTermsMetadata">
            <xsl:with-param name="metadataName" select="'dcterms:Location'"/>
            <xsl:with-param name="metadataValue" select="."/>
            <xsl:with-param name="metadataNS" select="$metadataNS"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="generateHtml">
        <xsl:param name="divElem" required="yes"/>
        <xsl:param name="path" required="yes"/>

        <xsl:result-document href="{$path}" method="xml">
            <xsl:element name="html" namespace="{$HTML_URL}">
                <xsl:namespace name="dlxs" select="$DLXS_URL"/>

                <xsl:call-template name="generateHtmlHead">
                    <xsl:with-param name="divType" select="$divElem/@type"/>
                </xsl:call-template>

                <xsl:element name="body" namespace="{$HTML_URL}">
                    <xsl:namespace name="epub" select="$OPS_URL"/>
                    <xsl:apply-templates select="$divElem"/>
                </xsl:element>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="generateHtmlHead">
        <xsl:param name="divType" required="yes"/>

        <xsl:element name="head" namespace="{$HTML_URL}">
            <xsl:call-template name="insertStyles"/>
            <xsl:element name="meta" namespace="{$HTML_URL}">
                <xsl:attribute name="name" select="'viewport'"/>
                <xsl:attribute name="content" select="'initial-scale=1.0,maximum-scale=5.0'"/>
            </xsl:element>
            <xsl:if test="string-length($divType) > 0">
                <xsl:element name="meta" namespace="{$HTML_URL}">
                    <xsl:attribute name="name" select="$divType"/>
                    <xsl:attribute name="content" select="$divType"/>
                    <xsl:attribute name="role" select="'section'"/>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>

    <xsl:template name="generateTOC">
        <xsl:param name="itemList"/>
        <xsl:param name="rendition"/>
        <xsl:param name="init" select="'no'"/>

        <!-- If we decide to allow dlxs:status=nodisplay to be included, but suppressed.
        <xsl:variable name="entryList" select="$itemList[exists(./tei:head/tei:bibl[@type!='para'])]"/>
        -->
        <xsl:variable name="entryList" select="$itemList[(not(exists(@dlxs:status)) or @dlxs:status != 'toc-nodisplay') and exists(./tei:head/tei:bibl[@type!='para'])]"/>

        <xsl:if test="$init='yes' or count($entryList) > 0">
            <xsl:element name="ol" namespace="{$HTML_URL}">
                <xsl:if test="$init='yes'">
                    <xsl:variable name="ref" select="'cover.xhtml'"/>
                    <xsl:variable name="href" select="concat('xhtml',$FILE_SEPARATOR,$ref)"/>

                    <xsl:element name="li" namespace="{$HTML_URL}">
                        <xsl:element name="a" namespace="{$HTML_URL}">
                            <xsl:attribute name="href" select="$href"/>
                            <xsl:value-of select="'Cover'"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:if>
                <xsl:for-each-group select="$entryList" group-by="./tei:head">

                    <xsl:variable name="ref" select="mlibxsl:genReference(.)"/>
                    <xsl:variable name="href" select="concat('xhtml',$FILE_SEPARATOR,$ref)"/>

                    <xsl:element name="li" namespace="{$HTML_URL}">
                        <!-- If we decide to allow dlxs:status=nodisplay to be included, but suppressed.
                        <xsl:if test="exists(@dlxs:status)">
                            <xsl:attribute name="class" select="@dlxs:status"/>
                        </xsl:if>
                        -->
                        <xsl:element name="a" namespace="{$HTML_URL}">
                            <xsl:attribute name="href" select="$href"/>
                            <xsl:for-each select="./tei:head">
                                <xsl:if test="string-length(normalize-space(string())) > 0">
                                    <xsl:if test="position() > 1">
                                        <xsl:text> </xsl:text>
                                    </xsl:if>

                                    <xsl:apply-templates select="." mode="toc"/>
                                </xsl:if>
                            </xsl:for-each>
                            <!--
                            <xsl:if test="string-length(normalize-space(./tei:bibl)) > 0">
                                <xsl:text> (</xsl:text>
                                <xsl:apply-templates select="./tei:bibl/tei:author"/>
                                <xsl:if test="string-length(normalize-space(./tei:bibl/tei:biblScope)) > 0">
                                    <xsl:if test="string-length(normalize-space(./tei:bibl/tei:author)) > 0">
                                        <xsl:text>, </xsl:text>
                                    </xsl:if>
                                    <xsl:apply-templates select="./tei:bibl/tei:biblScope"/>
                                </xsl:if>
                                <xsl:text>)</xsl:text>
                            </xsl:if>
                            -->
                        </xsl:element>

                        <xsl:call-template name="generateTOC">
                            <xsl:with-param name="itemList" select="./tei:div"/>
                            <xsl:with-param name="rendition" select="$rendition"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:for-each-group>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template name="generatePGList">
        <xsl:param name="itemList"/>
        <xsl:param name="rendition"/>

        <xsl:if test="count($itemList) > 0">
            <xsl:element name="ol" namespace="{$HTML_URL}">
                <xsl:for-each select="$itemList">

                    <xsl:element name="li" namespace="{$HTML_URL}">
                        <xsl:element name="a" namespace="{$HTML_URL}">
                            <xsl:variable name="ref" select="mlibxsl:genReference(.)"/>
                            <xsl:variable name="href" select="concat('xhtml',$FILE_SEPARATOR,$ref)"/>
                            <xsl:attribute name="href" select="$href"/>
                            <xsl:value-of select="@n"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template name="generateCHList">
        <xsl:param name="itemList"/>
        <xsl:param name="rendition"/>

        <xsl:variable name="entryList" select="$itemList[not(exists(@dlxs:status)) or @dlxs:status != 'toc-nodisplay']"/>
        <xsl:if test="count($entryList) > 0">
            <xsl:element name="ol" namespace="{$HTML_URL}">
                <xsl:for-each-group select="$entryList" group-by="./tei:head">

                    <xsl:variable name="ref" select="mlibxsl:genReference(.)"/>
                    <xsl:variable name="href" select="concat('xhtml',$FILE_SEPARATOR,$ref)"/>

                    <xsl:element name="li" namespace="{$HTML_URL}">
                        <xsl:attribute name="class" select="@type"/>
                        <!-- If we decide to allow dlxs:status=nodisplay to be included, but suppressed.
                        <xsl:choose>
                            <xsl:when test="exists(@type) and exists(@dlxs:status)">
                                <xsl:attribute name="class" select="concat(@type,' ',@dlxs:status)"/>
                            </xsl:when>
                            <xsl:when test="exists(@type)">
                                <xsl:attribute name="class" select="@type"/>
                            </xsl:when>
                            <xsl:when test="exists(@dlxs:status)">
                                <xsl:attribute name="class" select="@dlxs:status"/>
                            </xsl:when>
                        </xsl:choose>
                        -->

                        <xsl:element name="a" namespace="{$HTML_URL}">
                            <xsl:attribute name="href" select="$href"/>
                            <xsl:for-each select="./tei:head">
                                <xsl:if test="string-length(normalize-space(.)) > 0">
                                    <xsl:if test="position() > 1">
                                        <xsl:text> </xsl:text>
                                    </xsl:if>

                                    <xsl:apply-templates select="." mode="toc"/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:element>

                        <xsl:call-template name="generateCHList">
                            <xsl:with-param name="itemList" select="./tei:div"/>
                            <xsl:with-param name="rendition" select="$rendition"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:for-each-group>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template name="generateContainerRenditionLabel">
        <xsl:param name="rendition"/>

        <xsl:attribute name="rendition:label" namespace="{$IDPF_RENDITION_URL}"
                       select="'XML'"/>
    </xsl:template>

    <xsl:template name="generateContainerLayout">
        <xsl:attribute name="rendition:layout" namespace="{$IDPF_RENDITION_URL}">
            <xsl:value-of select="'reflowable'"/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template name="generatePackageLayout">
        <xsl:element name="meta" namespace="{$IDPF_URL}">
            <xsl:attribute name="property" select="'rendition:layout'"/>
            <xsl:value-of select="'reflowable'"/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="insertUnorderedList">
        <xsl:param name="listNode" required="yes"/>

        <xsl:element name="ul" namespace="{$HTML_URL}">
            <xsl:if test="exists($listNode/@xml:id)">
                <xsl:attribute name="id" select="$listNode/@xml:id"/>
            </xsl:if>
            <xsl:attribute name="style">
                <xsl:choose>
                    <xsl:when test="$listNode/@type='bulleted'">
                        <xsl:value-of select="'list-style-type:circle'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'list-style-type:none'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>

            <xsl:apply-templates select="$listNode/*[local-name() != 'head']"/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="insertOrderedList">
        <xsl:param name="listNode" required="yes"/>

        <xsl:element name="ol" namespace="{$HTML_URL}">
            <xsl:if test="exists($listNode/@xml:id)">
                <xsl:attribute name="id" select="$listNode/@xml:id"/>
            </xsl:if>
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test="$listNode/@type='lowercasealpha'">
                        <xsl:value-of select="'a'"/>
                    </xsl:when>
                    <xsl:when test="$listNode/@type='uppercasealpha'">
                        <xsl:value-of select="'A'"/>
                    </xsl:when>
                    <xsl:when test="$listNode/@type='lowercaseroman'">
                        <xsl:value-of select="'i'"/>
                    </xsl:when>
                    <xsl:when test="$listNode/@type='uppercaseroman'">
                        <xsl:value-of select="'I'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'1'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="$listNode/*[local-name() != 'head']"/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="insertImage">
        <xsl:param name="figure" required="yes"/>

        <xsl:element name="img" namespace="{$HTML_URL}">
            <xsl:choose>
                <xsl:when test="$figure/@type='ic'">
                    <xsl:attribute name="src" select="$figure/@url"/>
                </xsl:when>
                <xsl:otherwise>
                    <!--
                    <xsl:attribute name="src" select="concat('..',$FILE_SEPARATOR,@url)"/>
                    -->
                    <xsl:attribute name="src" select="concat('..',$FILE_SEPARATOR,'images',$FILE_SEPARATOR,$figure/@dlxs:entity,'.jpg')"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="exists($figure/tei:figDesc)">
                    <xsl:attribute name="alt" select="$figure/tei:figDesc"/>
                </xsl:when>
                <xsl:when test="exists($figure/tei:head)">
                    <xsl:attribute name="alt" select="$figure/tei:head"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="alt" select="$figure/@dlxs:entity"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template name="insertHeading">
        <xsl:param name="headNode" required="yes"/>
        <xsl:param name="level" required="yes" as="xs:integer"/>

        <xsl:choose>
            <xsl:when test="$headNode/@type='title' or $headNode/@type='chapter'">
                <xsl:variable name="elemName">
                    <xsl:choose>
                        <xsl:when test="$level =  0">
                            <xsl:value-of select="'h6'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat('h',$level+2)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:element name="{$elemName}" namespace="{$HTML_URL}">
                    <xsl:if test="exists($headNode/@xml:id)">
                        <xsl:attribute name="id" select="$headNode/@xml:id"/>
                    </xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="$headNode/@type ='subtitle'">
                <xsl:element name="p" namespace="{$HTML_URL}">
                    <xsl:attribute name="role" select="'doc-subtitle'"/>
                    <xsl:attribute name="class" select="$headNode/@type"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="p" namespace="{$HTML_URL}">
                    <xsl:if test="exists(@xml:id)">
                        <xsl:attribute name="id" select="@xml:id"/>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="exists($headNode/@type)">
                            <xsl:attribute name="class" select="$headNode/@type"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="class" select="local-name()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:function name="mlibxsl:mapTarget">
        <xsl:param name="target"/>

        <xsl:variable name="tgt">
            <xsl:choose>
                <xsl:when test="starts-with($target,'#')">
                    <xsl:value-of select="substring($target,2)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$target"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="$tgt"/>

    </xsl:function>

    <xsl:function name="mlibxsl:genReference">
        <xsl:param name="divNode"/>

        <xsl:variable name="parentId" select="$divNode/ancestor::*[local-name()='div'][last()]/@xml:id"/>
        <xsl:variable name="divId" select="$divNode/@xml:id"/>

        <xsl:choose>
            <xsl:when test="empty($parentId)">
                <xsl:sequence select="concat($divId,'.xhtml')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="concat($parentId,'.xhtml#',$divId)"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:sequence select="()"/>
    </xsl:function>

    <xsl:function name="mlibxsl:genAssetReference" as="element()*">
        <xsl:param name="ref"/>

        <xsl:variable name="refNode"
                      select="$assetsTable/html:tr[html:td[@class='asset' and string()=$ref] and html:td[@class='media' and lower-case(string())='yes']]"/>
        <xsl:variable name="pngNode"
                      select="$assetsTable/html:tr[html:td[@class='asset' and string()=concat($ref,'.png')] and html:td[@class='media' and lower-case(string())='yes']]"/>
        <xsl:variable name="jpgNode"
                      select="$assetsTable/html:tr[html:td[@class='asset' and string()=concat($ref,'.jpg')] and html:td[@class='media' and lower-case(string())='yes']]"/>
        <xsl:choose>
            <xsl:when test="exists($refNode)">
                <xsl:sequence select="$refNode"/>
            </xsl:when>
            <xsl:when test="exists($pngNode)">
                <xsl:sequence select="$pngNode"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$jpgNode"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:function>

    <!--
    <xsl:function name="mlibxsl:genLinkReference" as="element()*">
        <xsl:param name="ref"/>

        <xsl:variable name="refNode"
                      select="$linksTable/html:tr[html:td[@class='asset' and string()=$ref]]"/>
        <xsl:variable name="pngNode"
                      select="$linksTable/html:tr[html:td[@class='asset' and string()=concat($ref,'.png')]]"/>
        <xsl:variable name="jpgNode"
                      select="$linksTable/html:tr[html:td[@class='asset' and string()=concat($ref,'.jpg')]]"/>
        <xsl:choose>
            <xsl:when test="exists($refNode)">
                <xsl:sequence select="$refNode"/>
            </xsl:when>
            <xsl:when test="exists($pngNode)">
                <xsl:sequence select="$pngNode"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$jpgNode"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:function>
    -->

    <xsl:function name="mlibxsl:generateHtmlId">
        <xsl:param name="div"/>

        <xsl:sequence select="mlibxsl:genDivName($div)"/>
    </xsl:function>

    <xsl:function name="mlibxsl:generateHtmlPath">
        <xsl:param name="div"/>
        <xsl:param name="pos"/>

        <xsl:sequence select="mlibxsl:genDivName($div)"/>
    </xsl:function>

    <xsl:function name="mlibxsl:genDivName">
        <xsl:param name="div"/>

        <xsl:variable name="cname">
            <xsl:choose>
                <xsl:when test="string-length(normalize-space($div/@xml:id)) > 0">
                    <xsl:value-of select="normalize-space($div/@xml:id)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$div/@type"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:sequence select="$cname"/>
    </xsl:function>

    <xsl:function name="mlibxsl:mapDivType2Value">
        <xsl:param name="mapType"/>
        <xsl:param name="key"/>

        <xsl:variable name="value">
            <xsl:choose>
                <xsl:when test="exists($valueMaps/valueMaps/map[@type=$mapType]/entry[@key=$key])">
                    <xsl:value-of select="$valueMaps/valueMaps/map[@type=$mapType]/entry[@key=$key]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="''"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:sequence select="$value"/>
    </xsl:function>

</xsl:stylesheet>