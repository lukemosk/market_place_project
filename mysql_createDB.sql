# RUN THIS FILE ONCE ONLY THEN RUN THE INSERT SQL FILE FOR DATA
  
DROP DATABASE IF EXISTS cs336project;
CREATE DATABASE cs336project;
USE cs336project;

CREATE TABLE users (
  id int AUTO_INCREMENT NOT NULL,
  username varchar(255) NOT NULL UNIQUE,
  password varchar(255) NOT NULL,
  type enum('admin', 'cs', 'default') NOT NULL,
  email varchar(64),
  dob date,
  PRIMARY KEY (id)
);

CREATE TABLE vehicles (
    VIN varchar(17) NOT NULL,
    vehicle_type enum('car', 'motorbike', 'boat') NOT NULL, 
    owner_id int NOT NULL,                         
    make varchar(50) NOT NULL,                     
    model varchar(50) NOT NULL,                    
    year int NOT NULL,                             
    mileage int NOT NULL,                          
    color varchar(15) NOT NULL,      
    PRIMARY KEY (VIN),
    FOREIGN KEY (owner_id) REFERENCES users(id)
);

CREATE TABLE auctions (
    auction_id int AUTO_INCREMENT NOT NULL,  
    vehicle_id varchar(17) NOT NULL,                   
    seller_id int NOT NULL,                             
    start_date datetime NOT NULL,                       
    end_date datetime NOT NULL,                         
    starting_price decimal(10, 2) NOT NULL,
    current_price decimal(10, 2) NOT NULL,
    reserve_price decimal(10, 2) DEFAULT NULL, 
    status enum('pending', 'ongoing', 'closed') NOT NULL, 
    PRIMARY KEY (auction_id),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(VIN), 
    FOREIGN KEY (seller_id) REFERENCES users(id) 
);

CREATE TABLE bids (
    bid_id int AUTO_INCREMENT NOT NULL,  
    auction_id int NOT NULL,                        
    bidder_id int NOT NULL,                         
    bid_amount decimal(10, 2) NOT NULL,
    bid_upper decimal(10, 2),
    bid_time datetime NOT NULL,
    PRIMARY KEY (bid_id),
    FOREIGN KEY (auction_id) REFERENCES auctions(auction_id),
    FOREIGN KEY (bidder_id) REFERENCES users(id)
);

CREATE TABLE faqs (
    message_id int AUTO_INCREMENT NOT NULL,
    poster_id int NOT NULL,
    parent_id int,
    content text NOT NULL,
    PRIMARY KEY (message_id),
    FOREIGN KEY (poster_id) REFERENCES users(id),
    FOREIGN KEY (parent_id) REFERENCES faqs(message_id)
);