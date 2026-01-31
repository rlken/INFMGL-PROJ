-- ============================================
-- Car Rental Travel Agency Database
-- Database Name: car_rental_travel_agency
-- ============================================

-- Create database
CREATE DATABASE IF NOT EXISTS car_rental_travel_agency;
USE car_rental_travel_agency;

-- ============================================
-- Table: cars
-- Stores all rental car information
-- ============================================
CREATE TABLE IF NOT EXISTS cars (
    car_id INT PRIMARY KEY AUTO_INCREMENT,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    plate_no VARCHAR(20) NOT NULL UNIQUE,
    category VARCHAR(30) NOT NULL,
    capacity INT NOT NULL,
    rate_per_day DECIMAL(10, 2) NOT NULL,
    status ENUM('Available', 'Rented', 'Maintenance') DEFAULT 'Available'
);

-- ============================================
-- Table: customers
-- Stores customer information
-- ============================================
CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    contact VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    nationality VARCHAR(50)
);

-- ============================================
-- Table: packages
-- Stores tour package offerings
-- ============================================
CREATE TABLE IF NOT EXISTS packages (
    package_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    destination VARCHAR(100) NOT NULL,
    days INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT
);

-- ============================================
-- Table: bookings
-- Stores all booking transactions
-- ============================================
CREATE TABLE IF NOT EXISTS bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    car_id INT NOT NULL,
    package_id INT,
    purpose VARCHAR(100),
    pickup_location VARCHAR(200) NOT NULL,
    dropoff_location VARCHAR(200) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_estimated DECIMAL(10, 2),
    actual_return DATE,
    total_final DECIMAL(10, 2),
    status ENUM('Pending', 'Approved', 'Ongoing', 'Completed', 'Cancelled') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (car_id) REFERENCES cars(car_id),
    FOREIGN KEY (package_id) REFERENCES packages(package_id)
);

-- ============================================
-- Sample Data: Cars
-- ============================================
INSERT INTO cars (brand, model, plate_no, category, capacity, rate_per_day, status) VALUES
('Toyota', 'Vios', 'ABC-1234', 'Sedan', 5, 1500.00, 'Available'),
('Honda', 'City', 'DEF-5678', 'Sedan', 5, 1600.00, 'Available'),
('Toyota', 'Innova', 'GHI-9012', 'SUV', 8, 2500.00, 'Available'),
('Mitsubishi', 'Montero Sport', 'JKL-3456', 'SUV', 7, 3000.00, 'Available'),
('Toyota', 'HiAce', 'MNO-7890', 'Van', 15, 3500.00, 'Available'),
('Nissan', 'Urvan', 'PQR-1122', 'Van', 18, 4000.00, 'Available'),
('Honda', 'Civic', 'STU-3344', 'Sedan', 5, 1800.00, 'Rented'),
('Ford', 'Everest', 'VWX-5566', 'SUV', 7, 3200.00, 'Available'),
('Toyota', 'Fortuner', 'YZA-7788', 'SUV', 7, 3000.00, 'Maintenance'),
('Suzuki', 'Ertiga', 'BCD-9900', 'MPV', 7, 1800.00, 'Available'),
('Mitsubishi', 'Mirage G4', 'EFG-1011', 'Sedan', 5, 1400.00, 'Available'),
('Hyundai', 'Accent', 'HIJ-1213', 'Sedan', 5, 1500.00, 'Available'),
('Nissan', 'Almera', 'KLM-1415', 'Sedan', 5, 1450.00, 'Available'),
('Isuzu', 'mu-X', 'NOP-1617', 'SUV', 7, 3100.00, 'Available'),
('Nissan', 'Terra', 'QRS-1819', 'SUV', 7, 3200.00, 'Available'),
('Toyota', 'Rush', 'TUV-2021', 'SUV', 7, 2000.00, 'Rented'),
('Mitsubishi', 'Xpander', 'WXY-2223', 'MPV', 7, 2200.00, 'Available'),
('Toyota', 'Avanza', 'ZAB-2425', 'MPV', 7, 2000.00, 'Maintenance'),
('Hyundai', 'Grand Starex', 'CDE-2627', 'Van', 10, 3800.00, 'Available'),
('Foton', 'Traveller', 'FGH-2829', 'Van', 16, 3600.00, 'Available');

-- ============================================
-- Sample Data: Packages
-- ============================================
INSERT INTO packages (name, destination, days, price, description) VALUES
('Baguio City Tour', 'Baguio City', 3, 5000.00, 'Explore the Summer Capital of the Philippines. Includes Burnham Park, Mines View, and Strawberry Farm visits.'),
('Tagaytay Day Trip', 'Tagaytay', 1, 2000.00, 'Scenic day trip to Tagaytay with Taal Volcano viewpoint and Sky Ranch visit.'),
('Palawan Adventure', 'Puerto Princesa', 5, 15000.00, 'Underground River tour, Honda Bay island hopping, and city tour package.'),
('Boracay Beach Getaway', 'Boracay', 4, 12000.00, 'White beach paradise with island hopping and water activities included.'),
('Cebu Heritage Tour', 'Cebu City', 3, 8000.00, 'Historical tour including Magellan\'s Cross, Basilica del Santo Niño, and Oslob whale sharks.'),
('Bohol Countryside', 'Bohol', 2, 6000.00, 'Chocolate Hills, Tarsier Sanctuary, Loboc River cruise, and more.');

-- ============================================
-- Sample Data: Customers (for testing)
-- ============================================
INSERT INTO customers (name, contact, email, nationality) VALUES
('Juan Dela Cruz', '09171234567', 'juan@email.com', 'Filipino'),
('Maria Santos', '09181234567', 'maria@email.com', 'Filipino'),
('Antonio Reyes', '09172234567', 'antonio.reyes@email.com', 'Filipino'),
('Sofia Garcia', '09173234567', 'sofia.garcia@email.com', 'Filipino'),
('Miguel Fernandez', '09174234567', 'miguel.fernandez@email.com', 'Filipino'),
('Isabella Lopez', '09175234567', 'isabella.lopez@email.com', 'Filipino'),
('Gabriel Gonzales', '09176234567', 'gabriel.gonzales@email.com', 'Filipino'),
('Michael Brown', '09177234567', 'michael.brown@email.com', 'American'),
('Emily Davis', '09178234567', 'emily.davis@email.com', 'American'),
('Wei Zhang', '09179234567', 'wei.zhang@email.com', 'Chinese'),
('Sakura Tanaka', '09180234567', 'sakura.tanaka@email.com', 'Japanese'),
('Liam Wilson', '09181234568', 'liam.wilson@email.com', 'British'),
('Olivia Martin', '09182234567', 'olivia.martin@email.com', 'Canadian'),
('Noah Thompson', '09183234567', 'noah.thompson@email.com', 'Australian'),
('Emma White', '09184234567', 'emma.white@email.com', 'New Zealander'),
('Lucas Kim', '09185234567', 'lucas.kim@email.com', 'Korean'),
('Ji-woo Park', '09186234567', 'jiwoo.park@email.com', 'Korean'),
('Alexander Schmidt', '09187234567', 'alexander.schmidt@email.com', 'German'),
('Sophie Dubois', '09188234567', 'sophie.dubois@email.com', 'French'),
('Mateo Rossi', '09189234567', 'mateo.rossi@email.com', 'Italian'),
('Camila Silva', '09190234567', 'camila.silva@email.com', 'Brazilian'),
('Diego Torres', '09191234567', 'diego.torres@email.com', 'Spanish'),
('Elena Popov', '09192234567', 'elena.popov@email.com', 'Russian'),
('Aarav Patel', '09193234567', 'aarav.patel@email.com', 'Indian'),
('Zara Khan', '09194234567', 'zara.khan@email.com', 'Indian'),
('Luis Hernandez', '09195234567', 'luis.hernandez@email.com', 'Mexican'),
('Ana Martinez', '09196234567', 'ana.martinez@email.com', 'Mexican'),
('Mark Johnson', '09197234567', 'mark.johnson@email.com', 'American'),
('Sarah Lee', '09198234567', 'sarah.lee@email.com', 'American'),
('Kevin Chen', '09199234567', 'kevin.chen@email.com', 'Chinese'),
('Yuki Sato', '09200234567', 'yuki.sato@email.com', 'Japanese'),
('James Taylor', '09201234567', 'james.taylor@email.com', 'British'),
('Chloe Anderson', '09202234567', 'chloe.anderson@email.com', 'Canadian'),
('Oliver Thomas', '09203234567', 'oliver.thomas@email.com', 'Australian'),
('Grace Robinson', '09204234567', 'grace.robinson@email.com', 'New Zealander'),
('Min-jun Choi', '09205234567', 'minjun.choi@email.com', 'Korean'),
('Seo-yeon Jung', '09206234567', 'seoyeon.jung@email.com', 'Korean'),
('Maximilian Mueller', '09207234567', 'max.mueller@email.com', 'German'),
('Lea Moreau', '09208234567', 'lea.moreau@email.com', 'French'),
('Lorenzo Esposito', '09209234567', 'lorenzo.esposito@email.com', 'Italian'),
('Gabriela Santos', '09210234567', 'gabriela.santos@email.com', 'Brazilian'),
('Javier Ruiz', '09211234567', 'javier.ruiz@email.com', 'Spanish'),
('Dmitry Ivanov', '09212234567', 'dmitry.ivanov@email.com', 'Russian'),
('Vihaan Sharma', '09213234567', 'vihaan.sharma@email.com', 'Indian'),
('Priya Singh', '09214234567', 'priya.singh@email.com', 'Indian'),
('Carlos Gomez', '09215234567', 'carlos.gomez@email.com', 'Mexican'),
('Valentina Diaz', '09216234567', 'valentina.diaz@email.com', 'Mexican'),
('Jose Rizal', '09217234567', 'jose.rizal@email.com', 'Filipino'),
('Andres Bonifacio', '09218234567', 'andres.bonifacio@email.com', 'Filipino'),
('Emilio Aguinaldo', '09219234567', 'emilio.aguinaldo@email.com', 'Filipino');

-- ============================================
-- Sample Data: Bookings (for testing)
-- ============================================
INSERT INTO bookings (customer_id, car_id, package_id, purpose, pickup_location, dropoff_location, start_date, end_date, total_estimated, status) VALUES
(1, 7, 1, 'Family Vacation', 'Manila Airport', 'Manila Airport', '2026-01-25', '2026-01-28', 10400.00, 'Ongoing');
