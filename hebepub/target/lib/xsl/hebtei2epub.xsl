<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:dlxs="http://mlib.umich.edu/namespace/dlxs"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:epub="http://www.idpf.org/2007/ops"
                xmlns:mlibxsl="http://www.mlib.umich.edu/namespace/mlibxsl"
                exclude-result-prefixes="xs xi dlxs tei marc html epub mlibxsl"
                version="2.0">

    <xsl:import href="heblibtei.xsl"/>

    <xsl:strip-space elements="*" />
    <xsl:output method="xml" indent="no"/>

    <xsl:variable name="renditions" select="''"/>
    <xsl:variable name="rendList" select="tokenize($renditions, ' ')"/>

    <xsl:variable name="tocList" select="/tei:TEI/tei:text/*/tei:div"/>

    <xsl:variable name="pgList" select="/tei:TEI/tei:text/tei:body//tei:p/tei:pb[exists(@n)]"/>

    <xsl:variable name="xenoDataHTML" select="'assets copyholder fonts images related_title reviews series stylesheets subject'"/>
    <xsl:variable name="xenoDataHTMLList" select="tokenize($xenoDataHTML, ' ')"/>

    <xsl:template match="/">

        <xsl:call-template name="generateMimetype"/>
        <xsl:call-template name="generateContainer"/>
        <xsl:call-template name="generateMetadata"/>

        <xsl:if test="count($tocList) > 0">
            <xsl:for-each select="$rendList">
                <xsl:variable name="rendition" select="."/>

                <xsl:variable name="tocBasePath"
                              select="concat('toc_', $rendition, '.xhtml')"/>
                <xsl:variable name="tocPath" select="concat($epubContentDir, $tocBasePath)"/>

                <xsl:call-template name="generate_nav">
                    <xsl:with-param name="itemList" select="$tocList"/>
                    <xsl:with-param name="href" select="$tocPath"/>
                    <xsl:with-param name="navType" select="'toc'"/>
                    <xsl:with-param name="navHeader" select="$toc-title"/>
                    <xsl:with-param name="rendition" select="$rendition"/>
                </xsl:call-template>

                <xsl:variable name="chListBasePath"
                              select="concat('chapterlist_', $rendition, '.xhtml')"/>
                <xsl:variable name="chListPath" select="concat($epubContentDir, $chListBasePath)"/>

                <xsl:call-template name="generate_nav">
                    <xsl:with-param name="itemList" select="$tocList"/>
                    <xsl:with-param name="href" select="$chListPath"/>
                    <xsl:with-param name="navType" select="'chapter-list'"/>
                    <xsl:with-param name="navHeader" select="$chapterlist-title"/>
                    <xsl:with-param name="rendition" select="$rendition"/>
                    <xsl:with-param name="isHidden" select="'yes'"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>

        <xsl:if test="count($pgList) > 0">
            <xsl:for-each select="$rendList">
                <xsl:variable name="rendition" select="."/>

                <xsl:variable name="pgListBasePath" select="concat('pagelist_', $rendition, '.xhtml')"/>
                <xsl:variable name="pgListPath" select="concat($epubContentDir, $pgListBasePath)"/>

                <xsl:call-template name="generate_nav">
                    <xsl:with-param name="itemList" select="$pgList"/>
                    <xsl:with-param name="href" select="$pgListPath"/>
                    <xsl:with-param name="navType" select="'page-list'"/>
                    <xsl:with-param name="navHeader" select="$pagelist-title"/>
                    <xsl:with-param name="rendition" select="$rendition"/>
                    <xsl:with-param name="isHidden" select="'yes'"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tei:TEI">
        <xsl:param name="rendition"/>

        <xsl:element name="package" namespace="{$IDPF_URL}">
            <xsl:attribute name="unique-identifier" select="'unique-identifier'"/>
            <xsl:attribute name="version" select="'3.0'"/>

            <xsl:apply-templates>
                <xsl:with-param name="rendition" select="$rendition"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:teiHeader">

        <xsl:element name="metadata" namespace="{$IDPF_URL}">
            <xsl:namespace name="rendition" select="$IDPF_RENDITION_URL"/>
            <xsl:namespace name="dc" select="$PURL_DC_URL"/>
            <xsl:namespace name="dcterms" select="$PURL_DCTERMS_URL"/>

            <xsl:call-template name="insertCommonMetadata">
                <xsl:with-param name="metadataNS" select="$IDPF_URL"/>
            </xsl:call-template>

            <xsl:call-template name="generatePackageLayout"/>

            <xsl:element name="meta" namespace="{$IDPF_URL}">
                <xsl:attribute name="property" select="'rendition:orientation'"/>
                <xsl:value-of select="'auto'"/>
            </xsl:element>

            <xsl:element name="meta" namespace="{$IDPF_URL}">
                <xsl:attribute name="property" select="'rendition:spread'"/>
                <xsl:value-of select="'auto'"/>
            </xsl:element>

            <xsl:if test="exists($coverImageRow)">
                <xsl:element name="meta" namespace="{$IDPF_URL}">
                    <xsl:attribute name="name" select="'cover'"/>
                    <xsl:attribute name="content" select="'cover-image'"/>
                </xsl:element>
            </xsl:if>
        </xsl:element>
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

    <xsl:template match="tei:teiHeader/tei:profileDesc/tei:textClass/tei:keywords/tei:term">
        <!--
        <xsl:call-template name="generateDCMetadata">
            <xsl:with-param name="metadataName" select="'dc:subject'"/>
            <xsl:with-param name="metadataValue" select="."/>
        </xsl:call-template>
        -->
    </xsl:template>

    <xsl:template match="html:td[@class='subject']">
        <!-- Skip adding subject -->
        <!--
        <xsl:call-template name="generateDCMetadata">
            <xsl:with-param name="metadataName" select="'dc:subject'"/>
            <xsl:with-param name="metadataValue" select="."/>
        </xsl:call-template>
        -->
    </xsl:template>

    <xsl:template match="element()">
        <xsl:message>Element <xsl:value-of select="concat(name(ancestor::*[1]),'/',name())"/> not processed. Content=<xsl:value-of select="."/></xsl:message>
        <xsl:apply-templates/>
    </xsl:template>

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
                                    <xsl:with-param name="init" select="'yes'"/>
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

    <xsl:template name="generateContainer">

        <xsl:variable name="textClass" select="/tei:TEI"/>

        <xsl:variable name="containerPath" select="concat($epubMetaDir, 'container.xml')"/>
        <xsl:result-document href="{$containerPath}" method="xml">
            <xsl:element name="container" namespace="{$OCF_URI}">
                <xsl:namespace name="rendition" select="$IDPF_RENDITION_URL"/>
                <xsl:attribute name="version" select="'1.0'"/>
                <xsl:element name="rootfiles" namespace="{$OCF_URI}">
                    <xsl:for-each select="$rendList">
                        <xsl:variable name="rendition" select="."/>

                        <xsl:variable name="packageBasePath"
                                      select="concat($CONTENT_FOLDER,$FILE_SEPARATOR,'content_', $rendition, '.opf')"/>
                        <xsl:variable name="packagePath"
                                      select="concat($epubRootDir, $packageBasePath)"/>
                        <xsl:element name="rootfile" namespace="{$OCF_URI}">
                            <xsl:attribute name="full-path" select="$packageBasePath"/>
                            <xsl:attribute name="media-type" select="'application/oebps-package+xml'"/>

                            <xsl:call-template name="generateContainerRenditionLabel">
                                <xsl:with-param name="rendition" select="$rendition"/>
                            </xsl:call-template>

                            <xsl:call-template name="generateContainerLayout"/>

                            <xsl:attribute name="rendition:language" namespace="{$IDPF_RENDITION_URL}"
                                           select="$dc-language"/>
                            <xsl:attribute name="rendition:media" namespace="{$IDPF_RENDITION_URL}"
                                           select="'(orientation:portrait)'"/>
                            <xsl:attribute name="rendition:accessMode" namespace="{$IDPF_RENDITION_URL}" select="'visual'"/>
                        </xsl:element>

                        <xsl:result-document href="{$packagePath}" method="xml">
                            <xsl:apply-templates select="$textClass">
                                <xsl:with-param name="rendition" select="$rendition"/>
                            </xsl:apply-templates>
                        </xsl:result-document>
                    </xsl:for-each>
                </xsl:element>

                <!--
                <xsl:variable name="icFigList" select="//*[local-name()='figure'][@type='ic']"/>

                <xsl:if test="count($icFigList) > 0">
                    <xsl:element name="links" namespace="{$OCF_URI}">
                        <xsl:for-each select="$icFigList">
                            <xsl:element name="link" namespace="{$OCF_URI}">
                                <xsl:attribute name="href" select="tei:graphic/@url"/>
                                <xsl:attribute name="media-type" select="'image/jpeg'"/>
                                <xsl:attribute name="rel" select="'prefetch'"/>
                            </xsl:element>
                        </xsl:for-each>
                    </xsl:element>
                </xsl:if>
                -->
            </xsl:element>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="generateTOC">
        <xsl:param name="itemList"/>
        <xsl:param name="rendition"/>
        <xsl:param name="init" select="'no'"/>

        <xsl:message>generateTOC: not implemented.</xsl:message>
    </xsl:template>

    <xsl:template name="generatePGList">
        <xsl:param name="itemList"/>
        <xsl:param name="rendition"/>

        <xsl:message>generatePGList: not implemented.</xsl:message>
    </xsl:template>

    <xsl:template name="generateCHList">
        <xsl:param name="itemList"/>
        <xsl:param name="rendition"/>

        <xsl:message>generateCHList: not implemented.</xsl:message>
    </xsl:template>

    <xsl:template name="generateContainerRenditionLabel">
        <xsl:param name="rendition"/>

        <xsl:message>generatContainerRenditionLabel: not implemented.</xsl:message>
    </xsl:template>

    <xsl:template name="generateContainerLayout">
        <xsl:message>generateContainerLayout: not implemented.</xsl:message>
    </xsl:template>

    <xsl:template name="generatePackageLayout">
        <xsl:message>generatePackageLayout: not implemented.</xsl:message>
    </xsl:template>

    <xsl:template name="generateMimetype">
        <xsl:variable name="mimePath" select="concat($epubRootDir, $FILE_SEPARATOR, 'mimetype')"/>
        <xsl:result-document href="{$mimePath}" method="text">application/epub+zip</xsl:result-document>
    </xsl:template>

    <xsl:template name="generateMetadata">
        <xsl:variable name="metaPath" select="concat($epubMetaDir,'metadata.xml')"/>
        <xsl:result-document href="{$metaPath}" method="xml">
            <xsl:element name="metadata" namespace="{$IDPF_METADATA_URL}">
                <xsl:namespace name="dc" select="$PURL_DC_URL"/>
                <xsl:namespace name="dcterms" select="$PURL_DCTERMS_URL"/>

                <xsl:attribute name="unique-identifier" select="'unique-identifier'"/>
                <xsl:attribute name="version" select="'3.0'"/>

                <xsl:call-template name="insertCommonMetadata">
                    <xsl:with-param name="metadataNS" select="$IDPF_METADATA_URL"/>
                </xsl:call-template>

                <xsl:element name="link" namespace="{$IDPF_METADATA_URL}">
                    <xsl:attribute name="rel" select="'record'"/>
                    <xsl:attribute name="href" select="concat('src',$FILE_SEPARATOR,$dc-identifier,'_dlxs.xml')"/>
                    <xsl:attribute name="media-type" select="'application/xml'"/>
                </xsl:element>

                <xsl:element name="link" namespace="{$IDPF_METADATA_URL}">
                    <xsl:attribute name="rel" select="'record'"/>
                    <xsl:attribute name="href" select="concat('src',$FILE_SEPARATOR,$dc-identifier,'_tei.xml')"/>
                    <xsl:attribute name="media-type" select="'application/xml'"/>
                </xsl:element>
                <xsl:if test="exists($marcDoc/marc:record)">
                    <xsl:element name="link" namespace="{$IDPF_METADATA_URL}">
                        <xsl:attribute name="rel" select="'record'"/>
                        <xsl:attribute name="href" select="concat('src',$FILE_SEPARATOR,'marc.xml')"/>
                        <xsl:attribute name="media-type" select="'application/marc'"/>
                    </xsl:element>
                </xsl:if>

                <xsl:for-each select="$xenoDataHTMLList">
                    <xsl:element name="link" namespace="{$IDPF_METADATA_URL}">
                        <xsl:variable name="fileName" select="."/>

                        <xsl:attribute name="rel" select="'record'"/>
                        <xsl:attribute name="href" select="concat('src',$FILE_SEPARATOR,$fileName,'.html')"/>
                        <xsl:attribute name="media-type" select="'application/xhtml+xml'"/>
                    </xsl:element>
                </xsl:for-each>

            </xsl:element>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="insertCommonMetadata">
        <xsl:param name="metadataNS"/>

        <xsl:element name="dc:identifier" namespace="{$PURL_DC_URL}">
            <xsl:attribute name="id" select="'unique-identifier'"/>
            <xsl:value-of select="$dc-identifier"/>
        </xsl:element>
        <xsl:element name="dc:language" namespace="{$PURL_DC_URL}">
            <xsl:value-of select="$dc-language"/>
        </xsl:element>

        <xsl:call-template name="generateMetadataList">
            <xsl:with-param name="xpath" select="$dc-title-list"/>
            <xsl:with-param name="metadataNS" select="$metadataNS"/>
        </xsl:call-template>
        <xsl:call-template name="generateMetadataList">
            <xsl:with-param name="xpath" select="$dc-creator-list"/>
            <xsl:with-param name="metadataNS" select="$metadataNS"/>
        </xsl:call-template>
        <xsl:call-template name="generateMetadataList">
            <xsl:with-param name="xpath" select="$dc-contributor-list"/>
            <xsl:with-param name="metadataNS" select="$metadataNS"/>
        </xsl:call-template>
        <xsl:call-template name="generateMetadataList">
            <xsl:with-param name="xpath" select="$dc-publisher-list"/>
            <xsl:with-param name="metadataNS" select="$metadataNS"/>
        </xsl:call-template>
        <xsl:call-template name="generateMetadataList">
            <xsl:with-param name="xpath" select="$dc-rights-list"/>
            <xsl:with-param name="metadataNS" select="$metadataNS"/>
        </xsl:call-template>

        <xsl:if test="string-length(normalize-space($dc-description)) > 0">
            <xsl:element name="dc:description" namespace="{$PURL_DC_URL}">
                <xsl:value-of select="$dc-description"/>
            </xsl:element>
        </xsl:if>

        <xsl:call-template name="generateMetadataList">
            <xsl:with-param name="xpath" select="$dc-subject-list"/>
            <xsl:with-param name="metadataNS" select="$metadataNS"/>
        </xsl:call-template>
        <xsl:call-template name="generateMetadataList">
            <xsl:with-param name="xpath" select="$dc-source-list"/>
            <xsl:with-param name="metadataNS" select="$metadataNS"/>
        </xsl:call-template>

        <xsl:for-each select="$copyholderRowList">
            <xsl:variable name="copyholder" select="./*[local-name()='td'][@class='copyholder']"/>

            <xsl:if test="string-length(normalize-space($copyholder)) > 0">
                <xsl:variable name="puburl" select="./*[local-name()='td'][@class='puburl']"/>
                <xsl:variable name="metadataValue">
                    <xsl:choose>
                        <xsl:when test="string-length(normalize-space($puburl)) > 0">
                            <xsl:value-of select="concat($copyholder,' [',$puburl,']')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$copyholder"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="generateTermsMetadata">
                    <xsl:with-param name="metadataName" select="'dcterms:rightsHolder'"/>
                    <xsl:with-param name="metadataValue" select="$metadataValue"/>
                    <xsl:with-param name="metadataNS" select="$metadataNS"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>

        <xsl:call-template name="generateTermsMetadata">
            <xsl:with-param name="metadataName" select="'dcterms:modified'"/>
            <xsl:with-param name="metadataValue" select="$dcterms-modified"/>
            <xsl:with-param name="metadataNS" select="$metadataNS"/>
        </xsl:call-template>

        <xsl:call-template name="generateMetadataList">
            <xsl:with-param name="xpath" select="$dc-date-list"/>
            <xsl:with-param name="metadataNS" select="$metadataNS"/>
        </xsl:call-template>
        <xsl:call-template name="generateMetadataList">
            <xsl:with-param name="xpath" select="$dcterms-Location-list"/>
            <xsl:with-param name="metadataNS" select="$metadataNS"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="generateMetadataList">
        <xsl:param name="xpath"/>
        <xsl:param name="metadataNS"/>

        <xsl:for-each-group select="$xpath" group-by=".">
            <xsl:apply-templates select=".">
                <xsl:with-param name="metadataNS" select="$metadataNS"/>
            </xsl:apply-templates>
        </xsl:for-each-group>
    </xsl:template>

    <xsl:template name="generateDCMetadata">
        <xsl:param name="metadataName"/>
        <xsl:param name="metadataValue"/>

        <xsl:element name="{$metadataName}" namespace="{$PURL_DC_URL}">
            <xsl:value-of select="mlibxsl:strip_punctuation($metadataValue)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="generateTermsMetadata">
        <xsl:param name="metadataName"/>
        <xsl:param name="metadataValue"/>
        <xsl:param name="metadataNS"/>

        <xsl:element name="meta" namespace="{$metadataNS}">
            <xsl:attribute name="property" select="$metadataName"/>
            <xsl:value-of select="mlibxsl:strip_punctuation($metadataValue)"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>