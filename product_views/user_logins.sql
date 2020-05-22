select
cast(l."time" as datetime) as event_time
,cast(l."time" as date) as event_date
,l.user_id as user_external_id
,l.app_id + '.' + l."action" as event
from apophenia_wellness_parquet.smartdollar_session_create_success l
union all 
select
event_time
,event_date
,user_id as user_external_id
,event
from everydollar.signin;