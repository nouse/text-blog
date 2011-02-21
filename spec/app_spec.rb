# encoding: UTF-8

require 'spec_helper'

feature "blog" do
  subject { page }
  scenario 'index' do
    visit '/'
    should have_content "A Lucky Day"
  end

  scenario "article" do
    visit '/2010/10/10/a-lucky-day'
    should have_content "A Lucky Day"
    should have_content "今天是我的幸运日"
    should have_content "钱包里面正好有42块钱"
  end

  context "article not found" do
    background {
      visit "/2010/10/10/not-lucky-day"
    }
    its(:status_code) { should == 404 }
  end
end
