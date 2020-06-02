select
fo.opportunity_id
, fo.opportunity
, fo.account_id
, fa.account
, fa.client_status
, fo.opportunity_record_type
, fo.opportunity_owner
, fo.opportunity_stage
, fo.opportunity_lead_source
, fo.close_date
, fo.date_of_sales_qualification
, fo.opportunity_created_date
, fo.opportunity_eligible_employees
, fo.amount
, fo.annual_amount
, fa.employees
, fa.number_of_eligible_employees as account_eligible_employees
from analytics_sandbox.fw_opportunities fo
left join analytics_sandbox.fw_accounts fa
	on fo.account_id = fa.account_id