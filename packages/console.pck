create or replace package console is

  -- Author  : Renan Orati (renanorati@gmail.com)

  -- vars
  vg_max_output number := 32512;
  vg_timestamp  timestamp := localtimestamp;
  -- Public function and procedure declarations
  procedure inicio(ts timestamp default localtimestamp);
  procedure datahora;
  procedure tempo(ts timestamp default vg_timestamp);
  function datahora return varchar2;
  function tempo(ts timestamp default vg_timestamp) return varchar2;
  procedure log(texto varchar2, mostra_tempo boolean default false, mostra_datahora boolean default false);
  procedure log(texto clob, mostra_tempo boolean default false, mostra_datahora boolean default false);
  procedure log(data            date
               ,mostra_tempo    boolean default false
               ,mostra_datahora boolean default false
               ,formato         varchar2 default 'DD/MM/RRRR HH24:MI:SS');
  procedure log_args(linhas args, mostra_tempo boolean default false, mostra_datahora boolean default false);
  procedure log(valores         args
               ,campos          args default args()
               ,separador       char default null
               ,lpad            args default args()
               ,lpad_geral      number default null
               ,lpad_char       char default ' '
               ,rpad            args default args()
               ,rpad_geral      number default null
               ,rpad_char       char default ' '
               ,mostra_tempo    boolean default false
               ,mostra_datahora boolean default false);
  procedure log(valores         alist
               ,campos          args default args()
               ,separador       char default null
               ,lpad            args default args()
               ,lpad_geral      number default null
               ,lpad_char       char default ' '
               ,rpad            args default args()
               ,rpad_geral      number default null
               ,rpad_char       char default ' '
               ,mostra_tempo    boolean default false
               ,mostra_datahora boolean default false);
  procedure log(valores         argsd
               ,campos          args default args()
               ,separador       char default null
               ,lpad            args default args()
               ,lpad_geral      number default null
               ,lpad_char       char default ' '
               ,rpad            args default args()
               ,rpad_geral      number default null
               ,rpad_char       char default ' '
               ,mostra_tempo    boolean default false
               ,mostra_datahora boolean default false
               ,formato         varchar2 default 'DD/MM/RRRR');
  procedure log(valores         dlist
               ,campos          args default args()
               ,separador       char default null
               ,lpad            args default args()
               ,lpad_geral      number default null
               ,lpad_char       char default ' '
               ,rpad            args default args()
               ,rpad_geral      number default null
               ,rpad_char       char default ' '
               ,mostra_tempo    boolean default false
               ,mostra_datahora boolean default false
               ,formato         varchar2 default 'DD/MM/RRRR');
  procedure log(valores         argsdt
               ,campos          args default args()
               ,separador       char default null
               ,lpad            args default args()
               ,lpad_geral      number default null
               ,lpad_char       char default ' '
               ,rpad            args default args()
               ,rpad_geral      number default null
               ,rpad_char       char default ' '
               ,mostra_tempo    boolean default false
               ,mostra_datahora boolean default false
               ,formato         varchar2 default 'DD/MM/RRRR');
  procedure log(valores         argsn
               ,campos          args default args()
               ,separador       char default null
               ,lpad            args default args()
               ,lpad_geral      number default null
               ,lpad_char       char default ' '
               ,rpad            args default args()
               ,rpad_geral      number default null
               ,rpad_char       char default ' '
               ,mostra_tempo    boolean default false
               ,mostra_datahora boolean default false);
  procedure log(valores         nlist
               ,campos          args default args()
               ,separador       char default null
               ,lpad            args default args()
               ,lpad_geral      number default null
               ,lpad_char       char default ' '
               ,rpad            args default args()
               ,rpad_geral      number default null
               ,rpad_char       char default ' '
               ,mostra_tempo    boolean default false
               ,mostra_datahora boolean default false);
  procedure log(resp response, mostra_tempo boolean default false, mostra_datahora boolean default false);
end console;
/
create or replace package body console is

  procedure inicio(ts timestamp default localtimestamp) is
  begin
    vg_timestamp := ts;
  end;

  function datahora return varchar2 is
  begin
    return '[' || regexp_replace(to_char(localtimestamp, 'DD/MM/RRRR HH24:MI:SSxFF'), '0{1,3}$') || ']';
  end;

  function tempo(ts timestamp default vg_timestamp) return varchar2 is
  begin
    return '[' || regexp_replace(regexp_replace(regexp_replace((localtimestamp - ts), '^\+([0:]|\s)+', '+'), '0{1,3}$'), '^\+\.', '+0.') || ']';
  end;

  procedure datahora is
  begin
    dbms_output.put_line(datahora());
  end;

  procedure tempo(ts timestamp default vg_timestamp) is
  begin
    dbms_output.put_line(tempo(ts));
  end;

  -- Log em console com variável VARCHAR2
  procedure log(texto varchar2, mostra_tempo boolean default false, mostra_datahora boolean default false) is
    vtempos     varchar2(150);
    vtexto_clob clob;
  begin
    if mostra_datahora then
      vtempos := vtempos || ' ' || datahora();
    end if;
    if mostra_tempo then
      vtempos := vtempos || ' ' || tempo();
    end if;
  
    if length(texto) + nvl(length(vtempos), 0) > vg_max_output then
      vtexto_clob := texto || vtempos;
      log(vtexto_clob);
    else
      dbms_output.put_line(texto || vtempos);
    end if;
  end;

  procedure log(data            date
               ,mostra_tempo    boolean default false
               ,mostra_datahora boolean default false
               ,formato         varchar2 default 'DD/MM/RRRR HH24:MI:SS') is
  begin
    log(standard.to_char(data, formato), mostra_tempo, mostra_datahora);
  end;

  -- Log em console com variável CLOB
  procedure log(texto clob, mostra_tempo boolean default false, mostra_datahora boolean default false) is
    vlinha varchar2(32767);
    vpular number := 0;
    vchr10 number := 0;
    vpos   number := 1;
    vtexto clob := texto;
  begin
    if mostra_datahora then
      vtexto := vtexto || ' ' || datahora();
    end if;
    if mostra_tempo then
      vtexto := vtexto || ' ' || tempo();
    end if;
    -- --
    loop
      vchr10 := dbms_lob.instr(vtexto, chr(10), vpos + 1, 1);
      if vchr10 <> 0 and
         (vchr10 - vpos) < vg_max_output then
        vlinha := dbms_lob.substr(vtexto, (vchr10 - vpos), vpos);
        vpular := 1;
      else
        vlinha := dbms_lob.substr(vtexto, vg_max_output, vpos);
        vpular := 0;
      end if;
      dbms_output.put_line(vlinha);
      exit when vpos + length(vlinha) >= length(vtexto);
      vpos := vpos + length(vlinha) + vpular;
    end loop;
  end;

  procedure log_args(linhas args, mostra_tempo boolean default false, mostra_datahora boolean default false) is
  begin
    if linhas is not null and
       linhas is not empty then
      for i in linhas.first .. linhas.last
      loop
        log(linhas(i), mostra_tempo, mostra_datahora);
      end loop;
    end if;
  end;

  procedure log(valores         args
               ,campos          args default args()
               ,separador       char default null
               ,lpad            args default args()
               ,lpad_geral      number default null
               ,lpad_char       char default ' '
               ,rpad            args default args()
               ,rpad_geral      number default null
               ,rpad_char       char default ' '
               ,mostra_tempo    boolean default false
               ,mostra_datahora boolean default false) is
    linha clob;
    valor varchar2(32767);
  begin
    if valores is not null and
       valores is not empty then
      for i in valores.first .. valores.last
      loop
        -- verifica se existe valor na posição do array
        if valores.exists(i) then
          if separador is null then
            linha := null;
          end if;
          -- --
          declare
            vlpad number := null;
            vrpad number := null;
          begin
            -- separador
            linha := linha || (case
                       when linha is null then
                        null
                       else
                        separador
                     end);
            -- --
            if campos.exists(i) and
               campos(i) is not null then
              linha := linha || campos(i) || ': ';
            end if;
          
            -- ### LPAD ### --
            -- lpad valor
            if lpad.exists(i) and
               lpad(i) is not null then
              vlpad := lpad(i);
            else
              vlpad := lpad_geral;
            end if;
            -- prepara valor
            if vlpad is not null then
              valor := standard.lpad(valores(i), vlpad, lpad_char);
            end if;
          
            -- ### RPAD ### --
            -- Rpad valor
            if rpad.exists(i) and
               rpad(i) is not null then
              vrpad := rpad(i);
            else
              vrpad := rpad_geral;
            end if;
            -- prepara valor
            if vrpad is not null then
              valor := standard.rpad(valores(i), vrpad, rpad_char);
            end if;
          
            -- preenche linha
            if vlpad is null and
               vrpad is null then
              linha := linha || valores(i);
            else
              linha := linha || valor;
            end if;
          
            -- log
            if separador is null then
              log(linha, mostra_tempo, mostra_datahora);
            end if;
          end;
        end if;
      end loop;
      -- log
      if separador is not null then
        log(linha, mostra_tempo, mostra_datahora);
      end if;
    end if;
  end;

  procedure log(valores         alist
               ,campos          args default args()
               ,separador       char default null
               ,lpad            args default args()
               ,lpad_geral      number default null
               ,lpad_char       char default ' '
               ,rpad            args default args()
               ,rpad_geral      number default null
               ,rpad_char       char default ' '
               ,mostra_tempo    boolean default false
               ,mostra_datahora boolean default false) is
  begin
    log(valores.to_args(), campos, separador, lpad, lpad_geral, lpad_char, rpad, rpad_geral, rpad_char, mostra_tempo, mostra_datahora);
  end;

  procedure log(valores         argsd
               ,campos          args default args()
               ,separador       char default null
               ,lpad            args default args()
               ,lpad_geral      number default null
               ,lpad_char       char default ' '
               ,rpad            args default args()
               ,rpad_geral      number default null
               ,rpad_char       char default ' '
               ,mostra_tempo    boolean default false
               ,mostra_datahora boolean default false
               ,formato         varchar2 default 'DD/MM/RRRR') is
    vargs args := args();
  begin
    if valores is not null and
       valores is not empty then
      for i in valores.first .. valores.last
      loop
        -- verifica se existe valor na posição do array
        if valores.exists(i) then
          vargs.extend;
          vargs(vargs.last) := standard.to_char(valores(i), formato);
        end if;
      end loop;
    end if;
    log(vargs, campos, separador, lpad, lpad_geral, lpad_char, rpad, rpad_geral, rpad_char, mostra_tempo, mostra_datahora);
  end;

  procedure log(valores         dlist
               ,campos          args default args()
               ,separador       char default null
               ,lpad            args default args()
               ,lpad_geral      number default null
               ,lpad_char       char default ' '
               ,rpad            args default args()
               ,rpad_geral      number default null
               ,rpad_char       char default ' '
               ,mostra_tempo    boolean default false
               ,mostra_datahora boolean default false
               ,formato         varchar2 default 'DD/MM/RRRR') is
  begin
    log(valores.to_argsd(), campos, separador, lpad, lpad_geral, lpad_char, rpad, rpad_geral, rpad_char, mostra_tempo, mostra_datahora, formato);
  end;

  procedure log(valores         argsdt
               ,campos          args default args()
               ,separador       char default null
               ,lpad            args default args()
               ,lpad_geral      number default null
               ,lpad_char       char default ' '
               ,rpad            args default args()
               ,rpad_geral      number default null
               ,rpad_char       char default ' '
               ,mostra_tempo    boolean default false
               ,mostra_datahora boolean default false
               ,formato         varchar2 default 'DD/MM/RRRR') is
    vargs args := args();
  begin
    if valores is not null and
       valores is not empty then
      for i in valores.first .. valores.last
      loop
        -- verifica se existe valor na posição do array
        if valores.exists(i) then
          vargs.extend;
          vargs(vargs.last) := valores(i).to_char(formato);
        end if;
      end loop;
    end if;
    log(vargs, campos, separador, lpad, lpad_geral, lpad_char, rpad, rpad_geral, rpad_char, mostra_tempo, mostra_datahora);
  end;

  procedure log(valores         argsn
               ,campos          args default args()
               ,separador       char default null
               ,lpad            args default args()
               ,lpad_geral      number default null
               ,lpad_char       char default ' '
               ,rpad            args default args()
               ,rpad_geral      number default null
               ,rpad_char       char default ' '
               ,mostra_tempo    boolean default false
               ,mostra_datahora boolean default false) is
    vargs args := args();
  begin
    if valores is not null and
       valores is not empty then
      for i in valores.first .. valores.last
      loop
        -- verifica se existe valor na posição do array
        if valores.exists(i) then
          vargs.extend;
          vargs(vargs.last) := valores(i);
        end if;
      end loop;
    end if;
    log(vargs, campos, separador, lpad, lpad_geral, lpad_char, rpad, rpad_geral, rpad_char, mostra_tempo, mostra_datahora);
  end;

  procedure log(valores         nlist
               ,campos          args default args()
               ,separador       char default null
               ,lpad            args default args()
               ,lpad_geral      number default null
               ,lpad_char       char default ' '
               ,rpad            args default args()
               ,rpad_geral      number default null
               ,rpad_char       char default ' '
               ,mostra_tempo    boolean default false
               ,mostra_datahora boolean default false) is
  begin
    log(valores.to_argsn(), campos, separador, lpad, lpad_geral, lpad_char, rpad, rpad_geral, rpad_char, mostra_tempo, mostra_datahora);
  end;

  procedure log(resp response, mostra_tempo boolean default false, mostra_datahora boolean default false) is
  begin
    if resp.tipo is null then
      log('[OK]', mostra_tempo, mostra_datahora);
    else
      if resp.subtitulo is not null then
        log('[SUBTITULO]:');
        log(resp.subtitulo);
      end if;
      if resp.mensagem is not null then
        log('[MENSAGEM]:');
        log(resp.mensagem);
      end if;
      log('[' || resp.tipo || ']', mostra_tempo, mostra_datahora);
    end if;
  end;

end console;
/
