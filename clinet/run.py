import config

from opearations import Operatinos

operations = Operatinos()


def menu():
    print("\nsignup\nlogin\ndeposit\nwithdraw\ntransfer\ninterest payment\nupdate balance\ncheck balance")


def run():
    # run queries to create tables and procedures
    config.run_queries()

    while True:
        menu()
        input_value = input("Choose an action:(enter f to terminate)\n")

        if input_value == 'signup':
            operations.signup()
        elif input_value == 'login':
            operations.login()
        elif input_value == 'deposit':
            operations.deposit()
        elif input_value == 'withdraw':
            operations.withdraw()
        elif input_value == 'transfer':
            operations.transfer()
        elif input_value == 'interest payment':
            operations.interest_payment()
        elif input_value == 'update balance':
            operations.update_balance()
        elif input_value == 'check balance':
            operations.check_balance()
        elif input_value == 'f':
            print("finished.")
            return
        else:
            print("Invalid input!")


run()
