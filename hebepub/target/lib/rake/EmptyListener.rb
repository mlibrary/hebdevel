# This file contains a ruby class used for parsing
# the XHTML files that contain a table and determine
# the table/@role attribute has the value "empty".

require "rexml/document"
require "rexml/streamlistener"

include REXML

class EmptyListener
    include REXML::StreamListener

    def initialize()
        @role_empty = false
    end

    def tag_start(*args)
        #puts "tag_start: #{args.map {|x| x.inspect}.join(', ')}"
        elem = args[0]
        case elem
        when "table"
            attrs = args[1]
            @role_empty = attrs['role'] == 'empty'
        end
    end

    def is_empty?
        return @role_empty
    end
end


