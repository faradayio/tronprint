# Tronprint

Tronprint tracks the carbon footprint of your web application, provided by [Brighter Planet](http://brighterplanet.com).

## Deploying to Heroku

Tronprint requires a persistent datastore to store your application's usage statistics. Any datastore supported by [moneta](http://github.com/dkastner/moneta) will work. The easiest datastore to use with Heroku is MongoHQ.

To install MongoHQ:

    $ heroku addons:add mongohq:free

Once you have chosen a datastore, install the tronprint add-on:

    $ heroku addons:add tronprint:commercial

Depending on what Ruby web framework you're using, follow the relevant directions below.

## Rails 3 Configuration

Add Tronprint and mongo (if using MongoHQ) to your Gemfile:

    # Gemfile
    # ...
    gem 'tronprint'
    gem 'mongo'

Somewhere in your views, you can use the methods provided in [TronprintHelper](http://rubydoc.info/github/brighterplanet/tronprint/master/TronprintHelper) to display the site's total footprint, a link to the foot print calculation's methodology, and a CM1 badge.

In whichever controller(s) that will use TronprintHelper (or in `ApplicationController`), simply require the helper:

    class FoosController
      helper TronprintHelper
    end

### Helper Methods

TronprintHelper comes with a few helper methods:

* `footprint_badge` - A badge that displays total footprint and current rate of emissions for your app.
* `cm1_badge` - Displays a CM1 badge
* `footprint_methodology` - A URL for a live methodology statement reporting how your total footprint was calculated. {Example}[http://impact.brighterplanet.com/computations?duration=128372]

### Rails with ActiveRecord

If you'd like to use your Rails app's existing ActiveRecord datastore for 
storing Tronprint statistics, simply add the following to a new file, 
config/initializers/tronprint.rb:

    Tronprint.aggregator_options = { :adapter => :active_record }

Tronprint automatically creates a storage table, `moneta_store` the next time your app
is run.

If you need to create the table manually, add to your Rakefile:

    require 'tronprint/rake_tasks/active_record'

And run `rake tronprint:moneta`

## Sinatra Configuration

In your app.rb, add:

    require 'tronprint'
    require 'mongo'

[TronprintHelper](http://rubydoc.info/github/brighterplanet/tronprint/master/TronprintHelper) is Rails 3 specific, but if demand for a Sinatra-compatible helper module arises, we will make one. For now, you can use the source of TronprintHelper to help you display your footprint.

## Configuring Tronprint

If you choose to use a different datastore than MongoHQ, you'll need to configure Tronprint when your application initializes. In Rails, Tronprint's aggregator (the interface to the key/value store) can be initialized in config/initializers/tronprint.rb:

    Tronprint.aggregator_options = {
      :adapter => :my_adapter,
      :configuration_setting_a => 'foo',
      :configuration_setting_b => 'bar'
    }


## Support

Support is available from Brighter Planet at the following locations:

* via IRC at #brighterplanet on Freenode during normal US business hours.
* via [Twitter](http://twitter.com/brighterplanet)
* via [Email](mailto:support@brighterplanet.com)


