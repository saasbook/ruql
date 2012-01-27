require 'spec_helper'

describe Html5Renderer do
  describe 'when created' do
    subject { Html5Renderer.new(:fake_quiz) }
    its(:output) { should == '' }
  end
  describe 'with stylesheet link' do
    def rendering_with(opts)
      Html5Renderer.new(Quiz.new(''), opts).render_quiz.output
    end
    it 'should include CSS link with -c option' do
      rendering_with(:c => 'foo.html').
        should match /<link rel="stylesheet" type="text\/css" href="foo.html"/
    end
    it 'should include CSS link with --css option' do
      rendering_with(:css => 'foo.html').
        should match /<link rel="stylesheet" type="text\/css" href="foo.html"/
    end
  end
  describe 'rendering solutions' do
    before :each do
      @a = [
        Answer.new('aa',true,'This is right'),
        Answer.new('bb',false,'Nope'),
        Answer.new('cc',false)]
      @q = MultipleChoice.new('question', :answers => @a)
      @quiz = Quiz.new('foo', :questions => [@q])
      @output = Html5Renderer.new(@quiz,{:solutions => true}).render_quiz.output
    end
    it 'should highlight correct answer' do
      @output.should have_xml_element "//li[@class='correct']/p", :value => 'aa'
    end
    it 'should show explanations for incorrect answers' do
      @output.should have_xml_element "//li[@class='incorrect']/p", :value => 'bb'
      @output.should have_xml_element "//li[@class='incorrect']/p[@class='explanation']", :value => 'Nope'
    end
  end
      
  describe 'rendering multiple-choice question' do
    before :each do
      @a = [Answer.new('aa',true),Answer.new('bb',false), Answer.new('cc',false)]
      @q = MultipleChoice.new('question', :answers => @a)
      @h = Html5Renderer.new(:fake)
    end
    it 'should randomize option order if :randomize true' do
      @q.randomize = true
      runs = Array.new(10) { Html5Renderer.new(:fake).render_multiple_choice(@q,1).output }
      runs.any? { |run| runs[0] != run }.should be_true
    end
    it 'should preserve option order if :randomize false' do
      @q.randomize = false
      runs = Array.new(10) { @h.render_multiple_choice(@q,1).output }
      runs[0].should match /.*aa.*bb.*cc/m
      runs.all? { |run| runs[0] == run }.should be_true
    end
    it 'should not indicate solution' do
      @h.render_multiple_choice(@q,1).output.should_not include '<li class="correct">'
    end
  end
end
