create or replace function listargs(input varchar2) return args
  parallel_enable
  aggregate using obj_aggr_args;
/
