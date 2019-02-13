# This file contains a ruby class used for parsing
# the XHTML files that contain a table and determine
# the table/@role attribute has the value "empty".

require "nokogiri"

class EmptyTableParser < Nokogiri::XML::SAX::Document
    def initialize
        @role_empty = false
    end

    def start_element(name, attrs = [])
        # Handle each element, expecting the name and any attributes
        #puts "<#{name}: #{attrs.map {|x| x.inspect}.join(', ')}>"
        case name
        when "table"
            tbl = attrs.to_h
            @role_empty = tbl['role'] == 'empty'
        end
    end

    def characters(string)
        # Any characters between the start and end element expected as a string
    end

    def end_element(name)
        # Given the name of an element once its closing tag is reached
    end

    def is_empty?
        return @role_empty
    end
end

def is_empty_table?(path)
    empty_table_parser = EmptyTableParser.new
    parser = Nokogiri::XML::SAX::Parser.new(empty_table_parser)
    parser.parse_file(path)
    return empty_table_parser.is_empty?
end


