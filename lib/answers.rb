require 'questions'
class OpenAnswers
  attr_reader :tag, :response
  def initialize(question,answer)
    @tag = true
    question.answers.map{ |x| @response = "#{question.question}\nCorrect!\n\n" if x == answer}
	  if !(defined? @response)then
	    @tag = false
	    @response = "#{question.question}\nWRONG! \nPossible answer\\s:\n\n"
      options = 65
	    question.answers.map{ |x| @response = "#{@response}#{options.chr}: #{x}\n\n"
        options +=1
      }
	    @response = "#{@response}Your answer:\n#{answer}\n\n"
	  end
  end
end

class ClosedAnswers
  attr_reader :tag, :response
  def initialize(question,answers)
    @tag = true
    @response = "#{question.question}\nCorrect!\n\n" if question.correct == answers
    if !(defined? @response)then
      @tag = false
      @response = "#{question.question}\nWRONG! \nCorrect answer\\s:\n"
      options=64
      question.correct.each{ |x|
        @response = "#{@response}#{(x + options).chr}: #{question.answers[x-1]}\n"
        options +=1
      }
      @response = "#{@response}\n\nYour answer\\s:\n"
      options = 64
      answers.each{|x|
        @response = "#{@response}#{(x + options).chr}: #{question.answers[x-1]}\n"
        options +=1
      }
	  end
  end
end
