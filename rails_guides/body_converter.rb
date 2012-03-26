#coding: utf-8
require "rails_guides/text_process"
require "rails_guides/indexer"

module RailsGuides
  class BodyConverter
    attr_accessor :body, :markup, :view, :header_capture,:lb 
    def initialize(body,view,markup)
      @markup = markup
      @body = body
      @view = view
      if  @markup == "textile"
        @header_capture = /h2\.(.*)/
        @lb = lambda { |text,lite_mode| textile(text,lite_mode) }
      else
        @header_capture = /##\s*(.*)/
        @lb = lambda { |text,void|  markdown(text) }
      end
    end
    
    def convert_body
      set_header_section
      body = set_index

      lb.call(body,false).html_safe 
    end
    
    def set_header_section
      body.gsub!(/(.*?)endprologue\./m, '').strip!
      header = $1
      header =~ header_capture
      page_title = "Ruby on Rails Guides 中文: #{$1.strip}"
      header = lb.call(header,false)
      view.content_for(:page_title) { page_title.html_safe }
      view.content_for(:header_section) { header.html_safe }
    end

    def set_index
      index = <<-INDEX
      <div id="subCol">
        <h3 class="chapter"><img src="images/chapters_icon.gif" alt="" />目录</h3>
        <ol class="chapters">
      INDEX

      i = Indexer.new(body,@markup)
      i.index
      i.level_hash.each do |key, value|
        link = view.content_tag(:a, :href => key[:id]) {  lb.call(key[:title],true).html_safe }

        children = value.keys.map do |k|
          view.content_tag(:li,
            view.content_tag(:a, :href => k[:id]) { lb.call(k[:title],true).html_safe })
        end

        children_ul = children.empty? ? "" : view.content_tag(:ul, children.join(" ").html_safe)

        index << view.content_tag(:li, link.html_safe + children_ul.html_safe)
      end

      index << '</ol>'
      index << '</div>'

      view.content_for(:index_section) { index.html_safe }

      i.result
    end

    def textile(body, lite_mode)
      body = TextProcess.new(body,markup).process
      t = RedCloth.new(body)
      t.hard_breaks = false
      t.lite_mode = lite_mode
      t.to_html
    end
    
    def markdown(body)
      body = TextProcess.new(body,markup).process
      BlueCloth.new(body).to_html
    end



  end
end
