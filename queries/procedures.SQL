    --registers new users
    CREATE PROCEDURE register(password VARCHAR(50) ,first_name VARCHAR(20),
       last_name VARCHAR(20), national_id CHAR(10), date_of_birth DATE,
       type VARCHAR(8), interest_rate INT, INOUT message VARCHAR(100))
       AS $$
       DECLARE age int;
       DECLARE username VARCHAR(20);
       DECLARE account_number CHAR(16);
       BEGIN

       age := EXTRACT(year FROM CURRENT_DATE) - EXTRACT(year FROM date_of_birth);
       CALL get_account_number(account_number);
       CALL get_username(last_name, account_number, username);

       IF age < 13 THEN
            message := 'You are under age! (users age must be at least 13)';
       ELSE
            INSERT INTO account(
	username, account_number, password, first_name, last_name, national_id,
	date_of_birth, type, interest_rate)
	VALUES (username, account_number, sha256(password), first_name, last_name,
	national_id, date_of_birth, type, interest_rate);
	    message := 'account created successfully.';
       END IF;
    END;
$$ LANGUAGE plpgsql;



--login to account
--gets username and password
--and adds log to the login loges in successful logging in
CREATE PROCEDURE login(username VARCHAR(20), password VARCHAR(50),
 INOUT message VARCHAR(100))
AS $$
DECLARE correct_pass VARCHAR(50);

    BEGIN
    SELECT a.password into correct_pass
    FROM account AS a
    WHERE a.username = username;

    CASE

        WHEN correct_pass IS NULL THEN
            message := 'Invalid username. account with username ' || username || ' not found!';
        WHEN correct_pass <> sha256(password) THEN
         message := 'Incorrect password!';
        ELSE
            INSERT INTO login_log(
		    username ,
		    login_time) VALUES (username, NOW());
            message := 'Logged in successfully.';
    END CASE;
END;
$$
LANGUAGE plpgsql;



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

