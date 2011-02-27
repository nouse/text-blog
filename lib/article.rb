require 'tilt'
require 'yaml'
class Article

  class << self
    def load(dir, ext="txt")
      @articles ||= {}
      Dir.glob("#{dir}/**/*.#{ext}").each do |file|
        article = Article.new(file)
        @articles[article.slug] = article
      end
    end

    def [](slug)
      @articles[slug]
    end

    def articles
      @articles.values.sort.reverse
    end
  end

  def initialize(file_path)
    @file_path = file_path

    yaml = File.new(file_path).lines.take_while{ |line| !line.strip.empty? }
    @offset = yaml.length

    @options = YAML.load(yaml.join)
  end

  %w(title date author).each do |m|
    class_eval "def #{m};@options['#{m}'];end"
  end

  def [](key)
    @options[key.to_s]
  end

  def slug
    File.basename(@file_path, ".*")
  end

  def <=>(article)
    self.date <=> article.date
  end

  def body
    Tilt::RDiscountTemplate.new{ content }.render
  end

  def summary
    Tilt::RDiscountTemplate.new{ content[0..100] }.render
  end

  def path
    date = @options['date']
    if slug.start_with? date.strftime("%F")
      slug.split("-",4).join("/")
    else
      "/#{date.strftime("%Y/%m/%d")}/#{slug}"
    end
  end

  def to_hash
    Hash[%w(title date author body).map{ |key| [key.intern, self.send(key)] }]
  end

  def url
    path
  end

  private
  def content
    return @content if instance_variable_defined?("@content")
    File.new(@file_path).lines.drop(@offset).join
  end
end
