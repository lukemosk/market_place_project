# RUN THIS FILE ONCE ONLY THEN RUN THE INSERT SQL FILE FOR DATA
  
DROP DATABASE IF EXISTS cs336project;
CREATE DATABASE cs336project;
USE cs336project;

CREATE TABLE users (
  id int NOT NULL AUTO_INCREMENT UNIQUE,
  username varchar(255) NOT NULL UNIQUE,
  password varchar(255) NOT NULL,
  type ENUM('admin', 'cs', 'default') NOT NULL,
  email varchar(64),
  dob DATE,
  PRIMARY KEY (id)
);

CREATE TABLE vehicles (
    VIN VARCHAR(17) PRIMARY KEY NOT NULL,    
    vehicle_type ENUM('car', 'motorbike', 'boat') NOT NULL, 
    owner_id INT NOT NULL,                         
    make VARCHAR(50) NOT NULL,                     
    model VARCHAR(50) NOT NULL,                    
    year INT NOT NULL,                             
    mileage INT NOT NULL,                          
    color VARCHAR(15) NOT NULL,                    
    FOREIGN KEY (owner_id) REFERENCES users(id)
);

CREATE TABLE auctions (
    auction_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,  
    vehicle_id VARCHAR(17) NOT NULL,                   
    seller_id INT NOT NULL,                             
    start_date DATETIME NOT NULL,                       
    end_date DATETIME NOT NULL,                         
    starting_price DECIMAL(10, 2) NOT NULL,
    current_price DECIMAL(10, 2) NOT NULL,
    reserve_price DECIMAL(10, 2) DEFAULT NULL, 
    status ENUM('pending', 'ongoing', 'closed') NOT NULL, 
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(VIN), 
    FOREIGN KEY (seller_id) REFERENCES users(id) 
);

CREATE TABLE bids (
    bid_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,  
    auction_id INT NOT NULL,                        
    bidder_id INT NOT NULL,                         
    bid_amount DECIMAL(10, 2) NOT NULL,
    bid_upper DECIMAL(10, 2),
    bid_time DATETIME NOT NULL,
    FOREIGN KEY (auction_id) REFERENCES auctions(auction_id),
    FOREIGN KEY (bidder_id) REFERENCES users(id)
);

CREATE TABLE faqs (
    message_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    poster_id INT NOT NULL,
    parent_id INT,
    content TEXT NOT NULL,
    FOREIGN KEY (poster_id) REFERENCES users(id),
    FOREIGN KEY (parent_id) REFERENCES faqs(message_id)
);