CREATE TYPE TRANS as (type varchar(8),
    amount NUMERIC(16,2),
    from_account CHAR(16));


CREATE PROCEDURE update_balance()
AS $$
DECLARE latest_update TIMESTAMP;
DECLARE account_number CHAR(16);

    BEGIN

    --get latest updates date
    SELECT snapshot_time INTO latest_update
    FROM snapshot_log
    WHERE snapshot_id = (
                            SELECT max(snapshot_id)
                            FROM snapshot_log);

    FOR account_number IN (SELECT account_number
                           FROM latest_balance)
        LOOP

        --call the update balance procedure to update balance of each account
        CALL update_balance(account_number , latest_update);

        END LOOP;

    --save time of current update
    CALL make_snapshot();

    END
$$ LANGUAGE plpgsql;



CREATE OR REPLACE PROCEDURE update_balance(account_number VARCHAR(20), latest_update TIMESTAMP)
AS $$
DECLARE
    new_balance NUMERIC(16,2);

    trans TRANS;

BEGIN

    SELECT amount INTO new_balance
    FROM latest_balance
    WHERE account_number = account_number;

    FOR trans IN (
        SELECT type, from_account, amount
        FROM transactions
        WHERE transaction_time > latest_update AND
            (from_account = account_number OR to_account = account_number)
        ORDER BY transaction_time DESC
    ) LOOP

        CASE trans.type
        WHEN 'deposit' THEN
            new_balance := new_balance + trans.amount;
        WHEN 'withdraw' THEN
            new_balance := new_balance - trans.amount;
        WHEN 'transfer' THEN
            IF trans.from_account = account_number THEN
                new_balance := new_balance - trans.amount;
            ELSE
                new_balance := new_balance + trans.amount;
            END IF;
        ELSE -- assume type is 'interest'
            new_balance := new_balance * (1 + trans.amount);
        END CASE;

    END LOOP;

    --update balance of current user
    UPDATE latest_balance AS l
    SET amount = new_balance
    WHERE l.account_number = account_number;
END;
$$ LANGUAGE plpgsql;

--makes snapshot of the latest update
CREATE PROCEDURE make_snapshot()
AS $$
    BEGIN
    INSERT INTO snapshot_log(
		snapshot_time) VALUES (NOW());
    END
$$ LANGUAGE plpgsql;


CREATE PROCEDURE check_balance(INOUT curr_balance NUMERIC(16,2))
AS $$

DECLARE account_number CHAR(16);

    BEGIN

    CALL get_current_user(account_number);

    SELECT amount INTO curr_balance
    FROM latest_balance
    WHERE account_number = account_number;
    END

$$ LANGUAGE plpgsql;