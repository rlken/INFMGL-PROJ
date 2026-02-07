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
-- Sample Data: Cars (50+ Vehicles across categories)
-- ============================================
INSERT INTO cars (brand, model, plate_no, category, capacity, rate_per_day, status) VALUES
-- Sedans (Standard Economy)
('Toyota', 'Vios', 'ABC-1234', 'Sedan', 5, 1500.00, 'Available'),
('Honda', 'City', 'DEF-5678', 'Sedan', 5, 1600.00, 'Available'),
('Misubishi', 'Mirage G4', 'GHI-9012', 'Sedan', 5, 1400.00, 'Available'),
('Nissan', 'Almera', 'JKL-3456', 'Sedan', 5, 1450.00, 'Available'),
('Suzuki', 'Dzire', 'MNO-7890', 'Sedan', 5, 1300.00, 'Available'),
('Hyundai', 'Accent', 'PQR-1122', 'Sedan', 5, 1500.00, 'Available'),
('Kia', 'Soluto', 'STU-3344', 'Sedan', 5, 1350.00, 'Available'),
('Toyota', 'Vios', 'VWX-5566', 'Sedan', 5, 1500.00, 'Rented'),
('Honda', 'City', 'YZA-7788', 'Sedan', 5, 1600.00, 'Maintenance'),
('Mazda', '2 Sedan', 'BCD-9900', 'Sedan', 5, 1700.00, 'Available'),
('MG', '5', 'EFG-1011', 'Sedan', 5, 1400.00, 'Available'),
('Changan', 'Alsvin', 'HIJ-1213', 'Sedan', 5, 1300.00, 'Available'),
('Toyota', 'Corolla Altis', 'KLM-1415', 'Sedan', 5, 2500.00, 'Available'),
('Honda', 'Civic', 'NOP-1617', 'Sedan', 5, 2800.00, 'Available'),
('Mazda', '3 Sedan', 'QRS-1819', 'Sedan', 5, 2700.00, 'Available'),

-- SUVs (Mid-size & Full-size)
('Toyota', 'Fortuner', 'TUV-2021', 'SUV', 7, 3500.00, 'Available'),
('Mitsubishi', 'Montero Sport', 'WXY-2223', 'SUV', 7, 3400.00, 'Available'),
('Nissan', 'Terra', 'ZAB-2425', 'SUV', 7, 3400.00, 'Available'),
('Ford', 'Everest', 'CDE-2627', 'SUV', 7, 3600.00, 'Available'),
('Isuzu', 'mu-X', 'FGH-2829', 'SUV', 7, 3300.00, 'Available'),
('Toyota', 'Land Cruiser', 'IJK-3031', 'SUV', 7, 8000.00, 'Available'),
('Nissan', 'Patrol', 'LMN-3233', 'SUV', 8, 7500.00, 'Rented'),
('Ford', 'Territory', 'OPQ-3435', 'SUV', 5, 2800.00, 'Available'),
('Geely', 'Coolray', 'RST-3637', 'SUV', 5, 2500.00, 'Available'),
('Honda', 'CR-V', 'UVW-3839', 'SUV', 7, 3000.00, 'Available'),
('Mazda', 'CX-5', 'XYZ-4041', 'SUV', 5, 3000.00, 'Available'),
('Subaru', 'Forester', 'ABC-4243', 'SUV', 5, 3200.00, 'Available'),
('Suzuki', 'Jimny', 'DEF-4445', 'SUV', 4, 3000.00, 'Available'),

-- MPVs / AUVs (Family Carriers)
('Toyota', 'Innova', 'GHI-4647', 'MPV', 8, 2500.00, 'Available'),
('Mitsubishi', 'Xpander', 'JKL-4849', 'MPV', 7, 2200.00, 'Available'),
('Toyota', 'Avanza', 'MNO-5051', 'MPV', 7, 2000.00, 'Available'),
('Suzuki', 'Ertiga', 'PQR-5253', 'MPV', 7, 1800.00, 'Available'),
('Honda', 'BR-V', 'STU-5455', 'MPV', 7, 2300.00, 'Available'),
('Toyota', 'Veloz', 'VWX-5657', 'MPV', 7, 2400.00, 'Available'),
('Hyundai', 'Stargazer', 'YZA-5859', 'MPV', 7, 2200.00, 'Available'),
('Nissan', 'Livina', 'BCD-6061', 'MPV', 7, 2100.00, 'Available'),
('Toyota', 'Innova Zenix', 'EFG-6263', 'MPV', 7, 3000.00, 'Rented'),
('Mitsubishi', 'Xpander Cross', 'HIJ-6465', 'MPV', 7, 2500.00, 'Available'),

-- Vans (Large Capacity)
('Toyota', 'HiAce Commuter', 'KLM-6667', 'Van', 15, 3500.00, 'Available'),
('Toyota', 'HiAce Grandia', 'NOP-6869', 'Van', 12, 4000.00, 'Available'),
('Nissan', 'Urvan NV350', 'QRS-7071', 'Van', 18, 3800.00, 'Available'),
('Hyundai', 'Grand Starex', 'TUV-7273', 'Van', 10, 4200.00, 'Available'),
('Foton', 'Traveller', 'WXY-7475', 'Van', 16, 3600.00, 'Available'),
('Toyota', 'Alphard', 'ZAB-7677', 'Van', 7, 6000.00, 'Available'),
('Kia', 'Carnival', 'CDE-7879', 'Van', 7, 5500.00, 'Available'),
('Hyundai', 'Staria', 'FGH-8081', 'Van', 9, 5800.00, 'Available'),

-- Pickup Trucks (Utility / Adventure)
('Toyota', 'Hilux', 'IJK-8283', 'Pickup', 5, 3000.00, 'Available'),
('Ford', 'Ranger', 'LMN-8485', 'Pickup', 5, 3200.00, 'Available'),
('Nissan', 'Navara', 'OPQ-8687', 'Pickup', 5, 3100.00, 'Available'),
('Mitsubishi', 'Strada', 'RST-8889', 'Pickup', 5, 3000.00, 'Available'),
('Isuzu', 'D-MAX', 'UVW-9091', 'Pickup', 5, 2900.00, 'Available'),
('Ford', 'Ranger Raptor', 'XYZ-9293', 'Pickup', 5, 5000.00, 'Available');

-- ============================================
-- Sample Data: Packages (12 Tour Packages)
-- ============================================
INSERT INTO packages (name, destination, days, price, description) VALUES
('Baguio City Tour', 'Baguio City', 3, 5000.00, 'Explore the Summer Capital with Burnham Park, Mines View, and strawberry farms.'),
('Tagaytay Day Trip', 'Tagaytay', 1, 2000.00, 'Scenic views of Taal Volcano, bulalo restaurants, and cool weather.'),
('Palawan Adventure', 'Puerto Princesa', 5, 15000.00, 'Underground River tour and island hopping in El Nido.'),
('Boracay Beach Getaway', 'Boracay', 4, 12000.00, 'White Beach paradise with water sports and nightlife.'),
('Cebu Heritage Tour', 'Cebu City', 3, 8000.00, 'Magellan\'s Cross, Oslob whale sharks, and lechon feast.'),
('Siargao Surfing Trip', 'Siargao Island', 4, 10000.00, 'Cloud 9 surfing, island hopping, and laid-back vibes.'),
('Vigan Heritage Walk', 'Vigan City', 2, 4500.00, 'Spanish colonial architecture and Calle Crisologo experience.'),
('Bohol Countryside Tour', 'Bohol', 3, 7000.00, 'Chocolate Hills, tarsiers, and Loboc River cruise.'),
('Batanes Scenic Tour', 'Batanes', 4, 18000.00, 'Rolling hills, stone houses, and untouched natural beauty.'),
('La Union Beach Trip', 'La Union', 2, 3500.00, 'Surfing lessons, beach bars, and sunset views.'),
('Davao City Escape', 'Davao City', 3, 6500.00, 'Philippine Eagle Center, durian tasting, and Samal Island.'),
('Coron Island Hopping', 'Coron, Palawan', 4, 14000.00, 'Crystal-clear lagoons, WWII shipwrecks, and pristine beaches.');

-- ============================================
-- Sample Data: Customers (50 Entries)
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
