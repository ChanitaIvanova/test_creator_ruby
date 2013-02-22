libdir = './lib'
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
describe OpenAnswers do
  let(:question){OpenQuestion.new("Which main character in Stargate SG1 wears glasses?",["Dr. Daniel Jackson","Daniel Jackson"])}
  let(:answer){OpenAnswers.new(question,"Daniel Jackson")}
  it 'creates open answers when the answer is correct' do
    answer.tag.should eq true
    answer.response.should eq "Which main character in Stargate SG1 wears glasses?\nCorrect!\n\n"
  end
  let(:answer2) {OpenAnswers.new(question,"Teal'c")}
  it 'creates open answers when the answer is wrong' do
    answer2.tag.should eq false
    answer2.response.should eq ("Which main character in Stargate SG1 wears glasses?\nWRONG! \nPossible answer\\s:\n\n" +
                                "A: Dr. Daniel Jackson\n\nB: Daniel Jackson\n\nYour answer:\nTeal'c\n\n")
  end
end
describe ClosedAnswers do
  let(:question) {ClosedQuestion.new("Which main character in Stargate SG1 wears glasses?",["Dr. Daniel Jackson","Teal'c", "Samantha Carter"],[1])}
  let(:answer) {ClosedAnswers.new(question,[1])}
  it 'creates closed answers when the answer is correct' do
    answer.tag.should eq true
    answer.response.should eq "Which main character in Stargate SG1 wears glasses?\nCorrect!\n\n"
  end
  let(:answer2) {ClosedAnswers.new(question,[2])}
  it 'creates closed answers when the answer is wrong' do
    answer2.tag.should eq false
    answer2.response.should eq ("Which main character in Stargate SG1 wears glasses?\nWRONG! \nCorrect answer\\s:\n" +
                                  "A: Dr. Daniel Jackson\n\n\nYour answer\\s:\nB: Teal'c\n")
  end
end
  