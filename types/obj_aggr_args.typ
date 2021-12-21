create or replace type obj_aggr_args force as object
(
  list args,
  static function odciaggregateinitialize(object in out obj_aggr_args) return number,
  member function odciaggregateiterate(self  in out obj_aggr_args
                                      ,value in varchar2) return number,
  member function odciaggregatemerge(self   in out obj_aggr_args
                                    ,object in obj_aggr_args) return number,
  member function odciaggregateterminate(self  in obj_aggr_args
                                        ,ctx2  out args
                                        ,flags in number) return number
)
;
/
create or replace type body obj_aggr_args is

  static function odciaggregateinitialize(object in out obj_aggr_args) return number is
  begin
    object := obj_aggr_args(args());
    return odciconst.success;
  end odciaggregateinitialize;

  member function odciaggregateiterate(self  in out obj_aggr_args
                                      ,value in varchar2) return number is
  begin
    self.list.extend;
    self.list(self.list.last) := value;
    return odciconst.success;
  end odciaggregateiterate;

  member function odciaggregatemerge(self   in out obj_aggr_args
                                    ,object in obj_aggr_args) return number is
  begin
    self.list := self.list multiset union object.list;
    return odciconst.success;
  end odciaggregatemerge;

  member function odciaggregateterminate(self  in obj_aggr_args
                                        ,ctx2  out args
                                        ,flags in number) return number is
  begin
    ctx2 := self.list;
    return odciconst.success;
  end odciaggregateterminate;

end;
/
