-- synonym
create public synonym args for args;
create public synonym argsd for argsd;
create public synonym argsn for argsn;
create public synonym listargs for listargs;
create public synonym listargsn for listargsn;
create public synonym listargsd for listargsd;
create public synonym bool for bool;
create public synonym text for text;
create public synonym datetime for datetime;
create public synonym period for period;
-- Grant/Revoke object privileges
grant execute on args to public;
grant execute on argsd to public;
grant execute on argsn to public;
grant execute on listargs to public;
grant execute on listargsd to public;
grant execute on listargsn to public;
grant execute on obj_aggr_args to public;
grant execute on obj_aggr_argsd to public;
grant execute on obj_aggr_argsn to public;
grant execute on bool to public;
grant execute on text to public;
grant execute on datetime to public;
grant execute on period to public;
