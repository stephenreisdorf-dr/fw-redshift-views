select distinct
sr.opportunity_id
, sr.sr_account_id
from (
	select
	sr.id
	,sr.client_opportunity__c as opportunity_id
	,sr.sr_account__c as sr_account_id
	,case when sr.isdeleted = 'true' then true else false end as is_deleted
	,row_number() over(partition by sr.id order by sr.lastmodifieddate desc) = 1 as keep
	from crm_salesforce_strength_parquet.client_related_opportunity__c sr 
) as sr
where sr.keep