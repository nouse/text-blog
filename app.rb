require 'haml'
require 'sinatra'
require 'yaml'
require 'rdiscount'

get '/' do
  @articles = []
  Dir.glob("articles/*.txt").each do |article_file|
    @articles << File.read(article_file)
  end
  @parsed = @articles.map do |article|
    yaml, md = article.split("\n\n", 2)
    hash = YAML.load(yaml)
    md = RDiscount.new(md).to_html

    [hash, md]
  end

  haml :index
end

get '/:year/:month/:day/:title' do |year, month, day, title|
  article_file = "articles/#{year}-#{month}-#{day}-#{title.gsub(" ","-").downcase}.txt"
  puts article_file
    article = File.read(article_file)
    yaml, md = article.split("\n\n", 2)
    hash = YAML.load(yaml)
    md = RDiscount.new(md).to_html

    @article = [hash.inspect, md]
    haml :show
end

def to_url(hash)
  "/#{Time.parse(hash["date"]).strftime("%Y/%m/%d")}/#{hash["title"].gsub(" ", "-")}"
end
