class OpenQuestion
  attr_reader :question, :answers
  def initialize(question,answers)
    @question = question
    @answers = answers
  end

  def self.read(string)
    if(string =~ /Q O: (.*?) :QOEND/m) then question = $1 end
    if(string =~ /A O: (.*?) :AOEND/m) then answers_part = $1 end
    return nil if(!question or !answers_part)
    answers = []
    answers_part.gsub(/AN: (.*?) :ANEND/m) { answers << $1 }
    OpenQuestion.new(question,answers)
  end

end

class ClosedQuestion
  attr_reader :question, :answers, :answers_count, :correct
  def initialize(question,answers,correct)
    @question = question
    @answers = answers
    @answers_count = @answers.length
    @correct = correct
  end

  def self.read(string)
    if(string =~ /Q C: (.*?) :QCEND/m) then question = $1 end
    if(string =~ /A C: (.*?) :ACEND/m) then answers_part = $1 end
    if(string =~ /C C: (.*?) :CCEND/m) then correct = $1.to_s end
    correct = correct.split
    correct = correct.map{ |x| x.to_i }
    return nil if(!question or !answers_part)
    answers = []
    answers_part.gsub(/AN: (.*?) :ANEND/m) { answers << $1 }
    ClosedQuestion.new(question,answers,correct)
  end

end