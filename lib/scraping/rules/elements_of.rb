require 'ostruct'

module Scraping
  module Rules
    class ElementsOf
      include DSL
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def evaluate(&block)
        instance_eval(&block)
        self
      end

      def call(scraper, node)
        rules.inject(OpenStruct.new) do |obj, (name, rule)|
          obj[name] = rule.call(scraper, node)
          obj
        end
      end
    end
  end
end
