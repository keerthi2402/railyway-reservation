-- User Defined Types

-- Define an enumeration type for days of the week
CREATE TYPE DAY_OF_WEEK AS ENUM (
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
);

-- Define an enumeration type for seat types
CREATE TYPE SEAT_TYPE AS ENUM ('AC', 'NON-AC');

-- Define an enumeration type for booking statuses
CREATE TYPE BOOKING_STATUS AS ENUM('Waiting', 'Booked', 'Cancelled');

-- Define a composite type for day and time
CREATE TYPE DAY_TIME AS (
    day_of_journey INT,  -- Max value is 7
    time TIME
);

-- Extensions

-- Create or verify the existence of the "uuid-ossp" extension for UUID generation
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create or verify the existence of the "intarray" extension for integer arrays
CREATE EXTENSION IF NOT EXISTS "intarray";
