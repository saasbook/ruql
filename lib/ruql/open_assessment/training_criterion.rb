class TrainingCriterion
  attr_accessor :criterion, :option

  ##
  # Initializes a training criterion for a training response
  def initialize(options={})
    @criterion = options[:criterion]
    @option = options[:option]

    # Validation
    if @criterion.nil? || @option.nil?
      raise "Must include criterion and option."
    end
  end
end
