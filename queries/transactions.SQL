CREATE PROCEDURE deposit(amount numeric(16,2), INOUT message VARCHAR(100))
AS $$
DECLARE username VARCHAR(20);
DECLARE account_number CHAR(16);

BEGIN

    --get username of the latest login
    SELECT l.username INTO username
    FROM login_log AS l
    WHERE l.login_time = (
        SELECT MAX(login_time)
        FROM login_log);

    --get account number of the username
    SELECT a.account_number INTO account_number
    FROM account AS a
    WHERE a.username = username;

    INSERT INTO transactions(
		type,
		transaction_time,
		from_account,
		to_account,
		amount) VALUES ('deposit', NOW(), NULL, account_number, amount);
		message := 'Deposit transaction done\n' || 'amount : ' ||
		    cast(amount AS VARCHAR (16)) || '\nto ' || account_number;
END;
$$ LANGUAGE plpgsql;


CREATE PROCEDURE withdraw(amount numeric(16,2), INOUT message VARCHAR(100))
AS $$
DECLARE username VARCHAR(20);
DECLARE account_number CHAR(16);

BEGIN

    --get username of the latest login
    SELECT l.username INTO username
    FROM login_log AS l
    WHERE l.login_time = (
        SELECT MAX(login_time)
        FROM login_log);

    --get account number of the username
    SELECT a.account_number INTO account_number
    FROM account AS a
    WHERE a.username = username;

    INSERT INTO transactions(
		type,
		transaction_time,
		from_account,
		to_account,
		amount) VALUES ('withdraw', NOW(), account_number, NULL, amount);
		message := 'Withdraw transaction done\n' || 'amount : ' ||
		    cast(amount AS VARCHAR (16)) || '\nfrom ' || account_number;
END;
$$ LANGUAGE plpgsql;


CREATE PROCEDURE transfer(amount numeric(16,2), to_username VARCHAR(20), INOUT message VARCHAR(100))
AS $$
DECLARE username VARCHAR(20);
DECLARE account_number CHAR(16);
DECLARE to_account CHAR(16);
BEGIN

    --get username of the latest login
    SELECT l.username INTO username
    FROM login_log AS l
    WHERE l.login_time = (
        SELECT MAX(login_time)
        FROM login_log);

    --get account number of the username
    SELECT a.account_number INTO account_number
    FROM account AS a
    WHERE a.username = username;

    --get account number of destination account
    SELECT a.account_number INTO to_account
    FROM account as a
    WHERE a.username = to_username;

    IF to_account IS NOT NULL
                        THEN

    INSERT INTO transactions(
		type,
		transaction_time,
		from_account,
		to_account,
		amount) VALUES ('Transfer', NOW(), account_number, to_account, amount);
		message := 'Transfer transaction done\n' || 'amount : ' ||
		    cast(amount AS VARCHAR (16)) || '\nfrom ' || account_number
		    || '\nto ' || to_account;
    ELSE
        message :='transaction failed! There is no account with username : ' || to_username;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE PROCEDURE interest_payment(INOUT message VARCHAR(100))
AS $$
DECLARE username VARCHAR(20);
DECLARE account_number CHAR(16);
DECLARE interest_rate
BEGIN

    --get username of the latest login
    SELECT l.username INTO username
    FROM login_log AS l
    WHERE l.login_time = (
        SELECT MAX(login_time)
        FROM login_log);

    --get account number and interest rate of the user
    SELECT a.account_number INTO account_number, l.interest_rate INTO interest_rate
    FROM account AS a
    WHERE a.username = username;

    INSERT INTO transactions(
		type,
		transaction_time,
		from_account,
		to_account,
		amount) VALUES ('deposit', NOW(), NULL, account_number, interest_rate);
		message := 'Interest payment done\n' || 'rate : ' ||
		    cast(amount AS VARCHAR (16)) || '\nto ' || account_number;
END;
$$ LANGUAGE plpgsql;