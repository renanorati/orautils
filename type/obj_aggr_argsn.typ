create or replace type obj_aggr_argsn force as object
(
  list argsn,
  static function odciaggregateinitialize(object in out obj_aggr_argsn) return number,
  member function odciaggregateiterate(self  in out obj_aggr_argsn
                                      ,value in number) return number,
  member function odciaggregatemerge(self   in out obj_aggr_argsn
                                    ,object in obj_aggr_argsn) return number,
  member function odciaggregateterminate(self  in obj_aggr_argsn
                                        ,ctx2  out argsn
                                        ,flags in number) return number
)
;
/
create or replace type body obj_aggr_argsn is

  static function odciaggregateinitialize(object in out obj_aggr_argsn) return number is
  begin
    object := obj_aggr_argsn(argsn());
    return odciconst.success;
  end odciaggregateinitialize;

  member function odciaggregateiterate(self  in out obj_aggr_argsn
                                      ,value in number) return number is
  begin
    self.list.extend;
    self.list(self.list.last) := value;
    return odciconst.success;
  end odciaggregateiterate;

  member function odciaggregatemerge(self   in out obj_aggr_argsn
                                    ,object in obj_aggr_argsn) return number is
  begin
    self.list := self.list multiset union object.list;
    return odciconst.success;
  end odciaggregatemerge;

  member function odciaggregateterminate(self  in obj_aggr_argsn
                                        ,ctx2  out argsn
                                        ,flags in number) return number is
  begin
    ctx2 := self.list;
    return odciconst.success;
  end odciaggregateterminate;

end;
/
