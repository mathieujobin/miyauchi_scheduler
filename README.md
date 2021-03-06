# MiyauchiScheduler
[![Build Status](https://secure.travis-ci.org/mathieujobin/miyauchi_scheduler.png?branch=master)](http://travis-ci.org/mathieujobin/miyauchi_scheduler) [![Coverage Status](https://coveralls.io/repos/mathieujobin/miyauchi_scheduler/badge.png)](https://coveralls.io/r/mathieujobin/miyauchi_scheduler)


Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/miyauchi_scheduler`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'miyauchi_scheduler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install miyauchi_scheduler

## Usage

```ruby
horaire = MiyauchiScheduler.new
horaire.add_worker "Joe", 22
horaire.add_worker "Pete", 28
horaire.add_worker "Jack", 16
horaire.add_worker "Bob", 13
cal = horaire.generate_calendar
cal.print
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mathieujobin/miyauchi_scheduler. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

