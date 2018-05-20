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

To use this gem, install in the `Rakefile`.
```
require 'yard-ghpages'
Yard::GHPages::Tasks.install_tasks
```

Build the yard docs.
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

## Optional Configuration

Include a file called .yard-gh-pages.yml in the root of your project.

Options:
- source_branch (default: 'master')
  - Branch that should be used to pull the latest directory of generated YARD files
- source_directory (default: 'docs')
  - Directory within the source_branch that contains the generated YARD files
- destination_branch (default: 'gh-pages')
  - Branch within github where the YARD files should be pushed. 'gh-pages' is also the default branch used by Github.

Example file:
```yaml
source_branch: 'master'
source_directory: 'docs'
destination_branch: 'gh-pages'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
