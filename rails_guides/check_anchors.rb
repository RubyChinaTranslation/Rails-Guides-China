require 'rails_guides/levenshtein'

module RailsGuides
  module CheckAnchors
   def warn_about_broken_links(html)
      anchors = extract_anchors(html)
      check_fragment_identifiers(html, anchors)
   end

   def extract_anchors(html)
      # Textile generates headers with IDs computed from titles.
      anchors = Set.new
      html.scan(/<h\d\s+id="([^"]+)/).flatten.each do |anchor|
        if anchors.member?(anchor)
          puts "*** DUPLICATE ID: #{anchor}, please use an explicit ID, e.g. h4(#explicit-id), or consider rewording"
        else
          anchors << anchor
        end
      end

      # Footnotes.
      anchors += Set.new(html.scan(/<p\s+class="footnote"\s+id="([^"]+)/).flatten)
      anchors += Set.new(html.scan(/<sup\s+class="footnote"\s+id="([^"]+)/).flatten)
      return anchors
   end

   def check_fragment_identifiers(html, anchors)
      html.scan(/<a\s+href="#([^"]+)/).flatten.each do |fragment_identifier|
        next if fragment_identifier == 'mainCol' # in layout, jumps to some DIV
        unless anchors.member?(fragment_identifier)
          guess = anchors.min { |a, b|
            Levenshtein.distance(fragment_identifier, a) <=> Levenshtein.distance(fragment_identifier, b)
          }
          puts "*** BROKEN LINK: ##{fragment_identifier}, perhaps you meant ##{guess}."
        end
      end
     end


  end
end
