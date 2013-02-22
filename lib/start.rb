require "tk"
require 'test'
def start
  $f1.destroy if($f1)
  $answers=[]
  $f1 = TkFrame.new($root){
    background "red"
    pack('expand' => 1,'fill' => 'both','side'=>'bottom')
  }
  entry1 = TkEntry.new($f1) do
    justify 'left'
    width 10
    pack('side'=>'left')
  end
  variable = TkVariable.new
  entry1.textvariable = variable
  variable.value = 0
  $directory = ""
  browse_button = TkButton.new($f1) do
    text "Browse..."
    command {
      $directory = Tk.getOpenFile
    }
    pack('side'=>'left','padx'=>5, 'pady'=>0)
  end
  test = TkButton.new($f1) do
    text "Test"
    command {
      if ($directory == "") then
        Tk.messageBox(
          'message' => "You have not choosen a test!\n",
          'type' => 'ok',
          'icon' => 'warning'
        )
        return
      end
      test(variable)
    }
    pack('side'=>'left','padx'=>5, 'pady'=>0)
  end
end

def test(count)
    test = Test.load($directory)
    array_questions = test.questions
    $f1.destroy if($f1)
    $f1 = TkFrame.new($root)do
      background  "red"
      pack('expand' => 1,'fill' => 'both','side'=>'bottom')
    end
    if ((count == 0) or (count > array_questions.length))then
      count = array_questions.length
    end
    test_questions = []
    array_questions.map{|x| test_questions << x}
    index = 1
    $f2 = TkFrame.new($f1) do
      background "blue"
      pack('expand' => 1,'fill' => 'both','side'=>'bottom')
    end
    ask(index,test_questions,count)
end

def open_ask(index,open_question,test_questions,count)
  $f2.destroy if($f2)
  $f2 = TkFrame.new($f1) do
    background "blue"
    pack('expand' => 1,'fill' => 'both','side'=>'bottom')
  end
  TkLabel.new($f2) do
    text ("#{index.to_s}: #{open_question.question}\n")
    pack('side'=>'top','padx'=>0, 'pady'=>0)
  end
  entry1 = TkEntry.new($f2) do
    justify 'left'
    width 25
    pack('side'=>'top')
  end
  variable = TkVariable.new
  entry1.textvariable = variable
  variable.value = "Your Answer"
  if (index == count) then
    finish = TkButton.new($f2) do
      text "Finish"
      command {
        $answers << OpenAnswers.new(open_question,variable)
        $f2.destroy
        wrong = 0
        0.upto(($answers.length) - 1){ |i|
          TkLabel.new($f1) do
            text ("#{(i + 1).to_s}. #{$answers[i].response}")
            pack('side'=>'top')
          end
          wrong +=1 if ($answers[i].tag == false)
        }
        right = count - wrong
        TkLabel.new($f1) do
          text "You gave #{right.to_s} correct answer\\s and #{wrong.to_s} wrong answer\\s!\n"
          pack('side'=>'top')
        end
      }
      pack('side'=>'top')
    end
  else
    TkButton.new($f2) do
      text "Next"
      command {
        $answers << OpenAnswers.new(open_question,variable)
        index +=1
        ask(index,test_questions,count)
      }
      pack('side'=>'top')
    end
  end
end

def closed_ask(index,closed_question,test_questions,count)
  $f2.destroy if($f2)
  $f2 = TkFrame.new($f1) do
    background "blue"
    pack('expand' => 1,'fill' => 'both','side'=>'bottom')
  end
  TkLabel.new($f2) do
    text ("#{index.to_s}: #{closed_question.question}\n")
    pack('side'=>'top','padx'=>0, 'pady'=>0)
  end
  options = 65
  array_answers = closed_question.answers
  user_answers = []
  $my_answers = []
  my_buttons = []
  1.upto(array_answers.length) { |j|
    my_buttons[(j-1)]= TkCheckButton.new($f2) do
      text "#{options.chr}: #{array_answers[(j-1)]}"
      onvalue 1
      offvalue 0
      variable $my_answers[(j-1)]
      pack('side'=>'top','padx'=>0,'pady'=>10)
    end
    options +=1
  }
  if (index == count)then
    finish = TkButton.new($f2) do
      text "Finish"
      command {
        0.upto((my_buttons.length) - 1){ |j|
          user_answers << (j+1) if(my_buttons[j].cget('variable') == 1)
        }
        $answers << ClosedAnswers.new(closed_question,user_answers)
        $f2.destroy
        wrong = 0
        0.upto(($answers.length) -1) { |i|
          TkLabel.new($f1) do
            text ("#{(i+1).to_s}. #{$answers[i].response}")
            pack()
          end
          wrong +=1 if ($answers[i].tag == false)
        }
        right = count - wrong
        TkLabel.new($f1) do
          text "You gave #{right.to_s} correct answer\\s and #{wrong.to_s} wrong answer\\s!\n"
          pack('side'=>'top')
        end
      }
      pack('side'=>'top')
    end
  else
    TkButton.new($f2) do
    text "Next"
      command {
        0.upto((my_buttons.length) -1){ |j|
          user_answers << (j+1) if(my_buttons[j].cget('variable') == 1)
        }
        $answers << ClosedAnswers.new(closed_question,user_answers)
        index +=1
        ask(index,test_questions,count)
      }
      pack('side'=>'top')
    end
  end
end

def ask(index, test_questions,count)
  $f2.destroy if($f2)
  $f2 = TkFrame.new($f1) do
    background "blue"
    pack('expand' => 1,'fill' => 'both','side'=>'bottom')
  end
  question_index = rand(test_questions.length)
  question = test_questions[question_index]
  test_questions.delete_at(question_index)
  if (question.class == ClosedQuestion) then
    closed_ask(index,question,test_questions,count)
  else
    open_ask(index,question,test_questions,count)
  end
end