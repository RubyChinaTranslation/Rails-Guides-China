require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/inflections'

module RailsGuides
  class Indexer
    attr_reader :body, :result,:level_hash,:markup

    def initialize(body,markup)
      @body     = body
      @result   = @body.dup
      @markup = markup
    end

    def index
      @level_hash = process(body)
    end

    private
    def process(string, current_level=3, counters=[1])
      s = StringScanner.new(string)

      level_hash = {}
      re = if markup == "textile"
            %r{^h(\d)(?:\((#.*?)\))?\s*\.\s*(.*)$}
           else
            %r{^(###+)\s*(.*)$} 
           end
      while !s.eos?
        s.match?(re)
        if matched = s.matched
          matched =~ re
          if markup == "textile"
           level, idx, title = $1.to_i, $2, $3.strip
          else
           level, idx, title = $1.count('#'), nil, $2.strip
          end
          if level < current_level
            # This is needed. Go figure.
            return level_hash
          elsif level == current_level
            index = counters.join("-")
            idx ||= '#' + index 
            if markup == "textile" 
              @result.sub!(matched, "h#{level}(#{idx}). #{index.gsub('-','.')} #{title}") 
            end
            key = {
              :title => title,
              :id => idx
            }
            # Recurse
            counters << 1
            level_hash[key] = process(s.post_match, current_level + 1, counters)
            counters.pop

            # Increment the current level
            last = counters.pop
            counters << last + 1
          end
        end
        if matched
          s.pos += matched.size
        else
          s.getch
        end
      end
      level_hash
    end
  end
end
