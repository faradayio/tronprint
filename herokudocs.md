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

## Sinatra Configuration

In your app.rb, add:

    require 'tronprint'
    require 'mongo'

[TronprintHelper](http://rubydoc.info/github/brighterplanet/tronprint/master/TronprintHelper) is Rails 3 specific, but if demand for a Sinatra-compatible helper module arises, we will make one. For now, you can use the source of TronprintHelper to help you display your footprint.

## Configuring Tronprint

If you are using Heroku and choose to use a different datastore than MongoHQ, or you are not an Heroku and you choose to use an adapter different than the default yaml datastore, you'll need to configure Tronprint when your application initializes. In Rails, Tronprint's aggregator (the interface to the key/value store) can be initialized in config/initializers/tronprint.rb:

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


