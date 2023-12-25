-- Create a group named 'users'
CREATE GROUP users;

-- Revoke all permissions on specified procedures from the PUBLIC role
REVOKE ALL ON PROCEDURE book_tickets,
                       cancel_booking,
                       allocate_seat
FROM PUBLIC;

-- Grant all permissions on the 'users' table to the 'users' group
GRANT ALL ON TABLE users TO users;

-- Grant all permissions on the 'passenger' table to the 'users' group
GRANT ALL ON TABLE passenger TO users;

-- Grant SELECT permission on the 'ticket' table to the 'users' group
GRANT SELECT ON TABLE ticket TO users;

-- Grant execute permission on specified procedures to the 'users' group
GRANT EXECUTE ON PROCEDURE book_tickets,
                            cancel_booking
TO users;
