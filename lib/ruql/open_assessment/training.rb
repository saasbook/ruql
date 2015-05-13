class Training

  attr_accessor :training_criterions, :training_answer

  def initialize(options={})
    @training_criterions = []
  end

  def answer(s) ; @training_answer = s ; end

  def training_criterion(*args)
    training = TrainingCriterion.new(args);
    @training_criterions << training
  end
end
