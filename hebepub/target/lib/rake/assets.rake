# This file generates the ASSETSPATH (assets.html) file.
#
# The input is the list of all assets (images, audio, video, pdfs, etc.)
# for this book and store information concerning these assets in an
# HTML table. This information is used when generating the EPUB archive
# and the Fulcrum bundle.
#
# This table has the following columns:
#   asset           Asset base name, e.g. hebxxxxx.001.pdf
#   assetpath       Absolute path to the asset.
#   mime-type       Asset mime type.
#   media           yes/no indicates whether an external asset.
#   inclusion       yes/no indicates whether asset should be
#                   included in the EPUB archive.
#   cover-image     Indicates whether asset is a cover image.
#   hi-res          yes/no indicates whether an image is hi-res.
#                   Determined if the image basensame has a -lg suffix.
#   width           If asset is an image, then its width, otherwise 0.
#   height          If asset is an image, then its height, otherwise 0.
#   title           If asset currently exists on Fulcrum, then its
#                   title metadata.
#   noid            If asset currently exists on Fulcrum, then its noid.
#   link            If asset currently exists on Fulcrum, then its link.
#   embed-markup    If asset currently exists on Fulcrum, then the
#                   markup necessary to embed this asset within the epub.
require 'csv'
require 'htmlentities'
require 'image_size'

require_relative "common.rb"

namespace :assets do

    # Assets table markup
    MARKUP_HEADER_ASSETS = <<-MHA
    <th class="asset">Asset</th>
    <th class="assetpath">Path</th>
    <th class="mime-type">Mime Type</th>
    <th class="media">Media</th>
    <th class="inclusion">Inclusion</th>
    <th class="cover-image">Cover Image</th>
    <th class="hi-res">Hi-Res</th>
    <th class="width">Width</th>
    <th class="height">Height</th>
    <th class="title">Title</th>
    <th class="noid">NOID</th>
    <th class="link">Link</th>
    <th class="embed-markup">Embedded Markup</th>
    MHA

    MARKUP_ROW_ASSETS = <<-MRA
    <tr>
    <td class="asset">%s</td>
    <td class="assetpath">%s</td>
    <td class="mime-type">%s</td>
    <td class="media">%s</td>
    <td class="inclusion">%s</td>
    <td class="cover-image">%s</td>
    <td class="hi-res">%s</td>
    <td class="width">%s</td>
    <td class="height">%s</td>
    <td class="title">%s</td>
    <td class="noid">%s</td>
    <td class="link">%s</td>
    <td class="embed-markup">%s</td>
    </tr>
    MRA

    MARKUP_EMBED_MEDIA = <<-MRA
    <iframe src="https://www.fulcrum.org/embed?hdl=2027%%2Ffulcrum.%s"
	    title="%s"
	    style="display:block; overflow:hidden; border-width:0; width:98%%; max-width:98%%; max-height:400px; margin:auto">
    </iframe>
    MRA

    MARKUP_EMBED_IMAGE = <<-MRA
    <div style="width:auto; page-break-inside:avoid; -webkit-column-break-inside:avoid; break-inside:avoid; max-width:650px; margin:auto">
    <div style="overflow:hidden; padding-bottom:60%%; position:relative; height:0;">
    <iframe src="https://www.fulcrum.org/embed?hdl=2027%%2Ffulcrum.%s"
        title="%s"
        style="overflow:hidden; border-width:0; left:0; top:0; width:100%%; height:100%%; position:absolute;">
    </iframe>
    </div>
    </div>
    MRA

    SRCLINKSCSV=File.join(RESOURCESDIR, "asset_links", "#{HEBID}.csv" )

    task :default => [ :files ]

    task :files => [ ASSETSPATH ]

    file ASSETSPATH => [ METAINFSRCDIR ] do

        media_assets = Hash.new
        coder = HTMLEntities.new
        if File.exists?(SRCLINKSCSV)
            # A source CSV file exists.
            print "Manifest #{SRCLINKSCSV} exists.\n"
            CSV.foreach(SRCLINKSCSV, :headers => true, :converters => :all, :header_converters => lambda { |h| h.downcase.gsub(' ', '_') }) do |row|
                asset = row['file_name']
                title = coder.encode(row['title'])
                noid = row['noid']
                olink = row['link']
                link =  olink.match('^[^\(]+\(\"([^\"]+)\".*') {|m| m[1] }
                #embed_markup = row['embed_markup']
                embed_markup = ""
                media_assets[asset] = Media.new(asset, title, noid, link, embed_markup)
            end
        else
            # Generate the empty html table for this file.
            print "Warning: #{SRCLINKSCSV} doesn't exist. Template created.\n"
        end

        assets = Hash.new
        hires = Hash.new
        nonimage = Hash.new

        # Traverse the list of media assets and determine
        # its mime type. If the media is an image, then determine
        # if it is hi-res by looking for the "-lg" suffix
        # on the file name.
        SRCASSETLIST.each do |f|
            f_basename = File.basename(f)
            f_noext = File.basename(f_basename, File.extname(f_basename))

            IO.popen(["file", "--mime-type", "--brief", "#{f}"]) { |io|
                m_type = io.read.chomp
                f_type = m_type.split("/").at(0)
                hres = false
                width = 0
                height = 0
                if f_type == "image"
                    if f_noext.end_with?("-lg")
                        hres = true
                        hires[f] = true
                    end
                    image_size = ImageSize.path(f)
                    width = image_size.width
                    height = image_size.height
                else
                    nonimage[f_noext] = f_type
                end
                assets[f] = Asset.new(f, m_type, f_type, hres, width, height)
            }
        end

        # Traverse the list again and determine if the asset
        # should be included in the EPUB archive and whether it
        # should be uploaded as an external asset.
        rows = ""
        SRCASSETLIST.each do |f|
            asset = assets[f]
            f_basename = asset.getBasePath
            f_ext = File.extname(f_basename)
            f_noext = File.basename(f_basename, f_ext)

            m_type = asset.getMimeType
            f_type = asset.getAssetType
            is_hires = asset.getHiRes
            width = asset.getWidth
            height = asset.getHeight

            # Assumne the asset is not a cover
            # image and will be uploaded to
            # Fulcrum as an media asset and
            # will not be included in
            # the EPUB archive.
            media = "yes"
            inclusion = "no"
            cover = "no"
            hres = is_hires ? "yes" : "no"

            title = ""
            link = ""
            markup = ""
            m_asset = nil
            if media_assets.has_key?(f_basename)
                m_asset = media_assets[f_basename]
                title = m_asset.getTitle
                noid = m_asset.getNoid
                link = m_asset.getLink
                #markup = m_asset.getMarkup

                case f_type
                when "image", "video"
                    markup = coder.encode(sprintf(MARKUP_EMBED_IMAGE, noid, title))
                else
                    markup = coder.encode(sprintf(MARKUP_EMBED_MEDIA, noid, title))
                end
            end

            if f_type == "image"
                if f_basename.start_with?(HEBID)
                    # Asset file name contains the
                    # HEBID, so assume it is a cover.
                    cover = "yes"
                end

                if !is_hires and m_asset == nil
                    #if nonimage.has_key?(f_noext) or hires.has_key?(File.join(File.dirname(f), "#{f_noext}-lg#{f_ext}"))
                    if nonimage.has_key?(f_noext) or hires.has_key?(File.join(File.dirname(f), "#{f_noext}-lg#{f_ext}")) or hires.has_key?(File.join(File.dirname(f), "#{f_noext}-lg.png"))
                    #if nonimage.has_key?(f_noext) or hires.has_key?(File.join(File.dirname(f), "#{f_noext}-lg.png"))
                        # Either a non-image asset exists with
                        # the same base name as this image or
                        # this file is a lo-res cover image
                        # and a hi-res cover image exists.
                        # Do not upload this to Fulcrum as
                        # a media asset.
                        media = "no"
                    end
                end

                if cover == "yes" or hres == "no"
                    # Asset is a cover image and not hi-res.
                    # Include it in the EPUB archive.
                    inclusion = "yes"
                end
            end
            rows += sprintf(MARKUP_ROW_ASSETS, f_basename, f, m_type, media,
                        inclusion, cover, hres, width, height, title, noid, link, markup)

            if inclusion == "yes"
                # Asset is to be included in the
                # EPUB archive. Asset will be copied
                # to the epub images directory.
                # Only images are included
                # in the EPUB archive.
                print "Asset \"#{f_basename}\" included in epub\n"
            end
            if media == "yes"
                # Asset is to uploaded to Fulcrum as a
                # media asset. Asset will be copied to
                # the media directory so it is included
                # in the uploaded bundle.
                # NOTE: hi-res images are uploaded as an
                # asset and included in the EPUB archive.
                print "Asset \"#{f_basename}\" to be uploaded as media asset\n"
            end
        end

        # Generate the assets.html HTML file that contains a
        # table listing the EPUB assets.
        File.open(ASSETSPATH, "w") { |f| f.write(sprintf(MARKUP_TBL, "#{HEBID}_assets", HEBID, MARKUP_HEADER_ASSETS, rows)) }
    end

    class Asset
        def initialize(p, m, a, hres, w, h)
            @path = p
            @base_path = File.basename(p)
            @mimetype = m
            @assettype = a
            @hires = hres
            @width = w
            @height = h
        end

        def getPath
            @path
        end

        def getBasePath
            @base_path
        end

        def getMimeType
            @mimetype
        end

        def getAssetType
            @assettype
        end

        def getHiRes
            @hires
        end

        def getWidth
            @width
        end

        def getHeight
            @height
        end
    end

    class Media
        def initialize(n, t, d, l, m)
            @name = n
            @title = t
            @noid = d
            @link = l
            @embed_markup = m
        end

        def getName
            @name
        end

        def getTitle
            @title
        end
        def getNoid
            @noid
        end

        def getLink
            @link
        end

        def getMarkup
            @embed_markup
        end
    end
end