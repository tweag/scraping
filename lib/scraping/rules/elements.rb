require 'ostruct'

module Scraping
  module Rules
    class Elements
      attr_reader :name, :selector, :rule, :options

      def initialize(name, selector, options = {})
        @name = name
        @selector = selector
        @options = options
      end

      def evaluate(&block)
        if block_given?
          @rule = ElementsOf.new(name).evaluate(&block)
        else
          @rule = Element.new(name, '.', options)
        end

        self
      end

      def call(scraper, node)
        node.search(selector).map do |item|
          rule.call(scraper, item)
        end
      end
    end
  end
end
