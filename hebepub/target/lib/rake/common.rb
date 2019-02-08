# This file processes the parameters and
# set the paths to files needed to generate
# the epub.

# Process parameters passed as environment variables.
#   HEBDIR            HEB book source directory

HEBDIR=ENV['HEBDIR']

# Determine the HEB ID. Assumes that
# the last component of the HEB directory
# is the ID.
HEBID=File.basename(HEBDIR)
HEBPRFX=HEBID[0..7]
OS=ENV['OS']

# Determine process paths relative to this file.
RAKEPATH="#{__FILE__}"
TARGETRB=File.dirname(RAKEPATH)
TARGETLIB=File.dirname(TARGETRB)
TARGETDIR=File.dirname(TARGETLIB)
TARGETBIN=File.join(TARGETDIR, "bin")
ROOTDIR=File.dirname(TARGETDIR)

# For fixepub, determine the source tif/png
# images directories for this book
SRCTIFSCANDIR=File.join(ROOTDIR, "fixepub", "dlxs", "tif", HEBID)
SRCPNGSCANDIR=File.join(ROOTDIR, "fixepub", "dlxs", "png", HEBID)

SRCFIXEPUBDIR=File.join(ROOTDIR, "fixepub", "fixed_layout_epub", "epub", HEBID)
SRCFIXEPUBDLXS=File.join(SRCFIXEPUBDIR, "#{HEBID}_dlxs.xml")
SRCFIXEPUBDLXSORG=File.join(SRCFIXEPUBDIR, "#{HEBID}_dlxs_org.xml")
SRCFIXEPUBIMGS=File.join(SRCFIXEPUBDIR, HEBID, "OEBPS", "images")

# Determine where the source DLXS XML file resides, thus
# determining the book layout.
layout="flowepub"
srcdlxspath=File.join(ROOTDIR, layout, "dlxs", "#{HEBID}.xml")
if (!File.exists?(srcdlxspath))
    layout="fixepub"
    srcdlxspath=SRCFIXEPUBDLXS
    if (!File.exists?(srcdlxspath))
        abort("Error: unknown HEB ID #{HEBID}")
    end
end
LAYOUT=layout
TARGETLAYOUTROOT=File.join(TARGETDIR, LAYOUT)
SRCDLXSPATH=srcdlxspath
ORGSRCDLXSPATH=File.join(File.dirname(srcdlxspath),"#{HEBID}_dlxs_org.xml")

# Set paths for the XSLT, image utilities, and epubcheck jars
XSLTJAR=File.join(TARGETLIB, "jars", "hebxslt-jar-with-dependencies.jar")
IMGJAR=File.join(TARGETLIB, "jars", "hebimg-jar-with-dependencies.jar")
IMGJP2JAR=File.join(TARGETLIB, "jars", "hebimgjp2-jar-with-dependencies.jar")
CHECKJAR=File.join(TARGETLIB, "jars", "epubcheck-jar-with-dependencies.jar")

# Set the paths for the process XSLT files.
# DLXS => TEI
# TEI => CSV
# TEI => {fixepub,flowepub}
TEIXSLPATH=File.join(TARGETLIB, "xsl", "hebdlxs2tei.xsl")
METAXSLPATH=File.join(TARGETLIB, "xsl", "hebtei2meta.xsl")
LAYOUTXSLPATH=File.join(TARGETLIB, "xsl", "hebtei2#{LAYOUT}.xsl")

# Set path for layout specific paths
LAYOUTROOT=File.join(ROOTDIR, LAYOUT)

# Set root path for resources (acls, marc, etc.)
RESOURCESDIR=File.join(ROOTDIR, "resources")

# Set the path for all book assets, containing
# pdfs, audio, book cover images, etc.
SRCASSETSDIR=File.join(RESOURCESDIR, "assets")
asset_list_file=File.join(HEBDIR, "asset_list.txt")
asset_list=Array.new
if File.exist?(asset_list_file)
    File.readlines(asset_list_file).each { |line| asset_list.push(line.chomp) }
else
    asset_list = Dir.glob(File.join(SRCASSETSDIR, "#{HEBPRFX}*"))
end
SRCASSETLIST=asset_list

# Set the path to the directory containing
# the source MARC records.
SRCMARCPATH=File.join(RESOURCESDIR, "marc", "#{HEBPRFX}.xml")

# Set the paths to the bundle CSV file,
# the book epub file, and the bundle zip file.
CSVPATH=File.join(HEBDIR, "#{HEBID}_metadata.csv")
EPUBPATH=File.join(HEBDIR, "#{HEBID}.epub")
BUNDLEPATH=File.join(HEBDIR, "#{HEBID}.zip")

# Set the paths the media assets and epub directories.
EPUBDIR=File.join(HEBDIR, "epub")

MIMETYPE=File.join(EPUBDIR, "mimetype")
EPUBSRC=MIMETYPE

# Set the paths for epub source files.
METAINFDIR=File.join(EPUBDIR, "META-INF")
METAINFSRCDIR=File.join(METAINFDIR, "src")
DLXSPATH=File.join(METAINFSRCDIR, "#{HEBID}_dlxs.xml")
TEIPATH=File.join(METAINFSRCDIR, "#{HEBID}_tei.xml")
CPHOLDERPATH=File.join(METAINFSRCDIR, "copyholder.html")
#RELATEDPATH=File.join(METAINFSRCDIR, "related_title.html")
RELATEDPATH=File.join(METAINFSRCDIR, "related.html")
REVIEWSPATH=File.join(METAINFSRCDIR, "reviews.html")
SERIESPATH=File.join(METAINFSRCDIR, "series.html")
SUBJECTPATH=File.join(METAINFSRCDIR, "subject.html")
MARCPATH=File.join(METAINFSRCDIR, "marc.xml")
STYLESPATH=File.join(METAINFSRCDIR, "stylesheets.html")
FONTSPATH=File.join(METAINFSRCDIR, "fonts.html")
ASSETSPATH=File.join(METAINFSRCDIR, "assets.html")
IMAGESPATH=File.join(METAINFSRCDIR, "images.html")

OEBPSDIR=File.join(EPUBDIR, "OEBPS")
IMAGESDIR=File.join(OEBPSDIR, "images")
XHTMLDIR=File.join(OEBPSDIR, "xhtml")

# Markup format strings used for generating HTML tables
MARKUP_TBL = <<-MTBL
<?xml version="1.0" encoding="UTF-8"?>
<table xmlns="http://www.w3.org/1999/xhtml" id="%s" title="%s">
<thead><tr>%s</tr></thead>
<tbody>%s</tbody>
</table>
MTBL

MARKUP_TBL_EMPTY = <<-MTBLE
<?xml version="1.0" encoding="UTF-8"?>
<table xmlns="http://www.w3.org/1999/xhtml" id="%s" title="%s" role="empty">
<caption>%s</caption>
<tbody><tr><td/></tr></tbody>
</table>
MTBLE

directory HEBDIR
directory METAINFSRCDIR

