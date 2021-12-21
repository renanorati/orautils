create or replace type obj_aggr_alist force as object
(
  list alist,
  static function odciaggregateinitialize(object in out obj_aggr_alist) return number,
  member function odciaggregateiterate(self  in out obj_aggr_alist
                                      ,value in varchar2) return number,
  member function odciaggregatemerge(self   in out obj_aggr_alist
                                    ,object in obj_aggr_alist) return number,
  member function odciaggregateterminate(self  in obj_aggr_alist
                                        ,ctx2  out alist
                                        ,flags in number) return number
)
;
/
create or replace type body obj_aggr_alist is

  static function odciaggregateinitialize(object in out obj_aggr_alist) return number is
  begin
    object := obj_aggr_alist(alist());
    return odciconst.success;
  end odciaggregateinitialize;

  member function odciaggregateiterate(self  in out obj_aggr_alist
                                      ,value in varchar2) return number is
  begin
    self.list.list.extend;
    self.list.list(self.list.list.last) := value;
    return odciconst.success;
  end odciaggregateiterate;

  member function odciaggregatemerge(self   in out obj_aggr_alist
                                    ,object in obj_aggr_alist) return number is
  begin
    self.list.list := self.list.list multiset union object.list.list;
    return odciconst.success;
  end odciaggregatemerge;

  member function odciaggregateterminate(self  in obj_aggr_alist
                                        ,ctx2  out alist
                                        ,flags in number) return number is
  begin
    ctx2 := self.list;
    return odciconst.success;
  end odciaggregateterminate;

end;
/
