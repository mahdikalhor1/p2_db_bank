
--this function creates and sets username account number for user
--creates unique username and account number using datetime
--and sets the accounts balance to 0
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

    UPDATE account
    SET account.username = username, account.account_number = account_number,
    account.balance = 0.00
    WHERE account.username IS NULL;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;


--run the complete fields function after inserting each row to account
CREATE TRIGGER account_insertion AFTER INSERT ON account
FOR EACH ROW EXECUTE PROCEDURE complete_fields()
