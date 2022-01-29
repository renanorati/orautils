# ORAUTILS
Autor: **Renan Orati**

Bibliotecas para apoio ao desenvolvimento Oracle. [[documentação]](https://renanorati.github.io/orautils)

- [Coleções Básicas](#coleções-básicas)
- Types para criação de coleções básicas
- [datetime](#datetime)
- Biblioteca para manipulação de datas.
- [period](#period)
- Biblioteca para manipulação de períodos .

## Coleções Básicas
- args `varchar2`
- argsn `number`
- argsd `date`
```TSQL
DECLARE
vusu args := args(); -- declaração
BEGIN
-- adicionando valores
vusu := args('JOAO','MARIA');
-- adicionando dinamicamente
vusu.extend();
vusu(vusu.last) := 'PAULA';
-- exibindo no console
console.log(vusu);
console.log('--------------');
-- removendo valores
vusu.delete(1);
-- exibindo no console
console.log(vusu);
-- removendo todos os valores
vusu.delete;
END;
```
### Funções de agregação para as coleções:
- listargs `args`
- listargsn `argsn`
- listargsd `argsd`
```TSQL
select listargs(cli.nome) from clientes cli where cli.empresa = 3;
```
## datetime
Tipo de dados para auxílio no desenvolvimento com uso de datas. [[documentação]](https://renanorati.github.io/orautils/datetime.html)

A utilização do tipo **`datetime`** pode **reduzir o código** e/ou **melhorar a legibilidade**:

- Verificar se o dia de HOJE + 2 meses e 5 dias, irá cair em um "fim de semana" (fds):
```TSQL
-- Utilizando função nativa (case)
select case
when to_char(add_months(sysdate, 2) + 5, 'D') in (1, 7) then
'S'
else
'N'
end
from dual;

-- Utilizando função nativa (decode)
select decode(to_char(add_months(sysdate, 2) + 5, 'D'), 1, 'S', 7, 'S', 'N') from dual;

-- Utilizando tipo 'datetime'
select datetime(sysdate).adicionar(meses => 2, dias => 5).fds() from dual;
```
- Verificar o último dia do mês, do dia de HOJE + 2 anos, 3 meses e 5 dias:
```TSQL
-- Utilizando apenas funções nativas
select to_char(last_day(add_months(sysdate, (2 * 12) + 3) + 15), 'DD') from dual;

-- Utilizando tipo datetime
select datetime(sysdate).adicionar(anos => 2, meses => 3, dias => 15).ultimo().dia() from dual;
```
Outros exemplos de uso:
```TSQL
-- dia "12/06/2017" + "5 dias úteis"
select datetime('12/06/2017').adicionar(dias_uteis=>5) from dual; -- 20/06/2017

-- verificar se o dia "15/06/2017" é um feriado
select datetime('15/06/2017').feriado() from dual; -- "S"

-- verificar se o dia "07/09/2017" é um dia útil
select datetime('07/09/2017').dia_util() from dual; -- "N"

-- verificar se o ano "2020" é um ano "bissexto"
select datetime(ano=>2020).bissexto() from dual; -- "S"
```
## period
Tipo de dados para auxílio no desenvolvimento com uso de períodos. [[documentação]](https://renanorati.github.io/orautils/datetime.html)

Armazena início e fim do período utilizando o tipo de dados datetime.

### Declaração

O tipo period pode ser criado de diversas maneiras, como por exemplo:
```TSQL
declare
-- declarações básicas
vperiodo period := period('10/10/2018','15/10/2018'); -- 10/10/2018 a 15/10/2018
vperiodo period := period('10/10/2018'); -- a partir de 10/10/2018
vperiodo period := period('10/10/2018',infinito=>'N'); -- 10/10/2018
vperiodo period := period('10/10/2018',infinito=>'FM'); -- 10/10/2018 a 31/10/2018 ('FM' = "fim do mês")
vperiodo period := period('2018-10-10T00:00:00-03:00',formato=>'ISO8601'); -- a partir de 10/10/2018

-- geração do período a partir de uma data inicial
vperiodo period := period('10/10/2018',dias=>1); -- 10/10/2018
vperiodo period := period('10/10/2018',dias=>3); -- 10/10/2018 a 12/10/2018
vperiodo period := period('10/10/2018',meses=>1); -- 10/10/2018 a 09/11/2018
vperiodo period := period('10/10/2018',anos=>2); -- 10/10/2018 a 09/10/2020
vperiodo period := period('10/10/2018',anos=>1,dias=>1); -- 10/10/2018 a 10/10/2019
vperiodo period := period('12/06/2017',dias_uteis=>5); -- 12/06/2017 a 19/06/2017

-- geração de período facilitadas
vperiodo period := period(ano=>2017); -- 01/01/2017 a 31/12/2017
vperiodo period := period(anomes=>201706); -- 01/06/2017 a 30/06/2017
vperiodo period := period(ano=>2017,mes=>06); -- 01/06/2017 a 30/06/2017
```

### Exibição Descritiva
```TSQL
-- to_char()
select period(anomes=>201706).to_char() from dual; -- 01/06/2017 a 30/06/2017
select period(ano=>2017).to_char('MM/RRRR') from dual; -- 01/2017 a 12/2017

-- data completa
select period('14/06/2017 15:25','16/06/2017 17:59').data_completa() from dual; -- 14/06/2017 15:25:00 a 16/06/2017 17:59:00
```
### Exibição em "Tabela"
```TSQL
select * from table(period('14/06/2017','16/06/2017').to_table()); -- <<tabela>>

select * from table(period(anomes=>201704).to_table()); -- <<tabela :: 01/04/2017 a 30/04/2017>>

select * from table(period('14/06/2017','16/08/2017').limitar(period(anomes=>201708)).to_table()); -- <<tabela :: 01/08/2017 a 16/08/2017>>

select * from table(period(anomes=>201704).listar_feriados()); -- <<tabela :: 14/04/2017, 21/04/2017>>
```

### Utilizações mais comuns

#### Contagem de Tempo
```TSQL
select period('01/01/2017','15/03/2019').tempo() from dual; -- 2 anos 2 meses e 15 dias

select period('01/01/2017','15/03/2019').tempo(resumido=>'S') from dual; -- 2a 2m 15d

select period('01/01/2017 10:45:00','01/01/2017 22:18:17').tempo() from dual; -- 11 horas 33 minutos e 17 segundos

select period('01/01/2017 10:45:00','01/01/2017 22:18:17').tempo(resumido=>'S') from dual; -- 11:33:17
```
#### Dias, Meses e Anos

Considera apenas o **tempo já completo**, e não o resto.
```TSQL
-- funções básicas
select period(anomes => 201704).dias() from dual; -- 30

select period('01/01/2017', '15/03/2019').dias() from dual; -- 804

select period('01/01/2017', '15/03/2019').meses() from dual; -- 26

select period('01/01/2017', '15/03/2019').anos() from dual; -- 2

-- outras funções
-- -- Dias de semana
select period(anomes => 201704).dias_semana() from dual; -- 20

-- -- Dias em Finais de Semana
select period(anomes => 201704).dias_fds() from dual; -- 10

-- -- Feriados
select period(anomes => 201704).dias_feriado() from dual; -- 2

-- -- Dias úteis
select period(anomes => 201704).dias_uteis() from dual; -- 18

-- calcular a idade à partir da data de nascimento
select period('28/09/1987', to_char(sysdate)).anos(contar_dia_inicial => 'N') from dual;
```
#### Cruzamento
```TSQL
-- -- verificar casas que receberam locações em pelo menos um dia dentro do período de 10/10/2017 a 25/10/2017
select * from locacoes l where period(l.inicio, l.fim).cruzamento('10/10/2017', '25/10/2017') like 'S';

-- -- verificar casas que receberam locações em pelo menos um dia dentro do ano/mês 2017/07
select * from locacoes l where period(l.inicio, l.fim).cruzamento(period(anomes => 201707)) like 'S';

-- -- verificar casas que receberam locações em pelo menos um dia dentro do ano 2017
select * from locacoes l where period(l.inicio, l.fim).cruzamento(period(ano => 2017)) like 'S';
```
#### Abrangência
```TSQL
-- -- verificar casas que tiveram locações iniciadas e finalizadas entre 10/10/2017 a 20/11/2018
select * from locacoes l where period(l.inicio, l.fim).esta_dentro('10/10/2017', '20/11/2018') like 'S';

-- -- verificar casas que tiveram locações iniciadas e finalizadas dentro do ANO 2018
select * from locacoes l where period(ano => 2018).abrange(l.inicio, l.fim) like 'S';
```
#### Limitar Períodos

Limitar o período dentro de outro período
**Obs.:** Caso o período limitante não tenha cruzamento com o período base, o limite não é aplicado.
```TSQL
-- limitar e retornar novo período
select period('14/06/2017', '16/08/2018').limitar('11/06/2018', '19/08/2018') from dual; -- 11/06/2018 a 16/08/2018

select period('14/06/2017', '16/08/2018').limitar(period(anomes => 201808)) from dual; -- 01/08/2018 a 16/08/2018

select period('14/06/2017', '16/08/2018').limitar(period(ano => 2018)) from dual; -- 01/01/2018 a 16/08/2018

-- limitar e filtrar por cruzamento
select l.codigo
,l.descricao
,period(l.inicio, l.fim).limitar(period(ano => 2017))
from locacoes l
where period(l.inicio, l.fim).cruzamento(period(ano => 2017)) like 'S';

-- limitar e gerar tabela
select * from table(period('14/06/2017', '16/08/2018').limitar(period(ano => 2018)).to_table()); -- <<tabela :: 01/01/2018 a 16/08/2018>>
```
#### Outros Exemplos
```TSQL
-- Dias da semana
select period('14/06/2017', '16/06/2017').ds() from dual; -- 4,5,6
select period('14/06/2017', '16/06/2017').ds(formato => 'day', separador => ' | ') from dual; -- quarta-feira | quinta-feira | sexta-feira

-- Possui dias da semana
select period('14/06/2017', '16/06/2017').possui_ds(5) from dual; -- S
select period('14/06/2017', '16/06/2017').possui_ds(2) from dual; -- N

-- Possui ano
select period('14/06/2017', '16/06/2017').possui_ano(2016) from dual; -- N
select period('14/06/2017', '16/06/2017').possui_ano(2017) from dual; -- S

-- Possui ano/mes
select period('14/06/2017', '16/06/2017').possui_anomes(201706) from dual; -- S
select period('14/06/2017', '16/06/2017').possui_anomes(201707) from dual; -- N

-- Listar Feriados
select period('14/06/2017', '16/06/2017').listar_feriados() from dual; -- 15/06/2017

-- Listar Feriados como Tabela
select * from table(period(anomes => 201704).listar_feriados()); -- <<tabela :: 14/04/2017, 21/04/2017>>
```
