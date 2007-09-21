create or replace function listargsn(input number) return argsn
  parallel_enable
  aggregate using obj_aggr_argsn;
/
