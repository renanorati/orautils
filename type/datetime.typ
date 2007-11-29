create or replace type datetime force as object
(
-- Attributes
  data date,

-- Constructor
/** [constructor] Construir o objeto informando data (varchar2)<br>
*<code>
*declare
*  dt1 datetime := datetime('13/03/2017');
*  dt2 datetime := datetime('12/2019','MM/RRRR');
*  dt3 datetime := datetime('2018-12-10T10:25:42Z','ISO8601'); -- padrão ISO8601
*begin
*  console.log(args(
*    dt1.to_char(), -- 13/03/2017
*    dt2.to_char(), -- 01/12/2019
*    dt3.data_completa() -- 10/12/2018 07:25:42
*  )); 
*end;
*</code>
* %param data (varchar2)
* %return novo objeto (datetime)
**/
  constructor function datetime(data    varchar2
                               ,formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') return self as result,
  constructor function datetime(data    number
                               ,formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') return self as result,

/** [constructor] Construir o objeto com partes da data, o restante será preenchido com sysdate truncado (pode ser informado dia, mes, ano, hora, minuto, segundo)<br>
*<code>
*declare
*  dt datetime := datetime(dia=>13,ano=>2021); -- considerando sysdate = 31/12/2016
*begin
*  console.log(
*    dt.to_char() -- '13/12/2021'
*  );
*end;
*</code>
* %param ano Informar novo ano
* %param mes Informar novo mes
* %param dia Informar novo dia
* %param hora Informar nova hora
* %param minuto Informar novo minuto
* %param segundo Informar novo segundo
**/
  constructor function datetime(ano     number default null
                               ,mes     number default null
                               ,dia     number default null
                               ,hora    number default null
                               ,minuto  number default null
                               ,segundo number default null) return self as result,
/** [function] Altera a data, passando um date e retornando um novo objeto
* %param data nova data (date)
* %return novo objeto (datetime)
**/
  member function alterar(data date default null) return datetime,
/** [function] Altera a data, passando um varchar2 e retornando um novo objeto
* %param data nova data (varchar2)
* %param formato da data (default 'DD/MM/RRRR HH24:MI:SS')
* %return novo objeto (datetime)
**/
  member function alterar(data    varchar2
                         ,formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') return datetime,
/** [function] Altera parte da data retornando um novo objeto (pode ser alterado dia, mes, ano, hora, minuto, segundo)<br>
*<code>
*declare
*  dt datetime := datetime('17/07/2017');
*begin
*  console.log(args(
*    dt.alterar(mes=>9).to_char()            -- '17/09/2017'
*    dt.alterar(dia=>12,ano=>2020).to_char() -- '12/07/2020'
*  ));
*end;
*</code>
* %param ano Informar novo ano
* %param mes Informar novo mes
* %param dia Informar novo dia
* %param hora Informar nova hora
* %param minuto Informar novo minuto
* %param segundo Informar novo segundo
* %return novo objeto (datetime)
**/
  member function alterar(ano     number default null
                         ,mes     number default null
                         ,dia     number default null
                         ,hora    number default null
                         ,minuto  number default null
                         ,segundo number default null) return datetime,
-- Member functions and procedures
/** [procedure] Informar nova data no objeto passando um date
* %param data nova data (date)
**/
  member procedure atribuir(self in out nocopy datetime
                           ,data date default null),
/** [procedure] Informar nova data no objeto passando um varchar2
* %param data nova data (varchar2)
* %param formato da nova data (default 'DD/MM/RRRR HH24:MI:SS')
**/
  member procedure atribuir(self    in out nocopy datetime
                           ,data    varchar2
                           ,formato varchar2 default 'DD/MM/RRRR HH24:MI:SS'),
/** [procedure] Informar novas partes do objeto (pode ser informado dia, mes, ano, hora, minuto, segundo)<br>
*<code>
*declare
*  dt datetime := datetime('17/07/2017');
*begin
*  dt.atribuir(mes=>9);            -- nova data '17/09/2017'
*  dt.atribuir(dia=>12,ano=>2020); -- nova data '12/09/2020'
*end;
*</code>
* %param ano Informar novo ano
* %param mes Informar novo mes
* %param dia Informar novo dia
* %param hora Informar nova hora
* %param minuto Informar novo minuto
* %param segundo Informar novo segundo
**/
  member procedure atribuir(self    in out nocopy datetime
                           ,ano     number default null
                           ,mes     number default null
                           ,dia     number default null
                           ,hora    number default null
                           ,minuto  number default null
                           ,segundo number default null),
/** [function] Retorna novo objeto com data NULL ou data modificada de acordo com os parâmetros informados<br>
*<code>
*declare
*  dt datetime := datetime('17/07/2017 23:56:13'); -- considerando sysdate = 17/07/2015
*begin
*  console.log(args(
*    dt.limpar().to_char(), -- NULL
*    dt.limpar(ano=>'S').to_char(), -- 17/07/2015
*    dt.limpar(ano=>'S',horario='S').data_completa() -- 17/07/2015 00:00:00
*  ));
*end;
*</code>
* %param ano Se informado com "S" seta o ano de sysdate
* %param mes Se informado com "S" seta o mes de sysdate
* %param dia Se informado com "S" seta o dia de sysdate
* %param hora Se informado com "S" seta 00
* %param minuto Se informado com "S" seta 00
* %param segundo Se informado com "S" seta 00
* %return novo objeto (datetime)
**/
  member function limpar(ano     char default 'N'
                        ,mes     char default 'N'
                        ,dia     char default 'N'
                        ,hora    char default 'N'
                        ,minuto  char default 'N'
                        ,segundo char default 'N'
                        ,horario char default 'N') return datetime,
/** [procedure] Seta NULL na data do objeto ou modifica a data de acordo com os parâmetros informados<br>
*<code>
*declare
*  dt datetime := datetime('17/07/2017 23:56:13'); -- considerando sysdate = 17/07/2015
*begin
*  dt.limpar(); -- NULL
*  dt.limpar(ano=>'S'); -- 17/07/2015
*  dt.limpar(ano=>'S',horario='S'); -- 17/07/2015 00:00:00
*end;
*</code>
*</code>
* %param ano Se informado com "S" seta o ano de sysdate
* %param mes Se informado com "S" seta o mes de sysdate
* %param dia Se informado com "S" seta o dia de sysdate
* %param hora Se informado com "S" seta 00
* %param minuto Se informado com "S" seta 00
* %param segundo Se informado com "S" seta 00
**/
  member procedure limpar(self    in out nocopy datetime
                         ,ano     boolean default false
                         ,mes     boolean default false
                         ,dia     boolean default false
                         ,hora    boolean default false
                         ,minuto  boolean default false
                         ,segundo boolean default false
                         ,horario boolean default false),
/** [function] Retorna novo objeto com horario zerado<br>
*<code>
*declare
*  dt datetime := datetime(sysdate); -- considerando sysdate = 10/12/2018 10:25:42
*begin
*  console.log(
*    dt.limpar_horario().to_char() -- 10/12/2018 00:00:00
*  );
*end;
*</code>
* %return novo objeto (datetime)
**/
  member function limpar_horario return datetime,
/** [procedure] Zera o horário do objeto<br>
*<code>
*declare
*  dt datetime := datetime(sysdate); -- considerando sysdate = 10/12/2018 10:25:42
*begin
*  dt.limpar_horario(); -- 10/12/2018 00:00:00
*end;
*</code>
**/
  member procedure limpar_horario,
/** [function] Adiciona dias, meses, anos, horas minutos e/ou segundos na data<br>
*<code>
*declare
*  dt datetime := datetime('17/07/2017');
*begin
*  console.log(
*    dt.adicionar(dias=>3,anos=>4).to_char() -- '20/07/2021'
*  );
*end;
*</code>
* %param anos Quantidade de anos (number)
* %param meses Quantidade de meses (number)
* %param dias Quantidade de dias (number)
* %param horas Quantidade de horas (number)
* %param minutos Quantidade de minutos (number)
* %param segundos Quantidade de segundos (number)
* %return novo objeto (datetime)
**/
  member function adicionar(anos     number default null
                           ,meses    number default null
                           ,dias     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null) return datetime,
/** [procedure] Adiciona dias, meses, anos, horas minutos e/ou segundos na data<br>
*<code>
*declare
*  dt datetime := datetime('17/07/2017');
*begin
*  dt.adicionar(dias=>3,anos=>4); -- '20/07/2021'
*end;
*</code>
* %param anos Quantidade de anos (number)
* %param meses Quantidade de meses (number)
* %param dias Quantidade de dias (number)
* %param horas Quantidade de horas (number)
* %param minutos Quantidade de minutos (number)
* %param segundos Quantidade de segundos (number)
**/
  member procedure adicionar(self     in out nocopy datetime
                            ,anos     number default null
                            ,meses    number default null
                            ,dias     number default null
                            ,horas    number default null
                            ,minutos  number default null
                            ,segundos number default null),
/** [function] Adiciona dias úteis na data<br>
*É possível informar a lista de feriádos a serem considerados, ou por padrão serão consultados na tabela vw_calendario.<br>
*<code>
*declare
*  dt datetime := datetime('06/09/2016');
*begin
*  console.log(
*    dt.adicionar(dias_uteis=>3).to_char() -- '12/09/2016' -- (dias não contados: 07, 10 e 11/09/2016)
*  );
*end;
*</code>
* %param dias_uteis Quantidade de dias (number)
* %param list_feriados lista de feriados (argsd)
* %return novo objeto (datetime)
**/
  member function adicionar(dias_uteis    number
                           ,list_feriados argsd default argsd()) return datetime,
/** [function] Adiciona dias úteis na data passando lista de feriádos em varchar2<br>
*<code>
*declare
*  dt datetime := datetime('06/09/2016');
*  feriados_nacionais varchar2(500):= '01/01/2016;21/04/2016;01/05/2016;07/09/2016;12/10/2016;02/11/2016;15/11/2016;25/12/2016';
*begin
*  console.log(
*    dt.adicionar(dias_uteis=>3,feriados_nacionais).to_char() -- '12/09/2016' -- (dias não contados: 07, 10 e 11/09/2016)
*  );
*end;
*</code>
* %param dias_uteis Quantidade de dias (number)
* %param list_feriados lista de datas (varchar2)
* %param formato da data (default 'DD/MM/RRRR HH24:MI:SS')
* %param separador caractere que separa as datas (por padrão ';')
* %return novo objeto (datetime)
**/
  member function adicionar(dias_uteis    number
                           ,list_feriados varchar2
                           ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                           ,separador     char default ';') return datetime,
/** [procedure] Adiciona dias úteis na data<br>
*É possível informar a lista de feriádos a serem considerados, ou por padrão serão consultados na tabela vw_calendario.<br>
*<code>
*declare
*  dt datetime := datetime('06/09/2016');
*begin
*  dt.adicionar(dias_uteis=>3); -- '12/09/2016' -- (dias não contados: 07, 10 e 11/09/2016)
*end;
*</code>
* %param dias_uteis Quantidade de dias (number)
**/
  member procedure adicionar(self          in out nocopy datetime
                            ,dias_uteis    number
                            ,list_feriados argsd default argsd()),
/** [function] Adiciona dias úteis na data passando lista de feriádos em varchar2<br>
*<code>
*declare
*  dt datetime := datetime('06/09/2016');
*  feriados_nacionais varchar2(500):= '01/01/2016;21/04/2016;01/05/2016;07/09/2016;12/10/2016;02/11/2016;15/11/2016;25/12/2016';
*begin
*  dt.adicionar(dias_uteis=>3,feriados_nacionais); -- '12/09/2016' -- (dias não contados: 07, 10 e 11/09/2016)
*end;
*</code>
* %param dias_uteis Quantidade de dias (number)
* %param list_feriados lista de datas (varchar2)
* %param formato da data (default 'DD/MM/RRRR HH24:MI:SS')
* %param separador caractere que separa as datas (por padrão ';')
**/
  member procedure adicionar(self          in out nocopy datetime
                            ,dias_uteis    number
                            ,list_feriados varchar2
                            ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                            ,separador     char default ';'),
/** [function] Subtrai dias, meses, anos, horas minutos e/ou segundos na data<br>
*<code>
*declare
*  dt datetime := datetime('17/07/2017');
*begin
*  console.log(args(
*
*    dt.subtrair(dias=>3,anos=>4).to_char(), -- '14/07/2013'
*
*    -- métodos encadeados
*    dt.subtrair(anos=>3)
*      .adicionar(meses=>2)
*      .alterar(dia=>21).to_char() -- '21/09/2014'
*
*  ));
*end;
*</code>
* %param anos Quantidade de anos (number)
* %param meses Quantidade de meses (number)
* %param dias Quantidade de dias (number)
* %param horas Quantidade de horas (number)
* %param minutos Quantidade de minutos (number)
* %param segundos Quantidade de segundos (number)
* %return novo objeto (datetime)
**/
  member function subtrair(anos     number default null
                          ,meses    number default null
                          ,dias     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null) return datetime,
/** [procedure] Subtrai dias, meses, anos, horas minutos e/ou segundos na data<br>
*<code>
*declare
*  dt datetime := datetime('17/07/2017');
*begin
*  dt.subtrair(dias=>3,anos=>4); -- '14/07/2013'
*end;
*</code>
* %param anos Quantidade de anos (number)
* %param meses Quantidade de meses (number)
* %param dias Quantidade de dias (number)
* %param horas Quantidade de horas (number)
* %param minutos Quantidade de minutos (number)
* %param segundos Quantidade de segundos (number)
**/
  member procedure subtrair(self     in out nocopy datetime
                           ,anos     number default null
                           ,meses    number default null
                           ,dias     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null),
/** [function] Subtrai dias úteis na data<br>
*É possível informar a lista de feriádos a serem considerados, ou por padrão serão consultados na tabela vw_calendario.<br>
*<code>
*declare
*  dt datetime := datetime('12/09/2016');
*begin
*  console.log(
*    dt.subtrair(dias_uteis=>3).to_char() -- '06/09/2016' -- (dias não contados: 07, 10 e 11/09/2016)
*  );
*end;
*</code>
* %param dias_uteis Quantidade de dias (number)
* %param list_feriados lista de feriados (argsd)
* %return novo objeto (datetime)
**/
  member function subtrair(dias_uteis    number
                          ,list_feriados argsd default argsd()) return datetime,
/** [function] Subtrai dias úteis na data passando lista de feriádos em varchar2<br>
*<code>
*declare
*  dt datetime := datetime('12/09/2016');
*  feriados_nacionais varchar2(500):= '01/01/2016;21/04/2016;01/05/2016;07/09/2016;12/10/2016;02/11/2016;15/11/2016;25/12/2016';
*begin
*  console.log(
*    dt.subtrair(dias_uteis=>3,feriados_nacionais).to_char() -- '06/09/2016' -- (dias não contados: 07, 10 e 11/09/2016)
*  );
*end;
*</code>
* %param dias_uteis Quantidade de dias (number)
* %param list_feriados lista de datas (varchar2)
* %param formato da data (default 'DD/MM/RRRR HH24:MI:SS')
* %param separador caractere que separa as datas (por padrão ';')
* %return novo objeto (datetime)
**/
  member function subtrair(dias_uteis    number
                          ,list_feriados varchar2
                          ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                          ,separador     char default ';') return datetime,
/** [procedure] Subtrai dias úteis na data<br>
*É possível informar a lista de feriádos a serem considerados, ou por padrão serão consultados na tabela vw_calendario.<br>
*<code>
*declare
*  dt datetime := datetime('12/09/2016');
*begin
*  dt.subtrair(dias_uteis=>3); -- '06/09/2016' -- (dias não contados: 07, 10 e 11/09/2016)
*end;
*</code>
* %param dias_uteis Quantidade de dias (number)
**/
  member procedure subtrair(self          in out nocopy datetime
                           ,dias_uteis    number
                           ,list_feriados argsd default argsd()),
/** [function] Subtrai dias úteis na data passando lista de feriádos em varchar2<br>
*<code>
*declare
*  dt datetime := datetime('12/09/2016');
*  feriados_nacionais varchar2(500):= '01/01/2016;21/04/2016;01/05/2016;07/09/2016;12/10/2016;02/11/2016;15/11/2016;25/12/2016';
*begin
*  dt.subtrair(dias_uteis=>3,feriados_nacionais); -- '06/09/2016' -- (dias não contados: 07, 10 e 11/09/2016)
*end;
*</code>
* %param dias_uteis Quantidade de dias (number)
* %param list_feriados lista de datas (varchar2)
* %param formato da data (default 'DD/MM/RRRR HH24:MI:SS')
* %param separador caractere que separa as datas (por padrão ';')
**/
  member procedure subtrair(self          in out nocopy datetime
                           ,dias_uteis    number
                           ,list_feriados varchar2
                           ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                           ,separador     char default ';'),
/** [function] Retorna um novo objeto com a data do último dia do mês/ano atual<br>
*<code>
*declare
*  dt datetime := datetime('17/07/2017');
*begin
*  console.log(args(
*
*    dt.ultimo().to_char(), -- '31/07/2017'
*
*    -- métodos encadeados
*    dt.adicionar(meses=>4).ultimo().to_char(), -- '30/11/2017'
*    dt.adicionar(meses=>4).ultimo().dia(), -- 30
*    dt.ultimo().dia() -- 31
*
*  ));
*end;
*</code>
* %return novo objeto (datetime)
**/
  member function ultimo return datetime,
/** [function] Retorna o "dia"<br>
*<code>
*declare
*  dt datetime := datetime('17/08/2017');
*begin
*  console.log(args(
*
*    dt.dia(), -- 17
*
*    -- métodos encadeados
*    dt.adicionar(dias=>20).dia(), -- 06
*    dt.adicionar(meses=>1,dias=>20).dia() -- 07
*
*  ));
*end;
*</code>
* %return dia (char)
**/
  member function dia return char,
/** [function] Retorna o "mes"<br>
*<code>
*declare
*  dt datetime := datetime('17/08/2017');
*begin
*  console.log(args(
*
*    dt.mes(), -- 08
*
*    -- métodos encadeados
*    dt.adicionar(meses=>5).mes() -- 01
*
*  ));
*end;
*</code>
* %return mes (char)
**/
  member function mes return char,
/** [function] Retorna o "ano"<br>
*<code>
*declare
*  dt datetime := datetime('17/08/2017');
*begin
*  console.log(args(
*
*    dt.ano(), -- 2017
*
*    -- métodos encadeados
*    dt.adicionar(meses=>5).ano() -- 2018
*
*  ));
*end;
*</code>
* %return ano (char)
**/
  member function ano return char,
/** [function] Retorna a "hora"<br>
*<code>
*declare
*  dt datetime := datetime('13/12/2017 15:35:22');
*begin
*  console.log(args(
*
*    dt.hora(), -- 15
*
*    -- métodos encadeados
*    dt.adicionar(minutos=>30).hora() -- 16
*
*  ));
*end;
*</code>
* %return hora (char)
**/
  member function hora return char,
/** [function] Retorna o "minuto"<br>
*<code>
*declare
*  dt datetime := datetime('13/12/2017 15:35:22');
*begin
*  console.log(args(
*
*    dt.minuto(), -- 35
*
*    -- métodos encadeados
*    dt.adicionar(minutos=>30).minuto() -- 05
*
*  ));
*end;
*</code>
* %return minuto (char)
**/
  member function minuto return char,
/** [function] Retorna o "segundo"<br>
*<code>
*declare
*  dt datetime := datetime('13/12/2017 15:35:22');
*begin
*  console.log(args(
*
*    dt.segundo(), -- 22
*
*    -- métodos encadeados
*    dt.adicionar(segundos=>42).segundo() -- 04
*
*  ));
*end;
*</code>
* %return segundo (char)
**/
  member function segundo return char,
/** [function] Retorna "ano" e "mes" no formato AAAAMM<br>
*<code>
*declare
*  dt datetime := datetime('17/08/2017');
*begin
*  console.log(args(
*
*    dt.anomes(), -- 201708
*
*    -- métodos encadeados
*    dt.adicionar(meses=>5).anomes() -- 201801
*
*  ));
*end;
*</code>
* %return ano e mes (char)
**/
  member function anomes return char,
/** [function] Retorna "mes" e "dia" no formato MMDD<br>
*<code>
*declare
*  dt datetime := datetime('17/08/2017');
*begin
*  console.log(
*    dt.mesdia() -- 0817
*  );
*end;
*</code>
* %return mes e dia (char)
**/
  member function mesdia return char,
/** [function] Retorna "hora" e "minuto" no formato HH24MI<br>
*<code>
*declare
*  dt datetime := datetime(sysdate); -- considerando sysdate = 10/12/2018 10:25:42
*begin
*  console.log(
*    dt.horaminuto() -- 1025
*  );
*end;
*</code>
* %return "hora" e "minuto" (char)
**/
  member function horaminuto return char,
/** [function] Retorna "horario" no formato HH24:MI:SS<br>
*<code>
*declare
*  dt datetime := datetime(sysdate); -- considerando sysdate = 10/12/2018 10:25:42
*begin
*  console.log(
*    dt.horario() -- 10:25:42
*  );
*end;
*</code>
* %return horario (char)
**/
  member function horario return char,
/** [function] Retorna "horario" no formato HH24MISS<br>
*<code>
*declare
*  dt datetime := datetime(sysdate); -- considerando sysdate = 10/12/2018 10:25:42
*begin
*  console.log(
*    dt.horario_num() -- 102542
*  );
*end;
*</code>
* %return horario (number)
**/
  member function horario_num return number,
/** [function] Retorna "data completa" no formato DD/MM/RRRR HH24:MI:SS<br>
*<code>
*declare
*  dt datetime := datetime(sysdate); -- considerando sysdate = 10/12/2018 10:25:42
*begin
*  console.log(
*    dt.data_completa() -- 10/12/2018 10:25:42
*  );
*end;
*</code>
* %return "data completa" (varchar2)
**/
  member function data_completa return varchar2,
/** [function] Retorna "data completa" no formato RRRRMMDDHH24MISS<br>
*<code>
*declare
*  dt datetime := datetime(sysdate); -- considerando sysdate = 10/12/2018 10:25:42
*begin
*  console.log(
*    dt.data_completa_num() -- 20181210102542
*  );
*end;
*</code>
* %return "data completa" (number)
**/
  member function data_completa_num return number,
/** [function] Retorna "data completa" no formato ISO8601<br>
*<code>
*declare
*  dt datetime := datetime(sysdate); -- considerando sysdate = 10/12/2018 10:25:42 (GMT-3)
*begin
*  console.log(
*    dt.iso8601() -- 2018-12-10T10:25:42-03:00
*  );
*end;
*</code>
* %return "data em iso8601" (varchar2)
**/
  member function iso8601 return varchar2,
/** [function] Retorna o dia da semana (1-7)<br>
*<code>
*declare
*  dt datetime := datetime('17/08/2017');
*begin
*  console.log(args(
*
*    dt.ds(), -- 5
*
*    -- métodos encadeados
*    dt.adicionar(meses=>5).ds() -- 4
*
*  ));
*end;
*</code>
* %return dia da semana (number)
**/
  member function ds return number,
/** [function] Retorna se é um dia de fim de semana (S/N)<br>
*<code>
*declare
*  dt datetime := datetime('19/08/2017');
*begin
*  console.log(args(
*
*    dt.fds(), -- "S"
*
*    -- métodos encadeados
*    dt.adicionar(meses=>5).fds() -- "N"
*
*  ));
*end;
*</code>
* %return fim de semana (S/N)
**/
  member function fds return char,
/** [function] Retorna se é um feriado (S/N).<br>
*É possível informar a lista de feriádos a serem considerados, ou por padrão serão consultados na tabela vw_calendario.<br>
*<code>
*declare
*  dt datetime := datetime('07/09/2016');
*  dt2 datetime := datetime('08/09/2016');
*  dt3 datetime := datetime('10/09/2016'); -- sábado
*begin
*  console.log(args(
*    dt.feriado(), -- "S"
*    dt2.feriado(), -- "N"
*    dt3.feriado() -- "N"
*  ));
*end;
*</code>
* %param list_feriados lista de feriados (argsd)
* %return feriado (S/N)
**/
  member function feriado(list_feriados argsd default argsd()) return char,
/** [function] Retorna se é um dia útil (S/N).<br>
*É possível informar a lista de feriádos a serem considerados, ou por padrão serão consultados na tabela vw_calendario.<br>
*<code>
*declare
*  dt datetime := datetime('07/09/2016');
*  dt2 datetime := datetime('08/09/2016');
*  dt3 datetime := datetime('10/09/2016'); -- sábado
*begin
*  console.log(args(
*    dt.dia_util(), -- "N"
*    dt2.dia_util(), -- "S"
*    dt3.dia_util() -- "N"
*  ));
*end;
*</code>
* %param list_feriados lista de feriados (argsd)
* %return dia útil (S/N)
**/
  member function dia_util(list_feriados argsd default argsd()) return char,
/** [function] Retorna se é um ano bissexto (S/N)<br>
*<code>
*declare
*  dt datetime := datetime(sysdate); -- considerando sysdate = 13/09/2016
*begin
*  console.log(args(
*
*    dt.bissexto(), -- "S"
*
*    -- métodos encadeados
*    dt.adicionar(meses=>5).bissexto(), -- "N"
*
*    -- construindo objeto apenas com ano
*    datetime(ano=>2012).bissexto() -- "S"
*
*  ));
*end;
*</code>
* %return ano bissexto (S/N)
**/
  member function bissexto return char,
/** [function] Retorna se a data atual é nula (S/N)<br>
*<code>
*declare
*  dt datetime := datetime();
*begin
*  console.log(args(
*
*    dt.nulo(), -- "S"
*
*    -- métodos encadeados
*    dt.alterar(dia=>10).nulo() -- "N"
*
*  ));
*end;
*</code>
* %return data atual é nula (S/N)
**/
  member function nulo return char,
/** [function] Retorna se a data atual não é nula (S/N)<br>
*<code>
*declare
*  dt datetime := datetime();
*begin
*  console.log(args(
*
*    dt.nulo(), -- "N"
*
*    -- métodos encadeados
*    dt.alterar(dia=>10).nulo() -- "S"
*
*  ));
*end;
*</code>
* %return data atual não é nula (S/N)
**/
  member function nao_nulo return char,
/** [function] Retorna um novo objeto com uma nova data caso a data atual seja nula, passando um datetime<br>
*<code>
*declare -- considerando sysdate = 11/05/2018
*  dt datetime := datetime('15/05/2019');
*  dt2 datetime := datetime();
*begin
*  console.log(args(
*
*    dt.se_nulo(datetime(dia=>18)).to_char(), -- 15/05/2019
*
*    -- métodos encadeados
*    dt2.se_nulo(dt).subtrair(anos=>2).to_char() -- 15/05/2017
*
*  ));
*end;
*</code>
* %param data nova data (datetime)
* %return novo objeto (datetime)
**/
  member function se_nulo(data datetime) return datetime,
/** [function] Retorna um novo objeto com uma nova data caso a data atual seja nula, passando um date<br>
*<code>
*declare -- considerando sysdate = 11/05/2018
*  dt datetime := datetime('15/05/2019');
*  dt2 datetime := datetime();
*begin
*  console.log(args(
*
*    dt.se_nulo(sysdate).to_char(), -- 15/05/2019
*
*    -- métodos encadeados
*    dt2.se_nulo(sysdate).subtrair(anos=>2).to_char() -- 11/05/2016
*
*  ));
*end;
*</code>
* %param data nova data (date)
* %return novo objeto (datetime)
**/
  member function se_nulo(data date) return datetime,
/** [function] Retorna um novo objeto com uma nova data caso a data atual seja nula, passando um varchar2<br>
*<code>
*declare
*  dt datetime := datetime('15/05/2019');
*  dt2 datetime := datetime();
*begin
*  console.log(args(
*
*    dt.se_nulo('10/10/2019').to_char(), -- 15/05/2019
*
*    -- métodos encadeados
*    dt2.se_nulo('10/10/2019').subtrair(anos=>2).to_char() -- 10/10/2017
*
*  ));
*end;
*</code>
* %param data nova data (varchar2)
* %param formato da data (default 'DD/MM/RRRR HH24:MI:SS')
* %return novo objeto (datetime)
**/
  member function se_nulo(data    varchar2
                         ,formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') return datetime,
/** [procedure] Atribui uma nova data caso a data atual seja nula, passando um datetime<br>
*<code>
*declare -- considerando sysdate = 11/05/2018
*  dt datetime := datetime();
*  dt2 datetime := datetime();
*begin
*  dt.se_nulo(datetime(dia=>18)); -- 18/05/2018
*  -- métodos encadeados
*  dt2.se_nulo(dt).subtrair(anos=>2); -- 18/05/2016
*end;
*</code>
* %param data nova data (datetime)
**/
  member procedure se_nulo(self in out nocopy datetime
                          ,data datetime),
/** [procedure] Atribui uma nova data caso a data atual seja nula, passando um date<br>
*<code>
*declare -- considerando sysdate = 11/05/2018
*  dt datetime := datetime('15/05/2019');
*  dt2 datetime := datetime();
*begin
*    dt.se_nulo(sysdate); -- 15/05/2019
*    -- métodos encadeados
*    dt2.se_nulo(sysdate).subtrair(anos=>2); -- 11/05/2016
*end;
*</code>
* %param data nova data (date)
**/
  member procedure se_nulo(self in out nocopy datetime
                          ,data date),
/** [procedure] Atribui uma nova data caso a data atual seja nula, passando um varchar2<br>
*<code>
*declare
*  dt datetime := datetime('15/05/2019');
*  dt2 datetime := datetime();
*begin
*  dt.se_nulo('10/10/2019'); -- 15/05/2019
*  -- métodos encadeados
*  dt2.se_nulo('10/10/2019').subtrair(anos=>2); -- 10/10/2017
*end;
*</code>
* %param data nova data (varchar2)
* %param formato da data (default 'DD/MM/RRRR HH24:MI:SS')
**/
  member procedure se_nulo(data    varchar2
                          ,formato varchar2 default 'DD/MM/RRRR HH24:MI:SS'),
/** [function] Retorna um novo objeto com a primeira data possível caso a data atual seja nula<br>
*<code>
*declare
*  dt datetime := datetime();
*begin
*  console.log(
*    dt.inicial_se_nulo.to_char() -- 01/01/0001
*  );
*end;
*</code>
* %return novo objeto (datetime)
**/
  member function inicial_se_nulo return datetime,
/** [procedure] Atribui a primeira data possível caso a data atual seja nula<br>
*<code>
*declare
*  dt datetime := datetime();
*begin
*  dt.inicial_se_nulo; -- 01/01/0001
*end;
*</code>
**/
  member procedure inicial_se_nulo,
/** [function] Retorna um novo objeto com a última data possível caso a data atual seja nula<br>
*<code>
*declare
*  dt datetime := datetime();
*begin
*  console.log(
*    dt.final_se_nulo.to_char() -- 31/12/9999
*  );
*end;
*</code>
* %return novo objeto (datetime)
**/
  member function final_se_nulo return datetime,
/** [procedure] Atribui a última data possível caso a data atual seja nula<br>
*<code>
*declare
*  dt datetime := datetime();
*begin
*  dt.final_se_nulo; -- 31/12/9999
*end;
*</code>
**/
  member procedure final_se_nulo,
/** [function] Retorna se a data atual está dentro de uma lista de datas (S/N)<br>
*<code>
*declare
*  dt datetime := datetime('25/12/2018');
*  dt2 datetime := datetime('18/10/2018');
*  datas_eventuais varchar2(500) := '10/10/2016;18/10/2018;25/10/2018;02/11/2018';
*  feriados_nacionais varchar2(500):= '01/01;21/04;01/05;07/09;12/10;02/11;15/11;25/12';
*begin
*  console.log(args(
*
*    dt.esta_na_lista(datas_eventuais), -- "N"
*    dt2.esta_na_lista(datas_eventuais), -- "S"
*
*    -- verificar datas sem o ano
*    dt.limpar(ano=>'S').esta_na_lista(feriados_nacionais,'DD/MM'), -- "S"
*    dt2.limpar(ano=>'S').esta_na_lista(feriados_nacionais,'DD/MM'), -- "N"
*    -- utilizando to_format no lugar do limpar
*    dt.to_format('DD/MM').esta_na_lista(feriados_nacionais,'DD/MM'), -- "S"
*    dt2.to_format('DD/MM').esta_na_lista(feriados_nacionais,'DD/MM') -- "N"
*
*  ));
*end;
*</code>
* %param list lista de datas (varchar2)
* %param formato da data (default 'DD/MM/RRRR HH24:MI:SS')
* %param separador caractere que separa as datas (por padrão ';')
* %return está na lista (S/N)
**/
  member function esta_na_lista(list      varchar2
                               ,formato   varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                               ,separador char default ';') return char,
/** [function] Retorna se a data atual está dentro de um período (passando datas em datetime) (S/N)<br>
*<code>
*declare
*  dt datetime := datetime('25/12/2018');
*  dt2 datetime := datetime('18/12/2018');
*  dt3 datetime := datetime('31/12/2018');
*begin
*  console.log(args(
*    dt.esta_dentro(dt2,dt3), -- "S"
*    dt2.esta_dentro(dt,dt3) -- "N"
*  ));
*end;
*</code>
* %param inicio (datetime)
* %param fim (datetime)
* %param infinito considerar período infinito quando inicio e fim forem ambos nulos S/N (default 'N')
* %return está dentro do periodo (S/N)
**/
  member function esta_dentro(inicio   datetime
                             ,fim      datetime
                             ,infinito char default 'N') return char,
/** [function] Retorna se a data atual está dentro de um período (passando datas em date) (S/N)<br>
*<code>
*declare -- considerando sysdate = 10/12/2018
*  dt datetime := datetime('25/12/2018');
*begin
*  console.log(args(
*
*    dt.esta_dentro(to_date('01/12/2018'),to_date('15/12/2018')), -- "N"
*    dt.esta_dentro(sysdate,to_date('28/12/2018')), -- "S"
*
*    -- data apartir
*    dt.esta_dentro(sysdate), -- "S"
*    -- data até
*    dt.esta_dentro(fim=>sysdate) -- "N"
*
*  ));
*end;
*</code>
* %param inicio (date)
* %param fim (date)
* %param infinito considerar período infinito quando inicio e fim forem ambos nulos S/N (default 'N')
* %return está dentro do periodo (S/N)
**/
  member function esta_dentro(inicio   date default null
                             ,fim      date default null
                             ,infinito char default 'N') return char,
/** [function] Retorna se a data atual está dentro de um período (passando datas em varchar2) (S/N)<br>
*<code>
*declare
*  dt datetime := datetime('25/12/2018');
*begin
*  console.log(args(
*
*    dt.esta_dentro('01/12/2018','15/12/2018'), -- "N"
*    dt.esta_dentro('10/12/2018','28/12/2018'), -- "S"
*
*    -- data apartir
*    dt.esta_dentro('10/12/2018'), -- "S"
*    -- data até
*    dt.esta_dentro(fim=>'10/12/2018') -- "N"
*
*  ));
*end;
*</code>
* %param inicio (varchar2)
* %param fim (varchar2)
* %param formato das datas (default 'DD/MM/RRRR HH24:MI:SS')
* %param infinito considerar período infinito quando inicio e fim forem ambos nulos S/N (default 'N')
* %return está dentro do periodo (S/N)
**/
  member function esta_dentro(inicio   varchar2 default null
                             ,fim      varchar2 default null
                             ,formato  varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                             ,infinito char default 'N') return char,
/** [function] Retorna se a data atual está dentro de um período ANO/MES (passando datas em datetime) (S/N)<br>
*Se a data possuir "dia" será descartado da comparação.
*<code>
*declare
*  dt datetime := datetime('05/10/2018');
*  dt2 datetime := datetime('18/10/2018');
*  dt3 datetime := datetime('20/12/2018');
*begin
*  console.log(args(
*    dt.esta_dentro_anomes(dt2,dt3), -- "S"
*    dt3.esta_dentro_anomes(dt,dt2) -- "N"
*  ));
*end;
*</code>
* %param inicio (datetime)
* %param fim (datetime)
* %param infinito considerar período infinito quando inicio e fim forem ambos nulos S/N (default 'N')
* %return está dentro do periodo AN0/MES (S/N)
**/
  member function esta_dentro_anomes(inicio   datetime
                                    ,fim      datetime
                                    ,infinito char default 'N') return char,
/** [function] Retorna se a data atual está dentro de um período AN0/MES (passando datas em date) (S/N)<br>
*Se a data possuir "dia" será descartado da comparação.
*<code>
*declare -- considerando sysdate = 10/12/2018
*  dt datetime := datetime('25/12/2018');
*begin
*  console.log(args(
*
*    dt.esta_dentro_anomes(to_date('31/12/2018'),to_date('01/01/2019')), -- "S"
*    dt.esta_dentro_anomes(sysdate,to_date('11/12/2018')), -- "S"
*
*    -- data apartir
*    dt.esta_dentro_anomes(sysdate), -- "S"
*    -- data até
*    dt.esta_dentro_anomes(fim=>to_date('10/11/2018')) -- "N"
*
*  ));
*end;
*</code>
* %param inicio (date)
* %param fim (date)
* %param infinito considerar período infinito quando inicio e fim forem ambos nulos S/N (default 'N')
* %return está dentro do periodo AN0/MES (S/N)
**/
  member function esta_dentro_anomes(inicio   date default null
                                    ,fim      date default null
                                    ,infinito char default 'N') return char,
/** [function] Retorna se a data atual está dentro de um período AN0/MES (passando datas em varchar2) (S/N)<br>
*Se a data possuir "dia" será descartado da comparação.
*<code>
*declare
*  dt datetime := datetime('25/12/2018');
*begin
*  console.log(args(
*
*    dt.esta_dentro_anomes('10/2018','11/2018','MM/RRRR'), -- "N"
*    dt.esta_dentro_anomes('10/12/2018','15/12/2018'), -- "S"
*
*    -- data apartir
*    dt.esta_dentro_anomes('11/2018',formato=>'MM/RRRR'), -- "S"
*    -- data até
*    dt.esta_dentro_anomes(fim=>'11/2018',formato=>'MM/RRRR') -- "N"
*
*  ));
*end;
*</code>
* %param inicio (varchar2)
* %param fim (varchar2)
* %param formato das datas (default 'DD/MM/RRRR HH24:MI:SS')
* %param infinito considerar período infinito quando inicio e fim forem ambos nulos S/N (default 'N')
* %return está dentro do periodo AN0/MES (S/N)
**/
  member function esta_dentro_anomes(inicio   varchar2 default null
                                    ,fim      varchar2 default null
                                    ,formato  varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                                    ,infinito char default 'N') return char,
/** [function] Retorna se a data atual está dentro de um período AN0/MES (passando RRRRMM em number) (S/N)<br>
*<code>
*declare
*  dt datetime := datetime('25/12/2018');
*begin
*  console.log(args(
*
*    dt.esta_dentro_anomes(201810,201811), -- "N"
*    dt.esta_dentro_anomes(201812,201812), -- "S"
*
*    -- data apartir
*    dt.esta_dentro_anomes(201811), -- "S"
*    -- data até
*    dt.esta_dentro_anomes(fim=>201811) -- "N"
*
*  ));
*end;
*</code>
* %param inicio RRRRMM (number)
* %param fim RRRRMM (number)
* %param infinito considerar período infinito quando inicio e fim forem ambos nulos S/N (default 'N')
* %return está dentro do periodo AN0/MES (S/N)
**/
  member function esta_dentro_anomes(inicio   number default null
                                    ,fim      number default null
                                    ,infinito char default 'N') return char,
/** [function] Retorna o horário atual está dentro de um período de horário (passando HH24MI em number) (S/N)<br>
*<b>Obs.:</b> Considera apenas horas e minutos.
*<code>
*declare
*  dt datetime := datetime(hora=>12,minuto=>13);
*begin
*  console.log(args(
*  
*    dt.esta_dentro_horario(1100,1400), -- S
*    dt.esta_dentro_horario(1213), -- S
*    dt.esta_dentro_horario(1214), -- N
*    dt.esta_dentro_horario(1213,inicio_fim=>'S'), -- S
*    dt.esta_dentro_horario(fim=>1213), -- S
*    dt.esta_dentro_horario(fim=>1212), -- N
*    dt.esta_dentro_horario(fim=>1213,inicio_fim=>'S') -- N
*    
*  ));
*end;
*</code>
* %param inicio HH24MI (number)
* %param fim HH24MI (number)
* %param inicio_fim data pode colidir com o final do período (default 'N')
* %return está dentro de outro horário (S/N)
**/
  member function esta_dentro_horario(inicio     number default null
                                     ,fim        number default null
                                     ,inicio_fim char default 'N') return varchar2,

/** [function] Retorna o horário atual está dentro de um período de horário (passando datetime) (S/N)<br>
*<b>Obs.:</b> Considera apenas horas e minutos.
*<code>
*declare
*  dt datetime := datetime(hora=>12,minuto=>13);
*  dt2 datetime := datetime('11:00','HH24:MI');
*  dt3 datetime := datetime('14:00','HH24:MI');
*  dt4 datetime := datetime('12:13','HH24:MI');
*begin
*  console.log(args(
*  
*    dt.esta_dentro_horario(dt2,dt3), -- S
*    dt.esta_dentro_horario(dt4), -- N
*    dt.esta_dentro_horario(dt4,inicio_fim=>'S') -- S
*    
*  ));
*end;
*</code>
* %param inicio (datetime)
* %param fim (datetime)
* %param inicio_fim data pode colidir com o final do período (default 'N')
* %return está dentro de outro horário (S/N)
**/
  member function esta_dentro_horario(inicio     datetime
                                     ,fim        datetime
                                     ,inicio_fim char default 'N') return varchar2,
/** [function] Retorna o horário atual está dentro de um período de horário (passando date) (S/N)<br>
*<b>Obs.:</b> Considera apenas horas e minutos.
*<code>
*declare -- considerando sysdate = 10/12/2018 12:13:55
*  dt datetime := datetime(hora=>12,minuto=>13);
*begin
*  console.log(args(
*  
*    dt.esta_dentro_horario(to_date('11:00','HH24:MI'),to_date('14:00','HH24:MI')), -- S
*    dt.esta_dentro_horario(sysdate), -- N
*    dt.esta_dentro_horario(sysdate,inicio_fim=>'S') -- S
*    
*  ));
*end;
*</code>
* %param inicio (date)
* %param fim (date)
* %param inicio_fim data pode colidir com o final do período (default 'N')
* %return está dentro de outro horário (S/N)
**/
  member function esta_dentro_horario(inicio     date default null
                                     ,fim        date default null
                                     ,inicio_fim char default 'N') return varchar2,
/** [function] Retorna o horário atual está dentro de um período de horário (passando varchar2) (S/N)<br>
*<b>Obs.:</b> Considera apenas horas e minutos.
*<code>
*declare
*  dt datetime := datetime(hora=>12,minuto=>13);
*begin
*  console.log(args(
*  
*    dt.esta_dentro_horario('11:00','14:00'), -- S
*    dt.esta_dentro_horario('12:13'), -- N
*    dt.esta_dentro_horario('12:13',inicio_fim=>'S') -- S
*    
*  ));
*end;
*</code>
* %param inicio (varchar2)
* %param fim (varchar2)
* %param inicio_fim data pode colidir com o final do período (default 'N')
* %return está dentro de outro horário (S/N)
**/
  member function esta_dentro_horario(inicio     varchar2 default null
                                     ,fim        varchar2 default null
                                     ,inicio_fim char default 'N') return varchar2,
/** [function] Retorna a data truncada<br>
*<code>
*declare
*  dt datetime := datetime('19/12/2018 13:45:22');
*begin
*  console.log(
*    dt.trunc() -- 19/12/2018
*  );
*end;
*</code>
* %return data truncada DD/MM/RRRR
**/
  member function trunc return date,
/** [function] Retorna um novo objeto datetime com o formato informado<br>
*<code>
*declare
*  dt datetime := datetime('19/12/2018 13:45:22'); -- considerando sysdate = 18/11/2019
*begin
*  console.log(args(
*    dt.to_format('RRRR').to_char(), -- 01/11/2018
*  ));
*end;
*</code>
* %param formato (default 'DD/MM/RRRR')
* %return data (datetime) de acordo com o formato
**/
  member function to_format(formato varchar2 default 'MM/RRRR') return datetime,
/** [function] Retorna a data em varchar2<br>
*<code>
*declare
*  dt datetime := datetime('19/12/2018 13:45:22');
*begin
*  console.log(args(
*    dt.to_char(), -- 19/12/2018
*    dt.to_char('MM/RRRR'), -- 12/2018
*    dt.to_char('MM/RR'), -- 12/18
*    dt.to_char('DD/MM'), -- 19/12
*    dt.to_char('DD/MM -> HH24:MI') -- 19/12 -> 13:45
*  ));
*end;
*</code>
* %param formato (default 'DD/MM/RRRR')
* %return data (varchar2) de acordo com o formato
**/
  member function to_char(formato varchar2 default 'DD/MM/RRRR') return varchar2,
/** [function] Retorna a data em number<br>
*<code>
*declare
*  dt datetime := datetime('19/12/2018 13:45:22');
*begin
*  console.log(args(
*    dt.to_char(), -- 20181219
*    dt.to_char('MMRRRR'), -- 122018
*    dt.to_char('RRMM'), -- 1812
*    dt.to_char('DDMM') -- 1912
*  ));
*end;
*</code>
* %param formato (default 'DD/MM/RRRR')
* %return data (number) de acordo com o formato
**/
  member function to_number(formato varchar2 default 'RRRRMMDD') return number,
/** [function] Retorna a data<br>
* %return data (date)
**/
  member function to_date return date,
/** [static function] Retorna se é um ano bissexto (S/N)<br>
*<code>
*begin
*  console.log(args(
*    datetime.bissexto(2010), -- "N"
*    datetime.bissexto(2012) -- "S"
*  ));
*end;
*</code>
* %param ano (number)
* %return ano bissexto (S/N)
**/
  static function bissexto(ano number) return char,
/** [static function] Retorna datas de feriados<br>
*<code>
*select * from table(datetime.feriados()); -- todos os feriados
*</code>
* %return feriados (argsd)
**/
  static function feriados return argsd,
/** [static function] Retorna datas de feriados<br>
*<code>
*select * from table(datetime.feriados(datetime('10/10/2016'))); -- feriados a partir de 10/10/2016
*</code>
* %param inicio (datetime)
* %param fim (datetime)
* %return feriados (argsd)
**/
  static function feriados(inicio datetime
                          ,fim    datetime) return argsd,
/** [static function] Retorna datas de feriados<br>
*<code>
*select * from table(datetime.feriados(sysdate)); -- feriados a partir de sysdate
*</code>
* %param inicio (date)
* %param fim (date)
* %return feriados (argsd)
**/
  static function feriados(inicio date
                          ,fim    date default null) return argsd,
/** [static function] Retorna datas de feriados<br>
*<code>
*select * from table(datetime.feriados('01/01/2018','31/12/2018')); -- feriados de 01/01/2018 até 31/12/2018
*</code>
* %param inicio (varchar2)
* %param fim (varchar2)
* %param formato (default 'DD/MM/RRRR HH24:MI:SS')
* %return feriados (argsd)
**/
  static function feriados(inicio  varchar2
                          ,fim     varchar2 default null
                          ,formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') return argsd,
/** [static function] Retorna a lista de feriados<br>
*<code>
*begin
*  console.log(
*    datetime.feriados -- todos os feriados
*  );
*end;
*</code>
* %return lista separada por ';' (varchar2)
**/
  static function listar_feriados return varchar2,
/** [static function] Retorna a lista de feriados<br>
*<code>
*declare
*  inicio datetime := datetime('01/01/2016');
*  fim datetime := datetime('31/12/2016');
*begin
*  console.log(args(
*    datetime.feriados(inicio), -- feriados a partir de 01/01/2016
*    datetime.feriados(inicio,fim) -- feriados entre 01/01/2016 e 31/12/2016
*  ));
*end;
*</code>
* %param inicio (datetime)
* %param fim (datetime)
* %return lista separada por ';' (varchar2)
**/
  static function listar_feriados(inicio datetime
                                 ,fim    datetime) return varchar2,
/** [static function] Retorna a lista de feriados<br>
*<code>
*declare
*  inicio date := to_date('01/01/2016');
*  fim date := to_date('31/12/2016');
*begin
*  console.log(args(
*    datetime.feriados(inicio), -- feriados a partir de 01/01/2016
*    datetime.feriados(inicio,fim) -- feriados entre 01/01/2016 e 31/12/2016
*  ));
*end;
*</code>
* %param inicio (date)
* %param fim (date)
* %return lista separada por ';' (varchar2)
**/
  static function listar_feriados(inicio date
                                 ,fim    date default null) return varchar2,
/** [static function] Retorna a lista de feriados<br>
*<code>
*begin
*  console.log(args(
*    datetime.feriados(fim=>'31/12/2016'), -- feriados até de 01/01/2016
*    datetime.feriados('01/01/2016','31/12/2016') -- feriados entre 01/01/2016 e 31/12/2016
*  ));
*end;
*</code>
* %param inicio (varchar2)
* %param fim (varchar2)
* %param formato (default 'DD/MM/RRRR HH24:MI:SS')
* %return lista separada por ';' (varchar2)
**/
  static function listar_feriados(inicio  varchar2
                                 ,fim     varchar2 default null
                                 ,formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') return varchar2,
  member function mostra(formato varchar2 default 'DD/MM/RRRR') return varchar2
)
/
create or replace type body datetime is

  -- Constructor
  constructor function datetime(data    varchar2
                               ,formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') return self as result is
  begin
    if formato = 'ISO8601' then
      atribuir(data, formato=>formato);
    else
      self.data := standard.to_date(data, formato);
    end if;
    return;
  end;

  constructor function datetime(data    number
                               ,formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') return self as result is
  begin
    if formato = 'ISO8601' then
      atribuir(data, formato=>formato);
      null;
    else
      self.data := standard.to_date(data, formato);
    end if;
    return;
  end;

  constructor function datetime(ano     number default null
                               ,mes     number default null
                               ,dia     number default null
                               ,hora    number default null
                               ,minuto  number default null
                               ,segundo number default null) return self as result is
    formato varchar2(50);
    ndata   varchar2(50);
  begin
    if dia is not null or
       mes is not null or
       ano is not null or
       hora is not null or
       minuto is not null or
       segundo is not null then
      if dia is not null then
        formato := formato || 'DD';
        ndata   := ndata || lpad(dia, 2, '0');
      end if;
      if mes is not null then
        formato := formato || 'MM';
        ndata   := ndata || lpad(mes, 2, '0');
      end if;
      if ano is not null then
        formato := formato || 'RRRR';
        ndata   := ndata || lpad(ano, 4, '0');
      end if;
      if hora is not null then
        formato := formato || 'HH24';
        ndata   := ndata || lpad(hora, 2, '0');
      end if;
      if minuto is not null then
        formato := formato || 'MI';
        ndata   := ndata || lpad(minuto, 2, '0');
      end if;
      if segundo is not null then
        formato := formato || 'SS';
        ndata   := ndata || lpad(segundo, 2, '0');
      end if;
      self.data := standard.to_date(ndata, formato);
    else
      self.data := null;
    end if;
    return;
  end;

  -- Member procedures and functions
  member function alterar(data date default null) return datetime is
  begin
    if data is not null then
      return datetime(data);
    else
      return self;
    end if;
  end alterar;

  member function alterar(data    varchar2
                         ,formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') return datetime is
  begin
    if data is not null then
      return datetime(standard.to_date(data, formato));
    else
      return self;
    end if;
  end alterar;

  member function alterar(ano     number default null
                         ,mes     number default null
                         ,dia     number default null
                         ,hora    number default null
                         ,minuto  number default null
                         ,segundo number default null) return datetime is
    formato      varchar2(50);
    formato_novo varchar2(50);
    ndata        varchar2(50);
    data_atual   date := self.data;
  begin
    if dia is not null or
       mes is not null or
       ano is not null or
       hora is not null or
       minuto is not null or
       segundo is not null then
      -- se a data é nula, deve pegar sysdate
      if data_atual is null then
        data_atual := standard.trunc(sysdate);
      end if;
      -- --
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
      -- --
      return datetime(standard.to_date(ndata || standard.to_char(data_atual, formato), formato_novo || formato));
    else
      return self;
    end if;
  end alterar;

  member procedure atribuir(self in out nocopy datetime
                           ,data date default null) is
  begin
    self.data := data;
  end atribuir;

  member procedure atribuir(self    in out nocopy datetime
                           ,data    varchar2
                           ,formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') is
  begin
    if formato = 'ISO8601' then
      self.data := cast(to_timestamp_tz(upper(data), 'YYYY-MM-DD"T"HH24:MI:SS.ff9TZR') at time zone dbtimezone as date);
    else
      self.data := standard.to_date(data, formato);
    end if;
  end atribuir;

  member procedure atribuir(self    in out nocopy datetime
                           ,ano     number default null
                           ,mes     number default null
                           ,dia     number default null
                           ,hora    number default null
                           ,minuto  number default null
                           ,segundo number default null) is
  begin
    self := alterar(ano, mes, dia, hora, minuto, segundo);
  end atribuir;

  member function limpar(ano     char default 'N'
                        ,mes     char default 'N'
                        ,dia     char default 'N'
                        ,hora    char default 'N'
                        ,minuto  char default 'N'
                        ,segundo char default 'N'
                        ,horario char default 'N') return datetime is
  begin
    if self.data is not null and
       (ano like 'S' or mes like 'S' or dia like 'S' or hora like 'S' or minuto like 'S' or segundo like 'S' or horario like 'S') then
      declare
        vano     number := null;
        vmes     number := null;
        vdia     number := null;
        vhora    number := null;
        vminuto  number := null;
        vsegundo number := null;
      begin
        if ano like 'S' then
          vano := standard.to_char(sysdate, 'RRRR');
        end if;
        if mes like 'S' then
          vmes := standard.to_char(sysdate, 'MM');
        end if;
        if dia like 'S' then
          vdia := standard.to_char(sysdate, 'DD');
        end if;
        if hora like 'S' then
          vhora := 00;
        end if;
        if minuto like 'S' then
          vminuto := 00;
        end if;
        if segundo like 'S' then
          vsegundo := 00;
        end if;
        if horario like 'S' then
          vhora    := 00;
          vminuto  := 00;
          vsegundo := 00;
        end if;
        -- altera
        return alterar(vano, vmes, vdia, vhora, vminuto, vsegundo);
      end;
    else
      return datetime();
    end if;
  end limpar;

  member procedure limpar(self    in out nocopy datetime
                         ,ano     boolean default false
                         ,mes     boolean default false
                         ,dia     boolean default false
                         ,hora    boolean default false
                         ,minuto  boolean default false
                         ,segundo boolean default false
                         ,horario boolean default false) is
  begin
    if self.data is not null and
       (ano or mes or dia or hora or minuto or segundo or horario) then
      declare
        vano     number := null;
        vmes     number := null;
        vdia     number := null;
        vhora    number := null;
        vminuto  number := null;
        vsegundo number := null;
      begin
        if ano then
          vano := standard.to_char(sysdate, 'RRRR');
        end if;
        if mes then
          vmes := standard.to_char(sysdate, 'MM');
        end if;
        if dia then
          vdia := standard.to_char(sysdate, 'DD');
        end if;
        if hora then
          vhora := 00;
        end if;
        if minuto then
          vminuto := 00;
        end if;
        if segundo then
          vsegundo := 00;
        end if;
        if horario then
          vhora    := 00;
          vminuto  := 00;
          vsegundo := 00;
        end if;
        -- altera
        self := alterar(vano, vmes, vdia, vhora, vminuto, vsegundo);
      end;
    else
      self.data := null;
    end if;
  end limpar;

  member function limpar_horario return datetime is
  begin
    return datetime(standard.trunc(self.data));
  end;

  member procedure limpar_horario is
  begin
    self.data := standard.trunc(self.data);
  end;

  member function adicionar(anos     number default null
                           ,meses    number default null
                           ,dias     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null) return datetime is
    -- --
    ano_invalido exception;
    pragma exception_init(ano_invalido, -1841);
    -- --
    result datetime := self;
  begin
    if anos is not null then
      result.data := add_months(result.data, anos * 12);
    end if;
    if meses is not null then
      result.data := add_months(result.data, meses);
    end if;
    if dias is not null then
      result.data := result.data + dias;
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
  exception
    when ano_invalido then
      return datetime(standard.to_date('31/12/9999'));
  end adicionar;

  member procedure adicionar(self     in out nocopy datetime
                            ,anos     number default null
                            ,meses    number default null
                            ,dias     number default null
                            ,horas    number default null
                            ,minutos  number default null
                            ,segundos number default null) is
  begin
    self := adicionar(anos, meses, dias, horas, minutos, segundos);
  end adicionar;

  member function adicionar(dias_uteis    number
                           ,list_feriados argsd default argsd()) return datetime is
    dias_total    number := nvl(dias_uteis, 0);
    dias_contados number := 0;
    result        datetime := self;
    lferiados     argsd;
  begin
    -- verifica feriados
    if list_feriados is not null and
       list_feriados is not empty then
      lferiados := list_feriados;
    else
      lferiados := datetime.feriados(self.data);
    end if;
    -- --
    loop
      exit when dias_contados = dias_total;
      -- soma dia
      result.data := result.data + 1;
      -- verifica se deve contar dia somado (dia util)
      if standard.to_char(result.data, 'D') between 2 and 6 and
         result.data not member of lferiados then
        dias_contados := dias_contados + 1;
      end if;
    end loop;
    -- --
    return result;
    -- --
  end;

  member function adicionar(dias_uteis    number
                           ,list_feriados varchar2
                           ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                           ,separador     char default ';') return datetime is
    lferiados argsd := argsd();
  begin
    if list_feriados is not null then
      -- gera lista de feriados
      declare
        vpos varchar2(100) := null;
        i    number := 1;
      begin
        loop
          vpos := regexp_substr(list_feriados, '[^' || separador || ']+', 1, i);
          exit when vpos is null;
          -- add
          lferiados.extend;
          lferiados(lferiados.last) := standard.to_date(vpos, formato);
          -- --
          i := i + 1;
        end loop;
      end;
      -- executa adicionar padrão
      return adicionar(dias_uteis => dias_uteis, list_feriados => lferiados);
    else
      return adicionar(dias_uteis => dias_uteis);
    end if;
  end;

  member procedure adicionar(self          in out nocopy datetime
                            ,dias_uteis    number
                            ,list_feriados argsd default argsd()) is
  begin
    self := adicionar(dias_uteis => dias_uteis, list_feriados => list_feriados);
  end;

  member procedure adicionar(self          in out nocopy datetime
                            ,dias_uteis    number
                            ,list_feriados varchar2
                            ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                            ,separador     char default ';') is
  begin
    self := adicionar(dias_uteis => dias_uteis, list_feriados => list_feriados, formato => formato, separador => separador);
  end;

  member function subtrair(anos     number default null
                          ,meses    number default null
                          ,dias     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null) return datetime is
  begin
    return adicionar(-anos, -meses, -dias, -horas, -minutos, -segundos);
  end subtrair;

  member procedure subtrair(self     in out nocopy datetime
                           ,anos     number default null
                           ,meses    number default null
                           ,dias     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null) is
  begin
    self := adicionar(-anos, -meses, -dias, -horas, -minutos, -segundos);
  end subtrair;

  member function subtrair(dias_uteis    number
                          ,list_feriados argsd default argsd()) return datetime is
    dias_total    number := nvl(dias_uteis, 0);
    dias_contados number := 0;
    result        datetime := self;
    lferiados     argsd;
  begin
    -- verifica feriados
    if list_feriados is not null and
       list_feriados is not empty then
      lferiados := list_feriados;
    else
      lferiados := datetime.feriados(null, fim => self.data);
    end if;
    -- --
    loop
      exit when dias_contados = dias_total;
      -- subtrai dia
      result.data := result.data - 1;
      -- verifica se deve contar dia somado (dia util)
      if standard.to_char(result.data, 'D') between 2 and 6 and
         result.data not member of lferiados then
        dias_contados := dias_contados + 1;
      end if;
    end loop;
    -- --
    return result;
    -- --
  end;

  member function subtrair(dias_uteis    number
                          ,list_feriados varchar2
                          ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                          ,separador     char default ';') return datetime is
    lferiados argsd := argsd();
  begin
    if list_feriados is not null then
      -- gera lista de feriados
      declare
        vpos varchar2(100) := null;
        i    number := 1;
      begin
        loop
          vpos := regexp_substr(list_feriados, '[^' || separador || ']+', 1, i);
          exit when vpos is null;
          -- add
          lferiados.extend;
          lferiados(lferiados.last) := standard.to_date(vpos, formato);
          -- --
          i := i + 1;
        end loop;
      end;
      -- executa adicionar padrão
      return subtrair(dias_uteis => dias_uteis, list_feriados => lferiados);
    else
      return subtrair(dias_uteis => dias_uteis);
    end if;
  end;

  member procedure subtrair(self          in out nocopy datetime
                           ,dias_uteis    number
                           ,list_feriados argsd default argsd()) is
  begin
    self := subtrair(dias_uteis => dias_uteis, list_feriados => list_feriados);
  end;

  member procedure subtrair(self          in out nocopy datetime
                           ,dias_uteis    number
                           ,list_feriados varchar2
                           ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                           ,separador     char default ';') is
  begin
    self := subtrair(dias_uteis => dias_uteis, list_feriados => list_feriados, formato => formato, separador => separador);
  end;

  member function ultimo return datetime is
  begin
    return datetime(last_day(self.data));
  end ultimo;

  member function dia return char is
  begin
    return standard.to_char(self.data, 'DD');
  end dia;

  member function mes return char is
  begin
    return standard.to_char(self.data, 'MM');
  end mes;

  member function ano return char is
  begin
    return standard.to_char(self.data, 'RRRR');
  end ano;

  member function hora return char is
  begin
    return standard.to_char(self.data, 'HH24');
  end hora;

  member function minuto return char is
  begin
    return standard.to_char(self.data, 'MI');
  end minuto;

  member function segundo return char is
  begin
    return standard.to_char(self.data, 'SS');
  end segundo;

  member function anomes return char is
  begin
    return standard.to_char(self.data, 'RRRRMM');
  end anomes;

  member function mesdia return char is
  begin
    return standard.to_char(self.data, 'MMDD');
  end mesdia;

  member function horaminuto return char is
  begin
    return standard.to_char(self.data, 'HH24MI');
  end;

  member function horario return char is
  begin
    return standard.to_char(self.data, 'HH24:MI:SS');
  end;

  member function horario_num return number is
  begin
    return standard.to_char(self.data, 'HH24MISS');
  end;

  member function data_completa return varchar2 is
  begin
    return standard.to_char(self.data, 'DD/MM/RRRR HH24:MI:SS');
  end;

  member function data_completa_num return number is
  begin
    return standard.to_char(self.data, 'RRRRMMDDHH24MISS');
  end;

  member function iso8601 return varchar2 is
  begin
    return standard.to_char(self.data, 'RRRR-MM-DD"T"HH24:MI:SS') || dbtimezone;
  end;

  member function ds return number is
  begin
    return standard.to_char(self.data, 'D');
  end ds;

  member function fds return char is
  begin
    if standard.to_char(self.data, 'D') in (1, 7) then
      return 'S';
    else
      return 'N';
    end if;
  end fds;

  member function feriado(list_feriados argsd default argsd()) return char is
    qtd number := 0;
  begin
    if list_feriados is not null and
       list_feriados is not empty then
      if self.data member of list_feriados then
        return 'S';
      else
        return 'N';
      end if;
    else
      declare
        qtd number := 0;
      begin
        select count(1)
          into qtd
          from vw_calendario c
         where c.sit_tipo in ('F', 'P')
           and c.data = self.data;
        -- --
        if qtd > 0 then
          return 'S';
        else
          return 'N';
        end if;
      end;
    end if;
  end feriado;

  member function dia_util(list_feriados argsd default argsd()) return char is
  begin
    if self.fds like 'N' and
       self.feriado(list_feriados) like 'N' then
      return 'S';
    else
      return 'N';
    end if;
  end dia_util;

  member function bissexto return char is
    vano number := ano;
  begin
    if mod(vano, 4) = 0 then
      if mod(vano, 100) = 0 and
         mod(vano, 400) <> 0 then
        return 'N';
      end if;
      return 'S';
    else
      return 'N';
    end if;
  end bissexto;

  member function nulo return char is
  begin
    if self.data is null then
      return 'S';
    else
      return 'N';
    end if;
  end;

  member function nao_nulo return char is
  begin
    if self.data is not null then
      return 'S';
    else
      return 'N';
    end if;
  end;

  member function se_nulo(data datetime) return datetime is
  begin
    if self.data is null then
      return data;
    else
      return self;
    end if;
  end;

  member function se_nulo(data date) return datetime is
  begin
    return se_nulo(datetime(data));
  end;

  member function se_nulo(data    varchar2
                         ,formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') return datetime is
  begin
    return se_nulo(datetime(data, formato));
  end;

  member procedure se_nulo(self in out nocopy datetime
                          ,data datetime) is
  begin
    if self.data is null then
      self := data;
    end if;
  end;

  member procedure se_nulo(data date) is
  begin
    se_nulo(datetime(data));
  end;

  member procedure se_nulo(data    varchar2
                          ,formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') is
  begin
    se_nulo(datetime(data, formato));
  end;

  member function inicial_se_nulo return datetime is
  begin
    if self.data is null then
      return datetime(standard.to_date('01/01/0001'));
    else
      return self;
    end if;
  end;

  member procedure inicial_se_nulo is
  begin
    if self.data is null then
      self := datetime(standard.to_date('01/01/0001'));
    end if;
  end;

  member function final_se_nulo return datetime is
  begin
    if self.data is null then
      return datetime(standard.to_date('31/12/9999'));
    else
      return self;
    end if;
  end;

  member procedure final_se_nulo is
  begin
    if self.data is null then
      self := datetime(standard.to_date('31/12/9999'));
    end if;
  end;

  member function esta_na_lista(list      varchar2
                               ,formato   varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                               ,separador char default ';') return char is
    vpos varchar2(100) := null;
    i    number := 1;
  begin
    loop
      vpos := regexp_substr(list, '[^' || separador || ']+', 1, i);
      exit when vpos is null;
      if standard.to_date(vpos, formato) = standard.trunc(self.data) then
        return 'S';
      end if;
      i := i + 1;
    end loop;
    return 'N';
  end esta_na_lista;

  member function esta_dentro(inicio   datetime
                             ,fim      datetime
                             ,infinito char default 'N') return char is
  begin
    if (data is not null and (infinito like 'S' or (infinito like 'N' and (inicio.data is not null or fim.data is not null)))) and
       self.trunc() between (inicio.inicial_se_nulo().trunc()) and (fim.final_se_nulo().trunc()) then
      return 'S';
    else
      return 'N';
    end if;
  end esta_dentro;

  member function esta_dentro(inicio   date default null
                             ,fim      date default null
                             ,infinito char default 'N') return char is
  begin
    return esta_dentro(datetime(inicio), datetime(fim), infinito);
  end esta_dentro;

  member function esta_dentro(inicio   varchar2 default null
                             ,fim      varchar2 default null
                             ,formato  varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                             ,infinito char default 'N') return char is
  begin
    return esta_dentro(datetime(inicio, formato), datetime(fim, formato), infinito);
  end esta_dentro;

  member function esta_dentro_anomes(inicio   datetime
                                    ,fim      datetime
                                    ,infinito char default 'N') return char is
  begin
    return esta_dentro_anomes(inicio.anomes, fim.anomes, infinito);
  end esta_dentro_anomes;

  member function esta_dentro_anomes(inicio   date default null
                                    ,fim      date default null
                                    ,infinito char default 'N') return char is
  begin
    return esta_dentro_anomes(datetime(inicio).anomes, datetime(fim).anomes, infinito);
  end esta_dentro_anomes;

  member function esta_dentro_anomes(inicio   varchar2 default null
                                    ,fim      varchar2 default null
                                    ,formato  varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                                    ,infinito char default 'N') return char is
  begin
    return esta_dentro_anomes(datetime(inicio, formato).anomes, datetime(fim, formato).anomes, infinito);
  end esta_dentro_anomes;

  member function esta_dentro_anomes(inicio   number default null
                                    ,fim      number default null
                                    ,infinito char default 'N') return char is
  begin
    if (data is not null and (infinito like 'S' or (infinito like 'N' and (inicio is not null or fim is not null)))) and
       anomes between nvl(inicio, 0) and nvl(fim, 999912) then
      return 'S';
    else
      return 'N';
    end if;
  end esta_dentro_anomes;

  member function esta_dentro_horario(inicio     number default null
                                     ,fim        number default null
                                     ,inicio_fim char default 'N') return varchar2 is
    vinicio number := nvl(inicio, 0);
    vfim    number := nvl(fim, 2359);
  begin
    -- pode ter final e inicio igual
    if inicio_fim like 'S' then
      vfim := vfim - 1;
    end if;
    -- verifica cruzamento
    if self.horaminuto() between vinicio and vfim then
      return 'S';
    else
      return 'N';
    end if;
  end esta_dentro_horario;

  member function esta_dentro_horario(inicio     datetime
                                     ,fim        datetime
                                     ,inicio_fim char default 'N') return varchar2 is
  begin
    return esta_dentro_horario(inicio.horaminuto, fim.horaminuto, inicio_fim);
  end esta_dentro_horario;

  member function esta_dentro_horario(inicio     date default null
                                     ,fim        date default null
                                     ,inicio_fim char default 'N') return varchar2 is
  begin
    return esta_dentro_horario(standard.to_number(standard.to_char(inicio, 'HH24MI')), standard.to_number(standard.to_char(fim, 'HH24MI')),
                               inicio_fim);
  end esta_dentro_horario;

  member function esta_dentro_horario(inicio     varchar2 default null
                                     ,fim        varchar2 default null
                                     ,inicio_fim char default 'N') return varchar2 is
  begin
    return esta_dentro_horario(standard.to_number(substr(text(inicio).apenas_numeros(), -4)),
                               standard.to_number(substr(text(fim).apenas_numeros(), -4)), inicio_fim);
  end esta_dentro_horario;

  member function trunc return date is
  begin
    return standard.trunc(self.data);
  end trunc;

  member function to_format(formato varchar2 default 'MM/RRRR') return datetime is
  begin
    return datetime(standard.to_char(self.data, formato), formato);
  end;

  member function to_char(formato varchar2 default 'DD/MM/RRRR') return varchar2 is
  begin
    return trim(standard.to_char(self.data, formato));
  end to_char;

  member function to_number(formato varchar2 default 'RRRRMMDD') return number is
  begin
    return standard.to_char(self.data, formato);
  end to_number;

  member function to_date return date is
  begin
    return self.data;
  end to_date;

  static function bissexto(ano number) return char is
  begin
    if mod(ano, 4) = 0 then
      if mod(ano, 100) = 0 and
         mod(ano, 400) <> 0 then
        return 'N';
      end if;
      return 'S';
    else
      return 'N';
    end if;
  end bissexto;

  static function feriados return argsd is
  begin
    return feriados(datetime(), datetime());
  end;

  static function feriados(inicio datetime
                          ,fim    datetime) return argsd is
    result  argsd := argsd();
    vinicio date := standard.trunc(inicio.inicial_se_nulo().data);
    vfim    date := standard.trunc(fim.final_se_nulo().data);
  begin
    for reg in (select c.data
                  from vw_calendario c
                 where c.sit_tipo in ('F', 'P')
                   and c.data between vinicio and vfim
                 order by c.data)
    loop
      result.extend;
      result(result.last) := reg.data;
    end loop;
    return result;
  end;

  static function feriados(inicio date
                          ,fim    date default null) return argsd is
  begin
    return feriados(datetime(inicio), datetime(fim));
  end;

  static function feriados(inicio  varchar2
                          ,fim     varchar2 default null
                          ,formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') return argsd is
  begin
    return feriados(datetime(inicio, formato), datetime(fim, formato));
  end;

  static function listar_feriados return varchar2 is
  begin
    return listar_feriados(datetime(), datetime());
  end;

  static function listar_feriados(inicio datetime
                                 ,fim    datetime) return varchar2 is
    result  varchar2(32767);
    vinicio date := inicio.inicial_se_nulo().data;
    vfim    date := fim.final_se_nulo().data;
  begin
    for reg in (select c.data
                  from vw_calendario c
                 where c.sit_tipo in ('F', 'P')
                   and c.data between vinicio and vfim
                 order by c.data)
    loop
      result := result || reg.data || ';';
    end loop;
    -- --
    result := rtrim(result, ';');
    -- --
    return result;
  end;

  static function listar_feriados(inicio date
                                 ,fim    date default null) return varchar2 is
  begin
    return listar_feriados(datetime(inicio), datetime(fim));
  end;

  static function listar_feriados(inicio  varchar2
                                 ,fim     varchar2 default null
                                 ,formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') return varchar2 is
  begin
    return listar_feriados(datetime(inicio, formato), datetime(fim, formato));
  end;

  member function mostra(formato varchar2 default 'DD/MM/RRRR') return varchar2 is
  begin
    return to_char(formato);
  end mostra;

end;

--select listagg(c.data,';') within group(order by 1) from vw_calendario c where datetime(c.data).ano() = 2017 and c.sit_tipo in ('F','P');
/
