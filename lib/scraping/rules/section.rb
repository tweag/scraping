require 'ostruct'

module Scraping
  module Rules
    class Section
      include DSL
      attr_reader :name, :selector

      def initialize(name, selector = '.')
        @name = name
        @selector = selector
      end

      def evaluate(&block)
        instance_eval(&block)
        self
      end

      def call(scraper, node)
        rules.inject(OpenStruct.new) do |obj, (name, rule)|
          obj[name] = rule.call scraper, node.at(selector)
          obj
        end
      end
    end
  end
end
