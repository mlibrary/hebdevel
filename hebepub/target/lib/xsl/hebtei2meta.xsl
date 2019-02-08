<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:dlxs="http://mlib.umich.edu/namespace/dlxs"
                xmlns:mlibxsl="http://www.mlib.umich.edu/namespace/mlibxsl"
                exclude-result-prefixes="xs xi tei html dlxs mlibxsl"
                version="2.0">

    <xsl:import href="heblibtei.xsl"/>

    <xsl:output method="text" indent="no"/>

    <xsl:variable name="PROPERTIES"
                  select="'File Name,Identifier(s),Legacy ID,Title,Resource Type,Representative Kind,External Resource URL,Caption,Alternative Text,Copyright Holder,Allow High-Res Display?,Allow Download?,Copyright Status,Rights Granted,Rights Granted - Creative Commons,Permissions Expiration Date,After Expiration: Allow Display?,After Expiration: Allow Download?,Credit Line,Holding Contact,Exclusive to Fulcrum,Persistent ID - Display on Platform,Persistent ID - XML for CrossRef,Persistent ID - Handle,Content Type,Creator(s),Primary Creator Role,Additional Creator(s),Sort Date,Display Date,Series,Description,Keywords,Section,Language,Transcript,Translation,Publisher,Subject,ISBN(s),Buy Book URL,Pub Year,Pub Location'"/>
    <xsl:variable name="propertyList" select="tokenize($PROPERTIES,',')"/>
    <xsl:variable name="propertyListCnt" select="count($propertyList)"/>

    <xsl:param name="SEPARATOR_FIELD" select="','"/>
    <xsl:param name="SEPARATOR_VALUE" select="';'"/>
    <xsl:param name="SEPARATOR_RECORD" select="'&#xa;'"/>

    <xsl:param name="language">
        <xsl:choose>
            <xsl:when test="contains($language-list,'eng')">
                <xsl:value-of select="$language-en"/>
            </xsl:when>
            <xsl:when test="string-length($language-list) > 0">
                <xsl:value-of select="$language-list"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>

    <xsl:variable name="QUOTE">"</xsl:variable>

    <xsl:variable name="BLANK_MSG" select="'*** row intentionally left blank ***'"/>
    <xsl:variable name="MONOGRAPH_MARKER" select="'://:MONOGRAPH://:'"/>

    <xsl:variable name="hebDir" select="concat($working-dir,'..',$FILE_SEPARATOR,'..',$FILE_SEPARATOR,'..',$FILE_SEPARATOR)"/>
    <xsl:variable name="csvPath" select="concat($hebDir,$FILE_SEPARATOR,$dc-identifier,'_metadata.csv')"/>

    <xsl:template match="/">

        <xsl:result-document href="{$csvPath}" method="text">
            <xsl:call-template name="insertHeaderRow"/>
            <xsl:call-template name="insertBlankRow"/>
            <xsl:call-template name="insertCoverRow"/>
            <xsl:call-template name="insertReviewsRow"/>
            <xsl:call-template name="insertRelatedRow"/>
            <xsl:call-template name="insertEpubRow"/>
            <xsl:call-template name="insertAssetRows"/>
            <xsl:call-template name="insertMonographRow"/>
        </xsl:result-document>

    </xsl:template>

    <xsl:template name="insertHeaderRow">
        <xsl:for-each select="$propertyList">
            <xsl:call-template name="insertField">
                <xsl:with-param name="value" select="."/>
                <xsl:with-param name="insertSeparator" select="$propertyListCnt > position()"/>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:call-template name="insertRecordSeparator"/>
    </xsl:template>

    <xsl:template name="insertBlankRow">
        <xsl:call-template name="insertRow">
            <xsl:with-param name="fileName" select="$BLANK_MSG"/>
            <xsl:with-param name="kind" select="''"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="insertCoverRow">
        <xsl:variable name="teiDoc" select="/"/>

        <xsl:variable name="coverRow"
                      select="$assetsTable/html:tr[html:td[@class='cover-image' and lower-case(string())='yes'] and html:td[@class='media' and lower-case(string())='yes']]"/>
        <xsl:if test="exists($coverRow)">
            <xsl:variable name="asset" select="."/>
            <xsl:variable name="assetName" select="$coverRow/html:td[@class='asset']"/>
            <xsl:variable name="assetType" select="$coverRow/html:td[@class='mime-type']"/>

            <xsl:for-each select="$propertyList">
                <xsl:variable name="property" select="."/>

                <xsl:variable name="propertyValue">
                    <xsl:choose>
                        <xsl:when test="$property='File Name'">
                            <xsl:value-of select="$assetName"/>
                        </xsl:when>
                        <xsl:when test="$property='Resource Type'">
                            <xsl:value-of select="'image'"/>
                        </xsl:when>
                        <xsl:when test="$property='Representative Kind'">
                            <xsl:value-of select="'cover'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="''"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:call-template name="insertField">
                    <xsl:with-param name="value" select="normalize-space($propertyValue)"/>
                    <xsl:with-param name="insertSeparator" select="$propertyListCnt > position()"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:call-template name="insertRecordSeparator"/>
        </xsl:if>

    </xsl:template>

    <xsl:template name="insertReviewsRow">
        <xsl:if test="count($dc-reviews-list) > 0">
            <xsl:call-template name="insertRow">
                <xsl:with-param name="fileName" select="$reviewsPath"/>
                <xsl:with-param name="kind" select="'reviews'"/>
            </xsl:call-template>

            <!-- Rakefile now handles this
            <xsl:variable name="path" select="concat($hebDir,'reviews.html')"/>
            <xsl:result-document href="{$path}" method="xml">
                <xsl:copy-of select="$reviewsDoc"/>
            </xsl:result-document>
            -->
        </xsl:if>
    </xsl:template>

    <xsl:template name="insertRelatedRow">
        <xsl:if test="count($dc-relatedtitles-list) > 0">
            <xsl:call-template name="insertRow">
                <xsl:with-param name="fileName" select="'related.html'"/>
                <xsl:with-param name="kind" select="'related'"/>
            </xsl:call-template>

            <!-- Rakefile now handles this
            <xsl:variable name="path" select="concat($hebDir,'related.html')"/>
            <xsl:result-document href="{$path}" method="xml">
                <xsl:copy-of select="$relatedDoc"/>
            </xsl:result-document>
            -->
        </xsl:if>
    </xsl:template>

    <xsl:template name="insertEpubRow">
        <xsl:for-each select="$propertyList">
            <xsl:variable name="propertyValue">
                <xsl:choose>
                    <xsl:when test=". = 'File Name'">
                        <xsl:value-of select="concat($dc-identifier,'.epub')"/>
                    </xsl:when>
                    <xsl:when test=". = 'Allow Download?'">
                        <xsl:value-of select="'no'"/>
                    </xsl:when>
                    <xsl:when test=". ='Representative Kind'">
                        <xsl:value-of select="'epub'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="''"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:call-template name="insertField">
                <xsl:with-param name="value" select="$propertyValue"/>
                <xsl:with-param name="insertSeparator" select="$propertyListCnt > position()"/>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:call-template name="insertRecordSeparator"/>
    </xsl:template>

    <xsl:template name="insertAssetRows">
        <xsl:variable name="teiDoc" select="/"/>

        <xsl:variable name="assetList" select="$assetsTable/html:tr[html:td[@class='cover-image' and lower-case(string())='no'] and html:td[@class='media' and lower-case(string())='yes']]"/>
        <xsl:for-each select="$assetList">
            <xsl:variable name="asset" select="."/>
            <xsl:variable name="assetName" select="$asset/html:td[@class='asset']"/>
            <xsl:variable name="assetType" select="$asset/html:td[@class='mime-type']"/>
            <xsl:variable name="assetIncluded" select="$asset/html:td[@class='inclusion']"/>

            <xsl:variable name="ref1" as="element()*">
                <xsl:choose>
                    <xsl:when test="substring-before($assetType,'/')='image' and ($assetIncluded='no' or exists($teiDoc//*[local-name()='figure' and starts-with($assetName, @dlxs:entity)]))">
                        <xsl:sequence select="$teiDoc//*[local-name()='figure' and starts-with($assetName, @dlxs:entity)]"/>
                    </xsl:when>
                    <xsl:when test="$assetIncluded='no' and exists($teiDoc//*[local-name()='ref' and @source=$assetName])">
                        <xsl:sequence select="$teiDoc//*[local-name()='ref' and @source=$assetName]"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="ref" as="element()*">
                <xsl:choose>
                    <xsl:when test="count($ref1) > 1">
                        <xsl:sequence select="$ref1[1]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="$ref1"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:for-each select="$propertyList">
                <xsl:variable name="property" select="."/>

                <xsl:variable name="propertyValue">
                    <xsl:choose>
                        <xsl:when test="$property='File Name'">
                            <xsl:value-of select="$assetName"/>
                        </xsl:when>
                        <xsl:when test="$property='Resource Type'">
                            <xsl:choose>
                                <xsl:when test="substring-before($assetType,'/')='application'">
                                    <xsl:value-of select="'text'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="substring-before($assetType,'/')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <!--
                        <xsl:when test="$property='Copyright Holder' or $property='Creator(s)'">
                            <xsl:value-of select="string-join($dc-copyholder-list,$SEPARATOR_VALUE)"/>
                        </xsl:when>
                        <xsl:when test="$property='Holding Contact'">
                            <xsl:value-of select="string-join($dc-holdercontact-list,$SEPARATOR_VALUE)"/>
                        </xsl:when>
                        -->
                        <xsl:when test="$property='Creator(s)'">
                            <xsl:value-of select="string-join($dc-copyholder-list,$SEPARATOR_VALUE)"/>
                        </xsl:when>
                        <xsl:when test="$property='Allow High-Res Display?'">
                            <xsl:value-of select="'no'"/>
                        </xsl:when>
                        <xsl:when test="$property='Allow Download?'">
                            <xsl:value-of select="'no'"/>
                        </xsl:when>
                        <xsl:when test="$property='Copyright Status'">
                            <xsl:value-of select="'in-copyright'"/>
                        </xsl:when>
                        <xsl:when test="$property='Exclusive to Fulcrum'">
                            <xsl:value-of select="'no'"/>
                        </xsl:when>
                        <xsl:when test="exists($ref)">
                            <xsl:choose>
                                <xsl:when test="$property='Title'">
                                    <xsl:choose>
                                        <xsl:when test="local-name($ref)='figure' and count($ref/tei:head) > 2">
                                            <xsl:value-of select="$ref/tei:head[position() > 1 and position() &lt; last()]"/>
                                        </xsl:when>
                                        <xsl:when test="local-name($ref)='figure' and count($ref/tei:head) > 0">
                                            <xsl:value-of select="$ref/tei:head[last()]"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$ref"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:when test="$property='Caption'">
                                    <xsl:choose>
                                        <xsl:when test="local-name($ref)='figure' and count($ref/tei:head) > 2">
                                            <xsl:value-of select="$ref/tei:head[position() &lt; last()]"/>
                                        </xsl:when>
                                        <xsl:when test="local-name($ref)='figure' and count($ref/tei:head) > 0">
                                            <xsl:value-of select="$ref/tei:head"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$ref"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:when test="$property='Alternative Text'">
                                    <xsl:choose>
                                        <xsl:when test="local-name($ref)='figure' and count($ref/tei:head) > 1">
                                            <xsl:value-of select="$ref/tei:head[last()]"/>
                                        </xsl:when>
                                        <xsl:when test="local-name($ref)='figure' and exists($ref/tei:head)">
                                            <xsl:value-of select="$ref/*[local-name()='head']"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$ref"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="''"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="''"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:call-template name="insertField">
                    <xsl:with-param name="value" select="normalize-space($propertyValue)"/>
                    <xsl:with-param name="insertSeparator" select="$propertyListCnt > position()"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:call-template name="insertRecordSeparator"/>
        </xsl:for-each>

    </xsl:template>

    <xsl:template name="insertMonographRow">
        <xsl:for-each select="$propertyList">
            <xsl:variable name="propertyValue">
                <xsl:choose>
                    <xsl:when test=". = 'File Name'">
                        <xsl:value-of select="$MONOGRAPH_MARKER"/>
                    </xsl:when>
                    <xsl:when test=". = 'Identifier(s)' or . = 'Legacy ID'">
                        <xsl:value-of select="$dc-identifier"/>
                    </xsl:when>
                    <xsl:when test=". = 'Title'">
                        <xsl:value-of select="string-join($dc-title-list,$SEPARATOR_VALUE)"/>
                    </xsl:when>
                    <xsl:when test=". = 'Copyright Holder'">
                        <xsl:value-of select="string-join($dc-copyholder-list,$SEPARATOR_VALUE)"/>
                    </xsl:when>
                    <xsl:when test=". = 'Holding Contact'">
                        <xsl:value-of select="string-join($dc-holdercontact-list,$SEPARATOR_VALUE)"/>
                    </xsl:when>
                    <xsl:when test=". = 'Persistent ID - Display on Platform'">
                        <xsl:value-of select="string-join($dc-source-list,$SEPARATOR_VALUE)"/>
                    </xsl:when>
                    <xsl:when test=". = 'Creator(s)'">
                        <xsl:value-of select="mlibxsl:strip_punctuation(string-join($dc-creator-list,$SEPARATOR_VALUE))"/>
                    </xsl:when>
                    <xsl:when test=". = 'Additional Creator(s)'">
                        <xsl:value-of select="mlibxsl:strip_punctuation(string-join($dc-contributor-list,$SEPARATOR_VALUE))"/>
                    </xsl:when>
                    <xsl:when test=". = 'Series'">
                        <xsl:value-of select="string-join($dc-series-list,$SEPARATOR_VALUE)"/>
                    </xsl:when>
                    <xsl:when test=". = 'Description'">
                        <xsl:value-of select="$dc-description"/>
                    </xsl:when>
                    <xsl:when test=". = 'Section'">
                        <xsl:value-of select="$MONOGRAPH_MARKER"/>
                    </xsl:when>
                    <xsl:when test=". = 'Section'">
                        <xsl:value-of select="$MONOGRAPH_MARKER"/>
                    </xsl:when>
                    <xsl:when test=". = 'Language'">
                        <xsl:choose>
                            <xsl:when test="string-length($language) > 0">
                                <xsl:value-of select="$language"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="''"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test=". = 'Publisher'">
                        <xsl:value-of select="mlibxsl:strip_punctuation(string-join($dc-publisher-list,$SEPARATOR_VALUE))"/>
                    </xsl:when>
                    <xsl:when test=". = 'Subject'">
                        <xsl:value-of select="string-join($dc-subject-list,$SEPARATOR_VALUE)"/>
                    </xsl:when>
                    <xsl:when test=". = 'ISBN(s)'">
                        <xsl:value-of select="string-join($dc-isbn-list,$SEPARATOR_VALUE)"/>
                    </xsl:when>
                    <xsl:when test=". = 'Pub Year'">
                        <xsl:value-of select="mlibxsl:strip_punctuation(string-join($dc-date-list,$SEPARATOR_VALUE))"/>
                    </xsl:when>
                    <xsl:when test=". = 'Pub Location'">
                        <xsl:value-of select="mlibxsl:strip_punctuation(string-join($dcterms-Location-list,$SEPARATOR_VALUE))"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="''"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:call-template name="insertField">
                <xsl:with-param name="value" select="$propertyValue"/>
                <xsl:with-param name="insertSeparator" select="$propertyListCnt > position()"/>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:call-template name="insertRecordSeparator"/>
    </xsl:template>

    <xsl:template name="insertRow">
        <xsl:param name="fileName"/>
        <xsl:param name="kind"/>

        <xsl:for-each select="$propertyList">
            <xsl:variable name="propertyValue">
                <xsl:choose>
                    <xsl:when test=". = 'File Name'">
                        <xsl:value-of select="$fileName"/>
                    </xsl:when>
                    <xsl:when test=". = 'Representative Kind'">
                        <xsl:value-of select="$kind"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="''"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:call-template name="insertField">
                <xsl:with-param name="value" select="$propertyValue"/>
                <xsl:with-param name="insertSeparator" select="$propertyListCnt > position()"/>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:call-template name="insertRecordSeparator"/>
    </xsl:template>

    <xsl:template name="insertField">
        <xsl:param name="value" select="''"/>
        <xsl:param name="insertSeparator" select="true()" as="xs:boolean"/>

        <xsl:choose>
            <xsl:when test="string-length($value) > 0">
                <xsl:text>&quot;</xsl:text>
                <!--
                <xsl:value-of select="$value"/>
                -->
                <xsl:value-of select="replace($value,$QUOTE,concat($QUOTE,$QUOTE))"/>
                <xsl:text>&quot;</xsl:text>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>

        <xsl:if test="$insertSeparator = true()">
            <xsl:call-template name="insertFieldSeparator"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="insertFieldSeparator">
        <xsl:value-of select="$SEPARATOR_FIELD"/>
    </xsl:template>

    <xsl:template name="insertRecordSeparator">
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

</xsl:stylesheet>