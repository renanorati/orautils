create or replace type period force as object
(
-- Author  : Renan Orati (renanorati@gmail.com)
-- Purpose : Tratamento de dados do tipo "Período"

-- Attributes
  inicio datetime,
  fim    datetime,

-- Constructor
/** [constructor] Construir o objeto vazio<br>
*<code>
*declare
*  vperiodo period := period();
*</code>
* %return novo objeto (period)
**/
  constructor function period return self as result,
/** [constructor] Construir o objeto passando date<br>
*<code>
*declare -- considerando sysdate = 10/10/2018
*  vperiodo period := period(sysdate); -- A partir de 10/10/2018
*  vperiodo period := period(sysdate,infinito=>'N'); -- 10/10/2018
*  vperiodo period := period(sysdate,infinito=>'FM'); -- 10/10/2018 até 31/10/2018
*  vperiodo period := period(sysdate,to_date('15/10/2018')); -- 10/10/2018 até 15/10/2018
*  vperiodo period := period(sysdate,dias=>1); -- 10/10/2018
*  vperiodo period := period(sysdate,dias=>3); -- 10/10/2018 a 12/10/2018
*  vperiodo period := period(sysdate,meses=>1); -- 10/10/2018 a 09/11/2018
*  vperiodo period := period(sysdate,anos=>2); -- 10/10/2018 a 09/10/2020
*  vperiodo period := period(sysdate,anos=>1,dias=>1); -- 10/10/2018 a 10/10/2019
*</code>
* %return novo objeto (period)
* %param inicio date
* %param fim date default null
* %param anos number default null
* %param meses number default null
* %param dias number default null
* %param horas number default null
* %param minutos number default null
* %param segundos number default null
* %param infinito char default 'S' (Caso o final seja nulo: 'N' -> Período de apenas 1 dia | 'FM' -> Até o fim do mês)
**/
  constructor function period(inicio   date
                             ,fim      date default null
                             ,anos     number default null
                             ,meses    number default null
                             ,dias     number default null
                             ,horas    number default null
                             ,minutos  number default null
                             ,segundos number default null
                             ,infinito char default 'S') return self as result,
/** [constructor] Construir o objeto passando varchar2<br>
*<code>
*declare
*  vperiodo period := period('10/10/2018'); -- A partir de 10/10/2018
*  vperiodo period := period('10/10/2018',infinito=>'N'); -- 10/10/2018
*  vperiodo period := period('10/10/2018',infinito=>'FM'); -- 10/10/2018 até 31/10/2018
*  vperiodo period := period('10/10/2018','15/10/2018'); -- 10/10/2018 até 15/10/2018
*  vperiodo period := period('10/10/2018',dias=>1); -- 10/10/2018
*  vperiodo period := period('10/10/2018',dias=>3); -- 10/10/2018 a 12/10/2018
*  vperiodo period := period('10/10/2018',meses=>1); -- 10/10/2018 a 09/11/2018
*  vperiodo period := period('10/10/2018',anos=>2); -- 10/10/2018 a 09/10/2020
*  vperiodo period := period('10/10/2018',anos=>1,dias=>1); -- 10/10/2018 a 10/10/2019
*  vperiodo period := period('2018-10-10T00:00:00-03:00',formato=>'ISO8601'); -- A partir de 10/10/2018
*</code>
* %return novo objeto (period)
* %param inicio varchar2
* %param fim varchar2 default null
* %param anos number default null
* %param meses number default null
* %param dias number default null
* %param horas number default null
* %param minutos number default null
* %param segundos number default null
* %param infinito char default 'S' (Caso o final seja nulo: 'N' -> Período de apenas 1 dia | 'FM' -> Até o fim do mês)
* %param formato varchar2 default 'DD/MM/RRRR HH24:MI:SS'
**/
  constructor function period(inicio   varchar2
                             ,fim      varchar2 default null
                             ,anos     number default null
                             ,meses    number default null
                             ,dias     number default null
                             ,horas    number default null
                             ,minutos  number default null
                             ,segundos number default null
                             ,infinito char default 'S'
                             ,formato  varchar2 default 'DD/MM/RRRR HH24:MI:SS') return self as result,
/** [constructor] Construir o objeto de ano completo<br>
*<code>
*declare
*  vperiodo period := period(ano=>2018); -- 01/01/2018 a 31/12/2018
*</code>
* %return novo objeto (period)
* %param ano number
**/
  constructor function period(ano number) return self as result,
/** [constructor] Construir o objeto de ano/mes completo<br>
*<code>
*declare
*  vperiodo period := period(anomes=>201801); -- 01/01/2018 a 31/01/2018
*</code>
* %return novo objeto (period)
* %param anomes number
* %param dia_inicio number default 1 
**/
  constructor function period(anomes number, dia_inicio number default 1) return self as result,
/** [constructor] Construir o objeto de ano/mes completo<br>
*<code>
*declare
*  vperiodo period := period(mes=>01,ano=>2018); -- 01/01/2018 a 31/01/2018
*</code>
* %return novo objeto (period)
* %param mes number 
* %param ano number default null 
* %param dia_inicio number default 1
**/
  constructor function period(mes number, ano number default null, dia_inicio number default 1) return self as result,
/** [constructor] Construir o objeto de dia/mes/ano completo<br>
*<code>
*declare
*  vperiodo period := period(dia=>11,mes=>01,ano=>2018); -- 11/01/2018
*  vperiodo period := period(dia=>11,mes=>01,ano=>2018,fim_mes=>'S'); -- 11/01/2018 a 31/01/2018
*</code>
* %return novo objeto (period)
* %param dia number 
* %param mes number default null 
* %param ano number default null 
* %param fim_mes char default 'N' 
**/
  constructor function period(dia number, mes number default null, ano number default null, fim_mes char default 'N') return self as result,
/** [constructor] Construir o objeto com quantidade de dias úteis<br>
*É possível informar a lista de feriádos a serem considerados, ou por padrão serão consultados na tabela vw_calendario.<br>
*<code>
*declare -- considerando sysdate = 06/09/2017
*  vperiodo period := period(sysdate,dias_uteis=>1); -- 06/09/2017
*  vperiodo period := period(sysdate,dias_uteis=>2); -- 06/09/2017 a 08/09/2017
*</code>
* %return novo objeto (period)
* %param inicio date 
* %param dias_uteis number 
* %param list_feriados argsd default argsd() 
**/
  constructor function period(inicio date, dias_uteis number, list_feriados argsd default argsd()) return self as result,
/** [constructor] Construir o objeto com quantidade de dias úteis passando lista de feriádos em varchar2<br>
*<code>
*declare -- considerando sysdate = 06/09/2017
*  feriados_nacionais varchar2(500):= '01/01/2017;21/04/2017;01/05/2017;07/09/2017;12/10/2017;02/11/2017;15/11/2017;25/12/2017';
*  vperiodo period := period(sysdate,dias_uteis=>1,list_feriados=>feriados_nacionais); -- 06/09/2017
*  vperiodo period := period(sysdate,dias_uteis=>2,list_feriados=>feriados_nacionais); -- 06/09/2017 a 08/09/2017
*</code>
* %return novo objeto (period)
* %param inicio date 
* %param dias_uteis number 
* %param list_feriados varchar2 
* %param formato varchar2 default 'DD/MM/RRRR HH24:MI:SS' 
* %param separador char default ';'
**/
  constructor function period(inicio        date
                             ,dias_uteis    number
                             ,list_feriados varchar2
                             ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                             ,separador     char default ';') return self as result,
/** [constructor] Construir o objeto com quantidade de dias úteis<br>
*É possível informar a lista de feriádos a serem considerados, ou por padrão serão consultados na tabela vw_calendario.<br>
*<code>
*declare
*  vperiodo period := period('06/09/2017',dias_uteis=>1); -- 06/09/2017
*  vperiodo period := period('06/09/2017',dias_uteis=>3); -- 06/09/2017 a 11/09/2017
*</code>
* %param inicio varchar2 
* %param dias_uteis number 
* %param list_feriados argsd default argsd() 
* %param formato varchar2 default 'DD/MM/RRRR HH24:MI:SS' 
**/
  constructor function period(inicio        varchar2
                             ,dias_uteis    number
                             ,list_feriados argsd default argsd()
                             ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS') return self as result,
/** [constructor] Construir o objeto com quantidade de dias úteis passando lista de feriádos em varchar2<br>
*<code>
*declare
*  feriados_nacionais varchar2(500):= '01/01/2017;21/04/2017;01/05/2017;07/09/2017;12/10/2017;02/11/2017;15/11/2017;25/12/2017';
*  vperiodo period := period('06/09/2017',dias_uteis=>1,list_feriados=>feriados_nacionais); -- 06/09/2017
*  vperiodo period := period('06/09/2017',dias_uteis=>3,list_feriados=>feriados_nacionais); -- 06/09/2017 a 11/09/2017
*</code>
* %return novo objeto (period)
* %param inicio varchar2 
* %param dias_uteis number 
* %param list_feriados varchar2 
* %param formato varchar2 default 'DD/MM/RRRR HH24:MI:SS' 
* %param separador char default ';'
**/
  constructor function period(inicio        varchar2
                             ,dias_uteis    number
                             ,list_feriados varchar2
                             ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                             ,separador     char default ';') return self as result,
/** [procedure] Atribuir novos valores de inicio e fim<br>
*<code>
*declare
*  vperiodo period := period('10/10/2018');
*begin
*  vperiodo.atribuir(fim=>datetime('10/12/2018')); -- 10/10/2018 a 10/12/2018
*  vperiodo.atribuir(fim=>datetime('10/12/2018'),limpar=>'S'); -- Até 10/12/2018
*end;
*</code>
* %param inicio datetime default datetime() 
* %param fim datetime default datetime() 
* %param limpar char default 'N' (se o parametro é passado nulo elimina o valor atual)
**/
  member procedure atribuir(self in out nocopy period, inicio datetime default datetime(), fim datetime default datetime(), limpar char default 'N'),
/** [procedure] Atribuir novos valores de inicio e fim<br>
*<code>
*declare -- considerando sysdate = 10/12/2018
*  vperiodo period := period('10/10/2018');
*begin
*  vperiodo.atribuir(fim=>sysdate); -- 10/10/2018 a 10/12/2018
*  vperiodo.atribuir(fim=>sysdate,limpar=>'S'); -- Até 10/12/2018
*end;
*</code>
* %param inicio datetime default datetime() 
* %param fim datetime default datetime() 
* %param limpar char default 'N' (se o parametro é passado nulo elimina o valor atual)
**/
  member procedure atribuir(inicio date default null, fim date default null, limpar char default 'N'),
/** [procedure] Atribuir novos valores de inicio e fim<br>
*<code>
*declare
*  vperiodo period := period('10/10/2018');
*begin
*  vperiodo.atribuir(fim=>'10/12/2018'); -- 10/10/2018 a 10/12/2018
*  vperiodo.atribuir(fim=>'10/12/2018',limpar=>'S'); -- Até 10/12/2018
*end;
*</code>
* %param inicio datetime default datetime() 
* %param fim datetime default datetime() 
* %param limpar char default 'N' (se o parametro é passado nulo elimina o valor atual)
**/
  member procedure atribuir(inicio  varchar2 default null
                           ,fim     varchar2 default null
                           ,formato varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                           ,limpar  char default 'N'),
/** [function] Retorna novo objeto com datas NULL ou data modificada de acordo com os parâmetros informados<br>
*Obs.: Ao limpar o objeto parcialmente, os dados atribuidos serão correspondentes a sysdate
*<code>
*declare -- considerando sysdate = 10/10/2018
*  vperiodo period := period('15/12/2020');
*begin
*  console.log(vperiodo.limpar(ano=>'S').to_char()); -- A partir de 15/12/2018
*end;
*</code>
* %return novo objeto (period)
* %param ano char default 'N' 
* %param mes char default 'N' 
* %param dia char default 'N' 
* %param hora char default 'N' 
* %param minuto char default 'N' 
* %param segundo char default 'N' 
* %param horario char default 'N' 
**/
  member function limpar(ano     char default 'N'
                        ,mes     char default 'N'
                        ,dia     char default 'N'
                        ,hora    char default 'N'
                        ,minuto  char default 'N'
                        ,segundo char default 'N'
                        ,horario char default 'N') return period,
/** [procedure] Atribui datas NULL ou modifica datas de acordo com os parâmetros informados<br>
*Obs.: Ao limpar o objeto parcialmente, os dados atribuidos serão correspondentes a sysdate
*<code>
*declare -- considerando sysdate = 10/10/2018
*  vperiodo period := period('15/12/2020');
*begin
*  vperiodo.limpar(ano=>'S'); -- A partir de 15/12/2018
*end;
*</code>
* %param ano char default 'N' 
* %param mes char default 'N' 
* %param dia char default 'N' 
* %param hora char default 'N' 
* %param minuto char default 'N' 
* %param segundo char default 'N' 
* %param horario char default 'N' 
**/
  member procedure limpar(self    in out nocopy period
                         ,ano     boolean default false
                         ,mes     boolean default false
                         ,dia     boolean default false
                         ,hora    boolean default false
                         ,minuto  boolean default false
                         ,segundo boolean default false
                         ,horario boolean default false),
/** [function] Retorna novo objeto com inicio NULL ou inicio modificado de acordo com os parâmetros informados<br>
*Obs.: Ao limpar o objeto parcialmente, os dados atribuidos serão correspondentes a sysdate
*<code>
*declare -- considerando sysdate = 10/10/2018
*  vperiodo period := period('15/12/2020','20/12/2020');
*begin
*  console.log(vperiodo.limpar_inicio(ano=>'S').to_char()); -- 15/12/2018 a 20/12/2020
*end;
*</code>
* %return novo objeto (period)
* %param ano char default 'N' 
* %param mes char default 'N' 
* %param dia char default 'N' 
* %param hora char default 'N' 
* %param minuto char default 'N' 
* %param segundo char default 'N' 
* %param horario char default 'N' 
**/
  member function limpar_inicio(ano     char default 'N'
                               ,mes     char default 'N'
                               ,dia     char default 'N'
                               ,hora    char default 'N'
                               ,minuto  char default 'N'
                               ,segundo char default 'N'
                               ,horario char default 'N') return period,
/** [procedure] Atribui inicio NULL ou modifica inicio de acordo com os parâmetros informados<br>
*Obs.: Ao limpar o objeto parcialmente, os dados atribuidos serão correspondentes a sysdate
*<code>
*declare -- considerando sysdate = 10/10/2018
*  vperiodo period := period('15/12/2020','20/12/2020');
*begin
*  vperiodo.limpar_inicio(ano=>'S'); -- 15/12/2018 a 20/12/2020
*end;
*</code>
* %param ano char default 'N' 
* %param mes char default 'N' 
* %param dia char default 'N' 
* %param hora char default 'N' 
* %param minuto char default 'N' 
* %param segundo char default 'N' 
* %param horario char default 'N' 
**/
  member procedure limpar_inicio(self    in out nocopy period
                                ,ano     boolean default false
                                ,mes     boolean default false
                                ,dia     boolean default false
                                ,hora    boolean default false
                                ,minuto  boolean default false
                                ,segundo boolean default false
                                ,horario boolean default false),
/** [function] Retorna novo objeto com fim NULL ou fim modificado de acordo com os parâmetros informados<br>
*Obs.: Ao limpar o objeto parcialmente, os dados atribuidos serão correspondentes a sysdate
*<code>
*declare -- considerando sysdate = 10/10/2018
*  vperiodo period := period('15/01/2020','20/12/2020');
*begin
*  console.log(vperiodo.limpar_fim(mes=>'S').to_char()); -- 15/01/2018 a 20/10/2020
*end;
*</code>
* %return novo objeto (period)
* %param ano char default 'N' 
* %param mes char default 'N' 
* %param dia char default 'N' 
* %param hora char default 'N' 
* %param minuto char default 'N' 
* %param segundo char default 'N' 
* %param horario char default 'N' 
**/
  member function limpar_fim(ano     char default 'N'
                            ,mes     char default 'N'
                            ,dia     char default 'N'
                            ,hora    char default 'N'
                            ,minuto  char default 'N'
                            ,segundo char default 'N'
                            ,horario char default 'N') return period,
/** [procedure] Atribui fim NULL ou modifica fim de acordo com os parâmetros informados<br>
*Obs.: Ao limpar o objeto parcialmente, os dados atribuidos serão correspondentes a sysdate
*<code>
*declare -- considerando sysdate = 10/10/2018
*  vperiodo period := period('15/01/2020','20/12/2020');
*begin
*  vperiodo.limpar_fim(mes=>'S'); -- 15/01/2018 a 20/10/2020
*end;
*</code>
* %param ano char default 'N' 
* %param mes char default 'N' 
* %param dia char default 'N' 
* %param hora char default 'N' 
* %param minuto char default 'N' 
* %param segundo char default 'N' 
* %param horario char default 'N' 
**/
  member procedure limpar_fim(self    in out nocopy period
                             ,ano     boolean default false
                             ,mes     boolean default false
                             ,dia     boolean default false
                             ,hora    boolean default false
                             ,minuto  boolean default false
                             ,segundo boolean default false
                             ,horario boolean default false),
/** [function] Retorna novo objeto sem informações de horários<br>
*<code>
*declare
*  vperiodo period := period('10/10/2018 10:25:33');
*begin
*  console.log(vperiodo.limpar_horario().to_char()); -- A partir de 10/10/2018 00:00:00
*end;
*</code>
* %return novo objeto (period)
**/
  member function limpar_horario return period,
/** [procedure] Remove informações de horários do objeto<br>
*<code>
*declare
*  vperiodo period := period('10/10/2018 10:25:33');
*begin
*  console.log(
*    vperiodo.limpar_horario().to_char() -- A partir de 10/10/2018 00:00:00
*  );
*end;
*</code>
**/
  member procedure limpar_horario,
/** [function] Altera os valores de inicio e fim<br>
*<code>
*declare
*  vperiodo period := period('10/10/2018','15/10/2018');
*  vfim_novo datetime := datetime('25/10/2018');
*begin
*  console.log(args(
*    vperiodo.alterar(fim=>vnovo_fim).to_char(), -- 10/10/2018 a 25/10/2018
*    vperiodo.alterar(fim=>vnovo_fim,limpar=>'S').to_char() -- Até 25/10/2018
*  ));
*end;
*</code>
* %return novo objeto (period)
* %param inicio datetime default datetime() 
* %param fim datetime default datetime() 
* %param limpar char default 'N' (se o parametro é passado nulo elimina o valor atual)
**/
  member function alterar(inicio datetime default datetime(), fim datetime default datetime(), limpar char default 'N') return period,
/** [function] Altera os valores de inicio e fim<br>
*<code>
*declare -- considerando sysdate = 25/10/2018
*  vperiodo period := period('10/10/2018','15/10/2018');
*begin
*  console.log(args(
*    vperiodo.alterar(fim=>sysdate).to_char(), -- 10/10/2018 a 25/10/2018
*    vperiodo.alterar(fim=>sysdate,limpar=>'S').to_char() -- Até 25/10/2018
*  ));
*end;
*</code>
* %return novo objeto (period)
* %param inicio date default null 
* %param fim date default null 
* %param limpar char default 'N' (se o parametro é passado nulo elimina o valor atual)
**/
  member function alterar(inicio date default null, fim date default null, limpar char default 'N') return period,
/** [function] Altera os valores de inicio e fim<br>
*<code>
*declare
*  vperiodo period := period('10/10/2018','15/10/2018');
*begin
*  console.log(args(
*    vperiodo.alterar(fim=>'25/10/2018').to_char(), -- 10/10/2018 a 25/10/2018
*    vperiodo.alterar(fim=>'25/10/2018',limpar=>'S').to_char() -- Até 25/10/2018
*  ));
*end;
*</code>
* %return novo objeto (period)
* %param inicio varchar2 default null 
* %param fim varchar2 default null 
* %param formato varchar2 default 'DD/MM/RRRR HH24:MI:SS'
* %param limpar char default 'N' (se o parametro é passado nulo elimina o valor atual)
**/
  member function alterar(inicio  varchar2 default null
                         ,fim     varchar2 default null
                         ,formato varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                         ,limpar  char default 'N') return period,
/** [function] Limita o período dentro do novo período informado (period)<br>
*Obs.: Caso o período limitante não tenha cruzamento com o período base, o limite não é aplicado.<br>
*<code>
*declare
*  vperiodo period := period('10/10/2018','13/10/2020');
*begin
*  console.log(args(
*    vperiodo.limitar(period(ano=>2018)).to_char(), -- 10/10/2018 a 31/12/2018
*    vperiodo.limitar(period(anomes=>202010)).to_char() -- 01/10/2020 a 13/10/2020
*  ));
*end;
*</code>
* %return novo objeto (period)
* %param periodo period
**/
  member function limitar(periodo period) return period,
/** [function] Limita o período dentro do novo período informado (datas em datetime)<br>
*Obs.: Caso o período limitante não tenha cruzamento com o período base, o limite não é aplicado.<br>
*<code>
*declare
*  vperiodo period := period('10/10/2018','13/10/2020');
*  vinicio datetime := datetime('01/08/2018');
*  vfim datetime := datetime('05/01/2019');
*begin
*  console.log(
*    vperiodo.limitar(vinicio,vfim).to_char() -- 10/10/2018 a 05/01/2019
*  );
*end;
*</code>
* %return novo objeto (period)
* %param inicio datetime default datetime() 
* %param fim datetime default datetime()
**/
  member function limitar(inicio datetime default datetime(), fim datetime default datetime()) return period,
/** [function] Limita o período dentro do novo período informado (datas em date)<br>
*Obs.: Caso o período limitante não tenha cruzamento com o período base, o limite não é aplicado.<br>
*<code>
*declare -- considerando sysdate = 01/11/2018
*  vperiodo period := period('10/10/2018','13/10/2020');
*begin
*  console.log(
*    vperiodo.limitar(inicio=>sysdate).to_char() -- 01/11/2018 a 13/10/2020
*  );
*end;
*</code>
* %return novo objeto (period)
* %param inicio date default null 
* %param fim date default null 

**/
  member function limitar(inicio date default null, fim date default null) return period,
/** [function] Limita o período dentro do novo período informado (datas em date)<br>
*Obs.: Caso o período limitante não tenha cruzamento com o período base, o limite não é aplicado.<br>
*<code>
*declare
*  vperiodo period := period('10/10/2018','13/10/2020');
*begin
*  console.log(args(
*    vperiodo.limitar(inicio=>'01/01/2019').to_char(), -- 01/01/2019 a 13/10/2020
*    vperiodo.limitar(fim=>'01/01/2019').to_char(), -- 10/10/2018 a 01/01/2019
*    vperiodo.limitar('01/01/2019','31/01/2019').to_char() -- 01/01/2019 a 31/01/2019
*  ));
*end;
*</code>
* %return novo objeto (period)
* %param inicio varchar2 default null 
* %param fim varchar2 default null 
* %param formato varchar2 default 'DD/MM/RRRR HH24:MI:SS' 
**/
  member function limitar(inicio varchar2 default null, fim varchar2 default null, formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') return period,
/** [function] Adiciona ao início e ao fim<br>
*<code>
*begin
*  console.log(
*    period(ano=>2017).adicionar(meses=>1).to_char() -- 01/02/2017 a 31/01/2018
*  );
*end;
*</code>
* %return novo objeto (period)
* %param anos number default null 
* %param meses number default null 
* %param dias number default null 
* %param horas number default null 
* %param minutos number default null 
* %param segundos number default null 
**/
  member function adicionar(anos     number default null
                           ,meses    number default null
                           ,dias     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null) return period,
/** [procedure] Adiciona ao início e ao fim<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*begin
*  vperiodo.adicionar(meses=>1).to_char(); -- 01/02/2017 a 31/01/2018
*end;
*</code>
* %param anos number default null 
* %param meses number default null 
* %param dias number default null 
* %param horas number default null 
* %param minutos number default null 
* %param segundos number default null 
**/
  member procedure adicionar(self     in out nocopy period
                            ,anos     number default null
                            ,meses    number default null
                            ,dias     number default null
                            ,horas    number default null
                            ,minutos  number default null
                            ,segundos number default null),
/** [function] Adiciona dias úteis ao início e ao fim<br>
*<code>
*begin
*  console.log(args(
*    period(ano=>2017).adicionar(dias_uteis=>1).to_char(), -- 02/01/2017 a 02/01/2018
*    period('01/01/2017','06/09/2017').adicionar(dias_uteis=>1).to_char() -- 02/01/2017 a 08/09/2017
*  ));
*end;
*</code>
* %return novo objeto (period)
* %param dias_uteis number 
* %param list_feriados argsd default argsd() 
**/
  member function adicionar(dias_uteis number, list_feriados argsd default argsd()) return period,
/** [procedure] Adiciona dias úteis ao início e ao fim<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*  vperiodo2 period := period('01/01/2017','06/09/2017');
*begin
*  vperiodo.adicionar(dias_uteis=>1); -- 02/01/2017 a 02/01/2018
*  vperiodo2.adicionar(dias_uteis=>1); -- 02/01/2017 a 08/09/2017
*end;
*</code>
* %param dias_uteis number 
* %param list_feriados argsd default argsd() 
**/
  member procedure adicionar(self in out nocopy period, dias_uteis number, list_feriados argsd default argsd()),
/** [function] Adiciona dias úteis ao início e ao fim passando lista de feriados<br>
*<code>
*declare
*  feriados_nacionais varchar2(500):= '01/01/2017;21/04/2017;01/05/2017;07/09/2017;12/10/2017;02/11/2017;15/11/2017;25/12/2017';
*  vperiodo period := period(ano=>2017);
*  vperiodo2 period := period('01/01/2017','06/09/2017');
*begin
*  console.log(args(
*    vperiodo.adicionar(dias_uteis=>1,list_feriados=>feriados_nacionais), -- 02/01/2017 a 01/01/2018
*    vperiodo2.adicionar(dias_uteis=>1,list_feriados=>feriados_nacionais) -- 02/01/2017 a 08/09/2017
*  ));
*end;
*</code>
* %param dias_uteis number 
* %param list_feriados varchar2 
* %param formato varchar2 default 'DD/MM/RRRR HH24:MI:SS' 
* %param separador char default ';' 
**/
  member function adicionar(dias_uteis number, list_feriados varchar2, formato varchar2 default 'DD/MM/RRRR HH24:MI:SS', separador char default ';')
    return period,
/** [procedure] Adiciona dias úteis ao início e ao fim passando lista de feriados<br>
*<code>
*declare
*  feriados_nacionais varchar2(500):= '01/01/2017;21/04/2017;01/05/2017;07/09/2017;12/10/2017;02/11/2017;15/11/2017;25/12/2017';
*  vperiodo period := period(ano=>2017);
*  vperiodo2 period := period('01/01/2017','06/09/2017');
*begin
*  vperiodo.adicionar(dias_uteis=>1,list_feriados=>feriados_nacionais); -- 02/01/2017 a 01/01/2018
*  vperiodo2.adicionar(dias_uteis=>1,list_feriados=>feriados_nacionais); -- 02/01/2017 a 08/09/2017
*end;
*</code>
* %param dias_uteis number 
* %param list_feriados varchar2 
* %param formato varchar2 default 'DD/MM/RRRR HH24:MI:SS' 
* %param separador char default ';' 
**/
  member procedure adicionar(self          in out nocopy period
                            ,dias_uteis    number
                            ,list_feriados varchar2
                            ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                            ,separador     char default ';'),
/** [function] Adiciona ao início<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*begin
*  console.log(
*    vperiodo.add_inicio(meses=>1).to_char() -- 01/02/2017 a 31/12/2017
*  );
*end;
*</code>
* %return novo objeto (period)
* %param anos number default null 
* %param meses number default null 
* %param dias number default null 
* %param horas number default null 
* %param minutos number default null 
* %param segundos number default null 
**/
  member function add_inicio(anos     number default null
                            ,meses    number default null
                            ,dias     number default null
                            ,horas    number default null
                            ,minutos  number default null
                            ,segundos number default null) return period,
/** [procedure] Adiciona ao início<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*begin
*  vperiodo.add_inicio(meses=>1); -- 01/02/2017 a 31/12/2017
*end;
*</code>
* %param anos number default null 
* %param meses number default null 
* %param dias number default null 
* %param horas number default null 
* %param minutos number default null 
* %param segundos number default null 
**/
  member procedure add_inicio(self     in out nocopy period
                             ,anos     number default null
                             ,meses    number default null
                             ,dias     number default null
                             ,horas    number default null
                             ,minutos  number default null
                             ,segundos number default null),
/** [function] Adiciona dias úteis ao início<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*  vperiodo2 period := period('01/01/2017','06/09/2017');
*begin
*  console.log(args(
*    vperiodo.add_inicio(dias_uteis=>1), -- 02/01/2017 a 31/12/2017
*    vperiodo2.add_inicio(dias_uteis=>1) -- 02/01/2017 a 06/09/2017
*  ));
*end;
*</code>
* %return novo objeto (period)
* %param dias_uteis number 
* %param list_feriados argsd default argsd() 
**/
  member function add_inicio(dias_uteis number, list_feriados argsd default argsd()) return period,
/** [procedure] Adiciona dias úteis ao início<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*  vperiodo2 period := period('01/01/2017','06/09/2017');
*begin
*  vperiodo.add_inicio(dias_uteis=>1); -- 02/01/2017 a 31/12/2017
*  vperiodo2.add_inicio(dias_uteis=>1); -- 02/01/2017 a 06/09/2017
*end;
*</code>
* %param dias_uteis number 
* %param list_feriados argsd default argsd() 
**/
  member procedure add_inicio(self in out nocopy period, dias_uteis number, list_feriados argsd default argsd()),
  member function add_inicio(dias_uteis number, list_feriados varchar2, formato varchar2 default 'DD/MM/RRRR HH24:MI:SS', separador char default ';')
    return period,
  member procedure add_inicio(self          in out nocopy period
                             ,dias_uteis    number
                             ,list_feriados varchar2
                             ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                             ,separador     char default ';'),
/** [function] Adiciona ao fim<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*begin
*  console.log(
*    vperiodo.add_fim(meses=>1).to_char() -- 01/01/2017 a 31/01/2018
*  );
*end;
*</code>
* %return novo objeto (period)
* %param anos number default null 
* %param meses number default null 
* %param dias number default null 
* %param horas number default null 
* %param minutos number default null 
* %param segundos number default null 
**/
  member function add_fim(anos     number default null
                         ,meses    number default null
                         ,dias     number default null
                         ,horas    number default null
                         ,minutos  number default null
                         ,segundos number default null) return period,
/** [procedure] Adiciona ao fim<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*begin
*  vperiodo.add_fim(meses=>1); -- 01/01/2017 a 31/01/2018
*end;
*</code>
* %param anos number default null 
* %param meses number default null 
* %param dias number default null 
* %param horas number default null 
* %param minutos number default null 
* %param segundos number default null 
**/
  member procedure add_fim(self     in out nocopy period
                          ,anos     number default null
                          ,meses    number default null
                          ,dias     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null),
/** [function] Adiciona dias úteis ao fim<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*  vperiodo2 period := period('01/01/2017','06/09/2017');
*begin
*  console.log(args(
*    vperiodo.add_fim(dias_uteis=>1), -- 01/01/2017 a 02/01/2018
*    vperiodo2.add_fim(dias_uteis=>1) -- 01/01/2017 a 08/09/2017
*  ));
*end;
*</code>
* %return novo objeto (period)
* %param dias_uteis number 
* %param list_feriados argsd default argsd() 
**/
  member function add_fim(dias_uteis number, list_feriados argsd default argsd()) return period,
/** [procedure] Adiciona dias úteis ao fim<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*  vperiodo2 period := period('01/01/2017','06/09/2017');
*begin
*  vperiodo.add_fim(dias_uteis=>1); -- 01/01/2017 a 02/01/2018
*  vperiodo2.add_fim(dias_uteis=>1); -- 01/01/2017 a 08/09/2017
*end;
*</code>
* %param dias_uteis number 
* %param list_feriados argsd default argsd() 
**/
  member procedure add_fim(self in out nocopy period, dias_uteis number, list_feriados argsd default argsd()),
  member function add_fim(dias_uteis number, list_feriados varchar2, formato varchar2 default 'DD/MM/RRRR HH24:MI:SS', separador char default ';')
    return period,
  member procedure add_fim(self          in out nocopy period
                          ,dias_uteis    number
                          ,list_feriados varchar2
                          ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                          ,separador     char default ';'),
/** [function] Subtrai do início e fim<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*begin
*  console.log(
*    vperiodo.subtrair(meses=>1).to_char() -- 01/12/2016 a 30/11/2017
*  );
*end;
*</code>
* %return novo objeto (period)
* %param anos number default null 
* %param meses number default null 
* %param dias number default null 
* %param horas number default null 
* %param minutos number default null 
* %param segundos number default null 
**/
  member function subtrair(anos     number default null
                          ,meses    number default null
                          ,dias     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null) return period,
/** [procedure] Subtrai do início e fim<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*begin
*  vperiodo.subtrair(meses=>1); -- 01/12/2016 a 30/11/2017
*end;
*</code>
* %return novo objeto (period)
* %param anos number default null 
* %param meses number default null 
* %param dias number default null 
* %param horas number default null 
* %param minutos number default null 
* %param segundos number default null 
**/
  member procedure subtrair(self     in out nocopy period
                           ,anos     number default null
                           ,meses    number default null
                           ,dias     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null),
/** [function] Subtrai dias úteis do início e fim<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*  vperiodo2 period := period('01/01/2017','08/09/2017');
*begin
*  console.log(args(
*    vperiodo.subtrair(dias_uteis=>1).to_char(), -- 30/12/2016 a 29/12/2017
*    vperiodo2.subtrair(dias_uteis=>1).to_char() -- 30/12/2016 a 06/09/2017
*  ));
*end;
*</code>
* %return novo objeto (period)
* %param dias_uteis number 
* %param list_feriados argsd default argsd() 
**/
  member function subtrair(dias_uteis number, list_feriados argsd default argsd()) return period,
/** [procedure] Subtrai dias úteis do início e fim<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*  vperiodo2 period := period('01/01/2017','08/09/2017');
*begin
*  vperiodo.subtrair(dias_uteis=>1); -- 30/12/2016 a 29/12/2017
*  vperiodo2.subtrair(dias_uteis=>1); -- 30/12/2016 a 06/09/2017
*end;
*</code>
* %param dias_uteis number 
* %param list_feriados argsd default argsd() 
**/
  member procedure subtrair(self in out nocopy period, dias_uteis number, list_feriados argsd default argsd()),
  member function subtrair(dias_uteis number, list_feriados varchar2, formato varchar2 default 'DD/MM/RRRR HH24:MI:SS', separador char default ';')
    return period,
  member procedure subtrair(self          in out nocopy period
                           ,dias_uteis    number
                           ,list_feriados varchar2
                           ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                           ,separador     char default ';'),
/** [function] Subtrai do início<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*begin
*  console.log(
*    vperiodo.sub_inicio(meses=>1).to_char() -- 01/12/2016 a 31/12/2017
*  );
*end;
*</code>
* %return novo objeto (period)
* %param anos number default null 
* %param meses number default null 
* %param dias number default null 
* %param horas number default null 
* %param minutos number default null 
* %param segundos number default null 
**/
  member function sub_inicio(anos     number default null
                            ,meses    number default null
                            ,dias     number default null
                            ,horas    number default null
                            ,minutos  number default null
                            ,segundos number default null) return period,
/** [procedure] Subtrai do início<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*begin
*  vperiodo.sub_inicio(meses=>1); -- 01/12/2016 a 31/12/2017
*end;
*</code>
* %param anos number default null 
* %param meses number default null 
* %param dias number default null 
* %param horas number default null 
* %param minutos number default null 
* %param segundos number default null 
**/
  member procedure sub_inicio(self     in out nocopy period
                             ,anos     number default null
                             ,meses    number default null
                             ,dias     number default null
                             ,horas    number default null
                             ,minutos  number default null
                             ,segundos number default null),
/** [function] Subtrai dias úteis do início<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*  vperiodo2 period := period('01/01/2017','08/09/2017');
*begin
*  console.log(args(
*    vperiodo.sub_inicio(dias_uteis=>1).to_char(), -- 30/12/2016 a 31/12/2017
*    vperiodo2.sub_inicio(dias_uteis=>1).to_char() -- 30/12/2016 a 08/09/2017
*  ));
*end;
*</code>
* %return novo objeto (period)
* %param dias_uteis number 
* %param list_feriados argsd default argsd() 
**/
  member function sub_inicio(dias_uteis number, list_feriados argsd default argsd()) return period,
/** [procedure] Subtrai dias úteis do início<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*  vperiodo2 period := period('01/01/2017','08/09/2017');
*begin
*  vperiodo.sub_inicio(dias_uteis=>1); -- 30/12/2016 a 31/12/2017
*  vperiodo2.sub_inicio(dias_uteis=>1); -- 30/12/2016 a 08/09/2017
*end;
*</code>
* %param dias_uteis number 
* %param list_feriados argsd default argsd() 
**/
  member procedure sub_inicio(self in out nocopy period, dias_uteis number, list_feriados argsd default argsd()),
  member function sub_inicio(dias_uteis number, list_feriados varchar2, formato varchar2 default 'DD/MM/RRRR HH24:MI:SS', separador char default ';')
    return period,
  member procedure sub_inicio(self          in out nocopy period
                             ,dias_uteis    number
                             ,list_feriados varchar2
                             ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                             ,separador     char default ';'),
/** [function] Subtrai do fim<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*begin
*  console.log(
*    vperiodo.sub_fim(meses=>1).to_char() -- 01/01/2017 a 30/11/2017
*  );
*end;
*</code>
* %return novo objeto (period)
* %param anos number default null 
* %param meses number default null 
* %param dias number default null 
* %param horas number default null 
* %param minutos number default null 
* %param segundos number default null 
**/
  member function sub_fim(anos     number default null
                         ,meses    number default null
                         ,dias     number default null
                         ,horas    number default null
                         ,minutos  number default null
                         ,segundos number default null) return period,
/** [procedure] Subtrai do fim<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*begin
*  vperiodo.sub_fim(meses=>1); -- 01/01/2017 a 30/11/2017
*end;
*</code>
* %param anos number default null 
* %param meses number default null 
* %param dias number default null 
* %param horas number default null 
* %param minutos number default null 
* %param segundos number default null 
**/
  member procedure sub_fim(self     in out nocopy period
                          ,anos     number default null
                          ,meses    number default null
                          ,dias     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null),
/** [function] Subtrai dias úteis do fim<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*  vperiodo2 period := period('01/01/2017','08/09/2017');
*begin
*  console.log(args(
*    vperiodo.sub_fim(dias_uteis=>1).to_char(), -- 01/01/2017 a 29/12/2017
*    vperiodo2.sub_fim(dias_uteis=>1).to_char() -- 01/01/2017 a 06/09/2017
*  ));
*end;
*</code>
* %return novo objeto (period)
* %param dias_uteis number 
* %param list_feriados argsd default argsd() 
**/
  member function sub_fim(dias_uteis number, list_feriados argsd default argsd()) return period,
/** [procedure] Subtrai dias úteis do fim<br>
*<code>
*declare
*  vperiodo period := period(ano=>2017);
*  vperiodo2 period := period('01/01/2017','08/09/2017');
*begin
*  vperiodo.sub_fim(dias_uteis=>1); -- 01/01/2017 a 29/12/2017
*  vperiodo2.sub_fim(dias_uteis=>1); -- 01/01/2017 a 06/09/2017
*end;
*</code>
* %param dias_uteis number 
* %param list_feriados argsd default argsd() 
**/
  member procedure sub_fim(self in out nocopy period, dias_uteis number, list_feriados argsd default argsd()),
  member function sub_fim(dias_uteis number, list_feriados varchar2, formato varchar2 default 'DD/MM/RRRR HH24:MI:SS', separador char default ';')
    return period,
  member procedure sub_fim(self          in out nocopy period
                          ,dias_uteis    number
                          ,list_feriados varchar2
                          ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                          ,separador     char default ';'),
/** [function] Verifica se o período é nulo<br>
*<code>
*declare
*  vperiodo period := period();
*  vperiodo2 period := period(sysdate);
*begin
*  console.log(args(
*    vperiodo.nulo(), -- S
*    vperiodo2.nulo() -- N
*  ));
*end;
*</code>
* %return char (S/N)
**/
  member function nulo return char,
/** [function] Verifica se o período não é nulo<br>
*<code>
*declare
*  vperiodo period := period();
*  vperiodo2 period := period(sysdate);
*begin
*  console.log(args(
*    vperiodo.nao_nulo(), -- N
*    vperiodo2.nao_nulo() -- S
*  ));
*end;
*</code>
* %return char (S/N)
**/
  member function nao_nulo return char,
/** [function] Verifica se o início é nulo<br>
*<code>
*declare
*  vperiodo period := period(sysdate);
*begin
*  console.log(
*    vperiodo.inicio_nulo() -- N
*  );
*end;
*</code>
* %return char (S/N)
**/
  member function inicio_nulo return char,
/** [function] Verifica se o fim é nulo<br>
*<code>
*declare
*  vperiodo period := period(sysdate);
*begin
*  console.log(
*    vperiodo.fim_nulo() -- S
*  );
*end;
*</code>
* %return char (S/N)
**/
  member function fim_nulo return char,
/** [function] Retorna um nvl das datas de inicio e fim<br>
*<code>
*declare
*  vperiodo period := period('01/01/2017');
*  vperiodo2 period := period();
*begin
*  console.log(args(
*    vperiodo.to_char(), -- A partir de 01/01/2017
*    vperiodo.nvl().to_char(), -- 01/01/2017 a 31/12/9999
*    vperiodo2.to_char(), -- <infinito>
*    vperiodo2.nvl().to_char() -- 01/01/0001 a 31/12/9999
*  ));
*end;
*</code>
* %return novo objeto (period)
* %param inicio date default '01/01/0001' 
* %param fim date default '31/12/9999'
**/
  member function nvl(inicio date default '01/01/0001', fim date default '31/12/9999') return period,
/** [function] Retorna um nvl do início<br>
*<code>
*declare
*  vperiodo period := period('01/01/2017');
*  vperiodo2 period := period();
*begin
*  console.log(args(
*    vperiodo.to_char(), -- A partir de 01/01/2017
*    vperiodo.inicio_nvl('31/12/2006').to_char(), -- A partir de 01/01/2017
*    vperiodo2.to_char(), -- <infinito>
*    vperiodo2.inicio_nvl('31/12/2006').to_char() -- A partir de 31/12/2006
*  ));
*end;
*</code>
* %return novo objeto (period)
* %param data date default '01/01/0001' 
**/
  member function inicio_nvl(data date default '01/01/0001') return datetime,
/** [function] Retorna um nvl do fim<br>
*<code>
*declare
*  vperiodo period := period('01/01/2017');
*  vperiodo2 period := period();
*begin
*  console.log(args(
*    vperiodo.to_char(), -- A partir de 01/01/2017
*    vperiodo.fim_nvl('31/12/2006').to_char(), -- 01/01/2017 a 31/12/2006
*    vperiodo2.to_char(), -- <infinito>
*    vperiodo2.fim_nvl('31/12/2006').to_char() -- Até 31/12/2006
*  ));
*end;
*</code>
* %return novo objeto (period)
* %param data date default '01/01/0001' 
**/
  member function fim_nvl(data date default '31/12/9999') return datetime,
/** [function] Verifica se o fim é menor que o início<br>
*<code>
*declare
*  vperiodo period := period('10/10/2015','15/10/2015');
*  vperiodo2 period := period('10/10/2015','05/10/2015');
*begin
*  console.log(args(
*    vperiodo.fim_menor(), -- N
*    vperiodo2.fim_menor() -- S
*  ));
*end;
*</code>
* %return char (S/N)
**/
  member function fim_menor return char,
/** [function] Retorna a quantidade de dias dentro do período<br>
*<code>
*begin
*  console.log(args(
*    period('01/01/2016',infinito=>'N').dias(), -- 1
*    period('01/01/2016','02/01/2016').dias(), -- 2
*    period(ano=>2016).dias(), -- 366
*    period(anomes=>201602).dias() -- 29
*  ));
*end;
*</code>
* %return number
* %param contar_dia_inicial char default 'S'
**/
  member function dias(contar_dia_inicial char default 'S') return number,
/** [function] Retorna a quantidade de meses dentro do período<br>
*<code>
*begin
*  console.log(args(
*    period('01/01/2016',infinito=>'N').meses(), -- 0
*    period(ano=>2016).meses(), -- 12
*    period(anomes=>201602).meses() -- 1
*  ));
*end;
*</code>
* %return number
* %param contar_dia_inicial char default 'S'
**/
  member function meses(contar_dia_inicial char default 'S') return number,
/** [function] Retorna a quantidade de anos dentro do período<br>
*<code>
*begin
*  console.log(args(
*    period('01/01/2016','31/12/2019').anos(), -- 4
*    period(ano=>2016).anos(), -- 1
*    period(anomes=>201602).anos() -- 0
*  ));
*end;
*</code>
* %return number
* %param contar_dia_inicial char default 'S'
**/
  member function anos(contar_dia_inicial char default 'S') return number,
/** [function] Retorna a quantidade de horas dentro do período<br>
*<code>
*begin
*  console.log(args(
*    period('01/01/2016',infinito=>'N').horas(), -- 24
*    period(ano=>2016).horas(), -- 8784
*    period(anomes=>201602).horas() -- 696
*  ));
*end;
*</code>
* %return number
* %param contar_dia_inicial char default 'S'
**/
  member function horas(contar_dia_inicial char default 'S') return number,
/** [function] Retorna a quantidade de minutos dentro do período<br>
*<code>
*begin
*  console.log(args(
*    period('01/01/2016',infinito=>'N').minutos(), -- 1440
*    period(ano=>2016).minutos(), -- 527040
*    period(anomes=>201602).minutos() -- 41760
*  ));
*end;
*</code>
* %return number
* %param contar_dia_inicial char default 'S'
**/
  member function minutos(contar_dia_inicial char default 'S') return number,
/** [function] Retorna a quantidade de segundos dentro do período<br>
*<code>
*begin
*  console.log(args(
*    period('01/01/2016',infinito=>'N').segundos(), -- 86400
*    period(ano=>2016).segundos(), -- 31622400
*    period(anomes=>201602).segundos() -- 2505600
*  ));
*end;
*</code>
* %return number
* %param contar_dia_inicial char default 'S'
**/
  member function segundos(contar_dia_inicial char default 'S') return number,
/** [function] Retorna tempo dentro período<br>
*<code>
*begin
*  console.log(args(
*    period('01/01/2016 01:15:33', '01/07/2018 12:11:55').tempo(), -- 2 anos 6 meses 10 horas 56 minutos e 22 segundos
*    period('01/01/2016 01:15:33', '01/07/2018 12:11:55').tempo(resumido=>'S'), -- 2a 6m 10:56:22
*    period('01/01/2016 01:15:33', '01/07/2018 12:11:55').tempo(em_horas=>'S'), -- 21898:56:22
*    period(ano=>2016).tempo(), -- 1 ano 
*    period(ano=>2016).tempo(em_horas=>'S'), -- 8784:00:00
*    period(anomes=>201602).tempo(), -- 1 mês
*    period(anomes=>201602).tempo(em_horas=>'S') -- 696:00:00
*  ));
*end;
*</code>
* %return varchar2
* %param contar_bissexto char default 'N' (S/N) 
* %param resumido char default 'N' (S/N) 
* %param em_horas char default 'N' (S/N) 
**/
  member function tempo(contar_bissexto char default 'N', resumido char default 'N', em_horas char default 'N', separador char default ':')
    return varchar2,
/** [function] Retorna a data completa em varchar2<br>
*<code>
*begin
*  console.log(args(
*    period('01/01/2016 01:15:33', '01/07/2018 12:11:55').to_char(), -- 01/01/2016 a 01/07/2018
*    period('01/01/2016 01:15:33', '01/07/2018 12:11:55').to_char('DD/MM/RRRR HH24:MI:SS'), -- 01/01/2016 01:15:33 a 01/07/2018 12:11:55
*    period('01/01/2016 01:15:33', '01/07/2018 12:11:55').data_completa() -- 01/01/2016 01:15:33 a 01/07/2018 12:11:55
*  ));
*end;
*</code>
* %return varchar2
**/
  member function data_completa return varchar2,
/** [function] Retorna os dias da semana que estão compreendidos no período<br>
*<code>
*begin
*  console.log(args(
*    period('31/12/2017','01/01/2018').ds(), -- 1,2
*    period('31/12/2017','01/01/2018').ds(formato=>'day'), -- domingo,segunda-feira
*    period('31/12/2017','01/01/2018').ds(formato=>'day',separador=>' > ') -- domingo > segunda-feira
*  ));
*end;
*</code>
* %return varchar2
* %param formato varchar2 default 'D' 
* %param separador varchar2 default ','
**/
  member function ds(formato varchar2 default 'D', separador varchar2 default ',') return varchar2,
/** [function] Retorna a quantidade de dias em finais de semana dentro do período<br>
*<code>
*begin
*  console.log(args(
*    period('31/12/2017','03/01/2018').dias_fds(), -- 1
*    period(ano=>2016).dias_fds(), -- 105
*    period(anomes=>201602).dias_fds() -- 8
*  ));
*end;
*</code>
* %return number
**/
  member function dias_fds return number,
/** [function] Retorna a quantidade de dias de semana dentro do período<br>
*<code>
*begin
*  console.log(args(
*    period('31/12/2017','03/01/2018').dias_semana(), -- 3
*    period(ano=>2016).dias_semana(), -- 261
*    period(anomes=>201602).dias_semana() -- 21
*  ));
*end;
*</code>
* %return number
**/
  member function dias_semana return number,
/** [function] Retorna a quantidade de feriados dentro do período<br>
*<code>
*begin
*  console.log(args(
*    period('31/12/2017','03/01/2018').dias_feriado(), -- 1
*    period(ano=>2016).dias_feriado(), -- 21
*    period(anomes=>201602).dias_feriado() -- 2
*  ));
*end;
*</code>
* %return number
**/
  member function dias_feriado(list_feriados argsd default argsd()) return number,
/** [function] Retorna a quantidade de feriados em dias de semana dentro do período<br>
*<code>
*begin
*  console.log(args(
*    period('31/12/2017','03/01/2018').dias_feriado_semana(), -- 1
*    period(ano=>2016).dias_feriado_semana(), -- 16
*    period(anomes=>201602).dias_feriado_semana() -- 2
*  ));
*end;
*</code>
* %return number
**/
  member function dias_feriado_semana(list_feriados argsd default argsd()) return number,
/** [function] Retorna a quantidade de feriados em finais de semana dentro do período<br>
*<code>
*begin
*  console.log(args(
*    period('31/12/2017','03/01/2018').dias_feriado_fds(), -- 0
*    period(ano=>2016).dias_feriado_fds(), -- 5
*    period(anomes=>201603).dias_feriado_fds() -- 1
*  ));
*end;
*</code>
* %return number
**/
  member function dias_feriado_fds(list_feriados argsd default argsd()) return number,
/** [function] Retorna a quantidade de dias úteis dentro do período<br>
*<code>
*begin
*  console.log(args(
*    period('31/12/2017','03/01/2018').dias_uteis(), -- 2
*    period(ano=>2016).dias_uteis(), -- 245
*    period(anomes=>201602).dias_uteis() -- 19
*  ));
*end;
*</code>
* %return number
**/
  member function dias_uteis(list_feriados argsd default argsd()) return number,
/** [function] Collection com dias de finais de semana dentro do período<br>
*<code>
*select * from table(period('31/12/2017','03/01/2018').listar_dias_fds());
*select * from table(period(ano=>2016).listar_dias_fds());
*select * from table(period(anomes=>201602).listar_dias_fds());
*</code>
* %return argsd (collection de date)
**/
  member function listar_dias_fds return argsd,
/** [function] Collection com dias de semana dentro do período<br>
*<code>
*select * from table(period('31/12/2017','03/01/2018').listar_dias_semana());
*select * from table(period(ano=>2016).listar_dias_semana());
*select * from table(period(anomes=>201602).listar_dias_semana());
*</code>
* %return argsd (collection de date)
**/
  member function listar_dias_semana return argsd,
/** [function] Collection com feriados dentro do período<br>
*<code>
*select * from table(period('31/12/2017','03/01/2018').listar_feriados());
*select * from table(period(ano=>2016).listar_feriados());
*select * from table(period(anomes=>201602).listar_feriados());
*</code>
* %return argsd (collection de date)
**/
  member function listar_feriados(list_feriados argsd default argsd()) return argsd,
/** [function] Collection com feriados em dias de semana dentro do período<br>
*<code>
*select * from table(period('31/12/2017','03/01/2018').listar_feriados_semana());
*select * from table(period(ano=>2016).listar_feriados_semana());
*select * from table(period(anomes=>201602).listar_feriados_semana());
*</code>
* %return argsd (collection de date)
**/
  member function listar_feriados_semana(list_feriados argsd default argsd()) return argsd,
/** [function] Collection com feriados em dias de finais de semana dentro do período<br>
*<code>
*select * from table(period('31/12/2017','03/01/2018').listar_feriados_fds());
*select * from table(period(ano=>2016).listar_feriados_fds());
*select * from table(period(anomes=>201602).listar_feriados_fds());
*</code>
* %return argsd (collection de date)
**/
  member function listar_feriados_fds(list_feriados argsd default argsd()) return argsd,
/** [function] Collection com dias úteis dentro do período<br>
*<code>
*select * from table(period('31/12/2017','03/01/2018').listar_dias_uteis());
*select * from table(period(ano=>2016).listar_dias_uteis());
*select * from table(period(anomes=>201602).listar_dias_uteis());
*</code>
* %return argsd (collection de date)
**/
  member function listar_dias_uteis(list_feriados argsd default argsd()) return argsd,
/** [function] Retorna os dias da semana que estão compreendidos no período<br>
*<code>
*begin
*  console.log(args(
*    period('31/12/2017','01/01/2018').ds(), -- argsn(1,2)
*    period('31/12/2017','02/01/2018').ds() -- argsn(1,2,3)
*  ));
*end;
*</code>
* %return argsn
**/
  member function listar_ds return argsn,
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
  member function cruzamento_lista(list argsd default argsd(), infinito char default 'N') return char,
/** [function] Retorna se o período de horário está dentro do horário do período<br>
*<b>Obs.:</b> Considera apenas horas e minutos.
*<code>
*declare
*  vperiodo period := period('10:30','12:00',formato=>'HH24:MI');
*begin
*  console.log(args(
*    vperiodo.cruzamento_horario('11:50','15:30'), -- S
*    vperiodo.cruzamento_horario('12:00','13:00'), -- S
*    vperiodo.cruzamento_horario('12:00','13:00',inicio_fim=>'S') -- N
*  ));
*end;
*</code>
* %return char (S/N)
* %param inicio date
* %param fim date
* %param inicio_fim char default 'N' (não cruzar último e primeiro minuto)
**/
  member function cruzamento_horario(inicio date default null, fim date default null, inicio_fim char default 'N') return char,
/** [function] Retorna se o período de horário está dentro do horário do período<br>
*<b>Obs.:</b> Considera apenas horas e minutos.
*<code>
*declare
*  vperiodo period := period('10:30','12:00',formato=>'HH24:MI');
*begin
*  console.log(args(
*    vperiodo.cruzamento_horario('11:50','15:30'), -- S
*    vperiodo.cruzamento_horario('12:00','13:00'), -- S
*    vperiodo.cruzamento_horario('12:00','13:00',inicio_fim=>'S') -- N
*  ));
*end;
*</code>
* %return char (S/N)
* %param inicio varchar2
* %param fim varchar2
* %param inicio_fim char default 'N' (não cruzar último e primeiro minuto)
**/
  member function cruzamento_horario(inicio varchar2 default null, fim varchar2 default null, inicio_fim char default 'N') return char,
/** [function] Verifica se o período está totalmente dentro de um período<br>
*<code>
*declare
*  vperiodo period := period('13/01/2018','21/09/2018');
*begin
*  console.log(args(
*    vperiodo.esta_dentro(period('21/09/2018','28/09/2018')), -- N
*    vperiodo.esta_dentro(period('01/09/2018','21/09/2018')), -- S
*    vperiodo.esta_dentro(period('01/10/2018')), -- N
*    vperiodo.esta_dentro(period('01/01/2015')), -- S
*    vperiodo.esta_dentro(period(anomes=>201809)), -- N
*    vperiodo.esta_dentro(period(anomes=>201812)), -- N
*    vperiodo.esta_dentro(period(ano=>2017)), -- N
*    vperiodo.esta_dentro(period(ano=>2018)) -- S
*  ));
*end;
*</code>
* %return char (S/N)
* %param periodo period
* %param infinito char default 'N' 
* %param considerar_horario char default 'N' 
**/
  member function esta_dentro(periodo period, infinito char default 'N', considerar_horario char default 'N') return char,
/** [function] Verifica se o período está totalmente dentro de um período<br>
*<code>
*declare
*  vperiodo period := period('13/01/2018','21/09/2018');
*begin
*  console.log(args(
*    vperiodo.esta_dentro(datetime('21/09/2018'),datetime('28/09/2018')), -- N
*    vperiodo.esta_dentro(datetime('01/01/2018'),datetime('21/09/2018')), -- S
*    vperiodo.esta_dentro(datetime('01/10/2018')), -- N
*    vperiodo.esta_dentro(datetime('01/01/2015')) -- S
*  ));
*end;
*</code>
* %return char (S/N)
* %param inicio datetime 
* %param fim datetime 
* %param infinito char default 'N' 
* %param considerar_horario char default 'N' 
**/
  member function esta_dentro(inicio             datetime default datetime()
                             ,fim                datetime default datetime()
                             ,infinito           char default 'N'
                             ,considerar_horario char default 'N') return char,
/** [function] Verifica se o período está totalmente dentro de um período<br>
*<code>
*declare
*  vperiodo period := period('13/10/2018','21/09/2018');
*begin
*  console.log(args(
*    vperiodo.esta_dentro(to_date('21/09/2018'),to_date('28/09/2018')), -- N
*    vperiodo.esta_dentro(to_date('01/01/2018'),to_date('21/09/2018')), -- S
*    vperiodo.esta_dentro(to_date('01/10/2018')), -- N
*    vperiodo.esta_dentro(to_date('01/01/2015')) -- S
*  ));
*end;
*</code>
* %return char (S/N)
* %param inicio date 
* %param fim date 
* %param infinito char default 'N' 
* %param considerar_horario char default 'N' 
**/
  member function esta_dentro(inicio date default null, fim date default null, infinito char default 'N', considerar_horario char default 'N')
    return char,
/** [function] Verifica se o período está totalmente dentro de um período<br>
*<code>
*declare
*  vperiodo period := period('13/10/2018','21/09/2018');
*begin
*  console.log(args(
*    vperiodo.esta_dentro('21/09/2018','28/09/2018'), -- N
*    vperiodo.esta_dentro('01/01/2018','21/09/2018'), -- S
*    vperiodo.esta_dentro('01/10/2018'), -- N
*    vperiodo.esta_dentro('01/01/2015') -- S
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
  member function esta_dentro(inicio             varchar2 default null
                             ,fim                varchar2 default null
                             ,formato            varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                             ,infinito           char default 'N'
                             ,considerar_horario char default 'N') return char,
/** [function] Verifica se o período abrange totalmente um período<br>
*<code>
*declare
*  vperiodo period := period('13/01/2016','21/09/2018');
*begin
*  console.log(args(
*    vperiodo.abrange(period('21/09/2018','28/09/2018')), -- N
*    vperiodo.abrange(period('01/09/2018','21/09/2018')), -- S
*    vperiodo.abrange(period('01/10/2018')), -- N
*    vperiodo.abrange(period('01/01/2015')), -- N
*    vperiodo.abrange(period(anomes=>201809)), -- N
*    vperiodo.abrange(period(anomes=>201807)), -- S
*    vperiodo.abrange(period(ano=>2017)), -- S
*    vperiodo.abrange(period(ano=>2018)) -- N
*  ));
*end;
*</code>
* %return char (S/N)
* %param periodo period
* %param infinito char default 'N' 
* %param considerar_horario char default 'N' 
**/
  member function abrange(periodo period, infinito char default 'N', considerar_horario char default 'N') return char,
/** [function] Verifica se o período abrange totalmente um período<br>
*<code>
*declare
*  vperiodo period := period('13/01/2016','21/09/2018');
*begin
*  console.log(args(
*    vperiodo.abrange(datetime('21/09/2018'),datetime('28/09/2018')), -- N
*    vperiodo.abrange(datetime('01/01/2018'),datetime('21/09/2018')), -- S
*    vperiodo.abrange(datetime('01/10/2018')), -- N
*    vperiodo.abrange(datetime('01/01/2015')) -- N
*  ));
*end;
*</code>
* %return char (S/N)
* %param inicio datetime 
* %param fim datetime 
* %param infinito char default 'N' 
* %param considerar_horario char default 'N' 
**/
  member function abrange(inicio             datetime default datetime()
                         ,fim                datetime default datetime()
                         ,infinito           char default 'N'
                         ,considerar_horario char default 'N') return char,
/** [function] Verifica se o período abrange totalmente um período<br>
*<code>
*declare
*  vperiodo period := period('13/10/2016','21/09/2018');
*begin
*  console.log(args(
*    vperiodo.abrange(to_date('21/09/2018'),to_date('28/09/2018')), -- N
*    vperiodo.abrange(to_date('01/01/2018'),to_date('21/09/2018')), -- S
*    vperiodo.abrange(to_date('01/10/2018')), -- N
*    vperiodo.abrange(to_date('01/01/2015')) -- N
*  ));
*end;
*</code>
* %return char (S/N)
* %param inicio date 
* %param fim date 
* %param infinito char default 'N' 
* %param considerar_horario char default 'N' 
**/
  member function abrange(inicio date default null, fim date default null, infinito char default 'N', considerar_horario char default 'N')
    return char,
/** [function] Verifica se o período abrange totalmente um período<br>
*<code>
*declare
*  vperiodo period := period('13/10/2016','21/09/2018');
*begin
*  console.log(args(
*    vperiodo.abrange('21/09/2018','28/09/2018'), -- N
*    vperiodo.abrange('01/01/2018','21/09/2018'), -- S
*    vperiodo.abrange('01/10/2018'), -- N
*    vperiodo.abrange('01/01/2015') -- N
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
  member function abrange(inicio             varchar2 default null
                         ,fim                varchar2 default null
                         ,formato            varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                         ,infinito           char default 'N'
                         ,considerar_horario char default 'N') return char,
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
/** [function] Verifica se o período possui um ANO<br>
*<code>
*begin
*  console.log(args(
*    period('13/01/2016','21/09/2018').possui_ano(2017), -- S
*    period('01/01/2016').possui_ano(2017), -- S
*    period('01/02/2018').possui_ano(2017), -- N
*    period().possui_ano(2017), -- N
*    period().possui_ano(2017,infinito=>'S') -- S
*  ));
*end;
*</code>
* %return char (S/N)
* %param ano number 
* %param infinito char default 'N' 
**/
  member function possui_ano(ano number, infinito char default 'N') return char,
/** [function] Verifica se o período possui um ANOMES<br>
*<code>
*begin
*  console.log(args(
*    period('13/01/2016','21/09/2018').possui_anomes(201809), -- S
*    period('01/01/2016').possui_anomes(201809), -- S
*    period('01/10/2018').possui_anomes(201809), -- N
*    period().possui_anomes(201809), -- N
*    period().possui_anomes(201809,infinito=>'S') -- S
*  ));
*end;
*</code>
* %return char (S/N)
* %param anomes number 
* %param infinito char default 'N' 
**/
  member function possui_anomes(anomes number, infinito char default 'N') return char,
/** [function] Retorna se o horário está dentro do horário do período<br>
*<b>Obs.:</b> Considera apenas horas e minutos.
*<code>
*declare
*  vperiodo period := period('10:30','12:00',formato=>'HH24:MI');
*begin
*  console.log(args(
*    vperiodo.possui_horario(to_date('11:50','HH24:MI')), -- S
*    vperiodo.possui_horario(to_date('13:30','HH24:MI')) -- N
*  ));
*end;
*</code>
* %return char (S/N)
* %param data date
* %param inicio_fim char default 'N' (não cruzar último minuto)
**/
  member function possui_horario(data date, inicio_fim char default 'N') return char,
/** [function] Retorna se o horário está dentro do horário do período<br>
*<b>Obs.:</b> Considera apenas horas e minutos.
*<code>
*declare
*  vperiodo period := period('10:30','12:00',formato=>'HH24:MI');
*begin
*  console.log(args(
*    vperiodo.possui_horario('11:50'), -- S
*    vperiodo.possui_horario('13:30') -- N
*  ));
*end;
*</code>
* %return char (S/N)
* %param data varchar2
* %param inicio_fim char default 'N' (não cruzar último minuto)
**/
  member function possui_horario(data varchar2, inicio_fim char default 'N') return char,
/** [function] Retorna se o período possui dia da semana<br>
*<code>
*declare
*  vperiodo period := period('20/02/2017', '22/02/2017');
*begin
*  console.log(args(
*    vperiodo.possui_ds(2), -- S
*    vperiodo.possui_ds(5) -- N
*  ));
*end;
*</code>
* %return char (S/N)
* %param ds number 
**/
  member function possui_ds(ds number) return char,
/** [function] Retorna se o período possui dia da semana<br>
*<code>
*declare
*  vperiodo period := period('20/02/2017', '22/02/2017');
*begin
*  console.log(args(
*    vperiodo.possui_ds(argsn(2,4)), -- S
*    vperiodo.possui_ds(argsn(1,4)) -- N
*  ));
*end;
*</code>
* %return char (S/N)
* %param ds argsn default argsn()
**/
  member function possui_ds(ds argsn default argsn()) return char,
/** [function] Retorna período truncado (inicio e fim)<br>
*<code>
*declare
*  vperiodo period := period('20/02/2017 10:45:00', '22/02/2017 18:32:15');
*begin
*  console.log(args(
*    vperiodo.data_completa(), -- 20/02/2017 10:45:00 a 22/02/2017 18:32:15
*    vperiodo.trunc().data_completa() -- 20/02/2017 00:00:00 a 22/02/2017 00:00:00
*  ));
*end;
*</code>
* %return novo objeto (period)
**/
  member function trunc return period,
/** [function] Reescreve as datas em um novo formato informado<br>
*<code>
*declare -- considerando sysdate = 13/01/2019
*  vperiodo period := period('20/02/2017', '22/08/2017');
*begin
*  console.log(args(
*    vperiodo.to_char(), -- 20/02/2017 a 22/08/2017
*    vperiodo.to_format('DD/MM').to_char(), -- 20/02/2019 a 22/08/2019
*    vperiodo.to_format('MM/RRRR').to_char() -- 01/02/2017 a 31/08/2017
*  ));
*end;
*</code>
* %return novo objeto (period)
* %param formato varchar2 default 'DD/MM/RRRR' 
**/
  member function to_format(formato varchar2 default 'DD/MM/RRRR') return period,
/** [function] Extrai a informação de período em varchar2<br>
*<code>
*begin
*  console.log(args(
*    period('20/02/2017', '20/02/2017').to_char(), -- 20/02/2017
*    period('20/02/2017', '22/08/2017').to_char(), -- 20/02/2017 a 22/08/2017
*    period('20/02/2017').to_char(), -- A partir de 20/02/2017
*    period().to_char(), -- <infinito>
*    period().alterar(fim=>'22/08/2017').to_char() -- Até 22/08/2017
*  ));
*end;
*</code>
* %return varchar2
* %param formato varchar2 default 'DD/MM/RRRR' 
* %param infinito varchar2 default '<infinito>' 
* %param separador varchar2 default ' a ' 
* %param a_partir varchar2 default 'A partir de ' 
* %param ate varchar2 default 'Até ' 
**/
  member function to_char(formato   varchar2 default 'DD/MM/RRRR'
                         ,infinito  varchar2 default '<infinito>'
                         ,separador varchar2 default ' a '
                         ,a_partir  varchar2 default 'A partir de '
                         ,ate       varchar2 default 'Até ') return varchar2,
/** [function] Collection todos os dias dentro do período<br>
*<code>
*select * from table(period('31/12/2017','03/01/2018').to_table());
*select * from table(period(ano=>2016).to_table());
*select * from table(period(anomes=>201602).to_table());
*</code>
* %return argsd (collection de date)
**/
  member function to_table(exceto argsd default argsd()) return argsd,
  member function mostra(formato varchar2 default 'DD/MM/RRRR') return varchar2
)
/
create or replace type body period is

  -- Constructor
  constructor function period return self as result is
    vdata date := null;
  begin
    self.inicio := datetime(vdata);
    self.fim    := datetime(vdata);
    return;
  end;

  constructor function period(inicio   date
                             ,fim      date default null
                             ,anos     number default null
                             ,meses    number default null
                             ,dias     number default null
                             ,horas    number default null
                             ,minutos  number default null
                             ,segundos number default null
                             ,infinito char default 'S') return self as result is
    dia_desc number := 0;
  begin
    self.inicio := datetime(inicio);
    self.fim    := datetime(fim);
    -- verifica fim infinito
    if fim is null then
      if infinito like 'FM' then
        self.fim.data := last_day(self.inicio.data);
      elsif infinito like 'N' then
        self.fim := self.inicio;
      end if;
    end if;
    -- --
    if dias is not null or
       meses is not null or
       anos is not null or
       horas is not null or
       minutos is not null or
       segundos is not null then
      if self.fim.data is null then
        self.fim := self.inicio;
        if horas is null and
           minutos is null and
           segundos is null then
          dia_desc := 1;
        end if;
      end if;
      self.fim.adicionar(anos, meses, standard.nvl(dias, 0) - dia_desc, horas, minutos, segundos);
    end if;
    return;
  end;

  constructor function period(inicio   varchar2
                             ,fim      varchar2 default null
                             ,anos     number default null
                             ,meses    number default null
                             ,dias     number default null
                             ,horas    number default null
                             ,minutos  number default null
                             ,segundos number default null
                             ,infinito char default 'S'
                             ,formato  varchar2 default 'DD/MM/RRRR HH24:MI:SS') return self as result is
    dia_desc number := 0;
  begin
    if formato <> 'ISO8601' then
      self.inicio := datetime(standard.to_date(inicio, formato));
      self.fim    := datetime(standard.to_date(fim, formato));
    else
      self.inicio := datetime(inicio, formato);
      self.fim    := datetime(fim, formato);
    end if;
    -- verifica fim infinito
    if fim is null then
      if infinito like 'FM' then
        self.fim.data := last_day(self.inicio.data);
      elsif infinito like 'N' then
        self.fim := self.inicio;
      end if;
    elsif instr(upper(formato), 'DD') = 0 and
          formato <> 'ISO8601' then
      -- ajusta fim quando nao tem dia no formato
      self.fim.data := last_day(self.fim.data);
    end if;
    -- --
    if dias is not null or
       meses is not null or
       anos is not null or
       horas is not null or
       minutos is not null or
       segundos is not null then
      if self.fim.data is null then
        self.fim := self.inicio;
        if horas is null and
           minutos is null and
           segundos is null then
          dia_desc := 1;
        end if;
      end if;
      self.fim.adicionar(anos, meses, standard.nvl(dias, 0) - dia_desc, horas, minutos, segundos);
    end if;
    return;
  end;

  constructor function period(ano number) return self as result is
  begin
    if ano is not null then
      self.inicio := datetime(lpad(ano, 4, '0') || '0101', 'RRRRMMDD');
      self.fim    := datetime(lpad(ano, 4, '0') || '1231', 'RRRRMMDD');
    else
      self.inicio := datetime();
      self.fim    := datetime();
    end if;
    return;
  end;

  constructor function period(anomes number, dia_inicio number default 1) return self as result is
  begin
    if anomes is not null then
      self.inicio := datetime(lpad(anomes, 6, '0') || lpad(dia_inicio, 2, '0'), 'RRRRMMDD');
      self.fim    := datetime(last_day(self.inicio.data));
    else
      self.inicio := datetime();
      self.fim    := datetime();
    end if;
    return;
  end;

  constructor function period(mes number, ano number default null, dia_inicio number default 1) return self as result is
  begin
    if mes is not null then
      self.inicio := datetime(dia => dia_inicio, mes => mes, ano => ano);
      self.fim    := datetime(last_day(self.inicio.data));
    else
      self.inicio := datetime();
      self.fim    := datetime();
    end if;
    return;
  end;

  constructor function period(dia number, mes number default null, ano number default null, fim_mes char default 'N') return self as result is
  begin
    if dia is not null then
      self.inicio := datetime(dia => dia, mes => mes, ano => ano);
      if fim_mes like 'N' then
        self.fim := self.inicio;
      else
        self.fim := datetime(last_day(self.inicio.data));
      end if;
    else
      self.inicio := datetime();
      self.fim    := datetime();
    end if;
    return;
  end;

  constructor function period(inicio date, dias_uteis number, list_feriados argsd default argsd()) return self as result is
  begin
    self.inicio := datetime(inicio);
    self.fim    := self.inicio;
    -- --
    self.fim.adicionar(dias_uteis => dias_uteis - 1, list_feriados => list_feriados);
    return;
  end;

  constructor function period(inicio        date
                             ,dias_uteis    number
                             ,list_feriados varchar2
                             ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                             ,separador     char default ';') return self as result is
  begin
    self.inicio := datetime(inicio);
    self.fim    := self.inicio;
    -- --
    self.fim.adicionar(dias_uteis => dias_uteis - 1, list_feriados => list_feriados, formato => formato, separador => separador);
    return;
  end;

  constructor function period(inicio        varchar2
                             ,dias_uteis    number
                             ,list_feriados argsd default argsd()
                             ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS') return self as result is
  begin
    self.inicio := datetime(inicio, formato);
    self.fim    := self.inicio;
    -- --
    self.fim.adicionar(dias_uteis => dias_uteis - 1, list_feriados => list_feriados);
    return;
  end;

  constructor function period(inicio        varchar2
                             ,dias_uteis    number
                             ,list_feriados varchar2
                             ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                             ,separador     char default ';') return self as result is
  begin
    self.inicio := datetime(inicio, formato);
    self.fim    := self.inicio;
    -- --
    self.fim.adicionar(dias_uteis => dias_uteis - 1, list_feriados => list_feriados, formato => formato, separador => separador);
    return;
  end;

  -- Member procedures and functions
  member procedure atribuir(self in out nocopy period, inicio datetime default datetime(), fim datetime default datetime(), limpar char default 'N') is
  begin
    if inicio.data is not null or
       limpar like 'S' then
      self.inicio := inicio;
    end if;
    -- --
    if fim.data is not null or
       limpar like 'S' then
      self.fim := fim;
    end if;
  end atribuir;

  member procedure atribuir(inicio date default null, fim date default null, limpar char default 'N') is
  begin
    atribuir(datetime(inicio), datetime(fim), limpar);
  end atribuir;

  member procedure atribuir(inicio  varchar2 default null
                           ,fim     varchar2 default null
                           ,formato varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                           ,limpar  char default 'N') is
  begin
    atribuir(datetime(inicio, formato), datetime(fim, formato), limpar);
  end atribuir;

  member function alterar(inicio datetime default datetime(), fim datetime default datetime(), limpar char default 'N') return period is
    result period := self;
  begin
    if inicio.data is not null or
       limpar like 'S' then
      result.inicio := inicio;
    end if;
    -- --
    if fim.data is not null or
       limpar like 'S' then
      result.fim := fim;
    end if;
    return result;
  end alterar;

  member function alterar(inicio date default null, fim date default null, limpar char default 'N') return period is
  begin
    return alterar(datetime(inicio), datetime(fim), limpar);
  end alterar;

  member function alterar(inicio  varchar2 default null
                         ,fim     varchar2 default null
                         ,formato varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                         ,limpar  char default 'N') return period is
  begin
    return alterar(datetime(inicio, formato), datetime(fim, formato), limpar);
  end alterar;

  member function limpar(ano     char default 'N'
                        ,mes     char default 'N'
                        ,dia     char default 'N'
                        ,hora    char default 'N'
                        ,minuto  char default 'N'
                        ,segundo char default 'N'
                        ,horario char default 'N') return period is
  begin
    return period(self.inicio.limpar(ano, mes, dia, hora, minuto, segundo, horario), self.fim.limpar(ano, mes, dia, hora, minuto, segundo, horario));
  end limpar;

  member procedure limpar(self    in out nocopy period
                         ,ano     boolean default false
                         ,mes     boolean default false
                         ,dia     boolean default false
                         ,hora    boolean default false
                         ,minuto  boolean default false
                         ,segundo boolean default false
                         ,horario boolean default false) is
  begin
    self.inicio.limpar(ano, mes, dia, hora, minuto, segundo, horario);
    self.fim.limpar(ano, mes, dia, hora, minuto, segundo, horario);
  end limpar;

  member function limpar_inicio(ano     char default 'N'
                               ,mes     char default 'N'
                               ,dia     char default 'N'
                               ,hora    char default 'N'
                               ,minuto  char default 'N'
                               ,segundo char default 'N'
                               ,horario char default 'N') return period is
  begin
    return period(self.inicio.limpar(ano, mes, dia, hora, minuto, segundo, horario), self.fim);
  end limpar_inicio;

  member procedure limpar_inicio(self    in out nocopy period
                                ,ano     boolean default false
                                ,mes     boolean default false
                                ,dia     boolean default false
                                ,hora    boolean default false
                                ,minuto  boolean default false
                                ,segundo boolean default false
                                ,horario boolean default false) is
  begin
    self.inicio.limpar(ano, mes, dia, hora, minuto, segundo, horario);
  end limpar_inicio;

  member function limpar_fim(ano     char default 'N'
                            ,mes     char default 'N'
                            ,dia     char default 'N'
                            ,hora    char default 'N'
                            ,minuto  char default 'N'
                            ,segundo char default 'N'
                            ,horario char default 'N') return period is
  begin
    return period(self.inicio, self.fim.limpar(ano, mes, dia, hora, minuto, segundo, horario));
  end limpar_fim;

  member procedure limpar_fim(self    in out nocopy period
                             ,ano     boolean default false
                             ,mes     boolean default false
                             ,dia     boolean default false
                             ,hora    boolean default false
                             ,minuto  boolean default false
                             ,segundo boolean default false
                             ,horario boolean default false) is
  begin
    self.fim.limpar(ano, mes, dia, hora, minuto, segundo, horario);
  end limpar_fim;

  member function limpar_horario return period is
  begin
    return period(self.inicio.limpar_horario, self.fim.limpar_horario);
  end;

  member procedure limpar_horario is
  begin
    self.inicio.limpar_horario;
    self.fim.limpar_horario;
  end;

  member function limitar(periodo period) return period is
  begin
    if periodo.inicio.data > self.fim.data or
       periodo.fim.data < self.inicio.data then
      return self;
    else
      return period(greatest(standard.nvl(periodo.inicio.data, self.inicio.data), self.inicio_nvl().data),
                    least(standard.nvl(periodo.fim.data, self.fim.data), self.fim_nvl().data));
    end if;
  end limitar;

  member function limitar(inicio datetime default datetime(), fim datetime default datetime()) return period is
  begin
    return limitar(period(inicio, fim));
  end limitar;

  member function limitar(inicio date default null, fim date default null) return period is
  begin
    return limitar(period(datetime(inicio), datetime(fim)));
  end limitar;

  member function limitar(inicio varchar2 default null, fim varchar2 default null, formato varchar2 default 'DD/MM/RRRR HH24:MI:SS') return period is
  begin
    return limitar(period(datetime(inicio, formato), datetime(fim, formato)));
  end limitar;

  member function adicionar(anos     number default null
                           ,meses    number default null
                           ,dias     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null) return period is
  begin
    return period(self.inicio.adicionar(anos, meses, dias, horas, minutos, segundos), self.fim.adicionar(anos, meses, dias, horas, minutos, segundos));
  end adicionar;

  member procedure adicionar(self     in out nocopy period
                            ,anos     number default null
                            ,meses    number default null
                            ,dias     number default null
                            ,horas    number default null
                            ,minutos  number default null
                            ,segundos number default null) is
  begin
    self.inicio.adicionar(anos, meses, dias, horas, minutos, segundos);
    self.fim.adicionar(anos, meses, dias, horas, minutos, segundos);
  end adicionar;

  member function adicionar(dias_uteis number, list_feriados argsd default argsd()) return period is
  begin
    return period(self.inicio.adicionar(dias_uteis => dias_uteis, list_feriados => list_feriados),
                  self.fim.adicionar(dias_uteis => dias_uteis, list_feriados => list_feriados));
  end;

  member procedure adicionar(self in out nocopy period, dias_uteis number, list_feriados argsd default argsd()) is
  begin
    self.inicio.adicionar(dias_uteis => dias_uteis, list_feriados => list_feriados);
    self.fim.adicionar(dias_uteis => dias_uteis, list_feriados => list_feriados);
  end;

  member function adicionar(dias_uteis number, list_feriados varchar2, formato varchar2 default 'DD/MM/RRRR HH24:MI:SS', separador char default ';')
    return period is
  begin
    return period(self.inicio.adicionar(dias_uteis => dias_uteis, list_feriados => list_feriados, formato => formato, separador => separador),
                  self.fim.adicionar(dias_uteis => dias_uteis, list_feriados => list_feriados, formato => formato, separador => separador));
  end;

  member procedure adicionar(self          in out nocopy period
                            ,dias_uteis    number
                            ,list_feriados varchar2
                            ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                            ,separador     char default ';') is
  begin
    self.inicio.adicionar(dias_uteis => dias_uteis, list_feriados => list_feriados, formato => formato, separador => separador);
    self.fim.adicionar(dias_uteis => dias_uteis, list_feriados => list_feriados, formato => formato, separador => separador);
  end;

  member function add_inicio(anos     number default null
                            ,meses    number default null
                            ,dias     number default null
                            ,horas    number default null
                            ,minutos  number default null
                            ,segundos number default null) return period is
  begin
    return period(self.inicio.adicionar(anos, meses, dias, horas, minutos, segundos), self.fim);
  end add_inicio;

  member procedure add_inicio(self     in out nocopy period
                             ,anos     number default null
                             ,meses    number default null
                             ,dias     number default null
                             ,horas    number default null
                             ,minutos  number default null
                             ,segundos number default null) is
  begin
    self.inicio.adicionar(anos, meses, dias, horas, minutos, segundos);
  end add_inicio;

  member function add_inicio(dias_uteis number, list_feriados argsd default argsd()) return period is
  begin
    return period(self.inicio.adicionar(dias_uteis => dias_uteis, list_feriados => list_feriados), self.fim);
  end;

  member procedure add_inicio(self in out nocopy period, dias_uteis number, list_feriados argsd default argsd()) is
  begin
    self.inicio.adicionar(dias_uteis => dias_uteis, list_feriados => list_feriados);
  end;

  member function add_inicio(dias_uteis number, list_feriados varchar2, formato varchar2 default 'DD/MM/RRRR HH24:MI:SS', separador char default ';')
    return period is
  begin
    return period(self.inicio.adicionar(dias_uteis => dias_uteis, list_feriados => list_feriados, formato => formato, separador => separador),
                  self.fim);
  end;

  member procedure add_inicio(self          in out nocopy period
                             ,dias_uteis    number
                             ,list_feriados varchar2
                             ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                             ,separador     char default ';') is
  begin
    self.inicio.adicionar(dias_uteis => dias_uteis, list_feriados => list_feriados, formato => formato, separador => separador);
  end;

  member function add_fim(anos     number default null
                         ,meses    number default null
                         ,dias     number default null
                         ,horas    number default null
                         ,minutos  number default null
                         ,segundos number default null) return period is
  begin
    return period(self.inicio, self.fim.adicionar(anos, meses, dias, horas, minutos, segundos));
  end add_fim;

  member procedure add_fim(self     in out nocopy period
                          ,anos     number default null
                          ,meses    number default null
                          ,dias     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null) is
  begin
    self.fim.adicionar(anos, meses, dias, horas, minutos, segundos);
  end add_fim;

  member function add_fim(dias_uteis number, list_feriados argsd default argsd()) return period is
  begin
    return period(self.inicio, self.fim.adicionar(dias_uteis => dias_uteis, list_feriados => list_feriados));
  end;

  member procedure add_fim(self in out nocopy period, dias_uteis number, list_feriados argsd default argsd()) is
  begin
    self.fim.adicionar(dias_uteis => dias_uteis, list_feriados => list_feriados);
  end;

  member function add_fim(dias_uteis number, list_feriados varchar2, formato varchar2 default 'DD/MM/RRRR HH24:MI:SS', separador char default ';')
    return period is
  begin
    return period(self.inicio,
                  self.fim.adicionar(dias_uteis => dias_uteis, list_feriados => list_feriados, formato => formato, separador => separador));
  end;

  member procedure add_fim(self          in out nocopy period
                          ,dias_uteis    number
                          ,list_feriados varchar2
                          ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                          ,separador     char default ';') is
  begin
    self.fim.adicionar(dias_uteis => dias_uteis, list_feriados => list_feriados, formato => formato, separador => separador);
  end;

  member function subtrair(anos     number default null
                          ,meses    number default null
                          ,dias     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null) return period is
  begin
    return period(self.inicio.subtrair(anos, meses, dias, horas, minutos, segundos), self.fim.subtrair(anos, meses, dias, horas, minutos, segundos));
  end subtrair;

  member procedure subtrair(self     in out nocopy period
                           ,anos     number default null
                           ,meses    number default null
                           ,dias     number default null
                           ,horas    number default null
                           ,minutos  number default null
                           ,segundos number default null) is
  begin
    self.inicio.subtrair(anos, meses, dias, horas, minutos, segundos);
    self.fim.subtrair(anos, meses, dias, horas, minutos, segundos);
  end subtrair;

  member function subtrair(dias_uteis number, list_feriados argsd default argsd()) return period is
  begin
    return period(self.inicio.subtrair(dias_uteis => dias_uteis, list_feriados => list_feriados),
                  self.fim.subtrair(dias_uteis => dias_uteis, list_feriados => list_feriados));
  end;

  member procedure subtrair(self in out nocopy period, dias_uteis number, list_feriados argsd default argsd()) is
  begin
    self.inicio.subtrair(dias_uteis => dias_uteis, list_feriados => list_feriados);
    self.fim.subtrair(dias_uteis => dias_uteis, list_feriados => list_feriados);
  end;

  member function subtrair(dias_uteis number, list_feriados varchar2, formato varchar2 default 'DD/MM/RRRR HH24:MI:SS', separador char default ';')
    return period is
  begin
    return period(self.inicio.subtrair(dias_uteis => dias_uteis, list_feriados => list_feriados, formato => formato, separador => separador),
                  self.fim.subtrair(dias_uteis => dias_uteis, list_feriados => list_feriados, formato => formato, separador => separador));
  end;

  member procedure subtrair(self          in out nocopy period
                           ,dias_uteis    number
                           ,list_feriados varchar2
                           ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                           ,separador     char default ';') is
  begin
    self.inicio.subtrair(dias_uteis => dias_uteis, list_feriados => list_feriados, formato => formato, separador => separador);
    self.fim.subtrair(dias_uteis => dias_uteis, list_feriados => list_feriados, formato => formato, separador => separador);
  end;

  member function sub_inicio(anos     number default null
                            ,meses    number default null
                            ,dias     number default null
                            ,horas    number default null
                            ,minutos  number default null
                            ,segundos number default null) return period is
  begin
    return period(self.inicio.subtrair(anos, meses, dias, horas, minutos, segundos), self.fim);
  end sub_inicio;

  member procedure sub_inicio(self     in out nocopy period
                             ,anos     number default null
                             ,meses    number default null
                             ,dias     number default null
                             ,horas    number default null
                             ,minutos  number default null
                             ,segundos number default null) is
  begin
    self.inicio.subtrair(anos, meses, dias, horas, minutos, segundos);
  end sub_inicio;

  member function sub_inicio(dias_uteis number, list_feriados argsd default argsd()) return period is
  begin
    return period(self.inicio.subtrair(dias_uteis => dias_uteis, list_feriados => list_feriados), self.fim);
  end;

  member procedure sub_inicio(self in out nocopy period, dias_uteis number, list_feriados argsd default argsd()) is
  begin
    self.inicio.subtrair(dias_uteis => dias_uteis, list_feriados => list_feriados);
  end;

  member function sub_inicio(dias_uteis number, list_feriados varchar2, formato varchar2 default 'DD/MM/RRRR HH24:MI:SS', separador char default ';')
    return period is
  begin
    return period(self.inicio.subtrair(dias_uteis => dias_uteis, list_feriados => list_feriados, formato => formato, separador => separador),
                  self.fim);
  end;

  member procedure sub_inicio(self          in out nocopy period
                             ,dias_uteis    number
                             ,list_feriados varchar2
                             ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                             ,separador     char default ';') is
  begin
    self.inicio.subtrair(dias_uteis => dias_uteis, list_feriados => list_feriados, formato => formato, separador => separador);
  end;

  member function sub_fim(anos     number default null
                         ,meses    number default null
                         ,dias     number default null
                         ,horas    number default null
                         ,minutos  number default null
                         ,segundos number default null) return period is
  begin
    return period(self.inicio, self.fim.subtrair(anos, meses, dias, horas, minutos, segundos));
  end sub_fim;

  member procedure sub_fim(self     in out nocopy period
                          ,anos     number default null
                          ,meses    number default null
                          ,dias     number default null
                          ,horas    number default null
                          ,minutos  number default null
                          ,segundos number default null) is
  begin
    self.fim.subtrair(anos, meses, dias, horas, minutos, segundos);
  end sub_fim;

  member function sub_fim(dias_uteis number, list_feriados argsd default argsd()) return period is
  begin
    return period(self.inicio, self.fim.subtrair(dias_uteis => dias_uteis, list_feriados => list_feriados));
  end;

  member procedure sub_fim(self in out nocopy period, dias_uteis number, list_feriados argsd default argsd()) is
  begin
    self.fim.subtrair(dias_uteis => dias_uteis, list_feriados => list_feriados);
  end;

  member function sub_fim(dias_uteis number, list_feriados varchar2, formato varchar2 default 'DD/MM/RRRR HH24:MI:SS', separador char default ';')
    return period is
  begin
    return period(self.inicio,
                  self.fim.subtrair(dias_uteis => dias_uteis, list_feriados => list_feriados, formato => formato, separador => separador));
  end;

  member procedure sub_fim(self          in out nocopy period
                          ,dias_uteis    number
                          ,list_feriados varchar2
                          ,formato       varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                          ,separador     char default ';') is
  begin
    self.fim.subtrair(dias_uteis => dias_uteis, list_feriados => list_feriados, formato => formato, separador => separador);
  end;

  member function nulo return char is
  begin
    if (self.inicio.data is null and self.fim.data is null) then
      return 'S';
    else
      return 'N';
    end if;
  end;

  member function nao_nulo return char is
  begin
    if not (self.inicio.data is null and self.fim.data is null) then
      return 'S';
    else
      return 'N';
    end if;
  end;

  member function inicio_nulo return char is
  begin
    if self.inicio.data is null then
      return 'S';
    else
      return 'N';
    end if;
  end;

  member function fim_nulo return char is
  begin
    if self.fim.data is null then
      return 'S';
    else
      return 'N';
    end if;
  end;

  member function nvl(inicio date default '01/01/0001', fim date default '31/12/9999') return period is
  begin
    return period(datetime(standard.nvl(self.inicio.data, inicio)), datetime(standard.nvl(self.fim.data, fim)));
  end;

  member function inicio_nvl(data date default '01/01/0001') return datetime is
  begin
    if self.inicio.data is null then
      return datetime(data);
    else
      return self.inicio;
    end if;
  end;

  member function fim_nvl(data date default '31/12/9999') return datetime is
  begin
    if self.fim.data is null then
      return datetime(data);
    else
      return self.fim;
    end if;
  end;

  member function fim_menor return char is
  begin
    if self.fim.data < self.inicio.data then
      return 'S';
    else
      return 'N';
    end if;
  end;

  member function dias(contar_dia_inicial char default 'S') return number is
    result number;
  begin
    result := standard.trunc(fim_nvl().data - inicio_nvl().data);
    -- se é apenas data conta dia completo
    if contar_dia_inicial like 'S' and
       inicio_nvl().horario_num + fim_nvl().horario_num = 0 then
      result := result + 1;
    end if;
    -- --
    return result;
  end;

  member function meses(contar_dia_inicial char default 'S') return number is
    vdia_ini number := 0;
  begin
    if contar_dia_inicial like 'S' and
       inicio_nvl().horario_num + fim_nvl().horario_num = 0 then
      vdia_ini := 1;
    end if;
    return standard.trunc(months_between(fim_nvl().adicionar(dias => vdia_ini).data, inicio_nvl().data));
  end;

  member function anos(contar_dia_inicial char default 'S') return number is
    vdia_ini number := 0;
  begin
    if contar_dia_inicial like 'S' and
       inicio_nvl().horario_num + fim_nvl().horario_num = 0 then
      vdia_ini := 1;
    end if;
    return standard.trunc(months_between(fim_nvl().adicionar(dias => vdia_ini).data, inicio_nvl().data) / 12);
  end;

  member function horas(contar_dia_inicial char default 'S') return number is
    vdia_ini number := 0;
  begin
    if contar_dia_inicial like 'S' and
       inicio_nvl().horario_num + fim_nvl().horario_num = 0 then
      vdia_ini := 1;
    end if;
    return standard.trunc(((fim_nvl().data - inicio_nvl().data + vdia_ini) * 24) + 1.15740740740741e-8);
  end;

  member function minutos(contar_dia_inicial char default 'S') return number is
    vdia_ini number := 0;
  begin
    if contar_dia_inicial like 'S' and
       inicio_nvl().horario_num + fim_nvl().horario_num = 0 then
      vdia_ini := 1;
    end if;
    return standard.trunc(((fim_nvl().data - inicio_nvl().data + vdia_ini) * 24 * 60) + 1.15740740740741e-8);
  end;

  member function segundos(contar_dia_inicial char default 'S') return number is
    vdia_ini number := 0;
  begin
    if contar_dia_inicial like 'S' and
       inicio_nvl().horario_num + fim_nvl().horario_num = 0 then
      vdia_ini := 1;
    end if;
    return standard.trunc(((fim_nvl().data - inicio_nvl().data + vdia_ini) * 24 * 60 * 60) + 1.15740740740741e-8);
  end;

  member function tempo(contar_bissexto char default 'N', resumido char default 'N', em_horas char default 'N', separador char default ':')
    return varchar2 is
    result      varchar2(500);
    ano         number := 0;
    mes         number := 0;
    dia         number := 0;
    hora        number := 0;
    minuto      number := 0;
    segundo     number := 0;
    meses_total number := 0;
    diff        date;
  begin
    -- Obtém os períodos de ano, mês, dia, hora, minuto e segundo
    diff := to_date('01/01/0001 00:00:00', 'DD/MM/RRRR HH24:MI:SS') + (fim_nvl().data - inicio_nvl().data + 1);
    -- --
    if em_horas like 'N' then
      hora    := standard.to_char(diff, 'HH24');
      minuto  := standard.to_char(diff, 'MI');
      segundo := standard.to_char(diff, 'SS');
    
      -- verifica total de meses
      meses_total := meses();
      -- ajusta ano e mes
      ano := standard.trunc(meses_total / 12);
      mes := mod(meses_total, 12);
      -- ajusta dia
      if meses_total = 0 then
        dia := self.dias();
      else
        declare
          ini_aux datetime := self.inicio.adicionar(meses => meses_total);
        begin
          if self.fim.data = self.fim.ultimo().data and
             self.inicio.dia <> 1 then
            dia := period(self.inicio, self.inicio.ultimo).dias();
            if contar_bissexto like 'N' and
               self.inicio.mes = 2 and
               self.inicio.bissexto like 'S' then
              dia := dia - 1;
            end if;
          elsif ini_aux.data - 1 > self.fim.data then
            dia := period(self.fim, ini_aux).dias();
          elsif ini_aux.data - 1 < self.fim.data then
            dia := period(ini_aux, self.fim).dias();
          end if;
        end;
      end if;
    else
      hora    := horas();
      minuto  := standard.to_char(diff, 'MI');
      segundo := standard.to_char(diff, 'SS');
    end if;
  
    if em_horas like 'S' then
      -- EM HORAS
    
      -- horas:minutos:segundos
      if (hora + minuto + segundo <> 0) then
        result := result || standard.to_char(hora, 'FM99999999999999999900') || separador || lpad(minuto, 2, '0') || case
                    when segundo <> 0 then
                     separador || lpad(segundo, 2, '0')
                    else
                     null
                  end;
      end if;
    
    elsif resumido like 'S' then
      -- RESUMIDO
    
      -- Plural de ano
      if ano > 0 then
        result := result || ano || 'a ';
      end if;
    
      -- Plural de mês
      if mes > 0 then
        result := result || mes || 'm ';
      end if;
    
      -- Plural de dia
      if (dia > 0) then
        result := result || dia || 'd ';
      end if;
    
      -- horas:minutos:segundos
      if (hora + minuto + segundo <> 0) then
        result := result || lpad(hora, 2, '0') || separador || lpad(minuto, 2, '0') || separador || lpad(segundo, 2, '0');
      end if;
    
    else
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
    end if;
  
    return trim(result);
  exception
    when others then
      return null;
  end;

  member function data_completa return varchar2 is
  begin
    return replace(to_char('DD/MM/RRRR HH24:MI:SS'), ' 00:00:00');
  end;

  member function ds(formato varchar2 default 'D', separador varchar2 default ',') return varchar2 is
    result   varchar2(1000);
    vperiodo period := self.trunc();
  begin
    if self.dias >= 7 then
      result := trim(standard.to_char(to_date(1 || '/05/0001', 'DD/MM/RRRR'), formato)) || separador ||
                trim(standard.to_char(to_date(2 || '/05/0001', 'DD/MM/RRRR'), formato)) || separador ||
                trim(standard.to_char(to_date(3 || '/05/0001', 'DD/MM/RRRR'), formato)) || separador ||
                trim(standard.to_char(to_date(4 || '/05/0001', 'DD/MM/RRRR'), formato)) || separador ||
                trim(standard.to_char(to_date(5 || '/05/0001', 'DD/MM/RRRR'), formato)) || separador ||
                trim(standard.to_char(to_date(6 || '/05/0001', 'DD/MM/RRRR'), formato)) || separador ||
                trim(standard.to_char(to_date(7 || '/05/0001', 'DD/MM/RRRR'), formato));
    else
      for i in 1 .. vperiodo.fim.data - vperiodo.inicio.data + 1
      loop
        result := result || trim(standard.to_char(vperiodo.inicio.data - 1 + i, formato)) || separador;
      end loop;
      result := rtrim(result, separador);
    end if;
    return result;
  end;

  member function dias_fds return number is
    periodo period := period(inicio_nvl(), fim_nvl());
    per_aux period := periodo;
    ds_ini  number := periodo.inicio.ds;
    ds_fim  number := periodo.fim.ds;
    result  number := 0;
  begin
    -- ajuste de periodo_aux ini
    if ds_ini between 2 and 6 then
      per_aux.inicio.adicionar(dias => 7 - ds_ini);
    end if;
    -- ajuste de periodo_aux fim    
    if ds_fim between 2 and 6 then
      per_aux.fim.subtrair(dias => ds_fim - 1);
    end if;
    -- se inicio for maior que fim retorna 0
    if per_aux.fim_menor like 'S' then
      return 0;
    end if;
    -- ds de ini e fim    
    ds_ini := per_aux.inicio.ds;
    ds_fim := per_aux.fim.ds;
    -- contagem inicial
    result := standard.trunc(per_aux.dias() / 7) * 2;
    -- ajuste 1 dia
    if (ds_ini = 1 and ds_fim = 1) or
       (ds_ini = 7 and ds_fim = 7) then
      result := result + 1;
    elsif (ds_ini = 7 and ds_fim = 1) then
      result := result + 2;
    end if;
    -- --
    return result;
  end;

  member function dias_semana return number is
  begin
    return self.dias - self.dias_fds;
  end;

  member function dias_feriado(list_feriados argsd default argsd()) return number is
  begin
    return listar_feriados(list_feriados).count;
  end;

  member function dias_feriado_semana(list_feriados argsd default argsd()) return number is
    vinicio       date := standard.trunc(self.inicio_nvl().data);
    vfim          date := standard.trunc(self.fim_nvl().data);
    lferiados     argsd;
    vqtd_feriados number := 0;
  begin
    -- verifica feriados
    if list_feriados is not null and
       list_feriados is not empty then
      lferiados := list_feriados;
    else
      lferiados := datetime.feriados(vinicio, vfim);
    end if;
    -- --
    if lferiados is not null and
       lferiados is not empty then
      for i in lferiados.first .. lferiados.last
      loop
        -- verifica se esta no periodo
        if lferiados(i) between vinicio and vfim and
           standard.to_char(lferiados(i), 'D') between 2 and 6 then
          vqtd_feriados := vqtd_feriados + 1;
        end if;
      end loop;
    end if;
    -- resultado
    return vqtd_feriados;
    -- --
  end;

  member function dias_feriado_fds(list_feriados argsd default argsd()) return number is
    vinicio       date := standard.trunc(self.inicio_nvl().data);
    vfim          date := standard.trunc(self.fim_nvl().data);
    lferiados     argsd;
    vqtd_feriados number := 0;
  begin
    -- verifica feriados
    if list_feriados is not null and
       list_feriados is not empty then
      lferiados := list_feriados;
    else
      lferiados := datetime.feriados(vinicio, vfim);
    end if;
    -- --
    if lferiados is not null and
       lferiados is not empty then
      for i in lferiados.first .. lferiados.last
      loop
        -- verifica se esta no periodo
        if lferiados(i) between vinicio and vfim and
           standard.to_char(lferiados(i), 'D') in (1, 7) then
          vqtd_feriados := vqtd_feriados + 1;
        end if;
      end loop;
    end if;
    -- resultado
    return vqtd_feriados;
    -- --
  end;

  member function dias_uteis(list_feriados argsd default argsd()) return number is
  begin
    return dias_semana - dias_feriado_semana(list_feriados);
  end;

  member function listar_dias_fds return argsd is
    vinicio date := standard.trunc(self.inicio_nvl().data);
    vfim    date := standard.trunc(self.fim_nvl().data);
    result  argsd := argsd();
    vdata   date;
  begin
    for i in 1 .. vfim - vinicio + 1
    loop
      vdata := vinicio - 1 + i;
      -- verifica se é fds
      if standard.to_char(vdata, 'D') in (1, 7) then
        result.extend;
        result(result.last) := vdata;
      end if;
      -- --
    end loop;
    return result;
  end;

  member function listar_dias_semana return argsd is
    vinicio date := standard.trunc(self.inicio_nvl().data);
    vfim    date := standard.trunc(self.fim_nvl().data);
    result  argsd := argsd();
    vdata   date;
  begin
    for i in 1 .. vfim - vinicio + 1
    loop
      vdata := vinicio - 1 + i;
      -- verifica se é fds
      if standard.to_char(vdata, 'D') between 2 and 6 then
        result.extend;
        result(result.last) := vdata;
      end if;
      -- --
    end loop;
    return result;
  end;

  member function listar_feriados(list_feriados argsd default argsd()) return argsd is
    vinicio date := standard.trunc(self.inicio_nvl().data);
    vfim    date := standard.trunc(self.fim_nvl().data);
    result  argsd := argsd();
  begin
    -- verifica feriados
    if list_feriados is not null and
       list_feriados is not empty then
      for i in list_feriados.first .. list_feriados.last
      loop
        -- verifica se esta no periodo
        if list_feriados(i) between vinicio and vfim then
          result.extend;
          result(result.last) := list_feriados(i);
        end if;
      end loop;
    else
      return datetime.feriados(vinicio, vfim);
    end if;
  end;

  member function listar_feriados_semana(list_feriados argsd default argsd()) return argsd is
    vinicio   date := standard.trunc(self.inicio_nvl().data);
    vfim      date := standard.trunc(self.fim_nvl().data);
    result    argsd := argsd();
    lferiados argsd;
  begin
    -- verifica feriados
    if list_feriados is not null and
       list_feriados is not empty then
      lferiados := list_feriados;
    else
      lferiados := datetime.feriados(vinicio, vfim);
    end if;
    -- --
    if lferiados is not null and
       lferiados is not empty then
      for i in lferiados.first .. lferiados.last
      loop
        -- verifica se esta no periodo
        if lferiados(i) between vinicio and vfim and
           standard.to_char(lferiados(i), 'D') between 2 and 6 then
          result.extend;
          result(result.last) := lferiados(i);
        end if;
      end loop;
    end if;
    return result;
  end;

  member function listar_feriados_fds(list_feriados argsd default argsd()) return argsd is
    vinicio   date := standard.trunc(self.inicio_nvl().data);
    vfim      date := standard.trunc(self.fim_nvl().data);
    result    argsd := argsd();
    lferiados argsd;
  begin
    -- verifica feriados
    if list_feriados is not null and
       list_feriados is not empty then
      lferiados := list_feriados;
    else
      lferiados := datetime.feriados(vinicio, vfim);
    end if;
    -- --
    if lferiados is not null and
       lferiados is not empty then
      for i in lferiados.first .. lferiados.last
      loop
        -- verifica se esta no periodo
        if lferiados(i) between vinicio and vfim and
           standard.to_char(lferiados(i), 'D') in (1, 7) then
          result.extend;
          result(result.last) := lferiados(i);
        end if;
      end loop;
    end if;
    return result;
  end;

  member function listar_dias_uteis(list_feriados argsd default argsd()) return argsd is
  begin
    return listar_dias_semana multiset except listar_feriados_semana(list_feriados);
  end;

  member function listar_ds return argsn is
    result   argsn := argsn();
    vperiodo period := self.trunc();
  begin
    if self.dias >= 7 then
      result := argsn(1, 2, 3, 4, 5, 6, 7);
    else
      for i in 1 .. vperiodo.fim.data - vperiodo.inicio.data + 1
      loop
        result.extend;
        result(result.last) := standard.to_char(vperiodo.inicio.data - 1 + i, 'D');
      end loop;
    end if;
    return result;
  end;

  member function cruzamento(periodo period, infinito char default 'N', considerar_horario char default 'N') return char is
    vdata_ini1 date;
    vdata_fim1 date;
    vdata_ini2 date;
    vdata_fim2 date;
  begin
    if considerar_horario like 'N' then
      vdata_ini1 := self.inicio_nvl().trunc();
      vdata_fim1 := self.fim_nvl().trunc();
      vdata_ini2 := periodo.inicio_nvl().trunc();
      vdata_fim2 := periodo.fim_nvl().trunc();
    else
      vdata_ini1 := self.inicio_nvl().data;
      vdata_fim1 := self.fim_nvl().data;
      vdata_ini2 := periodo.inicio_nvl().data;
      vdata_fim2 := periodo.fim_nvl().data;
    end if;
    -- verifica cruzamento
    if ((infinito like 'N' and (self.inicio.data is not null or self.fim.data is not null) and
       (periodo.inicio.data is not null or periodo.fim.data is not null)) or (infinito like 'S')) and
       (vdata_fim2 between vdata_ini1 and vdata_fim1 or vdata_ini2 between vdata_ini1 and vdata_fim1 or
       (vdata_ini2 < vdata_ini1 and vdata_fim2 > vdata_fim1)) then
      return 'S';
    else
      return 'N';
    end if;
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

  member function cruzamento_lista(list      varchar2
                                  ,formato   varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                                  ,separador varchar2 default ';'
                                  ,infinito  char default 'N') return char is
    vper period;
    vpos number := 1;
    vsub number;
    vlen constant number := length(list);
    vsep constant number := length(separador);
    valor date;
  begin
    if (infinito like 'S' or (infinito like 'N' and (self.inicio.data is not null or self.fim.data is not null))) and
       vlen > 0 then
      vper := self.nvl().to_format(formato);
      loop
        vsub := instr(list, separador, vpos);
        if vsub = 0 then
          valor := standard.to_date(substr(list, vpos), formato);
        else
          valor := standard.to_date(substr(list, vpos, vsub - vpos), formato);
        end if;
        -- >> atrib
        if valor is not null and
           valor between vper.inicio.data and vper.fim.data then
          return 'S';
        end if;
        -- >> --
        exit when vsub = 0;
        vpos := vsub + vsep;
      end loop;
    end if;
    return 'N';
  end cruzamento_lista;

  member function cruzamento_lista(list argsd default argsd(), infinito char default 'N') return char is
    vinicio date;
    vfim    date;
  begin
    -- verifica feriados
    if list is not null and
       list is not empty and
       (infinito like 'S' or (infinito like 'N' and (self.inicio.data is not null or self.fim.data is not null))) then
      vinicio := self.inicio_nvl().trunc();
      vfim    := self.fim_nvl().trunc();
      for i in list.first .. list.last
      loop
        -- verifica se esta no periodo
        if list(i) between vinicio and vfim then
          return 'S';
        end if;
      end loop;
    end if;
    return 'N';
  end;

  member function cruzamento_horario(inicio date default null, fim date default null, inicio_fim char default 'N') return char is
    vhora_ini1 date := to_date(self.inicio_nvl().horaminuto(), 'HH24MI');
    vhora_fim1 date := to_date(standard.nvl(self.fim_nvl().horaminuto(), '2359'), 'HH24MI');
    vhora_ini2 date := to_date(standard.to_char(inicio, 'HH24MI'), 'HH24MI');
    vhora_fim2 date := to_date(standard.nvl(standard.to_char(fim, 'HH24MI'), '2359'), 'HH24MI');
  begin
    -- pode ter final e inicio igual
    if inicio_fim like 'S' then
      vhora_fim1 := vhora_fim1 - (1 / 24 / 60);
      vhora_fim2 := vhora_fim2 - (1 / 24 / 60);
    end if;
    -- verifica cruzamento
    if (vhora_ini1 between vhora_ini2 and vhora_fim2) or
       (vhora_fim1 between vhora_ini2 and vhora_fim2) or
       (vhora_ini1 < vhora_ini2 and vhora_fim1 > vhora_fim2) then
      return 'S';
    else
      return 'N';
    end if;
  end cruzamento_horario;

  member function cruzamento_horario(inicio varchar2 default null, fim varchar2 default null, inicio_fim char default 'N') return char is
    vinicio date := to_date(substr(text(inicio).apenas_numeros(), -4), 'HH24MI');
    vfim    date := to_date(standard.nvl(substr(text(fim).apenas_numeros(), -4), '2359'), 'HH24MI');
  begin
    return cruzamento_horario(vinicio, vfim, inicio_fim);
  end cruzamento_horario;

  member function esta_dentro(periodo period, infinito char default 'N', considerar_horario char default 'N') return char is
    vdentro_inicio date;
    vdentro_fim    date;
    vmargem_inicio date;
    vmargem_fim    date;
  begin
    if considerar_horario like 'N' then
      vdentro_inicio := self.inicio_nvl().trunc();
      vdentro_fim    := self.fim_nvl().trunc();
      vmargem_inicio := periodo.inicio_nvl().trunc();
      vmargem_fim    := periodo.fim_nvl().trunc();
    else
      vdentro_inicio := self.inicio_nvl().data;
      vdentro_fim    := self.fim_nvl().data;
      vmargem_inicio := periodo.inicio_nvl().data;
      vmargem_fim    := periodo.fim_nvl().data;
    end if;
    -- verifica abrangencia  
    if ((infinito like 'N' and self.nulo like 'N' and periodo.nulo like 'N') or (infinito like 'S')) and
       vdentro_inicio between vmargem_inicio and vmargem_fim and
       vdentro_fim between vmargem_inicio and vmargem_fim then
      return 'S';
    else
      return 'N';
    end if;
  end esta_dentro;

  member function esta_dentro(inicio             datetime default datetime()
                             ,fim                datetime default datetime()
                             ,infinito           char default 'N'
                             ,considerar_horario char default 'N') return char is
  begin
    return esta_dentro(period(inicio, fim), infinito, considerar_horario);
  end esta_dentro;

  member function esta_dentro(inicio date default null, fim date default null, infinito char default 'N', considerar_horario char default 'N')
    return char is
  begin
    return esta_dentro(period(inicio, fim), infinito, considerar_horario);
  end esta_dentro;

  member function esta_dentro(inicio             varchar2 default null
                             ,fim                varchar2 default null
                             ,formato            varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                             ,infinito           char default 'N'
                             ,considerar_horario char default 'N') return char is
  begin
    return esta_dentro(period(datetime(inicio, formato), datetime(fim, formato)), infinito, considerar_horario);
  end esta_dentro;

  member function abrange(periodo period, infinito char default 'N', considerar_horario char default 'N') return char is
  begin
    return periodo.esta_dentro(self, infinito, considerar_horario);
  end abrange;

  member function abrange(inicio             datetime default datetime()
                         ,fim                datetime default datetime()
                         ,infinito           char default 'N'
                         ,considerar_horario char default 'N') return char is
  begin
    return abrange(period(inicio, fim), infinito, considerar_horario);
  end abrange;

  member function abrange(inicio date default null, fim date default null, infinito char default 'N', considerar_horario char default 'N') return char is
  begin
    return abrange(period(inicio, fim), infinito, considerar_horario);
  end abrange;

  member function abrange(inicio             varchar2 default null
                         ,fim                varchar2 default null
                         ,formato            varchar2 default 'DD/MM/RRRR HH24:MI:SS'
                         ,infinito           char default 'N'
                         ,considerar_horario char default 'N') return char is
  begin
    return abrange(period(datetime(inicio, formato), datetime(fim, formato)), infinito, considerar_horario);
  end abrange;

  member function possui(data datetime, infinito char default 'N', considerar_horario char default 'N') return char is
    vperiodo period;
    vdata    datetime;
  begin
    if considerar_horario like 'N' then
      vperiodo := self.trunc().nvl();
      vdata    := data.limpar_horario();
    else
      vperiodo := self.nvl();
      vdata    := data;
    end if;
    -- verifica possui
    if (vdata.data is not null and (infinito like 'S' or (infinito like 'N' and self.nulo like 'N'))) and
       vdata.data between (vperiodo.inicio.data) and (vperiodo.fim.data) then
      return 'S';
    else
      return 'N';
    end if;
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

  member function possui_ano(ano number, infinito char default 'N') return char is
  begin
    if ano is not null and
       (infinito like 'S' or (infinito like 'N' and self.nulo like 'N')) and
       ano between standard.nvl(self.inicio.ano, 0) and standard.nvl(self.fim.ano, 9999) then
      return 'S';
    else
      return 'N';
    end if;
  end possui_ano;

  member function possui_anomes(anomes number, infinito char default 'N') return char is
  begin
    if anomes is not null and
       (infinito like 'S' or (infinito like 'N' and self.nulo like 'N')) and
       anomes between standard.nvl(self.inicio.anomes, 0) and standard.nvl(self.fim.anomes, 999912) then
      return 'S';
    else
      return 'N';
    end if;
  end possui_anomes;

  member function possui_horario(data date, inicio_fim char default 'N') return char is
  begin
    return datetime(data).esta_dentro_horario(self.inicio_nvl().data, self.fim_nvl().data, inicio_fim);
  end possui_horario;

  member function possui_horario(data varchar2, inicio_fim char default 'N') return char is
  begin
    return datetime(substr(text(data).apenas_numeros(), -4), 'HH24MI').esta_dentro_horario(self.inicio_nvl().data, self.fim_nvl().data, inicio_fim);
  end possui_horario;

  member function possui_ds(ds number) return char is
    vlist argsd;
  begin
    if dias >= 7 then
      return 'S';
    else
      vlist := to_table();
      for i in vlist.first .. vlist.last
      loop
        if standard.to_char(vlist(i), 'D') = ds then
          return 'S';
        end if;
      end loop;
      return 'N';
    end if;
  end;

  member function possui_ds(ds argsn default argsn()) return char is
    vlist argsn;
  begin
    if ds is not null and
       ds is not empty then
      if dias >= 7 then
        return 'S';
      else
        vlist := listar_ds();
        for i in ds.first .. ds.last
        loop
          if ds(i) not member of vlist then
            return 'N';
          end if;
        end loop;
        return 'S';
      end if;
    else
      return 'N';
    end if;
  end;

  member function trunc return period is
  begin
    return period(standard.trunc(self.inicio.data), standard.trunc(self.fim.data));
  end;

  member function to_format(formato varchar2 default 'DD/MM/RRRR') return period is
  begin
    return period(standard.to_char(self.inicio.data, formato), standard.to_char(self.fim.data, formato), formato => formato);
  end;

  member function to_char(formato   varchar2 default 'DD/MM/RRRR'
                         ,infinito  varchar2 default '<infinito>'
                         ,separador varchar2 default ' a '
                         ,a_partir  varchar2 default 'A partir de '
                         ,ate       varchar2 default 'Até ') return varchar2 is
  begin
    if self.inicio.data is not null then
      if self.fim.data is not null then
        if self.inicio.data = self.fim.data then
          return self.inicio.to_char(formato);
        else
          return self.inicio.to_char(formato) || separador || self.fim.to_char(formato);
        end if;
      else
        return a_partir || self.inicio.to_char(formato);
      end if;
    elsif self.fim.data is not null then
      return ate || self.fim.to_char(formato);
    else
      return infinito;
    end if;
  end;

  member function to_table(exceto argsd default argsd()) return argsd is
    vinicio date := standard.trunc(self.inicio_nvl().data);
    vfim    date := standard.trunc(self.fim_nvl().data);
    result  argsd := argsd();
  begin
    for i in 1 .. vfim - vinicio + 1
    loop
      result.extend;
      result(result.last) := vinicio - 1 + i;
    end loop;
    -- --
    if exceto is not null and
       exceto is not empty then
      result := result multiset except exceto;
    end if;
    -- --
    return result;
  end;

  member function mostra(formato varchar2 default 'DD/MM/RRRR') return varchar2 is
  begin
    return to_char(formato);
  end;

end;
/
