# This file generates the STYLESPATH (stylesheets.html) file.
#
# The input is the list of all stylesheets found in the {fixepub|flowepub}/styles
# directory. The list is stored in an HTML table for inclusion in the
# EPUB archive OPF file.
#
# This table has the following columns:
#   stylesheet            Stylesheet base name

require_relative "common.rb"

namespace :styles do

    # Styles table markup
    MARKUP_HEADER_STYLES = "<th class=\"stylesheet\">Stylesheet</th>"
    MARKUP_ROW_STYLES = "<tr><td class=\"stylesheet\">%s</td></tr>"

    LAYOUTSTYLES=File.join(TARGETLAYOUTROOT, "styles")
    STYLESDIR=File.join(OEBPSDIR, "styles")

    task :default => [ :files ]

    task :files => [ STYLESPATH ]

    file STYLESPATH => [ METAINFSRCDIR ] do
        # For the specified HEBID, generate the HTML table
        # header markup

        rows = ""
        if File.exists?(LAYOUTSTYLES)
            # Styles source directory exists.
            # Create the EPUB styles directory
            # and copy the stylesheets to it.
            # Add a row in the HTML table.
            FileUtils.mkdir_p "#{STYLESDIR}"
            Dir.glob(File.join(LAYOUTSTYLES, "*")).each do |f|
                f_basename = File.basename(f)
                cp(f, File.join(STYLESDIR, f_basename))
                rows += sprintf(MARKUP_ROW_STYLES, f_basename)
            end
        end

        # Generate the HTML files for this HEB directory.
        File.open(STYLESPATH, "w") { |f|
            f.write(sprintf(MARKUP_TBL, "#{HEBID}_stylesheets", HEBID, MARKUP_HEADER_STYLES, rows))
        }
    end

    CLOBBER.include(STYLESDIR)

end

