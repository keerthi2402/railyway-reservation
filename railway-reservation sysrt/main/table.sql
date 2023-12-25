-- Tables

-- Table for storing information about railway stations
CREATE TABLE IF NOT EXISTS railway_station (
    station_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL
);

-- Table for storing information about trains
CREATE TABLE IF NOT EXISTS train (
    train_no SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    src_station_id INT NOT NULL,
    dest_station_id INT NOT NULL,
    total_seats INT NOT NULL CHECK(total_seats >= 0),
    week_days DAY_OF_WEEK[] NOT NULL,
    FOREIGN KEY(src_station_id) REFERENCES railway_station(station_id) ON DELETE CASCADE,
    FOREIGN KEY(dest_station_id) REFERENCES railway_station(station_id) ON DELETE CASCADE
);

-- Table for storing user information
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email_id VARCHAR(100) NOT NULL UNIQUE CHECK(
        email_id ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'
    ),
    age INT NOT NULL CHECK(age > 0),
    mobile_no VARCHAR(20) NOT NULL
);

-- Table for storing information about passengers
CREATE TABLE IF NOT EXISTS passenger (
    pid UUID DEFAULT UUID_GENERATE_V4() PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    age INT NOT NULL CHECK(age > 0)
);

-- Table for storing seat information
CREATE TABLE IF NOT EXISTS seat (
    seat_id SERIAL PRIMARY KEY,
    seat_no INT CHECK(seat_no > 0),
    train_no INT NOT NULL,
    seat_type SEAT_TYPE NOT NULL,
    UNIQUE(seat_no, train_no),
    FOREIGN KEY(train_no) REFERENCES train(train_no) ON DELETE CASCADE
);

-- Table for storing ticket information
CREATE TABLE IF NOT EXISTS ticket (
    pnr UUID DEFAULT UUID_GENERATE_V4() PRIMARY KEY,
    cost INT NOT NULL CHECK(cost > 0),
    src_station_id INT NOT NULL,
    dest_station_id INT NOT NULL,
    train_no INT NOT NULL,
    user_id INT NOT NULL,
    date DATE NOT NULL CHECK(date - CURRENT_DATE >= 0),
    pid UUID NOT NULL,
    seat_id INT DEFAULT NULL,
    seat_type SEAT_TYPE DEFAULT NULL,
    booking_status BOOKING_STATUS DEFAULT 'Waiting',
    booking_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY(src_station_id) REFERENCES railway_station(station_id) ON DELETE CASCADE,
    FOREIGN KEY(dest_station_id) REFERENCES railway_station(station_id) ON DELETE CASCADE,
    FOREIGN KEY(train_no) REFERENCES train(train_no) ON DELETE CASCADE,
    FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY(pid) REFERENCES passenger(pid) ON DELETE CASCADE,
    FOREIGN KEY(seat_id) REFERENCES seat(seat_id) ON DELETE CASCADE
);

-- Table for storing schedule information
CREATE TABLE IF NOT EXISTS schedule (
    sch_id SERIAL PRIMARY KEY,
    train_no INT NOT NULL,
    curr_station_id INT NOT NULL,
    next_station_id INT,
    arr_time DAY_TIME NOT NULL,
    dep_time DAY_TIME NOT NULL CHECK(arr_time <= dep_time),
    fare NUMERIC(7, 2) NOT NULL CHECK(fare >= 0),
    delay_time INTERVAL NOT NULL CHECK(delay_time >= INTERVAL '0'),
    FOREIGN KEY(train_no) REFERENCES train(train_no) ON DELETE CASCADE,
    FOREIGN KEY(curr_station_id) REFERENCES railway_station(station_id) ON DELETE CASCADE,
    FOREIGN KEY(next_station_id) REFERENCES railway_station(station_id) ON DELETE CASCADE
);
