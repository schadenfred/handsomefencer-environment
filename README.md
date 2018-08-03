# Handsomefencer::Environment

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/handsomefencer/environment`. To experiment with that code, run `bin/console` for an interactive prompt.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'handsomefencer-environment'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install handsomefencer-environment

## Usage

I like to keep environment variables out of source control. But I also like deploying from circleci, which means I have to get those variables from my local machine into circleci. That can kind of be a pain. With this gem you can .gitignore all your environment files, push to source control, and then when circleci pulls your code to run it for a deploy, all you need is to set one variable equal to whatever password you used to obfuscate your environment files. In a rails 5.2 app, you can use config/master.key.

From the root of your

## Development

After checking out the repo, run `bundle` to install dependencies. Then, run `guard` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/schadenfred/handsomefencer-environment. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Handsomefencer::Environment project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/schadenfred/handsomefencer-environment/blob/master/CODE_OF_CONDUCT.md).
