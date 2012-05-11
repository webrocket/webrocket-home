# -*- ruby -*-
require 'sinatra'
require 'singleton'

RACK_ENV = ENV['RACK_ENV'] || 'development'
ROOT_PATH = File.dirname(__FILE__);
WEBROCKET_VERSION = ENV['WEBROCKET_VERSION']

class Docs
  DOCS_PATH = File.join(ROOT_PATH, 'docs/')
  
  module Helpers
    def remove_weights(path)
      path.gsub(/\d{2}\-/, '')
    end
  end

  class Section < Array
    attr_reader :path, :title

    def self.load(path)
      title = File.read(File.join(DOCS_PATH, path, '.section')) rescue return
      new(title, path)
    end

    def initialize(title, path)
      super()
      @title, @path = title, path
    end
  end

  class Page < String
    include Helpers

    attr_reader :title, :slug

    def self.load(path)
      lines = File.read(File.join(DOCS_PATH, path)).split(/$/)
      title, _ = *lines.shift(2)
      content = lines.join("\n")
      new(title, content, path)
    end

    def initialize(title, content, path)
      @title, @slug = title, remove_weights(path).split('.')[0]
      super(content)
    end
  end

  include Helpers

  attr_reader :sections, :routes

  def self.load
    new.load
  end

  def load
    find_all_sections
    find_all_pages
    load_sections
    load_pages
    self
  end

  def [](slug)
    routes[slug]
  end

  def load_sections
    @sections = @found_sections.map { |section| Section.load(section) }
  end

  def load_pages
    @routes = {}
    
    @found_pages.each do |path|
      page = Page.load(path) or next
      section = @sections.find { |s| s.path == File.dirname(path) }
      section << page

      slug = remove_weights(path).split('.')[0]
      @routes[slug] = page
    end
  end

  def find_all_pages
    glob = File.join(DOCS_PATH, '*/*.md')
    @found_pages = Dir[glob].map { |path| relative_path(path) }.sort
  end

  def find_all_sections
    glob = File.join(DOCS_PATH, '*/.section')
    @found_sections = Dir[glob].map { |path| File.dirname(relative_path(path)) }.sort
  end

  def relative_path(path)
    path.gsub(/^#{DOCS_PATH}/, '')
  end
end

set :public_folder, File.join(ROOT_PATH, 'public');
set :views, File.join(ROOT_PATH, 'views');

$pages = {
  'faq' => {
    :section => 'FAQ',
    :classes => ['white'],
  },
  'download' => {
    :section => 'Download',
    :classes => ['white'],
  },
  'code' => {
    :section => 'Code',
    :classes => ['white'],
  },
  'docs' => {
    :section => 'Docs',
    :classes => ['white'],
  },
  'crew' => {
    :section => 'Crew',
    :classes => ['white'],
  },
  'support' => {
    :section => 'Support',
    :classes => ['white'],
  }
}

$latest_server_version = WEBROCKET_VERSION
$docs = Docs.load

helpers do
  def setup_page_info!
    info = $pages.fetch(@page, {})
    @section = info[:section]
    @classes = info[:classes].to_a.join
  end
end

get '/' do
  @page = 'index'
  erb :index
end

get '/docs/*' do
  @page = 'docs'

  $docs = Docs.load if RACK_ENV.to_s == 'development'
  slug = params[:splat].join('/').gsub(/\/$/, '')
  @content = markdown $docs[slug].to_s unless slug.empty?
  
  setup_page_info!
  erb :docs
end

get '/*/' do
  path  = params[:splat]
  @page = path.join.gsub('/', '-')
  
  setup_page_info!
  erb(path.join.to_sym) rescue pass
end

run Sinatra::Application
