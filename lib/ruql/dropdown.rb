class Dropdown < Question

  DropdownChoice = Struct.new(:correct, :list)
  DropdownText = Struct.new(:text)

  def choice(correct, list)
    @choices << DropdownChoice.new(correct, list)
  end
  def label(str)
    @choices << DropdownChoice.new(0, [str])
  end

  attr_accessor :choices

  def initialize(opts={})
    super
    self.choices = []
  end
end
