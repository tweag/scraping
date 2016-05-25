# Scraping

A really simple HTML scraping DSL.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'scraping'
```

And then execute:

    $ bundle

## Usage

#### A simple example

```ruby
class Person
  include Scraping
  element :name, 'h1'
end

person = Person.scrape('<h1>Millard Fillmore</h1>')
person.name #=> 'Millard Fillmore'
```

#### More complex data structures

You can also scrape arrays, objects, and arrays of objects. `elements` and `elements_of` can be deeply nested.

```ruby
class YouCan
  include Scraping

  elements :scrape, '.scrape'

  sections :also_scrape, '.also-scrape li' do
    element :name, 'a'
    element :link, 'a/@href'
    elements :numbers, 'span'
  end

  section :nested_scrape do
    element :data, '.data'
  end
end

you_can = YouCan.scrape(<<-EOF)
  <p class="scrape">
    <span>Arrays</span>
    <span>Too</span>
  </p>

  <ul class="also-scrape">
    <li>
      <a href="example.com">Meek Mill</a>
      <span>1</span>
      <span>2</span>
    </li>
    <li><a href="test.com">Drake</a></li>
  <ul>

  <p class="data">Beef</p>
EOF

you_can.scrape #=> ['Arrays', 'Too']

you_can.also_scrape.first.name #=> 'Meek Mill'
you_can.also_scrape.first.link #=> 'example.com'
you_can.also_scrape.first.numbers #=> ['1', '2']

you_can.nested_scrape.data #=> 'Beef'
```

#### Customizing extraction

Any block given to `#element` will allow you to customize the value extracted from the found node.

Using `as: :something` would call a method named `#extract_something`.

```ruby
class Advanced
  element :first_name, '.name' do |node|
    node.text.split(', ').first
  end

  element :birthday, '.birthday', as: :date

  private

  def extract_date(node)
    Date.parse(node.text)
  end
end

advanced = Advanced.new(<<-EOF)
  <h1 class="name">Millard Fillmore</h1>
  <h2 class="birthday">7-1-1800</h2>
EOF

advanced.first_name #=> 'Millard'
advanced.birthday #=> #<Date: 1800-01-07>
```

## HTTP

Scraping is totally agnostic of HTTP, but if you need a suggestion, check out [HTTParty](https://github.com/jnunemaker/httparty).

```ruby
class HackerNews
  include HTTParty
  include Scraping

  base_uri 'https://news.ycombinator.com'
  elements :stories, '.athing .title > a'

  def self.scrape
    super get('/').body
  end
end

news = HackerNews.scrape
puts news.stories.inspect
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/promptworks/scraping.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
