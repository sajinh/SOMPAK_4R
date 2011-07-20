require File.join(File.dirname(__FILE__),'lib/sompak4r')
require File.join(File.dirname(__FILE__),'lib/vis_helpers')
require File.join(File.dirname(__FILE__),'lib/layer')
require File.join(File.dirname(__FILE__),'lib/stat_helpers')
class SOM
  include SomPak
  include Vis_SOM
  def initialize(xdim,ydim,options={})
     @xdim=xdim
     @ydim=ydim
     @opts={        :alpha=>0.1,
                    :rlen => 10000,
                    :topol => 'rect',
                    :radius => ([xdim,ydim].max)/2,
                    :neigh => 'gaussian',
                    :sim_crit => :eucl_dist,
                    :tau2 => 0.02,
                    :rand => 0,
                    :init => 'rand',
                    :buffer => 'nil'
                     }.merge(options)

    @layer = Layer.new(xdim,ydim)
    @sim_crit = :eucl_dist
  end

  def code_init(dataf,codef)
    map_init(@xdim,@ydim,dataf,codef)
  end

  def train(dataf,init_mapf,out_mapf)
    map_train(@xdim,@ydim,dataf,init_mapf,out_mapf,@opts)
  end

  def classify(samples,map)
    @layer.sample_init(samples)
    @layer.map = map
    classify_data(samples)
  end

  def vis_map(samples,lbl,map)
    classify(samples,map)
    visualize(lbl)
  end

  def inspect
    node_contents
  end

  def [](arg)
    node_contents[arg]
  end

  def node_qe
    @layer.node_qe
  end

  def mqe
    @layer.mqe
  end

private

  def classify_data(data)
    nodes.each {|node| node.reinit_bucket}
    data.each_with_index do |input,index|
      closest_node = find_best_matching_node(input)
      closest_node << index
    end
  end

  def nodes
    @layer.nodes
  end

  def node_rows
    @layer.node_rows
  end

  def find_best_matching_node(input)
    match=nodes.collect { |nd| nd.match_index(input,@sim_crit)}
    nodes[match.index(match.max)]
  end

  def node_contents
    nodes.map {|nd| {:pos=>nd.pos, :wgts=>nd.weights, :members=>nd.bucket} }
  end

end
