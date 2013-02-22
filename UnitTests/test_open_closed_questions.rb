describe OpenQuestion do
  let(:question){OpenQuestion.new("Which main character in Stargate SG1 wears glasses?",["Dr. Daniel Jackson","Daniel Jackson"])}
  it 'creates open questions' do
    question.question.should eq "Which main character in Stargate SG1 wears glasses?"
    question.answers.length.should eq 2
    question.answers[0].should eq "Dr. Daniel Jackson"
    question.answers[1].should eq "Daniel Jackson"
  end
  
  let(:question2) { OpenQuestion.read(TEST) }
  it 'reads open question from specially formatted text' do
    question2.question.should eq "Which main character in Stargate SG1 dies a lot?"
    question2.answers.length.should eq 2
    question2.answers[0].should eq "Dr. Daniel Jackson"
    question2.answers[1].should eq "Daniel Jackson"
  end
end

describe ClosedQuestion do
  let(:question){ClosedQuestion.new("Which main character in Stargate SG1 wears glasses?",["Dr. Daniel Jackson","Teal'c", "Samantha Carter"],[1])}
  it 'creates closed questions' do
    question.question.should eq "Which main character in Stargate SG1 wears glasses?"
    question.answers.length.should eq 3
    question.answers_count.should eq 3
    question.answers[0].should eq "Dr. Daniel Jackson"
    question.answers[1].should eq "Teal'c"
    question.answers[2].should eq "Samantha Carter"
    question.correct.length.should eq 1
    question.correct[0].should eq 1
  end
  
   let(:question2) { ClosedQuestion.read(TEST) }
  it 'reads closed question from specially formatted text' do
    question2.question.should eq "Which main characters in Stargate SG1 are Air Force?"
    question2.answers.length.should eq 4
    question2.answers_count.should eq 4
    question2.answers[0].should eq "Dr. Daniel Jackson"
    question2.answers[1].should eq "Teal'c"
    question2.answers[2].should eq "Samantha Carter"
    question2.answers[3].should eq "Jack O'Neill"
    question2.correct.length.should eq 2
    question2.correct[0].should eq 3
    question2.correct[1].should eq 4
  end
end
TEST = <<SOMET
Q O: Which main character in Stargate SG1 dies a lot? :QOEND
A O: 
  AN: Dr. Daniel Jackson :ANEND
  AN: Daniel Jackson :ANEND :AOEND
  
Q C: Which main characters in Stargate SG1 are Air Force? :QCEND
A C: 
  AN: Dr. Daniel Jackson :ANEND
  AN: Teal'c :ANEND
  AN: Samantha Carter :ANEND
  AN: Jack O'Neill :ANEND  :ACEND
  C C: 3 4 :CCEND
SOMET