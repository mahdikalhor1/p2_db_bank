# this file runs all queries of the queries folder
import psycopg2


def run_queries():
    conn = psycopg2.connect(
        database="bank_db", user='postgres', password='postgres', host='127.0.0.1', port='5432'
    )

    cur = conn.cursor()
    queries = []

    # check that queries are executed or not

    cur.execute("""SELECT EXISTS (
   SELECT FROM pg_tables
   WHERE  tablename = 'account'
    );""")

    # return if queries were ran
    if cur.fetchone()[0]:
        return

    # fetch queries
    with open('./../queries/create_tables.SQL', 'r') as file:
        create_tables = file.read()
        queries.append(create_tables)

    with open('./../queries/account_triggers.SQL', 'r') as file:
        account_triggers = file.read()
        queries.append(account_triggers)

    with open('./../queries/current_user.SQL', 'r') as file:
        current_user = file.read()
        queries.append(current_user)

    with open('./../queries/balance_operations.SQL', 'r') as file:
        balance_operations = file.read()
        queries.append(balance_operations)

    with open('./../queries/registering.SQL', 'r') as file:
        registering = file.read()
        queries.append(registering)

    with open('./../queries/transactions.SQL', 'r') as file:
        transactions = file.read()
        queries.append(transactions)

    # make the first snapshot
    cur.execute("CALL make_snapshot();")

    # run queries
    for query in queries:
        cur.execute(query)

    conn.commit()
    conn.close()


run_queries()
