--Users table
CREATE TYPE user_role AS ENUM('customer','admin');

CREATE TABLE "user"(
  user_id  INT Primary Key GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) Not Null,
  email VARCHAR(200) Unique Not Null,
  password VARCHAR(50) Not Null,
  role user_role Default 'customer',
  phone VARCHAR(20),
  created_at  TIMESTAMP Default CURRENT_TIMESTAMP
);

INSERT INTO "user"
VALUES
(default, 'Alice Smith', 'alice@gmail.com', 'hashed_password1', 'customer', '1234567890', '2024-01-01 10:00:00'),
(default, 'Bob Johnson', 'bob@gmail.com', 'hashed_password2', 'admin', '0987654321', '2024-01-02 11:00:00'),
(default, 'Charlie Brown', 'charlie@hotmail.com', 'hashed_password3', 'customer', '1122334455', '2024-01-03 12:00:00');

SELECT * FROM "user";

--Movies table
CREATE TYPE genre AS ENUM('Comedy','Sci-fi','Drama','Action','Horror');

CREATE TABLE movie(
  movie_id INT  Primary Key GENERATED ALWAYS AS IDENTITY,
  title VARCHAR(100) Not Null,
  description VARCHAR(200),
  genre genre Not Null,
  duration_minutes INT Not Null,
  release_date DATE NOT NULL,
  rating  INT Check (rating >= 0 AND rating <= 10),
  poster_url  VARCHAR(200),
  created_at  TIMESTAMP Default CURRENT_TIMESTAMP
);

INSERT INTO movie (movie_id, title, description, genre, duration_minutes, release_date, rating, poster_url, created_at) VALUES
(default, 'Inception', 'A mind-bending thriller.', 'Sci-fi', 148, '2010-07-16', 8.8, 'inception_poster.jpg', '2024-01-01 10:00:00'),
(default, 'The Matrix', 'A computer hacker learns about the true nature of reality.', 'Action', 136, '1999-03-31', 8.7, 'matrix_poster.jpg', '2024-01-02 11:00:00'),
(default, 'Titanic', 'A romantic drama on the ill-fated ship.', 'Drama', 195, '1997-12-19', 7.9, 'titanic_poster.jpg', '2024-01-03 12:00:00');

SELECT * FROM movie;

CREATE TABLE cinema(
  cinema_id INT Primary Key GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(100) Not Null,
  location VARCHAR(200) Not Null,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO cinema (cinema_id, name, location, created_at) VALUES
(default, 'Downtown Cinema', '123 Main Street, City Center', '2024-01-01 10:00:00'),
(default, 'Uptown Theater', '456 Uptown Avenue, Suburbs', '2024-01-02 11:00:00'),
(default, 'Parkside Cineplex', '789 Park Lane, Riverside', '2024-01-03 12:00:00');

SELECT * FROM cinema;

--Screens table
CREATE TABLE screen(
  screen_id INT Primary Key GENERATED ALWAYS AS IDENTITY,
  cinema_id INT NOT NULL,
  name VARCHAR(100) Not Null,
  capacity INT Not Null,

  FOREIGN KEY (cinema_id) REFERENCES cinema(cinema_id) 
);


INSERT INTO screen (screen_id, cinema_id, name, capacity) VALUES
(default, 1, 'Screen 1', 100),
(default, 1, 'Screen 2', 120),
(default, 2, 'Screen A', 150);

SELECT * FROM screen;

--Seats table
CREATE TYPE seat_type AS ENUM('Vip','Regular');

CREATE TABLE seat(
  seat_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  screen_id INT NOT NULL,
  seat_number CHAR(3) NOT NULL,
  seat_type seat_type NOT NULL,

  FOREIGN KEY (screen_id) REFERENCES screen(screen_id)
);

INSERT INTO seat
VALUES 
(default, 1, 'A1', 'Vip'),
(default, 1, 'A2', 'Regular'),
(default, 2, 'B1', 'Regular');

SELECT * FROM seat;

--Showtimes table

CREATE TABLE showtime(
  showtime_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  screen_id INT NOT NULL,
  movie_id INT NOT NULL,
  start_time TIMESTAMP,
  end_time TIMESTAMP,
  price NUMERIC(10,2),

  FOREIGN KEY (screen_id) REFERENCES screen(screen_id),
  FOREIGN KEY (movie_id) REFERENCES movie(movie_id)
);


INSERT INTO showtime
VALUES
(default, 1, 1, '2024-01-10 14:00:00', '2024-01-10 16:30:00', 10.00),
(default, 2, 2, '2024-01-11 18:00:00', '2024-01-11 20:30:00', 12.50),
(default, 3, 3, '2024-01-12 20:00:00', '2024-01-12 23:15:00', 15.00);

SELECT * FROM showtime;

--Bookings table

CREATE TYPE booking_status AS ENUM('pending','confirmed','canceled')

CREATE TABLE booking(
  booking_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  user_id INT NOT NULL,
  showtime_id INT NOT NULL,
  booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  total_price NUMERIC(10,2) NOT NULL,
  status booking_status NOT NULL,

  FOREIGN KEY (user_id) REFERENCES "user"(user_id),
  FOREIGN KEY (showtime_id) REFERENCES showtime(showtime_id)
);


INSERT INTO booking
VALUES
(default, 1, 1, '2024-01-05 10:00:00', 10.00, 'confirmed'),
(default, 2, 2, '2024-01-06 11:30:00', 25.00, 'pending'),
(default, 3, 3, '2024-01-07 15:45:00', 15.00, 'canceled');


SELECT * FROM booking;

--Booking details table

CREATE TABLE booking_detail(
  booking_detail_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  booking_id INT NOT NULL,
  seat_id INT NOT NULL,
  price NUMERIC(10,2) NOT NULL,

  FOREIGN KEY (booking_id) REFERENCES booking(booking_id),
  FOREIGN KEY (seat_id) REFERENCES seat(seat_id)
);


INSERT INTO booking_detail
VALUES
(default, 1, 1, 10.00),
(default, 2, 2, 12.50),
(default, 3, 3, 15.00);


SELECT * FROM booking_detail;

--Payment table
CREATE TYPE payment_status AS ENUM('pending','completed','failed');

CREATE TABLE payment(
  payment_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  booking_id INT NOT NULL,
  payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  amount NUMERIC(10,2) NOT NULL,
  payment_methpd VARCHAR(50) NOT NULL,
  status payment_status NOT NULL,

  FOREIGN KEY (booking_id) REFERENCES booking(booking_id)
);


INSERT INTO payment
VALUES
(default, 1, '2024-01-05 10:15:00', 10.00, 'Credit Card', 'completed'),
(default, 2, '2024-01-06 11:45:00', 25.00, 'PayPal', 'completed'),
(default, 3, '2024-01-07 16:00:00', 15.00, 'Cash', 'failed');

SELECT * FROM payment;



--Second Task:

--1.Operators
SELECT * FROM "user"
WHERE user_id > 100 AND (role = 'admin' OR role = 'customer');

SELECT * FROM movie
WHERE rating BETWEEN 7 AND 9 AND duration_minutes > 90;

SELECT * FROM booking
WHERE total_price > 50 AND status != 'canceled';

SELECT * FROM payment
WHERE amount > 100 OR payment_method = 'Credit Card';


--2.Where
SELECT * FROM "user"
WHERE email LIKE '%gmail.com';

SELECT * FROM movie
WHERE rating >= 8;

SELECT * FROM booking
WHERE user_id = 3;

SELECT * FROM showtime
WHERE movie_id = 5;

--3.Distinct
SELECT DISTINCT genre FROM movie;

SELECT DISTINCT location FROM cinema;

SELECT DISTINCT status FROM booking;

SELECT DISTINCT start_time FROM showtime;

--4.Order by
SELECT * FROM "user"
ORDER BY created_at ;

SELECT * FROM movie
ORDER BY release_date ASC;

SELECT * FROM booking
ORDER BY total_price DESC;

SELECT * FROM payment
ORDER BY payment_date DESC;

--5.Like
SELECT * FROM "user"
WHERE name LIKE 'A%';

SELECT * FROM movie
WHERE title LIKE '%love%';

SELECT * FROM booking
WHERE booking_date::TEXT LIKE '2024-%';

SELECT * FROM cinema
WHERE name LIKE '%Theater';

--6.Aliesses
SELECT user_id AS "User ID",name AS "Full name", email AS "Email Adress" FROM "user";

SELECT title AS "Movie title",release_date AS "Release Date", rating AS "Viewer rating" FROM movie;

SELECT booking_date AS "Booking Date",status AS "Booking Status", total_price AS "Amount Paid" FROM booking;

SELECT start_time AS "Show Start Time",price AS "Ticket Price", screen_id AS "Screen ID" FROM showtime;


