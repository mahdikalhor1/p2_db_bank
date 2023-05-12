--creating tables of db
CREATE TABLE IF NOT EXISTS account(
	username VARCHAR(20) PRIMARY KEY,
	account_number CHAR(16) UNIQUE,
	password VARCHAR(50) NOT NULL,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	national_id CHAR(10) NOT NULL,
	date_of_birth DATE NOT NULL,
	type VARCHAR(8) CHECK (type IN ('client', 'employee')),
	interest_rate NUMERIC(2,2)
)

CREATE TABLE IF NOT EXISTS login_log(
		username VARCHAR(20) REFERENCES account(username),
		login_time TIMESTAMP NOT NULL)


CREATE TABLE IF NOT EXISTS transactions(
		type varchar(8) CHECK (type IN ('deposit', 'withdraw', 'transfer', 'interest')),
		transaction_time TIMESTAMP NOT NULL,
		from_account CHAR(16),
		to_account CHAR(16),
		amount NUMERIC (16,2) NOT NULL,
		CONSTRAINT type_check CHECK(
		((type = 'deposit' OR type = 'interest') AND from_account IS NULL AND to_account IS NOT NULL)
		AND
		(type = 'withdraw' AND from_account IS NOT NULL AND to_account IS NULL)
		AND
		(type = 'transfer' AND from_account IS NOT NULL AND to_account IS NOT NULL)
		))

CREATE TABLE IF NOT EXISTS latest_balance(
		account_number CHAR(16) REFERENCES account(account_number),
		amount NUMERIC (16,2) NOT NULL)

CREATE TABLE IF NOT EXISTS snapshot_log(
		snapshot_id SERIAL,
		snapshot_time timestamp NOT NULL)
