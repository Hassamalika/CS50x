-- Keep a log of any SQL queries you execute as you solve the mystery.
-- load
-- 28 July 2020 and Chamberlain Street
.schema
.schema crime_scene_reports

-- select 28.07.2020
SELECT description FROM crime_scene_reports
WHERE day = 28
AND month = 7
AND year = 2020;
--Theft of the CS50 duck took place at 10:15am at the Chamberlin Street
--courthouse. Interviews were conducted today with three witnesses who were
--present at the time — each of their interview transcripts mentions the
--courthouse.

--interviews
SELECT name, transcript FROM interviews
WHERE day = 28
AND month = 7
AND year = 2020;

-- ruth: time of theft 10:15am. 10 mins after = thief got into car in courthouse
--parking lot (2) and left (exit)

--eugene knows person - ATM at Fifer Street early morning (1)

-- ray: earliest flight out of fiftyville next day (29.07) (3) - phone number
-- around time of theft. other person on phone to buy tickets - a different name?

-- ATM transaction
SELECT account_number, amount, transaction_type FROM atm_transactions
WHERE atm_location = "Fifer Street"
AND day = 28
AND month = 7
AND year = 2020;

SELECT name, passport_number, license_plate, phone_number FROM people
JOIN bank_accounts ON bank_accounts.person_id = people.id
WHERE account_number = 16153065;

-- 28500762 | 48 | withdraw : Danielle | 8496433585 | 4328GD8 | (389) 555-5198
-- 76054385 | 60 | withdraw : Madison | 1988161715 | 1106N58 | (286) 555-6063
-- 49610011 | 50 | withdraw : Ernest | 5773159633 | 94KL13X | (367) 555-5533
-- 25506511 | 20 | withdraw : Elizabeth | 7049073643 | L93JTIZ | (829) 555-5269
-- 26013199 | 35 | withdraw : Russell | 3592750733 | 322W7JE | (770) 555-1861


--parking lot
SELECT day, month, year, hour, minute, activity FROM courthouse_security_logs
WHERE license_plate = "QX4YZN3";
-- Roy: NO

SELECT day, month, year, hour, minute, activity FROM courthouse_security_logs
WHERE license_plate = "1106N58";
-- madison:
-- 28 | 7 | 2020 | 8 | 34 | entrance
-- 28 | 7 | 2020 | 10 | 35 | exit

SELECT day, month, year, hour, minute, activity FROM courthouse_security_logs
WHERE license_plate = "4328GD8";
-- danielle:
-- 28 | 7 | 2020 | 9 | 14 | entrance
-- 28 | 7 | 2020 | 10 | 19 | exit

-- ERNEST
-- 28 | 7 | 2020 | 8 | 23 | entrance
-- 28 | 7 | 2020 | 10 | 18 | exit

-- ELIZABETH
-- 28 | 7 | 2020 | 8 | 18 | entrance
-- 28 | 7 | 2020 | 10 | 21 | exit

-- RUSSELL
-- 28 | 7 | 2020 | 8 | 36 | entrance
-- 28 | 7 | 2020 | 10 | 23 | exit

-- PHONE LOGS

SELECT caller, receiver, duration FROM phone_calls
WHERE day = 28
AND month = 7
AND year = 2020;


SELECT caller, duration FROM phone_calls
WHERE receiver = "(389) 555-5198";
-- danielle received 60 sec call from
-- (609) 555-5876 | 60

SELECT caller, receiver, duration FROM phone_calls
WHERE caller = "(286) 555-6063"
AND day = 28
AND month = 7
AND year = 2020;
-- Madison:
(286) 555-6063 | (676) 555-6554 | 43
(286) 555-6063 | (310) 555-8568 | 235

-- Danielle: (389) 555-5198
SELECT caller, receiver, duration FROM phone_calls
WHERE receiver = "(389) 555-5198"
AND day = 28
AND month = 7
AND year = 2020;

(544) 555-8087 | (389) 555-5198 | 595
(609) 555-5876 | (389) 555-5198 | 60

-- Ernest (367) 555-5533
SELECT caller, receiver, duration FROM phone_calls
WHERE caller = "(367) 555-5533"
AND day = 28
AND month = 7
AND year = 2020;

(367) 555-5533 | (375) 555-8161 | 45
(367) 555-5533 | (344) 555-9601 | 120
(367) 555-5533 | (022) 555-4052 | 241
(367) 555-5533 | (704) 555-5790 | 75

-- Russell (770) 555-1861
SELECT caller, receiver, duration FROM phone_calls
WHERE caller = "(770) 555-1861"
AND day = 28
AND month = 7
AND year = 2020;

(770) 555-1861 | (725) 555-3243 | 49

-- WHO DID THEY CALL?

--madison - 43 sec call
SELECT name, passport_number FROM people
WHERE phone_number = "(676) 555-6554";
-- James | 2438825627


-- ernest 45 sec call
SELECT name, passport_number FROM people
WHERE phone_number = "(375) 555-8161";
--Berthold |

-- russell 49 sec
SELECT name, passport_number FROM people
WHERE phone_number = "(725) 555-3243";
-- Philip | 3391710505


--find fiftyville aiport id
SELECT id, abbreviation, full_name FROM airports
WHERE city = "Fiftyville";
-- 8 | CSF | Fiftyville Regional Airport

-- FLIGHTS:
SELECT id, hour, minute, origin_airport_id, destination_airport_id FROM flights
WHERE day = 29
AND month = 7
AND year = 2020;
-- id | hour | minute | origin_airport_id | destination_airport_id
-- 23 | 12 | 15 | 8 | 11
-- 36 | 8 | 20 | 8 | 4
-- 43 | 9 | 30 | 8 | 1


-- PASSENGERS
-- madison 1988161715
SELECT seat, passport_number FROM passengers
JOIN flights ON flights.id = passengers.flight_id
WHERE flight_id = 36;

2A | 7214083635
3B | 1695452385
4A | 5773159633 - ernest
5C | 1540955065
6C | 8294398571
6D | 1988161715 - madison
7A | 9878712108
7B | 8496433585 - danielle


SELECT abbreviation, city, full_name FROM airports
JOIN flights ON flights.destination_airport_id = airports.id
WHERE destination_airport_id = 4;
-- destination - London Heathrow airport

--Ernest thief, berthold - accomplice, city - london
