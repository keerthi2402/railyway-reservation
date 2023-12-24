-- Helper functions/procedures for other different queries

-- 1. Users can book tickets for multiple passengers
CREATE OR REPLACE PROCEDURE book_tickets(
    in_name VARCHAR(100)[],
    in_age INT[],
    in_seat_type SEAT_TYPE[],
    src_station VARCHAR(100),
    dest_station VARCHAR(100),
    train_name VARCHAR(100),
    in_date DATE
)
AS $$
DECLARE
    fare INT;
    src_id INT;
    dest_id INT;
    train_number INT;
    in_user_id INT;
    temp_id UUID;
    num_names INT;
    in_pid UUID;
BEGIN
    -- Input validation
    ASSERT ARRAY_LENGTH(in_name, 1) = ARRAY_LENGTH(in_age, 1), 'Number of names and ages for passengers do not match';
    ASSERT ARRAY_LENGTH(in_name, 1) = ARRAY_LENGTH(in_seat_type, 1), 'Number of names and seat types for passengers do not match';

	-- Extracting different variables
    SELECT get_user_id(SESSION_USER::VARCHAR(100))
    INTO in_user_id ;

    SELECT get_train_no(train_name)
    INTO train_number;

    SELECT get_station_id(src_station)
    INTO src_id;

    SELECT get_station_id(dest_station)
    INTO dest_id;

    -- Check if the train runs on the day of booking
    PERFORM validate_train_days_at_station(src_id, train_number, in_date);

    -- Get cost of the ticket
    SELECT get_fare(train_name, src_station, dest_station)
    INTO fare;

    -- Storing lengths of arrays
    SELECT ARRAY_LENGTH(in_name, 1)
    INTO num_names;

    FOR i IN 1 .. num_names LOOP
        -- Create a new passenger
        INSERT INTO passenger(name, age)
        VALUES (in_name[i], in_age[i])
        RETURNING pid INTO in_pid;

        -- Create tickets for each passenger with initial booking_status as 'Waiting'
        INSERT INTO ticket(cost, src_station_id, dest_station_id, train_no, user_id, date, pid, seat_type)
        VALUES (fare, src_id, dest_id, train_number, in_user_id, in_date, in_pid, in_seat_type[i]);
    END LOOP;

	-- COMMIT;
END;
$$ LANGUAGE PLPGSQL
   SECURITY DEFINER;


-- 2. Cancel booking
CREATE OR REPLACE PROCEDURE cancel_booking(in_pnr UUID)
AS $$
BEGIN
    PERFORM validate_pnr(in_pnr);

    -- Update ticket table
    UPDATE ticket
    SET booking_status = 'Cancelled',
        seat_id = NULL
    WHERE pnr = in_pnr;
END;
$$ LANGUAGE PLPGSQL
   SECURITY DEFINER;


-- 3. Confirm the status and allocate a seat to the ticket of the passenger - Admin
CREATE OR REPLACE PROCEDURE allocate_seat(
    in_pnr UUID,
    in_train_name VARCHAR(100),
    in_src_station_name VARCHAR(100),
    in_dest_station_name VARCHAR(100),
    in_date DATE,
    in_seat_type SEAT_TYPE
)
LANGUAGE PLPGSQL
AS $$
DECLARE
    in_train_no INT;
    in_src_station_id INT;
    in_dest_station_id INT;
    sch_ids INT[] := ARRAY[]::INT[];
    reservation_info RECORD;
    val INT;
    tmp_seat_id INT;
    idx INT;
    in_total_seats INT;
BEGIN
    -- Getting the declared values
    SELECT get_train_no(in_train_name)
    INTO in_train_no;

    SELECT get_station_id(in_src_station_name)
    INTO in_src_station_id;

    SELECT get_station_id(in_dest_station_name)
    INTO in_dest_station_id;

    -- Check if the train runs on the day of the booking
    PERFORM validate_train_days_at_station(in_src_station_id, in_train_no, in_date);

    -- Getting the sch_ids
    SELECT get_sch_ids(in_train_no, in_src_station_id, in_dest_station_id)
    INTO sch_ids;

    -- Total seats
    SELECT total_seats
    INTO in_total_seats
    FROM train
    WHERE train_no = in_train_no;

    -- Create a temporary table for reservation
    CREATE TEMPORARY TABLE reservation (
        sch_id INT,
        seat_id INT,
        res_seat_type SEAT_TYPE,
        booked BOOLEAN
    );

    CREATE INDEX temp_res_sch ON reservation USING HASH(sch_id);
    CREATE INDEX temp_res_seat_id ON reservation USING HASH(seat_id);

    -- Add all possible pairs of schedule_id and seat_id to the temporary table
    FOR idx IN 1 .. in_total_seats
    LOOP
        FOREACH val IN ARRAY sch_ids
        LOOP
            SELECT seat_type
            INTO res_seat_type
            FROM seat
            WHERE train_no = in_train_no
            AND seat_no = idx;

            INSERT INTO reservation(sch_id, seat_id, res_seat_type, booked)
            VALUES (val, idx, res_seat_type, FALSE);
        END LOOP;
    END LOOP;

    -- Updating booked values
    FOR reservation_info IN (SELECT src_station_id AS travel_src_station,
                                dest_station_id AS travel_dest_station,
                                seat_id
                            FROM ticket
                            WHERE (date - get_journey_at_station(src_station_id, train_no) + 1) =
                                (in_date - get_journey_at_station(in_src_station_id, in_train_no) + 1)
                                AND train_no = in_train_no
                                AND booking_status = 'Booked'
                                AND seat_type = in_seat_type
                            )
    LOOP
        FOREACH val IN ARRAY get_sch_ids(
                                in_train_no,
                                reservation_info.travel_src_station,
                                reservation_info.travel_dest_station
                            )
        LOOP
            UPDATE reservation
            SET booked = TRUE
            WHERE sch_id = val
                AND seat_id = reservation_info.seat_id
                AND res_seat_type = in_seat_type;
        END LOOP;

    END LOOP;

    -- NOTE: source and destination stations are
    -- source and destination of journey, not of the train

    -- Getting the best seat in tmp_seat_id

    -- This will give the empty seats for the given path
    -- SELECT seat_id FROM reservation WHERE (sch_id = ANY (sch_ids))
    -- GROUP BY seat_id H
