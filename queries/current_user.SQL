--returns the account number of the last logged in user as the current user
CREATE PROCEDURE get_current_user(INOUT account_number CHAR(16))
AS $$
DECLARE curr_username VARCHAR(20);

    BEGIN
        --get username of the latest login
        SELECT l.username INTO curr_username
        FROM login_log AS l
        WHERE l.login_time = (
            SELECT MAX(login_time)
            FROM login_log);

        --get account number of the username
        SELECT a.account_number INTO account_number
        FROM account AS a
        WHERE a.username = curr_username;
    END
$$ LANGUAGE plpgsql;