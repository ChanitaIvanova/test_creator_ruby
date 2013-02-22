require 'answers'
class Test
  attr_reader :questions
  def initialize(questions)
    @questions = questions
  end
#load opens a text file, and from it parses each question
#putting it in an array -questions, an then creates a
#test from the found questions
  def self.load(address)
    whole_file = IO.read(address)
	  questions = []
	  whole_file.gsub(/QU: (.*?) :QUEND/m){
      unless(question = OpenQuestion.read($1)) then question = ClosedQuestion.read($1) end
      questions << question
    }
    Test.new(questions)
  end
#creat_file takes a test and puts in text file
#each question with a special format so
#later will be easyer the questions to be parsed
  def creat_file(address)
    file = File.open(address,"w")
    questions.map{ |x|
      if(x.instance_of? OpenQuestion) then
        file.write("QU: Q O: #{x.question} :QOEND \nA O: \n")
        x.answers.map{ |y|
          file.write("AN: #{y} :ANEND\n")
        }
        file.write(" :AOEND :QUEND\n\n")
      else
        file.write("QU: Q C: #{x.question} :QCEND \nA C: \n")
        x.answers.map{ |y|
          file.write("AN: #{y} :ANEND\n")
        }
        file.write(" :ACEND\n C C: ")
        x.correct.map{ |y|
          file.write("#{y} ")
        }
        file.write(" :CCEND :QUEND\n\n")
      end
    }
    file.close
  end
end