from connection import Connection


connection = Connection()
conn = connection.conn
cur = connection.cur

def signup():

    first_name = input("Enter Your first name:")
    last_name = input("Last name:")
    national_id = input("National ID:")
    date_of_birth = input("date of base:(yyyy-mm-dd)")
    account_type = input("Type: (client or employee)")
    interest_rate = float(input("Interest rate: (a number between 0 and 1)"))
    password = input("Password:")

    username = ""
    message = ""

    cur.execute("""CALL register(%s::VARCHAR(50) ,%s::VARCHAR(20),
       %s::VARCHAR(20), %s::CHAR(10), %s::DATE,
       %s::VARCHAR(8), %s::NUMERIC(2,2), %s::VARCHAR(100),
        %s::VARCHAR(20));""", [password, first_name, last_name, national_id,
                                   date_of_birth, account_type, interest_rate, message,username])

    conn.commit()
    result = cur.fetchone()
    print(result[0] + "\nusername: "+result[1])

