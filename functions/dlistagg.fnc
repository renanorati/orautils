create or replace function dlistagg(input varchar2) return dlist
  parallel_enable
  aggregate using obj_aggr_dlist;
/
