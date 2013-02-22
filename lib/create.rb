require "tk"
require 'test'
class GraficInterface
  def self.more_entrys
    entry = TkEntry.new($f2) do
      pack('fill' => 'both')
    end
    variable = TkVariable.new
    entry.textvariable = variable
    variable.value = "Answer"
    $answers.push(variable)
  end

  def self.correct_entrys(*buttons)
    buttons.map! { |x| x.destroy }
    entry = TkEntry.new($f2) do
      pack('fill' => 'both','padx'=>0, 'pady'=>10)
    end
    variable = TkVariable.new
    entry.textvariable = variable
    variable.value = "Correct"
    $correct = variable
  end

  def self.closed
    $answers = []
    $correct = []
    $tag = 1
    $f2.destroy if($f2)
    $f2 = TkFrame.new($root) {
      background "green"
      pack('expand' => 1,'fill' => 'both','side'=>'top')
    }
    entry1 = TkEntry.new($f2) do
      justify 'left'
      width 25
      pack('fill' => 'both','side'=>'top')
    end
    $variable1 = TkVariable.new
    entry1.textvariable = $variable1
    $variable1.value = "Question"
    entry2 = TkEntry.new($f2) do
      justify 'left'
      width 25
      pack('fill' => 'both','side'=>'top')
    end
    variable = TkVariable.new
    entry2.textvariable = variable
    variable.value = "Answer"
    $answers.push(variable)
    more =  TkButton.new($f2) do
      text "More Answers"
      command { GraficInterface.more_entrys }
      pack('side'=>'bottom','padx'=>0, 'pady'=>10)
    end
    correct_button = TkButton.new($f2) do
      text "Correct Answers"
      pack('side'=>'bottom','padx'=>0, 'pady'=>10)
    end
    correct_button.command {GraficInterface.correct_entrys(correct_button,more)}
  end

  def self.open
    $answers = []
    $tag = 0
    $f2.destroy if($f2)
    $f2 = TkFrame.new($root) {
      background "green"
      pack('expand' => 1,'fill' => 'both','side'=>'top')
    }
    entry1 = TkEntry.new($f2) do
      justify 'left'
      width 25
      pack('fill' => 'both','side'=>'top')
    end
    $variable1 = TkVariable.new
    entry1.textvariable = $variable1
    $variable1.value = "Question"
    entry2 = TkEntry.new($f2) do
      justify 'left'
      width 25
      pack('fill' => 'both','side'=>'top')
    end
    variable2 = TkVariable.new
    entry2.textvariable = variable2
    variable2.value = "Answer"
    $answers.push(variable2)
    more =  TkButton.new($f2) do
      text "More Answers"
      command { GraficInterface.more_entrys }
      pack('side'=>'bottom','padx'=>0, 'pady'=>10)
    end
  end

  def self.create
    $questions = []
    $answers = []
    $correct = []
    $tag = -1
    $f1.destroy if($f1)
    $f2.destroy if($f2)
    $f1 = TkFrame.new($root) {
      background "red"
      pack('expand' => 1,'fill' => 'both')
    }
    TkButton.new($f1) do
      text "Finish"
      command {
          if($questions == []) then
            Tk.messageBox(
              'type' => "ok",
              'icon' => "warning",
              'message' => "You have not entered any questions!"
            )
            return
          end
          directory = Tk.getSaveFile
          if(directory == "") then
            Tk.messageBox(
              'type' => "ok",
              'icon' => "warning",
              'message' => "No such directory!"
            )
            return
          end
          Test.new($questions).creat_file(directory)
          $f1.destroy
      }
      pack('side'=>'bottom','padx'=>0, 'pady'=>0)
    end
    TkButton.new($f1) do
      text "Closed Question"
      command { GraficInterface.closed }
      pack('side'=>'bottom','padx'=>0, 'pady'=>0)
    end
    TkButton.new($f1) do
      text "Opened Question"
      command { GraficInterface.open}
      pack('side'=>'bottom','padx'=>0, 'pady'=>0)
    end
    TkButton.new($f1) do
      text "Save Qestion"
      command {
          if($tag == 1) then
            if($correct == []) then
              Tk.messageBox(
                'type' => "ok",
                'icon' => "warning",
                'message' => "You have not entered the correct answers!"
              )
              return
            end
            $questions << ClosedQuestion.new($variable1.value,$answers.map{|x| x.value},
                                              $correct.value.split(/,* */).map{|x| x.ord - 64})
          else
            $questions << OpenQuestion.new($variable1.value,$answers.map{|x| x.value}) if($tag == 0)
          end
          $tag = -1
          $f2.destroy
      }
      pack('side'=>'bottom','padx'=>0, 'pady'=>0)
    end
  end
end