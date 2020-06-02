select
va.id
, va.visitor_id
, va.prospect_id
, va.campaign_id
, va.form_id
, va.form_handler_id
, va.custom_redirect_id
, va.details
, cast(va.created_at as datetime) as created_at
, min(cast(created_at as datetime)) over (partition by va.prospect_id) 
	= cast(created_at as datetime) as first_custom_redirect_activity
from salesforce_custom_reporting.pardot_visitoractivity va
where va.custom_redirect_id in ('6854', '6856', '6910', '6912', '6908')
	and prospect_id is not null