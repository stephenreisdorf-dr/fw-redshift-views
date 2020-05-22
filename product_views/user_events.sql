-- Get the first and last timestamps for each user
with engagements as (
	select
	ue.user_external_id
	,min(ue.created_at) as first_engagement_at
	,max(ue.created_at) as last_engagement_at
	from engagement_api.engagement_api_user_engagements ue
	group by ue.user_external_id
),
-- Get the second engagement after a 12 hour block-out period
second_engagements as (
	select
	ue.user_external_id
	,min(ue.created_at) as second_engagement_at
	from engagement_api.engagement_api_user_engagements ue
	join events e
		on ue.user_external_id = e.user_external_id
		and ue.created_at > dateadd('hour'.12,e.first_engagement_at)
	group by ue.user_external_id
)
select
e.user_external_id
,e.first_engagement_at
,e2.second_engagement_at
,e.last_engagement_at
from events e
left join second_events e2
	on e.user_external_id = e2.user_external_id
