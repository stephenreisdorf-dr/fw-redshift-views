select
account.account_id
,account.account
,account.client_status
,account.employees
,account.number_of_eligible_employees
from (
	select
	a.id as account_id
	,a.client_status__c as client_status
	,a.name as account
	,case when a.numberofemployees = '' then null else cast(a.numberofemployees as decimal(38,0)) end as employees
	,case when a.number_of_eligible_employees__c = '' then null else cast(a.number_of_eligible_employees__c as decimal(38,0)) end as number_of_eligible_employees
	,case when a.isdeleted = 'true' then true else false end as is_deleted
	,row_number() over (partition by a.id order by a.lastmodifieddate desc) = 1 as keep
	from crm_salesforce_strength_parquet.account a
) as account
where account.keep and not account.is_deleted