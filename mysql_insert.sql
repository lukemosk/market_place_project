
#RUN THIS FILE ONCE AFTER RUNNING mysql_creatDB.sql
use  cs336project;

INSERT INTO users (username, password, type) VALUES 
('admin', '1234', 'admin'),
('seller1', 'password', 'default'),
('buyer1', 'hello', 'default');

INSERT INTO vehicles (VIN, vehicle_type ,owner_id, make, model, year, mileage, color) VALUES
('1234567891234567', 'motorbike', 2, 'Ducati', 'SuperBike', 2019, 23853, 'black'),
('1234567891234568', 'motorbike', 2, 'Yamaha', 'R1', 2022, 1522, 'blue'),
('1234567891234569', 'motorbike', 2, 'KTM', 'Duke 390', 2021, 5067, 'grey'),
('1234567891234560', 'motorbike', 2, 'Ducati', 'Panigale V2', 2021, 2837, 'red'),
('1234567891234561', 'motorbike', 2, 'Harley-Davidson', 'Street 750', 2020, 8920, 'red'),
('1234567891234562', 'motorbike', 2, 'Kawasaki', 'Ninja 650', 2021, 3519, 'green'),
('1234567891234563', 'motorbike', 2, 'Suzuki', 'GSX-S750', 2019, 15782, 'black'),
('1234567891234564', 'motorbike', 2, 'BMW', 'S1000RR', 2022, 1490, 'blue'),
('1234567891234565', 'motorbike', 2, 'Aprilia', 'Tuono V4', 2020, 4502, 'white'),
('1234567891234566', 'motorbike', 2, 'Harley-Davidson', 'Sportster 1200', 2021, 6268, 'white'),
('1234567891234510', 'motorbike', 2, 'Yamaha', 'MT-07', 2020, 9250, 'grey'),
('1234567891234511', 'motorbike', 2, 'KTM', 'Super Duke R', 2022, 2579, 'green'),
('1234567891234512', 'motorbike', 2, 'Kawasaki', 'Z900', 2020, 7522, 'red'),
('1234567891234513', 'motorbike', 2, 'Ducati', 'Monster 821', 2021, 3589, 'green'),
('1234567891234514', 'motorbike', 2, 'Suzuki', 'DR-Z400SM', 2019, 12378, 'blue'),
('1234567891234515', 'motorbike', 2, 'Harley-Davidson', 'Iron 883', 2018, 15930, 'black'),
('1234567891234516', 'motorbike', 2, 'Yamaha', 'Tracer 9 GT', 2022, 2995, 'black'),
('1234567891234517', 'motorbike', 2, 'Aprilia', 'RS 660', 2021, 3670, 'white'),
('1234567891234518', 'motorbike', 2, 'BMW', 'R1250GS', 2022, 1508, 'red'),
('1234567891234519', 'motorbike', 2, 'KTM', '390 Adventure', 2020, 8005, 'red'),
('0234567891234567', 'boat', 2, 'Bayliner', 'Element E16', 2019, 2093, 'white'),
('0234567891234568', 'boat', 2, 'Sea Ray', 'SPX 190', 2022, 1895, 'white'),
('0234567891234569', 'boat', 2, 'Yamaha', '212X', 2021, 390, 'white'),
('0234567891234560', 'boat', 2, 'Cobalt', 'CS22', 2021, 1970, 'blue'),
('0234567891234561', 'boat', 2, 'MasterCraft', 'XT22', 2020, 2995, 'white'),
('0234567891234562', 'boat', 2, 'Malibu', 'M240', 2021, 1200, 'grey'),
('0234567891234563', 'boat', 2, 'Chaparral', '21 SSi', 2019, 4002, 'white'),
('0234567891234564', 'boat', 2, 'Boston Whaler', 'Vantage 270', 2022, 523, 'white'),
('0234567891234565', 'boat', 2, 'Four Winns', 'Horizon 290', 2020, 2023, 'grey'),
('0234567891234566', 'boat', 2, 'Regal', '21 OBX', 2021, 2566, 'white'),
('01234567891234510', 'boat', 2, 'Tige', '23RZX', 2020, 301, 'blue'),
('0234567891234511', 'boat', 2, 'Tige', 'Z3', 2022, 104, 'white'),
('0234567891234512', 'boat', 2, 'Moomba', 'Craz', 2020, 401, 'blue'),
('0234567891234513', 'boat', 2, 'Nautique', 'GS20', 2021, 1511, 'black'),
('0234567891234514', 'boat', 2, 'MasterCraft', 'X24', 2019, 3546, 'black'),
('0234567891234515', 'boat', 2, 'Malibu', '25 LSV', 2018, 500, 'white'),
('0234567891234516', 'boat', 2, 'Sea Ray', 'SDX 290', 2022, 835, 'white'),
('0234567891234517', 'boat', 2, 'Chaparral', '307 SSX', 2021, 667, 'white'),
('0234567891234518', 'boat', 2, 'Beneteau', 'Antares 9', 2022, 46, 'black'),
('0234567891234519', 'boat', 2, 'Yamaha', '242X E-Series', 2020, 15, 'grey'),
('2234567891234567', 'car', 2, 'Toyota', 'Camry', 2019, 23000, 'grey'),
('2234567891234568', 'car', 2, 'Honda', 'Civic', 2022, 1200, 'blue'),
('2234567891234569', 'car', 2, 'Ford', 'Focus', 2021, 4500, 'blue'),
('2234567891234560', 'car', 2, 'Chevrolet', 'Malibu', 2021, 3500, 'black'),
('2234567891234561', 'car', 2, 'Nissan', 'Altima', 2020, 9800, 'grey'),
('2234567891234562', 'car', 2, 'BMW', '3 Series', 2021, 5200, 'white'),
('2234567891234563', 'car', 2, 'Mercedes-Benz', 'C-Class', 2019, 15700, 'black'),
('2234567891234564', 'car', 2, 'Audi', 'A4', 2022, 1600, 'red'),
('2234567891234565', 'car', 2, 'Lexus', 'ES', 2020, 5200, 'red'),
('2234567891234566', 'car', 2, 'Acura', 'TLX', 2021, 3200, 'red'),
('2234567891234510', 'car', 2, 'Mazda', 'Mazda3', 2020, 9000, 'black'),
('2234567891234511', 'car', 2, 'Subaru', 'Outback', 2022, 2200, 'green'),
('2234567891234512', 'car', 2, 'Hyundai', 'Sonata', 2020, 7500, 'grey'),
('2234567891234513', 'car', 2, 'Kia', 'Optima', 2021, 5600, 'blue'),
('2234567891234514', 'car', 2, 'Volkswagen', 'Jetta', 2019, 13800, 'black'),
('2234567891234515', 'car', 2, 'Jeep', 'Cherokee', 2018, 15900, 'white'),
('2234567891234516', 'car', 2, 'Tesla', 'Model 3', 2022, 1200, 'red'),
('2234567891234517', 'car', 2, 'Volvo', 'S60', 2021, 3700, 'grey'),
('2234567891234518', 'car', 2, 'Porsche', '911', 2022, 1100, 'grey'),
('2234567891234519', 'car', 2, 'Jaguar', 'F-Type', 2020, 8200, 'green'),
('2234567891234520', 'car', 2, 'Porsche', 'Cayman', 2020, 9200, 'black'),
('2234567891234521', 'car', 2, 'Porsche', '911 Turbo S', 2021, 12000, 'blue');




INSERT INTO auctions (vehicle_id, seller_id, start_date, end_date, starting_price, current_price, reserve_price, status)
VALUES
('2234567891234519', 2, '2024-05-03 09:00:00', '2024-05-10 17:00:00', 10000.00, 10000.00, 15000.00, 'ongoing'),
('2234567891234562', 2, '2024-05-04 10:00:00', '2024-05-11 18:00:00', 5000.00, 5000.00, 7000.00, 'ongoing'),
('1234567891234514', 2, '2024-05-05 11:00:00', '2024-05-12 19:00:00', 20000.00, 20000.00, NULL, 'ongoing'),
('1234567891234567', 2, '2024-05-06 12:00:00', '2024-05-13 20:00:00', 8000.00, 8000.00, 10000.00, 'ongoing'),
('0234567891234561', 2, '2024-05-07 13:00:00', '2024-05-14 21:00:00', 7000.00, 7000.00, 9000.00, 'ongoing'),

('2234567891234518', 2, '2024-05-07 13:00:00', '2024-05-14 21:00:00', 7000.00, 7000.00, 9000.00, 'ongoing'),
('2234567891234517', 2, '2024-05-07 13:00:00', '2024-05-14 21:00:00', 10000.00, 10000.00, 9000.00, 'ongoing'),
('2234567891234516', 2, '2024-05-07 13:00:00', '2024-05-14 21:00:00', 11000.00, 11000.00, 9000.00, 'ongoing'),
('2234567891234564', 2, '2024-05-07 13:00:00', '2024-05-14 21:00:00', 70000.00, 70000.00, 9000.00, 'ongoing'),
('0234567891234513', 2, '2024-05-07 13:00:00', '2024-05-14 21:00:00', 700000.00, 700000.00, 9000.00, 'ongoing'),

('0234567891234568', 2, '2024-05-07 13:00:00', '2024-05-14 21:00:00', 11000.00, 11000.00, 9000.00, 'ongoing'),
('1234567891234512', 2, '2024-05-07 13:00:00', '2024-05-14 21:00:00', 11100.00, 11100.00, 9000.00, 'ongoing'),
('1234567891234513', 2, '2024-05-07 13:00:00', '2024-05-14 21:00:00', 711110.00, 711110.00, 9000.00, 'ongoing'),
('1234567891234515', 2, '2024-05-07 13:00:00', '2024-05-14 21:00:00', 70001.00, 70001.00, 9000.00, 'ongoing'),
('2234567891234568', 2, '2024-05-07 13:00:00', '2024-05-14 21:00:00', 700033.00, 700033.00, 9000.00, 'ongoing'),
('2234567891234520', 2, '2024-05-07 13:00:00', '2024-05-14 21:00:00', 50000.00, 50000.00, 100000.00, 'ongoing'),
('2234567891234521', 2, '2024-05-07 13:00:00', '2024-05-14 21:00:00', 25000.00, 25000.00, 50000.00, 'ongoing');



INSERT INTO bids (auction_id, bidder_id, bid_amount, bid_upper, bid_time)
VALUES
(1, 3, 11000.00, 13000.00, '2024-05-03 10:00:00'),
(2, 3, 5500.00, 5500.00, '2024-05-04 11:00:00'),
(4, 3, 9000.00, 9500.00, '2024-05-06 13:00:00');

INSERT INTO bids (auction_id, bidder_id, bid_amount, bid_time)
VALUES
(3, 3, 21000.00, '2024-05-05 12:00:00'), 
(6, 3, 8000.00, '2024-05-07 14:00:00'),
(6, 3, 10000.00, '2024-05-07 14:02:00'),
(6, 3, 9000.00, '2024-05-07 14:01:00'),
(6, 3, 11000.00, '2024-05-07 14:03:00');



INSERT INTO faqs (poster_id, content) VALUES 
(2, 'how sell'),
(3, 'how buy'),
(3, 'how how');
INSERT INTO faqs (poster_id, parent_id, content) VALUES 
(1, 1, 'click sell!'),
(1, 1, 'sell!'),
(1, 2, 'yes!');

INSERT INTO alerts (user_id, make, model, year) VALUES 
(3, 'Jaguar', 'F-Type', 2020);
