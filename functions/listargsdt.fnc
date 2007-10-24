create or replace function listargsdt(input datetime) return argsdt
  parallel_enable
  aggregate using obj_aggr_argsdt;
/
