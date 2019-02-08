<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xi="http://www.w3.org/2001/XInclude"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:html="http://www.w3.org/1999/xhtml"
                xmlns:dlxs="http://mlib.umich.edu/namespace/dlxs"
                exclude-result-prefixes="xs xi tei html dlxs marc"
                version="2.0">

    <xsl:import href="heblib.xsl"/>

    <xsl:variable name="teiHeaderNode" select="/tei:TEI/tei:teiHeader"/>
    <xsl:variable name="teiFileDescNode" select="$teiHeaderNode/tei:fileDesc"/>
    <!--
    <xsl:param name="identifier" select="$teiFileDescNode/tei:publicationStmt/tei:idno[@type='heb'][1]"/>
    -->

    <xsl:variable name="marcDoc"
                  select="document($teiHeaderNode/tei:xenoData[@type='marcxml']/xi:include/@href)"/>

    <xsl:variable name="assetsPath" select="$teiHeaderNode/tei:xenoData[@type='assets']/xi:include/@href"/>
    <xsl:variable name="assetsDoc" select="document($assetsPath)"/>
    <xsl:variable name="assetsTable" select="$assetsDoc/html:table/html:tbody"/>

    <xsl:variable name="fontsPath" select="$teiHeaderNode/tei:xenoData[@type='fonts']/xi:include/@href"/>
    <xsl:variable name="fontsDoc" select="document($fontsPath)"/>
    <xsl:variable name="fontsTable" select="$fontsDoc/html:table/html:tbody"/>
    <xsl:variable name="fontsList" select="$fontsTable/html:tr"/>

    <xsl:variable name="stylesPath" select="$teiHeaderNode/tei:xenoData[@type='stylesheets']/xi:include/@href"/>
    <xsl:variable name="stylesDoc" select="document($stylesPath)"/>
    <xsl:variable name="stylesTable" select="$stylesDoc/html:table/html:tbody"/>
    <xsl:variable name="stylesList" select="$stylesTable/html:tr"/>

    <!--
    <xsl:variable name="linksPath" select="$teiHeaderNode/tei:xenoData[@type='links']/xi:include/@href"/>
    <xsl:variable name="linksDoc" select="document($linksPath)"/>
    <xsl:variable name="linksTable" select="$linksDoc/html:table/html:tbody"/>
    -->

    <xsl:variable name="imagesPath" select="$teiHeaderNode/tei:xenoData[@type='images']/xi:include/@href"/>
    <xsl:variable name="imagesDoc" select="document($imagesPath)"/>
    <xsl:variable name="imagesTable" select="$imagesDoc/html:table/html:tbody"/>

    <xsl:variable name="copyholderPath"
                  select="$teiHeaderNode/tei:xenoData[@type='copyholder']/xi:include/@href"/>
    <xsl:variable name="copyholderDoc" select="document($copyholderPath)"/>
    <xsl:variable name="copyholderList"
                  select="$copyholderDoc//*[local-name()='table']//*[local-name()='td'][@class='copyholder']"/>
    <xsl:variable name="copyholderRowList"
                  select="$copyholderDoc/*[local-name()='table']/*[local-name()='tbody']/*[local-name()='tr']"/>

    <xsl:variable name="relatedPath" select="$teiHeaderNode/tei:xenoData[@type='related_title']/xi:include/@href"/>
    <xsl:variable name="relatedDoc" select="document($relatedPath)"/>

    <xsl:variable name="reviewsPath" select="$teiHeaderNode/tei:xenoData[@type='reviews']/xi:include/@href"/>
    <xsl:variable name="reviewsDoc" select="document($reviewsPath)"/>

    <xsl:variable name="seriesPath" select="$teiHeaderNode/tei:xenoData[@type='series']/xi:include/@href"/>
    <xsl:variable name="seriesDoc" select="document($seriesPath)"/>

    <xsl:variable name="subjectPath" select="$teiHeaderNode/tei:xenoData[@type='subject']/xi:include/@href"/>
    <xsl:variable name="subjectDoc" select="document($subjectPath)"/>

    <xsl:variable name="cImageRows"
                  select="$assetsDoc/html:table/html:tbody/html:tr[html:td[@class='cover-image' and lower-case(string())='yes']]"/>
    <xsl:variable name="coverImageRow" as="element()*">
        <xsl:choose>
            <xsl:when test="exists($cImageRows/html:td[@class='hi-res' and lower-case(string())='yes'])">
                <xsl:sequence select="$cImageRows[html:td[@class='hi-res' and lower-case(string())='yes']]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$cImageRows[1]"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="otherCoverRows" as="element()*">
        <xsl:choose>
            <xsl:when test="exists($cImageRows/html:td[@class='hi-res' and lower-case(string())='yes'])">
                <xsl:sequence select="$cImageRows[html:td[@class='hi-res' and lower-case(string())='no']]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$cImageRows[position() > 1]"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="language-list"
                  select="lower-case(normalize-space(string-join($marcDoc//*[local-name()='datafield'][@tag='041']/*[local-name()='subfield'][@code='a'],'')))"/>
    <xsl:param name="dc-language">
        <xsl:choose>
            <xsl:when test="string-length($language-list) = 0 or contains($language-list,'eng')">
                <xsl:value-of select="$language-en"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$language-list"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>

    <xsl:variable name="dc-identifier-list" select="$teiFileDescNode/tei:publicationStmt/tei:idno[@type='heb']"/>
    <xsl:variable name="dc-identifier" select="$teiFileDescNode/tei:publicationStmt/tei:idno[@type='heb'][1]"/>

    <xsl:variable name="dc-description">
        <xsl:choose>
            <xsl:when test="exists($marcDoc//*[local-name()='datafield'][@tag='520']/*[local-name()='subfield'][@code='a'])">
                <xsl:value-of select="$marcDoc//*[local-name()='datafield'][@tag='520']/*[local-name()='subfield'][@code='a']"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:param name="dcterms-modified"
               select="format-dateTime(current-dateTime(), '[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01]Z')"/>
    <xsl:variable name="dc-title-list"
                  select="$teiFileDescNode/tei:titleStmt/tei:title[@type='245']"/>
    <xsl:variable name="dc-creator-list"
                  select="$teiFileDescNode/tei:titleStmt/tei:author[not(exists(@dlxs:type))]"/>
    <xsl:variable name="dc-contributor-list"
                  select="$teiFileDescNode/tei:titleStmt/tei:author[@dlxs:type='alt']"/>
    <xsl:variable name="dc-publisher-list"
                  select="$teiFileDescNode/tei:sourceDesc/tei:biblFull/tei:publicationStmt/tei:publisher"/>
    <xsl:variable name="dcterms-Location-list"
                  select="$teiFileDescNode/tei:sourceDesc/tei:biblFull/tei:publicationStmt/tei:pubPlace"/>
    <xsl:variable name="dc-source-list"
                  select="$teiFileDescNode/tei:sourceDesc/tei:biblFull/tei:notesStmt/tei:note[@type='url']"/>
    <xsl:variable name="dc-rights-list"
                  select="$teiFileDescNode/tei:publicationStmt/tei:availability/tei:p"/>
    <xsl:variable name="dc-subject-list"
                  select="$subjectDoc/html:table/html:tbody/html:tr/html:td[@class='subject']"/>
    <xsl:variable name="dc-date-list"
                  select="$teiFileDescNode/tei:sourceDesc/tei:biblFull/tei:publicationStmt/tei:date"/>
    <xsl:variable name="dc-isbn-list">
        <xsl:choose>
            <xsl:when test="exists($marcDoc/marc:record/marc:datafield[@tag='020'])">
                <xsl:value-of select="$marcDoc/marc:record/marc:datafield[@tag='020']"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$teiFileDescNode/tei:sourceDesc/tei:biblFull/tei:notesStmt/tei:note[@type='isbn']"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="dc-copyholder-list"
                  select="$copyholderDoc/html:table/html:tbody/html:tr/html:td[@class='copyholder']"/>
    <xsl:variable name="dc-holdercontact-list"
                  select="$copyholderDoc/html:table/html:tbody/html:tr/html:td[@class='puburl']"/>

    <xsl:variable name="dc-relatedtitles-list"
                  select="$relatedDoc/html:table/html:tbody/html:tr/html:td[@class='related_title']"/>
    <xsl:variable name="dc-reviews-list"
                  select="$reviewsDoc/html:table/html:tbody/html:tr/html:td[@class='journal_abbrev']"/>
    <xsl:variable name="dc-series-list"
                  select="$seriesDoc/html:table/html:tbody/html:tr/html:td[@class='series']"/>

    <xsl:template name="insertStyles">
        <xsl:for-each select="$stylesList">
            <xsl:element name="link" namespace="{$HTML_URL}">
                <xsl:attribute name="href" select="concat('..',$FILE_SEPARATOR,'styles',$FILE_SEPARATOR,.)"/>
                <xsl:attribute name="rel" select="'stylesheet'"/>
                <xsl:attribute name="type" select="'text/css'"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>