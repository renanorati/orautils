create or replace function listargspr(input period) return argspr
  parallel_enable
  aggregate using obj_aggr_argspr;
/
