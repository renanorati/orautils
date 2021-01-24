create or replace function nlistagg(input varchar2) return nlist
  parallel_enable
  aggregate using obj_aggr_nlist;
/
