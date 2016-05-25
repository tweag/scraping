module Scraping
  module Rules
    class Element
      attr_reader :name, :selector, :options, :extract

      def initialize(name, selector, options = {}, &extract)
        @name = name
        @selector = selector
        @options = options
        @extract = extract if block_given?
      end

      def call(scraper, node)
        item = node.at(selector)

        if item && options[:as]
          scraper.send("extract_#{options[:as]}", item)
        elsif item && extract
          scraper.instance_exec(item, &extract)
        elsif item
          item.text
        end
      end
    end
  end
end
