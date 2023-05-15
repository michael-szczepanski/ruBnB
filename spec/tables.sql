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
  availability text,
  user_id int,
  constraint fk_user foreign key(user_id) references users(id) on delete cascade
);
