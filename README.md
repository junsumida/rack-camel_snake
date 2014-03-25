[![Build Status](https://travis-ci.org/junsumida/rack-camel_snake.svg?branch=master)](https://travis-ci.org/junsumida/rack-camel_snake)
[![Coverage Status](https://coveralls.io/repos/junsumida/rack-camel_snake/badge.png)](https://coveralls.io/r/junsumida/rack-camel_snake)

# Rack::CamelSnake

Rack::CamelSnake is a Rack middleware to convert keys in a json from camelCase into snake_case, and vice versa.

## Requirement

- ruby 2.0.0 or above

## Installation

Add this line to your application's Gemfile:

    gem 'rack-camel_snake', :git => 'https://github.com/junsumida/rack-camel_snake.git'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-camel_snake

## Usage

Please add `use Rack::CamelSnake` to your `config.ru` file. For example, 

```ruby
use Rack::CamelSnake
run YourRackApp
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/rack-camel_snake/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
