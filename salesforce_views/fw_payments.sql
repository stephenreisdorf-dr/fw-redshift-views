select
payment.payment_id
,payment.opportunity_id
,payment.payment_owner_id
,usr.owner as payment_owner
,payment.invoice_sent_date
,payment.invoice_paid_date
,payment.payment_due_date
,payment.invoiced_amount
,payment.amount_received
,payment.keep
,usr.keep
from (
select
	p.id as payment_id
	,p.opportunity_name__c as opportunity_id
	,p.team_member__c as payment_owner_id
	,case
		when p.invoice_sent_date__c = '' then null
		else cast(p.invoice_sent_date__c as date)
	end as invoice_sent_date
	,case
		when p.invoice_paid_date__c = '' then null
		else cast(p.invoice_paid_date__c as date)
	end as invoice_paid_date
	,case
		when p.payment_due_date__c = '' then null
		else cast(p.payment_due_date__c as date)
	end as payment_due_date
	,case
		when p.invoiced_amount__c = '' then null
		else cast(p.invoiced_amount__c as decimal(38,2))
	end as invoiced_amount
	,case
		when p.amount_received__c = '' then null
		else cast(p.amount_received__c as decimal(38,2))
	end as amount_received
	,row_number() over(partition by p.id order by p.lastmodifieddate desc) = 1 as keep
	from crm_salesforce_strength_parquet.payment__c p
) as payment
left join (
	select
	u.id as user_id
	,u.name as owner
	,row_number() over(partition by u.id order by u.lastmodifieddate desc) = 1 as keep
	from crm_salesforce_strength_parquet."user" u
) as usr
on payment.payment_owner_id = usr.user_id
	and payment.keep and usr.keep
where payment.keep is not null and usr.keep is not null