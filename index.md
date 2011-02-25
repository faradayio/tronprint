---
layout: default
---

# What is Tronprint?

[Tronprint](http://github.com/brighterplanet/tronprint) calculates the carbon footprint of a host Ruby application in real-time, *as it's running*.

## Why is this important?

+--
### Tronprint supports:

* Elastic scaling
* Virtualization
* Clustering
* PaaS deploys
=--
{#support}

As applications move to the cloud, infrastructure is virtualized, and platforms provide deeper and deeper levels of abstraction away from the hardware, the question of what physical machine a given application is currently running on is both increasingly hard to determine and increasingly irrelevant.

Tronprint makes applications aware of *their own* carbon footprints. Even when deployed as a swarm of application instances, the applications, enhanced by Tronprint, will collect and aggregate ongoing carbon emissions data at the application level.

> **The Grid: a digital frontier.** I tried to picture clusters of information as they moved through the computer. Ships, motorcycles… Were the circuits like freeways? I kept dreaming of a world I’d never see. And then, one day, I got in!


## Quick start: using Tronprint with a Rails app

In your application's Gemfile:

<figure>
  <figcaption>Gemfile</figcaption>
{% highlight ruby %}
gem 'tronprint'
{% endhighlight %}
</figure>

Followed by:

<figure>
{% highlight console %}
$ bundle install
{% endhighlight %}
</figure>

Add your [Brighter Planet API key](http://keys.brighterplanet.com) in an initializer:

<figure>
  <figcaption>app/initializers/tronprint.rb</figcaption>
{% highlight ruby %}
Tronprint.brighter_planet_key = 'ABC123'
{% endhighlight %}
</figure>

Add the Tronprint helper to your controller(s):

<figure>
  <figcaption>app/controllers/foos_controller.rb</figcaption>
{% highlight ruby %}
class FoosController < ApplicationController
  helper TronprintHelper
end
{% endhighlight %}
</figure>

Then, in your view:

<figure>
  <figcaption>app/views/foo/bar.html.erb</figcaption>
{% highlight erb %}
<%= total_footprint %> kg CO<sub>2</sub>e
{% endhighlight %}
</figure>

### Helper Methods

TronprintHelper comes with a few helper methods:

* `cm1_badge` - Displays a CM1 badge like the one at the bottom of this page.
* `total_footprint` - The total footprint of your application, in kilograms.
* `footprint_methodology` - A URL for a live methodology statement reporting how your footprint was calculated. [Example](http://carbon.brighterplanet.com/computations?duration=128372)

## Using Tronprint with Heroku

A [Tronprint Heroku add-on](http://addons.heroku.com/tronprint) is currently in private beta. Follow [@brighterplanet](http://twitter.com/brighterplanet) for updates. Private beta participants can see our [Heroku docs](https://github.com/brighterplanet/tronprint/blob/master/herokudocs.md) for detailed instructions.

## Wait, self-aware applications? Is this the singularity?

Not really; it's just multithreading. When your application starts and loads the Tronprint library, Tronprint launches a separate thread and begins polling for CPU usage, which [is an excellent proxy for overall machine use](http://bnrg.eecs.berkeley.edu/~randy/Courses/CS294.F07/20.3.pdf). Tronprint submits compute time data to Brighter Planet's [CM1](http://carbon.brighterplanet.com) web service for real-time carbon calculation.

## Who's responsible for this? Floyd?

Tronprint is &copy;2011 [Brighter Planet](http://brighterplanet.com).
