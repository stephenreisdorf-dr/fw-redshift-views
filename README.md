# Shared Queries Documentation

## Salesforce Views

### Financial Wellness Opportunities
- Each row represents a single opportunity
- Record type and owner are denormalized from their respective foreign keys

### Financial Wellness Opportunity Stage Transitions

### Financial Wellness Payments

### Financial Wellness Accounts

### Strategic Relationships Mapping

### Strategic Relationships Tagged

## Product Views

### User Survey Completion
- Gets survey completion engagements from the engagements_api.
	- Looks for engagement_id 25 and 23 which are `smartdollar.survey.onboarding.wellness` and `smartdollar.survey.wellness` respectively.
	- Keeps a single record for each survey (Tableau aggregates to user using distinct counts).
- Filters out and gets company information from smartdollar_report database.
	- Uses `participants` table to get company and enrollment mappings.
	- Gets external_id from the `companies` table.
	- Filters on exclude_from_aggregate_reports = 0 from the `enrollments`.
- Identifies companies using the new survey from the feature flags in smartdollar_app database.
	- Looks for the feature `onboarding_survey_test`
	- Assumes that this feature will always be applied at the company level (only execptions at the time of creation are internal enrollments that are excluded anyway).
	- Filters for `true` using the odd string present in the table.

### User Events
This query leverages engagement api data to summarize the timestamps of key events in users journey.
- First login
- Last login
- Second login
