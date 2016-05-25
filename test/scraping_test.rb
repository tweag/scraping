require 'test_helper'

class TestScraper
  include Scraping

  element :name, '.name'
  element :cool_name, '.name' do |node|
    "Cool #{node.text}"
  end

  element :diddly, '.diddly', as: :diddly

  elements_of :info do
    element :alpha, '.alpha'

    elements_of :nested do
      element :beta, '.beta'
    end
  end

  elements :things, '.things span'
  elements :diddly_things, '.things span', as: :diddly

  elements :stuff, '.stuff li' do
    element :title, 'a'
    element :link, 'a/@href'

    elements_of :nested do
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

class ScrapingTest < Minitest::Test
  def setup
    @fixture = File.read fixture_file
    @scraper = TestScraper.scrape @fixture
  end

  def test_element
    assert_equal 'Ray', @scraper.name
  end

  def test_element_block
    assert_equal 'Cool Ray', @scraper.cool_name
  end

  def test_as_extract
    assert_equal 'Zanediddly', @scraper.diddly
  end

  def test_elements_for
    assert_equal 'one', @scraper.info.alpha
  end

  def test_nested_elements_for
    assert_equal 'two', @scraper.info.nested.beta
  end

  def test_elements_simple
    assert_equal ['one', 'two'], @scraper.things
  end

  def test_elements_as_extract
    assert_equal ['onediddly', 'twodiddly'], @scraper.diddly_things
  end

  def test_elements_composed_of_hashes
    assert_equal 'one', @scraper.stuff.first.title
    assert_equal 'yahoo.com', @scraper.stuff.last.link
  end

  def test_elements_composed_of_hashes_nested
    assert_equal '2', @scraper.stuff.last.nested.other
  end

  def test_subclass_does_not_mutate
    assert_equal '.name', TestScraper.rules[:name].selector
    assert_equal '.some-other-node', TestSubclass.rules[:name].selector
    assert_equal '.diddly', TestSubclass.rules[:diddly].selector
  end

  private

  def fixture_file
    File.expand_path '../fixture.html', __FILE__
  end
end
