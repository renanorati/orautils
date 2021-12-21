create or replace type alist force as object
(
-- Author  : Renan Orati (renanorati@gmail.com)

-- Attributes
  list args,

-- Constructor
  constructor function alist return self as result,
/** [constructor] Construir o objeto inserindo string de valores iniciais:<br>
* Valores devem ser separados por "," ou pelo "separador" informado por parâmetro.<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3');
*  console.log(vlista.to_args()); -- TESTE1, TESTE2, TESTE3
*end;
*</code>
* %return novo objeto (alist)
**/
  constructor function alist(valores varchar2, separador char default ',') return self as result,
/** [constructor] Construir o objeto inserindo string de valores iniciais:<br>
* Valores devem ser separados por "," ou pelo "separador" informado por parâmetro.<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3');
*  console.log(vlista.to_args()); -- TESTE1, TESTE2, TESTE3
*end;
*</code>
* %return novo objeto (alist)
**/
  constructor function alist(valores clob, separador char default ',') return self as result,

-- Member functions and procedures
/** [function] Retorna nova lista com valor adicionado<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3');
*  console.log(vlista.adiciona('TESTE4')); -- TESTE1,TESTE2,TESTE3,TESTE4
*  console.log(vlista.adiciona('TESTE4')); -- TESTE1,TESTE2,TESTE3,TESTE4,TESTE4
*  console.log(vlista.adiciona('TESTE4',dist=>'S')); -- TESTE1,TESTE2,TESTE3,TESTE4,TESTE5
*end;
*</code>
* %return nova lista (alist)
**/
  member function adicionar(item varchar2, dist char default 'N') return alist,
  member procedure adicionar(self in out nocopy alist, item varchar2, dist char default 'N'),
/** [function] Retorna nova lista com valores adicionados<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3');
*  console.log(vlista.adiciona(args('TESTE3','TESTE4'))); -- TESTE1,TESTE2,TESTE3,TESTE3,TESTE4
*  console.log(vlista.adiciona(args('TESTE4','TESTE5'))); -- TESTE1,TESTE2,TESTE3,TESTE3,TESTE4,TESTE4,TESTE5
*  console.log(vlista.adiciona(args('TESTE5','TESTE6'),dist=>'S')); -- TESTE1,TESTE2,TESTE3,TESTE4,TESTE5,TESTE6
*end;
*</code>
* %return nova lista (alist)
**/
  member function adicionar(lista args, dist char default 'N') return alist,
  member procedure adicionar(self in out nocopy alist, lista args, dist char default 'N'),
/** [function] Retorna nova lista com valores adicionados<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3');
*  console.log(vlista.adiciona(alist('TESTE3,TESTE4'))); -- TESTE1,TESTE2,TESTE3,TESTE3,TESTE4
*  console.log(vlista.adiciona(alist('TESTE4-TESTE5',separador=>'-'))); -- TESTE1,TESTE2,TESTE3,TESTE3,TESTE4,TESTE4,TESTE5
*  console.log(vlista.adiciona(alist('TESTE5,TESTE6'),dist=>'S')); -- TESTE1,TESTE2,TESTE3,TESTE4,TESTE5,TESTE6
*end;
*</code>
* %return nova lista (alist)
**/
  member function adicionar(lista alist, dist char default 'N') return alist,
  member procedure adicionar(self in out nocopy alist, lista alist, dist char default 'N'),
/** [function] Retorna nova lista sem valor informado<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3,TESTE3');
*  console.log(vlista.remover('TESTE2')); -- TESTE1,TESTE3,TESTE3
*  console.log(vlista.remover('TESTE3')); -- TESTE1,TESTE2,TESTE3
*  console.log(vlista.remover('TESTE3',dist=>'S')); -- TESTE1,TESTE2
*end;
*</code>
* %return nova lista (alist)
**/
  member function remover(item varchar2, dist char default 'N') return alist,
  member procedure remover(self in out nocopy alist, item varchar2, dist char default 'N'),
/** [function] Retorna nova lista sem valores informados<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3,TESTE3');
*  console.log(vlista.remover(args('TESTE2','TESTE3'))); -- TESTE1,TESTE3
*  console.log(vlista.remover(args('TESTE3','TESTE4'))); -- TESTE1,TESTE2,TESTE3
*  console.log(vlista.remover(args('TESTE2','TESTE3'),dist=>'S')); -- TESTE1
*end;
*</code>
* %return nova lista (alist)
**/
  member function remover(lista args, dist char default 'N') return alist,
  member procedure remover(self in out nocopy alist, lista args, dist char default 'N'),
/** [function] Retorna nova lista sem valores informados<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3,TESTE3');
*  console.log(vlista.remover(alist('TESTE2,TESTE3'))); -- TESTE1,TESTE3
*  console.log(vlista.remover(alist('TESTE3>TESTE4',separador=>'>'))); -- TESTE1,TESTE2,TESTE3
*  console.log(vlista.remover(alist('TESTE2,TESTE3'),dist=>'S')); -- TESTE1
*end;
*</code>
* %return nova lista (alist)
**/
  member function remover(lista alist, dist char default 'N') return alist,
  member procedure remover(self in out nocopy alist, lista alist, dist char default 'N'),
/** [function] Retorna nova lista com valores cruzados<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3,TESTE3');
*  console.log(vlista.cruzar(args('TESTE2','TESTE3','TESTE3','TESTE4'))); -- TESTE2,TESTE3,TESTE3
*  console.log(vlista.cruzar(args('TESTE4','TESTE5'))); -- <vazio>
*  console.log(vlista.cruzar(args('TESTE3','TESTE3','TESTE6'),dist=>'S')); -- TESTE3
*end;
*</code>
* %return nova lista (alist)
**/
  member function cruzar(lista args, dist char default 'N') return alist,
  member procedure cruzar(self in out nocopy alist, lista args, dist char default 'N'),
/** [function] Retorna nova lista com valores cruzados<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3,TESTE3');
*  console.log(vlista.cruzar(alist('TESTE2,TESTE3,TESTE3,TESTE4'))); -- TESTE2,TESTE3,TESTE3
*  console.log(vlista.cruzar(alist('TESTE4-TESTE5',separador=>'-'))); -- <vazio>
*  console.log(vlista.cruzar(alist('TESTE3,TESTE3,TESTE6'),dist=>'S')); -- TESTE3
*end;
*</code>
* %return nova lista (alist)
**/
  member function cruzar(lista alist, dist char default 'N') return alist,
  member procedure cruzar(self in out nocopy alist, lista alist, dist char default 'N'),
/** [function] Retorna lista distinta (sem itens duplicados)<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3,TESTE1');
*  console.log(vlista.set()); -- TESTE1, TESTE2, TESTE3
*end;
*</code>
* %return lista (alist)
**/
  member function dist return alist,
  member procedure dist(self in out nocopy alist),
/** [function] Retorna lista ordenada<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE7,TESTE2,TESTE3,TESTE1');
*  console.log(vlista.set()); -- TESTE1, TESTE2, TESTE3, TESTE7
*end;
*</code>
* %param ordem ('A','D')
* %return lista (alist)
**/
  member function ordenar(ordem char default 'A') return alist,
  member procedure ordenar(self in out nocopy alist, ordem char default 'A'),
/** [function] Retorna uma posição na lista<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3');
*  console.log(vlista.get()); -- TESTE1
*  console.log(vlista.get(2)); -- TESTE2
*end;
*</code>
* %return item (varchar2)
**/
  member function get(ps number default 1) return varchar2,
/** [function] Retorna uma posição na lista (formato 'text')<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE45');
*  console.log(vlista.text().apenas_numeros()); -- 1
*  console.log(vlista.text(3).apenas_numeros()); -- 45
*end;
*</code>
* %return item (text)
**/
  member function text(ps number default 1) return text,
/** [function] Retorna ultimo item na lista<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3');
*  console.log(vlista.ultimo()); -- TESTE3
*end;
*</code>
* %return item (varchar2)
**/
  member function ultimo return varchar2,
/** [function] Retorna primeiro item na lista<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3');
*  console.log(vlista.primeiro()); -- TESTE1
*end;
*</code>
* %return item (varchar2)
**/
  member function primeiro return varchar2,
/** [function] Retorna item com maior length<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE22,TESTE333');
*  console.log(vlista.maior_len()); -- 8
*end;
*</code>
* %return (varchar2)
**/
  member function maior return varchar2,
/** [function] Retorna item com menor length<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE22,TESTE333');
*  console.log(vlista.menor()); -- 6
*end;
*</code>
* %return (varchar2)
**/
  member function menor return varchar2,
/** [function] Retorna length do maior item<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE22,TESTE333');
*  console.log(vlista.maior_length()); -- 8
*end;
*</code>
* %return (number)
**/
  member function maior_length return number,
/** [function] Retorna length do menor item<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE22,TESTE333');
*  console.log(vlista.menor_length()); -- 6
*end;
*</code>
* %return (number)
**/
  member function menor_length return number,
/** [function] Retorna a quantidade de itens na lista<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3');
*  console.log(vlista.tamanho()); -- 3
*end;
*</code>
* %return tamanho (number)
**/
  member function tamanho return number,
/** [function] Verifica se possui o item indicado<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3');
*  console.log(vlista.possui('TESTE2')); -- S
*  console.log(vlista.possui('TESTE5')); -- N
*end;
*</code>
* %return (S/N)
**/
  member function possui(item varchar2) return char,
/** [function] Verifica se possui o item indicado<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3');
*  console.log(vlista.abrange(args('TESTE2','TESTE3'))); -- S
*  console.log(vlista.abrange(args('TESTE3','TESTE5'))); -- N
*end;
*</code>
* %return (S/N)
**/
  member function abrange(lista args) return char,
/** [function] Verifica se possui o item indicado<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3');
*  console.log(vlista.abrange(alist('TESTE2,TESTE3'))); -- S
*  console.log(vlista.abrange(alist('TESTE3:TESTE5',separador=>':'))); -- N
*end;
*</code>
* %return (S/N)
**/
  member function abrange(lista alist) return char,
/** [function] Verifica se possui cruzamento entre as listas<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3');
*  console.log(vlista.cruzamento(alist('TESTE1,TESTE3'))); -- S
*  console.log(vlista.cruzamento(args('TESTE4','TESTE'))); -- N
*end;
*</code>
* %return (S/N)
**/
  member function cruzamento(lista args) return char,
  member function cruzamento(lista alist) return char,
/** [function] Retorna no formato "args"<br>
*<code>
*  select * from table(alist('TESTE1,TESTE2,TESTE3').to_args()); -- <<table[varchar2]: TESTE1, TESTE2, TESTE3>>
*</code>
* %return novo objeto (args)
**/
  member function to_args return args,
/** [function] Retorna no formato "args"<br>
*<code>
*  select * from table(alist('TESTE1,TESTE2,TESTE3').to_args()); -- <<table[varchar2]: TESTE1, TESTE2, TESTE3>>
*</code>
* %return novo objeto (args)
**/
  member function to_table return args,
/** [function] Retorna no formato "argsn"<br>
*<code>
*  select * from table(alist('1,002,3').to_args()); -- <<table[number]: 1, 2, 3>>
*</code>
* %return novo objeto (argsn)
**/
  member function to_argsn return argsn,
/** [function] Retorna no formato "argsd"<br>
*<code>
*  select * from table(alist('01/12/2017,02/12/2017,03/12/2017').to_args()); -- <<table[date]: 01/12/2017, 02/12/2017, 03/12/2017>>
*</code>
* %return novo objeto (argsd)
**/
  member function to_argsd(formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') return argsd,
/** [function] Retorna no formato "varchar2"<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3');
*  console.log(vlista.to_char()); -- 'TESTE1,TESTE2,TESTE3'
*  console.log(vlista.to_char(separador=>' -> ')); -- 'TESTE1 -> TESTE2 -> TESTE3'
*end;
*</code>
* %return texto (varchar2)
**/
  member function to_char(separador char default ',', pre char default null, pos char default null) return varchar2,
/** [function] Retorna no formato "clob"<br>
*<code>
*declare
*  vlista alist;
*begin
*  vlista := alist('TESTE1,TESTE2,TESTE3');
*  console.log(vlista.to_char()); -- 'TESTE1,TESTE2,TESTE3'
*  console.log(vlista.to_char(separador=>' -> ')); -- 'TESTE1 -> TESTE2 -> TESTE3'
*end;
*</code>
* %return texto (clob)
**/
  member function to_clob(separador char default ',', pre char default null, pos char default null) return clob
)
/
create or replace type body alist is

  -- Constructor
  constructor function alist return self as result is
  begin
    self.list := args();
    return;
  end;

  constructor function alist(valores varchar2, separador char default ',') return self as result is
    vs   char := separador;
    vpos number := 1;
    vsub number;
    vlen constant number := length(valores);
    vsep constant number := length(vs);
    valor varchar2(32767);
  begin
    self.list := args();
    -- criação do objeto
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
          self.list.extend;
          self.list(self.list.last) := valor;
        end if;
        -- >> --
        exit when vsub = 0;
        vpos := vsub + vsep;
      end loop;
    end if;
    -- --
    return;
  end;

  constructor function alist(valores clob, separador char default ',') return self as result is
    vs   char := separador;
    vpos number := 1;
    vsub number;
    vlen constant number := length(valores);
    vsep constant number := length(vs);
    valor varchar2(32767);
  begin
    self.list := args();
    -- criação do objeto
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
          self.list.extend;
          self.list(self.list.last) := valor;
        end if;
        -- >> --
        exit when vsub = 0;
        vpos := vsub + vsep;
      end loop;
    end if;
    -- --
    return;
  end;

  -- Member procedures and functions
  member function adicionar(item varchar2, dist char default 'N') return alist is
    result alist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset union distinct args(item);
    else
      result.list.extend;
      result.list(result.list.last) := item;
    end if;
    return result;
  end;

  member procedure adicionar(self in out nocopy alist, item varchar2, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset union distinct args(item);
    else
      self.list.extend;
      self.list(self.list.last) := item;
    end if;
  end;

  member function adicionar(lista args, dist char default 'N') return alist is
    result alist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset union distinct lista;
    else
      result.list := result.list multiset union lista;
    end if;
    return result;
  end;

  member procedure adicionar(self in out nocopy alist, lista args, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset union distinct lista;
    else
      self.list := self.list multiset union lista;
    end if;
  end;

  member function adicionar(lista alist, dist char default 'N') return alist is
    result alist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset union distinct lista.to_args;
    else
      result.list := result.list multiset union lista.to_args;
    end if;
    return result;
  end;

  member procedure adicionar(self in out nocopy alist, lista alist, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset union distinct lista.to_args;
    else
      self.list := self.list multiset union lista.to_args;
    end if;
  end;

  member function remover(item varchar2, dist char default 'N') return alist is
    result alist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset except distinct args(item);
    else
      result.list := result.list multiset except args(item);
    end if;
    return result;
  end;

  member procedure remover(self in out nocopy alist, item varchar2, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset except distinct args(item);
    else
      self.list := self.list multiset except args(item);
    end if;
  end;

  member function remover(lista args, dist char default 'N') return alist is
    result alist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset except distinct lista;
    else
      result.list := result.list multiset except lista;
    end if;
    return result;
  end;

  member procedure remover(self in out nocopy alist, lista args, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset except distinct lista;
    else
      self.list := self.list multiset except lista;
    end if;
  end;

  member function remover(lista alist, dist char default 'N') return alist is
    result alist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset except distinct lista.to_args;
    else
      result.list := result.list multiset except lista.to_args;
    end if;
    return result;
  end;

  member procedure remover(self in out nocopy alist, lista alist, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset except distinct lista.to_args;
    else
      self.list := self.list multiset except lista.to_args;
    end if;
  end;

  member function cruzar(lista args, dist char default 'N') return alist is
    result alist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset intersect distinct lista;
    else
      result.list := result.list multiset intersect lista;
    end if;
    return result;
  end;

  member procedure cruzar(self in out nocopy alist, lista args, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset intersect distinct lista;
    else
      self.list := self.list multiset intersect lista;
    end if;
  end;

  member function cruzar(lista alist, dist char default 'N') return alist is
    result alist := self;
  begin
    if dist like 'S' then
      result.list := result.list multiset intersect distinct lista.to_args;
    else
      result.list := result.list multiset intersect lista.to_args;
    end if;
    return result;
  end;

  member procedure cruzar(self in out nocopy alist, lista alist, dist char default 'N') is
  begin
    if dist like 'S' then
      self.list := self.list multiset intersect distinct lista.to_args;
    else
      self.list := self.list multiset intersect lista.to_args;
    end if;
  end;

  member function dist return alist is
  begin
    return alist(set(self.list));
  end;

  member procedure dist(self in out nocopy alist) is
  begin
    self.list := set(self.list);
  end;

  member function ordenar(ordem char default 'A') return alist is
    result args;
  begin
    if ordenar.ordem = 'A' then
      select x.column_value bulk collect into result from table(self.list) x order by 1;
    elsif ordenar.ordem = 'D' then
      select x.column_value bulk collect into result from table(self.list) x order by 1 desc;
    end if;
    return alist(result);
  end;

  member procedure ordenar(self in out nocopy alist, ordem char default 'A') is
    vtab args := self.list;
  begin
    if ordenar.ordem = 'A' then
      select x.column_value bulk collect into self.list from table(vtab) x order by 1;
    elsif ordenar.ordem = 'D' then
      select x.column_value bulk collect into self.list from table(vtab) x order by 1 desc;
    end if;
  end;

  member function get(ps number default 1) return varchar2 is
  begin
    if self.list is not null and
       self.list.count > 0 and
       self.list.exists(ps) then
      return self.list(ps);
    else
      return null;
    end if;
  end;

  member function text(ps number default 1) return text is
  begin
    if self.list is not null and
       self.list.count > 0 and
       self.list.exists(ps) then
      return text(self.list(ps));
    else
      return null;
    end if;
  end;

  member function ultimo return varchar2 is
  begin
    if self.list is not null and
       self.list.count > 0 then
      return self.list(self.list.last);
    else
      return null;
    end if;
  end;

  member function primeiro return varchar2 is
  begin
    if self.list is not null and
       self.list.count > 0 then
      return self.list(self.list.first);
    else
      return null;
    end if;
  end;

  member function maior return varchar2 is
    vlen   number;
    nlen   number;
    result number := 1;
  begin
    if self.list is not null and
       self.list is not empty then
      vlen := length(self.list(1));
      for i in self.list.first .. self.list.last
      loop
        nlen := length(self.list(i));
        if nlen > vlen then
          vlen   := nlen;
          result := i;
        end if;
      end loop;
    end if;
    return self.list(result);
  end;

  member function menor return varchar2 is
    vlen   number;
    nlen   number;
    result number := 1;
  begin
    if self.list is not null and
       self.list is not empty then
      vlen := length(self.list(1));
      for i in self.list.first .. self.list.last
      loop
        nlen := length(self.list(i));
        if nlen < vlen then
          vlen   := nlen;
          result := i;
        end if;
      end loop;
    end if;
    return self.list(result);
  end;

  member function maior_length return number is
    result number;
  begin
    if self.list is not null and
       self.list is not empty then
      result := length(self.list(1));
      for i in self.list.first .. self.list.last
      loop
        result := greatest(result, length(self.list(i)));
      end loop;
    end if;
    return result;
  end;

  member function menor_length return number is
    result number;
  begin
    if self.list is not null and
       self.list is not empty then
      result := length(self.list(1));
      for i in self.list.first .. self.list.last
      loop
        result := least(result, length(self.list(i)));
      end loop;
    end if;
    return result;
  end;

  member function tamanho return number is
  begin
    return self.list.count;
  end;

  member function possui(item varchar2) return char is
  begin
    if item member of self.list then
      return 'S';
    else
      return 'N';
    end if;
  end;

  member function abrange(lista args) return char is
  begin
    if lista submultiset of self.list then
      return 'S';
    else
      return 'N';
    end if;
  end;

  member function abrange(lista alist) return char is
  begin
    if lista.to_args submultiset of self.list then
      return 'S';
    else
      return 'N';
    end if;
  end;

  member function cruzamento(lista args) return char is
    vaux args := args();
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

  member function cruzamento(lista alist) return char is
    vaux args := args();
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
  begin
    return self.list;
  end;

  member function to_table return args is
  begin
    return self.list;
  end;

  member function to_argsn return argsn is
    result argsn := argsn();
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

  member function to_argsd(formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') return argsd is
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

end;
/
