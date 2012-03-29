class MarkdownRender < Redcarpet::Render::HTML
  include RailsGuides::TextProcess
    
  def initialize(render_option={})
    @index = [0] * 6
    super 
  end

  def header(title, level)
    @index[level] += 1
    "<h#{level} id='#{set_index(level)}'>#{set_index(level).gsub('-','.')} #{title}</h#{level}>"
  end

  def preprocess(fullbody)
    fullbody = plusplus_markdown(fullbody) 
    fullbody = notestuff(fullbody)
    code(fullbody)
  end

  def set_index(level)
    puts @index[3..level].join("-") 
    @index[3..level].join("-") 

  end

end
