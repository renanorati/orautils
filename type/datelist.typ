create or replace type datelist as object
(
-- Attributes
  list args_date,

-- Constructor
  constructor function datelist return self as result,
  constructor function datelist(list      varchar2
                               ,formato   varchar2 default 'DD/MM/RRRR'
                               ,separador varchar2 default ';') return self as result,
-- Member functions and procedures
  member procedure atribuir(self      in out nocopy datelist
                           ,list      varchar2
                           ,formato   varchar2 default 'DD/MM/RRRR'
                           ,separador varchar2 default ';'),
  member function atribuir(self      in out nocopy datelist
                          ,list      varchar2
                          ,formato   varchar2 default 'DD/MM/RRRR'
                          ,separador varchar2 default ';') return datelist,
  member function existe(data datetime) return boolean,
  member function existe(data date) return boolean,
  member procedure adicionar(self    in out nocopy datelist
                            ,data    datetime
                            ,repetir boolean default false),
  member function adicionar(self    in out nocopy datelist
                           ,data    datetime
                           ,repetir boolean default false) return datelist,
  member procedure adicionar(data    date
                            ,repetir boolean default false),
  member function adicionar(self    in out nocopy datelist
                           ,data    date
                           ,repetir boolean default false) return datelist,
  member procedure adicionar(list      varchar2
                            ,formato   varchar2 default 'DD/MM/RRRR'
                            ,separador varchar2 default ';'
                            ,repetir   boolean default false),
  member function adicionar(self      in out nocopy datelist
                           ,list      varchar2
                           ,formato   varchar2 default 'DD/MM/RRRR'
                           ,separador varchar2 default ';'
                           ,repetir   boolean default false) return datelist,
  member procedure remover(self in out nocopy datelist
                          ,data datetime),
  member function remover(self in out nocopy datelist
                         ,data datetime) return datelist,
  member procedure remover(data date),
  member function remover(self in out nocopy datelist
                         ,data date) return datelist,
  member procedure remover(list      varchar2
                          ,formato   varchar2 default 'DD/MM/RRRR'
                          ,separador varchar2 default ';'),
  member function remover(self      in out nocopy datelist
                         ,list      varchar2
                         ,formato   varchar2 default 'DD/MM/RRRR'
                         ,separador varchar2 default ';') return datelist,
  member function to_table return args_date
    pipelined,
  member function maior return datetime,
  member function menor return datetime,
  member function cruzamento(lista datelist) return varchar2,
  member function cruzamento(list      varchar2
                            ,formato   varchar2 default 'DD/MM/RRRR'
                            ,separador varchar2 default ';') return varchar2,
  member function cruzamento_periodo(inicio datetime
                                    ,fim    datetime) return varchar2,
  member function cruzamento_periodo(inicio date
                                    ,fim    date) return varchar2,
  member function cruzamento_periodo(inicio  varchar2
                                    ,fim     varchar2
                                    ,formato varchar2 default 'DD/MM/RRRR') return varchar2,
  member function esta_dentro(lista datelist) return varchar2,
  member function esta_dentro(list      varchar2
                             ,formato   varchar2 default 'DD/MM/RRRR'
                             ,separador varchar2 default ';') return varchar2,
  member function abrange(lista datelist) return varchar2,
  member function abrange(list      varchar2
                         ,formato   varchar2 default 'DD/MM/RRRR'
                         ,separador varchar2 default ';') return varchar2,
  member function possui(data datetime) return varchar2,
  member function possui(data date) return varchar2,
  member function possui(data    varchar2
                        ,formato varchar2 default 'DD/MM/RRRR') return varchar2,
  member function limitar(inicio datetime default datetime(null)
                         ,fim    datetime default datetime(null)) return datelist,
  member procedure limitar(self   in out nocopy datelist
                          ,inicio datetime default datetime(null)
                          ,fim    datetime default datetime(null)),
  member function limitar(inicio date default null
                         ,fim    date default null) return datelist,
  member procedure limitar(inicio date default null
                          ,fim    date default null),
  member function limitar(inicio  varchar2 default null
                         ,fim     varchar2 default null
                         ,formato varchar2 default 'DD/MM/RRRR') return datelist,
  member procedure limitar(inicio  varchar2 default null
                          ,fim     varchar2 default null
                          ,formato varchar2 default 'DD/MM/RRRR'),
  member function dias return number,
  member function mostra(formato varchar2 default 'DD/MM/RRRR') return varchar2
)
/
create or replace type body datelist is

  -- Constructor
  constructor function datelist return self as result is
  begin
    self.list := args_date();
    return;
  end;

  constructor function datelist(list      varchar2
                               ,formato   varchar2 default 'DD/MM/RRRR'
                               ,separador varchar2 default ';') return self as result is
  begin
    self.list := args_date();
    atribuir(list, formato, separador);
    return;
  end;
  -- Member procedures and functions
  member procedure atribuir(self      in out nocopy datelist
                           ,list      varchar2
                           ,formato   varchar2 default 'DD/MM/RRRR'
                           ,separador varchar2 default ';') is
  begin
    self.list.delete;
    for reg in (select regexp_substr(list, '[^' || separador || ']+', 1, level) res
                  from dual
                connect by regexp_substr(list, '[^' || separador || ']+', 1, level) is not null)
    loop
      if reg.res is not null then
        self.list.extend;
        self.list(self.list.last) := datetime(reg.res, formato);
      end if;
    end loop;
  end atribuir;

  member function atribuir(self      in out nocopy datelist
                          ,list      varchar2
                          ,formato   varchar2 default 'DD/MM/RRRR'
                          ,separador varchar2 default ';') return datelist is
  begin
    atribuir(list, formato, separador);
    return self;
  end atribuir;

  member function existe(data datetime) return boolean is
  begin
    if self.list.first is not null then
      for reg in self.list.first .. self.list.last
      loop
        if self.list.exists(reg) then
          if self.list(reg).data = data.data then
            return true;
          end if;
        end if;
      end loop;
    end if;
    return false;
  end existe;

  member function existe(data date) return boolean is
  begin
    return existe(datetime(data));
  end existe;

  member procedure adicionar(self    in out nocopy datelist
                            ,data    datetime
                            ,repetir boolean default false) is
  begin
    if data.nao_nulo
       and (repetir or (not (repetir) and not (existe(data)))) then
      self.list.extend;
      self.list(self.list.last) := data;
    end if;
  end adicionar;

  member function adicionar(self    in out nocopy datelist
                           ,data    datetime
                           ,repetir boolean default false) return datelist is
  begin
    adicionar(data, repetir);
    return self;
  end adicionar;

  member procedure adicionar(data    date
                            ,repetir boolean default false) is
  begin
    adicionar(datetime(data), repetir);
  end adicionar;

  member function adicionar(self    in out nocopy datelist
                           ,data    date
                           ,repetir boolean default false) return datelist is
  begin
    adicionar(data, repetir);
    return self;
  end adicionar;

  member procedure adicionar(list      varchar2
                            ,formato   varchar2 default 'DD/MM/RRRR'
                            ,separador varchar2 default ';'
                            ,repetir   boolean default false) is
  begin
    for reg in (select regexp_substr(list, '[^' || separador || ']+', 1, level) res
                  from dual
                connect by regexp_substr(list, '[^' || separador || ']+', 1, level) is not null)
    loop
      if reg.res is not null then
        adicionar(datetime(reg.res, formato), repetir);
      end if;
    end loop;
  end adicionar;

  member function adicionar(self      in out nocopy datelist
                           ,list      varchar2
                           ,formato   varchar2 default 'DD/MM/RRRR'
                           ,separador varchar2 default ';'
                           ,repetir   boolean default false) return datelist is
  begin
    adicionar(list, formato, separador, repetir);
    return self;
  end adicionar;

  member procedure remover(self in out nocopy datelist
                          ,data datetime) is
  begin
    if self.list.first is not null
       and data.nao_nulo then
      for reg in self.list.first .. self.list.last
      loop
        if self.list.exists(reg) then
          if self.list(reg).data = data.data then
            self.list.delete(reg);
          end if;
        end if;
      end loop;
    end if;
  end remover;

  member function remover(self in out nocopy datelist
                         ,data datetime) return datelist is
  begin
    remover(data);
    return self;
  end remover;

  member procedure remover(data date) is
  begin
    remover(datetime(data));
  end remover;

  member function remover(self in out nocopy datelist
                         ,data date) return datelist is
  begin
    remover(data);
    return self;
  end remover;

  member procedure remover(list      varchar2
                          ,formato   varchar2 default 'DD/MM/RRRR'
                          ,separador varchar2 default ';') is
  begin
    for reg in (select regexp_substr(list, '[^' || separador || ']+', 1, level) res
                  from dual
                connect by regexp_substr(list, '[^' || separador || ']+', 1, level) is not null)
    loop
      if reg.res is not null then
        remover(datetime(reg.res, formato));
      end if;
    end loop;
  end remover;

  member function remover(self      in out nocopy datelist
                         ,list      varchar2
                         ,formato   varchar2 default 'DD/MM/RRRR'
                         ,separador varchar2 default ';') return datelist is
  begin
    remover(list, formato, separador);
    return self;
  end remover;

  member function to_table return args_date
    pipelined is
  begin
    if self.list.first is not null then
      for reg in self.list.first .. self.list.last
      loop
        if self.list.exists(reg) then
          pipe row(self.list(reg));
        end if;
      end loop;
    end if;
  end;

  member function maior return datetime is
    result datetime := datetime();
  begin
    select datetime(max(tb.data)) into result from table(self.to_table()) tb;
    return result;
  exception
    when others then
      dbms_output.put_line(sqlerrm);
      return datetime();
  end maior;

  member function menor return datetime is
    result datetime := datetime();
  begin
    select datetime(min(tb.data)) into result from table(self.to_table()) tb;
    return result;
  exception
    when others then
      return datetime();
  end menor;

  member function cruzamento(lista datelist) return varchar2 is
  begin
    if (self.list.first is not null and lista.list.first is not null) then
      for pos1 in self.list.first .. self.list.last
      loop
        -- verifica se existe item na posi��o
        if self.list.exists(pos1) then
          for pos2 in lista.list.first .. lista.list.last
          loop
            -- verifica se existe item na posi��o
            if lista.list.exists(pos2) then
              if trunc(self.list(pos1).data) = trunc(lista.list(pos2).data) then
                return 'S';
              end if;
            end if;
          end loop;
        end if;
      end loop;
    end if;
    return 'N';
  end cruzamento;

  member function cruzamento(list      varchar2
                            ,formato   varchar2 default 'DD/MM/RRRR'
                            ,separador varchar2 default ';') return varchar2 is
  begin
    return cruzamento(datelist(list, formato, separador));
  end cruzamento;

  member function cruzamento_periodo(inicio datetime
                                    ,fim    datetime) return varchar2 is
  begin
    if self.list.first is not null then
      for pos in self.list.first .. self.list.last
      loop
        -- verifica se existe item na posi��o
        if self.list.exists(pos) then
          if self.list(pos).esta_dentro(inicio, fim) = 'S' then
            return 'S';
          end if;
        end if;
      end loop;
    end if;
    return 'N';
  end cruzamento_periodo;

  member function cruzamento_periodo(inicio date
                                    ,fim    date) return varchar2 is
  begin
    return cruzamento_periodo(datetime(inicio), datetime(fim));
  end cruzamento_periodo;

  member function cruzamento_periodo(inicio  varchar2
                                    ,fim     varchar2
                                    ,formato varchar2 default 'DD/MM/RRRR') return varchar2 is
  begin
    return cruzamento_periodo(datetime(inicio, formato), datetime(fim, formato));
  end cruzamento_periodo;

  member function esta_dentro(lista datelist) return varchar2 is
    encontrou boolean default false;
  begin
    if (self.list.first is not null and lista.list.first is not null) then
      for pos1 in self.list.first .. self.list.last
      loop
        -- verifica se existe item na posi��o
        if self.list.exists(pos1) then
          encontrou := false;
          for pos2 in lista.list.first .. lista.list.last
          loop
            -- verifica se existe item na posi��o
            if lista.list.exists(pos2) then
              if trunc(self.list(pos1).data) = trunc(lista.list(pos2).data) then
                encontrou := true;
                exit;
              end if;
            end if;
          end loop;
          if not encontrou then
            return 'N';
          end if;
        end if;
      end loop;
    end if;
    return 'S';
  end esta_dentro;

  member function esta_dentro(list      varchar2
                             ,formato   varchar2 default 'DD/MM/RRRR'
                             ,separador varchar2 default ';') return varchar2 is
  begin
    return esta_dentro(datelist(list, formato, separador));
  end esta_dentro;

  member function abrange(lista datelist) return varchar2 is
  begin
    return lista.esta_dentro(self);
  end abrange;

  member function abrange(list      varchar2
                         ,formato   varchar2 default 'DD/MM/RRRR'
                         ,separador varchar2 default ';') return varchar2 is
  begin
    return abrange(datelist(list, formato, separador));
  end abrange;

  member function possui(data datetime) return varchar2 is
    list_verifica datelist := datelist();
  begin
    list_verifica.adicionar(data);
    return list_verifica.esta_dentro(self);
  end possui;

  member function possui(data date) return varchar2 is
  begin
    return possui(datetime(data));
  end possui;

  member function possui(data    varchar2
                        ,formato varchar2 default 'DD/MM/RRRR') return varchar2 is
  begin
    return possui(datetime(data, formato));
  end possui;

  member function limitar(inicio datetime default datetime(null)
                         ,fim    datetime default datetime(null)) return datelist is
    result datelist := datelist();
  begin
    if self.list.first is not null then
      for reg in self.list.first .. self.list.last
      loop
        if self.list.exists(reg) then
          if bool(self.list(reg).esta_dentro(inicio, fim)).to_bool then
            result.adicionar(self.list(reg));
          end if;
        end if;
      end loop;
    end if;
    return result;
  end;

  member procedure limitar(self   in out nocopy datelist
                          ,inicio datetime default datetime(null)
                          ,fim    datetime default datetime(null)) is
  begin
    self := limitar(inicio, fim);
  end;

  member function limitar(inicio date default null
                         ,fim    date default null) return datelist is
  begin
    return limitar(datetime(inicio), datetime(fim));
  end limitar;

  member procedure limitar(inicio date default null
                          ,fim    date default null) is
  begin
    limitar(datetime(inicio), datetime(fim));
  end;

  member function limitar(inicio  varchar2 default null
                         ,fim     varchar2 default null
                         ,formato varchar2 default 'DD/MM/RRRR') return datelist is
  begin
    return limitar(datetime(inicio, formato), datetime(fim, formato));
  end limitar;

  member procedure limitar(inicio  varchar2 default null
                          ,fim     varchar2 default null
                          ,formato varchar2 default 'DD/MM/RRRR') is
  begin
    limitar(datetime(inicio, formato), datetime(fim, formato));
  end;

  member function dias return number is
  begin
    return self.list.count();
  end;

  member function mostra(formato varchar2 default 'DD/MM/RRRR') return varchar2 is
    result varchar2(32767);
  begin
    if self.list.first is not null then
      for reg in self.list.first .. self.list.last
      loop
        if self.list.exists(reg) then
          result := result || self.list(reg).mostra(formato) || ';';
        end if;
      end loop;
      -- remove ultimo ';'
      result := substr(result, 1, length(result) - 1);
    end if;
    return result;
  end;

end;
/
