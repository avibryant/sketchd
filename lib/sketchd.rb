require 'digest/md5'

class SketchD
  DEPTH = 8

  def initialize(namespace, max_buckets)
    @namespace = namespace
    @width = max_buckets / DEPTH
  end

  def indices(key)
    Digest::MD5.digest(key).unpack("s"*8).map{|i| i % @width}
  end

  def buckets(key)
    indices(key).each_with_index.map{|x,y| "#{y}.#{x}"}
  end

  def increment(statsd, key)
    buckets(key).each{|b| statsd.increment(@namespace + "." + b)}
  end

  def target(key)
    all_buckets = buckets(key).join(",")
    "minSeries(#{@namespace}.{#{all_buckets}})}"
  end
end