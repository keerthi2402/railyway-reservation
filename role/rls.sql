-- Enable Row-Level Security on the 'users' table
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Create a policy ('users_policy') on the 'users' table that restricts access to rows where 'email_id' matches the current user
CREATE POLICY users_policy
    ON users
    FOR ALL
    TO users
    USING (email_id = CURRENT_USER);

-- Enable Row-Level Security on the 'ticket' table
ALTER TABLE ticket ENABLE ROW LEVEL SECURITY;

-- Create a policy ('ticket_policy') on the 'ticket' table that allows users to SELECT only their own tickets
CREATE POLICY ticket_policy
    ON ticket
    FOR SELECT
    TO users
    USING (ticket.user_id = (SELECT user_id
                             FROM users
                             WHERE email_id = CURRENT_USER));

-- Enable Row-Level Security on the 'passenger' table
ALTER TABLE passenger ENABLE ROW LEVEL SECURITY;

-- Create a policy ('passenger_policy') on the 'passenger' table that restricts access to rows associated with tickets of the current user
CREATE POLICY passenger_policy
    ON passenger
    FOR ALL
    TO users
    USING (passenger.pid = ANY(SELECT pid
                               FROM ticket
                               WHERE ticket.user_id = (SELECT user_id
                                                       FROM users
                                                       WHERE email_id = CURRENT_USER)));
                                                    )
                        )
    );                            
