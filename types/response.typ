create or replace type response as object
(
/**
**/

-- Atributos
/**Subtitulo da mensagem (não obrigatório)
  **/
  subtitulo varchar2(80),

/**Array de ARGUMENTOS(ARGS) contendo 1(uma) ou mais mensagens
  **/
  mensagem args,

/**Tipo de Mensagem<br> 
  * Retorno conforme tabela abaixo:<br>
  * {*} null => OK<br>
  * {*} S    => Sucesso<br>
  * {*} I    => Informação<br>
  * {*} A    => Alerta<br>
  * {*} Q    => Questão<br>
  * {*} E    => Erro<br>
  * {*} B    => BUG<br>
  **/
  tipo char,

/** [constructor]  Construtor Genérico/NULL<br>
  *<code>
  *declare
  *  rp response := response();
  *begin
  *  rp.setTipo('I');
  *  rp.adicionar('Olá Mundo');
  *  console.log(rp);
  *end;
  *</code>
  **/
  constructor function response return self as result,

/** [constructor] Construtor com parâmetros<br>
  *<code>
  *declare
  *  rp response := response('Olá Mundo', 'I');
  *begin
  *  console.log(rp);
  *end;
  *</code>
  * %param mensagem (varchar2) Informar <b>UMA</b> Mensagem em forma de Texto
  * %param tipo (number) Informar o Tipo da Mensagem
  * %param subtitulo (varchar2) Informar o Subtítulo, se quiser
  **/
  constructor function response(mensagem  varchar2
                               ,tipo      char default null
                               ,subtitulo varchar2 default null) return self as result,

/** [constructor] Construtor com parâmetros<br>
  *<code>
  *declare
  *  rp response :=response(args('Olá Mundo', 'Ocorreu um ERRO'), 'E');
  *begin
  *  console.log(rp);
  *end;
  *</code>
  * %param mensagem (args) Informar <b>UMA ou MAIS</b> Mensagem utilizando um array de Argumentos
  * %param tipo (char) Informar o Tipo da Mensagem
  * %param subtitulo (varchar2) Informar o Subtítulo, se quiser
  **/
  constructor function response(mensagem  args
                               ,tipo      char default null
                               ,subtitulo varchar2 default null) return self as result,

/** [procedure] Setar o Tipo da Mensagem<br>
  *<code>
  *declare
  *  rp response := response();
  *begin
  *  rp.setTipo('I');
  *  rp.adicionar('Olá Mundo');
  *  console.log(rp);
  *end;
  *</code>
  * %param tipo (char) Informar o Tipo da Mensagem
  **/
  member procedure settipo(self in out nocopy response
                          ,tipo char),

/** [procedure] Setar o Tipo da Mensagem<br>
  *<code>
  *declare
  *  rp response := response('Alerta!','A');
  *  rp2 response := response('Questão?','Q');
  *  rp3 response := response('Erro!','E');
  *  rp4 response := response('Sucesso!','S');
  *begin
  *  rp.merge(rp4); // response('Alerta!', 'A');
  *  rp.merge(rp2); // response('Alerta!
  *                             Questão?', 'Q');
  *  rp.merge(rp3); // response('Erro!','E');
  *end;
  *</code>
  * %param res (response) Informar "response" que será mesclado com o atual
  **/
  member procedure merge(self in out nocopy response
                        ,res  response),

/** [procedure] Adcionar uma nova Mensagem<br>
  *<code>
  *declare
  *  rp response :=response('Olá Mundo', 'I');
  *begin
  *  rp.adicionar('Olá Mundo Novo');
  *  console.log(rp);
  *end;
  *</code>
  * %param mensagem (varchar2) Informar a Mensagem
  **/
  member procedure adicionar(self     in out nocopy response
                            ,mensagem varchar2),

/** [procedure] Adcionar uma nova Mensagem<br>
  *<code>
  *declare
  *  rp response :=response('Olá Mundo', 'I');
  *  rp2 response :=response('Olá Mundo Novo', 'I');
  *begin
  *  rp2.adicionar(rp.mensagem);
  *  console.log(rp2.to_char());
  *end;
  *</code>
  * %param mensagem (varchar2) Informar a Mensagem
  **/
  member procedure adicionar(self     in out nocopy response
                            ,mensagem args),

/** [procedure] Concatena o texto à ultima mensagem adcionada ao Array<br>
  *<code>
  *declare
  *  rp response :=response('Olá Mundo', 'I');
  *begin
  *  rp.concat('Olá Mundo Novo');
  *  console.log(rp);
  *end;
  *</code>
  * %param texto (varchar2) Informar o Texto a ser Concatenado 
  * %param seperador (char) Informar o Separador para a concatenação, se não informado assumira o ENTER como default
  **/
  member procedure concat(self      in out nocopy response
                         ,texto     varchar2
                         ,seperador char default chr(10)),

/** [function] Retorna as Mensagem em Forma de Texto<br>
  * OBS: Se Houver somente uma mensagem no Array, o caracter Marcador não será utilizado
  *<code>
  *declare
  *  rp response :=response('Olá Mundo', 'I');
  *begin
  *  rp.concat('Olá Mundo Novo');
  *  console.log(rp);
  *end;
  *</code>
  * %param marcador (char) Informar o Marcador desejado para multiplas mensagems, se não informado, assumira o character bullet(chr(7))
  * %return (varchar2) Retorna um texto com as mensagens
  **/
  member function to_char(marcador char default chr(7)) return varchar2

)
/
create or replace type body response is

  -- Método Constructor Nulo
  constructor function response return self as result is
  begin
    self.mensagem := args();
    return;
  end;

  -- Método Constructor com Mensagem(VARCHAR2), Tipo e Subtítulo
  constructor function response(mensagem  varchar2
                               ,tipo      char default null
                               ,subtitulo varchar2 default null) return self as result is
  begin
    if not nvl(tipo, 'S') in ('S', 'I', 'A', 'Q', 'E', 'B') then
      raise_application_error(-20700
                             ,'TIPO do Objeto RESPONSE deve ter um dos seguintes valores: "S"[Sucesso], "I"[Informação], "A"[Alerta], "E"[Erro], "B"[Bug] ou NULL');
    end if;
  
    if mensagem is not null then
      self.mensagem := args(mensagem);
    else
      self.mensagem := args();
    end if;
    self.tipo      := tipo;
    self.subtitulo := subtitulo;
    return;
  end;

  -- Método Constructor com Mensagem(ARGS), Tipo e Subtítulo 
  constructor function response(mensagem  args
                               ,tipo      char default null
                               ,subtitulo varchar2 default null) return self as result is
  begin
    if not nvl(tipo, 'S') in ('S', 'I', 'A', 'Q', 'E', 'B') then
      raise_application_error(-20700
                             ,'TIPO do Objeto RESPONSE deve ter um dos seguintes valores: "S"[Sucesso], "I"[Informação], "A"[Alerta], "E"[Erro], "B"[Bug] ou NULL');
    end if;
  
    self.mensagem  := mensagem;
    self.tipo      := tipo;
    self.subtitulo := subtitulo;
    return;
  end;

  -- Member functions and procedures
  member procedure settipo(self in out nocopy response
                          ,tipo char) is
  begin
    if not nvl(tipo, 'S') in ('S', 'I', 'A', 'Q', 'E', 'B') then
      raise_application_error(-20700
                             ,'TIPO do Objeto RESPONSE deve ter um dos seguintes valores: "S"[Sucesso], "I"[Informação], "A"[Alerta], "E"[Erro], "B"[Bug] ou NULL');
    end if;
  
    if tipo is not null then
      self.tipo := tipo;
    end if;
  end;

  member procedure merge(self in out nocopy response
                        ,res  response) is
  begin
    if self.tipo is null then
      self := res;
    elsif self.tipo in ('I', 'S') then
      if res.tipo in ('Q', 'E', 'A', 'B') then
        self := res;
      elsif res.tipo in ('I', 'S') then
        self.adicionar(res.mensagem);
        if res.tipo = 'S'
           and res.tipo <> self.tipo then
          self.tipo := res.tipo;
        end if;
      end if;
    elsif self.tipo = 'A' then
      if res.tipo in ('E', 'B') then
        self := res;
      elsif res.tipo in ('Q', 'A') then
        self.tipo := res.tipo;
        self.adicionar(res.mensagem);
      end if;
    elsif self.tipo = 'Q' then
      if res.tipo in ('E', 'B') then
        self := res;
      elsif res.tipo in ('Q', 'A') then
        self.adicionar(res.mensagem);
      end if;
    elsif self.tipo = 'E'
          and res.tipo = 'B' then
      self.tipo := res.tipo;
      self.adicionar(res.mensagem);
    elsif self.tipo = 'B'
          and res.tipo = 'E' then
      self.adicionar(res.mensagem);
    end if;
  end;

  member procedure adicionar(self     in out nocopy response
                            ,mensagem varchar2) is
  begin
    if mensagem is not null then
      self.mensagem.extend;
      self.mensagem(self.mensagem.last) := mensagem;
    end if;
  end;

  member procedure adicionar(self     in out nocopy response
                            ,mensagem args) is
  begin
    if mensagem is not null
       and mensagem is not empty then
      for i in mensagem.first .. mensagem.last
      loop
        self.mensagem.extend;
        self.mensagem(self.mensagem.last) := mensagem(i);
      end loop;
    end if;
  end;

  member procedure concat(self      in out nocopy response
                         ,texto     varchar2
                         ,seperador char default chr(10)) is
  begin
    if mensagem is not null then
      self.mensagem(self.mensagem.last) := self.mensagem(self.mensagem.last) || seperador || texto;
    end if;
  end;

  member function to_char(marcador char default chr(7)) return varchar2 is
    v_ret varchar2(32767);
  begin
    if self.mensagem is not empty then
      if self.mensagem.count = 1 then
        v_ret := trim(self.mensagem(1));
      else
        for i in self.mensagem.first .. self.mensagem.last
        loop
          v_ret := v_ret || trim(marcador || ' ' || self.mensagem(i)) || chr(10);
        end loop;
      end if;
    end if;
    return v_ret;
  end;
end;
/
