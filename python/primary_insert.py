import sys
import csv
import helper

filename = sys.argv[1]
host = sys.argv[2]
database = sys.argv[3]
username = sys.argv[4]
try:
    password = sys.argv[5]
except IndexError:
    password = ''

cursor, conn = helper.connect_to_database(host, database, username, password)

def fix_fips(row):
	row['fips'] = row['fips'].split('.')[0]
	if row['state'] == 'New Hampshire':
		return {
			'Belknap' : '001',
			'Carroll' : '003',
			'Cheshire' : '005',
			'Coos' : '007',
			'Grafton' : '009',
			'Hillsborough' :'011',
			'Merrimack' : '013',
			'Rockingham': '015',
			'Strafford' : '017',
			'Sullivan' : '019',
		}.get(row['county'], 'notfound')
	return row['fips']


def state_insert(row):
    cursor.execute("INSERT INTO States "
                   "VALUES (%s, %s) "
                   "ON CONFLICT DO NOTHING;", (row['state_abbreviation'],
                                               row['state']))

def county_insert(row):
	fips = fix_fips(row)
	cursor.execute("INSERT INTO Counties "
				   "VALUES (%s, %s, %s) "
				   "ON CONFLICT DO NOTHING;\n", (fips, row['county'],
				   							   row['state_abbreviation']))


with open(filename) as csvfile:
	reader = csv.DictReader(csvfile)

	inserts = []
	for idx, row in enumerate(reader):
		county_insert(row)

		if idx % 5000 == 0:
			conn.commit()
			print('{} values processed'.format(idx))

conn.commit()
cursor.close()
conn.close()