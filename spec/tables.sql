CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name text,
  username text,
  email text,
  password text
);

CREATE TABLE spaces (
  id SERIAL PRIMARY KEY,
  name text,
  description text,
  price_per_night numeric,
  available_from date,
  available_to date,
  user_id int,
  constraint fk_user foreign key(user_id) references users(id) on delete cascade
);

CREATE TYPE status AS ENUM ('pending', 'confirmed', 'denied');

CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
  date date,
  request_status status default 'pending',
  user_id int,
  space_id int,
  constraint fk_user foreign key(user_id) references users(id) on delete cascade,
  constraint fk_space foreign key(space_id) references spaces(id) on delete cascade
);