# RUN THIS FILE ONCE ONLY THEN RUN THE INSERT SQL FILE FOR DATA
  
DROP DATABASE IF EXISTS cs336project;
CREATE DATABASE cs336project;
USE cs336project;

CREATE TABLE users (
  id int NOT NULL AUTO_INCREMENT UNIQUE,
  username varchar(255) NOT NULL UNIQUE,
  password varchar(255) NOT NULL,
  type ENUM('admin', 'cs', 'default'),
  email varchar(64),
  dob DATE,
  PRIMARY KEY (id)
);

CREATE TABLE vehicles (
    VIN VARCHAR(17) PRIMARY KEY,    
    vehicle_type ENUM('car', 'motorbike', 'boat'), 
    owner_id INT,                         
    make VARCHAR(50),                     
    model VARCHAR(50),                    
    year INT,                             
    mileage INT,                          
    color VARCHAR(15),                    
    FOREIGN KEY (owner_id) REFERENCES users(id)
);

CREATE TABLE auctions (
    auction_id INT PRIMARY KEY AUTO_INCREMENT,  
    vehicle_id VARCHAR(17),                   
    seller_id INT,                             
    start_date DATETIME,                       
    end_date DATETIME,                         
    starting_price DECIMAL(10, 2),             
    current_price DECIMAL(10, 2),              
    reserve_price DECIMAL(10, 2) DEFAULT NULL, 
    status ENUM('pending', 'ongoing', 'closed'), 
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(VIN), 
    FOREIGN KEY (seller_id) REFERENCES users(id) 
);

CREATE TABLE bids (
    bid_id INT PRIMARY KEY AUTO_INCREMENT,  
    auction_id INT,                        
    bidder_id INT,                         
    bid_amount DECIMAL(10, 2),             
    bid_time DATETIME,                     
    FOREIGN KEY (auction_id) REFERENCES auctions(auction_id),
    FOREIGN KEY (bidder_id) REFERENCES users(id)
);

CREATE TABLE faqs (
    message_id INT PRIMARY KEY AUTO_INCREMENT,
    poster_id INT,
    parent_id INT,
    content TEXT,
    FOREIGN KEY (poster_id) REFERENCES users(id),
    FOREIGN KEY (parent_id) REFERENCES faqs(message_id)
);