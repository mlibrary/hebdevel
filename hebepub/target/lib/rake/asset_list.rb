# This file contains a ruby class used for parsing
# the ASSETSPATH (assets.html)/LINKSPATH (links.html)
# files and determining which assets should be
# included in the epub directory structure (images
# directory) or should be included in media directory
# and uploaded as media assets.
#
# The assets.rake/links.rake processes are used to
# generate these files which contain HTML tables.

require "nokogiri"

class AssetListParser < Nokogiri::XML::SAX::Document

    def initialize()
        @role_empty = false
        @cell_class = ""
        @row_values = Hash.new
        @media_list = Array.new
        @image_list = Array.new
        @asset_map = Hash.new
    end

    def start_element(name, attrs = [])
        #puts "<#{name}: #{attrs.map {|x| x.inspect}.join(', ')}"
        case name
        when "table"
            tbl_attrs = attrs.to_h
            @role_empty = tbl_attrs['role'] == 'empty'
        when "tr"
            @row_values.clear
        when "td"
            td_attrs = attrs.to_h
            @cell_class = td_attrs['class']
        end
    end

    def characters(string)
        #return if string =~ /^\w*$/     # whitespace only
        return if string == nil or string.strip == ""

        if @cell_class != ""
            @row_values[@cell_class] = string
        end
    end

    def end_element(name)
        case name
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

def parsed_assets(path)
    asset_list_parser = AssetListParser.new
    parser = Nokogiri::XML::SAX::Parser.new(asset_list_parser)
    parser.parse_file(path)
    return asset_list_parser
end

