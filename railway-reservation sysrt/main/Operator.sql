-- Operator: DAY_TIME <= DAY_TIME
CREATE OR REPLACE FUNCTION le_day_time(dt1 DAY_TIME, dt2 DAY_TIME)
RETURNS BOOL
LANGUAGE PLPGSQL
AS $$
BEGIN
    IF dt1.day_of_journey < dt2.day_of_journey OR (dt1.day_of_journey = dt2.day_of_journey AND dt1.time <= dt2.time) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$;

CREATE OPERATOR <= (
    PROCEDURE = le_day_time,
    LEFTARG = DAY_TIME,
    RIGHTARG = DAY_TIME
);


-- Operator: DAY_TIME < DAY_TIME
CREATE OR REPLACE FUNCTION lt_day_time(dt1 DAY_TIME, dt2 DAY_TIME)
RETURNS BOOL
LANGUAGE PLPGSQL
AS $$
BEGIN
    IF dt1.day_of_journey < dt2.day_of_journey OR (dt1.day_of_journey = dt2.day_of_journey AND dt1.time < dt2.time) THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$;

CREATE OPERATOR < (
    PROCEDURE = lt_day_time,
    LEFTARG = DAY_TIME,
    RIGHTARG = DAY_TIME
);


-- Function: DAY_OF_WEEK + INT = DAY_OF_WEEK
CREATE OR REPLACE FUNCTION add_to_day(day DAY_OF_WEEK, diff INT)
RETURNS DAY_OF_WEEK
LANGUAGE PLPGSQL
AS $$
DECLARE
    sum INT := (EXTRACT(ISODOW FROM day)::INT + diff - 1) % 7 + 1;
BEGIN
    RETURN sum::DAY_OF_WEEK;
END;
$$;

CREATE OPERATOR @+ (
    PROCEDURE = add_to_day,
    LEFTARG = DAY_OF_WEEK,
    RIGHTARG = INT
);


-- Function: DAY_OF_WEEK - DAY_OF_WEEK = INT (Considering Day1 > Day2)
CREATE OR REPLACE FUNCTION day_diff(day1 DAY_OF_WEEK, day2 DAY_OF_WEEK)
RETURNS INT
LANGUAGE PLPGSQL
AS $$
BEGIN
    RETURN (EXTRACT(ISODOW FROM day1)::INT - EXTRACT(ISODOW FROM day2)::INT + 7) % 7;
END;
$$;

CREATE OPERATOR @- (
    PROCEDURE = day_diff,
    LEFTARG = DAY_OF_WEEK,
};
