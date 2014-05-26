load "$SysE/lib/ncl/helper_libs.ncl"

ngrp = 6
nmon = 12
nens = 100
nstn = nens*ngrp
ts = new( (/ngrp,nmon/), "float")
ts = 0.0
months = ispan(1,nmon,1)*1.0 ; keep type as float
PI = 3.14

rain = new( (/nens*ngrp,nmon/), typeof(ts))

; Group 1 (a sine curve)
ts(0,:) =  sin(2*PI*(months/nmon))

; Group 2 (opposite sign to Group 1, with small phase shift)
ts(1,:) =  -1.0*sin(2*PI*((months+1)/nmon))

; Group 3 (step. function with max in July and Aug)
ts(2,6:7) = 1.0

; Group 4 (step. function with max in May to Oct)
ts(3,4:9) = 1.0

; Group 5 (step. function with max in Oct to Dec)
ts(4,9:11) = 1.0

; Group 6 (step. function with max in Jan to Apr)
ts(5,0:3) = 1.0


;DebugGraph(ts(:,:))
; Add a mix of random whitenoise
k = 0
do iens = 0,nens-1
  do ig = 0,ngrp-1
    rain(k,:) = ts(ig,:) ;+ts(ig,:)*random_normal(avg(ts(ig,:)),0.2,nmon)
    k = k+1
  end do
end do

add_dimensions(rain,(/"station","month"/))
rain&station=ispan(1,nstn,1)
rain&month=ispan(1,nmon,1)
rain@units="mm/day"

outfil="synth.nc"
rm_file_if_present(outfil)
fout=fopen_write(outfil)
fout@desc="An artificial data set of time series groups"
fout->rain=rain
