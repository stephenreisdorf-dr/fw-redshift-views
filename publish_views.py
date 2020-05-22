import my_engines
import os

SCRIPT_HEADER = 'create or replace view analytics_sandbox.{name} as'
SCRIPT_FOOTER = 'with no schema binding;'

# List of directories with sql scripts to run
sql_script_directories = [
	'salesforce_views'
]

# Get a Redshift engine
engine = my_engines.get_engine('redshift')

# Get a list of all scripts paths in each sql script directory
scriptpaths = { f.split('.')[0]: os.path.join(d, f) for d in sql_script_directories for f in os.listdir(d) }

# Read the script text from each file
scripts = [
	'\n'.join(
		[
			SCRIPT_HEADER.format(name=name)
			, open(sp).read()
			, SCRIPT_FOOTER
		]
	) for name, sp in scriptpaths.items()
]

# Execute each script
for s in scripts:
	print('Running the following script:')
	print(s)
	print(engine.execute(s))