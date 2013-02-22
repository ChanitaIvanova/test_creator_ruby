describe Test do
  let(:question){OpenQuestion.new("Which main character in Stargate SG1 wears glasses?",["Dr. Daniel Jackson","Daniel Jackson"])}
  let(:question2){ClosedQuestion.new("Which main character in Stargate SG1 wears glasses?",["Dr. Daniel Jackson","Teal'c", "Samantha Carter"],[1])}
  let(:test) {Test.new([question,question2])}
  it 'creates tests' do
    test.questions.length.should eq 2
    test.questions[0].should eq question
    test.questions[1].should eq question2
  end
  it 'creates test files' do
    test.creat_file("C:/Ruby193/Project/UnitTests/Test")
    File.exist?("C:/Ruby193/Project/UnitTests/Test").should eq true
    file = File.open('C:/Ruby193/Project/UnitTests/Test',"r")
    text = file.readlines(nil)
    text.join("\n").should eq TEST
  end
  let(:test2){Test.load('C:/Ruby193/Project/UnitTests/Test')}
  it 'loads tests from file' do
    test2.questions.length.should eq 2
    test2.questions[0].question.should eq question.question
    test2.questions[1].question.should eq question2.question
    test2.questions[0].answers.should eq question.answers
    test2.questions[1].answers.should eq question2.answers
    test2.questions[1].correct.should eq question2.correct
  end
end
TEST ="QU: Q O: Which main character in Stargate SG1 wears glasses? :QOEND 
A O: 
AN: Dr. Daniel Jackson :ANEND
AN: Daniel Jackson :ANEND
 :AOEND :QUEND

QU: Q C: Which main character in Stargate SG1 wears glasses? :QCEND 
A C: 
AN: Dr. Daniel Jackson :ANEND
AN: Teal'c :ANEND
AN: Samantha Carter :ANEND
 :ACEND
 C C: 1  :CCEND :QUEND

"