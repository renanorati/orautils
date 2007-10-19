create or replace type datetime as object
(
-- Attributes
  data date,

-- Constructor
  constructor function datetime return self as result,
  constructor function datetime(data    varchar2
                               ,formato varchar2) return self as result,
-- Member functions and procedures
  member procedure atribuir(self in out nocopy datetime
                           ,data date default null),
  member function atribuir(self in out nocopy datetime
                          ,data date default null) return datetime,
  member procedure atribuir(self    in out nocopy datetime
                           ,data    varchar2
                           ,formato varchar2 default 'DD/MM/RRRR'),
  member function atribuir(self    in out nocopy datetime
                          ,data    varchar2
                          ,formato varchar2 default 'DD/MM/RRRR') return datetime,
  member procedure atribuir(self    in out nocopy datetime
                           ,dia     number default null
                           ,mes     number default null
                           ,ano     number default null
                           ,hora    number default null
                           ,minuto  number default null
                           ,segundo number default null),
  member function atribuir(self    in out nocopy datetime
                          ,dia     number default null
                          ,mes     number default null
                          ,ano     number default null
                          ,hora    number default null
                          ,minuto  number default null
                          ,segundo number default null) return datetime,
  member function alterar(dia     number default null
                         ,mes     number default null
                         ,ano     number default null
                         ,hora    number default null
                         ,minuto  number default null
                         ,segundo number default null) return datetime,
  member procedure limpar(self in out nocopy datetime),
  member function limpar(self in out nocopy datetime) return datetime,
  member function adicionar(dias     number default null
                           ,meses    number default null
                           ,anos     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null) return datetime,
  member procedure adicionar(self     in out nocopy datetime
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
                          ,segundos number default null) return datetime,
  member procedure subtrair(self     in out nocopy datetime
                           ,dias     number default null
                           ,meses    number default null
                           ,anos     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null),
  member function dia return number,
  member function mes return number,
  member function ano return number,
  member function hora return number,
  member function minuto return number,
  member function segundo return number,
  member function dia_semana return number,
  member function fim_de_semana return boolean,
  member function nulo return boolean,
  member function nao_nulo return boolean,
  member function se_nulo(data datetime) return datetime,
  member procedure se_nulo(self in out nocopy datetime
                          ,data datetime),
  member function se_nulo(data date) return datetime,
  member procedure se_nulo(self in out nocopy datetime
                          ,data date),
  member function se_nulo(data    varchar2
                         ,formato varchar2 default 'DD/MM/RRRR') return datetime,
  member procedure se_nulo(data    varchar2
                          ,formato varchar2 default 'DD/MM/RRRR'),
  member function esta_na_lista(list      varchar2
                               ,formato   varchar2 default 'DD/MM/RRRR'
                               ,separador varchar2 default ';') return varchar2,
  member function esta_dentro(inicio datetime
                             ,fim    datetime) return varchar2,
  member function esta_dentro(inicio date
                             ,fim    date) return varchar2,
  member function esta_dentro(inicio  varchar2
                             ,fim     varchar2
                             ,formato varchar2 default 'DD/MM/RRRR') return varchar2,
  member function cruzamento_horas(hora_ini   date
                                  ,hora_fim   date
                                  ,inicio_fim boolean default false) return varchar2,
  member function cruzamento_horas(hora_ini   varchar2
                                  ,hora_fim   varchar2
                                  ,inicio_fim boolean default false) return varchar2,
  member function truncado return date,
  member function get return date,
  member function mostra(formato varchar2 default 'DD/MM/RRRR') return varchar2
)
/
create or replace type body datetime is

  -- Constructor
  constructor function datetime return self as result is
  begin
    self.data := null;
    return;
  end;

  constructor function datetime(data    varchar2
                               ,formato varchar2) return self as result is
  begin
    self.data := to_date(data, nvl(formato, 'DD/MM/RRRR'));
    return;
  end;

  -- Member procedures and functions
  member procedure atribuir(self in out nocopy datetime
                           ,data date default null) is
  begin
    if data is not null then
      self.data := data;
    end if;
  end atribuir;

  member function atribuir(self in out nocopy datetime
                          ,data date default null) return datetime is
  begin
    atribuir(data);
    return self;
  end atribuir;

  member procedure atribuir(self    in out nocopy datetime
                           ,data    varchar2
                           ,formato varchar2 default 'DD/MM/RRRR') is
  begin
    if data is not null then
      self.data := to_date(data, formato);
    end if;
  end atribuir;

  member function atribuir(self    in out nocopy datetime
                          ,data    varchar2
                          ,formato varchar2 default 'DD/MM/RRRR') return datetime is
  begin
    atribuir(data, formato);
    return self;
  end atribuir;

  member procedure atribuir(self    in out nocopy datetime
                           ,dia     number default null
                           ,mes     number default null
                           ,ano     number default null
                           ,hora    number default null
                           ,minuto  number default null
                           ,segundo number default null) is
  begin
    self := alterar(dia, mes, ano, hora, minuto, segundo);
  end atribuir;

  member function atribuir(self    in out nocopy datetime
                          ,dia     number default null
                          ,mes     number default null
                          ,ano     number default null
                          ,hora    number default null
                          ,minuto  number default null
                          ,segundo number default null) return datetime is
  begin
    self := alterar(dia, mes, ano, hora, minuto, segundo);
    return self;
  end atribuir;

  member function alterar(dia     number default null
                         ,mes     number default null
                         ,ano     number default null
                         ,hora    number default null
                         ,minuto  number default null
                         ,segundo number default null) return datetime is
    formato      varchar2(50);
    formato_novo varchar2(50);
    ndata        varchar2(50);
  begin
    if dia is not null then
      formato_novo := formato_novo || 'DD';
      ndata        := ndata || lpad(dia, 2, '0');
    else
      formato := formato || 'DD';
    end if;
    if mes is not null then
      formato_novo := formato_novo || 'MM';
      ndata        := ndata || lpad(mes, 2, '0');
    else
      formato := formato || 'MM';
    end if;
    if ano is not null then
      formato_novo := formato_novo || 'RRRR';
      ndata        := ndata || lpad(ano, 4, '0');
    else
      formato := formato || 'RRRR';
    end if;
    if hora is not null then
      formato_novo := formato_novo || 'HH24';
      ndata        := ndata || lpad(hora, 2, '0');
    else
      formato := formato || 'HH24';
    end if;
    if minuto is not null then
      formato_novo := formato_novo || 'MI';
      ndata        := ndata || lpad(minuto, 2, '0');
    else
      formato := formato || 'MI';
    end if;
    if segundo is not null then
      formato_novo := formato_novo || 'SS';
      ndata        := ndata || lpad(segundo, 2, '0');
    else
      formato := formato || 'SS';
    end if;
    return datetime(to_date(ndata || to_char(self.data, formato), formato_novo || formato));
  end alterar;

  member procedure limpar(self in out nocopy datetime) is
  begin
    self.data := null;
  end limpar;

  member function limpar(self in out nocopy datetime) return datetime is
  begin
    limpar;
    return self;
  end limpar;

  member function adicionar(dias     number default null
                           ,meses    number default null
                           ,anos     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null) return datetime is
    result datetime := self;
  begin
    if dias is not null then
      result.data := result.data + dias;
    end if;
    if meses is not null then
      result.data := add_months(result.data, meses);
    end if;
    if anos is not null then
      result.data := add_months(result.data, anos * 12);
    end if;
    if horas is not null then
      result.data := result.data + ((1 / 24) * horas);
    end if;
    if minutos is not null then
      result.data := result.data + ((1 / 24 / 60) * minutos);
    end if;
    if segundos is not null then
      result.data := result.data + ((1 / 24 / 60 / 60) * segundos);
    end if;
    return result;
  end adicionar;

  member procedure adicionar(self     in out nocopy datetime
                            ,dias     number default null
                            ,meses    number default null
                            ,anos     number default null
                            ,horas    number default null
                            ,minutos  number default null
                            ,segundos number default null) is
  begin
    self := adicionar(dias, meses, anos, horas, minutos, segundos);
  end adicionar;

  member function subtrair(dias     number default null
                          ,meses    number default null
                          ,anos     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null) return datetime is
  begin
    return adicionar(-dias, -meses, -anos, -horas, -minutos, -segundos);
  end subtrair;

  member procedure subtrair(self     in out nocopy datetime
                           ,dias     number default null
                           ,meses    number default null
                           ,anos     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null) is
  begin
    self := adicionar(-dias, -meses, -anos, -horas, -minutos, -segundos);
  end subtrair;

  member function dia return number is
  begin
    return to_char(self.data, 'DD');
  end dia;

  member function mes return number is
  begin
    return to_char(self.data, 'MM');
  end mes;

  member function ano return number is
  begin
    return to_char(self.data, 'RRRR');
  end ano;

  member function hora return number is
  begin
    return to_char(self.data, 'HH24');
  end hora;

  member function minuto return number is
  begin
    return to_char(self.data, 'MI');
  end minuto;

  member function segundo return number is
  begin
    return to_char(self.data, 'SS');
  end segundo;

  member function dia_semana return number is
  begin
    return to_char(self.data, 'D');
  end dia_semana;

  member function fim_de_semana return boolean is
  begin
    if self.dia_semana in (1, 7) then
      return true;
    else
      return false;
    end if;
  end fim_de_semana;

  member function nulo return boolean is
  begin
    if self.data is null then
      return true;
    else
      return false;
    end if;
  end;

  member function nao_nulo return boolean is
  begin
    return not(nulo);
  end;

  member function se_nulo(data datetime) return datetime is
  begin
    if self.data is null then
      return data;
    else
      return self;
    end if;
  end;

  member procedure se_nulo(self in out nocopy datetime
                          ,data datetime) is
  begin
    if self.data is null then
      self := data;
    end if;
  end;

  member function se_nulo(data date) return datetime is
  begin
    return se_nulo(datetime(data));
  end;

  member procedure se_nulo(data date) is
  begin
    se_nulo(datetime(data));
  end;

  member function se_nulo(data    varchar2
                         ,formato varchar2 default 'DD/MM/RRRR') return datetime is
  begin
    return se_nulo(datetime(data, formato));
  end;

  member procedure se_nulo(data    varchar2
                          ,formato varchar2 default 'DD/MM/RRRR') is
  begin
    se_nulo(datetime(data, formato));
  end;

  member function esta_dentro(inicio datetime
                             ,fim    datetime) return varchar2 is
  begin
    if self.truncado between (inicio.se_nulo('01/01/0001').truncado) and
       (fim.se_nulo('31/12/9999').truncado) then
      return 'S';
    else
      return 'N';
    end if;
  end esta_dentro;

  member function esta_dentro(inicio date
                             ,fim    date) return varchar2 is
  begin
    return esta_dentro(datetime(inicio), datetime(fim));
  end esta_dentro;

  member function esta_dentro(inicio  varchar2
                             ,fim     varchar2
                             ,formato varchar2 default 'DD/MM/RRRR') return varchar2 is
  begin
    return esta_dentro(datetime(inicio, formato), datetime(fim, formato));
  end esta_dentro;

  member function esta_na_lista(list      varchar2
                               ,formato   varchar2 default 'DD/MM/RRRR'
                               ,separador varchar2 default ';') return varchar2 is
  begin
    for reg in (select to_date(column_value, formato) val from table(text(list).to_table(separador)))
    loop
      if self.truncado = trunc(reg.val) then
        return 'S';
      end if;
    end loop;
    return 'N';
  end esta_na_lista;

  member function cruzamento_horas(hora_ini   date
                                  ,hora_fim   date
                                  ,inicio_fim boolean default false) return varchar2 is
    vhora     date := to_date(self.mostra('HH24MI'), 'HH24MI');
    vhora_ini date := to_date(to_char(hora_ini, 'HH24MI'), 'HH24MI');
    vhora_fim date := to_date(nvl(to_char(hora_fim, 'HH24MI'), '2359'), 'HH24MI');
  begin
    -- pode ter final e inicio igual
    if inicio_fim then
      vhora_fim := vhora_fim - (1 / 24 / 60);
    end if;
    -- verifica cruzamento
    if vhora between vhora_ini and vhora_fim then
      return 'S';
    else
      return 'N';
    end if;
  end cruzamento_horas;

  member function cruzamento_horas(hora_ini   varchar2
                                  ,hora_fim   varchar2
                                  ,inicio_fim boolean default false) return varchar2 is
    vhora_ini date := to_date(substr(text(hora_ini).apenas_numeros(), -4), 'HH24MI');
    vhora_fim date := to_date(nvl(substr(text(hora_fim).apenas_numeros(), -4), '2359'), 'HH24MI');
  begin
    return cruzamento_horas(vhora_ini, vhora_fim, inicio_fim);
  end cruzamento_horas;

  member function truncado return date is
  begin
    return trunc(self.data);
  end truncado;
  
  member function get return date is
  begin
    return self.data;
  end get;

  member function mostra(formato varchar2 default 'DD/MM/RRRR') return varchar2 is
  begin
    return to_char(self.data, formato);
  end mostra;

end;
/
