create or replace type nlist force as object
(
-- Author  : Renan Orati (renanorati@gmail.com)

-- Attributes
  list argsn,

-- Constructor
  constructor function nlist return self as result,
/** [constructor] Construir o objeto inserindo string de valores iniciais:<br>
* Valores devem ser separados por "," ou um intervalo de valores separados por "-".<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('12-16,21,33');
*  console.log(vlista.to_argsn()); -- 12, 13, 14, 15, 16, 21, 33
*end;
*</code>
* %return novo objeto (nlist)
**/
  constructor function nlist(valores varchar2, separador char default ',', intervalo char default '-') return self as result,
/** [constructor] Construir o objeto inserindo string de valores iniciais:<br>
* Valores devem ser separados por "," ou um intervalo de valores separados por "-".<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('12-16,21,33');
*  console.log(vlista.to_argsn()); -- 12, 13, 14, 15, 16, 21, 33
*end;
*</code>
* %return novo objeto (nlist)
**/
  constructor function nlist(valores clob, separador char default ',', intervalo char default '-') return self as result,
/** [constructor] Construir o objeto inserindo unico valor inicial<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist(17);
*  console.log(vlista.to_argsn()); -- 17
*end;
*</code>
* %return novo objeto (nlist)
**/
  constructor function nlist(valor number) return self as result,

-- Member functions and procedures
  member procedure validar(valores clob, separador char default ';', intervalo char default '-'),
/** [function] Retorna nova lista com valor adicionado<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('1,7,9');
*  console.log(vlista.adiciona(4)); -- 1,7,9,4
*  console.log(vlista.adiciona(9)); -- 1,7,9,9
*  console.log(vlista.adiciona(9,dist=>'S')); -- 1,7,9
*end;
*</code>
* %return nova lista (nlist)
**/
  member function adicionar(item number, dist char default 'N') return nlist,
  member procedure adicionar(self in out nocopy nlist, item number, dist char default 'N'),
/** [function] Retorna nova lista com valores adicionados<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('1,7,9');
*  console.log(vlista.adiciona(argsn(3,4))); -- 1,7,9,3,4
*  console.log(vlista.adiciona(argsn(4,9))); -- 1,7,9,4,9
*  console.log(vlista.adiciona(argsn(4,9),dist=>'S')); -- 1,7,9,4
*end;
*</code>
* %return nova lista (nlist)
**/
  member function adicionar(lista argsn, dist char default 'N') return nlist,
  member procedure adicionar(self in out nocopy nlist, lista argsn, dist char default 'N'),
/** [function] Retorna nova lista com valores adicionados<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('1,7,9');
*  console.log(vlista.adiciona(nlist('3,4'))); -- 1,7,9,3,4
*  console.log(vlista.adiciona(nlist('4-9'))); -- 1,7,9,4,5,6,7,8,9
*  console.log(vlista.adiciona(nlist('4,9'),dist=>'S')); -- 1,7,9,4
*end;
*</code>
* %return nova lista (nlist)
**/
  member function adicionar(lista nlist, dist char default 'N') return nlist,
  member procedure adicionar(self in out nocopy nlist, lista nlist, dist char default 'N'),
/** [function] Retorna nova lista sem valor informado<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('1,7,9,9');
*  console.log(vlista.remover(1)); -- 7,9,9
*  console.log(vlista.remover(9)); -- 1,7,9
*  console.log(vlista.remover(9,dist=>'S')); -- 1,7
*end;
*</code>
* %return nova lista (nlist)
**/
  member function remover(item number, dist char default 'N') return nlist,
  member procedure remover(self in out nocopy nlist, item number, dist char default 'N'),
/** [function] Retorna nova lista sem valores informados<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('1,7,9,9');
*  console.log(vlista.remover(argsn(1,2))); -- 7,9,9
*  console.log(vlista.remover(argsn(1,9))); -- 7,9
*  console.log(vlista.remover(argsn(1,9),dist=>'S')); -- 7
*end;
*</code>
* %return nova lista (nlist)
**/
  member function remover(lista argsn, dist char default 'N') return nlist,
  member procedure remover(self in out nocopy nlist, lista argsn, dist char default 'N'),
/** [function] Retorna nova lista sem valores informados<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('1,7,9,9,13');
*  console.log(vlista.remover(nlist('1,2'))); -- 7,9,9,13
*  console.log(vlista.remover(nlist('1-9'))); -- 9,13
*  console.log(vlista.remover(nlist('1,9'),dist=>'S')); -- 7,13
*end;
*</code>
* %return nova lista (nlist)
**/
  member function remover(lista nlist, dist char default 'N') return nlist,
  member procedure remover(self in out nocopy nlist, lista nlist, dist char default 'N'),
/** [function] Retorna nova lista com valores cruzados<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('1,7,9,9,13');
*  console.log(vlista.cruzar(argsn(9,9,9,13,17))); -- 9,9,13
*  console.log(vlista.cruzar(argsn(17))); -- <vazio>
*  console.log(vlista.cruzar(argsn(9,9,13,17,22),dist=>'S')); -- 9
*end;
*</code>
* %return nova lista (nlist)
**/
  member function cruzar(lista argsn, dist char default 'N') return nlist,
  member procedure cruzar(self in out nocopy nlist, lista argsn, dist char default 'N'),
/** [function] Retorna nova lista com valores cruzados<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('1,7,9,9,13');
*  console.log(vlista.cruzar(nlist('9,9,9,13,17'))); -- 9,9,13
*  console.log(vlista.cruzar(nlist('1-12'))); -- 9,13
*  console.log(vlista.cruzar(nlist('1-12'),dist=>'S')); -- 13
*end;
*</code>
* %return nova lista (nlist)
**/
  member function cruzar(lista nlist, dist char default 'N') return nlist,
  member procedure cruzar(self in out nocopy nlist, lista nlist, dist char default 'N'),
/** [function] Retorna lista distinta (sem itens duplicados)<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('1-3,1');
*  console.log(vlista.set()); -- 1, 2, 3
*end;
*</code>
* %return lista (nlist)
**/
  member function dist return nlist,
  member procedure dist(self in out nocopy nlist),
/** [function] Retorna lista ordenada<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('7,1-3,5');
*  console.log(vlista.ordenar()); -- 1, 2, 3, 5, 7
*end;
*</code>
* %param ordem ('A','D')
* %return lista (nlist)
**/
  member function ordenar(ordem char default 'A') return nlist,
  member procedure ordenar(self in out nocopy nlist, ordem char default 'A'),
/** [function] Retorna uma posição na lista<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('1,7,9');
*  console.log(vlista.get()); -- 1
*  console.log(vlista.get(2)); -- 7
*end;
*</code>
* %return item (number)
**/
  member function get(ps number default 1) return number,
/** [function] Retorna uma posição na lista (formato 'enum')<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('85145265895,54815685195,45887698317');
*  console.log(vlista.enum().format_cpf()); -- 851.452.658-95
*  console.log(vlista.enum(3).format_cpf()); -- 458.876.983-17
*end;
*</code>
* %return item (enum)
**/
  member function enum(ps number default 1) return enum,
/** [function] Retorna ultimo item na lista<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('1,7,9');
*  console.log(vlista.ultimo()); -- 9
*end;
*</code>
* %return item (number)
**/
  member function ultimo return number,
/** [function] Retorna primeiro item na lista<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('1,7,9');
*  console.log(vlista.primeiro()); -- 1
*end;
*</code>
* %return item (number)
**/
  member function primeiro return number,
/** [function] Retorna maior número na lista<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('1,7,9,3');
*  console.log(vlista.maior()); -- 9
*end;
*</code>
* %return item (number)
**/
  member function maior return number,
/** [function] Retorna menor número na lista<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('1,7,9,3');
*  console.log(vlista.maior()); -- 1
*end;
*</code>
* %return item (number)
**/
  member function menor return number,
/** [function] Retorna a quantidade de itens na lista<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('12-16,21');
*  console.log(vlista.tamanho()); -- 6
*end;
*</code>
* %return tamanho (number)
**/
  member function tamanho return number,
/** [function] Verifica se possui o item indicado<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist(1,9,7);
*  console.log(vlista.possui(1)); -- S
*  console.log(vlista.possui(3)); -- N
*end;
*</code>
* %return (S/N)
**/
  member function possui(item number) return char,
/** [function] Verifica se possui o item indicado<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist(1,9,7);
*  console.log(vlista.abrange(argsn(1,7))); -- S
*  console.log(vlista.abrange(argsn(1,3))); -- N
*end;
*</code>
* %return (S/N)
**/
  member function abrange(lista argsn) return char,
/** [function] Verifica se possui o item indicado<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist(1,9,7);
*  console.log(vlista.abrange(nlist('1,7'))); -- S
*  console.log(vlista.abrange(nlist('1:7',separador=>':'))); -- N
*end;
*</code>
* %return (S/N)
**/
  member function abrange(lista nlist) return char,
/** [function] Verifica se possui cruzamento entre as listas<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist(1,9,7);
*  console.log(vlista.cruzamento(nlist('1,7'))); -- S
*  console.log(vlista.cruzamento(argsn(2,8))); -- N
*end;
*</code>
* %return (S/N)
**/
  member function cruzamento(lista argsn) return char,
  member function cruzamento(lista nlist) return char,
/** [function] Retorna no formato "args"<br>
*<code>
*  select * from table(nlist('12-16,21').to_args()); -- <<table[varchar2]: 12, 13, 14, 15, 16, 21>>
*</code>
* %return novo objeto (args)
**/
  member function to_args return args,
/** [function] Retorna no formato "argsd"<br>
*<code>
*  select * from table(nlist('20200302,20211125').to_argsd()); -- <<table[date]: 02/03/2020, 25/11/2021>>
*</code>
* %return novo objeto (argsd)
**/
  member function to_argsd(formato varchar2 default 'RRRRMMDDHH24MISS') return argsd,
/** [function] Retorna no formato "argsn"<br>
*<code>
*  select * from table(nlist('12-16,21').to_args()); -- <<table[number]: 12, 13, 14, 15, 16, 21>>
*</code>
* %return novo objeto (argsn)
**/
  member function to_argsn return argsn,
/** [function] Retorna no formato "argsn"<br>
*<code>
*  select * from table(nlist('12-16,21').to_args()); -- <<table[number]: 12, 13, 14, 15, 16, 21>>
*</code>
* %return novo objeto (argsn)
**/
  member function to_table return argsn,
/** [function] Retorna no formato "varchar2"<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('12-16,21');
*  console.log(vlista.to_char()); -- '12,13,14,15,16,21'
*  console.log(vlista.to_char(separador=>' -> ')); -- '12 -> 13 -> 14 -> 15 -> 16 -> 21'
*end;
*</code>
* %return texto (varchar2)
**/
  member function to_char(separador char default ',', pre char default null, pos char default null) return varchar2,
/** [function] Retorna no formato "varchar2"<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('12-16,21');
*  console.log(vlista.to_char(4)); -- '0012,0013,0014,0015,0016,0021'
*  console.log(vlista.to_char(4, separador=>' -> ')); -- '0012 -> 0013 -> 0014 -> 0015 -> 0016 -> 0021'
*end;
*</code>
* %return texto (varchar2)
**/
  member function to_char(lpad_qtd number, lpad_char char default '0', separador char default ',') return varchar2,
/** [function] Retorna no formato "clob"<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('12-16,21');
*  console.log(vlista.to_char()); -- '12,13,14,15,16,21'
*  console.log(vlista.to_char(separador=>' -> ')); -- '12 -> 13 -> 14 -> 15 -> 16 -> 21'
*end;
*</code>
* %return texto (clob)
**/
  member function to_clob(separador char default ',', pre char default null, pos char default null) return clob,
/** [function] Retorna no formato "clob"<br>
*<code>
*declare
*  vlista nlist;
*begin
*  vlista := nlist('12-16,21');
*  console.log(vlista.to_char(4)); -- '0012,0013,0014,0015,0016,0021'
*  console.log(vlista.to_char(4, separador=>' -> ')); -- '0012 -> 0013 -> 0014 -> 0015 -> 0016 -> 0021'
*end;
*</code>
* %return texto (clob)
**/
  member function to_clob(lpad_qtd number, lpad_char char default '0', separador char default ',') return clob
)
/
create or replace type body nlist is

  -- Constructor
  constructor function nlist return self as result is
  begin
    self.list := argsn();
    return;
  end;

  constructor function nlist(valores varchar2, separador char default ',', intervalo char default '-') return self as result is
    vs char := separador;
    vi char := intervalo;
  begin
    self.list := argsn();
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
              self.list(self.list.last) := valor;
            else
              -- é um "range"
              declare
                vini number := regexp_substr(valor, '[^' || vi || ']+', 1, 1);
                vfim number := regexp_substr(valor, '[^' || vi || ']+', 1, 2);
              begin
                if vfim < vini then
                  raise_application_error(-20102,
                                          'O valor "inicial" de um intervalo de valores não deve ser maior do que o valor "final".' || chr(10) ||
                                           'Problema no intervalo: ' || vini || vi || vfim || '.');
                end if;
                -- adiciona range
                for x in vini .. vfim
                loop
                  self.list.extend;
                  self.list(self.list.last) := x;
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
      validar(valores, vs, vi);
  end;

  constructor function nlist(valores clob, separador char default ',', intervalo char default '-') return self as result is
    vs char := separador;
    vi char := intervalo;
  begin
    self.list := argsn();
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
              self.list(self.list.last) := valor;
            else
              -- é um "range"
              declare
                vini number := regexp_substr(valor, '[^' || vi || ']+', 1, 1);
                vfim number := regexp_substr(valor, '[^' || vi || ']+', 1, 2);
              begin
                if vfim < vini then
                  raise_application_error(-20102,
                                          'O valor "inicial" de um intervalo de valores não deve ser maior do que o valor "final".' || chr(10) ||
                                           'Problema no intervalo: ' || vini || vi || vfim || '.');
                end if;
                -- adiciona range
                for x in vini .. vfim
                loop
                  self.list.extend;
                  self.list(self.list.last) := x;
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
      validar(valores, vs, vi);
  end;

  constructor function nlist(valor number) return self as result is
  begin
    self.list := argsn();
    self.list.extend;
    self.list(self.list.last) := valor;
    return;
  end;

  -- Member procedures and functions
  member procedure validar(valores clob, separador char default ';', intervalo char default '-') is
    vs char := separador;
    vi char := intervalo;
  begin
    if regexp_instr(valores, '[^[:digit:]' || vs || vi || ']') <> 0 then
      raise_application_error(-20101,
                              'Apenas é permitido incluir números, "' || vs || '" e "' || vi || '" para instanciar o objeto nlist!' || chr(10) ||
                               'Ex.: "1' || vs || '5' || vs || '10' || vi || '15' || vs || '11".');
    elsif regexp_instr(valores, '\' || vi || '[[:digit:]]+\' || vi) <> 0 then
      raise_application_error(-20102,
                              'O "' || vi || '" para instanciar o objeto nlist deve ser utilizado como indicação de intervalo!' || chr(10) ||
                               'Ex.: "100' || vi || '115".');
    end if;
  end;

  member function adicionar(item number, dist char default 'N') return nlist is
    result nlist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset union distinct argsn(item);
    else
      result.list.extend;
      result.list(result.list.last) := item;
    end if;
    return result;
  end;

  member procedure adicionar(self in out nocopy nlist, item number, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset union distinct argsn(item);
    else
      self.list.extend;
      self.list(self.list.last) := item;
    end if;
  end;

  member function adicionar(lista argsn, dist char default 'N') return nlist is
    result nlist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset union distinct lista;
    else
      result.list := result.list multiset union lista;
    end if;
    return result;
  end;

  member procedure adicionar(self in out nocopy nlist, lista argsn, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset union distinct lista;
    else
      self.list := self.list multiset union lista;
    end if;
  end;

  member function adicionar(lista nlist, dist char default 'N') return nlist is
    result nlist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset union distinct lista.to_argsn;
    else
      result.list := result.list multiset union lista.to_argsn;
    end if;
    return result;
  end;

  member procedure adicionar(self in out nocopy nlist, lista nlist, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset union distinct lista.to_argsn;
    else
      self.list := self.list multiset union lista.to_argsn;
    end if;
  end;

  member function remover(item number, dist char default 'N') return nlist is
    result nlist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset except distinct argsn(item);
    else
      result.list := result.list multiset except argsn(item);
    end if;
    return result;
  end;

  member procedure remover(self in out nocopy nlist, item number, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset except distinct argsn(item);
    else
      self.list := self.list multiset except argsn(item);
    end if;
  end;

  member function remover(lista argsn, dist char default 'N') return nlist is
    result nlist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset except distinct lista;
    else
      result.list := result.list multiset except lista;
    end if;
    return result;
  end;

  member procedure remover(self in out nocopy nlist, lista argsn, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset except distinct lista;
    else
      self.list := self.list multiset except lista;
    end if;
  end;

  member function remover(lista nlist, dist char default 'N') return nlist is
    result nlist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset except distinct lista.to_argsn;
    else
      result.list := result.list multiset except lista.to_argsn;
    end if;
    return result;
  end;

  member procedure remover(self in out nocopy nlist, lista nlist, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset except distinct lista.to_argsn;
    else
      self.list := self.list multiset except lista.to_argsn;
    end if;
  end;

  member function cruzar(lista argsn, dist char default 'N') return nlist is
    result nlist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset intersect distinct lista;
    else
      result.list := result.list multiset intersect lista;
    end if;
    return result;
  end;

  member procedure cruzar(self in out nocopy nlist, lista argsn, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset intersect distinct lista;
    else
      self.list := self.list multiset intersect lista;
    end if;
  end;

  member function cruzar(lista nlist, dist char default 'N') return nlist is
    result nlist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset intersect distinct lista.to_argsn;
    else
      result.list := result.list multiset intersect lista.to_argsn;
    end if;
    return result;
  end;

  member procedure cruzar(self in out nocopy nlist, lista nlist, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset intersect distinct lista.to_argsn;
    else
      self.list := self.list multiset intersect lista.to_argsn;
    end if;
  end;

  member function dist return nlist is
  begin
    return nlist(set(self.list));
  end;

  member procedure dist(self in out nocopy nlist) is
  begin
    self.list := set(self.list);
  end;

  member function ordenar(ordem char default 'A') return nlist is
    result argsn;
  begin
    if ordenar.ordem = 'A' then
      select x.column_value bulk collect into result from table(self.list) x order by 1;
    elsif ordenar.ordem = 'D' then
      select x.column_value bulk collect into result from table(self.list) x order by 1 desc;
    end if;
    return nlist(result);
  end;

  member procedure ordenar(self in out nocopy nlist, ordem char default 'A') is
    vtab argsn := self.list;
  begin
    if ordenar.ordem = 'A' then
      select x.column_value bulk collect into self.list from table(vtab) x order by 1;
    elsif ordenar.ordem = 'D' then
      select x.column_value bulk collect into self.list from table(vtab) x order by 1 desc;
    end if;
  end;

  member function get(ps number default 1) return number is
  begin
    if self.list is not null and
       self.list.count > 0 and
       self.list.exists(ps) then
      return self.list(ps);
    else
      return null;
    end if;
  end;

  member function enum(ps number default 1) return enum is
  begin
    if self.list is not null and
       self.list.count > 0 and
       self.list.exists(ps) then
      return enum(self.list(ps));
    else
      return null;
    end if;
  end;

  member function ultimo return number is
  begin
    if self.list is not null and
       self.list.count > 0 then
      return self.list(self.list.last);
    else
      return null;
    end if;
  end;

  member function primeiro return number is
  begin
    if self.list is not null and
       self.list.count > 0 then
      return self.list(self.list.first);
    else
      return null;
    end if;
  end;

  member function maior return number is
    result number;
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

  member function menor return number is
    result number;
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

  member function possui(item number) return char is
  begin
    if item member of self.list then
      return 'S';
    else
      return 'N';
    end if;
  end;

  member function abrange(lista argsn) return char is
  begin
    if lista submultiset of self.list then
      return 'S';
    else
      return 'N';
    end if;
  end;

  member function abrange(lista nlist) return char is
  begin
    if lista.to_argsn submultiset of self.list then
      return 'S';
    else
      return 'N';
    end if;
  end;

  member function cruzamento(lista argsn) return char is
    vaux argsn := argsn();
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

  member function cruzamento(lista nlist) return char is
    vaux argsn := argsn();
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

  member function to_args return args is
    result args := args();
    vaux   number;
  begin
    vaux := self.list.first;
    while vaux is not null
    loop
      result.extend;
      result(result.last) := self.list(vaux);
      -- next
      vaux := self.list.next(vaux);
    end loop;
    return result;
  end;

  member function to_argsd(formato varchar2 default 'RRRRMMDDHH24MISS') return argsd is
    result argsd := argsd();
    vaux   number;
  begin
    vaux := self.list.first;
    while vaux is not null
    loop
      result.extend;
      result(result.last) := standard.to_date(self.list(vaux), formato);
      -- next
      vaux := self.list.next(vaux);
    end loop;
    return result;
  end;

  member function to_argsn return argsn is
  begin
    return self.list;
  end;

  member function to_table return argsn is
  begin
    return self.list;
  end;

  member function to_char(separador char default ',', pre char default null, pos char default null) return varchar2 is
    result varchar2(32767);
    vaux   number;
  begin
    vaux := self.list.first;
    while vaux is not null
    loop
      result := result || pre || self.list(vaux) || pos || separador;
      -- next
      vaux := self.list.next(vaux);
    end loop;
    -- remove ultimo
    result := rtrim(result, separador);
    -- --
    return result;
  end;

  member function to_char(lpad_qtd number, lpad_char char default '0', separador char default ',') return varchar2 is
    result varchar2(32767);
    vaux   number;
  begin
    vaux := self.list.first;
    while vaux is not null
    loop
      result := result || lpad(self.list(vaux), lpad_qtd, lpad_char) || separador;
      -- next
      vaux := self.list.next(vaux);
    end loop;
    -- remove ultimo
    result := rtrim(result, separador);
    -- --
    return result;
  end;

  member function to_clob(separador char default ',', pre char default null, pos char default null) return clob is
    result clob;
    vaux   number;
  begin
    vaux := self.list.first;
    while vaux is not null
    loop
      result := result || pre || self.list(vaux) || pos || separador;
      -- next
      vaux := self.list.next(vaux);
    end loop;
    -- remove ultimo
    result := rtrim(result, separador);
    -- --
    return result;
  end;

  member function to_clob(lpad_qtd number, lpad_char char default '0', separador char default ',') return clob is
    result clob;
    vaux   number;
  begin
    vaux := self.list.first;
    while vaux is not null
    loop
      result := result || lpad(self.list(vaux), lpad_qtd, lpad_char) || separador;
      -- next
      vaux := self.list.next(vaux);
    end loop;
    -- remove ultimo
    result := rtrim(result, separador);
    -- --
    return result;
  end;

end;
/
