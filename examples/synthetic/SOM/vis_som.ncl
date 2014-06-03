load "$SysE/lib/ncl/helper_libs.ncl"

fin = fopen_read("../synth.nc")
nstn = dimsizes(fin->station)

head = readAsciiHead("./synth.fin_map", 1) 
arr  = str_split(head," ")
nvec = toint(arr(0))
ncol = toint(arr(2))
nrow = toint(arr(3))
pp("num cols = "+ncol)
pp("num rows = "+nrow)

som = new( (/nrow,ncol,nvec/), "float")
som_text = new( (/nrow,ncol/), "string")
som_text = "0"
nsom = nrow*ncol
isom = 0
plot = new(nsom,"graphic")
tnum  = plot
ttxt  = plot
wks  = open_wks("pdf","som_map","rainbow")
res = True
;res@gsnXYBarChart = True
;res@gsnXYBarChartOutlineOnly = True
res@gsnYRefLine = 0.0
res@trYMinF = -1.7
res@trYMaxF = -1*res@trYMinF
res@trXMinF = -1
res@trXMaxF = 14
nodraw(res)
noframe(res)
mon = ispan(1,12,1)
txres               = True                     ; text mods desired
txres@txFontHeightF = 0.05                     ; font smaller. default big
do iy = 0,nrow-1
  do ix = 0,ncol-1
    fnam = "./node_weights/som"+ix+"_"+iy
    som(iy,ix,:) = asciiread(fnam,nvec,"float")
    tnam = "./node_members/som"+ix+"_"+iy
    if isfilepresent(tnam)
      som_text(iy,ix) = numAsciiRow(tnam)
    end if
    plot(isom) = gsn_csm_xy(wks,mon,som(iy,ix,:), res)
txres@txFontHeightF = 0.03                     ; font smaller. default big
    tnum(isom)  = gsn_add_text(wks,plot(isom),ix+"_"+iy,1,-0.4,txres) 
txres@txFontHeightF = 0.05                     ; font smaller. default big
    ttxt(isom)  = gsn_add_text(wks,plot(isom),som_text(iy,ix),1,-1.0,txres) 
    isom = isom + 1
  end do
end do

gsn_panel(wks,plot,(/nrow,ncol/),True)
