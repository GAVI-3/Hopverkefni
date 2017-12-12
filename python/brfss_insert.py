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

# cursor, conn = helper.connect_to_database(host, database, username, password)


def class_insert(row):
    return ('INSERT INTO Classes '
            'VALUES ("{}", "{}") '
            'ON CONFLICT DO NOTHING;\n'.format(row['ClassId'], row['Class']))


def topic_insert(row):
    return ('INSERT INTO Topics '
            'VALUES ("{}", "{}", "{}") '
            'ON CONFLICT DO NOTHING;\n'.format(row['TopicId'], row['Topic'],
                                               row['ClassId']))


def break_out_category_insert(row):
    return ('INSERT INTO BreakOutCategories '
            'VALUES ("{}", "{}") '
            'ON CONFLICT DO NOTHING;\n'.format(row['BreakOutCategoryID'],
                                               row['Break_Out_Category']))


def break_out_insert(row):
    return ('INSERT INTO BreakOuts '
            'VALUES ("{}", "{}", "{}") '
            'ON CONFLICT DO NOTHING;\n'.format(row['BreakoutID'],
                                               row['Break_Out'],
                                               row['BreakOutCategoryID']))


def response_insert(row):
    return ('INSERT INTO Responses '
            'VALUES ("{}", "{}") '
            'ON CONFLICT DO NOTHING;\n'.format(row['ResponseID'],
                                               row['Response']))


def question_insert(row):
    return ('INSERT INTO Questions '
            'VALUES ("{}", "{}", "{}") '
            'ON CONFLICT DO NOTHING;\n'.format(row['QuestionID'],
                                               row['Question'],
                                               row['TopicId']))


def data_value_type_insert(row):
    return ('INSERT INTO DataValueTypes '
            'VALUES ("{}", "{}") '
            'ON CONFLICT DO NOTHING;\n'.format(row['Data_value_type'],
                                               row['Data_value_unit']))


def result_insert(row):
    return ('INSERT INTO Results '
            'VALUES ("{}", "{}", "{}", "{}", "{}", "{}", "{}")'.format(
                row['BreakoutID'], row['Data_value_type'], row['Sample_Size'],
                row['Data_value'], row['Confidence_limit_Low'],
                row['Confidence_limit_High'],
                row['Data_Value_Footnote_Symbol'], row['Data_Value_Footnote']
            ))


with open(filename) as csvfile:
    # sniffer = csv.Sniffer()
    # dialect = sniffer.sniff(csvfile.read(1024), delimiters=[','])
    reader = csv.DictReader(csvfile)

    inserts = []
    for row in reader:
        inserts.append(class_insert(row))
        inserts.append(topic_insert(row))
        inserts.append(break_out_category_insert(row))
        inserts.append(break_out_insert(row))
        inserts.append(response_insert(row))
        inserts.append(question_insert(row))
        inserts.append(data_value_type_insert(row))
        inserts.append(response_insert(row))
    print(inserts[0])
