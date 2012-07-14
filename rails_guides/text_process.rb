
require 'active_support/core_ext/object/inclusion'

module RailsGuides
   module TextProcess
    def notestuff(body)
     body.gsub!(/^(TIP|IMPORTANT|CAUTION|WARNING|NOTE|INFO)[.:](.*?)(\n(?=\n)|\Z)/m) do |m|
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
     body
    end

    def plusplus_markdown(body)
        body.gsub!(/\+(.*?)\+/) do |m|
          matched = $1
          matched.gsub!(/[.!()?#`\\_*]/) { |s| "\\" + s[0] }
          matched
        end
        body.gsub!('<plus>', '+') #this is real plus
        body
    end
    def plusplus_textile(body)
      body.gsub!(/\+(.*?)\+/) do |m|
        "<notextile><tt>#{$1}</tt></notextile>"
      end
      body.gsub!('<plus>', '+')
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

    def code(body)
      body.gsub!(%r{<(yaml|shell|ruby|erb|html|sql|plain)>(.*?)</\1>}m) do |m|
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
      body
    end

   end
  end

