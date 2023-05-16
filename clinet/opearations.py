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
                               date_of_birth, account_type, interest_rate, message, username])

    conn.commit()
    result = cur.fetchone()
    print(result[0] + "\nusername: " + result[1])


def login():
    username = input("Enter your username:")
    password = input("password:")

    message = " "

    cur.execute("""CALL login(%s::VARCHAR(20), %s::VARCHAR(50),
    %s::VARCHAR(100))""", [username, password, message])

    conn.commit()

    print(cur.fetchone()[0])


def deposit():
    try:
        amount = float(input("Enter amount of deposit:"))
        message = ''
        cur.execute("""CALL deposit(%s::NUMERIC(16,2), %s::VARCHAR(100))""",
                    [amount, message])

        conn.commit()

        print(cur.fetchone()[0])

    except ValueError:
        print("you must enter numeric value!")


def withdraw():
    try:
        amount = float(input("Enter amount of withdraw:"))
        message = ''
        cur.execute("""CALL withdraw(%s::NUMERIC(16,2), %s::VARCHAR(100))""",
                    [amount, message])

        conn.commit()

        print(cur.fetchone()[0])

    except ValueError:
        print("you must enter numeric value!")


def transfer():
    try:
        amount = float(input("Enter amount of transfer:"))
        username = input("To username:")

        message = ''
        cur.execute("""CALL transfer(%s::NUMERIC(16,2), %s::VARCHAR(20), %s::VARCHAR(100))""",
                    [amount, username, message])

        conn.commit()

        print(cur.fetchone()[0])

    except ValueError:
        print("you must enter numeric value!")


def interest_payment():
    try:
        input('Press an enter to pay interest.')
        message = ''
        cur.execute("""CALL interest_payment(%s::VARCHAR(100))""",
                    [message])

        conn.commit()

        print(cur.fetchone()[0])

    except ValueError:
        print("you must enter numeric value!")


def update_balance():
    try:
        input('Press an enter to update balances.')
        cur.execute("""CALL update_balance()""", )

        conn.commit()

        print('balances updated.')

    except ValueError:
        print("you must enter numeric value!")


def check_balance():

    input("Press enter to get your balance.")

    balance = 0
    cur.execute("""CALL check_balance(%s::NUMERIC(16,2));""", [balance])
    conn.commit()

    balance = cur.fetchone()[0]

    print("Your balance is :", balance)

# signup()
# login()
# deposit()
# transfer()
# interest_payment()
# update_balance()
check_balance()