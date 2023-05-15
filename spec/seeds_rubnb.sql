TRUNCATE TABLE spaces, users RESTART IDENTITY;

INSERT INTO users (name, username, email, password) VALUES ('Jack', 'skates', 'jack@email.com', 'password123');
INSERT INTO users (name, username, email, password) VALUES ('Jill', 'bigjill200', 'jill@email.com', 'secret456');


INSERT INTO spaces (name, description, price_per_night, availability, user_id) 
VALUES ('Jack''s House', 'This is my lovely house', '10.5', 'true', 1);

INSERT INTO spaces (name, description, price_per_night, availability, user_id) 
VALUES ('Jack''s Shed', 'This is my less-lovely shed', '10.0', 'false', 1);

INSERT INTO spaces (name, description, price_per_night, availability, user_id) 
VALUES ('Jill''s converted well', 'Feel like a frog looking at the sky', '20.0', 'true', 2);
