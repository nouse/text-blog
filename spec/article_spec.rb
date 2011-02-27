# encoding: utf-8

require 'bundler/setup'
require 'rspec'
require 'article'

describe ::Article do
  let(:article) { Article.new(File.dirname(__FILE__)+"/articles/2010-10-10-a-lucky-day.txt") }

  subject { article }

  its(:title) { should == "A Lucky Day" }
  its(:date)  { should == Date.civil(2010,10,10) }
  its(:slug)  { should == "2010-10-10-a-lucky-day" }
  its(:body)  { should == <<-END
<h1>今天是我的幸运日</h1>

<p>早上在地铁门将要关上的那一刻，我冲进了车厢，于是约会没有迟到...</p>

<p>中午提前了一点去港丽，居然只排了42分钟...</p>

<p>晚上又赶上了末班车...</p>

<p>到家数了数，钱包里面正好有42块钱...</p>
END
}
end
