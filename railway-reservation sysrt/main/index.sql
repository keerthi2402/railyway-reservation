-- Index for Seat Table
CREATE INDEX idx_seat_train_no ON seat USING HASH(train_no);

-- Indexes for Ticket Table
CREATE INDEX idx_ticket_src_station_id ON ticket USING HASH(src_station_id);
CREATE INDEX idx_ticket_dest_station_id ON ticket USING HASH(dest_station_id);
CREATE INDEX idx_ticket_train_no ON ticket USING HASH(train_no);
CREATE INDEX idx_ticket_user_id ON ticket USING HASH(user_id);
CREATE INDEX idx_ticket_pid ON ticket USING HASH(pid);
CREATE INDEX idx_ticket_seat_id ON ticket USING HASH(seat_id);
CREATE INDEX idx_ticket_date ON ticket USING BTREE(date);
CREATE INDEX idx_ticket_booking_status ON ticket USING HASH(booking_status);
CREATE INDEX idx_ticket_seat_type ON ticket USING HASH(seat_type);

-- Indexes for Train Table
CREATE INDEX idx_train_src_station_id ON train USING HASH(src_station_id);
CREATE INDEX idx_train_dest_station_id ON train USING HASH(dest_station_id);

-- Indexes for Schedule Table
CREATE INDEX idx_schedule_train_no ON schedule USING HASH(train_no);
CREATE INDEX idx_schedule_curr_station_id ON schedule USING HASH(curr_station_id);
CREATE INDEX idx_schedule_next_station_id ON schedule USING HASH(next_station_id);
