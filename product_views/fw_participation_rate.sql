select
des.calendar_date
, des.company_id
, c."name" as company
, des.enrollment_id
, e."name" as enrollment
, p.first_name || ' ' || p.last_name as rm
, des.company_size
, des.launch_date
, des.calculated_launch_date 
, des.days_since_launch
, des.total_eligible_participants
, des.total_current_users
from smartdollar.smartdollar_report_daily_enrollment_summaries des
join smartdollar.smartdollar_report_enrollments e
	on des.enrollment_id = e.id
join smartdollar.smartdollar_report_companies c
	on des.company_id = c.id
left join smartdollar.smartdollar_report_company_relationship_managers rm
	on rm.company_id = des.company_id
left join smartdollar.smartdollar_report_participants p
	on p.id = rm.participant_id
where e.exclude_from_aggregate_reports = 0