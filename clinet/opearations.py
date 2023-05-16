from connection import Connection


class Operatinos:

    def __init__(self):
        self.connection = Connection()
        self.conn = self.connection.conn
        self.cur = self.connection.cur

    def signup(self):
        first_name = input("Enter Your first name:")
        last_name = input("Last name:")
        national_id = input("National ID:")
        date_of_birth = input("date of base:(yyyy-mm-dd)")
        account_type = input("Type: (client or employee)")
        interest_rate = float(input("Interest rate: (a number between 0 and 1)"))
        password = input("Password:")

        username = ""
        message = ""

        self.cur.execute("""CALL register(%s::VARCHAR(50) ,%s::VARCHAR(20),
           %s::VARCHAR(20), %s::CHAR(10), %s::DATE,
           %s::VARCHAR(8), %s::NUMERIC(2,2), %s::VARCHAR(100),
            %s::VARCHAR(20));""", [password, first_name, last_name, national_id,
                                   date_of_birth, account_type, interest_rate, message, username])

        self.conn.commit()
        result = self.cur.fetchone()
        print(result[0] + "\nusername: " + result[1])

    def login(self):
        username = input("Enter your username:")
        password = input("password:")

        message = " "

        self.cur.execute("""CALL login(%s::VARCHAR(20), %s::VARCHAR(50),
        %s::VARCHAR(100))""", [username, password, message])

        self.conn.commit()

        print(self.cur.fetchone()[0])

    def deposit(self):
        try:
            amount = float(input("Enter amount of deposit:"))
            message = ''
            self.cur.execute("""CALL deposit(%s::NUMERIC(16,2), %s::VARCHAR(100))""",
                             [amount, message])

            self.conn.commit()

            print(self.cur.fetchone()[0])

        except ValueError:
            print("you must enter numeric value!")

    def withdraw(self):
        try:
            amount = float(input("Enter amount of withdraw:"))
            message = ''
            self.cur.execute("""CALL withdraw(%s::NUMERIC(16,2), %s::VARCHAR(100))""",
                             [amount, message])

            self.conn.commit()

            print(self.cur.fetchone()[0])

        except ValueError:
            print("you must enter numeric value!")

    def transfer(self):
        try:
            amount = float(input("Enter amount of transfer:"))
            username = input("To username:")

            message = ''
            self.cur.execute("""CALL transfer(%s::NUMERIC(16,2), %s::VARCHAR(20), %s::VARCHAR(100))""",
                             [amount, username, message])

            self.conn.commit()

            print(self.cur.fetchone()[0])

        except ValueError:
            print("you must enter numeric value!")

    def interest_payment(self):
        try:
            input('Press an enter to pay interest.')
            message = ''
            self.cur.execute("""CALL interest_payment(%s::VARCHAR(100))""",
                             [message])

            self.conn.commit()

            print(self.cur.fetchone()[0])

        except ValueError:
            print("you must enter numeric value!")

    def update_balance(self):
        try:
            input('Press an enter to update balances.')
            self.cur.execute("""CALL update_balance()""", )

            self.conn.commit()

            print('balances updated.')

        except ValueError:
            print("you must enter numeric value!")

    def check_balance(self):

        input("Press enter to get your balance.")

        balance = 0
        self.cur.execute("""CALL check_balance(%s::NUMERIC(16,2));""", [balance])
        self.conn.commit()

        balance = self.cur.fetchone()[0]

        print("Your balance is :", balance)

# signup()
# login()
# deposit()
# transfer()
# interest_payment()
# update_balance()
# check_balance()
