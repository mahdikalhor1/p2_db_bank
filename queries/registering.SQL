    --registers new users
    CREATE PROCEDURE register(password VARCHAR(500) ,first_name VARCHAR(20),
       last_name VARCHAR(20), national_id CHAR(10), date_of_birth DATE,
       type VARCHAR(8), interest_rate NUMERIC(2,2), INOUT message VARCHAR(100)
       ,INOUT DECLARE username VARCHAR(20))
       AS $$
       DECLARE age int;
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
	VALUES (username, account_number, digest(password, 'sha256'), first_name, last_name,
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
        WHEN correct_pass <> digest(password, 'sha256') THEN
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

