# Check if element exists:
# <tt>xml.should have_xml_element("account")<tt>
# Use REXML syntax to address nested elements:
# <tt>xml.should have_xml_element("account/name")<tt>
# Check if element has certain value:
# <tt>xml.should have_xml_element("account/name").with_value("foo")<tt>
# or:
# <tt>xml.should have_xml_element("account", :value => "foo")<tt>
# Check if element has certain attribute:
# <tt>xml.should have_xml_element("account").with_attribute("type")<tt>
# Check if attribute has certain value:
# <tt>xml.should have_xml_element("account").with_attribute("type", "user")<tt>
# or:
# <tt>xml.should have_xml_element("account", :type => "user")<tt>
# Check if element occurs a number of times:
# <tt>xml.should have_xml_element("account", :count => 2)<tt>
# Check if element has a number of children named users:
# <tt>xml.should have_xml_element("account").containing(2).users<tt>
# or
# <tt>xml.should have_xml_element("account").containing(2, "users")<tt>
# or
# <tt>xml.should have_xml_element("account", :count => 2, :child => :user)<tt>
# or use generic "element" to count all children regardless of name:
# <tt>xml.should have_xml_element("account").containing(2).elements<tt>

#NOTE: Currently you cannot combine any of the options
#TODO: make it possible to combine count, value, attributes


class ElementCountProxy
  
  attr_accessor :element, :element_name
  
  def initialize(matcher,element=nil)
    @element = element
    @element_name = @element.dup if @element
    @matcher = matcher
  end
  
  def matches?(*args)
    @matcher.matches?(*args)
  end
  
  def failure_message
    @matcher.failure_message
  end

  def negative_failure_message
    @matcher.negative_failure_message
  end
  
  def method_missing(meth, *args, &blk)
    @element_name = meth
    @element = meth.to_s.singularize.dasherize
    return @matcher
  end
  
end

class HaveXmlElement
  
  def initialize(expected,options={})
    @expected = expected
    @value = options.delete(:value)      
    @match_value = @value || false
    @count = options.delete(:count)
    @count_proxy = ElementCountProxy.new(self,options.delete(:child)) if options[:child]
    @attribute_name = options.keys.first
    @attribute_value = options.values.first
    @match_attribute_name = @attribute_name || false
    @match_attribute_value = @attribute_value || false
  end

  def matches?(actual)
    @actual = actual
    begin
      document = REXML::Document.new(actual)
      if @match_value
        compare_values(document.elements[@expected.to_s].text,@value)
      elsif @match_attribute_value          
        compare_values(document.elements[@expected.to_s].attributes[@attribute_name],@attribute_value)
      elsif @match_attribute_name          
        document.elements[@expected.to_s].attributes[@attribute_name] ? true : false
      elsif @count && @count > 0
        if counted_element && counted_element == 'element' 
          document.elements[@expected.to_s].elements.size == @count ? true : false
        elsif counted_element
          document.elements[@expected.to_s].elements[counted_element].size == @count ? true : false
        else
          document.elements[@expected.to_s].size == @count ? true : false 
        end
      else          
        document.elements[@expected.to_s] ? true : false
      end
    rescue => e
      false
    end
  end

  def containing(count,child=nil)
    @count = count
    @count_proxy = ElementCountProxy.new(self,child)
    return @count_proxy
  end

  def with_value(value)
    @match_value = true
    @value = value
    return self
  end
  
  def with_attribute(name,value=nil)
    if name.is_a?(Hash)
      arr = name.to_a.flatten
      name = arr[0]
      value = arr[1]
    end
    @match_attribute_name = true
    @match_attribute_value = value.nil? ? false : true
    @attribute_name = name
    @attribute_value = value
    return self
  end

  def failure_message
    "expected \n\n#{@actual}\n to have XML element #{@expected.inspect}#{message_extension}, but it didn't"
  end

  def negative_failure_message
    "expected \n\n#{@actual}\n to not have XML element #{@expected.inspect}#{message_extension}, but it did"
  end
  
  def counted_element
    @count_proxy.element
  end
  
  def counted_element_name
    @count_proxy.element_name
  end

  protected
  
  def compare_values(target,source)
    if source.is_a? Regexp
      target.to_s.match source
    else
      target.to_s == source.to_s
    end
  end

  def message_extension
    case
    when @match_value                             then " with value \"#{@value}\""
    when @match_attribute_value                   then " with attribute \"#{@attribute_name}\" matching \"#{@attribute_value}\""
    when @match_attribute_name                    then " with attribute \"#{@attribute_name}\""
    when @count && @count > 0 && counted_element  then " containing #{@count} #{counted_element_name}"
    when @count && @count > 0                     then " appearing #{@count} times"
    else ""
    end
  end

end

def have_xml_element(expected,options={})
  HaveXmlElement.new(expected,options)
end


RSpec::Matchers.define :have_xml_element do |elt,options={}|
  match do |subj|
    HaveXmlElement.new(elt,options).matches?(subj)
  end
end

