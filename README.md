# Guard::Coffeelint

Coffeelint plugin for Guard

## Installation

Add this line to your application's Gemfile:

    gem 'guard-coffeelint'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install guard-coffeelint

## Usage

1. Create and customize your config file:

  ```
  coffeelint --makeconfig > config/coffeelint.json
  ```

  By default guard-coffeelint will look in `config/coffeelint.json`,
  but you can override the location with `:config_file` in your Guardfile.

2. Add Coffeelint to your Guardfile:

  ```ruby
   # Lint CoffeeScript files on change
  guard :coffeelint do
    watch %r{^app/assets/javascripts/.*\.coffee$}
  end
  ```
 
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
