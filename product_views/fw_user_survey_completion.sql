select
p.external_id as user_external_id
, c.external_id as company_external_id
, p.signed_up_at
, s.survey_completed_at
, s.onboarding_survey
, s.retake_survey
, ff.external_id is not null as new_survey
from smartdollar.smartdollar_report_participants p
join smartdollar.smartdollar_report_enrollments e
	on p.enrollment_id = e.id
join smartdollar.smartdollar_report_companies c
	on p.company_id = c.id
join (
	select
	ue.user_external_id
	, ue.created_at as survey_completed_at
	, ue.engagement_config_id = 23 as retake_survey
	, ue.engagement_config_id = 25 as onboarding_survey
	from engagement_api.engagement_api_user_engagements ue
	where ue.engagement_config_id in (23,25)
	group by
	ue.user_external_id
	, ue.created_at
	, ue.engagement_config_id
) as s
	on p.external_id = s.user_external_id
left join (
	select external_id
	from smartdollar.smartdollar_app_feature_flags
	where var = 'onboarding_survey_test'
		and thing_type = 'FinancialWellness::CompanyApi::Company'
		and value = '--- true
...'
) as ff
	on c.external_id = ff.external_id
where e.exclude_from_aggregate_reports = 0