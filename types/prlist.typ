create or replace type prlist force as object
(
-- Attributes
  list argspr,

-- Constructor
  constructor function prlist return self as result,
/** [constructor] Construir o objeto inserindo string de datas iniciais:<br>
* Datas devem ser separadas por ";" ou um intervalo de datas separados por "-".<br>
*<code>
*declare
*  vlista prlist;
*begin
*  vlista := prlist('12/01/2020-16/01/2020;21/01/2020;30/01/2020');
*  console.log(vlista.to_argspr()); -- 12/01/2020, 13/01/2020, 14/01/2020, 15/01/2020, 16/01/2020, 21/01/2020, 30/01/2020
*end;
*</code>
* %return novo objeto (prlist)
**/
  constructor function prlist(valores   varchar2
                             ,separador char default ';'
                             ,intervalo char default '-'
                             ,formato   varchar2 default 'DD/MM/RRRR HH24:MI:SS') return self as result,
/** [constructor] Construir o objeto inserindo string de datas iniciais:<br>
* Datas devem ser separadas por ";" ou um intervalo de datas separados por "-".<br>
*<code>
*declare
*  vlista prlist;
*begin
*  vlista := prlist('12/01/2020-16/01/2020;21/01/2020;30/01/2020');
*  console.log(vlista.to_argspr()); -- 12/01/2020, 13/01/2020, 14/01/2020, 15/01/2020, 16/01/2020, 21/01/2020, 30/01/2020
*end;
*</code>
* %return novo objeto (prlist)
**/
  constructor function prlist(valores clob, separador char default ';', intervalo char default '-', formato varchar2 default 'DD/MM/RRRR HH24:MI:SS')
    return self as result,
/** [constructor] Construir o objeto inserindo unica data inicial<br>
*<code>
*declare
*  vlista prlist;
*begin
*  vlista := prlist(17/01/2020);
*  console.log(vlista.to_argspr()); -- 17/01/2020
*end;
*</code>
* %return novo objeto (prlist)
**/
  constructor function prlist(valor period) return self as result,

-- Member functions and procedures
  member procedure validar(valores clob, separador char default ';', intervalo char default '-', formato varchar2 default 'DD/MM/RRRR HH24:MI:SS'),
/** [function] Retorna nova lista com valor adicionado<br>
*<code>
*declare
*  vlista prlist;
*begin
*  vlista := prlist('01/01/2020;07/01/2020;09/01/2020');
*  console.log(vlista.adicionar('04/01/2020')); -- 01/01/2020, 07/01/2020, 09/01/2020, 04/01/2020
*  console.log(vlista.adicionar('09/01/2020')); -- 01/01/2020, 07/01/2020, 09/01/2020, 09/01/2020
*  console.log(vlista.adicionar('09/01/2020',dist=>'S')); -- 01/01/2020, 07/01/2020, 09/01/2020
*end;
*</code>
* %return nova lista (prlist)
**/
  member function adicionar(periodo period) return prlist,
  member procedure adicionar(periodo period),
/** [function] Retorna nova lista com valor adicionado<br>
*<code>
*declare
*  vlista prlist;
*begin
*  vlista := prlist('01/01/2020;07/01/2020;09/01/2020');
*  console.log(vlista.adicionar('04/01/2020')); -- 01/01/2020, 07/01/2020, 09/01/2020, 04/01/2020
*  console.log(vlista.adicionar('09/01/2020')); -- 01/01/2020, 07/01/2020, 09/01/2020, 09/01/2020
*  console.log(vlista.adicionar('09/01/2020',dist=>'S')); -- 01/01/2020, 07/01/2020, 09/01/2020
*end;
*</code>
* %return nova lista (prlist)
**/
  member function adicionar(data date) return prlist,
  member procedure adicionar(data date),
/** [function] Retorna nova lista com valores adicionados<br>
*<code>
*declare
*  vlista prlist;
*begin
*  vlista := prlist('01/01/2020;07/01/2020;09/01/2020');
*  console.log(vlista.adicionar(argspr('03/01/2020','04/01/2020'))); -- 01/01/2020, 07/01/2020, 09/01/2020, 03/01/2020, 04/01/2020
*  console.log(vlista.adicionar(argspr('04/01/2020','09/01/2020'))); -- 01/01/2020, 07/01/2020, 09/01/2020, 04/01/2020, 09/01/2020
*  console.log(vlista.adicionar(argspr('04/01/2020','09/01/2020'),dist=>'S')); -- 01/01/2020, 07/01/2020, 09/01/2020, 04/01/2020
*end;
*</code>
* %return nova lista (prlist)
**/
  member function adicionar(lista argspr) return prlist,
  member procedure adicionar(lista argspr),
/** [function] Retorna nova lista com valores adicionados<br>
*<code>
*declare
*  vlista prlist;
*begin
*  vlista := prlist('01/01/2020;07/01/2020;09/01/2020');
*  console.log(vlista.adicionar(prlist('03/01/2020;04/01/2020'))); -- 01/01/2020, 07/01/2020, 09/01/2020, 03/01/2020, 04/01/2020
*  console.log(vlista.adicionar(prlist('04/01/2020-09/01/2020'))); -- 01/01/2020, 07/01/2020, 09/01/2020, 04/01/2020, 05/01/2020, 06/01/2020, 07/01/2020, 08/01/2020, 09/01/2020
*  console.log(vlista.adicionar(prlist('04/01/2020;09/01/2020'),dist=>'S')); -- 01/01/2020, 07/01/2020, 09/01/2020, 04/01/2020
*end;
*</code>
* %return nova lista (prlist)
**/
  member function adicionar(lista prlist) return prlist,
  member procedure adicionar(lista prlist),
/** REMOVER PERÍODOS **/
  member function remover(periodo period) return prlist,
  member procedure remover(self in out nocopy prlist, periodo period),
  member function remover(data date) return prlist,
  member procedure remover(data date),
  member function remover(lista argspr) return prlist,
  member procedure remover(self in out nocopy prlist, lista argspr),
  member function remover(lista prlist) return prlist,
  member procedure remover(self in out nocopy prlist, lista prlist),
  member function nulo return char,
/** [function] Retorna a quantidade de itens na lista<br>
*<code>
*declare
*  vlista prlist;
*begin
*  vlista := prlist('12/01/2020-16/01/2020;21/01/2020');
*  console.log(vlista.tamanho()); -- 6
*end;
*</code>
* %return tamanho (number)
**/
  member function tamanho return number,
/** [function] Retorna o primeiro período<br>
*<code>
*declare
*  vlista prlist;
*begin
*  vlista := prlist('12/01/2020-16/01/2020;21/01/2020');
*  console.log(vlista.primeiro.to_char()); -- 12/01/2020
*end;
*</code>
* %return primeiro (period)
**/
  member function primeiro return period,
/** [function] Retorna o último período<br>
*<code>
*declare
*  vlista prlist;
*begin
*  vlista := prlist('12/01/2020-16/01/2020;21/01/2020');
*  console.log(vlista.ultimo.to_char()); -- 21/01/2020
*end;
*</code>
* %return ultimo (period)
**/
  member function ultimo return period,
/** [function] Verifica cruzamento de períodos<br>
*<code>
*declare
*  vperiodo period := period('13/10/2016','21/09/2018');
*begin
*  console.log(args(
*    vperiodo.cruzamento(period('21/09/2018','28/09/2018')), -- S
*    vperiodo.cruzamento(period('01/09/2018','21/09/2018')), -- S
*    vperiodo.cruzamento(period('01/10/2018')), -- N
*    vperiodo.cruzamento(period('01/01/2015')), -- S
*    vperiodo.cruzamento(period(anomes=>201809)), -- S
*    vperiodo.cruzamento(period(anomes=>201812)), -- N
*    vperiodo.cruzamento(period(ano=>2017)), -- S
*    vperiodo.cruzamento(period(ano=>2019)) -- S
*  ));
*end;
*</code>
* %return char (S/N)
* %param periodo period
* %param infinito char default 'N' 
* %param considerar_horario char default 'N' 
**/
  member function cruzamento(periodo period, infinito char default 'N', considerar_horario char default 'N') return char,
/** [function] Verifica cruzamento de períodos<br>
*<code>
*declare
*  vperiodo period := period('13/10/2016','21/09/2018');
*begin
*  console.log(args(
*    vperiodo.cruzamento(datetime('21/09/2018'),datetime('28/09/2018')), -- S
*    vperiodo.cruzamento(datetime('01/09/2018'),datetime('21/09/2018')), -- S
*    vperiodo.cruzamento(datetime('01/10/2018')), -- N
*    vperiodo.cruzamento(datetime('01/01/2015')) -- S
*  ));
*end;
*</code>
* %return char (S/N)
* %param inicio datetime 
* %param fim datetime 
* %param infinito char default 'N' 
* %param considerar_horario char default 'N' 
**/
  member function cruzamento(inicio             datetime default datetime()
                            ,fim                datetime default datetime()
                            ,infinito           char default 'N'
                            ,considerar_horario char default 'N') return char,
/** [function] Verifica cruzamento de períodos<br>
*<code>
*declare
*  vperiodo period := period('13/10/2016','21/09/2018');
*begin
*  console.log(args(
*    vperiodo.cruzamento('21/09/2018','28/09/2018'), -- S
*    vperiodo.cruzamento('01/09/2018','21/09/2018'), -- S
*    vperiodo.cruzamento('01/10/2018'), -- N
*    vperiodo.cruzamento('01/01/2015') -- S
*  ));
*end;
*</code>
* %return char (S/N)
* %param inicio varchar2 
* %param fim varchar2 
* %param formato varchar2 default 'DD/MM/RRRR HH24:MI:SS' 
* %param infinito char default 'N' 
* %param considerar_horario char default 'N'
**/
  member function cruzamento(inicio             varchar2 default null
                            ,fim                varchar2 default null
                            ,formato            varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                            ,infinito           char default 'N'
                            ,considerar_horario char default 'N') return char,
/** [function] Verifica cruzamento de períodos<br>
*<code>
*declare
*  vperiodo period := period('13/10/2016','21/09/2018');
*begin
*  console.log(args(
*    vperiodo.cruzamento(to_date('21/09/2018'),to_date('28/09/2018')), -- S
*    vperiodo.cruzamento(to_date('01/09/2018'),to_date('21/09/2018')), -- S
*    vperiodo.cruzamento(to_date('01/10/2018')), -- N
*    vperiodo.cruzamento(to_date('01/01/2015')) -- S
*  ));
*end;
*</code>
* %return char (S/N)
* %param inicio date 
* %param fim date 
* %param infinito char default 'N' 
* %param considerar_horario char default 'N' 
**/
  member function cruzamento(inicio date default null, fim date default null, infinito char default 'N', considerar_horario char default 'N')
    return char,
/** [function] Verifica cruzamento de períodos<br>
*<code>
*declare
*  vperiodo period := period('13/10/2016','21/09/2018');
*begin
*  console.log(args(
*    vperiodo.cruzamento(to_date('21/09/2018'),to_date('28/09/2018')), -- S
*    vperiodo.cruzamento(to_date('01/09/2018'),to_date('21/09/2018')), -- S
*    vperiodo.cruzamento(to_date('01/10/2018')), -- N
*    vperiodo.cruzamento(to_date('01/01/2015')) -- S
*  ));
*end;
*</code>
* %return char (S/N)
* %param inicio date 
* %param fim date 
* %param infinito char default 'N' 
* %param considerar_horario char default 'N' 
**/
  member function cruzamento(list argspr, infinito char default 'N', considerar_horario char default 'N') return char,
/** [function] Verifica cruzamento de períodos<br>
*<code>
*declare
*  vperiodo period := period('13/10/2016','21/09/2018');
*begin
*  console.log(args(
*    vperiodo.cruzamento(to_date('21/09/2018'),to_date('28/09/2018')), -- S
*    vperiodo.cruzamento(to_date('01/09/2018'),to_date('21/09/2018')), -- S
*    vperiodo.cruzamento(to_date('01/10/2018')), -- N
*    vperiodo.cruzamento(to_date('01/01/2015')) -- S
*  ));
*end;
*</code>
* %return char (S/N)
* %param inicio date 
* %param fim date 
* %param infinito char default 'N' 
* %param considerar_horario char default 'N' 
**/
  member function cruzamento(list prlist, infinito char default 'N', considerar_horario char default 'N') return char,
/** [function] Verifica cruzamento de períodos<br>
*<code>
*declare
*  vperiodo period := period('13/10/2016','28/12/2016');
*  vperiodo2 period := period('01/02/2016','10/02/2016');
*begin
*  console.log(args(
*    vperiodo.cruzamento_lista(datetime.feriados()), -- S
*    vperiodo2.cruzamento_lista(datetime.feriados()) -- N
*  ));
*end;
*</code>
* %return char (S/N)
* %param list argsd default argsd() 
**/
  member function cruzamento(list argsd, infinito char default 'N', considerar_horario char default 'N') return char,
  member function cruzamento(list argsdt, infinito char default 'N', considerar_horario char default 'N') return char,
  member function cruzamento(list datelist, infinito char default 'N', considerar_horario char default 'N') return char,
/** [function] Verifica cruzamento de períodos<br>
*<code>
*declare
*  vperiodo period := period('13/10/2016','28/12/2016');
*  vperiodo2 period := period('01/02/2016','10/02/2016');
*  feriados_nacionais varchar2(500):= '01/01/2016;21/04/2016;01/05/2016;07/09/2016;12/10/2016;02/11/2016;15/11/2016;25/12/2016';
*begin
*  console.log(args(
*    vperiodo.cruzamento_lista(feriados_nacionais), -- S
*    vperiodo2.cruzamento_lista(feriados_nacionais) -- N
*  ));
*end;
*</code>
* %return char (S/N)
* %param list varchar2 
* %param formato varchar2 default 'DD/MM/RRRR HH24:MI:SS' 
* %param separador varchar2 default ';'
**/
  member function cruzamento_lista(list      varchar2 default null
                                  ,formato   varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                                  ,separador varchar2 default ';'
                                  ,infinito  char default 'N') return char,
/** [function] Verifica se o período possui uma data<br>
*<code>
*declare
*  vperiodo period := period('13/01/2016','21/09/2018');
*  vperiodo2 period := period('01/01/2016');
*  vperiodo3 period := period('01/02/2016');
*begin
*  console.log(args(
*    vperiodo.possui(datetime('11/01/2016')), -- N
*    vperiodo2.possui(datetime('11/01/2016')), -- S
*    vperiodo3.possui(datetime('11/01/2016')) -- N
*  ));
*end;
*</code>
* %return char (S/N)
* %param data datetime 
* %param infinito char default 'N' 
* %param considerar_horario char default 'N' 
**/
  member function possui(periodo period, infinito char default 'N', considerar_horario char default 'N') return char,
/** [function] Verifica se o período possui uma data<br>
*<code>
*declare
*  vperiodo period := period('13/01/2016','21/09/2018');
*  vperiodo2 period := period('01/01/2016');
*  vperiodo3 period := period('01/02/2016');
*begin
*  console.log(args(
*    vperiodo.possui(datetime('11/01/2016')), -- N
*    vperiodo2.possui(datetime('11/01/2016')), -- S
*    vperiodo3.possui(datetime('11/01/2016')) -- N
*  ));
*end;
*</code>
* %return char (S/N)
* %param data datetime 
* %param infinito char default 'N' 
* %param considerar_horario char default 'N' 
**/
  member function possui(list prlist, infinito char default 'N', considerar_horario char default 'N') return char,
/** [function] Verifica se o período possui uma data<br>
*<code>
*declare
*  vperiodo period := period('13/01/2016','21/09/2018');
*  vperiodo2 period := period('01/01/2016');
*  vperiodo3 period := period('01/02/2016');
*begin
*  console.log(args(
*    vperiodo.possui(datetime('11/01/2016')), -- N
*    vperiodo2.possui(datetime('11/01/2016')), -- S
*    vperiodo3.possui(datetime('11/01/2016')) -- N
*  ));
*end;
*</code>
* %return char (S/N)
* %param data datetime 
* %param infinito char default 'N' 
* %param considerar_horario char default 'N' 
**/
  member function possui(data datetime, infinito char default 'N', considerar_horario char default 'N') return char,
/** [function] Verifica se o período possui uma data<br>
*<code>
*declare
*  vperiodo period := period('13/01/2016','21/09/2018');
*  vperiodo2 period := period('01/01/2016');
*  vperiodo3 period := period('01/02/2016');
*begin
*  console.log(args(
*    vperiodo.possui(to_date('11/01/2016')), -- N
*    vperiodo2.possui(to_date('11/01/2016')), -- S
*    vperiodo3.possui(to_date('11/01/2016')) -- N
*  ));
*end;
*</code>
* %return char (S/N)
* %param data date 
* %param infinito char default 'N' 
* %param considerar_horario char default 'N'
**/
  member function possui(data date, infinito char default 'N', considerar_horario char default 'N') return char,
/** [function] Verifica se o período possui uma data<br>
*<code>
*declare
*  vperiodo period := period('13/01/2016','21/09/2018');
*  vperiodo2 period := period('01/01/2016');
*  vperiodo3 period := period('01/02/2016');
*begin
*  console.log(args(
*    vperiodo.possui('11/01/2016'), -- N
*    vperiodo2.possui('11/01/2016'), -- S
*    vperiodo3.possui('11/01/2016') -- N
*  ));
*end;
*</code>
* %return char (S/N)
* %param data varchar2 
* %param formato varchar2 default 'DD/MM/RRRR HH24:MI:SS' 
* %param infinito char default 'N' 
* %param considerar_horario char default 'N' 
**/
  member function possui(data               varchar2
                        ,formato            varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                        ,infinito           char default 'N'
                        ,considerar_horario char default 'N') return char,
/** [function] Retorna no formato "args"<br>
*<code>
*  select * from table(prlist('12/01/2020-16/01/2020;21/01/2020').to_args()); -- <<table[varchar2]: 12/01/2020, 13/01/2020, 14/01/2020, 15/01/2020, 16/01/2020, 21/01/2020>>
*</code>
* %return novo objeto (args)
**/
  member function to_args(formato varchar2 default 'DD/MM/RRRR') return args,
/** [function] Retorna no formato "argsn"<br>
*<code>
*  select * from table(prlist('12/01/2020-16/01/2020;21/01/2020').to_argsn()); -- <<table[number]: 20200112000000, 20200113000000, 20200114000000, 20200115000000, 20200116000000, 20200121000000>>
*</code>
* %return novo objeto (argsn)
**/
  member function to_argsn(formato varchar2 default 'RRRRMMDD') return argsn,
/** [function] Retorna no formato "argsn"<br>
*<code>
*  select * from table(prlist('12/01/2020-16/01/2020;21/01/2020').to_argsd()); -- <<table[date]: 20200112000000, 20200113000000, 20200114000000, 20200115000000, 20200116000000, 20200121000000>>
*</code>
* %return novo objeto (argsd)
**/
  member function to_argsd return argsd,
/** [function] Retorna no formato "argspr"<br>
*<code>
*  select * from table(prlist('12/01/2020-16/01/2020;21/01/2020').to_args()); -- <<table[period]: 12/01/2020 a 16/01/2020, 21/01/2020>>
*</code>
* %return novo objeto (argspr)
**/
  member function to_argspr return argspr,
/** [function] Retorna no formato "argsprt"<br>
*<code>
*  select * from table(prlist('12/01/2020-16/01/2020;21/01/2020').to_argst()); -- <<table[datetime]: 12/01/2020, 13/01/2020, 14/01/2020, 15/01/2020, 16/01/2020, 21/01/2020>>
*</code>
* %return novo objeto (argsprt)
**/
  member function to_table return argspr,
/** [function] Retorna no formato "varchar2"<br>
*<code>
*declare
*  vlista prlist;
*begin
*  vlista := prlist('12/01/2020-16/01/2020;21/01/2020');
*  console.log(vlista.to_char()); -- '12/01/2020;13/01/2020;14/01/2020;15/01/2020;16/01/2020;21/01/2020'
*  console.log(vlista.to_char(separador=>' -> ')); -- '12/01/2020 -> 13/01/2020 -> 14/01/2020 -> 15/01/2020 -> 16/01/2020 -> 21/01/2020'
*  console.log(vlista.to_char(separador=>' -> ',formato=>'DD/MM')); -- '12/01 -> 13/01 -> 14/01 -> 15/01 -> 16/01 -> 21/01'
*end;
*</code>
* %return texto (varchar2)
**/
  member function to_char(formato   varchar2 default 'DD/MM/RRRR'
                         ,infinito  varchar2 default '<infinito>'
                         ,sep_per   varchar2 default ' a '
                         ,a_partir  varchar2 default 'A partir de '
                         ,ate       varchar2 default 'Até '
                         ,separador char default ';') return varchar2,
/** [function] Retorna no formato "clob"<br>
*<code>
*declare
*  vlista prlist;
*begin
*  vlista := prlist('12/01/2020-16/01/2020;21/01/2020');
*  console.log(vlista.to_char()); -- '12/01/2020;13/01/2020;14/01/2020;15/01/2020;16/01/2020;21/01/2020'
*  console.log(vlista.to_char(separador=>' -> ')); -- '12/01/2020 -> 13/01/2020 -> 14/01/2020 -> 15/01/2020 -> 16/01/2020 -> 21/01/2020'
*  console.log(vlista.to_char(separador=>' -> ',formato=>'DD/MM')); -- '12/01 -> 13/01 -> 14/01 -> 15/01 -> 16/01 -> 21/01'
*end;
*</code>
* %return texto (clob)
**/
  member function to_clob(formato   varchar2 default 'DD/MM/RRRR'
                         ,infinito  varchar2 default '<infinito>'
                         ,sep_per   varchar2 default ' a '
                         ,a_partir  varchar2 default 'A partir de '
                         ,ate       varchar2 default 'Até '
                         ,separador char default ';') return clob
)
/
create or replace type body prlist is

  -- Constructor
  constructor function prlist return self as result is
  begin
    self.list := argspr();
    return;
  end;

  constructor function prlist(valores   varchar2
                             ,separador char default ';'
                             ,intervalo char default '-'
                             ,formato   varchar2 default 'DD/MM/RRRR HH24:MI:SS') return self as result is
    vs char := separador;
    vi char := intervalo;
  begin
    self.list := argspr();
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
            -- verifica se é uma "data" ou um "período"
            declare
              vposi number := instr(valor, vi);
              vini  date;
              vfim  date;
            begin
              if vposi = 0 then
                -- é uma "data"
                vini := standard.to_date(valor, formato);
                vfim := vini;
              elsif instr(valor, vi, nth => 2) = 0 then
                -- é um "período"
                if vfim < vini then
                  raise_application_error(-20102,
                                          'O valor "inicial" de um intervalo de datas não deve ser maior do que o valor "final".' || chr(10) ||
                                           'Problema no intervalo: ' || valor || '.');
                end if;
                -- --
                vini := standard.to_date(substr(valor, 1, vposi - 1), formato);
                vfim := standard.to_date(substr(valor, vposi + 1, length(valor) - vposi + 1), formato);
              else
                raise_application_error(-20102,
                                        'O caractere de intervalo "' || vi || '" de datas deve aparecer apenas uma vez por período.' || chr(10) ||
                                         'Problema no intervalo: ' || valor || '.');
              end if;
              -- adiciona período
              self.list.extend;
              self.list(self.list.last) := period(vini, vfim);
            end;
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

  constructor function prlist(valores clob, separador char default ';', intervalo char default '-', formato varchar2 default 'DD/MM/RRRR HH24:MI:SS')
    return self as result is
    vs char := separador;
    vi char := intervalo;
  begin
    self.list := argspr();
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
            -- verifica se é uma "data" ou um "período"
            declare
              vposi number := instr(valor, vi);
              vini  date;
              vfim  date;
            begin
              if vposi = 0 then
                -- é uma "data"
                vini := standard.to_date(valor, formato);
                vfim := vini;
              elsif instr(valor, vi, nth => 2) = 0 then
                -- é um "período"
                if vfim < vini then
                  raise_application_error(-20102,
                                          'O valor "inicial" de um intervalo de datas não deve ser maior do que o valor "final".' || chr(10) ||
                                           'Problema no intervalo: ' || valor || '.');
                end if;
                -- --
                vini := standard.to_date(substr(valor, 1, vposi - 1), formato);
                vfim := standard.to_date(substr(valor, vposi + 1, length(valor) - vposi + 1), formato);
              else
                raise_application_error(-20102,
                                        'O caractere de intervalo "' || vi || '" de datas deve aparecer apenas uma vez por período.' || chr(10) ||
                                         'Problema no intervalo: ' || valor || '.');
              end if;
              -- adiciona período
              self.list.extend;
              self.list(self.list.last) := period(vini, vfim);
            end;
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

  constructor function prlist(valor period) return self as result is
  begin
    self.list := argspr();
    self.list.extend;
    self.list(self.list.last) := valor;
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
                               '") para instanciar o objeto prlist!' || chr(10) || 'Ex.: "22/05/2019-26/05/2019' || vs || '29/12/2020' || vs ||
                               '01/05/2020' || vi || '05/05/2020' || vs || '15/05/2020".');
    elsif regexp_instr(valores, '\' || vi || '[' || vd || '[:digit:]]+\' || vi) <> 0 then
      raise_application_error(-20102,
                              'O "' || vi || '" para instanciar o objeto prlist deve ser utilizado como indicação de intervalo!' || chr(10) ||
                               'Ex.: "01/08/2020' || vi || '11/08/2020".');
    elsif regexp_instr(formato, '[^' || vd || '[:digit:]' || vs || vi || ']') <> 0 then
      raise_application_error(-20103,
                              'Para o "formato", apenas é permitido incluir números e caracteres para identificação de data ("' || vd || '").');
    end if;
  end;

  member function adicionar(periodo period) return prlist is
    result prlist := self;
  begin
    result.adicionar(periodo);
    return result;
  end;

  member procedure adicionar(periodo period) is
  begin
    self.list.extend;
    self.list(self.list.last) := periodo;
  end;

  member function adicionar(data date) return prlist is
    result prlist := self;
  begin
    result.adicionar(data);
    return result;
  end;

  member procedure adicionar(data date) is
  begin
    self.list.extend;
    self.list(self.list.last) := period(data, data);
  end;

  member function adicionar(lista argspr) return prlist is
    result prlist := self;
  begin
    result.adicionar(lista);
    return result;
  end;

  member procedure adicionar(lista argspr) is
  begin
    if lista is not null and
       lista is not empty then
      for i in lista.first .. lista.last
      loop
        self.list.extend;
        self.list(self.list.last) := lista(i);
      end loop;
    end if;
  end;

  member function adicionar(lista prlist) return prlist is
    result prlist := self;
  begin
    result.adicionar(lista);
    return result;
  end;

  member procedure adicionar(lista prlist) is
  begin
    if lista.list is not null and
       lista.list is not empty then
      for i in lista.list.first .. lista.list.last
      loop
        self.list.extend;
        self.list(self.list.last) := lista.list(i);
      end loop;
    end if;
  end;

  member function remover(periodo period) return prlist is
    result   prlist := prlist();
    vperiodo period := periodo.nvl();
  begin
    if periodo.nulo like 'S' then
      return self;
    else
      if self.list.first is not null then
        for reg in self.list.first .. self.list.last
        loop
          if self.list.exists(reg) then
            if self.list(reg).inicio_nvl().data <> vperiodo.inicio.data or
               self.list(reg).fim_nvl().data <> vperiodo.fim.data then
              result.adicionar(self.list(reg));
            end if;
          end if;
        end loop;
      end if;
    end if;
    return result;
  end remover;

  member procedure remover(self in out nocopy prlist, periodo period) is
  begin
    self := remover(periodo);
  end remover;

  member function remover(data date) return prlist is
  begin
    return remover(data);
  end remover;

  member procedure remover(data date) is
  begin
    remover(period(data, data));
  end remover;

  member function remover(lista argspr) return prlist is
    result prlist := self;
  begin
    if lista is not null and
       lista is not empty then
      for i in lista.first .. lista.last
      loop
        if lista(i).nulo like 'N' then
          result := result.remover(lista(i));
        end if;
      end loop;
    end if;
    return result;
  end remover;

  member procedure remover(self in out nocopy prlist, lista argspr) is
  begin
    self := remover(lista);
  end remover;

  member function remover(lista prlist) return prlist is
  begin
    return remover(lista.list);
  end remover;

  member procedure remover(self in out nocopy prlist, lista prlist) is
  begin
    self := remover(lista);
  end remover;

  member function nulo return char is
  begin
    if self.list is null or
       self.list is empty then
      return 'S';
    else
      return 'N';
    end if;
  end;

  member function tamanho return number is
  begin
    return self.list.count;
  end;

  member function primeiro return period is
  begin
    if self.list.first is null then
      return null;
    else
      return self.list(self.list.first);
    end if;
  end;

  member function ultimo return period is
  begin
    if self.list.last is null then
      return null;
    else
      return self.list(self.list.last);
    end if;
  end;

  member function cruzamento(periodo period, infinito char default 'N', considerar_horario char default 'N') return char is
  begin
    if self.list is not null and
       self.list is not empty then
      for i in self.list.first .. self.list.last
      loop
        if self.list(i).cruzamento(periodo, infinito, considerar_horario) = 'S' then
          return 'S';
        end if;
      end loop;
    end if;
    return 'N';
  end cruzamento;

  member function cruzamento(inicio             datetime default datetime()
                            ,fim                datetime default datetime()
                            ,infinito           char default 'N'
                            ,considerar_horario char default 'N') return char is
  begin
    return cruzamento(period(inicio, fim), infinito, considerar_horario);
  end cruzamento;

  member function cruzamento(inicio date default null, fim date default null, infinito char default 'N', considerar_horario char default 'N')
    return char is
  begin
    return cruzamento(period(inicio, fim), infinito, considerar_horario);
  end cruzamento;

  member function cruzamento(inicio             varchar2 default null
                            ,fim                varchar2 default null
                            ,formato            varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                            ,infinito           char default 'N'
                            ,considerar_horario char default 'N') return char is
  begin
    return cruzamento(period(datetime(inicio, formato), datetime(fim, formato)), infinito, considerar_horario);
  end;

  member function cruzamento(list argspr, infinito char default 'N', considerar_horario char default 'N') return char is
  begin
    if list is not null and
       list is not empty then
      -- verifica periodo da lista
      for i in list.first .. list.last
      loop
        if cruzamento(list(i), infinito, considerar_horario) = 'S' then
          return 'S';
        end if;
      end loop;
      -- --
    end if;
    return 'N';
  end cruzamento;

  member function cruzamento(list prlist, infinito char default 'N', considerar_horario char default 'N') return char is
  begin
    return cruzamento(list.list, infinito, considerar_horario);
  end cruzamento;

  member function cruzamento(list argsd, infinito char default 'N', considerar_horario char default 'N') return char is
  begin
    if self.list is not null and
       self.list is not empty then
      for i in self.list.first .. self.list.last
      loop
        -- verifica LISTA
        if list is not null and
           list is not empty and
           (infinito like 'S' or (infinito like 'N' and (self.list(i).inicio.data is not null or self.list(i).fim.data is not null))) then
          declare
            vinicio date;
            vfim    date;
          begin
            if considerar_horario like 'N' then
              vinicio := self.list(i).inicio_nvl().trunc();
              vfim    := self.list(i).fim_nvl().trunc();
            else
              vinicio := self.list(i).inicio_nvl().data;
              vfim    := self.list(i).fim_nvl().data;
            end if;
            -- percorre LISTA
            for i in list.first .. list.last
            loop
              -- verifica se esta no periodo
              if list(i) between vinicio and vfim then
                return 'S';
              end if;
            end loop;
          end;
        end if;
        -- --
      end loop;
    end if;
    return 'N';
  end cruzamento;

  member function cruzamento(list argsdt, infinito char default 'N', considerar_horario char default 'N') return char is
  begin
    if self.list is not null and
       self.list is not empty then
      for i in self.list.first .. self.list.last
      loop
        -- verifica LISTA
        if list is not null and
           list is not empty and
           (infinito like 'S' or (infinito like 'N' and (self.list(i).inicio.data is not null or self.list(i).fim.data is not null))) then
          declare
            vinicio date;
            vfim    date;
          begin
            if considerar_horario like 'N' then
              vinicio := self.list(i).inicio_nvl().trunc();
              vfim    := self.list(i).fim_nvl().trunc();
            else
              vinicio := self.list(i).inicio_nvl().data;
              vfim    := self.list(i).fim_nvl().data;
            end if;
            -- percorre LISTA
            for i in list.first .. list.last
            loop
              -- verifica se esta no periodo
              if list(i).data between vinicio and vfim then
                return 'S';
              end if;
            end loop;
          end;
        end if;
        -- --
      end loop;
    end if;
    return 'N';
  end cruzamento;

  member function cruzamento(list datelist, infinito char default 'N', considerar_horario char default 'N') return char is
  begin
    return cruzamento(list.list, infinito, considerar_horario);
  end cruzamento;

  member function cruzamento_lista(list      varchar2
                                  ,formato   varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                                  ,separador varchar2 default ';'
                                  ,infinito  char default 'N') return char is
  begin
    if self.list is not null and
       self.list is not empty then
      for i in self.list.first .. self.list.last
      loop
        if self.list(i).cruzamento_lista(list, formato, separador, infinito) = 'S' then
          return 'S';
        end if;
      end loop;
    end if;
    return 'N';
  end cruzamento_lista;

  member function possui(periodo period, infinito char default 'N', considerar_horario char default 'N') return char is
    vperiodo_ent period;
  begin
    if self.list is not null and
       self.list is not empty then
      -- verifica parametros do periodo
      if considerar_horario like 'N' then
        vperiodo_ent := periodo.trunc().nvl();
      else
        vperiodo_ent := periodo.nvl();
      end if;
      -- --
      if infinito like 'S' or
         (infinito like 'N' and periodo.nulo like 'N') then
        for i in self.list.first .. self.list.last
        loop
          declare
            vperiodo period;
          begin
            if considerar_horario like 'N' then
              vperiodo := self.list(i).trunc().nvl();
            else
              vperiodo := self.list(i).nvl();
            end if;
            -- verifica possui
            if (infinito like 'S' or (infinito like 'N' and self.list(i).nulo like 'N')) and
               vperiodo_ent.inicio.data = vperiodo.inicio.data and
               vperiodo_ent.fim.data = vperiodo.fim.data then
              return 'S';
            end if;
          end;
        end loop;
      end if;
      -- --
    end if;
    return 'N';
  end possui;

  member function possui(list prlist, infinito char default 'N', considerar_horario char default 'N') return char is
  begin
    if list.list is not null and
       list.list is not empty then
      -- verifica periodo da lista
      for i in list.list.first .. list.list.last
      loop
        if possui(list.list(i), infinito, considerar_horario) = 'N' then
          return 'N';
        end if;
      end loop;
      -- --
    end if;
    return 'S';
  end possui;

  member function possui(data datetime, infinito char default 'N', considerar_horario char default 'N') return char is
  begin
    if self.list is not null and
       self.list is not empty then
      for i in self.list.first .. self.list.last
      loop
        if self.list(i).possui(data, infinito, considerar_horario) = 'S' then
          return 'S';
        end if;
      end loop;
    end if;
    return 'N';
  end possui;

  member function possui(data date, infinito char default 'N', considerar_horario char default 'N') return char is
  begin
    return possui(datetime(data), infinito, considerar_horario);
  end possui;

  member function possui(data               varchar2
                        ,formato            varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                        ,infinito           char default 'N'
                        ,considerar_horario char default 'N') return char is
  begin
    return possui(datetime(data, formato), infinito, considerar_horario);
  end possui;

  member function to_args(formato varchar2 default 'DD/MM/RRRR') return args is
    result dlist := dlist();
  begin
    if self.list is not null and
       self.list is not empty then
      for i in self.list.first .. self.list.last
      loop
        result.adicionar(self.list(i).to_table());
      end loop;
    end if;
    return result.to_args(formato);
  end;

  member function to_argsn(formato varchar2 default 'RRRRMMDD') return argsn is
    result dlist := dlist();
  begin
    if self.list is not null and
       self.list is not empty then
      for i in self.list.first .. self.list.last
      loop
        result.adicionar(self.list(i).to_table());
      end loop;
    end if;
    return result.to_argsn(formato);
  end;

  member function to_argsd return argsd is
    result dlist := dlist();
  begin
    if self.list is not null and
       self.list is not empty then
      for i in self.list.first .. self.list.last
      loop
        result.adicionar(self.list(i).to_table());
      end loop;
    end if;
    return result.list;
  end;

  member function to_argspr return argspr is
  begin
    return self.list;
  end;

  member function to_table return argspr is
  begin
    return self.list;
  end;

  member function to_char(formato   varchar2 default 'DD/MM/RRRR'
                         ,infinito  varchar2 default '<infinito>'
                         ,sep_per   varchar2 default ' a '
                         ,a_partir  varchar2 default 'A partir de '
                         ,ate       varchar2 default 'Até '
                         ,separador char default ';') return varchar2 is
    result varchar2(32767);
  begin
    if self.list is not null and
       self.list is not empty then
      for i in self.list.first .. self.list.last
      loop
        result := result || self.list(i).to_char(formato, infinito, sep_per, a_partir, ate) || separador;
      end loop;
      -- remove ultimo
      result := rtrim(result, separador);
    end if;
    return result;
  end;

  member function to_clob(formato   varchar2 default 'DD/MM/RRRR'
                         ,infinito  varchar2 default '<infinito>'
                         ,sep_per   varchar2 default ' a '
                         ,a_partir  varchar2 default 'A partir de '
                         ,ate       varchar2 default 'Até '
                         ,separador char default ';') return clob is
    result clob;
  begin
    if self.list is not null and
       self.list is not empty then
      for i in self.list.first .. self.list.last
      loop
        result := result || self.list(i).to_char(formato, infinito, sep_per, a_partir, ate) || separador;
      end loop;
      -- remove ultimo
      result := rtrim(result, separador);
    end if;
    return result;
  end;

end;
/
