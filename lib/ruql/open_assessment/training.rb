class Training

  attr_accessor :training_criterions, :training_answer

  ##
  # Initializes a training response
  def initialize(options={})
    @training_criterions = []
  end

  ##
  # Sets the answer for the training response
  def answer(s) ; @training_answer = s ; end

  ##
  # Adds a training criterion and evaluates to proc block
  def training_criterion(*args)
    training = TrainingCriterion.new(*args)
    @training_criterions << training
  end
end
