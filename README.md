# Handsomefencer::Environment

Obscure your environment files in source control, expose them for deploys.

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

Create a .env directory at the root of your app. In it, place any environment files you'd like to obfuscate in source control:

.env/development.env
.env/staging.env
.env/production.env

Or you can namespace them like so:

.env/production/database.env  

If you aren't using Rails, or don't otherwise already have a config directory, go ahead and create one because we're going to generate a deploy.key to put inside it:

`$ mkdir config`

Then write a ruby script at the root of your project called obfuscate_env.rb and put code like this inside:

```ruby
require 'handsomefencer/environment'
cipher = Handsomefencer::Environment::Crypto.new
cipher.obfuscate
```

Now you should be able to run the script like so:

`$ ruby obfuscate_env.rb`

You should now have a config/deploy.key file as well as an encoded version of each .env file in your .env directory. For example:

.env/development.env
.env/development.env.enc

You may wish to confirm that the deploy key and the .env files have been added to your .gitignore, and also that they are not still cached in your repo.

Next, write a ruby script at the root of your project called expose_env.rb and put code like this inside:

```ruby
require 'handsomefencer/environment'
cipher = Handsomefencer::Environment::Crypto.new
cipher.expose

```

Once your code is on the deploy server, you can either create a deploy key with the correct key inside, or set it as a DEPLOY_KEY environment variable. Then you can expose the variables with:

`$ ruby expose_env.rb`

## Development

After checking out the repo, run `bundle` to install dependencies. There are some issues with the test_helper loading that I don't understand at the moment, but the tests will run automatically and correctly when saved, after running `bundle exec guard`. 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/schadenfred/handsomefencer-environment.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
