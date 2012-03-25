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

      while !s.eos?
        if markup == "markdown"
          re = %r{/^(#+)\s*(.*)$/}
          s.match?(re)
          matched = s.matched
          matched =~ re
          level, idx, title = $1.count('#'), nil, $2.strip
        else
          re = %r{^h(\d)(?:\((#.*?)\))?\s*\.\s*(.*)$}
          s.match?(re)
          matched = s.matched
          matched =~ re
          level, idx, title = $1.to_i, $2, $3.strip if matched
        end
        if matched
         if level < current_level
            # This is needed. Go figure.
            return level_hash
         elsif level == current_level
            index = counters.join("-")
            idx ||= '#' + index
            if markup == "markdown"
              @result.sub!(matched,"<h#{level} id='#{index}'> #{index}#{title} </h#{level}>")
            else 
              @result.sub!(matched, "h#{level}(#{idx}). #{index} #{title}")
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
        s.getch
      end
      level_hash
    end
  end
end
