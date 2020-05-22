select
fo.opportunity_id
, fo.opportunity
, fo.account_id
, fa.account
, fa.client_status
, fp.payment_id
, fp.payment_owner_id
, fp.payment_owner
, fp.invoice_sent_date
, fp.invoice_paid_date
, fp.payment_due_date
, fo.record_type as opportunity_record_type
, fo.owner as opportunity_owner
, fo.stage as opportunity_stage
, fo.lead_source as opportunity_lead_source
, fo.close_date as close_date
, fo.date_of_sales_qualification as date_of_sales_qualification
, fo.created_date as opportunity_created_date
, fo.number_of_eligible_employees as opportunity_eligible_employees
, fo.amount as opportunity_amount
, fo.annual_amount as opportunity_annual_amount
, fa.employees
, fa.number_of_eligible_employees as account_eligible_employees
, count(*) over (partition by fo.opportunity_id) as total_payments
, fo.amount / total_payments as amount_per_payment
, fo.annual_amount / total_payments as annual_amount_per_payment
, fp.invoiced_amount
, fp.amount_received
from analytics_sandbox.fw_opportunities fo
join analytics_sandbox.fw_accounts fa
	on fo.account_id = fa.account_id
join analytics_sandbox.fw_payments fp
	on fp.opportunity_id = fo.opportunity_id