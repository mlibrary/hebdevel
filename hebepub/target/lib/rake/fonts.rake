# This file generates the FONTSPATH (fonts.html) file.
#
# The input is the list of all fonts found in the {fixepub|flowepub}/fonts
# directory. The list is stored in an HTML table for inclusion in the
# EPUB archive OPF file.
#
# This table has the following columns:
#   font            Font base name

require_relative "common.rb"

namespace :fonts do

    # Fonts table markup
    MARKUP_HEADER_FONTS = "<th class=\"font\">Font</th>"
    MARKUP_ROW_FONTS = "<tr><td class=\"font\">%s</td></tr>"

    LAYOUTFONTS=File.join(TARGETLAYOUTROOT, "fonts")
    FONTSDIR=File.join(OEBPSDIR, "fonts")

    task :default => [ :files ]

    task :files => [ FONTSPATH ]

    file FONTSPATH => [ METAINFSRCDIR ] do
        # For the specified HEBID, generate the HTML table
        # header markup

        rows = ""
        if File.exists?(LAYOUTFONTS)
            # Fonts source directory exists.
            # Create the EPUB fonts directory
            # and copy the font files to it.
            # Add a row in the HTML table.
            FileUtils.mkdir_p "#{FONTSDIR}"
            Dir.glob(File.join(LAYOUTFONTS, "*")).each do |f|
                f_basename = File.basename(f)
                cp(f, File.join(FONTSDIR, f_basename))
                rows += sprintf(MARKUP_ROW_FONTS, f_basename)
            end
        end

        # Generate the HTML files for this HEB directory.
        File.open(FONTSPATH, "w") { |f|
            f.write(sprintf(MARKUP_TBL, "#{HEBID}_fonts", HEBID, MARKUP_HEADER_FONTS, rows))
        }
    end

    CLOBBER.include(FONTSDIR)

end

