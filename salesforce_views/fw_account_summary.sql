select
sa.id as account_id
, sa.client_status__c as client_status
, case 
	when sa.numberofemployees = ''
	then null
	else cast(sa.numberofemployees as decimal)
end as employees
, case 
	when sa.number_of_eligible_employees__c = ''
	then null
	else cast(sa.number_of_eligible_employees__c as decimal)
end as eligible_employees
, case
	when employees >= 10000 then 'Large'
	when employees >= 500 then 'Mid'
	when employees >= 1 then 'Small'
	else null
end as newsales_market
, sa.industry
, sa."name" as account
, sa.employer_identification_number_ein__c as ein
, sa.demandbase_sid__c as demandbase_sid
, sa.billingstreet
, sa.billingcity
, sa.billingstate
, sa.billingpostalcode
, os.total_amount
, os.total_annual_amount
, os.opportunity_count
, os.won_opportunities
, os.closed_opportunities
, SPLIT_PART(sc.email,'@',2) as company_domain
from salesforce_custom_reporting.strength_account sa
left join salesforce_custom_reporting.strength_contact sc
	on sa.id = sc.accountid
join (
	select
	so.accountid as account_id
	, sum(
		case 
			when so.annual_amount__c = ''
			then null
			else cast(so.annual_amount__c as decimal(18,2))
		end
	) as total_annual_amount
	, sum(
		case 
			when so.amount = ''
			then null
			else cast(so.amount as decimal(18,2))
		end
	) as total_amount
	, count(distinct so.id) as opportunity_count
	, count(distinct
		case
			when so.stagename = 'Closed Won'
			then so.id else null
		end
	) as won_opportunities
	, count(distinct
		case
			when so.stagename in ('Closed Won', 'Closed Lost')
			then so.id else null
		end
	) as closed_opportunities
	from salesforce_custom_reporting.strength_opportunity so
	group by so.accountid
) as os
	on sa.id = os.account_id