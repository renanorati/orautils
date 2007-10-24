create or replace type obj_aggr_argsdt force as object
(
  list argsdt,
  static function odciaggregateinitialize(object in out obj_aggr_argsdt) return number,
  member function odciaggregateiterate(self  in out obj_aggr_argsdt
                                      ,value in datetime) return number,
  member function odciaggregatemerge(self   in out obj_aggr_argsdt
                                    ,object in obj_aggr_argsdt) return number,
  member function odciaggregateterminate(self  in obj_aggr_argsdt
                                        ,ctx2  out argsdt
                                        ,flags in number) return number
)
;
/
create or replace type body obj_aggr_argsdt is

  static function odciaggregateinitialize(object in out obj_aggr_argsdt) return number is
  begin
    object := obj_aggr_argsdt(argsdt());
    return odciconst.success;
  end odciaggregateinitialize;

  member function odciaggregateiterate(self  in out obj_aggr_argsdt
                                      ,value in datetime) return number is
  begin
    self.list.extend;
    self.list(self.list.last) := value;
    return odciconst.success;
  end odciaggregateiterate;

  member function odciaggregatemerge(self   in out obj_aggr_argsdt
                                    ,object in obj_aggr_argsdt) return number is
  begin
    self.list := self.list multiset union object.list;
    return odciconst.success;
  end odciaggregatemerge;

  member function odciaggregateterminate(self  in obj_aggr_argsdt
                                        ,ctx2  out argsdt
                                        ,flags in number) return number is
  begin
    ctx2 := self.list;
    return odciconst.success;
  end odciaggregateterminate;

end;
/
