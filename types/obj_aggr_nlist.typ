create or replace type obj_aggr_nlist force as object
(
  list nlist,
  static function odciaggregateinitialize(object in out obj_aggr_nlist) return number,
  member function odciaggregateiterate(self  in out obj_aggr_nlist
                                      ,value in number) return number,
  member function odciaggregatemerge(self   in out obj_aggr_nlist
                                    ,object in obj_aggr_nlist) return number,
  member function odciaggregateterminate(self  in obj_aggr_nlist
                                        ,ctx2  out nlist
                                        ,flags in number) return number
)
;
/
create or replace type body obj_aggr_nlist is

  static function odciaggregateinitialize(object in out obj_aggr_nlist) return number is
  begin
    object := obj_aggr_nlist(nlist());
    return odciconst.success;
  end odciaggregateinitialize;

  member function odciaggregateiterate(self  in out obj_aggr_nlist
                                      ,value in number) return number is
  begin
    self.list.list.extend;
    self.list.list(self.list.list.last) := value;
    return odciconst.success;
  end odciaggregateiterate;

  member function odciaggregatemerge(self   in out obj_aggr_nlist
                                    ,object in obj_aggr_nlist) return number is
  begin
    self.list.list := self.list.list multiset union object.list.list;
    return odciconst.success;
  end odciaggregatemerge;

  member function odciaggregateterminate(self  in obj_aggr_nlist
                                        ,ctx2  out nlist
                                        ,flags in number) return number is
  begin
    ctx2 := self.list;
    return odciconst.success;
  end odciaggregateterminate;

end;
/
