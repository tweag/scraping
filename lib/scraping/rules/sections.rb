require 'scraping/rules/section'

module Scraping
  module Rules
    class Sections < Section
      attr_reader :multiselector

      def initialize(name, selector)
        super name, '.'
        @multiselector = selector
      end

      def call(scraper, node)
        node.search(multiselector).map do |item|
          super scraper, item
        end
      end
    end
  end
end
