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


def fix_county_name(row):
    tokens = row['county_name'].split()
    if len(tokens) > 1 and tokens[-1] == 'County':
        row['county_name'] = ' '.join(tokens[:-1])


def fix_diff(row):
    row['diff'] = row['diff'].replace(',', '')


def fix_per_point_diff(row):
    row['per_point_diff'] = row['per_point_diff'][:-1]


def integerize_integers(row):
    row['votes_dem'] = int(float(row['votes_dem']))
    row['votes_gop'] = int(float(row['votes_gop']))
    row['total_votes'] = int(float(row['total_votes']))


def county_insert(row):
    cursor.execute("INSERT INTO Counties "
                   "VALUES (%s, %s, %s) "
                   "ON CONFLICT DO NOTHING;\n", (row['combined_fips'],
                                                 row['county_name'],
                                                 row['state_abbr']))


def genearal_votes_insert(row):
    cursor.execute("INSERT INTO GeneralVotes "
                   "VALUES (%s, %s ,%s, %s, %s, %s, %s, %s, %s, %s)"
                   "ON CONFLICT DO NOTHING;\n", (row['id'],
                                                 row['votes_dem'],
                                                 row['votes_gop'],
                                                 row['total_votes'],
                                                 row['per_dem'],
                                                 row['per_gop'],
                                                 row['diff'],
                                                 row['per_point_diff'],
                                                 row['state_abbr'],
                                                 row['combined_fips']))


with open(filename) as csvfile:
    reader = csv.DictReader(csvfile)

    inserts = []
    for idx, row in enumerate(reader):
        fix_county_name(row)
        fix_diff(row)
        fix_per_point_diff(row)
        integerize_integers(row)
        county_insert(row)
        genearal_votes_insert(row)

        if idx % 5000 == 0:
            conn.commit()
            print('{} values processed'.format(idx))

conn.commit()
cursor.close()
conn.close()
