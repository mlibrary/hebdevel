# This file contains a ruby class used for parsing
# the ASSETSPATH (assets.html)/LINKSPATH (links.html)
# files and determining which assets should be
# included in the epub directory structure (images
# directory) or should be included in media directory
# and uploaded as media assets.
#
# The assets.rake/links.rake processes are used to
# generate these files which contain HTML tables.
require "rexml/document"
require "rexml/streamlistener"

include REXML

class AssetListener
    include REXML::StreamListener

    def initialize()
        @role_empty = false
        @cell_class = ""
        @row_values = Hash.new
        @media_list = Array.new
        @image_list = Array.new
        @asset_map = Hash.new
    end

    def tag_start(*args)
        #puts "tag_start: #{args.map {|x| x.inspect}.join(', ')}"
        elem = args[0]
        case elem
        when "table"
            attrs = args[1]
            @role_empty = attrs['role'] == 'empty'
        when "tr"
            @row_values.clear
        when "td"
            attrs = args[1]
            @cell_class = attrs['class']
        end
    end

    def tag_end(*args)
        elem = args[0]
        case elem
        when "tr"
            asset = @row_values['asset']
            return if asset == nil or asset.strip == ""

            assetpath = @row_values['assetpath']
            @asset_map[asset] = assetpath

            if @row_values['media'] == 'yes'
                @media_list.push(assetpath)
            end
            if @row_values['inclusion'] == 'yes'
                @image_list.push(assetpath)
            end
        when "td"
            @cell_class = ""
        end
    end

    def text(data)
        #return if data =~ /^\w*$/     # whitespace only
        return if data == nil or data.strip == ""

        if @cell_class != ""
            @row_values[@cell_class] = data
        end
    end

    def is_empty?
        return @role_empty
    end

    def get_media_list
        return @media_list
    end

    def get_image_list
        return @image_list
    end

    def get_asset_map
        return @asset_map
    end
end


