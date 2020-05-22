select distinct
opp.opportunity_id
,opp.opportunity
,opp.account_id
,rt.opportunity_record_type
,usr.opportunity_owner
,opp.opportunity_stage
,opp.opportunity_lead_source
,opp.close_date
,opp.date_of_sales_qualification
,opp.opportunity_created_date
,opp.opportunity_eligible_employees
,opp.amount
,opp.annual_amount
from (
	select
	o.id as opportunity_id
	,o.name as opportunity
	,o.accountid as account_id
	,o.ownerid as owner_id
	,o.recordtypeid as record_type_id
	,o.stagename as opportunity_stage
	,o.leadsource as opportunity_lead_source
	,case
		when o.number_of_eligible_employees__c = '' then null
		else cast(o.number_of_eligible_employees__c as numeric)
	end as opportunity_eligible_employees
	,case
		 when o.closedate = '' then null
		 else cast(o.closedate as date)
	end as close_date
	,case
		 when o.date_of_sales_qualification__c = '' then null
		 else cast(o.date_of_sales_qualification__c as date)
	end as date_of_sales_qualification
	,case
		 when o.createddate = '' then null
		 else cast(o.createddate as date)
	end as opportunity_created_date
	,case
		when o.amount = '' then null
		else cast(o.amount as decimal(38,2))
	end as amount
	,case
		when o.annual_amount__c = '' then null
		else cast(o.annual_amount__c as decimal(38,2))
	end as annual_amount
	,case when o.isdeleted = 'true' then true else false end as is_deleted
	,row_number() over (partition by o.id order by o.lastmodifieddate desc) = 1 as keep
	from crm_salesforce_strength_parquet.opportunity o
) as opp
left join (
	select
	r.id as record_type_id
	,r.name as opportunity_record_type
	,row_number() over(partition by r.id order by lastmodifieddate desc) = 1 as keep
	from crm_salesforce_strength_parquet.recordtype r
) as rt
on opp.record_type_id = rt.record_type_id
left join (
	select
	u.id as user_id
	,u.name as opportunity_owner
	,row_number() over(partition by u.id order by u.lastmodifieddate desc) = 1 as keep
	from crm_salesforce_strength_parquet."user" u
) as usr
on opp.owner_id = usr.user_id
where opp.keep and not opp.is_deleted and rt.keep and usr.keep