import psycopg2

class Connection:

    def __init__(self):
        conn = psycopg2.connect(
            database="bank_db", user='postgres', password='postgres', host='127.0.0.1', port='5432'
        )

        self.cur = conn.cursor()