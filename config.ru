# -*- ruby -*-
$LOAD_PATH.unshift(File.expand_path('../lib/', __FILE__))
require 'sinatra'
require 'webrocket/docs'

RACK_ENV = ENV['RACK_ENV'] || 'development'
ROOT_PATH = File.dirname(__FILE__);
DOCS_PATH = File.join(ROOT_PATH, 'docs/')
WEBROCKET_VERSION = ENV['WEBROCKET_VERSION']

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
$docs = WebRocket::Docs.load

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

  $docs = WebRocket::Docs.load if RACK_ENV.to_s != 'production'
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

not_found do
  File.read(File.join(settings.public_folder, '404.html'))
end

run Sinatra::Application
