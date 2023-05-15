
--this function sets employees interest rate to zero
--and creates balance for account in latest balance table
CREATE FUNCTION complete_fields()
RETURNS TRIGGER
 AS $$
BEGIN
    --set interest rate of employees to zero
    UPDATE account
    SET interest_rate = 0
    WHERE username = NEW.username and type = 'employee';

    --insert balance for account
    INSERT INTO latest_balance(account_number, amount) VALUES (NEW.account_number, 0.00);
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE PROCEDURE get_username(last_name VARCHAR(15),account_number CHAR(16) ,
 INOUT username VARCHAR(20))
AS $$

    BEGIN
        username = last_name || right(account_number, 5);
    END

$$ LANGUAGE plpgsql;

CREATE PROCEDURE get_account_number(INOUT account_number CHAR(16))
AS $$

    DECLARE seconds numeric(16);
    BEGIN
        seconds = (select cast(extract(epoch from now()) * 1000000 as numeric(16)));
        account_number = cast(seconds as char(16));
    END

$$ LANGUAGE plpgsql;


--run the complete fields function after inserting each row to account
CREATE TRIGGER account_insertion AFTER INSERT ON account
FOR EACH ROW EXECUTE PROCEDURE complete_fields();
