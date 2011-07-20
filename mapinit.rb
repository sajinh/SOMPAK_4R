require 'sompak4r'
  include SomPak
module SOM
class Code

  def self.init(xdim,ydim,din,options={})
     opts={ 
           :topol => 'rect',
           :neigh => 'gaussian', 
           :init => 'rand',
           :rand => 0,
           :buffer => nil,
                     }.merge(options)

    codes=map_init(xdim,ydim,din,options)
  end

private
  def self.outfile(fname)
    ext=File.extname(fname)
    basename=File.basename(fname,ext)
    basename+".init_cod"
  end

  def self.map_init(xdim,ydim,din,options)
    SomPak.map_init(xdim,ydim,din,self.outfile(din))
  end
#  def self.map_init(*args)
#   "hello"
#  end

end
end

a=SOM::Code.init(8,5,"animal.dat")
p a
