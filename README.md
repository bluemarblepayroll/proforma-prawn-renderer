# Proforma Prawn Renderer

[![Gem Version](https://badge.fury.io/rb/proforma-prawn-renderer.svg)](https://badge.fury.io/rb/proforma-prawn-renderer) [![Build Status](https://travis-ci.org/bluemarblepayroll/proforma-prawn-renderer.svg?branch=master)](https://travis-ci.org/bluemarblepayroll/proforma-prawn-renderer) [![Maintainability](https://api.codeclimate.com/v1/badges/c7807c3864ca2c32e244/maintainability)](https://codeclimate.com/github/bluemarblepayroll/proforma-prawn-renderer/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/c7807c3864ca2c32e244/test_coverage)](https://codeclimate.com/github/bluemarblepayroll/proforma-prawn-renderer/test_coverage) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[Proforma](https://github.com/bluemarblepayroll/proforma) ships with a basic plain-text renderer.  Luckily we can plug in different rendering engines to provide additional business value.  This library gives Proforma the ability to render PDF's instead of simple plain-text.

## Installation

To install through Rubygems:

````
gem install install proforma-prawn-renderer
````

You can also add this to your Gemfile:

````
bundle add proforma-prawn-renderer
````

Note: If you are using bundler for auto-requiring then you need to specify as:

```
gem 'proforma-prawn-renderer', require: 'proforma/prawn_renderer'
```

## Examples

### Connecting to Proforma Rendering Pipeline

To use this plugin within Proforma:

1. Install [Proforma](https://github.com/bluemarblepayroll/proforma)
2. Install this library
3. Require both libraries
4. Pass in an instance of Proforma::PrawnRenderer into the Proforma#render method

````ruby
require 'proforma'
require 'proforma/prawn_renderer'

data = [
  { id: 1, name: 'Chicago Bulls' },
  { id: 2, name: 'Indiana Pacers' },
  { id: 3, name: 'Boston Celtics' }
]

template = {
  title: 'nba_team_list',
  children: [
    { type: 'Header', value: 'NBA Teams' },
    { type: 'Separator' },
    {
      type: 'DataTable',
      columns: [
        { header: 'Team ID #', body: '$id' },
        { header: 'Team Name', body: '$name' },
      ]
    }
  ]
}

documents = Proforma.render(data, template, renderer: Proforma::PrawnRenderer.new)
````

The `documents` attribute will now be an array with one object:

```ruby
expected_documents = [
  {
    contents: "...", # PDF Data
    extension: '.pdf',
    title: 'nba_team_list'
  }
]
```

The `contents` attribute will contain the native PDF data.

### Prawn Customization

All options for Prawn are passed through the Util::Options object:

Name             | Default | Type
---------------- | ------- | -----------------
bold_font_style  | bold    | symbol or string
header_font_size | 15      | number
text_font_size   | 10      | number
font_name        | nil     | nil or string
fonts            | []      | array of Util::Font objects or hashes with same attribute keys.

You can choose to pass in either a Util::Options instance or a hash with the same attribute keys.  These options will be used during the PDF rendering process.

### Custom Fonts

The fonts option above allows you to specify different fonts to use.  This is particularly useful if you wish to use fonts that better support internationalization.  Here is an example of defining and using a custom font:

````
options = {
  font_name: 'Tuffy',
  fonts: [
    {
      bold_path: File.join('fonts', 'Tuffy_Bold.ttf'),
      name: 'Tuffy',
      normal_path: File.join('fonts', 'Tuffy.ttf')
    }
  ]
}

renderer = Proforma::PrawnRenderer.new(options)

# ...
# Omitted data declaration
# Omitted template declaration
# ...

documents = Proforma.render(data, template, renderer: renderer)
````

Note: Update the paths to reflect the actual locations on your machine/server.

## Contributing

### Development Environment Configuration

Basic steps to take to get this repository compiling:

1. Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/) (check proforma-prawn-renderer.gemspec for versions supported)
2. Install bundler (gem install bundler)
3. Clone the repository (git clone git@github.com:bluemarblepayroll/proforma-prawn-renderer.git)
4. Navigate to the root folder (cd proforma)
5. Install dependencies (bundle)

### Running Tests

To execute the test suite run:

````
bundle exec rspec spec --format documentation
````

Alternatively, you can have Guard watch for changes:

````
bundle exec guard
````

Also, do not forget to run Rubocop:

````
bundle exec rubocop
````

### Publishing

Note: ensure you have proper authorization before trying to publish new versions.

After code changes have successfully gone through the Pull Request review process then the following steps should be followed for publishing new versions:

1. Merge Pull Request into master
2. Update `lib/proforma/prawn_renderer/version.rb` using [semantic versioning](https://semver.org/)
3. Install dependencies: `bundle`
4. Update `CHANGELOG.md` with release notes
5. Commit & push master to remote and ensure CI builds master successfully
6. Run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

This project is MIT Licensed.
