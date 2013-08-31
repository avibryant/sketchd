SketchD
=======

A simple hack to allow you to track estimates of an infinite number of StatsD metrics using a finite number of underlying graphite buckets.

Usage:

````ruby
#namespace will be the prefix of all the underlying buckets the sketch uses
#max_buckets is the largest number of buckets that will be used.
#the more buckets used, the more accurate the estimates will be
sketch = SketchD.new(namespace, max_buckets)

#Pass in a Statsd instance and a key to increment. (No other operations are allowed).
#No matter how many unique keys you increment, no more than max_buckets actual metrics will be created.
sketch.increment(statsd, key)

#Retrieve the target to give graphite to visualize the estimate for a key.
#This will be of the form minSeries(....)
puts sketch.target(key)

````