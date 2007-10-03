create or replace type text as object
(
-- Attributes
  texto varchar2(32767),

-- Constructor
  constructor function text return self as result,
-- Member functions and procedures
  member procedure atribuir(self  in out nocopy text
                           ,texto date default null),
  member function atribuir(self  in out nocopy text
                          ,texto date default null) return text,
  member function alterar(texto date default null) return text,
  member function limpar return text,
  member procedure limpar(self in out nocopy text),
  member function to_array(separador varchar2 default ',') return args,
  member function to_table(separador varchar2 default ',') return args
    pipelined,
  member function apenas_numeros return varchar2,
  member procedure apenas_numeros(self in out nocopy text),
  member function abreviar return text,
  member procedure abreviar(self in out nocopy text),
  member function tamanho return number,
  member function mostra return varchar2
)
/
create or replace type body text is

  -- Constructor
  constructor function text return self as result is
  begin
    self.texto := null;
    return;
  end;

  -- Member procedures and functions
  member procedure atribuir(self  in out nocopy text
                           ,texto date default null) is
  begin
    if texto is not null then
      self.texto := texto;
    end if;
  end atribuir;

  member function atribuir(self  in out nocopy text
                          ,texto date default null) return text is
  begin
    atribuir(texto);
    return self;
  end atribuir;

  member function alterar(texto date default null) return text is
  begin
    return text(texto);
  end alterar;

  member function limpar return text is
    result varchar2(32767);
  begin
    if self.texto is null then
      return text('');
    end if;
  
    -- Remove pontuações (!@#$%.. etc) e números (0-9)
    result := regexp_replace(self.texto, '[[:punct:]]|[[:digit:]]');
  
    -- Remove espaços maiores que 2 (apenas o espaço simples " " é mantido)
    result := regexp_replace(result, '( ){2,}', ' ');
  
    -- Remove acentos (substitui o caracter pela forma sem acento)
    result := utl_raw.cast_to_varchar2(nlssort(result, 'nls_sort=binary_ai'));
  
    -- Remove o caracter hex 0x00 (espaço vazio) que gera erro em arquivos texto
    --
    -- Remove espaços adicionais no início e fim (trim)
    --
    -- Transforma para caixa alta, isto é necessário pois utl_raw.cast_to_varchar2 é insensitive
    result := upper(trim(replace(result, chr(0))));
  
    -- Enfim retorna a string
    return text(result);
  exception
    when others then
      return text('');
  end limpar;

  member procedure limpar(self in out nocopy text) is
  begin
    self := limpar;
  end limpar;

  member function to_array(separador varchar2 default ',') return args is
    result args := args();
  begin
    for reg in (select regexp_substr(self.texto, '[^' || separador || ']+', 1, level) res
                  from dual
                connect by regexp_substr(self.texto, '[^' || separador || ']+', 1, level) is not null)
    loop
      if reg.res is not null then
        result.extend;
        result(result.last) := reg.res;
      end if;
    end loop;
    return result;
  end;

  member function to_table(separador varchar2 default ',') return args
    pipelined is
  begin
    for reg in (select regexp_substr(self.texto, '[^' || separador || ']+', 1, level) res
                  from dual
                connect by regexp_substr(self.texto, '[^' || separador || ']+', 1, level) is not null)
    loop
      if reg.res is not null then
        pipe row(reg.res);
      end if;
    end loop;
  end;

  member function apenas_numeros return varchar2 is
  begin
    return regexp_replace(self.texto, '[[:punct:]]|[[:alpha:]]|\s');
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
      if i in (regnom.first, regnom.last)
         or upper(regnom(i)) in ('DA', 'DAS', 'DE', 'DO', 'DOS') then
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

  member function mostra return varchar2 is
  begin
    return self.texto;
  end;

end;
/
