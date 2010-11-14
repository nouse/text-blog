require 'rspec'
require 'app'
require 'nokogiri'

$KCODE = 'u'
describe "blog" do
  before do
    @req = Rack::MockRequest.new(Sinatra::Application)
  end
  it "should show index correctly" do
    resp = @req.get '/'
    resp.status.should == 200
    doc = Nokogiri(resp.body)
    (doc/'a[href="/2010/10/10/a-lucky-day"]').text.should == "A Lucky Day"
    resp.body.should match "钱包里面正好有42块钱"
  end
  it "should show article correctly" do
    resp = @req.get '/2010/10/10/a-lucky-day'
    resp.status.should == 200
    doc = Nokogiri(resp.body)
    (doc/'title').text.should == "A Lucky Day"
    resp.body.should match "钱包里面正好有42块钱"
  end
end
