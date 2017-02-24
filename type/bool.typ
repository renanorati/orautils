create or replace type bool as object
(
-- Attributes
  val number,

-- Constructor
  constructor function bool return self as result,
  constructor function bool(value varchar2) return self as result,
  constructor function bool(value boolean) return self as result,
-- Member functions and procedures
  member procedure atribuir(self  in out nocopy bool
                           ,value number default null),
  member function atribuir(self  in out nocopy bool
                          ,value number default null) return bool,
  member procedure atribuir(self  in out nocopy bool
                           ,value varchar2 default null),
  member function atribuir(self  in out nocopy bool
                          ,value varchar2 default null) return bool,
  member procedure atribuir(self  in out nocopy bool
                           ,value boolean default null),
  member function atribuir(self  in out nocopy bool
                          ,value boolean default null) return bool,
  member procedure inverter(self in out nocopy bool),
  member function inverter return bool,
  member function to_bool return boolean,
  member function to_text return varchar2,
  member function to_char return varchar2,
  member function to_number return number,
  member function to_forms return number
)
/
create or replace type body bool is

  -- Constructor
  constructor function bool return self as result is
  begin
    self.val := 1;
    return;
  end;

  constructor function bool(value varchar2) return self as result is
  begin
    atribuir(value);
    return;
  end;

  constructor function bool(value boolean) return self as result is
  begin
    atribuir(value);
    return;
  end;

  -- Member procedures and functions
  member procedure atribuir(self  in out nocopy bool
                           ,value number default null) is
  begin
    -- Se o valor é **menor ou igual a 0**, considera **false**
    if nvl(value, 0) > 0 then
      self.val := 1;
    else
      self.val := 0;
    end if;
    -- --
  end atribuir;

  member function atribuir(self  in out nocopy bool
                          ,value number default null) return bool is
  begin
    atribuir(value);
    return self;
  end atribuir;

  member procedure atribuir(self  in out nocopy bool
                           ,value varchar2 default null) is
    valor varchar2(100) := trim(value);
  begin
    /* Valores considerados **false**:
     * n
     * f
     * property_false
     * property_off
     * false
     * 0
     * i
     * nao, não
    */
    if valor is null
       or regexp_like(valor, '^(n|f|property_false|property_off|false|off|0|i|n.o)$', 'i') then
      self.val := 0;
    else
      self.val := 1;
    end if;
  end atribuir;

  member function atribuir(self  in out nocopy bool
                          ,value varchar2 default null) return bool is
  begin
    atribuir(value);
    return self;
  end atribuir;

  member procedure atribuir(self  in out nocopy bool
                           ,value boolean default null) is
  begin
    if value then
      self.val := 1;
    else
      self.val := 0;
    end if;
  end atribuir;

  member function atribuir(self  in out nocopy bool
                          ,value boolean default null) return bool is
  begin
    atribuir(value);
    return self;
  end atribuir;

  member procedure inverter(self in out nocopy bool) is
  begin
    self := inverter;
  end inverter;

  member function inverter return bool is
  begin
    return bool(not to_bool);
  end inverter;

  member function to_bool return boolean is
  begin
    -- Se o valor é **menor ou igual a 0**, considera **false**
    if self.val > 0 then
      return true;
    else
      return false;
    end if;
    -- --
  end;

  member function to_text return varchar2 is
  begin
    if to_bool then
      return 'S';
    else
      return 'N';
    end if;
  end;

  member function to_char return varchar2 is
  begin
    if to_bool then
      return 'S';
    else
      return 'N';
    end if;
  end;

  member function to_number return number is
  begin
    if to_bool then
      return 1;
    else
      return 0;
    end if;
  end;

  member function to_forms return number is
  begin
    if to_bool then
      return 4;
    else
      return 5;
    end if;
  end;

end;
/
