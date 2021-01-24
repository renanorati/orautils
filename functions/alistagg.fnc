create or replace function alistagg(input varchar2) return alist
  parallel_enable
  aggregate using obj_aggr_alist;
/
