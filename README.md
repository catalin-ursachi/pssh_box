# PsshBox

A builder for PSSH boxes used in content encryption, as per the specification at https://w3c.github.io/encrypted-media/format-registry/initdata/cenc.html.

The implementation was based on the the Shaka-Packager PSSH tool available at https://github.com/google/shaka-packager/tree/master/packager/tools/pssh. The tool was used to generate & validate the unit test values.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pssh_box'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pssh_box

## Usage

A version 0 PSSH box can be generated with:

```ruby
PsshBox::Builder.build_pssh_box(0, 'edef8ba9-79d6-4ace-a3c8-27dcd51d21ed', pssh_data_bytes)
```

A version 1 PSSH box can be generated with:

```ruby
PsshBox::Builder.build_pssh_box(1, 'edef8ba9-79d6-4ace-a3c8-27dcd51d21ed', pssh_data_bytes, [key_id])
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/catalin-ursachi/pssh_box. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PsshBox project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/pssh_box/blob/master/CODE_OF_CONDUCT.md).
