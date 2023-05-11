
--this function creates and sets username account number for user
--creates unique username and account number using datetime
--and creates balance for account in latest balance table
--and hashes the pass
CREATE FUNCTION complete_fields()
RETURNS TRIGGER
 AS $$
DECLARE seconds numeric(16);
DECLARE account_number CHAR(16);
DECLARE username VARCHAR(20);
BEGIN
    seconds = (select cast(extract(epoch from now()) * 1000000 as numeric(16)));
    account_number = cast(seconds as char(16));
    username = NEW.last_name || right(account_number, 5);

    --set interest rate of employees to zero
    UPDATE account
    SET insert_rate = 0
    WHERE username IS NULL and type = 'employee';


    UPDATE account
    SET account.username = username, account.account_number = account_number,
    --hash the password
    password = sha256(password),
    WHERE account.username IS NULL;

    --insert balance for account
    INSERT INTO latest_balance(account_number, amount) VALUES (NEW.account_number, 0.00);

    RETURN NEW;
END
$$ LANGUAGE plpgsql;


--run the complete fields function after inserting each row to account
CREATE TRIGGER account_insertion AFTER INSERT ON account
FOR EACH ROW EXECUTE PROCEDURE complete_fields();
