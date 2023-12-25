-- Create a database group for administrators
CREATE GROUP dbAdmin;

-- Grant all privileges on the 'railway_reservation_system' database to the 'dbAdmin' group
GRANT ALL ON DATABASE railway_reservation_system TO dbAdmin;

-- Grant all privileges on all tables in the public schema to the 'dbAdmin' group
GRANT ALL ON ALL TABLES IN SCHEMA PUBLIC TO dbAdmin;

-- Allow members of the 'dbAdmin' group to bypass Row-Level Security (RLS)
ALTER ROLE dbAdmin BYPASSRLS;

-- Create a user 'mno' and associate it with the 'dbAdmin' group, allowing bypass of RLS
CREATE USER mno IN GROUP dbAdmin BYPASSRLS PASSWORD 'mno';

-- Create a user 'pqr' and associate it with the 'dbAdmin' group, allowing bypass of RLS
CREATE USER pqr IN GROUP dbAdmin BYPASSRLS PASSWORD 'pqr';
