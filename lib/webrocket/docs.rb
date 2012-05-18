require 'singleton'

module WebRocket
  class Docs
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
        content = lines.join
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
end
