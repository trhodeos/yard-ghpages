# Yard::GHPages

A simple set of Rake tasks that generates Yard docs and publishes them to github
pages.

## Installation

Add this line to your application's Gemfile:

    gem 'yard-ghpages'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yard-ghpages

## Usage

This gem exposes two new rake tasks: `yard:build` and `yard:publish`.

To use this gem, build the yard docs first.
```
rake yard:build
```

Commit the changes.
```
git commit -am 'Update yard docs'
```

Publish the docs to github pages.
```
rake yard:publish
```

Easy as that!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
