CREATE DATABASE `atc_database` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
use atc_database;
show tables;

-- drop table user_query;
-- drop table user_runway;
-- drop table runway_vehicle;
-- drop table flight_schedule;
-- drop table current_plane;
-- drop table user_details;
-- drop table query_log;
-- drop table airline_details;
-- drop table runway;
-- drop table utility_vehicles;

-- ///// ENTITY SETS /////
create table user_details(
	emp_id	        INT               UNIQUE NOT NULL,
    name	        VARCHAR(50)       NOT NULL,
    password        VARCHAR(15)       NOT NULL,
    access_level	INT               CHECK(access_level in (1,2,3)) NOT NULL,
    PRIMARY KEY (emp_id)
    );
    
create table query_log(
	query_id 	INT		         AUTO_INCREMENT NOT NULL,
	query	    VARCHAR(100)      NOT  NULL,
    query_time	timestamp        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY(query_id)
	); 

create table airline_details(
	airline				  VARCHAR(50)		UNIQUE NOT NULL,
    airline_headquarters  VARCHAR(50)		NOT NULL,
    PRIMARY KEY (airline)
    ); 
 
 create table runway(
	runway_code		INT		      UNIQUE NOT NULL,
	runway_status	VARCHAR(15)   CHECK(runway_status in ('Busy', 'Free')) NOT NULL,
    PRIMARY KEY(runway_code)
    );
    
create table utility_vehicles(
	vehicle_id		INT 	        UNIQUE NOT NULL,
    vehicle_type	VARCHAR(50)     CHECK(vehicle_type in ('Fire_Truck', 
															'Ambulance', 
															'Refueler_Jet', 
                                                            'Cargo_Loader', 
                                                            'Fuel_Bowser', 
                                                            'Safety_Check_Rig')) NOT NULL,
    status          VARCHAR(15)     CHECK(status in ('Busy', 'Free')) NOT NULL,
    PRIMARY KEY (vehicle_id)
    );
    
create table flight_schedule(
	flight_number		VARCHAR(10) 	NOT NULL,
    origin				VARCHAR(50)     NOT NULL,
    scheduled_arrival	TIME,
    scheduled_departure	TIME,
    capacity			INT				NOT NULL,
    emp_id				INT				NOT NULL,
    airline				VARCHAR(50)		NOT NULL, 
    isLanded			VARCHAR(3)      DEFAULT 'No' CHECK(isLanded in ('Yes', 'No')),
    PRIMARY KEY (flight_number),
    FOREIGN KEY (emp_id) REFERENCES user_details(emp_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (airline) REFERENCES airline_details(airline) ON UPDATE CASCADE ON DELETE CASCADE
    );
    
create table current_plane(
	flight_number       VARCHAR(10)		UNIQUE NOT NULL,
    isTransit		    VARCHAR(3)		CHECK(isTransit in ('Yes', 'No')),
    isFueled		    VARCHAR(3)		DEFAULT 'No' CHECK(isFueled in ('Yes', 'No')),
    isSafetyCheck		VARCHAR(3)		DEFAULT 'No' CHECK(isSafetyCheck in ('Yes', 'No')),
    isCargoLoaded		VARCHAR(3)		DEFAULT 'No' CHECK(isCargoLoaded in ('Yes', 'No')),
    emp_id              INT             NOT NULL,
    PRIMARY KEY(flight_number),
    FOREIGN KEY (emp_id) REFERENCES user_details(emp_id) ON UPDATE CASCADE ON DELETE CASCADE
    );

 -- ///// RELATION SETS /////
create table user_query(
	emp_id	        INT		         NOT NULL,
    query_id 	    INT		         UNIQUE NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES user_details(emp_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (query_id) REFERENCES query_log(query_id) ON UPDATE CASCADE ON DELETE CASCADE
    ); 

-- create table flight_user(
-- 	emp_id	        INT		         NOT NULL,
--     flight_number	VARCHAR(10) 	 UNIQUE NOT NULL,
--     FOREIGN KEY (emp_id) REFERENCES user_details(emp_id) ON UPDATE CASCADE ON DELETE CASCADE,
--     FOREIGN KEY (flight_number) REFERENCES flight_schedule(flight_number) ON UPDATE CASCADE ON DELETE CASCADE
--     );
    
-- create table operated_by(
-- 	flight_number	VARCHAR(10) 	 UNIQUE NOT NULL,
--     airline			VARCHAR(50)		 NOT NULL,
--     FOREIGN KEY (flight_number) REFERENCES flight_schedule(flight_number) ON UPDATE CASCADE ON DELETE CASCADE,
--     FOREIGN KEY (airline) REFERENCES airline_details(airline) ON UPDATE CASCADE ON DELETE CASCADE
--     );
  
create table user_runway(
	emp_id	        INT		     NOT NULL,
	runway_code		INT		     UNIQUE NOT NULL,
    FOREIGN KEY (emp_id) REFERENCES user_details(emp_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (runway_code) REFERENCES runway(runway_code) ON UPDATE CASCADE ON DELETE CASCADE
    );
    
create table runway_vehicle(
	vehicle_id		INT 	     UNIQUE NOT NULL,
    runway_code		INT		     NOT NULL,
    FOREIGN KEY (vehicle_id) REFERENCES utility_vehicles(vehicle_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (runway_code) REFERENCES runway(runway_code) ON UPDATE CASCADE ON DELETE CASCADE
    );

-- create table user_current_plane(
-- 	flight_number       VARCHAR(10)		UNIQUE NOT NULL,
-- 	emp_id	        	INT		     	NOT NULL,
--     FOREIGN KEY (flight_number) REFERENCES current_plane(flight_number) ON UPDATE CASCADE ON DELETE CASCADE,
--     FOREIGN KEY (emp_id) REFERENCES user_details(emp_id) ON UPDATE CASCADE ON DELETE CASCADE
--     );

-- ////// VALUE INSERTION //////
insert into airline_details values
	('Air India', 'Gurgaon'),
    ('Akasa Air', 'Bangalore'),
    ('SpiceJet', 'Hyderabad'),
    ('Vistara', 'Mumbai'),
    ('Indigo', 'Chennai'),
    ('AIX Connect', 'Bangalore'),
    ('Jet Airways','Kolkata');
    
insert into user_details values
	(100, 'Ben Howard', 'oldPine23', 2),
    (143, 'Wesley Schultz', 'cleopatra36', 1),
    (203, 'Randy Blythe', 'omerta512', 3),
    (435, 'Elena Tonra', 'newWays220', 1),
    (321, 'Courtney LaPlante', 'jaded9s', 2),
    (244, 'Nathan Drake', 'sicParvisMagna4', 3);

insert into flight_schedule (flight_number, origin, scheduled_arrival, scheduled_departure, capacity, emp_id, airline) values
	('AIX 4435', 'New Delhi',null,'10:29:18', 186, 100, 'AIX Connect'),
    ('AI 3284', 'Chandigarh', '11:50:07', '13:03:56', 200, 321, 'Air India'),
    ('6E 4353', 'New Delhi',null ,'13:03:56', 186, 435, 'Indigo'),
    ('AIX 4476', 'Mumbai', '14:27:59','16:36:48', 186, 244,'AIX Connect'),
    ('6E 9732', 'Kolkata','02:55:14'  , '04:08:51', 74, 435, 'Indigo'),
    ('AI 8743', 'Mumbai','07:21:37' ,'09:49:02', 306, 143, 'Air India'),
    ('AIX 2475', 'Goa', '03:33:29','05:47:15', 186, 203, 'AIX Connect'),
    ('SG 2147', 'Jammu', '08:58:06' ,'11:10:43', 150, 321, 'SpiceJet'),
    ('QP 4783', 'Port Blair','06:05:47' ,'07:19:33', 186, 100, 'Akasa Air'),
    ('UK 6413', 'Dehradun','10:39:41' ,'12:56:14', 182, 203, 'Vistara'),
    ('AI 1572', 'Patna', '01:23:07', '03:36:53', 250, 244, 'Air India'),
    ('QP 9711', 'Bikaner','05:34:56','07:48:42', 186, 435, 'Akasa Air'),
    ('SG 4583', 'Hyderabad','00:01:09','04:22:47', 109, 143, 'SpiceJet'),
    ('UK 7159', 'Trichi','08:11:48', '09:33:26', 186, 244, 'Vistara'),
    ('6E 3576', 'Vellore','02:09:01' ,'10:25:34', 52, 435, 'Indigo'),
    
    ('9W 1234', 'Lucknow', '07:19:33', '08:15:42', 210, 244, 'Jet Airways'),
	('AI 5678', 'Chennai ','13:03:56', '14:27:59', 300, 100, 'Air India'),
	('AIX 9101', 'New Delhi', null, '03:33:29', 180, 143, 'AIX Connect'),
	('9W 2468',  'New Delhi', null, '07:21:37', 360, 244, 'Jet Airways'),
	('SG 1357', 'Faridabad', '00:01:09', '01:23:07', 240, 203, 'SpiceJet'),
	('9W 3690',  'New Delhi',null , '02:55:14', 420, 321, 'Jet Airways'),
	('QP 8025', 'Ghaziabad', '08:11:48', '10:39:41', 270, 100, 'Akasa Air'),
	('SG 4789', 'Nagpur', '02:55:14', '05:34:56', 330, 100, 'SpiceJet'),
	('6E 2468', 'Nanded','07:19:40', '09:36:53', 240, 321, 'Indigo'),
	('QP 1357', 'Pune', '14:27:59', '18:36:48', 360, 203, 'Akasa Air');


insert into runway values
	(1, 'Free'),
    (2, 'Busy'),
    (3, 'Free'),
    (4, 'Free'),
    (5, 'Busy'),
    (6, 'Free'),
    (7, 'Free'),
    (8, 'Busy'),
    (9, 'Free'),
    (10, 'Free');
    
insert into utility_vehicles values
	(101, 'Fire_Truck', 'Free'),
    (102, 'Fire_Truck', 'Free'),
    (103, 'Fire_Truck', 'Free'),
    (104, 'Fire_Truck', 'Free'),
    (105, 'Fire_Truck', 'Busy'),
    (106, 'Fire_Truck', 'Free'),
    (107, 'Fire_Truck', 'Free'),
    (108, 'Fire_Truck', 'Busy'),
    (109, 'Fire_Truck', 'Free'),
    (110, 'Fire_Truck', 'Busy'),
    
    (201, 'Safety_Check_Rig', 'Free'),
    (202, 'Safety_Check_Rig', 'Free'),
    (203, 'Safety_Check_Rig', 'Free'),
    (204, 'Safety_Check_Rig', 'Busy'),
    (205, 'Safety_Check_Rig', 'Free'),
    (206, 'Safety_Check_Rig', 'Busy'),
    (207, 'Safety_Check_Rig', 'Free'),
    (208, 'Safety_Check_Rig', 'Free'),
    (209, 'Safety_Check_Rig', 'Free'),
    (210, 'Safety_Check_Rig', 'Busy'),
    
    (301, 'Refueler_Jet', 'Busy'),
    (302, 'Refueler_Jet', 'Free'),
    (303, 'Refueler_Jet', 'Free'),
    (304, 'Refueler_Jet', 'Free'),
    (305, 'Refueler_Jet', 'Free'),
    (306, 'Refueler_Jet', 'Free'),
    (307, 'Refueler_Jet', 'Free'),
    (308, 'Refueler_Jet', 'Busy'),
    (309, 'Refueler_Jet', 'Free'),
    (310, 'Refueler_Jet', 'Free'),    
    (401, 'Ambulance', 'Free'),
    (402, 'Ambulance', 'Free'),
    (403, 'Ambulance', 'Free'),
    (404, 'Ambulance', 'Busy'),
    (405, 'Ambulance', 'Free'),
    (406, 'Ambulance', 'Free'),
    (407, 'Ambulance', 'Busy'),
    (408, 'Ambulance', 'Free'),
    (409, 'Ambulance', 'Busy'),
    (410, 'Ambulance', 'Free'),
    
    (501, 'Cargo_Loader', 'Free'),
    (502, 'Cargo_Loader', 'Free'),
    (503, 'Cargo_Loader', 'Free'),
    (504, 'Cargo_Loader', 'Busy'),
    (505, 'Cargo_Loader', 'Free'),
    (506, 'Cargo_Loader', 'Free'),
    (507, 'Cargo_Loader', 'Busy'),
    (508, 'Cargo_Loader', 'Free'),
    (509, 'Cargo_Loader', 'Free'),
    (510, 'Cargo_Loader', 'Free'),
    
	(601, 'Fuel_Bowser', 'Free'),
    (602, 'Fuel_Bowser', 'Busy'),
    (603, 'Fuel_Bowser', 'Busy'),
    (604, 'Fuel_Bowser', 'Free'),
    (605, 'Fuel_Bowser', 'Free'),
    (606, 'Fuel_Bowser', 'Free'),
    (607, 'Fuel_Bowser', 'Free'),
    (608, 'Fuel_Bowser', 'Free'),
    (609, 'Fuel_Bowser', 'Free'),
    (610, 'Fuel_Bowser', 'Free');

insert into user_runway values
	(100, 1),
    (100, 5),
    (143, 2),
    (143, 6),
    (203, 3),
    (203, 7),
    (435, 4),
    (435, 8),
    (321, 9),
    (244, 10);

insert into runway_vehicle values
	(101, 1), (102, 2), (103, 3), (104, 4), (105 ,5), (106, 6), (107, 7), (108, 8), (109, 9), (110, 10),
    (201, 1), (202, 2), (203, 3), (204, 4), (205 ,5), (206, 6), (207, 7), (208, 8), (209, 9), (210, 10),
    (301, 1), (302, 2), (303, 3), (304, 4), (305 ,5), (306, 6), (307, 7), (308, 8), (309, 9), (310, 10),
    (401, 1), (402, 2), (403, 3), (404, 4), (405 ,5), (406, 6), (407, 7), (408, 8), (409, 9), (410, 10),
    (501, 1), (502, 2), (503, 3), (504, 4), (505 ,5), (506, 6), (507, 7), (508, 8), (509, 9), (510, 10),
    (601, 1), (602, 2), (603, 3), (604, 4), (605 ,5), (606, 6), (607, 7), (608, 8), (609, 9), (610, 10);
