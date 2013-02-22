libdir = './lib'
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
require 'test'
require 'generate_test'
class TestCreatorInterface

  def execute(line)
    case line
      when /^creat\s+(.+)\s*$/ then creat_test($1)
      when /^start\s+(.+?)\b\s*(\d*)\s*$/ then
        if !(File.exist? $1) then print "There isn't such test!\n"
          return
        end
        if $2 != "" then test(Test.load($1),$2.to_i)
        else
        test(Test.load($1))
        end
      when /^generate\s+(.+?)\b\s*(\d*)\s*$/ then
        if $2 != "" then generate($1,$2.to_i)
        else
        generate($1)
        end
      when 'help' then help
      when 'exit' then raise StopIteration
      else raise 'Not valid command! Try typeing \'help\''
    end
    rescue StopIteration
      raise
    rescue => e
      puts "ERROR:  #{e.message}"
  end

  def creat_test(address)
    if (File.exist? address) then 
      print "This file allready exists!\nWould you like to change it?[yes|[no]"
      command = gets.chomp
      if(command == 'no') then return end
    end
    questions =[]
    print "When you've given all the answers you wanted write
\"last\" as an answer and you will go back to creating your next question
or you will have to write witch are the correct answers if you are craeting
a closed question.
Write help for other information.\n"
    loop do
      print '~~'
      command = gets.chomp
      case command
        when /\s*closed\s*/ then questions << creat_closed_question
        when /\s*open\s*/ then questions << creat_open_question
        when /\s*finish\s*/ then break
        when /\s*exit\s*/ then exit(0)
        when /\s*help\s*/ then help
        else print "Not valid command! Try typeing 'help'\n"
      end
    end
    Test.new(questions).creat_file(address)
  end
#with this function the user could create a closed question
#the user inputs a question, answers and correct answers
#and the function creates a ClosedQuestion to put in the test
#that the user is creating
  def creat_closed_question
    print "Write question:\n~~" 
    question = gets.chomp
    print "Write Answers:\n"
    optians = 65
    answers=[]
    loop do
      print optians.chr + ": "
      optians +=1
      answer= gets.chomp
      break if answer == 'last'
      answers << answer
    end
    print "Correct answers\n~~"
    correct = gets.chomp
    correct = correct.split(/,* */)
    correct = correct.map{|x| x.ord - 64}
    ClosedQuestion.new(question,answers,correct)
  end
#with this function the user could create an open question
#the user inputs a question and possible answers 
#and the function creates an OpenQuestion to put in the test
#that the user is creating
  def creat_open_question
    print "Write question:\n~~" 
    question = gets.chomp
    print "Write Answers:\n"
    optians = 65
    answers=[]
    loop do
      print optians.chr + ": "
      optians +=1
      answer= gets.chomp
      break if answer == 'last'
      answers << answer
    end
    OpenQuestion.new(question,answers)
  end
#open_ask is given an open question
#it prints the question 
#and takes the user's answer
#then it produces an OpenAnswer
#so that a response could be given to the user
  def open_ask(open)
    print open.question + "\n"
    user_answer = gets.chomp
    OpenAnswers.new(open,user_answer)
  end
#closed_ask is given a closed question
#it prints the question and the answers
#so that the user could see them
#and takes the user's answer
#then it produces a ClosedAnswer
#so that a response could be given to the user
  def closed_ask(closed)
    print closed.question + "\n"
    options = 65
    closed.answers.map{ |x| print options.chr + ": " + x + "\n" 
      options +=1
     }
    user_answer = gets.chomp
    user_answer = user_answer.split(/,* */)
    user_answer = user_answer.map{|x| x.ord - 64}
    ClosedAnswers.new(closed,user_answer)
  end
#ask helps find out what kind of question
#is going to be asked the user -open or closed
  def ask(question)
    return closed_ask(question) if question.is_a? ClosedQuestion
    open_ask(question)
  end
#test() randomly takes $count questions from $test
#and asks the user. For each question test()
#saves the users answer in array answers and after all the 
#questions are answerd it prints statistics about the correct
#and wrong answers. 
  def test(test,count = test.questions.length)
    count = test.questions.length if count > test.questions.length
    test_questions = []
    answers =[]
    test.questions.map{ |x| test_questions << x }
    1.upto(count){ |x|
      print "#{x}: "
      index = rand(test_questions.length)
      question = test_questions[index]
      test_questions.delete_at(index)
      answer = ask(question)
      answers<<answer
    }
    wrong = 0
    answers.each_index{ |x| 
      puts "#{x +1 } " + answers[x].response
      wrong +=1 if !answers[x].tag
    }
    print "You gave #{count - wrong} correct answer\\s and #{wrong} wrong answer\\s!\n"
  end
#generate() takes $count questions from $address which
#is the address of a test and puts them in a text file.
#If is given $title it is put in the begining of the 
#text file. If is given an address for the answers
#in it are saved the corresponding answers to the
#questions put in the text file.
  def generate(address,count=nil)
    if !(File.exist? address) then 
      print "There isn't such test!\n"
      return
    end
    print "Title of the test: "
    title = gets.chomp
    print "Address for the test: "
    address_test = gets.chomp
    if (File.exist? address_test+".pdf") then 
      print "This file allready exists!\nWould you like to change it?[yes|[no]"
      command = gets.chomp
      if(command == 'no') then return end
    end
    print "Address for the answers: "
    address_answers = gets.chomp
    if (File.exist? address_answers + ".pdf") then 
      print "This file allready exists!\nWould you like to change it?[yes|[no]"
      command = gets.chomp
      if(command == 'no') then return end
    end
    test = Test.load(address)
    Generate.create(test,count,address_test,address_answers,title)
  end

  def run
    loop do
      print '>> '
      execute gets.chomp
    end
  end

end
TestCreatorInterface.new.run