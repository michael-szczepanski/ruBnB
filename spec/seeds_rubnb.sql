TRUNCATE TABLE spaces, users, bookings RESTART IDENTITY;


INSERT INTO users (name, username, email, password) VALUES ('Jack', 'skates', 'jack@email.com', 'password123');
INSERT INTO users (name, username, email, password) VALUES ('Jill', 'bigjill200', 'jill@email.com', 'secret456');
INSERT INTO users (name, username, email, password) VALUES ('Molly', 'Mollay', 'molly@email.com', 'molly666');


INSERT INTO spaces (name, description, price_per_night, available_from, available_to, user_id) 
VALUES ('Jack''s House', 'This is my lovely house', '10.50', '2023-05-16', '2023-05-21', 1);

INSERT INTO spaces (name, description, price_per_night, available_from, available_to, user_id) 
VALUES ('Jack''s Shed', 'This is my less-lovely shed', '10.00', '2023-05-25', '2023-06-02', 1);

INSERT INTO spaces (name, description, price_per_night, available_from, available_to, user_id) 
VALUES ('Jill''s converted well', 'Feel like a frog looking at the sky', '20.00', '2023-05-19', '2023-05-19', 2);


-- jill pending request for jack's house
INSERT INTO bookings (date, request_status, user_id, space_id)
VALUES ('2023-05-20', 'pending', 2, 1);

-- jill pending request for jack's shed
INSERT INTO bookings (date, request_status, user_id, space_id)
VALUES ('2023-05-26', 'pending', 2, 2);

-- molly pending request for jack's shed on the same day as jill
INSERT INTO bookings (date, request_status, user_id, space_id)
VALUES ('2023-05-26', 'pending', 3, 2);

-- jack and molly both want well and jack got denied
INSERT INTO bookings (date, request_status, user_id, space_id)
VALUES ('2023-05-19', 'denied', 1, 3);

-- jack and molly both want well and molly got confirmed
INSERT INTO bookings (date, request_status, user_id, space_id)
VALUES ('2023-05-19', 'confirmed', 3, 3);


