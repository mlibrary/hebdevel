<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        xmlns:xi="http://www.w3.org/2001/XInclude"
        xmlns:dlxs="http://mlib.umich.edu/namespace/dlxs"
        exclude-result-prefixes="xs xi"
        version="2.0">

    <xsl:import href="heblib.xsl"/>


    <xsl:strip-space elements="*" />
    <xsl:output method="xml" indent="no"/>

    <xsl:param name="identifier" select="/DLPSTEXTCLASS/HEADER/FILEDESC/PUBLICATIONSTMT/IDNO[@TYPE='heb']"/>

    <xsl:template match="/">
        <xsl:variable name="teiPath" select="concat($working-dir,$identifier,'_tei.xml')"/>
        <xsl:result-document href="{$teiPath}" method="xml">
            <xsl:apply-templates select="DLPSTEXTCLASS"/>
        </xsl:result-document>

        <!--<xsl:call-template name="genImageTable"/>-->

    </xsl:template>

    <xsl:template match="DLPSTEXTCLASS">
        <xsl:element name="TEI" namespace="{$TEI_URL}">
            <xsl:namespace name="dlxs" select="$DLXS_URL"/>

            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="SN|PRICE|IMPRINT|RUNHEAD|PERFORMANCE|SUP|EDITORIND
        |DIVINFO|DESCRIPT|SUPPLIED|CASTGROUP|V|SET
        |Q2|COPYRIGHT|Q3|PROLOGUE|SUBHEAD|FIRSTL|APP|CAESURA|DATES|PREFACE
        |SERIES|FW|ALIAS|RDG|DEDICAT|EPILOGUE|AUTHORIND|CASTLIST|ROLEDESC
        |WIT|EPB|XPTR|XREF|ORIGINAL|ROLE|VB|CASTITEM">
        <xsl:element name="{concat('dlxs:',lower-case(name()))}">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="MILESTONE">
        <xsl:element name="{lower-case(name())}" namespace="{$TEI_URL}">
            <xsl:attribute name="unit" select="'absent'"/>

            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="DIV1|DIV2|DIV3|DIV4|DIV5|DIV6|DIV7|DIV8|DIV9|DIV10
        |HI1|HI2|HI3
        |NOTE1|NOTE2|NOTE3
        |Q1">
        <xsl:variable name="elemName">
            <xsl:analyze-string select="local-name()" regex="^([^0-9]+)">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:element name="{lower-case($elemName)}" namespace="{$TEI_URL}">
            <!-- Do we need to remember the level number? -->
            <xsl:variable name="elemLevel" select="substring(local-name(),string-length($elemName)+1)"/>
            <xsl:attribute name="dlxs:level" select="$elemLevel"/>

            <xsl:apply-templates select="@*"/>
            <xsl:if test="lower-case($elemName) = 'hi'">
                <xsl:variable name="rendVal" select="lower-case(@REND)"/>
                <xsl:choose>
                    <xsl:when test="$rendVal = 'i'">
                        <xsl:attribute name="rend" select="'italic'"/>
                    </xsl:when>
                    <xsl:when test="$rendVal = 'b'">
                        <xsl:attribute name="rend" select="'bold'"/>
                    </xsl:when>
                    <!--
                    <xsl:otherwise>
                        <xsl:attribute name="dlxs:hi" select="@REND"/>
                    </xsl:otherwise>
                    -->
                </xsl:choose>
            </xsl:if>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="HEAD">
        <!--
        <xsl:choose>
            <xsl:when test="exists(@*)">
                <xsl:element name="{lower-case(local-name())}" namespace="{$TEI_URL}">
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                Skip element with no attributes
            </xsl:otherwise>
        </xsl:choose>
        -->
        <xsl:element name="{lower-case(local-name())}" namespace="{$TEI_URL}">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="EPIGRAPH_CURRENT">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="EPIGRAPH">
        <xsl:element name="{lower-case(local-name())}" namespace="{$TEI_URL}">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="FIGURE">
        <xsl:element name="{lower-case(local-name())}" namespace="{$TEI_URL}">
            <xsl:apply-templates select="@*"/>
            <!--
            <xsl:element name="graphic" namespace="{$TEI_URL}">
                <xsl:variable name="imgFile" select="concat(@ENTITY,'.jpg')"/>

                <xsl:choose>
                    <xsl:when test="lower-case(@TYPE)='ic'">
                        <xsl:attribute name="url" select="concat('https://quod.lib.umich.edu/a/acls/images/',$imgFile)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="url" select="concat('images/',$imgFile)"/>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:element>
            <xsl:apply-templates select="node()"/>
            -->
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="REF">
        <xsl:element name="{lower-case(local-name())}" namespace="{$TEI_URL}">
            <xsl:apply-templates select="@*[name() != 'FILENAME']"/>
            <xsl:choose>
                <xsl:when test="lower-case(@TYPE) = 'unity'">
                    <xsl:attribute name="target" select="@NAME"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="string-length(@TARGET) > 0 and substring(@TARGET,1,1) != '#'">
                        <xsl:attribute name="target" select="concat('#',@TARGET)"/>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="exists(@FILENAME)">
                <xsl:attribute name="source" select="@FILENAME"/>
            </xsl:if>
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="PUBLICATIONSTMT">
        <xsl:element name="publicationStmt" namespace="{$TEI_URL}">
            <xsl:apply-templates select="@*"/>

            <xsl:apply-templates select="PUBLISHER"/>
            <xsl:apply-templates select="DATE|PUBPLACE|IDNO|AVAILABILITY"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="HEADER">
        <xsl:element name="teiHeader" namespace="{$TEI_URL}">
            <xsl:apply-templates select="@*|node()"/>

            <xsl:element name="xenoData" namespace="{$TEI_URL}">
                <xsl:attribute name="type" select="'marcxml'"/>

                <xsl:element name="xi:include" namespace="{$XI_URL}">
                    <xsl:attribute name="href" select="'marc.xml'"/>
                </xsl:element>
            </xsl:element>

            <xsl:element name="xenoData" namespace="{$TEI_URL}">
                <xsl:attribute name="type" select="'copyholder'"/>

                <xsl:element name="xi:include" namespace="{$XI_URL}">
                    <xsl:attribute name="href" select="'copyholder.html'"/>
                </xsl:element>
            </xsl:element>

            <xsl:element name="xenoData" namespace="{$TEI_URL}">
                <xsl:attribute name="type" select="'related_title'"/>

                <xsl:element name="xi:include" namespace="{$XI_URL}">
                    <xsl:attribute name="href" select="'related.html'"/>
                    <xsl:call-template name="insertFallback"/>
                </xsl:element>
            </xsl:element>

            <xsl:element name="xenoData" namespace="{$TEI_URL}">
                <xsl:attribute name="type" select="'reviews'"/>

                <xsl:element name="xi:include" namespace="{$XI_URL}">
                    <xsl:attribute name="href" select="'reviews.html'"/>
                    <xsl:call-template name="insertFallback"/>
                </xsl:element>
            </xsl:element>

            <xsl:element name="xenoData" namespace="{$TEI_URL}">
                <xsl:attribute name="type" select="'series'"/>

                <xsl:element name="xi:include" namespace="{$XI_URL}">
                    <xsl:attribute name="href" select="'series.html'"/>
                    <xsl:call-template name="insertFallback"/>
                </xsl:element>
            </xsl:element>

            <xsl:element name="xenoData" namespace="{$TEI_URL}">
                <xsl:attribute name="type" select="'subject'"/>

                <xsl:element name="xi:include" namespace="{$XI_URL}">
                    <xsl:attribute name="href" select="'subject.html'"/>
                    <xsl:call-template name="insertFallback"/>
                </xsl:element>
            </xsl:element>

            <xsl:element name="xenoData" namespace="{$TEI_URL}">
                <xsl:attribute name="type" select="'assets'"/>

                <xsl:element name="xi:include" namespace="{$XI_URL}">
                    <xsl:attribute name="href" select="'assets.html'"/>
                    <xsl:call-template name="insertFallback"/>
                </xsl:element>
            </xsl:element>

            <xsl:element name="xenoData" namespace="{$TEI_URL}">
                <xsl:attribute name="type" select="'fonts'"/>

                <xsl:element name="xi:include" namespace="{$XI_URL}">
                    <xsl:attribute name="href" select="'fonts.html'"/>
                    <xsl:call-template name="insertFallback"/>
                </xsl:element>
            </xsl:element>

            <!--
            <xsl:element name="xenoData" namespace="{$TEI_URL}">
                <xsl:attribute name="type" select="'links'"/>

                <xsl:element name="xi:include" namespace="{$XI_URL}">
                    <xsl:attribute name="href" select="'links.html'"/>
                    <xsl:call-template name="insertFallback"/>
                </xsl:element>
            </xsl:element>
            -->

            <xsl:element name="xenoData" namespace="{$TEI_URL}">
                <xsl:attribute name="type" select="'stylesheets'"/>

                <xsl:element name="xi:include" namespace="{$XI_URL}">
                    <xsl:attribute name="href" select="'stylesheets.html'"/>
                    <xsl:call-template name="insertFallback"/>
                </xsl:element>
            </xsl:element>

             <xsl:element name="xenoData" namespace="{$TEI_URL}">
                 <xsl:attribute name="type" select="'images'"/>

                 <xsl:element name="xi:include" namespace="{$XI_URL}">
                     <xsl:attribute name="href" select="'images.html'"/>
                     <xsl:call-template name="insertFallback"/>
                 </xsl:element>
             </xsl:element>

            <!--
            <xsl:element name="xenoData" namespace="{$TEI_URL}">
                <xsl:attribute name="type" select="'coverpages'"/>

                <xsl:element name="xi:include" namespace="{$XI_URL}">
                    <xsl:attribute name="href" select="'coverpages.html'"/>
                    <xsl:call-template name="insertFallback"/>
                </xsl:element>
            </xsl:element>

             <xsl:element name="xenoData" namespace="{$TEI_URL}">
                 <xsl:attribute name="type" select="'jp2'"/>

                 <xsl:element name="xi:include" namespace="{$XI_URL}">
                     <xsl:attribute name="href" select="'jp2.html'"/>
                     <xsl:call-template name="insertFallback"/>
                 </xsl:element>
             </xsl:element>

             <xsl:element name="xenoData" namespace="{$TEI_URL}">
                 <xsl:attribute name="type" select="'tif'"/>

                 <xsl:element name="xi:include" namespace="{$XI_URL}">
                     <xsl:attribute name="href" select="'tif.html'"/>
                     <xsl:call-template name="insertFallback"/>
                 </xsl:element>
             </xsl:element>

             <xsl:element name="xenoData" namespace="{$TEI_URL}">
                 <xsl:attribute name="type" select="'imgtable'"/>

                 <xsl:element name="xi:include" namespace="{$XI_URL}">
                     <xsl:attribute name="href" select="'imgtable.html'"/>
                     <xsl:call-template name="insertFallback"/>
                 </xsl:element>
             </xsl:element>
             -->
        </xsl:element>
    </xsl:template>

    <xsl:template match="element()">
        <xsl:variable name="nname">
            <xsl:choose>
                <!--
                <xsl:when test="local-name() = 'HEADER'">
                    <xsl:value-of select="'teiHeader'"/>
                </xsl:when>
                -->
                <xsl:when test="local-name() = 'SOCALLED'">
                    <xsl:value-of select="'soCalled'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'REVISIONDESC'">
                    <xsl:value-of select="'revisionDesc'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'PUBPLACE'">
                    <xsl:value-of select="'pubPlace'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'DOCTITLE'">
                    <xsl:value-of select="'docTitle'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'NOTESSTMT'">
                    <xsl:value-of select="'notesStmt'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'FIGDESC'">
                    <xsl:value-of select="'figDesc'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'RESPSTMT'">
                    <xsl:value-of select="'respStmt'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'EDITORIALDECL'">
                    <xsl:value-of select="'editorialDecl'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'CLASSCODE'">
                    <xsl:value-of select="'classCode'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'TITLEPART'">
                    <xsl:value-of select="'titlePart'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'TEXTCLASS'">
                    <xsl:value-of select="'textClass'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'SOURCEDESC'">
                    <xsl:value-of select="'sourceDesc'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'ENCODINGDESC'">
                    <xsl:value-of select="'encodingDesc'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'CLASSDECL'">
                    <xsl:value-of select="'classDecl'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'CATREF'">
                    <xsl:value-of select="'catRef'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'TITLESTMT'">
                    <xsl:value-of select="'titleStmt'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'REFSDECL'">
                    <xsl:value-of select="'refsDecl'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'PUBLICATIONSTMT'">
                    <xsl:value-of select="'publicationStmt'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'LANGUSAGE'">
                    <xsl:value-of select="'langUsage'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'DOCEDITION'">
                    <xsl:value-of select="'docEdition'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'BIBLSCOPE'">
                    <xsl:value-of select="'biblScope'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'BIBLFULL'">
                    <xsl:value-of select="'biblFull'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'PROJECTDESC'">
                    <xsl:value-of select="'projectDesc'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'PROFILEDESC'">
                    <xsl:value-of select="'profileDesc'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'LISTBIBL'">
                    <xsl:value-of select="'listBibl'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'DOCDATE'">
                    <xsl:value-of select="'docDate'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'DOCAUTHOR'">
                    <xsl:value-of select="'docAuthor'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'ADDRLINE'">
                    <xsl:value-of select="'addrLine'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'TITLEPAGE'">
                    <xsl:value-of select="'titlePage'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'SERIESSTMT'">
                    <xsl:value-of select="'seriesStmt'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'SAMPLINGDECL'">
                    <xsl:value-of select="'samplingDecl'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'FILEDESC'">
                    <xsl:value-of select="'fileDesc'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'EDITIONSTMT'">
                    <xsl:value-of select="'editionStmt'"/>
                </xsl:when>
                <xsl:when test="local-name() = 'DOCIMPRINT'">
                    <xsl:value-of select="'docImprint'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="lower-case(local-name())"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$nname = ''">
                <xsl:apply-templates select="@*|node()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="{$nname}" namespace="{$TEI_URL}">
                    <xsl:apply-templates select="@*|node()"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="@NAME|@NODE|@ENTITY|@URL|@BORDER|@COLSPAN|@ROWSPAN|@STATUS
            |AUTHOR/@TYPE|PB/@REF|PB/@SEQ|PB/@RES|PB/@FMT|PB/@FTR|PB/@CNF|LIST/@TYPE
            |P/@ALIGN|TABLE/@ALIGN|CELL/@TYPE|SIGNED/@ALIGN|DATELINE/@ALIGN|SALUTE/@ALIGN">
        <xsl:attribute name="{concat('dlxs:',lower-case(local-name()))}" select="lower-case(.)"/>
    </xsl:template>

    <xsl:template match="BIBLSCOPE/@TYPE">
        <xsl:variable name="type" select="."/>
        <xsl:choose>
            <xsl:when test="$type = 'pg'">
                <xsl:attribute name="unit" select="'page'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="{concat('dlxs:',lower-case(local-name()))}" select="$type"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="PTR/@TARGET">
        <xsl:attribute name="{lower-case(local-name())}" select="."/>
    </xsl:template>

    <xsl:template match="@ID">
        <xsl:attribute name="{concat('xml:',lower-case(local-name()))}" select="."/>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:attribute name="{lower-case(local-name())}" select="lower-case(.)"/>
    </xsl:template>

    <xsl:template match="text()">
        <!--
        <xsl:copy>.</xsl:copy>
        -->
        <xsl:value-of select="." disable-output-escaping="no"/>
    </xsl:template>

    <xsl:template name="insertFallback">
        <xsl:element name="xi:fallback" namespace="{$XI_URL}">
            <xsl:element name="table" namespace="{$HTML_URL}">
                <xsl:element name="tbody" namespace="{$HTML_URL}">
                    <xsl:element name="tr" namespace="{$HTML_URL}">
                        <xsl:element name="th" namespace="{$HTML_URL}">
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!--
    <xsl:template name="genImageTable">
        <xsl:param name="imgProperties" select="'id entity type'"/>
        <xsl:variable name="imgPropertiesList" select="tokenize($imgProperties, ' ')"/>

        <xsl:variable name="figureList" select="//*[local-name()='FIGURE']"/>

        <xsl:variable name="path" select="concat($working-dir,'imgtable.html')"/>
        <xsl:result-document href="{$path}" method="xml">
            <xsl:element name="table" namespace="{$HTML_URL}">
                <xsl:attribute name="id" select="concat($identifier, '_imgtable')"/>
                <xsl:attribute name="title" select="$identifier"/>

                <xsl:element name="thead" namespace="{$HTML_URL}">
                    <xsl:element name="tr" namespace="{$HTML_URL}">
                        <xsl:for-each select="$imgPropertiesList">
                            <xsl:element name="th" namespace="{$HTML_URL}">
                                <xsl:attribute name="class" select="."/>
                                <xsl:value-of select="."/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="tbody" namespace="{$HTML_URL}">
                    <xsl:choose>
                        <xsl:when test="count($figureList) > 0">
                            <xsl:for-each select="$figureList">
                                <xsl:variable name="figure" select="."/>

                                <xsl:element name="tr" namespace="{$HTML_URL}">
                                    <xsl:for-each select="$imgPropertiesList">
                                        <xsl:variable name="property" select="."/>

                                        <xsl:element name="td" namespace="{$HTML_URL}">
                                            <xsl:attribute name="class" select="$property"/>

                                            <xsl:choose>
                                                <xsl:when test="$property='type' and not(exists($figure/@TYPE))">
                                                    <xsl:value-of select="'embed'"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$figure/@*[lower-case(local-name())=$property]"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="tr" namespace="{$HTML_URL}">
                                <xsl:for-each select="$imgPropertiesList">
                                    <xsl:element name="td" namespace="{$HTML_URL}">
                                        <xsl:attribute name="class" select="."/>
                                    </xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>
    -->

</xsl:stylesheet>