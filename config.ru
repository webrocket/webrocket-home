# -*- ruby -*-

use Rack::Static,
  :urls  => [''], 
  :root  => 'public',
  :index => 'index.html'

run lambda { |env|
  [
    404, {
      'Content-Type'   => 'text/html',
      'Cache-Control'  => 'public, max-age=86400', 
      'Content-Length' => File.size(error_404).to_s,
      'Last-Modified'  => File.mtime(error_404).httpdate,
    },
    "404: File not found"
  ]
}
