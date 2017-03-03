# KupongIntegration

This is a gem for creating and sending text vouchers through the kupong.se's API. Kupong.se is a platform for the distribution of digital coupons. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kupong_integration'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kupong_integration

## Usage

### Initlialize

```ruby
# ./confic/initializers/kupong_integration.rb

KupongIntegration.config(api_url: 'https://to.kupong.se/api')
```
If you don't initialize the KupongIntegration, it will use the default API-URL, which is currently: `http://api.kupong.se/v1.5/coupons`. 

### Send Voucher
```ruby
service = KupongIntegration::Service.new(settings:, phone:)
service.call
```

The needed keys in configs are stored in `KupongIntegration::Service::SETTINGS_ATTRIBUTES`, which contains `authorization`, `coupon_id` and `proxy`. 

The phone number gets automatically sanitized and the country code (`KupongIntegration::Service::COUNTRY_CODE`) is been added, if it's not part of the phone number already. 

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/edenspiekermann/kupong_integration. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

