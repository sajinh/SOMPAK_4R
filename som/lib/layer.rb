require File.join(File.dirname(__FILE__),'node')
class Layer
  attr_accessor :nodes, :width, :height

  def initialize(width,height)
    @height, @width  = height, width
    init_nodes
  end

  def init_nodes
    @nodes=[]
  end

  def map=(wgt_arr)
    @nodes.each_index {|i| @nodes[i].weights=wgt_arr[i]}
  end

  def sample_init(samples)
    init_nodes
    id=0
    height.times do |h|
      width.times do |w|
        init_wgts = samples[(rand*(samples.size-1)).round]
         nodes << Node.new(id,w,h,init_wgts)
         id+=1
      end
    end #Sample Initialization
    nodes
  end

  def node_qe
    nodes.map {|nd| nd.qe}
  end

  def mqe
    (node_qe.inject(0) {|sum,entry| sum+entry})/node_qe.size.to_f
  end

  def node_rows
    node_rows=Array.new(height)
    ns=0
    height.times do |h|
      node_rows[h]=nodes[ns,width]
      ns+=width
    end
    node_rows
  end
	
end
