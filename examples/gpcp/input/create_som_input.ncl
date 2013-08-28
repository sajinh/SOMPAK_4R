load "$SysE/lib/ncl/helper_libs.ncl"
load "$SysE/lib/ncl/readers/db_retriever.ncl"
external AscWrite "$SysE/lib/ncl/writers/fortran/shared/ascii_write_helper.so"

begin

  syr=1979
  eyr=2011

  ; We use our gridded data base under /home2/saji/SysE_DB
  ;------------------------------------------------------

  opt = True
  opt@vname="precip"
  opt@DataRoot="/home/saji/SysE_DB"
  opt@DataSource="GPCP"
  opt@DataFreq="Monthly"
  opt@DataType="Anomaly"
  opt@Time=(/"1Jan"+syr,"31Dec"+eyr/)
  opt@Lat=(/-30,30/)
  opt@Lon=(/30,150/)

  olr_mon=slice_data(opt)
  olr = month_to_season(olr_mon, "JJA")

  info(olr)
  ndims=dimsizes(olr)
  ntim=ndims(0)
  nlat=ndims(1)
  nlon=ndims(2)
print(nlat)
print(nlon)
exit
  nxy = nlat*nlon

  funit=10

  ; We collapse the 2-D data for each season to a 1-D time series
  ; We also append the name of the year to the end of the record
  ; This is used to label SOM maps during visualization phase

  olr_vec = new( nlat*nlon+1, "float")
  AscWrite::open_file(funit,"gpcp_anom_jja.txt")
  AscWrite::write_string(funit, (nlat*nlon)+" rect 2 2 gaussian")
  do it = 0,ntim-1
    olr_vec(:nxy-1) = ndtooned(olr(it,:,:))
    olr_vec(nxy) = syr+it
    AscWrite::write_real_array(funit, olr_vec, nxy+1)
  end do
  AscWrite::close_file(funit)

end
