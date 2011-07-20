module Stat
  module_function
  def mean(x)
    sum = 0
    x.each {|v| sum+=v}
    sum/x.size
  end
  def variance(x)
    m = mean(x)
    sum = 0.0
    x.each {|v| sum+= (v-m)**2 }
    sum/x.size
  end
  def sigma(x)
    Math.sqrt(variance(x))
  end
  def correlate(x,y)
    sum=0.0
    x.each_index do |i|
      sum+= x[i]*y[i]
    end
    xymean = sum/x.size.to_f
    xmean  = mean(x)
    ymean  = mean(y)
    sx     = sigma(x)
    sy     = sigma(y)
    (xymean - (xmean*ymean))/(sx*sy)
  end
  def distance(x,y)
    sum=0.0
    sx = sigma(x)
    sy = sigma(y)
    x.each_index do |i|
      sum += (y[i]/sy - x[i]/sx).abs
    end
    sum/x.size.to_f
  end
  def eucl_distance(x,y)
    sum=0.0
    x.each_index do |i|
      sum += (y[i] - x[i]) ** 2
    end
    sum
    sum/x.size.to_f
  end

  def sim_crits
    [:distance, :correlation]
  end

end
class Float
  def round_at(precision)
     "%.#{precision}f" % self
  end
end
