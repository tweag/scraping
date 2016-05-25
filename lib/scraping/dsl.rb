module Scraping
  module DSL
    def rules
      @rules ||= {}
    end

    def element(name, selector, options = {}, &block)
      rules[name] = Rules::Element.new(name, selector, options, &block)
    end

    def elements(name, selector, options = {}, &block)
      rules[name] = Rules::Elements.new(name, selector, options, &block)
    end

    def section(name, selector = '.', &block)
      rules[name] = Rules::Section.new(name, selector).evaluate(&block)
    end

    def sections(name, selector, &block)
      rules[name] = Rules::Sections.new(name, selector).evaluate(&block)
    end
  end
end
