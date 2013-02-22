libdir = './lib'
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
require 'test'
describe Generate do
  let(:test){ Test.load('C:/Ruby193/Project/Tests/StarTrek')}
  let(:address_to){ 'C:/Ruby193/Project/UnitTests/StarTrek.pdf'}
  let(:address_answers) { 'C:/Ruby193/Project/UnitTests/StarTrekAnswers.pdf'}
  it 'generates pdf files with random questions' do
    Generate.create(test,nil,address_to,'','')
    File.exists?(address_to).should eq true
  end
  
  it 'generates pdfs with random questions from test and their answers' do
    Generate.create(test,nil,address_to,address_answers,'')
    File.exists?(address_to).should eq true
    File.exists?(address_answers).should eq true
  end
end