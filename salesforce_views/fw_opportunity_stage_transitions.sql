select 
o.opportunityid as opportunity_id
,o.newvalue as stage
,count(*) as records
,max(cast(o.createddate as date)) as start_date
from crm_salesforce_strength_parquet.opportunityfieldhistory o
where field = 'StageName'
group by
o.opportunityid
,o.newvalue
,o.createddate