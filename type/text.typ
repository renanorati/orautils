create or replace type text force as object
(
-- Author  : Renan Orati (renanorati@gmail.com)

-- Attributes
  texto varchar2(32767),

-- Constructor
  constructor function text return self as result,
/** [constructor] Construir o objeto vazio<br>
*<code>
*declare
*  vtexto text;
*begin
*  vtexto := text('Nome: %s | Sobrenome: %s | Idade: %s', args('John', 'Doe', 37));
*  console.log(vtexto.to_char()); -- 'Nome: John | Sobrenome: Doe | Idade: 37'
*end;
*</code>
* %return novo objeto (text)
**/
  constructor function text(value varchar2, format args) return self as result,

-- Member functions and procedures
  member procedure atribuir(self in out nocopy text, texto date default null),
  member function atribuir(self in out nocopy text, texto date default null) return text,
  member function alterar(texto date default null) return text,
  member function remover_acentos return varchar2,
  member procedure remover_acentos(self in out nocopy text),
  member function remover_enter(inicio char default 'S', fim char default 'S', todos char default 'N') return varchar2,
  member procedure remover_enter(self in out nocopy text),
  member function limpar return text,
  member procedure limpar(self in out nocopy text),
  member function apenas_numeros return varchar2,
  member procedure apenas_numeros(self in out nocopy text),
  member function abreviar return text,
  member procedure abreviar(self in out nocopy text),
  member function tamanho return number,
  member function formata(valores varchar2) return varchar2,
  member function formata(valores args) return varchar2,
  member function to_array(separador varchar2 default ',', multi char default 'S') return args,
  member function to_args(separador varchar2 default ',', multi char default 'S') return args,
  member function to_argsn(separador varchar2 default ',', multi char default 'S') return argsn,
  member function to_table(separador varchar2 default ',', multi char default 'S') return args,
  member function mostra return varchar2,
  member function to_s return varchar2,
  member function to_char return varchar2
)
/
create or replace type body text is

  -- Constructor
  constructor function text return self as result is
  begin
    return;
  end;

  constructor function text(value varchar2, format args) return self as result is
  begin
    self.texto := value;
    self.texto := self.formata(format);
    return;
  end;

  -- Member procedures and functions
  member procedure atribuir(self in out nocopy text, texto date default null) is
  begin
    if texto is not null then
      self.texto := texto;
    end if;
  end atribuir;

  member function atribuir(self in out nocopy text, texto date default null) return text is
  begin
    atribuir(texto);
    return self;
  end atribuir;

  member function alterar(texto date default null) return text is
  begin
    return text(texto);
  end alterar;

  member function remover_acentos return varchar2 is
    result varchar2(32767);
  begin
    if self.texto is null then
      return null;
    end if;
    -- Remove acentos (substitui o caracter pela forma sem acento)
    result := translate(self.texto, 'ÁÇÉÍÓÚÀÈÌÒÙÂÊÎÔÛÃÕËÜáçéíóúàèìòùâêîôûãõëü', 'ACEIOUAEIOUAEIOUAOEUaceiouaeiouaeiouaoeu');
  
    -- Remove o caracter hex 0x00 (espaço vazio) que gera erro em arquivos texto
    --
    -- Remove espaços adicionais no início e fim (trim)
    result := trim(replace(result, chr(0)));
  
    -- Enfim retorna a string
    return result;
  exception
    when others then
      return null;
  end remover_acentos;

  member procedure remover_acentos(self in out nocopy text) is
  begin
    self.texto := remover_acentos();
  end remover_acentos;

  member function remover_enter(inicio char default 'S', fim char default 'S', todos char default 'N') return varchar2 is
    result varchar2(32767);
  begin
    if self.texto is null then
      return null;
    else
      result := self.texto;
    end if;
    -- Remove ENTER
    if todos like 'S' then
      result := replace(result, chr(10));
    else
      if inicio like 'S' then
        result := ltrim(result, chr(10));
      end if;
      if fim like 'S' then
        result := rtrim(result, chr(10));
      end if;
    end if;
    -- Retorna a string
    return result;
  exception
    when others then
      return null;
  end remover_enter;

  member procedure remover_enter(self in out nocopy text) is
  begin
    self.texto := remover_enter();
  end remover_enter;

  member function limpar return text is
    result text;
  begin
    if self.texto is null then
      return text('');
    else
      result := text(self.texto);
    end if;
  
    -- Remove acentos, pontuações (!@#$%.. etc) e números (0-9)
    result.texto := regexp_replace(result.remover_acentos(), '[[:punct:]]|[[:digit:]]');
  
    -- Remove espaços maiores que 2 (apenas o espaço simples " " é mantido)
    result.texto := regexp_replace(result.texto, '( ){2,}', ' ');
  
    -- Remove ENTER
    result.remover_enter;
  
    -- Enfim retorna a string
    return result;
  exception
    when others then
      return text('');
  end limpar;

  member procedure limpar(self in out nocopy text) is
  begin
    self := limpar;
  end limpar;

  member function apenas_numeros return varchar2 is
  begin
    return regexp_replace(self.texto, '[^[:digit:]]');
  end;

  member procedure apenas_numeros(self in out nocopy text) is
  begin
    self.texto := apenas_numeros();
  end;

  member function abreviar return text is
    regnom args;
    result varchar2(32767);
  begin
    -- separando nomes
    regnom := to_array(' ');
    -- abreviando nomes do meio
    for i in regnom.first .. regnom.last
    loop
      if i in (regnom.first, regnom.last) or
         upper(regnom(i)) in ('DA', 'DAS', 'DE', 'DO', 'DOS') then
        result := result || regnom(i) || ' ';
      else
        if upper(regnom(i)) like 'APARECID%' then
          result := result || substr(regnom(i), 1, 2) || '. ';
        else
          result := result || substr(regnom(i), 1, 1) || '. ';
        end if;
      end if;
    end loop;
    -- removendo sobras de espaço
    result := trim(result);
    -- --
    return text(result);
  exception
    when others then
      return null;
  end;

  member procedure abreviar(self in out nocopy text) is
  begin
    self := abreviar;
  end;

  member function tamanho return number is
  begin
    return length(self.texto);
  end;

  member function formata(valores varchar2) return varchar2 is
    v_valores args := text(valores).to_array();
  begin
    return formata(v_valores);
  end formata;

  member function formata(valores args) return varchar2 is
    v_texto_formatado varchar2(32767) := self.texto;
  begin
    -- TODO validar o numero de parametros com a qtde de %s
    -- se estiver diferente, deve lançar excecao
    for i in valores.first .. valores.last
    loop
      v_texto_formatado := regexp_replace(v_texto_formatado, '%s', valores(i), 1, 1);
    end loop;
    v_texto_formatado := regexp_replace(v_texto_formatado, '\\n', chr(10));
    return v_texto_formatado;
  end formata;

  member function to_array(separador varchar2 default ',', multi char default 'S') return args is
  begin
    return to_args(separador, multi);
  end;

  member function to_args(separador varchar2 default ',', multi char default 'S') return args as
    result args := args();
    vpos   number := 1;
    vsub   number;
    vlen constant number := length(self.texto);
    vsep constant number := length(separador);
    valor varchar2(32767);
  begin
    if vlen > 0 then
      if length(separador) <= 1 or
         multi = 'N' then
        loop
          vsub := instr(self.texto, separador, vpos);
          if vsub = 0 then
            valor := substr(self.texto, vpos);
          else
            valor := substr(self.texto, vpos, vsub - vpos);
          end if;
          -- >> atrib
          if valor is not null then
            result.extend;
            result(result.last) := valor;
          end if;
          -- >> --
          exit when vsub = 0;
          vpos := vsub + vsep;
        end loop;
      else
        declare
          i number := 1;
        begin
          loop
            valor := regexp_substr(self.texto, '[^' || separador || ']+', 1, i);
            exit when valor is null;
            -- >> atrib
            result.extend;
            result(result.last) := valor;
            -- >> --
            i := i + 1;
          end loop;
        end;
      end if;
    end if;
    return result;
  end;

  member function to_argsn(separador varchar2 default ',', multi char default 'S') return argsn as
    result argsn := argsn();
    vpos   number := 1;
    vsub   number;
    vlen constant number := length(self.texto);
    vsep constant number := length(separador);
    valor number;
  begin
    if vlen > 0 then
      if length(separador) <= 1 or
         multi = 'N' then
        loop
          vsub := instr(self.texto, separador, vpos);
          if vsub = 0 then
            valor := substr(self.texto, vpos);
          else
            valor := substr(self.texto, vpos, vsub - vpos);
          end if;
          -- >> atrib
          if valor is not null then
            result.extend;
            result(result.last) := valor;
          end if;
          -- >> --
          exit when vsub = 0;
          vpos := vsub + vsep;
        end loop;
      else
        declare
          i number := 1;
        begin
          loop
            valor := regexp_substr(self.texto, '[^' || separador || ']+', 1, i);
            exit when valor is null;
            -- >> atrib
            result.extend;
            result(result.last) := valor;
            -- >> --
            i := i + 1;
          end loop;
        end;
      end if;
    end if;
    return result;
  end;

  member function to_table(separador varchar2 default ',', multi char default 'S') return args is
  begin
    return to_args(separador, multi);
  end;

  member function mostra return varchar2 is
  begin
    return self.texto;
  end;

  member function to_s return varchar2 is
  begin
    return self.texto;
  end;

  member function to_char return varchar2 is
  begin
    return self.texto;
  end;

end;
/
