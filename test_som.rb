require 'som/som'
require 'pp' # to pretty print ruby objects

dataf="animal.dat"            # input data, given in SOM format
                              # SOM format consists of 1 header
                              # followed by data, one line for each vector
                              # header 
                              #  1st entry = dimension of vectors
                              #  2nd entry = geometry of SOM map, this is
                              #  not currently used by the code effectively

init_mapf="animal.init_map"   # Output file containing initial map
                              # in this code, this is the sum of the first
                              # two principal components of the data space

out_mapf="animal.fin_map"     # The final SOM map, after training

# The options Hash
opts = { :alpha => 0.7,       # so-called initial 'learning rate'
         :rlen  => 100000,    # number of maximum iterations
         :topol => 'rect',    # topology of the map, rectangular | hexagonal
         :neigh => 'gaussian' # neighborhood function, guassian | bubble
       }
som=SOM.new(4,3,opts)         # Initialize SOM with three arguments
                              # first two are breadth and height of the
                              # SOM Map
                              # The last argument is optional and is
                              # supplied in the form of a Hash

som.code_init(dataf,init_mapf)# Initialize the map and output to 'init_mapf'

som.train(dataf,init_mapf,out_mapf) # Self Organise the map based on input data

# The following 3 lines read data from the input file and the final map
# The first line reads the label information 
# The second line reads the data
# The third line reads the SOM map

sample_lbl=IO.readlines(dataf)[1..-1].map {|dt| dt.chomp.split(" ")[-1]}
sample_data=IO.readlines(dataf)[1..-1].map do |dt| 
              dt.chomp.split(" ")[0..-2].map {|ch| ch.to_f}
            end
map=IO.readlines(out_mapf)[1..-1].map {|dt| dt.chomp.split(" ")[0..-1].map {|ch| ch.to_f}}


# The data are passed to the method 'vis_map' for visualization on the
# specified SOM grid. Members belonging to each cluster are identified
# visually (hint: use short labels, so as not to clutter the display).

som.vis_map(sample_data,sample_lbl,map)

# See the contents of each node in the SOM Map
#pp som.inspect
#pp som[0]
#puts som.mqe
