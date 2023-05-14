from connection import Connection


conn = Connection()
cur = conn.cur

def signin():

    first_name = input("Enter Your first name:")
    last_name = input("Last name:")
    national_id = input("National ID:")
    date_of_birth = input("date of base:(yyyy-mm-dd)")
    type_ = input("Type: (client or employee)")
    interest_rate = float(input("Interest rate: (a number between 0 and 1)"))
    password = input("Password:")

    username = str
    message = str

    cur.execute("""CALL register(%s::VARCHAR(50) ,%s::VARCHAR(20),
       %s::VARCHAR(20), %s::CHAR(10), %s::DATE,
       %s::VARCHAR(8), %s::NUMERIC(2,2), %s::VARCHAR(100),
        %s::VARCHAR(20));""", [password, first_name, last_name, national_id,
                                   date_of_birth, type_, interest_rate, message,
                                   username])
    print(cur.fetchone()[0])

signin()