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


def empty_string_to_null(string):
    if string == '':
        return None
    return string


def state_insert(row):
    cursor.execute("INSERT INTO States "
                   "VALUES (%s, %s) "
                   "ON CONFLICT DO NOTHING;", (row['Locationabbr'],
                                               row['Locationdesc']))


def class_insert(row):
    cursor.execute("INSERT INTO Classes "
                   "VALUES (%s, %s) "
                   "ON CONFLICT DO NOTHING;", (row['ClassId'], row['Class']))


def topic_insert(row):
    cursor.execute("INSERT INTO Topics "
                   "VALUES (%s, %s, %s) "
                   "ON CONFLICT DO NOTHING;\n", (row['TopicId'], row['Topic'],
                                                 row['ClassId']))


def break_out_category_insert(row):
    cursor.execute("INSERT INTO BreakOutCategories "
                   "VALUES (%s, %s) "
                   "ON CONFLICT DO NOTHING;\n", (row['BreakOutCategoryID'],
                                                 row['Break_Out_Category']))


def break_out_insert(row):
    cursor.execute("INSERT INTO BreakOuts "
                   "VALUES (%s, %s, %s) "
                   "ON CONFLICT DO NOTHING;\n", (row['BreakoutID'],
                                                 row['Break_Out'],
                                                 row['BreakOutCategoryID']))


def response_insert(row):
    cursor.execute("INSERT INTO Responses "
                   "VALUES (%s, %s) "
                   'ON CONFLICT DO NOTHING;\n', (row['ResponseID'],
                                                 row['Response']))


def question_insert(row):
    cursor.execute('INSERT INTO Questions '
                   "VALUES (%s, %s, %s) "
                   'ON CONFLICT DO NOTHING;\n', (row['QuestionID'],
                                                 row['Question'],
                                                 row['TopicId']))


def data_value_type_insert(row):
    cursor.execute('INSERT INTO DataValueTypes '
                   "VALUES (%s, %s) "
                   'ON CONFLICT DO NOTHING;\n', (row['Data_value_type'],
                                                 row['Data_value_unit']))


def result_insert(row):
    cursor.execute('INSERT INTO Results'
                   '(year, state, questionId, responseId, breakOutId, '
                   'dataValueType, sampleSize, dataValue, confidenceLimitLow, '
                   'confidenceLimitHigh, footnoteSymbol, footnote) '
                   "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", (
                       row['Year'], row['Locationabbr'], row['QuestionID'],
                       row['ResponseID'], row['BreakoutID'],
                       row['Data_value_type'], row['Sample_Size'],
                       row['Data_value'], row['Confidence_limit_Low'],
                       row['Confidence_limit_High'],
                       row['Data_Value_Footnote_Symbol'],
                       row['Data_Value_Footnote']
                   ))


with open(filename) as csvfile:
    # sniffer = csv.Sniffer()
    # dialect = sniffer.sniff(csvfile.read(1024), delimiters=[','])
    reader = csv.DictReader(csvfile)

    inserts = []
    for idx, row in enumerate(reader):
        # Empty values to None
        row['Data_value'] = empty_string_to_null(row['Data_value'])
        row['Confidence_limit_Low'] = empty_string_to_null(
            row['Confidence_limit_Low'])
        row['Confidence_limit_High'] = empty_string_to_null(
            row['Confidence_limit_High'])

        state_insert(row)
        class_insert(row)
        topic_insert(row)
        break_out_category_insert(row)
        break_out_insert(row)
        response_insert(row)
        question_insert(row)
        data_value_type_insert(row)
        response_insert(row)
        result_insert(row)

        if idx % 5000 == 0:
            conn.commit()
            print('{} values processed'.format(idx))

conn.commit()
cursor.close()
conn.close()
