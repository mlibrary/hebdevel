<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:mlibxsl="http://www.mlib.umich.edu/namespace/mlibxsl"
                exclude-result-prefixes="xs mlibxsl"
                version="2.0">

    <xsl:param name="working-dir" required="yes"/>

    <xsl:variable name="FILE_SEPARATOR" select="'/'"/>

    <xsl:variable name="IDPF_URL" select="'http://www.idpf.org/2007/opf'"/>
    <xsl:variable name="IDPF_RENDITION_URL" select="'http://www.idpf.org/2013/rendition'"/>
    <xsl:variable name="IDPF_METADATA_URL" select="'http://www.idpf.org/2013/metadata'"/>
    <xsl:variable name="PURL_DC_URL" select="'http://purl.org/dc/elements/1.1/'"/>
    <xsl:variable name="PURL_DCTERMS_URL" select="'http://purl.org/dc/terms'"/>

    <xsl:variable name="HTML_URL" select="'http://www.w3.org/1999/xhtml'"/>
    <xsl:variable name="OPS_URL" select="'http://www.idpf.org/2007/ops'"/>
    <xsl:variable name="OCF_URI" select="'urn:oasis:names:tc:opendocument:xmlns:container'"/>

    <xsl:variable name="DLXS_URL" select="'http://mlib.umich.edu/namespace/dlxs'"/>
    <xsl:variable name="TEI_URL" select="'http://www.tei-c.org/ns/1.0'"/>
    <xsl:variable name="XI_URL" select="'http://www.w3.org/2001/XInclude'"/>

    <xsl:variable name="language-en" select="'en-US'"/>

    <xsl:param name="toc-title" select="'Table of Contents'"/>
    <xsl:param name="pagelist-title" select="'List of Pages'"/>
    <xsl:param name="chapterlist-title" select="'List of Chapters'"/>

    <xsl:param name="CONTENT_FOLDER" select="'OEBPS'"/>

    <xsl:variable name="epubRootDir" select="concat($working-dir,'../../../epub',$FILE_SEPARATOR)"/>
    <xsl:variable name="epubMetaDir" select="concat($epubRootDir,'META-INF',$FILE_SEPARATOR)"/>
    <xsl:variable name="epubContentDir" select="concat($epubRootDir,$CONTENT_FOLDER,$FILE_SEPARATOR)"/>
    <xsl:variable name="epubXHTMLDir" select="concat($epubContentDir,'xhtml',$FILE_SEPARATOR)"/>

    <xsl:function name="mlibxsl:strip_punctuation" as="xs:string">
        <xsl:param name="src" as="xs:string*"/>

        <xsl:sequence select="replace($src,'[\.,;:]+$','')"/>
    </xsl:function>

</xsl:stylesheet>