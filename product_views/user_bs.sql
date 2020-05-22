with lead_bs as (
	select
	id
	,user_external_id
	,created_at as started_at
	,"from" previous_baby_step
	,"to" baby_step
	,lead(created_at,1) over (partition by user_external_id order by created_at) as next_started_at
	,count(*) over (partition by user_external_id) as user_transitions
	,datediff('day', started_at, nvl(next_started_at, current_date)) as duration
	,next_started_at is null as current_baby_step
	from smartdollar.smartdollar_app_user_summary_current_baby_step_transitions bs
	where user_external_id is not null and baby_step <> 0
	order by
	user_external_id
	,created_at
),
first_bs as (
	select
	user_external_id
	,baby_step
	,started_at
	,duration
	,min(started_at) over (partition by user_external_id) = started_at as first_baby_step
	,current_baby_step
	from lead_bs
	where duration > 0
)
select
user_external_id
,baby_step as first_baby_step
,started_at
,duration
,current_baby_step
from first_bs
where first_baby_step;