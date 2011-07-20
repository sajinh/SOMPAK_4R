require File.join(File.dirname(__FILE__),'stat_helpers')

class Node
  include Stat

  attr_reader :id, :pos, :bucket
  attr_accessor :weights
  def initialize( id, xpos, ypos, weights) 
    @id = id
    @pos = [xpos,ypos]
    @bucket = []
    @weights = weights
  end
 
  def reinit_bucket
    @bucket = []
  end

  def update_weight(learning_rate, influence, input)
    weights.each_with_index do |weight,iw|
      @weights[iw] +=  learning_rate * influence * (input[iw] - weight)
    end
  end

  def match_index(input,crit)
    case crit
    when :corr
      return(correlate(weights,input)) 
    when :eucl_dist
      return(-eucl_distance(weights,input))
    end
    # low activation means more similar
  end

  def memoized_sq_dist_to(other)
    @cached_distance ||= []
    @cached_distance[other.id] ||= sq_dist_to(other)
  end

  def sq_dist_to(other)
    x1, x2 = pos[0], other.pos[0]
    y1, y2 = pos[1], other.pos[1]
    (x1 - x2)**2 + (y1 - y2)**2
  end

  def neighbors
    x,y=pos
    ([[x-1,y],[x+1,y],[x,y-1],[x,y+1]]).select { |i,j| i>=0 && j>=0}
  end

  def distance_to_data(data)
    dis=data.inject(0) {|sum,entry| sum + eucl_distance(weights,entry)}
    dis/data.size.to_f
  end

  def qe
    dis=bucket.inject(0) {|sum,entry| sum + eucl_distance(weights,entry)}
    den= bucket.size.to_f
    (den > 0) ? dis/den : dis
  end

  def <<(data)
    @bucket << data
  end
	
end
