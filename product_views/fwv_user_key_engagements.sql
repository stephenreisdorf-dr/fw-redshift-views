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
	join engagements e
		on ue.user_external_id = e.user_external_id
		and ue.created_at > dateadd('hour',12,e.first_engagement_at)
	group by ue.user_external_id
)
select
e.user_external_id
,p.signed_up_at
,e.first_engagement_at
,e2.second_engagement_at
,e.last_engagement_at
from engagements e
left join second_engagements e2
	on e.user_external_id = e2.user_external_id
left join smartdollar.smartdollar_report_participants p
	on e.user_external_id = p.external_id
left join smartdollar.smartdollar_report_enrollments en
	on p.enrollment_id = en.id
where en.exclude_from_aggregate_reports = 0