require 'rubygems'
require 'numru/netcdf'
require 'pp'
include NumRu

file = NetCDF.open("synth.nc")
rain = file.var("rain").get
station = file.var("station").get
file.close

pp rain.class
pp rain.size
pp rain.dim
pp rain.shape
ntim,nstn = rain.shape

# we need only rain for selected season

fout = File.open("synth.txt","w")
fout.puts "#{ntim} rect 2 2 gaussian"
(0..nstn-1).each do |istn|

  txt = (rain[true,istn]).to_a.map do |s| 

    v="%2.2f"%s
    v.gsub("-999.00", "x")
  end
  fout.puts txt.join(" ")+" #{"%02d" % station[istn]}"
end
fout.close

