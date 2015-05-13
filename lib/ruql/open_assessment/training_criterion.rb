class TrainingCriterion
  attr_accessor :criterion, :option

  def initialize(options={})
    @criterion = options[:criterion]
    @option = options[:option]

    # Validation
    if @criterion.nil? || @option.nil?
      raise "Must include criterion and option."
    end
  end
end
