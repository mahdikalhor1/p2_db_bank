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
