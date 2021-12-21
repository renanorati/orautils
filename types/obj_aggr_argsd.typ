create or replace type obj_aggr_argsd force as object
(
  list argsd,
  static function odciaggregateinitialize(object in out obj_aggr_argsd) return number,
  member function odciaggregateiterate(self  in out obj_aggr_argsd
                                      ,value in date) return number,
  member function odciaggregatemerge(self   in out obj_aggr_argsd
                                    ,object in obj_aggr_argsd) return number,
  member function odciaggregateterminate(self  in obj_aggr_argsd
                                        ,ctx2  out argsd
                                        ,flags in number) return number
)
;
/
create or replace type body obj_aggr_argsd is

  static function odciaggregateinitialize(object in out obj_aggr_argsd) return number is
  begin
    object := obj_aggr_argsd(argsd());
    return odciconst.success;
  end odciaggregateinitialize;

  member function odciaggregateiterate(self  in out obj_aggr_argsd
                                      ,value in date) return number is
  begin
    self.list.extend;
    self.list(self.list.last) := value;
    return odciconst.success;
  end odciaggregateiterate;

  member function odciaggregatemerge(self   in out obj_aggr_argsd
                                    ,object in obj_aggr_argsd) return number is
  begin
    self.list := self.list multiset union object.list;
    return odciconst.success;
  end odciaggregatemerge;

  member function odciaggregateterminate(self  in obj_aggr_argsd
                                        ,ctx2  out argsd
                                        ,flags in number) return number is
  begin
    ctx2 := self.list;
    return odciconst.success;
  end odciaggregateterminate;

end;
/
