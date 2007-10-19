create or replace type period as object
(
-- Attributes
  inicio datetime,
  fim    datetime,

-- Constructor
  constructor function period return self as result,
  constructor function period(inicio   date
                             ,fim      date default null
                             ,dias     number default null
                             ,meses    number default null
                             ,anos     number default null
                             ,horas    number default null
                             ,minutos  number default null
                             ,segundos number default null) return self as result,
  constructor function period(inicio   varchar2
                             ,fim      varchar2 default null
                             ,dias     number default null
                             ,meses    number default null
                             ,anos     number default null
                             ,horas    number default null
                             ,minutos  number default null
                             ,segundos number default null
                             ,formato  varchar2 default 'DD/MM/RRRR') return self as result,
-- Member functions and procedures
  member procedure atribuir(self     in out nocopy period
                           ,inicio   datetime default datetime(null)
                           ,fim      datetime default datetime(null)
                           ,dias     number default null
                           ,meses    number default null
                           ,anos     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null
                           ,limpar   boolean default false),
  member function atribuir(self     in out nocopy period
                          ,inicio   datetime default datetime(null)
                          ,fim      datetime default datetime(null)
                          ,dias     number default null
                          ,meses    number default null
                          ,anos     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null
                          ,limpar   boolean default false) return period,
  member procedure atribuir(inicio   date default null
                           ,fim      date default null
                           ,dias     number default null
                           ,meses    number default null
                           ,anos     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null
                           ,limpar   boolean default false),
  member function atribuir(self     in out nocopy period
                          ,inicio   date default null
                          ,fim      date default null
                          ,dias     number default null
                          ,meses    number default null
                          ,anos     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null
                          ,limpar   boolean default false) return period,
  member procedure atribuir(inicio   varchar2 default null
                           ,fim      varchar2 default null
                           ,dias     number default null
                           ,meses    number default null
                           ,anos     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null
                           ,formato  varchar2 default 'DD/MM/RRRR'
                           ,limpar   boolean default false),
  member function atribuir(self     in out nocopy period
                          ,inicio   varchar2 default null
                          ,fim      varchar2 default null
                          ,dias     number default null
                          ,meses    number default null
                          ,anos     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null
                          ,formato  varchar2 default 'DD/MM/RRRR'
                          ,limpar   boolean default false) return period,
  member function alterar(inicio date default null
                         ,fim    date default null) return period,
  member function limitar(periodo period) return period,
  member function limitar(inicio datetime default datetime(null)
                         ,fim    datetime default datetime(null)) return period,
  member function limitar(inicio date default null
                         ,fim    date default null) return period,
  member function limitar(inicio  varchar2 default null
                         ,fim     varchar2 default null
                         ,formato varchar2 default 'DD/MM/RRRR') return period,
  member function adicionar(dias     number default null
                           ,meses    number default null
                           ,anos     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null) return period,
  member procedure adicionar(self     in out nocopy period
                            ,dias     number default null
                            ,meses    number default null
                            ,anos     number default null
                            ,horas    number default null
                            ,minutos  number default null
                            ,segundos number default null),
  member function add_inicio(dias     number default null
                            ,meses    number default null
                            ,anos     number default null
                            ,horas    number default null
                            ,minutos  number default null
                            ,segundos number default null) return period,
  member procedure add_inicio(self     in out nocopy period
                             ,dias     number default null
                             ,meses    number default null
                             ,anos     number default null
                             ,horas    number default null
                             ,minutos  number default null
                             ,segundos number default null),
  member function add_fim(dias     number default null
                         ,meses    number default null
                         ,anos     number default null
                         ,horas    number default null
                         ,minutos  number default null
                         ,segundos number default null) return period,
  member procedure add_fim(self     in out nocopy period
                          ,dias     number default null
                          ,meses    number default null
                          ,anos     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null),
  member function subtrair(dias     number default null
                          ,meses    number default null
                          ,anos     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null) return period,
  member procedure subtrair(self     in out nocopy period
                           ,dias     number default null
                           ,meses    number default null
                           ,anos     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null),
  member function sub_inicio(dias     number default null
                            ,meses    number default null
                            ,anos     number default null
                            ,horas    number default null
                            ,minutos  number default null
                            ,segundos number default null) return period,
  member procedure sub_inicio(self     in out nocopy period
                             ,dias     number default null
                             ,meses    number default null
                             ,anos     number default null
                             ,horas    number default null
                             ,minutos  number default null
                             ,segundos number default null),
  member function sub_fim(dias     number default null
                         ,meses    number default null
                         ,anos     number default null
                         ,horas    number default null
                         ,minutos  number default null
                         ,segundos number default null) return period,
  member procedure sub_fim(self     in out nocopy period
                          ,dias     number default null
                          ,meses    number default null
                          ,anos     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null),
  member function nulo return boolean,
  member function nao_nulo return boolean,
  member function inicio_nulo(data date default '01/01/0001') return datetime,
  member function fim_nulo(data date default '31/12/9999') return datetime,
  member function fim_menor return boolean,
  member function dias(contar_dia_inicial boolean default true) return number,
  member function meses return number,
  member function anos return number,
  member function horas return number,
  member function minutos return number,
  member function segundos return number,
  member function tempo return varchar2,
  member function cruzamento(periodo period) return varchar2,
  member function cruzamento(inicio datetime
                            ,fim    datetime) return varchar2,
  member function cruzamento(inicio  varchar2
                            ,fim     varchar2
                            ,formato varchar2 default 'DD/MM/RRRR') return varchar2,
  member function cruzamento(inicio date
                            ,fim    date) return varchar2,
  member function cruzamento_lista(list      varchar2
                                  ,formato   varchar2 default 'DD/MM/RRRR'
                                  ,separador varchar2 default ';') return varchar2,
  member function cruzamento_horas(data       date
                                  ,inicio_fim boolean default true) return varchar2,
  member function cruzamento_horas(data       varchar2
                                  ,inicio_fim boolean default true) return varchar2,
  member function cruzamento_horas(inicio     date
                                  ,fim        date
                                  ,inicio_fim boolean default true) return varchar2,
  member function cruzamento_horas(inicio     varchar2
                                  ,fim        varchar2
                                  ,inicio_fim boolean default true) return varchar2,
  member function esta_dentro(periodo period) return varchar2,
  member function esta_dentro(inicio datetime
                             ,fim    datetime) return varchar2,
  member function esta_dentro(inicio date
                             ,fim    date) return varchar2,
  member function esta_dentro(inicio  varchar2
                             ,fim     varchar2
                             ,formato varchar2 default 'DD/MM/RRRR') return varchar2,
  member function abrange(periodo period) return varchar2,
  member function abrange(inicio datetime
                         ,fim    datetime) return varchar2,
  member function abrange(inicio date
                         ,fim    date) return varchar2,
  member function abrange(inicio  varchar2
                         ,fim     varchar2
                         ,formato varchar2 default 'DD/MM/RRRR') return varchar2,
  member function possui(data datetime) return varchar2,
  member function possui(data date) return varchar2,
  member function possui(data    varchar2
                        ,formato varchar2 default 'DD/MM/RRRR') return varchar2,
  member function mostra(formato varchar2 default 'DD/MM/RRRR') return varchar2
)
/
create or replace type body period is

  -- Constructor
  constructor function period return self as result is
  begin
    self.inicio := datetime(null);
    self.fim    := datetime(null);
    return;
  end;

  constructor function period(inicio   date
                             ,fim      date default null
                             ,dias     number default null
                             ,meses    number default null
                             ,anos     number default null
                             ,horas    number default null
                             ,minutos  number default null
                             ,segundos number default null) return self as result is
  begin
    atribuir(datetime(inicio), datetime(fim), dias, meses, anos, horas, minutos, segundos, true);
    return;
  end;

  constructor function period(inicio   varchar2
                             ,fim      varchar2 default null
                             ,dias     number default null
                             ,meses    number default null
                             ,anos     number default null
                             ,horas    number default null
                             ,minutos  number default null
                             ,segundos number default null
                             ,formato  varchar2 default 'DD/MM/RRRR') return self as result is
  begin
    atribuir(datetime(inicio, formato)
            ,datetime(fim, formato)
            ,dias
            ,meses
            ,anos
            ,horas
            ,minutos
            ,segundos
            ,true);
    return;
  end;

  -- Member procedures and functions
  member procedure atribuir(self     in out nocopy period
                           ,inicio   datetime default datetime(null)
                           ,fim      datetime default datetime(null)
                           ,dias     number default null
                           ,meses    number default null
                           ,anos     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null
                           ,limpar   boolean default false) is
  begin
    if inicio.nao_nulo
       or limpar then
      self.inicio := inicio;
    end if;
    -- --
    if dias is not null
       or meses is not null
       or anos is not null
       or horas is not null
       or minutos is not null
       or segundos is not null then
      if fim.nulo then
        self.fim := self.inicio;
      else
        self.fim := fim;
      end if;
      self.fim.adicionar(dias, meses, anos, horas, minutos, segundos);
    else
      if fim.nao_nulo
         or limpar then
        self.fim := fim;
      end if;
    end if;
  end atribuir;

  member function atribuir(self     in out nocopy period
                          ,inicio   datetime default datetime(null)
                          ,fim      datetime default datetime(null)
                          ,dias     number default null
                          ,meses    number default null
                          ,anos     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null
                          ,limpar   boolean default false) return period is
  begin
    atribuir(inicio, fim, dias, meses, anos, horas, minutos, segundos, limpar);
    return self;
  end atribuir;

  member procedure atribuir(inicio   date default null
                           ,fim      date default null
                           ,dias     number default null
                           ,meses    number default null
                           ,anos     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null
                           ,limpar   boolean default false) is
  begin
    atribuir(datetime(inicio), datetime(fim), dias, meses, anos, horas, minutos, segundos, limpar);
  end atribuir;

  member function atribuir(self     in out nocopy period
                          ,inicio   date default null
                          ,fim      date default null
                          ,dias     number default null
                          ,meses    number default null
                          ,anos     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null
                          ,limpar   boolean default false) return period is
  begin
    atribuir(datetime(inicio), datetime(fim), dias, meses, anos, horas, minutos, segundos, limpar);
    return self;
  end atribuir;

  member procedure atribuir(inicio   varchar2 default null
                           ,fim      varchar2 default null
                           ,dias     number default null
                           ,meses    number default null
                           ,anos     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null
                           ,formato  varchar2 default 'DD/MM/RRRR'
                           ,limpar   boolean default false) is
  begin
    atribuir(datetime(inicio, formato)
            ,datetime(fim, formato)
            ,dias
            ,meses
            ,anos
            ,horas
            ,minutos
            ,segundos
            ,limpar);
  end atribuir;

  member function atribuir(self     in out nocopy period
                          ,inicio   varchar2 default null
                          ,fim      varchar2 default null
                          ,dias     number default null
                          ,meses    number default null
                          ,anos     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null
                          ,formato  varchar2 default 'DD/MM/RRRR'
                          ,limpar   boolean default false) return period is
  begin
    atribuir(datetime(inicio, formato)
            ,datetime(fim, formato)
            ,dias
            ,meses
            ,anos
            ,horas
            ,minutos
            ,segundos
            ,limpar);
    return self;
  end atribuir;

  member function alterar(inicio date default null
                         ,fim    date default null) return period is
  begin
    return period(nvl(inicio, self.inicio.data), nvl(fim, self.fim.data));
  end alterar;

  member function limitar(periodo period) return period is
  begin
    return period(greatest(nvl(periodo.inicio.data, self.inicio.data), self.inicio_nulo().data)
                 ,least(nvl(periodo.fim.data, self.fim.data), self.fim_nulo().data));
  end limitar;

  member function limitar(inicio datetime default datetime(null)
                         ,fim    datetime default datetime(null)) return period is
  begin
    return limitar(period(inicio, fim));
  end limitar;

  member function limitar(inicio date default null
                         ,fim    date default null) return period is
  begin
    return limitar(period(datetime(inicio), datetime(fim)));
  end limitar;

  member function limitar(inicio  varchar2 default null
                         ,fim     varchar2 default null
                         ,formato varchar2 default 'DD/MM/RRRR') return period is
  begin
    return limitar(period(datetime(inicio, formato), datetime(fim, formato)));
  end limitar;

  member function adicionar(dias     number default null
                           ,meses    number default null
                           ,anos     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null) return period is
  begin
    return period(self.inicio.adicionar(dias, meses, anos, horas, minutos, segundos)
                 ,self.fim.adicionar(dias, meses, anos, horas, minutos, segundos));
  end adicionar;

  member procedure adicionar(self     in out nocopy period
                            ,dias     number default null
                            ,meses    number default null
                            ,anos     number default null
                            ,horas    number default null
                            ,minutos  number default null
                            ,segundos number default null) is
  begin
    self.inicio.adicionar(dias, meses, anos, horas, minutos, segundos);
    self.fim.adicionar(dias, meses, anos, horas, minutos, segundos);
  end adicionar;

  member function add_inicio(dias     number default null
                            ,meses    number default null
                            ,anos     number default null
                            ,horas    number default null
                            ,minutos  number default null
                            ,segundos number default null) return period is
  begin
    return period(self.inicio.adicionar(dias, meses, anos, horas, minutos, segundos), self.fim);
  end add_inicio;

  member procedure add_inicio(self     in out nocopy period
                             ,dias     number default null
                             ,meses    number default null
                             ,anos     number default null
                             ,horas    number default null
                             ,minutos  number default null
                             ,segundos number default null) is
  begin
    self.inicio.adicionar(dias, meses, anos, horas, minutos, segundos);
  end add_inicio;

  member function add_fim(dias     number default null
                         ,meses    number default null
                         ,anos     number default null
                         ,horas    number default null
                         ,minutos  number default null
                         ,segundos number default null) return period is
  begin
    return period(self.inicio, self.fim.adicionar(dias, meses, anos, horas, minutos, segundos));
  end add_fim;

  member procedure add_fim(self     in out nocopy period
                          ,dias     number default null
                          ,meses    number default null
                          ,anos     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null) is
  begin
    self.fim.adicionar(dias, meses, anos, horas, minutos, segundos);
  end add_fim;

  member function subtrair(dias     number default null
                          ,meses    number default null
                          ,anos     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null) return period is
  begin
    return period(self.inicio.subtrair(dias, meses, anos, horas, minutos, segundos)
                 ,self.fim.subtrair(dias, meses, anos, horas, minutos, segundos));
  end subtrair;

  member procedure subtrair(self     in out nocopy period
                           ,dias     number default null
                           ,meses    number default null
                           ,anos     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null) is
  begin
    self.inicio.subtrair(dias, meses, anos, horas, minutos, segundos);
    self.fim.subtrair(dias, meses, anos, horas, minutos, segundos);
  end subtrair;

  member function sub_inicio(dias     number default null
                            ,meses    number default null
                            ,anos     number default null
                            ,horas    number default null
                            ,minutos  number default null
                            ,segundos number default null) return period is
  begin
    return period(self.inicio.subtrair(dias, meses, anos, horas, minutos, segundos), self.fim);
  end sub_inicio;

  member procedure sub_inicio(self     in out nocopy period
                             ,dias     number default null
                             ,meses    number default null
                             ,anos     number default null
                             ,horas    number default null
                             ,minutos  number default null
                             ,segundos number default null) is
  begin
    self.inicio.subtrair(dias, meses, anos, horas, minutos, segundos);
  end sub_inicio;

  member function sub_fim(dias     number default null
                         ,meses    number default null
                         ,anos     number default null
                         ,horas    number default null
                         ,minutos  number default null
                         ,segundos number default null) return period is
  begin
    return period(self.inicio, self.fim.subtrair(dias, meses, anos, horas, minutos, segundos));
  end sub_fim;

  member procedure sub_fim(self     in out nocopy period
                          ,dias     number default null
                          ,meses    number default null
                          ,anos     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null) is
  begin
    self.fim.subtrair(dias, meses, anos, horas, minutos, segundos);
  end sub_fim;

  member function nulo return boolean is
  begin
    if self.inicio.data is null
       and self.fim.data is null then
      return true;
    else
      return false;
    end if;
  end;

  member function nao_nulo return boolean is
  begin
    return not(nulo);
  end;

  member function inicio_nulo(data date default '01/01/0001') return datetime is
  begin
    return self.inicio.se_nulo(data);
  end;

  member function fim_nulo(data date default '31/12/9999') return datetime is
  begin
    return self.fim.se_nulo(data);
  end;

  member function fim_menor return boolean is
  begin
    if self.fim.data < self.inicio.data then
      return true;
    else
      return false;
    end if;
  end;

  member function dias(contar_dia_inicial boolean default true) return number is
    result number;
  begin
    result := trunc(fim_nulo().data - inicio_nulo().data);
    -- se é apenas data conta dia completo
    if contar_dia_inicial
       and
       to_number(to_char(inicio_nulo().data, 'HH24MISS') || to_char(fim_nulo().data, 'HH24MISS')) = 0 then
      result := result + 1;
    end if;
    -- --
    return result;
  end;

  member function meses return number is
  begin
    return trunc(months_between(fim_nulo().data, inicio_nulo().data));
  end;

  member function anos return number is
  begin
    return trunc(months_between(fim_nulo().data, inicio_nulo().data) / 12);
  end;

  member function horas return number is
  begin
    return round((fim_nulo().data - inicio_nulo().data) * 24);
  end;

  member function minutos return number is
  begin
    return round((fim_nulo().data - inicio_nulo().data) * 24 * 60);
  end;

  member function segundos return number is
  begin
    return round((fim_nulo().data - inicio_nulo().data) * 24 * 60 * 60);
  end;

  member function tempo return varchar2 is
    result  varchar2(500);
    ano     number := 0;
    mes     number := 0;
    dia     number := 0;
    hora    number := 0;
    minuto  number := 0;
    segundo number := 0;
    diff    date;
  begin
    -- Obtém os períodos de ano, mês, dia, hora, minuto e segundo
    diff := to_date('01/01/0001 00:00:00', 'DD/MM/RRRR HH24:MI:SS') +
            (fim_nulo().data - inicio_nulo().data);
    -- --
    hora    := to_char(diff, 'HH24');
    minuto  := to_char(diff, 'MI');
    segundo := to_char(diff, 'SS');
    ano     := to_char(diff, 'RRRR') - 1;
    mes     := to_char(diff, 'MM') - 1;
    dia     := to_char(diff, 'DD');
    -- tratamento apenas de datas
    if not (to_char(fim_nulo().data, 'HH24MISS') = 0 and to_char(inicio_nulo().data, 'HH24MISS') = 0) then
      dia := dia - 1;
    end if;
    -- --
  
    -- Plural de ano
    if (ano > 1) then
      result := result || ano || ' anos ';
    elsif ano > 0 then
      result := result || ano || ' ano ';
    end if;
  
    -- e MÊS
    if (mes > 0 and ano > 0 and (dia + hora + minuto + segundo) = 0) then
      result := result || 'e ';
    end if;
  
    -- Plural de mês
    if (mes > 1) then
      result := result || mes || ' meses ';
    elsif mes > 0 then
      result := result || mes || ' mês ';
    end if;
  
    -- e DIA
    if (dia > 0 and (mes + ano) > 0 and (hora + minuto + segundo) = 0) then
      result := result || 'e ';
    end if;
  
    -- Plural de dia
    if (dia > 1) then
      result := result || dia || ' dias ';
    elsif (dia > 0) then
      result := result || dia || ' dia ';
    end if;
  
    -- e HORA
    if (hora > 0 and (dia + mes + ano) > 0 and (minuto + segundo) = 0) then
      result := result || 'e ';
    end if;
  
    -- Plural de hora
    if (hora > 1) then
      result := result || hora || ' horas ';
    elsif (hora > 0) then
      result := result || hora || ' hora ';
    end if;
  
    -- e MINUTO
    if (minuto > 0 and (hora + dia + mes + ano) > 0 and segundo = 0) then
      result := result || 'e ';
    end if;
  
    -- Plural de minuto
    if (minuto > 1) then
      result := result || minuto || ' minutos ';
    elsif (minuto > 0) then
      result := result || minuto || ' minuto ';
    end if;
  
    -- e SEGUNDO
    if (segundo > 0 and (minuto + hora + dia + mes + ano) > 0) then
      result := result || 'e ';
    end if;
  
    -- Plural de segundo
    if (segundo > 1) then
      result := result || segundo || ' segundos';
    elsif (segundo > 0) then
      result := result || segundo || ' segundo';
    end if;
  
    return trim(result);
  exception
    when others then
      return null;
  end;

  member function cruzamento(periodo period) return varchar2 is
    vdata_ini1 date := trunc(self.inicio_nulo().data);
    vdata_fim1 date := trunc(self.fim_nulo().data);
    vdata_ini2 date := trunc(periodo.inicio_nulo().data);
    vdata_fim2 date := trunc(periodo.fim_nulo().data);
  begin
    if self.nao_nulo
       and periodo.nao_nulo
       and (vdata_fim2 between vdata_ini1 and vdata_fim1 or vdata_ini2 between vdata_ini1 and vdata_fim1 or
       (vdata_ini2 < vdata_ini1 and vdata_fim2 > vdata_fim1)) then
      return 'S';
    else
      return 'N';
    end if;
  end cruzamento;

  member function cruzamento(inicio datetime
                            ,fim    datetime) return varchar2 is
  begin
    return cruzamento(period(inicio, fim));
  end cruzamento;

  member function cruzamento(inicio date
                            ,fim    date) return varchar2 is
  begin
    return cruzamento(period(inicio, fim));
  end cruzamento;

  member function cruzamento(inicio  varchar2
                            ,fim     varchar2
                            ,formato varchar2 default 'DD/MM/RRRR') return varchar2 is
  begin
    return cruzamento(period(datetime(inicio, formato), datetime(fim, formato)));
  end;

  member function cruzamento_lista(list      varchar2
                                  ,formato   varchar2 default 'DD/MM/RRRR'
                                  ,separador varchar2 default ';') return varchar2 is
  begin
    for reg in (select to_date(column_value, formato) val from table(text(list).to_table(separador)))
    loop
      if bool(possui(reg.val)).to_bool then
        return 'S';
      end if;
    end loop;
    return 'N';
  end cruzamento_lista;

  member function cruzamento_horas(data       date
                                  ,inicio_fim boolean default true) return varchar2 is
  begin
    return datetime(data).cruzamento_horas(self.inicio_nulo().data, self.fim_nulo().data, inicio_fim);
  end cruzamento_horas;

  member function cruzamento_horas(data       varchar2
                                  ,inicio_fim boolean default true) return varchar2 is
  begin
    return datetime(substr(text(data).apenas_numeros(), -4), 'HH24MI').cruzamento_horas(self.inicio_nulo().data
                                                                                       ,self.fim_nulo   ().data
                                                                                       ,inicio_fim);
  end cruzamento_horas;

  member function cruzamento_horas(inicio     date
                                  ,fim        date
                                  ,inicio_fim boolean default true) return varchar2 is
    vhora_ini1 date := to_date(self.inicio_nulo().mostra('HH24MI'), 'HH24MI');
    vhora_fim1 date := to_date(nvl(self.fim_nulo().mostra('HH24MI'), '2359'), 'HH24MI');
    vhora_ini2 date := to_date(to_char(inicio, 'HH24MI'), 'HH24MI');
    vhora_fim2 date := to_date(nvl(to_char(fim, 'HH24MI'), '2359'), 'HH24MI');
  begin
    -- pode ter final e inicio igual
    if inicio_fim then
      vhora_fim1 := vhora_fim1 - (1 / 24 / 60);
      vhora_fim2 := vhora_fim2 - (1 / 24 / 60);
    end if;
    -- verifica cruzamento
    if (vhora_ini1 between vhora_ini2 and vhora_fim2)
       or (vhora_fim1 between vhora_ini2 and vhora_fim2)
       or (vhora_ini1 < vhora_ini2 and vhora_fim1 > vhora_fim2) then
      return 'S';
    else
      return 'N';
    end if;
  end cruzamento_horas;

  member function cruzamento_horas(inicio     varchar2
                                  ,fim        varchar2
                                  ,inicio_fim boolean default true) return varchar2 is
    vinicio date := to_date(substr(text(inicio).apenas_numeros(), -4), 'HH24MI');
    vfim    date := to_date(nvl(substr(text(fim).apenas_numeros(), -4), '2359'), 'HH24MI');
  begin
    return cruzamento_horas(vinicio, vfim, inicio_fim);
  end cruzamento_horas;

  member function esta_dentro(periodo period) return varchar2 is
    vdentro_inicio date := trunc(self.inicio_nulo().data);
    vdentro_fim    date := trunc(self.fim_nulo().data);
    vmargem_inicio date := trunc(periodo.inicio_nulo().data);
    vmargem_fim    date := trunc(periodo.fim_nulo().data);
  begin
    if self.nao_nulo
       and periodo.nao_nulo
       and vdentro_inicio between vmargem_inicio and vmargem_fim
       and vdentro_fim between vmargem_inicio and vmargem_fim then
      return 'S';
    else
      return 'N';
    end if;
  end esta_dentro;

  member function esta_dentro(inicio datetime
                             ,fim    datetime) return varchar2 is
  begin
    return esta_dentro(period(inicio, fim));
  end esta_dentro;

  member function esta_dentro(inicio date
                             ,fim    date) return varchar2 is
  begin
    return esta_dentro(period(inicio, fim));
  end esta_dentro;

  member function esta_dentro(inicio  varchar2
                             ,fim     varchar2
                             ,formato varchar2 default 'DD/MM/RRRR') return varchar2 is
  begin
    return esta_dentro(period(datetime(inicio, formato), datetime(fim, formato)));
  end esta_dentro;

  member function abrange(periodo period) return varchar2 is
  begin
    return periodo.esta_dentro(self);
  end abrange;

  member function abrange(inicio datetime
                         ,fim    datetime) return varchar2 is
  begin
    return abrange(period(inicio, fim));
  end abrange;

  member function abrange(inicio date
                         ,fim    date) return varchar2 is
  begin
    return abrange(period(inicio, fim));
  end abrange;

  member function abrange(inicio  varchar2
                         ,fim     varchar2
                         ,formato varchar2 default 'DD/MM/RRRR') return varchar2 is
  begin
    return abrange(period(datetime(inicio, formato), datetime(fim, formato)));
  end abrange;

  member function possui(data datetime) return varchar2 is
  begin
    return data.esta_dentro(self.inicio, self.fim);
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

  member function mostra(formato varchar2 default 'DD/MM/RRRR') return varchar2 is
  begin
    if self.fim.data is not null
       and self.inicio.data is not null then
      return self.inicio.mostra(formato) || ' a ' || self.fim.mostra(formato);
    elsif self.inicio.data is not null
          and self.fim.data is null then
      return 'A partir de ' || self.inicio.mostra(formato);
    elsif self.inicio.data is null
          and self.fim.data is not null then
      return 'Até ' || self.fim.mostra(formato);
    else
      return '<infinito>';
    end if;
  end;

end;
/
