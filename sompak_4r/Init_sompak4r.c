#include <ruby.h>
#include <som_rout.h>
#include <datafile.h>
/* date updated 6-Sep-2010; saji.nh */

static VALUE mSomPak;


struct entries *get_entries(VALUE filname)
{
  return(open_entries(StringValueCStr(filname)));
}

struct teach_params get_params(VALUE ropt_hash)
{
  struct teach_params params;
  params.length = NUM2INT(rb_hash_aref(ropt_hash,ID2SYM(rb_intern("rlen"))));
  params.alpha = NUM2DBL(rb_hash_aref(ropt_hash,ID2SYM(rb_intern("alpha"))));
  params.radius = NUM2INT(rb_hash_aref(ropt_hash,ID2SYM(rb_intern("radius"))));
  return(params);
}
static VALUE som_train_map(VALUE self, VALUE rxdim, VALUE rydim,
       VALUE rdin, VALUE rcod1, VALUE rcod2, VALUE ropt_hash)
{
  struct teach_params params;
  struct entries *data = NULL, *codes = NULL;
  struct typelist *type_tmp;
  struct snapshot_info *snap = NULL;
  long buffer = 0;
  long randomize = oatoi(NULL,0);
  char *funcname = NULL;
  data = codes = NULL;
  params = get_params(ropt_hash);
  label_not_needed(1);
  data  = get_entries(rdin);
  codes = get_entries(rcod1);
  set_teach_params(&params, codes, data, buffer, funcname);
  set_som_params(&params);
  init_random(randomize);
  type_tmp = get_type_by_id(alpha_list, ALPHA_LINEAR);
  params.alpha_type = type_tmp->id;
  params.alpha_func = (ALPHA_FUNC *)type_tmp->data;
  codes = som_training(&params);
  printf("alpha = %f \n",params.alpha);
  save_entries(codes, StringValueCStr(rcod2));
  if (data)
  close_entries(data);
  if (codes)
  close_entries(codes);
  return(Qnil);
}

static VALUE som_map_init(VALUE self, VALUE rxdim, VALUE rydim,
       VALUE rdin, VALUE rdout)
{
  struct entries *data;
  struct entries *codes;
  int topol, neigh, xdim, ydim;
  xdim  = NUM2INT(rxdim);
  ydim  = NUM2INT(rydim);
  topol = topol_type("rect");
  neigh = neigh_type("gaussian");
  data  = get_entries(rdin);
  set_buffer(data,0);
  codes = lininit_codes(data,topol,neigh,xdim,ydim);
  close_entries(data);
  save_entries_wcomments(codes, StringValueCStr(rdout), "# comments \n");
  close_entries(codes);
  return(Qnil);
}

void
Init_sompak4r()
{
  mSomPak = rb_define_module("SomPak");

  rb_define_method(mSomPak, "map_init", som_map_init, 4);
  rb_define_method(mSomPak, "map_train", som_train_map, 6);
}
