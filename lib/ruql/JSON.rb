module JSON
  JSON_primitives = ["String", "Fixnum", "FalseClass", "TrueClass", "NilClass"]
  # def to_JSON
  #   if JSON_primitives.include? self.class.to_s
  #     puts 'GOT PRIMITIVE'
  #     return self
  #   elsif self.is_a? Array 
  #     puts 'GOT ARRAY'
  #     return self.map {|item| item.to_JSON}
  #   else
  #     puts 'GOT REGULAR OBJ'
  #     h = Hash[instance_variables.collect { |var| [var, instance_variable_get(var)] }]
  #     h[:question_type] = self.class.to_s
  #     return h
  #   end
  # end

  def to_JSON
      h = Hash[instance_variables.collect { |var| [var, instance_variable_get(var)] }]
      h[:question_type] = self.class.to_s
      return h
  end


end