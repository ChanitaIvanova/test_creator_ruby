require 'prawn'
class Generate
  def self.generate_test(test,count,address_test,title)
    count = test.questions.length if(!count || count == 0 || count > test.questions.length)
    answers = []
    Prawn::Document.generate(address_test) do
      text title, :align => :center, :size => 25
      move_down 50
      test_questions = []
      current_answers = []
      test.questions.map{ |x| test_questions << x }
      1.upto(count){ |x|
        index = rand(test_questions.length)
        current_question = test_questions[index]
        test_questions.delete_at(index)
        text "#{x}: #{current_question.question}"
        options = 65
        if current_question.is_a? ClosedQuestion then
          current_question.answers.map{ |x|
            text "\n#{options.chr}: #{x}"
            options += 1
          }
          current_question.correct.map {|x|
            current_answers << (x + 64).chr
          }
        else
          move_down(25)
          current_question.answers.map{ |x|
            current_answers << ("#{options.chr}: #{x}")
            options +=1
          }
        end
        answers << current_answers
        current_answers = []
        move_down(25)
      }
    end
    answers
  end

  def self.generate_answers(address,answers,title)
    Prawn::Document.generate(address) do
      text title, :align => :center, :size => 25
      move_down 50
      count = 1
      answers.map{ |x|
        text "#{count}: "
        count +=1
        x.map{ |y|
          text "\n#{y}"
        }
        move_down(25)
      }
    end
  end

  def self.create(test,count = nil,address_test,address_answers,title)
    answers = self.generate_test(test,count,address_test,title)
    self.generate_answers(address_answers,answers,title) if (address_answers != "")
  end

end