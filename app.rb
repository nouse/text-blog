require 'haml'
require 'sinatra'
require 'yaml'
require 'rdiscount'

EXT = ".txt"

class Article
  attr_reader :title, :body

  def initialize(file_path)
    yaml, md = File.read(file_path).split("\n\n", 2)

    @options = YAML.load(yaml)
    @options["file_name"] = File.basename(file_path, EXT).split('-',4)[-1]

    @body = RDiscount.new(md).to_html
  end

  def path
    @options["date"].strftime("/%Y/%m/%d/")+ @options["file_name"]
  end

  def title
    @options["title"]
  end
end

get '/' do
  @articles = []
  Dir.glob("articles/*#{EXT}").each do |article_file|
    @articles << Article.new(article_file)
  end
  haml :index
end

get '/:year/:month/:day/:title' do |year, month, day, title|
  article_file = "articles/#{year}-#{month}-#{day}-#{title.downcase}#{EXT}"
  @article = Article.new(article_file)
  haml :show
end
