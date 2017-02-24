create or replace type datelist force as object
(
-- Attributes
  list argsdt,

-- Constructor
  constructor function datelist return self as result,
  constructor function datelist(list varchar2, formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';') return self as result,
-- Member functions and procedures
  member procedure atribuir(self in out nocopy datelist, list varchar2, formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';'),
  member function atribuir(self in out nocopy datelist, list varchar2, formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';')
    return datelist,
  member function existe(data datetime) return boolean,
  member function existe(data date) return boolean,
  member function existe(data varchar2, formato varchar2 default 'DD/MM/RRRR') return boolean,
  member procedure adicionar(self in out nocopy datelist, data datetime, repetir varchar2 default 'N'),
  member function adicionar(data datetime, repetir varchar2 default 'N') return datelist,
  member procedure adicionar(data date, repetir varchar2 default 'N'),
  member function adicionar(data date, repetir varchar2 default 'N') return datelist,
  member procedure adicionar(list varchar2, formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';', repetir varchar2 default 'N'),
  member function adicionar(list varchar2, formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';', repetir varchar2 default 'N')
    return datelist,
  member procedure adicionar(lista datelist, repetir varchar2 default 'N'),
  member function adicionar(lista datelist, repetir varchar2 default 'N') return datelist,
  member procedure adicionar_periodo(inicio datetime default datetime(), fim datetime default datetime(), repetir varchar2 default 'N'),
  member function adicionar_periodo(inicio datetime default datetime(), fim datetime default datetime(), repetir varchar2 default 'N')
    return datelist,
  member procedure adicionar_periodo(inicio date default null, fim date default null, repetir varchar2 default 'N'),
  member function adicionar_periodo(inicio date default null, fim date default null, repetir varchar2 default 'N') return datelist,
  member procedure adicionar_periodo(inicio  varchar2 default null
                                    ,fim     varchar2 default null
                                    ,formato varchar2 default 'DD/MM/RRRR'
                                    ,repetir varchar2 default 'N'),
  member function adicionar_periodo(inicio  varchar2 default null
                                   ,fim     varchar2 default null
                                   ,formato varchar2 default 'DD/MM/RRRR'
                                   ,repetir varchar2 default 'N') return datelist,
  member function remover(data datetime) return datelist,
  member procedure remover(self in out nocopy datelist, data datetime),
  member function remover(data date) return datelist,
  member procedure remover(data date),
  member function remover(lista datelist) return datelist,
  member procedure remover(self in out nocopy datelist, lista datelist),
  member function remover(list varchar2, formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';') return datelist,
  member procedure remover(list varchar2, formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';'),
  member function remover_periodo(inicio datetime default datetime(), fim datetime default datetime()) return datelist,
  member procedure remover_periodo(self in out nocopy datelist, inicio datetime default datetime(), fim datetime default datetime()),
  member function remover_periodo(inicio date default null, fim date default null) return datelist,
  member procedure remover_periodo(inicio date default null, fim date default null),
  member function remover_periodo(inicio varchar2 default null, fim varchar2 default null, formato varchar2 default 'DD/MM/RRRR') return datelist,
  member procedure remover_periodo(inicio varchar2 default null, fim varchar2 default null, formato varchar2 default 'DD/MM/RRRR'),
  member function maior return datetime,
  member function menor return datetime,
  member function ordenar(ordem varchar2 default 'A') return datelist,
  member procedure ordenar(self in out nocopy datelist, ordem varchar2 default 'A'),
  member function cruzamento(lista datelist) return varchar2,
  member function cruzamento(list varchar2, formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';') return varchar2,
  member function cruzamento_periodo(inicio datetime, fim datetime) return varchar2,
  member function cruzamento_periodo(inicio date, fim date) return varchar2,
  member function cruzamento_periodo(inicio varchar2, fim varchar2, formato varchar2 default 'DD/MM/RRRR') return varchar2,
  member function esta_dentro(lista datelist) return varchar2,
  member function esta_dentro(list varchar2, formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';') return varchar2,
  member function abrange(lista datelist) return varchar2,
  member function abrange(list varchar2, formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';') return varchar2,
  member function possui(data datetime) return varchar2,
  member function possui(data date) return varchar2,
  member function possui(data varchar2, formato varchar2 default 'DD/MM/RRRR') return varchar2,
  member function limitar(inicio datetime default datetime(), fim datetime default datetime()) return datelist,
  member procedure limitar(self in out nocopy datelist, inicio datetime default datetime(), fim datetime default datetime()),
  member function limitar(inicio date default null, fim date default null) return datelist,
  member procedure limitar(inicio date default null, fim date default null),
  member function limitar(inicio varchar2 default null, fim varchar2 default null, formato varchar2 default 'DD/MM/RRRR') return datelist,
  member procedure limitar(inicio varchar2 default null, fim varchar2 default null, formato varchar2 default 'DD/MM/RRRR'),
  member function dias return number,
  member function dias_semana(formato varchar2 default 'D', separador varchar2 default ',') return varchar2,
  member function possui_ds(ds number) return varchar2,
  member function to_char(formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';') return varchar2,
  member function to_table return argsdt,
  member function mostra(formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';') return varchar2
)
/
create or replace type body datelist is

  -- Constructor
  constructor function datelist return self as result is
  begin
    self.list := argsdt();
    return;
  end;

  constructor function datelist(list varchar2, formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';') return self as result is
  begin
    self.list := argsdt();
    atribuir(list, formato, separador);
    return;
  end;

  -- Member procedures and functions
  member procedure atribuir(self in out nocopy datelist, list varchar2, formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';') is
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

  member function atribuir(self in out nocopy datelist, list varchar2, formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';')
    return datelist is
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

  member function existe(data varchar2, formato varchar2 default 'DD/MM/RRRR') return boolean is
  begin
    return existe(datetime(data, formato));
  end existe;

  member procedure adicionar(self in out nocopy datelist, data datetime, repetir varchar2 default 'N') is
  begin
    if data.nao_nulo like 'S' and
       (repetir = 'S' or (repetir = 'N' and not (existe(data)))) then
      self.list.extend;
      self.list(self.list.last) := data;
    end if;
  end adicionar;

  member function adicionar(data datetime, repetir varchar2 default 'N') return datelist is
    result datelist := self;
  begin
    result.adicionar(data, repetir);
    return result;
  end adicionar;

  member procedure adicionar(data date, repetir varchar2 default 'N') is
  begin
    adicionar(datetime(data), repetir);
  end adicionar;

  member function adicionar(data date, repetir varchar2 default 'N') return datelist is
  begin
    return adicionar(datetime(data), repetir);
  end adicionar;

  member procedure adicionar(list varchar2, formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';', repetir varchar2 default 'N') is
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

  member function adicionar(list varchar2, formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';', repetir varchar2 default 'N')
    return datelist is
    result datelist := self;
  begin
    result.adicionar(list, formato, separador, repetir);
    return result;
  end adicionar;

  member procedure adicionar(lista datelist, repetir varchar2 default 'N') is
  begin
    if lista.list.first is not null then
      for reg in lista.list.first .. lista.list.last
      loop
        if lista.list.exists(reg) then
          adicionar(lista.list(reg), repetir);
        end if;
      end loop;
    end if;
  end adicionar;

  member function adicionar(lista datelist, repetir varchar2 default 'N') return datelist is
    result datelist := self;
  begin
    result.adicionar(lista, repetir);
    return result;
  end adicionar;

  member procedure adicionar_periodo(inicio datetime default datetime(), fim datetime default datetime(), repetir varchar2 default 'N') is
  begin
    if fim.data >= inicio.data then
      for i in 0 .. fim.data - inicio.data
      loop
        adicionar(inicio.adicionar(dias => i), repetir);
      end loop;
    end if;
  end adicionar_periodo;

  member function adicionar_periodo(inicio datetime default datetime(), fim datetime default datetime(), repetir varchar2 default 'N') return datelist is
    result datelist := self;
  begin
    result.adicionar_periodo(inicio, fim, repetir);
    return result;
  end adicionar_periodo;

  member procedure adicionar_periodo(inicio date default null, fim date default null, repetir varchar2 default 'N') is
  begin
    adicionar_periodo(datetime(inicio), datetime(fim), repetir);
  end adicionar_periodo;

  member function adicionar_periodo(inicio date default null, fim date default null, repetir varchar2 default 'N') return datelist is
  begin
    return adicionar_periodo(datetime(inicio), datetime(fim), repetir);
  end adicionar_periodo;

  member procedure adicionar_periodo(inicio  varchar2 default null
                                    ,fim     varchar2 default null
                                    ,formato varchar2 default 'DD/MM/RRRR'
                                    ,repetir varchar2 default 'N') is
  begin
    adicionar_periodo(datetime(inicio, formato), datetime(fim, formato), repetir);
  end adicionar_periodo;

  member function adicionar_periodo(inicio  varchar2 default null
                                   ,fim     varchar2 default null
                                   ,formato varchar2 default 'DD/MM/RRRR'
                                   ,repetir varchar2 default 'N') return datelist is
  begin
    return adicionar_periodo(datetime(inicio, formato), datetime(fim, formato), repetir);
  end adicionar_periodo;

  member function remover(data datetime) return datelist is
    result datelist := datelist();
  begin
    if data.nulo like 'S' then
      return self;
    else
      if self.list.first is not null then
        for reg in self.list.first .. self.list.last
        loop
          if self.list.exists(reg) then
            if trunc(self.list(reg).data) <> trunc(data.data) then
              result.adicionar(self.list(reg), repetir => 'S');
            end if;
          end if;
        end loop;
      end if;
    end if;
    return result;
  end remover;

  member procedure remover(self in out nocopy datelist, data datetime) is
  begin
    self := remover(data);
  end remover;

  member function remover(data date) return datelist is
  begin
    return remover(datetime(data));
  end remover;

  member procedure remover(data date) is
  begin
    remover(datetime(data));
  end remover;

  member function remover(lista datelist) return datelist is
    result    datelist := datelist();
    encontrou boolean := false;
  begin
    if (self.list.first is not null and lista.list.first is not null) then
      for pos1 in self.list.first .. self.list.last
      loop
        encontrou := false;
        -- verifica se existe item na posição
        if self.list.exists(pos1) then
          for pos2 in lista.list.first .. lista.list.last
          loop
            -- verifica se existe item na posição
            if lista.list.exists(pos2) then
              if trunc(self.list(pos1).data) = trunc(lista.list(pos2).data) then
                encontrou := true;
                exit;
              end if;
            end if;
          end loop;
          -- se encontrou insere
          if not encontrou then
            result.adicionar(self.list(pos1), repetir => 'S');
          end if;
        end if;
      end loop;
    end if;
    return result;
  end remover;

  member procedure remover(self in out nocopy datelist, lista datelist) is
  begin
    self := remover(lista);
  end remover;

  member function remover(list varchar2, formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';') return datelist is
  begin
    return remover(datelist(list, formato, separador));
  end remover;

  member procedure remover(list varchar2, formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';') is
  begin
    remover(datelist(list, formato, separador));
  end remover;

  member function remover_periodo(inicio datetime default datetime(), fim datetime default datetime()) return datelist is
    result datelist := datelist();
  begin
    if self.list.first is not null then
      for reg in self.list.first .. self.list.last
      loop
        if self.list.exists(reg) then
          if not bool(self.list(reg).esta_dentro(inicio, fim)).to_bool then
            result.adicionar(self.list(reg), repetir => 'S');
          end if;
        end if;
      end loop;
    end if;
    return result;
  end remover_periodo;

  member procedure remover_periodo(self in out nocopy datelist, inicio datetime default datetime(), fim datetime default datetime()) is
  begin
    self := remover_periodo(inicio, fim);
  end remover_periodo;

  member function remover_periodo(inicio date default null, fim date default null) return datelist is
  begin
    return remover_periodo(datetime(inicio), datetime(fim));
  end remover_periodo;

  member procedure remover_periodo(inicio date default null, fim date default null) is
  begin
    remover_periodo(datetime(inicio), datetime(fim));
  end remover_periodo;

  member function remover_periodo(inicio varchar2 default null, fim varchar2 default null, formato varchar2 default 'DD/MM/RRRR') return datelist is
  begin
    return remover_periodo(datetime(inicio, formato), datetime(fim, formato));
  end remover_periodo;

  member procedure remover_periodo(inicio varchar2 default null, fim varchar2 default null, formato varchar2 default 'DD/MM/RRRR') is
  begin
    remover_periodo(datetime(inicio, formato), datetime(fim, formato));
  end remover_periodo;

  member function maior return datetime is
    result datetime := datetime();
  begin
    select datetime(max(tb.data)) into result from table(self.list) tb;
    return result;
  exception
    when others then
      return datetime();
  end maior;

  member function menor return datetime is
    result datetime := datetime();
  begin
    select datetime(min(tb.data)) into result from table(self.list) tb;
    return result;
  exception
    when others then
      return datetime();
  end menor;

  member function ordenar(ordem varchar2 default 'A') return datelist is
    result datelist := datelist();
  begin
    if ordem = 'A' then
      select datetime(tb.data) bulk collect into result.list from table(self.list) tb order by tb.data;
    elsif ordem = 'D' then
      select datetime(tb.data) bulk collect into result.list from table(self.list) tb order by tb.data desc;
    else
      select datetime(tb.data) bulk collect into result.list from table(self.list) tb;
    end if;
    return result;
  exception
    when others then
      return self;
  end ordenar;

  member procedure ordenar(self in out nocopy datelist, ordem varchar2 default 'A') is
  begin
    self := ordenar(ordem);
  end ordenar;

  member function cruzamento(lista datelist) return varchar2 is
  begin
    if (self.list.first is not null and lista.list.first is not null) then
      for pos1 in self.list.first .. self.list.last
      loop
        -- verifica se existe item na posição
        if self.list.exists(pos1) then
          for pos2 in lista.list.first .. lista.list.last
          loop
            -- verifica se existe item na posição
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

  member function cruzamento(list varchar2, formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';') return varchar2 is
  begin
    return cruzamento(datelist(list, formato, separador));
  end cruzamento;

  member function cruzamento_periodo(inicio datetime, fim datetime) return varchar2 is
  begin
    if self.list.first is not null then
      for pos in self.list.first .. self.list.last
      loop
        -- verifica se existe item na posição
        if self.list.exists(pos) then
          if self.list(pos).esta_dentro(inicio, fim) = 'S' then
            return 'S';
          end if;
        end if;
      end loop;
    end if;
    return 'N';
  end cruzamento_periodo;

  member function cruzamento_periodo(inicio date, fim date) return varchar2 is
  begin
    return cruzamento_periodo(datetime(inicio), datetime(fim));
  end cruzamento_periodo;

  member function cruzamento_periodo(inicio varchar2, fim varchar2, formato varchar2 default 'DD/MM/RRRR') return varchar2 is
  begin
    return cruzamento_periodo(datetime(inicio, formato), datetime(fim, formato));
  end cruzamento_periodo;

  member function esta_dentro(lista datelist) return varchar2 is
    encontrou boolean default false;
  begin
    if (self.list.first is not null and lista.list.first is not null) then
      for pos1 in self.list.first .. self.list.last
      loop
        -- verifica se existe item na posição
        if self.list.exists(pos1) then
          encontrou := false;
          for pos2 in lista.list.first .. lista.list.last
          loop
            -- verifica se existe item na posição
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

  member function esta_dentro(list varchar2, formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';') return varchar2 is
  begin
    return esta_dentro(datelist(list, formato, separador));
  end esta_dentro;

  member function abrange(lista datelist) return varchar2 is
  begin
    return lista.esta_dentro(self);
  end abrange;

  member function abrange(list varchar2, formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';') return varchar2 is
  begin
    return abrange(datelist(list, formato, separador));
  end abrange;

  member function possui(data datetime) return varchar2 is
  begin
    if self.list.first is not null then
      for reg in self.list.first .. self.list.last
      loop
        if self.list.exists(reg) then
          if self.list(reg).data = data.data then
            return 'S';
          end if;
        end if;
      end loop;
    end if;
    return 'N';
  end possui;

  member function possui(data date) return varchar2 is
  begin
    return possui(datetime(data));
  end possui;

  member function possui(data varchar2, formato varchar2 default 'DD/MM/RRRR') return varchar2 is
  begin
    return possui(datetime(data, formato));
  end possui;

  member function limitar(inicio datetime default datetime(), fim datetime default datetime()) return datelist is
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

  member procedure limitar(self in out nocopy datelist, inicio datetime default datetime(), fim datetime default datetime()) is
  begin
    self := limitar(inicio, fim);
  end;

  member function limitar(inicio date default null, fim date default null) return datelist is
  begin
    return limitar(datetime(inicio), datetime(fim));
  end limitar;

  member procedure limitar(inicio date default null, fim date default null) is
  begin
    limitar(datetime(inicio), datetime(fim));
  end;

  member function limitar(inicio varchar2 default null, fim varchar2 default null, formato varchar2 default 'DD/MM/RRRR') return datelist is
  begin
    return limitar(datetime(inicio, formato), datetime(fim, formato));
  end limitar;

  member procedure limitar(inicio varchar2 default null, fim varchar2 default null, formato varchar2 default 'DD/MM/RRRR') is
  begin
    limitar(datetime(inicio, formato), datetime(fim, formato));
  end;

  member function dias return number is
  begin
    return self.list.count();
  end;

  member function dias_semana(formato varchar2 default 'D', separador varchar2 default ',') return varchar2 is
    vdias  varchar2(5000);
    result varchar2(32767);
  begin
    if self.list.first is not null then
      for reg in self.list.first .. self.list.last
      loop
        if self.list.exists(reg) then
          vdias := vdias || ',' || self.list(reg).ds;
        end if;
      end loop;
      -- ordena e distinct
      begin
        select listagg(x.descr, separador) within group(order by x.val)
          into result
          from (select distinct t.column_value val
                               ,trim(to_char(to_date(t.column_value || '/05/0001', 'DD/MM/RRRR'), formato)) descr
                  from table(text(vdias).to_table()) t) x;
      exception
        when others then
          result := null;
      end;
    end if;
    return result;
  end dias_semana;

  member function possui_ds(ds number) return varchar2 is
  begin
    if self.list.first is not null then
      for reg in self.list.first .. self.list.last
      loop
        if self.list.exists(reg) then
          if self.list(reg).ds = ds then
            return 'S';
          end if;
        end if;
      end loop;
    end if;
    return 'N';
  end possui_ds;

  member function to_char(formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';') return varchar2 is
    result varchar2(32767);
  begin
    if self.list.first is not null then
      for reg in self.list.first .. self.list.last
      loop
        if self.list.exists(reg) then
          result := result || self.list(reg).to_char(formato);
          if reg <> self.list.last then
            result := result || separador;
          end if;
        end if;
      end loop;
    end if;
    return result;
  end;

  member function to_table return argsdt is
  begin
    return self.list;
  end;

  member function mostra(formato varchar2 default 'DD/MM/RRRR', separador varchar2 default ';') return varchar2 is
  begin
    return to_char(formato, separador);
  end;

end;
/
