create or replace type dlist force as object
(
-- Attributes
  list argsd,

-- Constructor
  constructor function dlist return self as result,
/** [constructor] Construir o objeto inserindo string de datas iniciais:<br>
* Datas devem ser separadas por ";" ou um intervalo de datas separados por "-".<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist('12/01/2020-16/01/2020,21/01/2020,30/01/2020');
*  console.log(vlista.to_argsd()); -- 12/01/2020, 13/01/2020, 14/01/2020, 15/01/2020, 16/01/2020, 21/01/2020, 30/01/2020
*end;
*</code>
* %return novo objeto (dlist)
**/
  constructor function dlist(valores   varchar2
                            ,separador char default ';'
                            ,intervalo char default '-'
                            ,formato   varchar2 default 'DD/MM/RRRR HH24:MI:SS') return self as result,
/** [constructor] Construir o objeto inserindo string de datas iniciais:<br>
* Datas devem ser separadas por ";" ou um intervalo de datas separados por "-".<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist('12/01/2020-16/01/2020;21/01/2020;30/01/2020');
*  console.log(vlista.to_argsd()); -- 12/01/2020, 13/01/2020, 14/01/2020, 15/01/2020, 16/01/2020, 21/01/2020, 30/01/2020
*end;
*</code>
* %return novo objeto (dlist)
**/
  constructor function dlist(valores clob, separador char default ';', intervalo char default '-', formato varchar2 default 'DD/MM/RRRR HH24:MI:SS')
    return self as result,
/** [constructor] Construir o objeto inserindo unica data inicial<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist(17/01/2020);
*  console.log(vlista.to_argsd()); -- 17/01/2020
*end;
*</code>
* %return novo objeto (dlist)
**/
  constructor function dlist(valor date, formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') return self as result,

-- Member functions and procedures
  member procedure validar(valores clob, separador char default ';', intervalo char default '-', formato varchar2 default 'DD/MM/RRRR HH24:MI:SS'),
/** [function] Retorna nova lista com valor adicionado<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist('01/01/2020,07/01/2020,09/01/2020');
*  console.log(vlista.adiciona('04/01/2020')); -- 01/01/2020,07/01/2020,09/01/2020,04/01/2020
*  console.log(vlista.adiciona('09/01/2020')); -- 01/01/2020,07/01/2020,09/01/2020,09/01/2020
*  console.log(vlista.adiciona('09/01/2020',dist=>'S')); -- 01/01/2020,07/01/2020,09/01/2020
*end;
*</code>
* %return nova lista (dlist)
**/
  member function adicionar(item date, dist char default 'N') return dlist,
  member procedure adicionar(self in out nocopy dlist, item date, dist char default 'N'),
/** [function] Retorna nova lista com valores adicionados<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist('01/01/2020,07/01/2020,09/01/2020');
*  console.log(vlista.adiciona(argsd('03/01/2020','04/01/2020'))); -- 01/01/2020,07/01/2020,09/01/2020,03/01/2020,04/01/2020
*  console.log(vlista.adiciona(argsd('04/01/2020','09/01/2020'))); -- 01/01/2020,07/01/2020,09/01/2020,04/01/2020,09/01/2020
*  console.log(vlista.adiciona(argsd('04/01/2020','09/01/2020'),dist=>'S')); -- 01/01/2020,07/01/2020,09/01/2020,04/01/2020
*end;
*</code>
* %return nova lista (dlist)
**/
  member function adicionar(lista argsd, dist char default 'N') return dlist,
  member procedure adicionar(self in out nocopy dlist, lista argsd, dist char default 'N'),
/** [function] Retorna nova lista com valores adicionados<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist('01/01/2020,07/01/2020,09/01/2020');
*  console.log(vlista.adiciona(dlist('03/01/2020,04/01/2020'))); -- 01/01/2020,07/01/2020,09/01/2020,03/01/2020,04/01/2020
*  console.log(vlista.adiciona(dlist('04/01/2020-09/01/2020'))); -- 01/01/2020,07/01/2020,09/01/2020,04/01/2020,05/01/2020,06/01/2020,07/01/2020,08/01/2020,09/01/2020
*  console.log(vlista.adiciona(dlist('04/01/2020,09/01/2020'),dist=>'S')); -- 01/01/2020,07/01/2020,09/01/2020,04/01/2020
*end;
*</code>
* %return nova lista (dlist)
**/
  member function adicionar(lista dlist, dist char default 'N') return dlist,
  member procedure adicionar(self in out nocopy dlist, lista dlist, dist char default 'N'),
/** [function] Retorna nova lista sem valor informado<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist('01/01/2020,07/01/2020,09/01/2020,09/01/2020');
*  console.log(vlista.remover('01/01/2020')); -- 07/01/2020,09/01/2020,09/01/2020
*  console.log(vlista.remover('09/01/2020')); -- 01/01/2020,07/01/2020,09/01/2020
*  console.log(vlista.remover('09/01/2020',dist=>'S')); -- 01/01/2020,07/01/2020
*end;
*</code>
* %return nova lista (dlist)
**/
  member function remover(item date, dist char default 'N') return dlist,
  member procedure remover(self in out nocopy dlist, item date, dist char default 'N'),
/** [function] Retorna nova lista sem valores informados<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist('1,7,9,9');
*  console.log(vlista.remover(argsd(1,2))); -- 7,9,9
*  console.log(vlista.remover(argsd(1,9))); -- 7,9
*  console.log(vlista.remover(argsd(1,9),dist=>'S')); -- 7
*end;
*</code>
* %return nova lista (dlist)
**/
  member function remover(lista argsd, dist char default 'N') return dlist,
  member procedure remover(self in out nocopy dlist, lista argsd, dist char default 'N'),
/** [function] Retorna nova lista sem valores informados<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist('1,7,9,9,13');
*  console.log(vlista.remover(dlist('1,2'))); -- 7,9,9,13
*  console.log(vlista.remover(dlist('1-9'))); -- 9,13
*  console.log(vlista.remover(dlist('1,9'),dist=>'S')); -- 7,13
*end;
*</code>
* %return nova lista (dlist)
**/
  member function remover(lista dlist, dist char default 'N') return dlist,
  member procedure remover(self in out nocopy dlist, lista dlist, dist char default 'N'),
/** [function] Retorna nova lista com datas cruzados<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('01/01/2018,07/01/2018,09/01/2018,09/01/2018,13/01/2018');
*  console.log(vlista.cruzar(argsn(09/01/2018,09/01/2018,09/01/2018,13/01/2018,17/01/2018))); -- 09/01/2018,09/01/2018,13/01/2018
*  console.log(vlista.cruzar(argsn(17/01/2018))); -- <vazio>
*  console.log(vlista.cruzar(argsn(09/01/2018,09/01/2018,13/01/2018,17/01/2018,22/01/2018),dist=>'S')); -- 09/01/2018
*end;
*</code>
* %return nova lista (dlist)
**/
  member function cruzar(lista argsd, dist char default 'N') return dlist,
  member procedure cruzar(self in out nocopy dlist, lista argsd, dist char default 'N'),
/** [function] Retorna nova lista com datas cruzados<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('01/01/2018,07/01/2018,09/01/2018,09/01/2018,13/01/2018');
*  console.log(vlista.cruzar(nlist('09/01/2018,09/01/2018,09/01/2018,13/01/2018,17/01/2018'))); -- 09/01/2018,09/01/2018,13/01/2018
*  console.log(vlista.cruzar(nlist('01/01/2018-12/01/2018'))); -- 09/01/2018,13/01/2018
*  console.log(vlista.cruzar(nlist('01/01/2018-12/01/2018'),dist=>'S')); -- 13/01/2018
*end;
*</code>
* %return nova lista (dlist)
**/
  member function cruzar(lista dlist, dist char default 'N') return dlist,
  member procedure cruzar(self in out nocopy dlist, lista dlist, dist char default 'N'),
/** [function] Retorna lista distinta (sem itens duplicados)<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist('01/03/2019-03/03/2019,01/03/2019');
*  console.log(vlista.dist()); -- 01/03/2019, 02/03/2019, 03/03/2019
*end;
*</code>
* %return lista (dlist)
**/
  member function dist return dlist,
  member procedure dist(self in out nocopy dlist),
/** [function] Retorna lista ordenada<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist('07/02/2020,01/02/2020-03/02/2020,05/02/2020');
*  console.log(vlista.ordenar()); -- 01/02/2020, 02/02/2020, 03/02/2020, 05/02/2020, 07/02/2020
*end;
*</code>
* %param ordem ('A','D')
* %return lista (dlist)
**/
  member function ordenar(ordem char default 'A') return dlist,
  member procedure ordenar(self in out nocopy dlist, ordem char default 'A'),
/** [function] Retorna uma posição na lista<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist('01/09/2007,07/09/2007,09/09/2007');
*  console.log(vlista.get()); -- 01/09/2007
*  console.log(vlista.get(2)); -- 07/09/2007
*end;
*</code>
* %return item (date)
**/
  member function get(ps number default 1) return date,
/** [function] Retorna ultimo item na lista<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist('11/03/2023,17/03/2023,23/03/2023,19/03/2023');
*  console.log(vlista.ultimo()); -- 19/03/2023
*end;
*</code>
* %return item (date)
**/
  member function ultimo return date,
/** [function] Retorna primeiro item na lista<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist('03/03/2023,01/03/2023,07/03/2023,09/03/2023');
*  console.log(vlista.primeiro()); -- 03/03/2023
*end;
*</code>
* %return item (date)
**/
  member function primeiro return date,
/** [function] Retorna maior número na lista<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist('01/03/2023,07/03/2023,09/03/2023,03/03/2023');
*  console.log(vlista.maior()); -- 09/03/2023
*end;
*</code>
* %return item (date)
**/
  member function maior return date,
/** [function] Retorna menor número na lista<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist('02/03/2023,01/03/2023,07/03/2023,09/03/2023,03/03/2023');
*  console.log(vlista.menor()); -- 01/03/2023
*end;
*</code>
* %return item (date)
**/
  member function menor return date,
/** [function] Retorna a quantidade de itens na lista<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist('12/01/2020-16/01/2020;21/01/2020');
*  console.log(vlista.tamanho()); -- 6
*end;
*</code>
* %return tamanho (number)
**/
  member function tamanho return number,
/** [function] Verifica se possui o item indicado<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist(01/04/2027,09/04/2027,07/04/2027);
*  console.log(vlista.possui(01/04/2027)); -- S
*  console.log(vlista.possui(03/04/2027)); -- N
*end;
*</code>
* %return (S/N)
**/
  member function possui(item date) return char,
/** [function] Verifica se possui o item indicado<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist(01/04/2027,09/04/2027,07/04/2027);
*  console.log(vlista.abrange(argsn(01/04/2027,07/04/2027))); -- S
*  console.log(vlista.abrange(argsn(01/04/2027,03/04/2027))); -- N
*end;
*</code>
* %return (S/N)
**/
  member function abrange(lista argsd) return char,
/** [function] Verifica se possui o item indicado<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist(01/04/2027,09/04/2027,07/04/2027);
*  console.log(vlista.abrange(dlist('01/04/2027,07/04/2027'))); -- S
*  console.log(vlista.abrange(dlist('01/04/2027:07/04/2027',separador=>':'))); -- N
*end;
*</code>
* %return (S/N)
**/
  member function abrange(lista dlist) return char,
/** [function] Verifica se possui cruzamento entre as listas<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist('01/08/2018,09/08/2018,07/08/2018');
*  console.log(vlista.cruzamento(dlist('01/08/2018,07/08/2018'))); -- S
*  console.log(vlista.cruzamento(argsd('02/08/2018','08/08/2018'))); -- N
*end;
*</code>
* %return (S/N)
**/
  member function cruzamento(lista argsd) return char,
  member function cruzamento(lista dlist) return char,
/** [function] Retorna no formato "args"<br>
*<code>
*  select * from table(dlist('12/01/2020-16/01/2020;21/01/2020').to_args()); -- <<table[varchar2]: 12/01/2020, 13/01/2020, 14/01/2020, 15/01/2020, 16/01/2020, 21/01/2020>>
*</code>
* %return novo objeto (args)
**/
  member function to_args(formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') return args,
/** [function] Retorna no formato "argsn"<br>
*<code>
*  select * from table(dlist('12/01/2020-16/01/2020;21/01/2020').to_argsn()); -- <<table[varchar2]: 20200112000000, 20200113000000, 20200114000000, 20200115000000, 20200116000000, 20200121000000>>
*</code>
* %return novo objeto (argsn)
**/
  member function to_argsn(formato varchar2 default 'RRRRMMDDHH24MISS') return argsn,
/** [function] Retorna no formato "argsd"<br>
*<code>
*  select * from table(dlist('12/01/2020-16/01/2020;21/01/2020').to_args()); -- <<table[date]: 12/01/2020, 13/01/2020, 14/01/2020, 15/01/2020, 16/01/2020, 21/01/2020>>
*</code>
* %return novo objeto (argsd)
**/
  member function to_argsd return argsd,
/** [function] Retorna no formato "argsdt"<br>
*<code>
*  select * from table(dlist('12/01/2020-16/01/2020;21/01/2020').to_argst()); -- <<table[datetime]: 12/01/2020, 13/01/2020, 14/01/2020, 15/01/2020, 16/01/2020, 21/01/2020>>
*</code>
* %return novo objeto (argsdt)
**/
  member function to_table return argsd,
/** [function] Retorna no formato "varchar2"<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist('12/01/2020-16/01/2020;21/01/2020');
*  console.log(vlista.to_char()); -- '12/01/2020;13/01/2020;14/01/2020;15/01/2020;16/01/2020;21/01/2020'
*  console.log(vlista.to_char(separador=>' -> ')); -- '12/01/2020 -> 13/01/2020 -> 14/01/2020 -> 15/01/2020 -> 16/01/2020 -> 21/01/2020'
*  console.log(vlista.to_char(separador=>' -> ',formato=>'DD/MM')); -- '12/01 -> 13/01 -> 14/01 -> 15/01 -> 16/01 -> 21/01'
*end;
*</code>
* %return texto (varchar2)
**/
  member function to_char(separador char default ';', formato varchar2 default 'DD/MM/RRRR', pre char default null, pos char default null)
    return varchar2,
/** [function] Retorna no formato "clob"<br>
*<code>
*declare
*  vlista dlist;
*begin
*  vlista := dlist('12/01/2020-16/01/2020;21/01/2020');
*  console.log(vlista.to_char()); -- '12/01/2020;13/01/2020;14/01/2020;15/01/2020;16/01/2020;21/01/2020'
*  console.log(vlista.to_char(separador=>' -> ')); -- '12/01/2020 -> 13/01/2020 -> 14/01/2020 -> 15/01/2020 -> 16/01/2020 -> 21/01/2020'
*  console.log(vlista.to_char(separador=>' -> ',formato=>'DD/MM')); -- '12/01 -> 13/01 -> 14/01 -> 15/01 -> 16/01 -> 21/01'
*end;
*</code>
* %return texto (clob)
**/
  member function to_clob(separador char default ';', formato varchar2 default 'DD/MM/RRRR', pre char default null, pos char default null)
    return clob
)
/
create or replace type body dlist is

  -- Constructor
  constructor function dlist return self as result is
  begin
    self.list := argsd();
    return;
  end;

  constructor function dlist(valores   varchar2
                            ,separador char default ';'
                            ,intervalo char default '-'
                            ,formato   varchar2 default 'DD/MM/RRRR HH24:MI:SS') return self as result is
    vs char := separador;
    vi char := intervalo;
  begin
    self.list := argsd();
    -- criação do objeto
    declare
      vpos number := 1;
      vsub number;
      vlen constant number := length(valores);
      vsep constant number := length(vs);
      valor varchar2(32767);
    begin
      if vlen > 0 then
        loop
          vsub := instr(valores, vs, vpos);
          if vsub = 0 then
            valor := substr(valores, vpos);
          else
            valor := substr(valores, vpos, vsub - vpos);
          end if;
          -- >> atrib
          if valor is not null then
            -- verifica se é um "valor" ou um "range"
            if instr(valor, vi) = 0 then
              -- é um "valor"
              self.list.extend;
              self.list(self.list.last) := standard.to_date(valor, formato);
            else
              -- é um "range"
              declare
                vini date := standard.to_date(regexp_substr(valor, '[^' || vi || ']+', 1, 1), formato);
                vfim date := standard.to_date(regexp_substr(valor, '[^' || vi || ']+', 1, 2), formato);
              begin
                if vfim < vini then
                  raise_application_error(-20102,
                                          'O valor "inicial" de um intervalo de datas não deve ser maior do que o valor "final".' || chr(10) ||
                                           'Problema no intervalo: ' || valor || '.');
                end if;
                -- adiciona range
                for x in 0 .. vfim - vini
                loop
                  self.list.extend;
                  self.list(self.list.last) := vini + x;
                end loop;
              end;
            end if;
          end if;
          -- >> --
          exit when vsub = 0;
          vpos := vsub + vsep;
        end loop;
      end if;
    end;
    -- --
    return;
  exception
    when others then
      -- validações
      validar(valores, vs, vi, formato);
  end;

  constructor function dlist(valores clob, separador char default ';', intervalo char default '-', formato varchar2 default 'DD/MM/RRRR HH24:MI:SS')
    return self as result is
    vs char := separador;
    vi char := intervalo;
  begin
    self.list := argsd();
    -- criação do objeto
    declare
      vpos number := 1;
      vsub number;
      vlen constant number := length(valores);
      vsep constant number := length(vs);
      valor varchar2(32767);
    begin
      if vlen > 0 then
        loop
          vsub := instr(valores, vs, vpos);
          if vsub = 0 then
            valor := substr(valores, vpos);
          else
            valor := substr(valores, vpos, vsub - vpos);
          end if;
          -- >> atrib
          if valor is not null then
            -- verifica se é um "valor" ou um "range"
            if instr(valor, vi) = 0 then
              -- é um "valor"
              self.list.extend;
              self.list(self.list.last) := standard.to_date(valor, formato);
            else
              -- é um "range"
              declare
                vini date := standard.to_date(regexp_substr(valor, '[^' || vi || ']+', 1, 1), formato);
                vfim date := standard.to_date(regexp_substr(valor, '[^' || vi || ']+', 1, 2), formato);
              begin
                if vfim < vini then
                  raise_application_error(-20102,
                                          'O valor "inicial" de um intervalo de datas não deve ser maior do que o valor "final".' || chr(10) ||
                                           'Problema no intervalo: ' || valor || '.');
                end if;
                -- adiciona range
                for x in 0 .. vfim - vini
                loop
                  self.list.extend;
                  self.list(self.list.last) := vini + x;
                end loop;
              end;
            end if;
          end if;
          -- >> --
          exit when vsub = 0;
          vpos := vsub + vsep;
        end loop;
      end if;
    end;
    -- --
    return;
  exception
    when others then
      -- validações
      validar(valores, vs, vi, formato);
  end;

  constructor function dlist(valor date, formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') return self as result is
  begin
    self.list := argsd();
    self.list.extend;
    self.list(self.list.last) := standard.to_date(valor, formato);
    return;
  end;

  -- Member procedures and functions
  member procedure validar(valores clob, separador char default ';', intervalo char default '-', formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') is
    vs char := separador;
    vi char := intervalo;
    vd char(2) := '/:';
  begin
    if regexp_instr(valores, '[^' || vd || '[:digit:]' || vs || vi || ']') <> 0 then
      raise_application_error(-20101,
                              'Apenas é permitido incluir números, "' || vs || '", "' || vi || '" e caracteres para identificação de data ("' || vd ||
                               '") para instanciar o objeto dlist!' || chr(10) || 'Ex.: "22/05/2019' || vi || '26/05/2019' || vs || '29/12/2020' || vs ||
                               '01/05/2020' || vi || '05/05/2020' || vs || '15/05/2020".');
    elsif regexp_instr(valores, '\' || vi || '[' || vd || '[:digit:]]+\' || vi) <> 0 then
      raise_application_error(-20102,
                              'O "' || vi || '" para instanciar o objeto dlist deve ser utilizado como indicação de intervalo!' || chr(10) ||
                               'Ex.: "01/08/2020' || vi || '11/08/2020".');
    elsif regexp_instr(formato, '[^' || vd || '[:digit:]' || vs || vi || ']') <> 0 then
      raise_application_error(-20103,
                              'Para o "formato", apenas é permitido incluir números e caracteres para identificação de data ("' || vd || '").');
    end if;
  end;

  member function adicionar(item date, dist char default 'N') return dlist is
    result dlist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset union distinct argsd(item);
    else
      result.list.extend;
      result.list(result.list.last) := item;
    end if;
    return result;
  end;

  member procedure adicionar(self in out nocopy dlist, item date, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset union distinct argsd(item);
    else
      self.list.extend;
      self.list(self.list.last) := item;
    end if;
  end;

  member function adicionar(lista argsd, dist char default 'N') return dlist is
    result dlist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset union distinct lista;
    else
      result.list := result.list multiset union lista;
    end if;
    return result;
  end;

  member procedure adicionar(self in out nocopy dlist, lista argsd, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset union distinct lista;
    else
      self.list := self.list multiset union lista;
    end if;
  end;

  member function adicionar(lista dlist, dist char default 'N') return dlist is
    result dlist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset union distinct lista.to_argsd;
    else
      result.list := result.list multiset union lista.to_argsd;
    end if;
    return result;
  end;

  member procedure adicionar(self in out nocopy dlist, lista dlist, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset union distinct lista.to_argsd;
    else
      self.list := self.list multiset union lista.to_argsd;
    end if;
  end;

  member function remover(item date, dist char default 'N') return dlist is
    result dlist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset except distinct argsd(item);
    else
      result.list := result.list multiset except argsd(item);
    end if;
    return result;
  end;

  member procedure remover(self in out nocopy dlist, item date, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset except distinct argsd(item);
    else
      self.list := self.list multiset except argsd(item);
    end if;
  end;

  member function remover(lista argsd, dist char default 'N') return dlist is
    result dlist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset except distinct lista;
    else
      result.list := result.list multiset except lista;
    end if;
    return result;
  end;

  member procedure remover(self in out nocopy dlist, lista argsd, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset except distinct lista;
    else
      self.list := self.list multiset except lista;
    end if;
  end;

  member function remover(lista dlist, dist char default 'N') return dlist is
    result dlist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset except distinct lista.to_argsd;
    else
      result.list := result.list multiset except lista.to_argsd;
    end if;
    return result;
  end;

  member procedure remover(self in out nocopy dlist, lista dlist, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset except distinct lista.to_argsd;
    else
      self.list := self.list multiset except lista.to_argsd;
    end if;
  end;

  member function cruzar(lista argsd, dist char default 'N') return dlist is
    result dlist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset intersect distinct lista;
    else
      result.list := result.list multiset intersect lista;
    end if;
    return result;
  end;

  member procedure cruzar(self in out nocopy dlist, lista argsd, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset intersect distinct lista;
    else
      self.list := self.list multiset intersect lista;
    end if;
  end;

  member function cruzar(lista dlist, dist char default 'N') return dlist is
    result dlist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset intersect distinct lista.to_argsd;
    else
      result.list := result.list multiset intersect lista.to_argsd;
    end if;
    return result;
  end;

  member procedure cruzar(self in out nocopy dlist, lista dlist, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset intersect distinct lista.to_argsd;
    else
      self.list := self.list multiset intersect lista.to_argsd;
    end if;
  end;

  member function dist return dlist is
  begin
    return dlist(set(self.list));
  end;

  member procedure dist(self in out nocopy dlist) is
  begin
    self.list := set(self.list);
  end;

  member function ordenar(ordem char default 'A') return dlist is
    result argsd;
  begin
    if ordenar.ordem = 'A' then
      select x.column_value bulk collect into result from table(self.list) x order by 1;
    elsif ordenar.ordem = 'D' then
      select x.column_value bulk collect into result from table(self.list) x order by 1 desc;
    end if;
    return dlist(result);
  end;

  member procedure ordenar(self in out nocopy dlist, ordem char default 'A') is
    vtab argsd := self.list;
  begin
    if ordenar.ordem = 'A' then
      select x.column_value bulk collect into self.list from table(vtab) x order by 1;
    elsif ordenar.ordem = 'D' then
      select x.column_value bulk collect into self.list from table(vtab) x order by 1 desc;
    end if;
  end;

  member function get(ps number default 1) return date is
  begin
    if self.list is not null and
       self.list.count > 0 and
       self.list.exists(ps) then
      return self.list(ps);
    else
      return null;
    end if;
  end;

  member function ultimo return date is
  begin
    if self.list is not null and
       self.list.count > 0 then
      return self.list(self.list.last);
    else
      return null;
    end if;
  end;

  member function primeiro return date is
  begin
    if self.list is not null and
       self.list.count > 0 then
      return self.list(self.list.first);
    else
      return null;
    end if;
  end;

  member function maior return date is
    result date;
  begin
    if self.list is not null and
       self.list.count > 0 then
      result := self.list(self.list.first);
      for i in self.list.first + 1 .. self.list.last
      loop
        if self.list(i) > result then
          result := self.list(i);
        end if;
      end loop;
      return result;
    else
      return null;
    end if;
  end;

  member function menor return date is
    result date;
  begin
    if self.list is not null and
       self.list.count > 0 then
      result := self.list(self.list.first);
      for i in self.list.first .. self.list.last
      loop
        if self.list(i) < result then
          result := self.list(i);
        end if;
      end loop;
      return result;
    else
      return null;
    end if;
  end;

  member function tamanho return number is
  begin
    return self.list.count;
  end;

  member function possui(item date) return char is
  begin
    if item member of self.list then
      return 'S';
    else
      return 'N';
    end if;
  end;

  member function abrange(lista argsd) return char is
  begin
    if lista submultiset of self.list then
      return 'S';
    else
      return 'N';
    end if;
  end;

  member function abrange(lista dlist) return char is
  begin
    if lista.to_argsd submultiset of self.list then
      return 'S';
    else
      return 'N';
    end if;
  end;

  member function cruzamento(lista argsd) return char is
    vaux argsd := argsd();
    vqtd number;
  begin
    if lista is not null then
      if self.list.count < 10 then
        vaux := self.list multiset intersect lista;
        vqtd := vaux.count;
      elsif lista.count < 10 then
        vaux := lista multiset intersect self.list;
        vqtd := vaux.count;
      elsif self.list.count * lista.count > 10000 then
        select count(1) into vqtd from table(self.list) s join table(lista) l on s.column_value = l.column_value;
      else
        vaux := self.list multiset intersect lista;
        vqtd := vaux.count;
      end if;
    end if;
    if vqtd = 0 then
      return 'N';
    else
      return 'S';
    end if;
  end;

  member function cruzamento(lista dlist) return char is
    vaux argsd := argsd();
    vqtd number;
  begin
    if lista.list is not null then
      if self.list.count < 10 then
        vaux := self.list multiset intersect lista.list;
        vqtd := vaux.count;
      elsif lista.list.count < 10 then
        vaux := lista.list multiset intersect self.list;
        vqtd := vaux.count;
      elsif self.list.count * lista.list.count > 10000 then
        select count(1) into vqtd from table(self.list) s join table(lista.list) l on s.column_value = l.column_value;
      else
        vaux := self.list multiset intersect lista.list;
        vqtd := vaux.count;
      end if;
    end if;
    if vqtd = 0 then
      return 'N';
    else
      return 'S';
    end if;
  end;

  member function to_args(formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') return args is
    result args := args();
  begin
    if self.list is not null and
       self.list is not empty then
      for i in self.list.first .. self.list.last
      loop
        result.extend;
        result(result.last) := standard.to_char(self.list(i), formato);
      end loop;
    end if;
    return result;
  end;

  member function to_argsn(formato varchar2 default 'RRRRMMDDHH24MISS') return argsn is
    result argsn := argsn();
  begin
    if self.list is not null and
       self.list is not empty then
      for i in self.list.first .. self.list.last
      loop
        result.extend;
        result(result.last) := standard.to_char(self.list(i), formato);
      end loop;
    end if;
    return result;
  end;

  member function to_argsd return argsd is
  begin
    return self.list;
  end;

  member function to_table return argsd is
  begin
    return self.list;
  end;

  member function to_char(separador char default ';', formato varchar2 default 'DD/MM/RRRR', pre char default null, pos char default null)
    return varchar2 is
    result varchar2(32767);
  begin
    if self.list is not null and
       self.list is not empty then
      for i in self.list.first .. self.list.last
      loop
        result := result || pre || standard.to_char(self.list(i), formato) || pos || separador;
      end loop;
      -- remove ultimo
      result := rtrim(result, separador);
    end if;
    return result;
  end;

  member function to_clob(separador char default ';', formato varchar2 default 'DD/MM/RRRR', pre char default null, pos char default null) return clob is
    result clob;
  begin
    if self.list is not null and
       self.list is not empty then
      for i in self.list.first .. self.list.last
      loop
        result := result || pre || standard.to_char(self.list(i), formato) || pos || separador;
      end loop;
      -- remove ultimo
      result := rtrim(result, separador);
    end if;
    return result;
  end;

end;
/
