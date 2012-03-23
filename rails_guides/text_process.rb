
require 'active_support/core_ext/object/inclusion'

module RailsGuides
   class TextProcess
    attr_reader :body
    def initialize(body)
      @body     = body
    end

    def process
      notestuff
      plusplus
      code
      body
    end
    
    def notestuff
     @body.gsub!(/^(TIP|IMPORTANT|CAUTION|WARNING|NOTE|INFO)[.:](.*?)(\n(?=\n)|\Z)/m) do |m|
        css_class = case $1
                    when 'CAUTION', 'IMPORTANT'
                      'warning'
                    when 'TIP'
                      'info'
                    else
                      $1.downcase
                    end
        %Q(<div class="#{css_class}"><p>#{$2.strip}</p></div>)
      end
    end

    def plusplus
      @body.gsub!(/\+(.*?)\+/) do |m|
        "<notextile><tt>#{$1}</tt></notextile>"
      end

      # The real plus sign
      @body.gsub!('<plus>', '+')
    end

    def brush_for(code_type)
      case code_type
        when 'ruby', 'sql', 'plain'
          code_type
        when 'erb'
          'ruby; html-script: true'
        when 'html'
          'xml' # html is understood, but there are .xml rules in the CSS
        else
          'plain'
      end
    end

    def code
      @body.gsub!(%r{<(yaml|shell|ruby|erb|html|sql|plain)>(.*?)</\1>}m) do |m|
        <<HTML
<notextile>
<div class="code_container">
<pre class="brush: #{brush_for($1)}; gutter: false; toolbar: false">
#{ERB::Util.h($2).strip}
</pre>
</div>
</notextile>
HTML
      end
    end

   end
  end

