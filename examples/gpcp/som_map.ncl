load "$SysE/lib/ncl/helper_libs.ncl"
external AscRead "$SysE/lib/ncl/readers/fortran/shared/ascii_read_helper.so"
begin
  funit=10
  AscRead::open_file(funit,"gpcp_spc_vc.fin_map")
  header="A blank line"
  AscRead::read_string(funit,header)
  nrow=12
  ncol=1152
  var=new( (/ncol,nrow/), "float")
  AscRead::read_array(funit,var,nrow,ncol)
  nlat = 24
  nlon = 48
  lat = fspan(-30,30,nlat)
  lon = fspan(30, 150, nlon)
  lat@units="degrees_north"
  lon@units="degrees_east"

  map1 = onedtond(var, (/12, nlat,nlon/))
  add_dimensions(map1,(/"som","lat","lon"/))
  map1&lat=lat
  map1&lon= lon
  map1&som = ispan(1,12,1)
  map1@shaded=True
  map1@map = True
  do isom = 0,11
    DebugPlot(map1(isom,:,:))
  end do
end
