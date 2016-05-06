set linesize 100;

with simple_data as (
  select distinct
    search_string
  , replace(
      regexp_replace(search_string, '\(GKEY ([A-Za-z0-9\.\-]*)\)', '\1', 1, 0)
    , ' AND ', '+'
    ) as opac_search_string
  from opac_search_log
  where search_date >= trunc(sysdate - 8) -- arbitrary
  and search_type = 'GKEY'
  and hits between 1 and 200 -- arbitrary
)
select 
  opac_search_string
-- , search_string -- for comparison / fine-tuning
from simple_data
where opac_search_string not like '%GKEY%' -- filter out the ones which didn't get cleaned up
order by rownum -- random-ish so no index clustering; no access to dbms_random
;
