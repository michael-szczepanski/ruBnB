# Three Tables (Many-to-Many) Design Recipe Template

## 1. Extract nouns from the user stories or specification

## 2. Infer the Table Name and Columns

Put the different nouns in this table. Replace the example with your own nouns.

| Record                | Properties          |
| --------------------- | ------------------  |
| user                  | name, username, email, password 
| space                 | name, description, price per night, availability
| booking               | date, status

1. Name of the third table (always plural): `bookings` 

    Column names: `date`, `status`

## 3. Decide the column types.

[Here's a full documentation of PostgreSQL data types](https://www.postgresql.org/docs/current/datatype.html).

Most of the time, you'll need either `text`, `int`, `bigint`, `numeric`, or `boolean`. If you're in doubt, do some research or ask your peers.

Remember to **always** have the primary key `id` as a first column. Its type will always be `SERIAL`.

```
Table: users
id: SERIAL
name: text
username: text
email: text
password: text

Table: spaces
id: SERIAL
name: text
description: text
price_per_night: numeric 
availability: boolean
(user_id: int)


Table: bookings
id: SERIAL 
date: date
request_status: enum (called 'status')
```

## 4. Design the Many-to-Many relationship

Make sure you can answer YES to these two questions:

```
Can one user have many spaces? Yes
Can one space have many users? No
Can one booking have many users? No
Can one user have many bookings? Yes
Can one booking have many spaces? No
Can one space have many bookings? Yes
```

## 4. Write the SQL.

```sql
-- EXAMPLE
-- file: posts_tags.sql

-- Replace the table name, columm names and types.

-- Create the first table.
CREATE TABLE posts (
  id SERIAL PRIMARY KEY,
  title text,
  content text
);

-- Create the second table.
CREATE TABLE tags (
  id SERIAL PRIMARY KEY,
  name text
);

-- Create the join table.
CREATE TABLE posts_tags (
  post_id int,
  tag_id int,
  constraint fk_post foreign key(post_id) references posts(id) on delete cascade,
  constraint fk_tag foreign key(tag_id) references tags(id) on delete cascade,
  PRIMARY KEY (post_id, tag_id)
);

```

```sql
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
;

CREATE TABLE bookings (
  id SERIAL PRIMARY KEY,
  date date,
  request_status status default 'pending',
  user_id int,
  space_id int,
  constraint fk_user foreign key(user_id) references users(id) on delete cascade
  constraint fk_space foreign key(space_id) references spaces(id) on delete cascade
);
```

## 5. Create the tables.

```bash
psql -h 127.0.0.1 database_name < posts_tags.sql
```
