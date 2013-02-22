require "tk"
require 'generate_test'
class GraficInterface
  def self.generate
    $directory_from = ""
    $directory_to = ""
    $f1.destroy if($f1)
    $f1 = TkFrame.new($root) do
      background "red"
      pack('expand' => 1,'fill' => 'both','side'=>'bottom')
    end
    entry1 = TkEntry.new($f1) do
      justify 'left'
      width 10
      pack('side'=>'top')
    end
    count = TkVariable.new
    entry1.textvariable = count
    count.value = 0
    entry2 = TkEntry.new($f1) do
      justify 'left'
      width 10
      pack('side'=>'top')
    end
    title = TkVariable.new
    entry2.textvariable = title
    title.value = "Title"
    $directory_from = TkVariable.new
    $directory_from.value = ""
    TkButton.new($f1) do
      text "From Test"
      pack('side'=>'top')
      command {$directory_from.value = Tk.getOpenFile}
    end
    entry3 = TkEntry.new($f1) do
      state 'disabled'
      width 15
      pack('side'=>'top','padx'=>0, 'pady'=>2)
    end
    entry3.textvariable = $directory_from
    $directory_to = TkVariable.new
    $directory_to.value = ""
    TkButton.new($f1) do
      text "Save Test In"
      pack('side'=>'top')
      command {$directory_to.value = Tk.getSaveFile('defaultextension'=> "pdf")}
    end
    entry4 = TkEntry.new($f1) do
      textvariable $directory_to
      state 'disabled'
      width 15
      pack('side'=>'top','padx'=>0, 'pady'=>2)
    end
    entry4.textvariable = $directory_to
    $directory_answers = TkVariable.new
    $directory_answers.value = ""
    TkButton.new($f1) do
      text "Save Answers In"
      pack('side'=>'top')
      command {$directory_answers.value = Tk.getSaveFile('defaultextension'=> "pdf")}
    end
    entry5 = TkEntry.new($f1) do
      state 'disabled'
      width 15
      pack('side'=>'top','padx'=>0, 'pady'=>2)
    end
    entry5.textvariable = $directory_answers
    TkButton.new($f1) do
      text "Save "
      pack('side'=>'top','padx'=>0, 'pady'=>10)
      command {
        if($directory_from.value =="") then
          Tk.messageBox(
            'message' => "You have not choosen a test!\n",
            'type' => 'ok',
            'icon' => 'warning'
          )
          return
        end
        if($directory_to.value == "") then
          Tk.messageBox(
            'message' => "You have not pointed where \nto be saved the test!\n",
            'type' => 'ok',
            'icon' => 'warning'
          )
          return
        end
        test = Test.load($directory_from.value)
        Generate.create(test,count.value.to_i,$directory_to.value,$directory_answers.value,title.value)
        $f1.destroy
      }
    end
  end
end