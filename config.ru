# -*- ruby -*-
$LOAD_PATH.unshift(File.expand_path('../lib/', __FILE__))
require 'sinatra'
require 'rdiscount'
require 'json'
require 'redis'
require 'webrocket/docs'

RACK_ENV = ENV['RACK_ENV'] || 'development'
ROOT_PATH = File.dirname(__FILE__);
DOCS_PATH = File.join(ROOT_PATH, 'docs/')
WEBROCKET_VERSION = ENV['WEBROCKET_VERSION']

set :public_folder, File.join(ROOT_PATH, 'public');
set :views, File.join(ROOT_PATH, 'views');

$redis = if ENV['REDISTOGO_URL'].to_s == ""
  Redis.new
else
  uri = URI.parse(ENV["REDISTOGO_URL"])
  Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

$pages = {
  'faq' => {
    :section => 'Frequently Asked Questions',
    :classes => ['white'],
  },
  'download' => {
    :section => 'Download',
    :classes => ['white'],
  },
  'code' => {
    :section => 'Get the code',
    :classes => ['white'],
  },
  'docs' => {
    :section => 'Documentation',
    :classes => ['white'],
  },
  'demos' => {
    :section => 'Demos',
    :classes => ['white'],
  },
  'contact' => {
    :section => 'Get in touch',
    :classes => ['white'],
  },  
  'crew' => {
    :section => 'Our awesome crew',
    :classes => ['white'],
  },
  'support' => {
    :section => 'Commercial support',
    :classes => ['white'],
  },
  'terms' => {
    :section => 'Terms of Service',
    :classes => ['white'],
  },
  'cloud' => {
    :section => 'WebRocket in the cloud',
    :classes => ['landing'],
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

VALID_EMAIL = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/

post "/signup" do
  content_type "application/json"
  email = params[:signup_email]

  error = if email =~ VALID_EMAIL
    $redis.hset(:subscribers, email, true)
    nil
  else 
    "This is not valid email address!"
  end

  { "error" => error }.to_json
end

get '/' do
  @page = 'index'
  erb :index
end

get '/docs/' do
  @page = 'docs'
  @content = markdown(:docs_index, :layout => false)

  setup_page_info!
  @classes << ' docs-index'

  erb :docs
end

get '/docs/*' do
  @page = 'docs'

  $docs = WebRocket::Docs.load if RACK_ENV.to_s != 'production'
  slug = params[:splat].join('/').gsub(/\/$/, '')
  doc = $docs[slug] or pass
  @content = markdown doc.to_s
  
  setup_page_info!
  erb :docs
end

get '/cloud/' do
  @page = 'cloud'

  setup_page_info!
  erb(:cloud, :layout => false)
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
