SketchD
=======

A simple hack to allow you to track estimates of an infinite number of StatsD metrics using a finite number of underlying graphite buckets.

SketchD {ab}uses graphite to maintain a [Count-min Sketch](http://en.wikipedia.org/wiki/Count%E2%80%93min_sketch) of depth 8 (and configurable width). Each logical increment translates to increments of 8 physical graphite buckets determined by a hash function. You can retrieve the estimate for a given logical key by using graphite's minSeries function over those 8 buckets.

Each individual point in the estimated timeseries will be an over-estimate by a factor of at most around (22*total_count)/max_buckets, 99.97% of the time. So, if you use 10,000 buckets, and a given time period had 100,000 total increments, each estimate will be at most 220 too high; this isn't great for the rarer keys, but should be fine for the larger ones you are most likely to care about.

Usage:

````ruby
#namespace will be the prefix of the physical buckets the sketch uses
#max_buckets is the largest number of buckets that will be used.
sketch = SketchD.new(namespace, max_buckets)

#Pass in a Statsd instance and a key to increment. (No other operations are allowed).
#No matter how many unique keys you increment, no more than max_buckets actual metrics will be created.
sketch.increment(statsd, key)

#Retrieve the target to give graphite to visualize the estimate for a key.
#This will be of the form minSeries(....)
puts sketch.target(key)

````
