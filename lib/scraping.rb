require 'nokogiri'
require 'scraping/version'
require 'scraping/dsl'
require 'scraping/rules/element'
require 'scraping/rules/elements'
require 'scraping/rules/section'
require 'scraping/rules/sections'

module Scraping
  def self.included(base)
    base.extend ClassMethods

    base.class_eval do
      attr_reader :page
    end
  end

  def initialize(page)
    @page = page
  end

  def scrape
    self.class.rules.each do |name, rule|
      public_send("#{name}=", rule.call(self, page))
    end
  end

  module ClassMethods
    include DSL

    # Make the rules inheritable, but prevent mutation
    # of the original hash
    def inherited(subclass)
      subclass.instance_variable_set(:@rules, rules.clone)
    end

    def element(name, *)
      attr_accessor name
      super
    end

    def elements(name, *)
      attr_accessor name
      super
    end

    def section(name, *)
      attr_accessor name
      super
    end

    def sections(name, *)
      attr_accessor name
      super
    end

    def scrape(html)
      new(Nokogiri::HTML(html)).tap(&:scrape)
    end
  end
end
