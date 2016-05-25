require 'scraping'
require 'minitest/spec'
require 'minitest/autorun'

class TestScraper
  include Scraping

  element :name, '.name'
  element :diddly, '.diddly', as: :diddly
  element :cool_name, '.name' do |node|
    "Cool #{node.text}"
  end

  elements :things, '.things span'
  elements :diddly_things, '.things span', as: :diddly
  elements :cool_things, '.things span' do |node|
    "Cool #{node.text}"
  end

  section :info do
    element :alpha, '.info .alpha'
    section :nested do
      element :beta, '.info .beta'
    end
  end

  section :scoped_info, '.info' do
    element :alpha, '.alpha'
    section :nested do
      element :beta, '.beta'
    end
  end

  sections :stuff, '.stuff li' do
    element :title, 'a'
    element :link, 'a/@href'
    section :nested do
      element :other, 'span'
    end
  end

  private

  def extract_diddly(node)
    "#{node.text}diddly"
  end
end

class TestSubclass < TestScraper
  element :name, '.some-other-node'
end

class ScrapingTest < Minitest::Spec
  let(:file) { File.expand_path '../fixture.html', __FILE__ }
  let(:fixture) { File.read file }
  let(:scraper) { TestScraper.scrape fixture }

  describe '#element' do
    it 'can extract text from a single node' do
      'Ray'.must_equal scraper.name
    end

    it 'can extract text using a block' do
      'Cool Ray'.must_equal scraper.cool_name
    end

    it 'can extract text using an :as extractor' do
      'Zanediddly'.must_equal scraper.diddly
    end
  end

  describe '#elements' do
    it 'extracts an array of text' do
      ['one', 'two'].must_equal scraper.things
    end

    it 'extracts an array using a block' do
      ['Cool one', 'Cool two'].must_equal scraper.cool_things
    end

    it 'extracts an array using an extractor' do
      ['onediddly', 'twodiddly'].must_equal scraper.diddly_things
    end
  end

  describe '#section' do
    it 'extracts a nested node' do
      'one'.must_equal scraper.info.alpha
    end

    it 'extracts a nested node with scoping' do
      'one'.must_equal scraper.scoped_info.alpha
    end

    it 'extracts a nested node with nesting' do
      'two'.must_equal scraper.info.nested.beta
    end
  end

  describe '#sections' do
    it 'extracts an array of structs' do
      'one'.must_equal scraper.stuff.first.title
      'yahoo.com'.must_equal scraper.stuff.last.link
    end

    it 'extracts an array of structs with nesting' do
      '2'.must_equal scraper.stuff.last.nested.other
    end
  end

  describe '.inherited' do
    it 'prevents mutation of the superclass' do
      '.name'.must_equal TestScraper.rules[:name].selector
    end

    it 'keeps the superclasses rules' do
      '.some-other-node'.must_equal TestSubclass.rules[:name].selector
      '.diddly'.must_equal TestSubclass.rules[:diddly].selector
    end
  end
end
