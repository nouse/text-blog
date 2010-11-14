require 'haml'
require 'sinatra'
require 'yaml'
require 'rdiscount'

EXT = ".txt"

class Article
  attr_reader :title, :body, :date

  def initialize(file_path)
    yaml, md = File.read(file_path).split("\n\n", 2)

    @options = YAML.load(yaml)
    @options["slug"] = File.basename(file_path, EXT).split('-',4)[-1]

    @body = RDiscount.new(md).to_html
  end

  def path
    @options["date"].strftime("/%Y/%m/%d/")+ @options["slug"]
  end

  %w(title date slug).each do |m|
    class_eval "def #{m};@options['#{m}'];end"
  end
end

configure do
  ALL_ARTICLES = Dir.glob("articles/*#{EXT}").map do |article_file|
    Article.new(article_file)
  end
end

get '/' do
  @articles = ALL_ARTICLES
  haml :index
end

get '/:year/:month/:day/:slug' do |year, month, day, slug|
  @article = ALL_ARTICLES.find do |article| 
    article.date == Date.civil(year.to_i, month.to_i, day.to_i) &&
      article.slug == slug
  end

  halt 404 unless @article
                               
  haml :show
end
