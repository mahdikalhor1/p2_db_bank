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
		    cast(amount AS VARCHAR (16)) || '\n to ' || account_number;
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
		    cast(amount AS VARCHAR (16)) || '\n to ' || account_number;
END;
$$ LANGUAGE plpgsql;