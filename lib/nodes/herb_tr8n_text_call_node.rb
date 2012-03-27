class HerbTr8nTextCallNode

  def initialize
    @text_values = []
    @variable_names_and_values = []
  end

  def add_text( text_value_as_string )
    @text_values << HerbTr8nStringNode.new( text_value_as_string )
  end

  def add_variable( name, value )
    @variable_names_and_values << [name, value]
    @text_values << "{#{name}}"
  end

  def self_contained_html_node( node_name )
    @text_values << "{#{node_name}}"
  end
  
  def text_value
    to_return = '<%= tr( "'

    @text_values.each do |text_value|
      to_return += text_value.to_s
    end

    to_return +='"'
    
    unless( @variable_names_and_values.empty? )
      to_return += ", nil, { "
      @variable_names_and_values.each do |variable_name_value|
        to_return += ":#{variable_name_value.first} => #{variable_name_value.last}"
        to_return += ", " unless variable_name_value == @variable_names_and_values.last
      end
      to_return += " }"
    end
    
    to_return += ' ) %>'

    to_return
  end

  def white_space( white_space_text )
    @text_values << white_space_text
  end
  
end
