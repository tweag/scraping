module Scraping
  module DSL
    def rules
      @rules ||= {}
    end

    def element(name, selector, options = {}, &block)
      rules[name] = Rules::Element.new(name, selector, options, &block)
    end

    def elements_of(name, &block)
      rules[name] = Rules::ElementsOf.new(name).evaluate(&block)
    end

    def elements(name, selector, options = {}, &block)
      rules[name] = Rules::Elements.new(name, selector, options).evaluate(&block)
    end
  end
end
