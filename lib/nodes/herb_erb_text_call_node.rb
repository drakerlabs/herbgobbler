class HerbErbTextCallNode

  def initialize( text_values = [], prepend = nil, postpend = nil )
    @text_values = text_values
    @prepend = prepend
    @postpend = postpend
  end

  def add_text( text )
    @text_values << text
  end

  def key_value
    I18nKey.new( original_text ).key_value
  end
  
  def original_text
    @text_values.join( '' )
  end
  
  def text_value
    "<%= #{@prepend}#{key_value}#{@postpend} %>"
  end
  
  def to_s
    text_value
  end
  
end
