-- Create a group named 'station_master'
CREATE GROUP station_master;

-- Revoke all permissions on specified procedures from the PUBLIC role
REVOKE ALL ON PROCEDURE add_railway_station,
                       add_schedule,
                       update_train_status
FROM PUBLIC;

-- Grant all permissions on specified tables to the 'station_master' group
GRANT ALL ON TABLE railway_station TO station_master;
GRANT ALL ON TABLE schedule TO station_master;
GRANT ALL ON TABLE train TO station_master;
GRANT ALL ON TABLE seat TO station_master;

-- Grant execute permission on specified procedures to the 'station_master' group
GRANT EXECUTE ON PROCEDURE add_railway_station,
                            add_schedule,
                            update_train_status
TO station_master;

-- Create a user 'qpr' in the 'station_master' group with the specified password
CREATE USER qpr IN GROUP station_master PASSWORD 'qpr';

-- Create a user 'pst' in the 'station_master' group with the specified password
CREATE USER pst IN GROUP station_master PASSWORD 'pst';
