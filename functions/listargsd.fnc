create or replace function listargsd(input date) return argsd
  parallel_enable
  aggregate using obj_aggr_argsd;
/
