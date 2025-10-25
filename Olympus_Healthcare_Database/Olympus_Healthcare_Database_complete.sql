
/* DDL and DML authored by members of group 6 */

		/* ADJUSTED VERSION */

CREATE DATABASE olympus_healthcare;
USE olympus_healthcare;

CREATE TABLE employee (
	employee_id INT NOT NULL,
    employee_name VARCHAR(200) NULL,
    street_name VARCHAR(200) NULL, 
    zip_code VARCHAR(10) NULL,
    state CHAR(2) NULL,
    time_zone VARCHAR(200) NULL,
    phone VARCHAR(15) NULL,
    employee_type VARCHAR(20) NULL,
    admin_id INT NULL,
    PRIMARY KEY (employee_id),
    CONSTRAINT employee_fkey_admin_id
		FOREIGN KEY (admin_id)
			REFERENCES employee(employee_id)
	);
   
   
    
DESC employee;

CREATE TABLE w2employee (
	w2employee_id INT NOT NULL,
    remote_work VARCHAR(3) NULL,
    start_date DATE NULL, 
    end_date DATE NULL,
    w2_type VARCHAR(10) NULL,
    PRIMARY KEY (w2employee_id),
    CONSTRAINT w2employee_fkey_w2employee_id
		FOREIGN KEY (w2employee_id)
			REFERENCES employee(employee_id)
	);

DESC w2employee;

CREATE TABLE work_check (
	wcid INT NOT NULL,
    wc_date DATE NULL,
    checkin_time TIME NULL,
    work_summary VARCHAR(200) NULL, 
    w2employee_id INT NULL,
    PRIMARY KEY (wcid),
    CONSTRAINT work_check_fkey_w2employee_id
		FOREIGN KEY (w2employee_id)
			REFERENCES w2employee(w2employee_id)
	);
    
DESC work_check;

CREATE TABLE part_time (
	pw2employee_id INT NOT NULL,
    wage DECIMAL(6,2) NULL,
    PRIMARY KEY (pw2employee_id),
    CONSTRAINT part_time_fkey_pw2employee_id
		FOREIGN KEY (pw2employee_id)
			REFERENCES w2employee(w2employee_id)
	);

DESC part_time;

CREATE TABLE full_time (
	fw2employee_id INT NOT NULL,
    salary DECIMAL(12,2) NULL,
    PRIMARY KEY (fw2employee_id),
    CONSTRAINT full_time_fkey_fw2empliee_id
		FOREIGN KEY (fw2employee_id)
			REFERENCES w2employee(w2employee_id)
	);

DESC full_time;

CREATE TABLE employee_1099 (
	employee1099_id INT NOT NULL,
    contract_start DATE NULL,
    e1099_date DATE NULL,
    contract_length INT NULL,
    contract_payment DECIMAL(12,2),
    PRIMARY KEY (employee1099_id),
    CONSTRAINT employee_1099_fkey_employee1099_id
		FOREIGN KEY (employee1099_id)
			REFERENCES employee(employee_id)
	);

DESC employee_1099;

CREATE TABLE substitute_1099 (
	employee1099_id INT NOT NULL,
    substitute_id INT NOT NULL,
    PRIMARY KEY (employee1099_id, substitute_id),
    CONSTRAINT substitute_1099_fkey_employee1099_id
		FOREIGN KEY (employee1099_id)
			REFERENCES employee_1099(employee1099_id),
	CONSTRAINT substitute_1099_fkey_substitute_id
		FOREIGN KEY (substitute_id)
			REFERENCES employee_1099(employee1099_id)
	);
    
DESC substitute_1099;

CREATE TABLE patient (
	patient_id INT NOT NULL,
    patient_name VARCHAR(200) NULL,
    street_address VARCHAR(200) NULL,
    zip_code VARCHAR(10) NULL,
    state CHAR(2) NULL,
    phone CHAR(10) NULL,
    PRIMARY KEY (patient_id)
    );

DESC patient;

CREATE TABLE schedule (
	employee1099_id INT NOT NULL,
    patient_id INT NOT NULL,
    schedule_date DATE NULL,
    schedule_time TIME NULL,
    condition_description VARCHAR(200) NULL,
    PRIMARY KEY (employee1099_id, patient_id),
    CONSTRAINT schedule_fkey_employee_id
		FOREIGN KEY (employee1099_id)
			REFERENCES employee_1099(employee1099_id),
	CONSTRAINT schedule_fkey_patient_id
		FOREIGN KEY (patient_id)
			REFERENCES patient(patient_id)
	);

DESC schedule;

CREATE TABLE health_service (
	hsid INT NOT NULL,
    hsname VARCHAR(200) NULL,
    street_address VARCHAR(200) NULL,
    zip_code VARCHAR(10) NULL,
    state CHAR(2) NULL,
    hsspecialty VARCHAR(200) NULL,
    hsdescription VARCHAR(200) NULL,
    PRIMARY KEY (hsid)
    );

DESC health_service;

CREATE TABLE state (
	state_id INT NOT NULL,
    state_name VARCHAR(100) NULL,
    dohphone CHAR(10) NULL,
    unique_restrictions VARCHAR(200) NULL,
    funding_status VARCHAR(100) NULL,
    PRIMARY KEY (state_id)
    );

DESC state;

CREATE TABLE hs_reccomendation (
	patient_id INT NOT NULL,
    hsid INT NOT NULL,
    PRIMARY KEY (patient_id, hsid),
    CONSTRAINT hs_reccomendation_fkey_patient_id
		FOREIGN KEY (patient_id)
			REFERENCES patient(patient_id),
	CONSTRAINT hs_reccomendation_fkey_hsid
		FOREIGN KEY (hsid)
			REFERENCES health_service(hsid)
	);

DESC hs_reccomendation;

CREATE TABLE Work_Check (
time_id INT NOT NULL,
WCID INT NOT NULL,
check_time TIME,
PRIMARY KEY (time_id),
CONSTRAINT work_check_time_fkey_wcid
	FOREIGN KEY (WCID)
    REFERENCES work_check(wcid)
);

CREATE TABLE state_report (
	srid INT NOT NULL,
    state_id INT NULL,
    w2employee_id INT NULL,
    employee1099_id INT NULL,
    date_recieved DATE NULL,
    descripition VARCHAR(200),
    PRIMARY KEY (srid),
    CONSTRAINT state_report_fkey_state_id
		FOREIGN KEY (state_id)
			REFERENCES state(state_id),
	CONSTRAINT state_report_fkey_w2employee_id
		FOREIGN KEY (w2employee_id)
			REFERENCES w2employee(w2employee_id),
	CONSTRAINT state_id_fkey_employee1099_id
		FOREIGN KEY (employee1099_id)
			REFERENCES employee_1099(employee1099_id)
	);

DESC state_report;

CREATE TABLE patient_report (
	report_id INT NOT NULL,
    patient_id INT NULL,
    hsid INT NULL,
    state_id INT NULL,
    doctor_id INT NULL,
    exam_date DATE NULL,
    resultsturnin_date DATE NULL,
    didpass VARCHAR(10) NULL,
    disability_diagnosis VARCHAR(200) NULL,
    reccomended_funding DECIMAL(20,2) NULL,
    PRIMARY KEY (report_id),
    CONSTRAINT patient_report_fkey_patient_id
		FOREIGN KEY (patient_id)
			REFERENCES patient(patient_id),
	CONSTRAINT patient_report_fkey_hsid
		FOREIGN KEY (hsid)
			REFERENCES health_service(hsid),
	CONSTRAINT patient_report_fkey_state_id
		FOREIGN KEY (state_id)
			REFERENCES state(state_id),
	CONSTRAINT patient_report_fkey_doctor_id
		FOREIGN KEY (doctor_id)
			REFERENCES employee_1099(employee1099_id)
	);
    
DESC patient_report;

ALTER TABLE employee MODIFY COLUMN time_zone VARCHAR(30) NULL;
USE olympus_healthcare;
ALTER TABLE employee 
MODIFY COLUMN phone VARCHAR(30) NULL;

INSERT INTO employee VALUES
(12,'Nancy Williams','864 Donna Place Apt. 265','70112','LA','Central','639-774-1430','W2', NULL);

INSERT INTO employee VALUES
(1,'James James','3304 Charles Mount Suite 142','44101','OH','Eastern','746-864-6886','1099',12),
(2,'Dominique Parker','98913 Williams Inlet Apt. 451','03301','NH','Eastern','588-586-8798','W2',12),
(3,'Amanda Oneal','2105 John Harbors','80201','CO','Mountain','775-622-7824','1099',12),
(4,'Marvin Flores','91792 Berger Junction Apt. 732','55401','MN','Central','346-876-9540','1099',12),
(5,'Ashley Garcia','159 Hart Junction','44101','OH','Eastern','662-238-1932','W2',12),
(6,'Tammy Cooper','3706 Thomas Plains Apt. 673','29201','SC','Eastern','588-435-5055','1099',12),
(7,'Adam Ramirez','83599 Johnson Groves Apt. 084','57101','SD','Central','481-328-5961','1099',12),
(8,'George Williams','3211 Johnson Motorway','05001','VT','Eastern','231-293-9691','W2',12),
(9,'Joseph Herrera','7331 Buckley Harbor','85001','AZ','Mountain','565-269-6649','1099',12),
(10,'Julie Allen','010 Garcia Heights','90001','CA','Pacific','229-283-1744','1099',12),
(11,'Shane Burke','557 Singleton Prairie Apt. 627','30301','GA','Eastern','473-660-5061','1099',12),
(13,'Emma Lawrence','3271 Best Flats Apt. 335','67201','KS','Central','315-538-3662','1099',12),
(14,'Holly Jackson','2590 Greer Bridge Apt. 363','37201','TN','Central','858-850-6295','1099',12),
(15,'Amanda Hall','8925 Bishop Ways','82001','WY','Mountain','956-901-9624','W2',12),
(16,'Kevin Morales','667 Shelby Landing','82001','WY','Mountain','818-920-4350','1099',12),
(17,'Nathan Brown','899 Meyer Knolls Suite 694','44101','OH','Eastern','896-729-6644','1099',12),
(18,'Mary Daniels','3688 Johnson Stream','25301','WV','Eastern','321-676-6026','W2',12),
(19,'Debbie Sherman','193 Davis Neck','85001','AZ','Mountain','505-674-9920','1099',12),
(20,'Joshua Meyers','972 Danielle Track','67201','KS','Central','751-477-5450','1099',12),
(21,'Brittany Schultz','860 Hill Ports','67201','KS','Central','786-749-3455','W2',12),
(22,'Ronald Rivera','423 Gregory Course Suite 518','96801','HI','Hawaii','239-493-8740','W2',12),
(23,'Lori Werner','13266 Cole Plain','25301','WV','Eastern','610-271-3324','1099',12),
(24,'Ronald Moran','34473 Michael Shoals Suite 771','70112','LA','Central','253-302-7771','1099',12),
(25,'Monica Shea','050 Flores Circle Suite 092','06101','CT','Eastern','754-261-2130','W2',12),
(26,'Selena Hodge','36108 Audrey Divide Suite 166','19901','DE','Eastern','716-861-3827','1099',12),
(27,'Erik Hanson','41074 David Park Suite 067','37201','TN','Central','978-793-8354','W2',12),
(28,'Joel Williams','029 Andrew Cove','37201','TN','Central','314-263-9972','W2',12),
(29,'James Alexander','70194 Gonzalez Ridges Apt. 177','90001','CA','Pacific','610-252-4189','W2',12),
(30,'Kyle Rogers','452 Kevin Parkway Suite 449','02901','RI','Eastern','473-284-7955','W2',12),
(31, 'Erica Gilmore', '476 Rebecca Coves', '97201', 'OR', 'Pacific', '216-206-9719', 'W2', 12),
(32, 'Amber Allen', '91401 Jensen Forks', '59101', 'MT', 'Mountain', '426-541-3754', '1099', 12),
(33, 'Jimmy Bell', '09016 James Mission', '73101', 'OK', 'Central', '396-452-5571', '1099', 12),
(34, 'Stephen Bruce', '6229 Hernandez Park Suite 056', '40201', 'KY', 'Eastern', '985-340-5186', '1099', 12),
(35, 'Brandon Patel', '148 Williams Well', '40201', 'KY', 'Eastern', '980-453-2341', '1099', 12),
(36, 'Victoria Thomas', '72094 Brown Locks', '05001', 'VT', 'Eastern', '938-834-7229', '1099', 12),
(37, 'Emily Brown', '0954 Scott Run', '90001', 'CA', 'Pacific', '560-759-6546', '1099', 12),
(38, 'Thomas Joseph', '18039 Long Estates', '57101', 'SD', 'Central', '576-317-5564', '1099', 12),
(39, 'Stephen Hall', '456 Baker Mountains Suite 036', '03301', 'NH', 'Eastern', '714-582-4862', 'W2', 12),
(40, 'Daniel Garcia', '402 Jeff Shoal Suite 614', '02101', 'MA', 'Eastern', '765-529-5637', '1099', 12),
(41, 'Ralph Wallace MD', '328 Gonzalez Creek Apt. 220', '53201', 'WI', 'Central', '448-232-2800', 'W2', 12),
(42, 'Katelyn Morrison', '3159 Julie Drive', '68101', 'NE', 'Central', '520-623-1749', '1099', 12),
(43, 'Brett Morris', '786 Rivera Shores Suite 555', '02101', 'MA', 'Eastern', '924-648-8199', '1099', 12),
(44, 'Fernando Chan', '28920 Roberts Route Suite 780', '73301', 'TX', 'Central', '357-375-6531', 'W2', 12),
(45, 'Aaron Gutierrez', '656 Trevino Divide', '37201', 'TN', 'Central', '506-686-1272', '1099', 12),
(46, 'Nicole Smith', '6511 Sandoval Junction Suite 409', '53201', 'WI', 'Central', '282-869-1519', '1099', 12),
(47, 'Valerie Spencer', '5901 Lin Ridges Apt. 524', '99501', 'AK', 'Alaska', '829-561-4941', '1099', 12),
(48, 'Amanda Hughes', '66426 Glenn Wells Apt. 512', '84101', 'UT', 'Mountain', '727-343-6373', 'W2', 12),
(49, 'Samantha Underwood', '9890 Reilly Freeway Apt. 723', '25301', 'WV', 'Eastern', '544-984-3147', '1099', 12),
(50, 'Lauren Burton', '60294 Thomas Well', '89501', 'NV', 'Pacific', '858-536-3093', '1099', 12);

Select * From employee;

 
 INSERT INTO employee_1099 VALUES
(1, '2024-01-01', '2025-01-01', 1, 12959.43),
(3, '2024-01-02', '2025-01-02', 1, 14573.4),
(4, '2024-01-03', '2025-01-03', 1, 13952.4),
(6, '2024-01-04', '2025-01-04', 1, 12765.41),
(7, '2024-01-05', '2025-01-05', 1, 10912.37),
(9, '2024-01-06', '2025-01-06', 1, 10246.81),
(10, '2024-01-07', '2025-01-07', 1, 13656.55),
(11, '2024-01-08', '2025-01-08', 1, 10049.07),
(13, '2024-01-09', '2025-01-09', 1, 12876.29),
(14, '2024-01-10', '2025-01-10', 1, 10087.78),
(16, '2024-01-11', '2025-01-11', 1, 12009.05),
(17, '2024-01-12', '2025-01-12', 1, 14260.22),
(19, '2024-01-13', '2025-01-13', 1, 13010.08),
(20, '2024-01-14', '2025-01-14', 1, 13116.21),
(23, '2024-01-15', '2025-01-15', 1, 13383.98),
(24, '2024-01-16', '2025-01-16', 1, 13713.95),
(26, '2024-01-17', '2025-01-17', 1, 11095.58),
(32, '2024-01-18', '2025-01-18', 1, 14786.71),
(33, '2024-01-19', '2025-01-19', 1, 12477.31),
(34, '2024-01-20', '2025-01-20', 1, 11508.78),
(35, '2024-01-21', '2025-01-21', 1, 14516.03),
(36, '2024-01-22', '2025-01-22', 1, 12004.64),
(37, '2024-01-23', '2025-01-23', 1, 12837.81),
(38, '2024-01-24', '2025-01-24', 1, 13979.91),
(40, '2024-01-25', '2025-01-25', 1, 14232.48),
(42, '2024-01-26', '2025-01-26', 1, 10245.41),
(43, '2024-01-27', '2025-01-27', 1, 13144.67),
(45, '2024-01-28', '2025-01-28', 1, 14468.9),
(46, '2024-01-29', '2025-01-29', 1, 10602.33),
(47, '2024-01-30', '2025-01-30', 1, 10110.1),
(49, '2024-01-31', '2025-01-31', 1, 14817.25),
(50, '2024-02-01', '2025-02-01', 1, 14817.91);
 
 Select * From employee_1099;
 
 INSERT INTO substitute_1099 VALUES
(1, 3),
(3, 1),
(4, 1),
(6, 1),
(7, 1),
(9, 1),
(10, 1),
(11, 10),
(13, 10),
(14, 10),
(16, 10),
(17, 10),
(19, 10),
(20, 10),
(23, 10),
(24, 10),
(26, 24),
(32, 24),
(33, 24),
(34, 24),
(35, 24),
(36, 24),
(37, 24),
(38, 37),
(40, 37),
(42, 37),
(43, 37),
(45, 43),
(46, 43),
(47, 43),
(49, 43),
(50, 43);

Select * From substitute_1099;
 
 INSERT INTO w2employee VALUES
(2,'yes', '2011-05-14', NULL, 'Full time'),
(5,'no', '2013-03-01', NULL, 'Part time'),
(12,'yes', '2016-09-20', NULL, 'Full time'),
(8,'no', '2018-01-15', '2020-06-30', 'Part time'),
(15,'yes', '2012-11-03', '2014-12-12', 'Part time'),
(18,'no', '2019-04-19', NULL, 'Full time'),
(21,'yes', '2020-07-01', '2023-01-01', 'Full time'),
(22,'no', '2014-06-22', '2017-03-25', 'Part time'),
(25,'yes', '2015-10-05', NULL, 'Full time'),
(27,'no', '2021-01-20', NULL, 'Part time'),
(28,'yes', '2017-12-15', '2022-12-15', 'Part time'),
(29,'no', '2013-07-08', '2016-08-15', 'Full time'),
(30,'yes', '2010-09-09', '2014-04-02', 'Part time'),
(31,'no', '2012-02-14', '2019-12-01', 'Full time'),
(39,'yes', '2022-06-18', NULL, 'Full time'),
(41,'no', '2011-03-30', '2015-09-11', 'Part time'),
(44,'yes', '2016-05-01', '2018-11-30', 'Full time'),
(48,'no', '2019-10-10', NULL, 'Part time');


SELECT * FROM w2employee;

INSERT INTO full_time VALUES
(2, 120000),
(12, 120000),
(18, 75000),
(21, 63000),
(25, 66000),
(29, 63000),
(31, 55000),
(39, 55000),
(44, 55000);

SELECT * FROM full_time;

INSERT INTO part_time VALUES
(5, 24.75),
(8, 24.75),
(15, 24.75),
(22, 19.85),
(27, 19.85),
(28, 17.65),
(30, 15.15),
(41, 15.15),
(48, 15.15);

SELECT * FROM part_time;

INSERT INTO health_service VALUES
(1, 'Ohio PT', '1832 Maplewood Drive', '44114', 'OH', 'Physical Therapy', 'Nice place with good service'),
(2, 'Colorado PT', '4578 Elmhurst Avenue', '80211', 'CO', 'Physical Therapy', 'Very capable staff'),
(3, 'Minnesota Psychiatry Clinic', '1029 Lakeview Terrace', '55406', 'MN', 'Psychiatric Care', 'Focuses on PTSD in veterans'),
(4, 'South Caroline Psychiatry Clinic', '7650 Chestnut Street', '29607', 'SC', 'Psychiatric Care', 'Focuses on victims of abuse'),
(5, 'South Dakota PT', '2211 Brookside Lane', '57104', 'SD', 'Physical Therapy', 'Focuses on pediatric PT'),
(6, 'Arizona PT', '9845 Hamilton Way', '85008', 'AZ', 'Physical Therapy', 'Specializes on the lower back'),
(7, 'California Psychiatry Clinic', '3307 Sunrise Court', '90210', 'CA', 'Psychiatric Care', 'Spanish speaking psychiatric care'),
(8, 'Georgia Psychiatry Clinic', '1482 Cypress Hill Road', '30318', 'GA', 'Psychiatric Care', 'Traveling psychiatrists'),
(9, 'Kansas PT', '6793 Riverbend Loop', '67211', 'KS', 'Physical Therapy', 'Specializes in geriatic care'),
(10, 'Tennessee PT', '204 Westfield Boulevard', '37209', 'TN', 'Physical Therapy', 'Focuses on sport injuries'),
(11, 'Wyoming Psychiatry Clinic', '5196 Meadow Creek Drive', '82001', 'WY', 'Psychiatric Care', 'Specializes on pyschiatry for the reservations'),
(12, 'West Virgina Psychiatry Clinic', '8751 Oakridge Circle', '25302', 'WV', 'Psychiatric Care', 'Focuses on mental healing through nature');

INSERT INTO health_service VALUES
(13, 'Louisiana PT', '1847 Willow Bend Lane', '70119', 'LA', 'Physical Therapy', 'Focuses on arthritic care'),
(14, 'Deleware PT', '3298 Maple Hollow Drive', '19904', 'DE', 'Physical Therapy', 'Military contracted specialists'),
(15, 'Montana Psychiatry Clinic', '7421 Crestview Court', '59102', 'MT', 'Psychiatric Care', 'Specializes in Moose therapy');

SELECT * FROM health_service;

INSERT INTO patient VALUES
(1, 'Liam Parker', '64493 Greene Pine', '44101', 'TX', '2165558790'),
(2, 'Noah Bailey', '6012 Russell Cliffs', '44101', 'WA', '5135557632'),
(3, 'Olivia Diaz', '5787 Hamilton Falls', '44101', 'TN', '3305554912'),
(4, 'Emma Jones', '18601 Jeremy Route Apt. 079', '44101', 'CA', '9375553847'),
(5, 'Ava Thomas', '5805 Diane Estate', '44101', 'SC', '7405551175'),
(6, 'Sophia Scott', '2352 Charles Springs', '44101', 'KS', '5675558374'),
(7, 'Isabella Morris', '42633 Ortega Port Suite 508', '44101', 'MT', '6145552039'),
(8, 'Mason Thompson', '4317 Washington Camp', '44101', 'GA', '3305556428'),
(9, 'Logan Reed', '9346 Matthew Way', '44101', 'WV', '2165557843'),
(10, 'Ethan Rogers', '179 Brown Park Suite 332', '44101', 'AZ', '5135552981'),
(11, 'James Rivera', '5362 Kelley Rapid', '44101', 'MN', '9375551407'),
(12, 'Benjamin Jenkins', '5088 Reed Lodge Suite 509', '44101', 'CO', '4195559354'),
(13, 'Elijah Phillips', '7371 Ford Pines Apt. 710', '44101', 'DE', '6145556093'),
(14, 'Lucas Murphy', '991 Nicole Views', '44101', 'LA', '7405558720'),
(15, 'Michael Mitchell', '7875 Griffin Ports', '44101', 'CA', '5675553214'),
(16, 'Alexander Cox', '35232 Wright Tunnel', '44101', 'TN', '2165551189'),
(17, 'Henry Ward', '867 Julie Drives Apt. 157', '44101', 'GA', '5135557852'),
(18, 'Sebastian Powell', '93085 Martinez Route Apt. 507', '44101', 'SD', '9375552253'),
(19, 'Jack Wood', '226 Taylor Tunnel Apt. 417', '44101', 'WY', '3305557759'),
(20, 'Levi Simmons', '528 Curtis Pike Apt. 005', '44101', 'KS', '4195559641'),
(21, 'Daniel Hayes', '76580 Park Fork', '44101', 'AZ', '6145557720'),
(22, 'Matthew Myers', '02812 Tiffany Ridges Apt. 502', '44101', 'SC', '7405552447'),
(23, 'Samuel Butler', '01270 Mary Place Apt. 899', '44101', 'CO', '5675553465'),
(24, 'David Perry', '14701 Jennifer Harbors Suite 898', '44101', 'LA', '2165556314'),
(25, 'Joseph Henderson', '9637 Freeman Shoals', '44101', 'DE', '5135552985'),
(26, 'Carter Bryant', '6039 Burnett Harbors', '44101', 'MT', '9375551093'),
(27, 'Owen Foster', '351 Alexander Lake Apt. 872', '44101', 'MN', '3305555837'),
(28, 'Wyatt Coleman', '00325 Susan Ways', '44101', 'TX', '4195559284'),
(29, 'John Jenkins', '2269 Wells Flats Apt. 979', '44101', 'WA', '6145552931'),
(30, 'Grayson Watson', '99154 Rebecca Plain Apt. 641', '44101', 'TN', '7405558162'),
(31, 'Gabriel Sanders', '07625 Barton Burgs', '44101', 'SD', '5675557032'),
(32, 'Julian Long', '42340 Bishop Ramp Suite 452', '44101', 'WY', '2165559034'),
(33, 'Luke Patterson', '1805 David Views', '44101', 'AZ', '5135551194'),
(34, 'Anthony Richardson', '17768 Lisa Mount', '44101', 'GA', '9375554758'),
(35, 'Isaac Russell', '44480 Little Branch Apt. 926', '44101', 'WV', '3305558306'),
(36, 'Jayden Griffin', '20281 Bryant Walk Suite 697', '44101', 'KS', '4195551637'),
(37, 'Dylan West', '12671 Emily View', '44101', 'CA', '6145554470'),
(38, 'Andrew Jordan', '0083 Angela Island Suite 452', '44101', 'TX', '7405557953'),
(39, 'Joshua Dean', '3362 Michelle Fords Apt. 837', '44101', 'MN', '5675553321'),
(40, 'Christopher Stone', '1719 Bryant Key Apt. 559', '44101', 'CO', '2165557129');

Select * From patient;


INSERT INTO state VALUES
(1, 'New York', '3116383104', 'not as strict', 'high funding'),
(2, 'Michigan', '3869545851', 'not as strict', 'low funding'),
(3, 'Missouri', '4038045973', 'strict', 'high funding'),
(4, 'North Carolina', '1304507877', 'loose', 'high funding'),
(5, 'Texas', '8157847189', 'strict', 'high funding'),
(6, 'New Hampshire', '3127844245', 'strict', 'low funding'),
(7, 'Montana', '6281726920', 'strict', 'high funding'),
(8, 'Connecticut', '5418053592', 'strict', 'high funding'),
(9, 'Maine', '0188850552', 'not as strict', 'low funding'),
(10, 'Florida', '0708037752', 'strict', 'low funding'),
(11, 'Delaware', '1237847656', 'loose', 'high funding'),
(12, 'Indiana', '3898357738', 'loose', 'high funding'),
(13, 'New York', '9907530855', 'not as strict', 'high funding'),
(14, 'Kentucky', '1256363080', 'loose', 'high funding'),
(15, 'Nebraska', '0808841293', 'not as strict', 'high funding'),
(16, 'Illinois', '9437817344', 'loose', 'low funding'),
(17, 'Nevada', '3042296955', 'strict', 'low funding'),
(18, 'Washington', '8823661931', 'loose', 'low funding'),
(19, 'Tennessee', '3082886797', 'strict', 'high funding'),
(20, 'Wisconsin', '1160994932', 'not as strict', 'low funding'),
(21, 'South Carolina', '1077894355', 'not as strict', 'low funding'),
(22, 'Wyoming', '8219338102', 'strict', 'low funding'),
(23, 'Oregon', '7831855702', 'strict', 'low funding'),
(24, 'California', '0554086709', 'not as strict', 'high funding'),
(25, 'Arkansas', '5602636073', 'not as strict', 'low funding'),
(26, 'Massachusetts', '2106759310', 'strict', 'low funding'),
(27, 'Idaho', '6378109633', 'loose', 'high funding'),
(28, 'North Dakota', '6572230013', 'strict', 'high funding'),
(29, 'Mississippi', '4201022886', 'not as strict', 'high funding'),
(30, 'Oklahoma', '7785383994', 'loose', 'high funding'),
(31, 'Hawaii', '7139942311', 'strict', 'high funding'),
(32, 'Georgia', '6321339634', 'loose', 'low funding'),
(33, 'Minnesota', '4986220901', 'not as strict', 'low funding'),
(34, 'Louisiana', '9154400362', 'loose', 'high funding'),
(35, 'Colorado', '3038409443', 'loose', 'low funding'),
(36, 'Pennsylvania', '1532187870', 'not as strict', 'high funding'),
(37, 'Arizona', '2782105227', 'strict', 'low funding'),
(38, 'Alabama', '1841429446', 'not as strict', 'low funding'),
(39, 'West Virginia', '6109776584', 'strict', 'high funding'),
(40, 'Rhode Island', '7743781801', 'not as strict', 'high funding'),
(41, 'Iowa', '6362857337', 'loose', 'low funding'),
(42, 'South Dakota', '3174160022', 'loose', 'high funding'),
(43, 'Maryland', '9362161347', 'not as strict', 'low funding'),
(44, 'New Jersey', '1470635172', 'strict', 'high funding'),
(45, 'Utah', '7208726902', 'loose', 'low funding'),
(46, 'Vermont', '3975611555', 'not as strict', 'low funding'),
(47, 'Kansas', '2154169438', 'loose', 'low funding'),
(48, 'Alaska', '8914902604', 'strict', 'high funding'),
(49, 'Illinois', '7794980047', 'loose', 'low funding'),
(50, 'Virginia', '2105943810', 'strict', 'low funding');

SELECT * FROM state;

INSERT INTO state_report VALUES
(1, 41, 18, 1, '2023-04-21', 'This doctor was amazing'),
(2, 16, 27, 10, '2023-05-09', 'This doctor did a good job'),
(3, 44, 25, 43, '2023-05-27', 'This doctor did a good job'),
(4, 38, 44, 1, '2023-06-14', 'This doctor did a good job'),
(5, 6, 27, 17, '2023-07-02', 'This doctor should not have received their degree'),
(6, 5, 48, 50, '2023-07-20', 'This doctor should not have received their degree'),
(7, 3, 48, 3, '2023-08-07', 'This doctor did a bad job'),
(8, 28, 41, 10, '2023-08-25', 'This doctor did a bad job'),
(9, 49, 48, 17, '2023-09-12', 'This doctor should not have received their degree'),
(10, 19, 48, 43, '2023-09-30', 'This doctor did a good job'),
(11, 9, 31, 50, '2023-10-18', 'This doctor did a good job'),
(12, 48, 44, 32, '2023-11-05', 'This doctor did a good job'),
(13, 6, 18, 3, '2023-11-23', 'This doctor did a good job'),
(14, 45, 18, 10, '2023-12-11', 'This doctor was ok'),
(15, 22, 48, 26, '2023-12-29', 'This doctor did a good job'),
(16, 47, 18, 25, '2024-01-16', 'This doctor should not have received their degree'),
(17, 23, 27, 10, '2024-02-03', 'This doctor was ok'),
(18, 25, 48, 32, '2024-02-21', 'This doctor was amazing'),
(19, 2, 31, 32, '2024-03-10', 'This doctor did a good job'),
(20, 35, 31, 1, '2024-03-28', 'This doctor did a bad job'),
(21, 2, 27, 1, '2024-04-15', 'This doctor was amazing'),
(22, 17, 41, 20, '2024-05-03', 'This doctor did a bad job'),
(23, 19, 41, 25, '2024-05-21', 'This doctor did a bad job'),
(24, 47, 41, 25, '2024-06-08', 'This doctor was amazing'),
(25, 20, 18, 17, '2024-06-26', 'This doctor did a good job'),
(26, 22, 27, 3, '2024-07-14', 'This doctor was amazing'),
(27, 38, 48, 20, '2024-08-01', 'This doctor did a good job'),
(28, 15, 44, 17, '2024-08-19', 'This doctor did a good job'),
(29, 30, 41, 32, '2024-09-06', 'This doctor did a good job'),
(30, 21, 25, 32, '2024-09-24', 'This doctor should not have received their degree'),
(31, 11, 31, 32, '2024-10-12', 'This doctor should not have received their degree'),
(32, 13, 48, 43, '2024-10-30', 'This doctor did a bad job'),
(33, 32, 18, 26, '2024-11-17', 'This doctor did a bad job'),
(34, 25, 31, 49, '2024-12-05', 'This doctor should not have received their degree'),
(35, 10, 31, 26, '2024-12-23', 'This doctor should not have received their degree'),
(36, 33, 44, 10, '2025-01-10', 'This doctor did a bad job'),
(37, 11, 48, 50, '2025-01-28', 'This doctor was ok'),
(38, 31, 44, 26, '2025-02-15', 'This doctor did a good job'),
(39, 39, 25, 20, '2025-03-05', 'This doctor did a bad job');

INSERT INTO state_report VALUES
(40, 29, 41, 25, '2025-03-23', 'This doctor did a good job');

Select * From state_report;

INSERT INTO schedule VALUES
(1, 1, '2024-12-10', '09:15:00', 'bad back'),
(3, 2, '2025-01-05', '14:00:00', 'ptsd'),
(10, 3, '2024-11-28', '11:30:00', 'mental disability'),
(17, 4, '2024-12-22', '10:45:00', 'ptsd'),
(20, 5, '2025-02-13', '15:20:00', 'bad back'),
(26, 6, '2024-10-30', '13:10:00', 'mental disability'),
(32, 7, '2024-12-05', '16:40:00', 'bad back'),
(25, 8, '2025-03-02', '09:05:00', 'ptsd'),
(43, 9, '2024-11-16', '12:55:00', 'mental disability'),
(45, 10, '2024-10-25', '14:30:00', 'ptsd'),
(46, 11, '2025-01-20', '10:10:00', 'bad back'),
(49, 12, '2025-02-27', '11:50:00', 'mental disability'),
(50, 13, '2024-12-18', '13:45:00', 'bad back'),
(3, 14, '2024-11-11', '15:35:00', 'ptsd'),
(26, 15, '2025-03-15', '16:00:00', 'mental disability'),
(1, 16, '2025-01-01', '09:25:00', 'ptsd'),
(17, 17, '2024-12-29', '14:10:00', 'mental disability'),
(10, 18, '2024-10-21', '10:35:00', 'bad back'),
(20, 19, '2025-02-08', '11:05:00', 'ptsd'),
(43, 20, '2025-01-26', '12:25:00', 'mental disability'),
(25, 21, '2025-02-19', '13:30:00', 'ptsd'),
(32, 22, '2024-11-03', '14:55:00', 'mental disability'),
(26, 23, '2024-12-14', '15:45:00', 'bad back'),
(1, 24, '2025-03-10', '16:20:00', 'ptsd'),
(3, 25, '2024-12-01', '10:20:00', 'mental disability'),
(17, 26, '2025-01-11', '09:50:00', 'bad back'),
(20, 27, '2025-02-05', '11:15:00', 'ptsd'),
(50, 28, '2025-03-20', '12:40:00', 'mental disability'),
(49, 29, '2024-11-20', '13:05:00', 'bad back'),
(10, 30, '2024-10-27', '14:50:00', 'ptsd'),
(26, 31, '2025-01-16', '15:10:00', 'mental disability'),
(45, 32, '2025-02-22', '16:30:00', 'bad back'),
(43, 33, '2024-11-06', '09:40:00', 'ptsd'),
(32, 34, '2025-03-05', '10:55:00', 'mental disability'),
(25, 35, '2024-12-08', '13:20:00', 'bad back'),
(17, 36, '2025-01-30', '14:15:00', 'ptsd'),
(46, 37, '2025-02-10', '15:55:00', 'mental disability'),
(3, 38, '2024-10-18', '11:20:00', 'ptsd'),
(1, 39, '2025-01-08', '10:00:00', 'bad back'),
(50, 40, '2024-12-25', '09:35:00', 'mental disability');


Select * From schedule;

INSERT INTO work_check VALUES
(1, '2025-03-08', NULL,'Answered calls', 2),
(2, '2025-03-08', NULL, 'Answered Emails', 5),
(3, '2025-03-08', NULL, 'Inspected Doctors', 8),
(4, '2025-03-08', NULL,'Visited the state house', 12),
(5, '2025-03-08', NULL,'Took a nap', 15),
(6, '2025-03-08', NULL,'Answered calls', 18),
(7, '2025-03-08', NULL,'Answered Emails', 21),
(8, '2025-03-08', NULL,'Inspected Doctors', 22),
(9, '2025-03-08', NULL,'Visited the state house', 25),
(10, '2025-03-08', NULL,'Took a nap', 27),
(11, '2025-03-08', NULL,'Answered calls', 28),
(12, '2025-03-08', NULL,'Answered Emails', 29),
(13, '2025-03-08', NULL,'Inspected Doctors', 30),
(14, '2025-03-08', NULL,'Visited the state house', 31),
(15, '2025-03-08', NULL,'Took a nap', 39),
(16, '2025-03-08', NULL,'Answered calls', 41),
(17, '2025-03-08', NULL,'Answered Emails', 44),
(18, '2025-03-08', NULL,'Inspected Doctors', 48),
(19, '2025-03-09', NULL,'Visited the state house', 2),
(20, '2025-03-09', NULL,'Took a nap', 5),
(21, '2025-03-09', NULL,'Answered calls', 8),
(22, '2025-03-09', NULL,'Answered Emails', 12),
(23, '2025-03-09', NULL,'Inspected Doctors', 15),
(24, '2025-03-09', NULL,'Visited the state house', 18),
(25, '2025-03-09', NULL,'Took a nap', 21),
(26, '2025-03-09', NULL,'Answered calls', 22),
(27, '2025-03-09', NULL,'Answered Emails', 25),
(28, '2025-03-09', NULL,'Inspected Doctors', 27),
(29, '2025-03-09', NULL,'Visited the state house', 28),
(30, '2025-03-09', NULL,'Took a nap', 29),
(31, '2025-03-09', NULL,'Answered calls', 30),
(32, '2025-03-09', NULL,'Answered Emails', 31),
(33, '2025-03-09', NULL,'Inspected Doctors', 39),
(34, '2025-03-09', NULL,'Visited the state house', 41),
(35, '2025-03-09', NULL,'Took a nap', 44),
(36, '2025-03-09', NULL,'Answered calls', 48),
(37, '2025-03-10', NULL,'Answered Emails', 2),
(38, '2025-03-10', NULL,'Inspected Doctors', 5),
(39, '2025-03-10', NULL,'Visited the state house', 8),
(40, '2025-03-10', NULL,'Took a nap', 12);

Select * From work_check;

-- work check is done. check in times not added. 

INSERT INTO checkin_time VALUES
(1, 1, '11:00:00'),
(2, 1, '14:00:00'),
(3, 2, '11:00:00'),
(4, 2, '14:00:00'),
(5, 3, '11:00:00'),
(6, 3, '14:00:00'),
(7, 4, '11:00:00'),
(8, 4, '14:00:00'),
(9, 5, '11:00:00'),
(10, 5, '14:00:00'),
(11, 6, '11:00:00'),
(12, 6, '14:00:00'),
(13, 7, '11:00:00'),
(14, 7, '14:00:00'),
(15, 8, '11:00:00'),
(16, 8, '14:00:00'),
(17, 9, '11:00:00'),
(18, 9, '14:00:00'),
(19, 10, '11:00:00'),
(20, 10, '14:00:00'),
(21, 11, '11:00:00'),
(22, 11, '14:00:00'),
(23, 12, '11:00:00'),
(24, 12, '14:00:00'),
(25, 13, '11:00:00'),
(26, 13, '14:00:00'),
(27, 14, '11:00:00'),
(28, 14, '14:00:00'),
(29, 15, '11:00:00'),
(30, 15, '14:00:00'),
(31, 16, '11:00:00'),
(32, 16, '14:00:00'),
(33, 17, '11:00:00'),
(34, 17, '14:00:00'),
(35, 18, '11:00:00'),
(36, 18, '14:00:00'),
(37, 19, '11:00:00'),
(38, 19, '14:00:00'),
(39, 20, '11:00:00'),
(40, 20, '14:00:00'),
(41, 21, '11:00:00'),
(42, 21, '14:00:00'),
(43, 22, '11:00:00'),
(44, 22, '14:00:00'),
(45, 23, '11:00:00'),
(46, 23, '14:00:00'),
(47, 24, '11:00:00'),
(48, 24, '14:00:00'),
(49, 25, '11:00:00'),
(50, 25, '14:00:00'),
(51, 26, '11:00:00'),
(52, 26, '14:00:00'),
(53, 27, '11:00:00'),
(54, 27, '14:00:00'),
(55, 28, '11:00:00'),
(56, 28, '14:00:00'),
(57, 29, '11:00:00'),
(58, 29, '14:00:00'),
(59, 30, '11:00:00'),
(60, 30, '14:00:00'),
(61, 31, '11:00:00'),
(62, 31, '14:00:00'),
(63, 32, '11:00:00'),
(64, 32, '14:00:00'),
(65, 33, '11:00:00'),
(66, 33, '14:00:00'),
(67, 34, '11:00:00'),
(68, 34, '14:00:00'),
(69, 35, '11:00:00'),
(70, 35, '14:00:00'),
(71, 36, '11:00:00'),
(72, 36, '14:00:00'),
(73, 37, '11:00:00'),
(74, 37, '14:00:00'),
(75, 38, '11:00:00'),
(76, 38, '14:00:00'),
(77, 39, '11:00:00'),
(78, 39, '14:00:00'),
(79, 40, '11:00:00'),
(80, 40, '14:00:00');

SELECT * FROM work_check_time;


INSERT INTO patient_report VALUES
(1, 40, NULL, 3, 1, '2025-03-03', '2025-03-05', 'no', NULL, NULL),
(2, 39, NULL, 32, 32, '2025-02-17', '2025-02-22', 'no', NULL, NULL),
(3, 38, NULL, 11, 49, '2025-01-28', '2025-01-31', 'no', NULL, NULL),
(4, 37, 4, 35, 20, '2025-02-26', '2025-03-03', 'yes', 'PTSD', 9168),
(5, 36, NULL, 10, 26, '2025-02-13', '2025-02-14', 'no', NULL, NULL),
(6, 35, 5, 3, 49, '2025-02-15', '2025-02-16', 'yes', 'Scoliosis', 3214),
(7, 34, 6, 22, 25, '2025-01-22', '2025-01-24', 'yes', 'Manic Depression', 7933),
(8, 33, 1, 44, 32, '2025-03-05', '2025-03-10', 'yes', 'ALS', 5698),
(9, 32, NULL, 25, 10, '2025-02-06', '2025-02-08', 'no', NULL, NULL),
(10, 31, 11, 13, 26, '2025-01-13', '2025-01-14', 'yes', 'Scoliosis', 5523),
(11, 30, NULL, 27, 17, '2025-01-29', '2025-02-01', 'no', NULL, NULL),
(12, 29, NULL, 9, 1, '2025-03-07', '2025-03-08', 'no', NULL, NULL),
(13, 28, 13, 16, 32, '2025-02-11', '2025-02-14', 'yes', 'PTSD', 8499),
(14, 27, 9, 18, 50, '2025-03-01', '2025-03-05', 'yes', 'Scoliosis', 6577),
(15, 26, NULL, 14, 25, '2025-02-19', '2025-02-24', 'no', NULL, NULL),
(16, 25, 4, 6, 45, '2025-01-10', '2025-01-13', 'yes', 'ALS', 4297),
(17, 24, NULL, 4, 10, '2025-02-01', '2025-02-05', 'no', NULL, NULL),
(18, 23, 1, 7, 3, '2025-01-14', '2025-01-15', 'yes', 'Manic Depression', 2632),
(19, 22, 8, 12, 46, '2025-02-20', '2025-02-23', 'yes', 'ALS', 9076),
(20, 21, NULL, 50, 17, '2025-03-04', '2025-03-07', 'no', NULL, NULL),
(21, 20, 12, 19, 20, '2025-02-09', '2025-02-14', 'yes', 'Scoliosis', 2729),
(22, 19, NULL, 23, 32, '2025-01-11', '2025-01-16', 'no', NULL, NULL),
(23, 18, NULL, 39, 43, '2025-02-12', '2025-02-17', 'no', NULL, NULL),
(24, 17, 9, 1, 25, '2025-01-20', '2025-01-21', 'yes', 'Manic Depression', 3674),
(25, 16, 13, 21, 46, '2025-03-06', '2025-03-11', 'yes', 'PTSD', 7391),
(26, 15, NULL, 5, 3, '2025-02-04', '2025-02-09', 'no', NULL, NULL),
(27, 14, 3, 28, 49, '2025-02-14', '2025-02-18', 'yes', 'Scoliosis', 5283),
(28, 13, 14, 29, 1, '2025-01-19', '2025-01-24', 'yes', 'ALS', 7242),
(29, 12, NULL, 17, 26, '2025-02-02', '2025-02-03', 'no', NULL, NULL),
(30, 11, 12, 2, 10, '2025-02-22', '2025-02-24', 'yes', 'PTSD', 8759),
(31, 10, 9, 15, 43, '2025-01-26', '2025-01-27', 'yes', 'Scoliosis', 7725),
(32, 9, NULL, 36, 20, '2025-02-16', '2025-02-17', 'no', NULL, NULL),
(33, 8, 6, 14, 50, '2025-03-02', '2025-03-03', 'yes', 'ALS', 4610),
(34, 7, NULL, 26, 45, '2025-01-17', '2025-01-19', 'no', NULL, NULL),
(35, 6, 3, 37, 17, '2025-02-05', '2025-02-06', 'yes', 'PTSD', 7025),
(36, 5, 8, 31, 1, '2025-01-30', '2025-02-01', 'yes', 'Scoliosis', 6251),
(37, 4, 10, 30, 26, '2025-02-23', '2025-02-26', 'yes', 'Manic Depression', 6846),
(38, 3, NULL, 33, 50, '2025-01-15', '2025-01-18', 'no', NULL, NULL),
(39, 2, 1, 41, 10, '2025-03-08', '2025-03-13', 'yes', 'PTSD', 8847),
(40, 1, NULL, 20, 46, '2025-02-18', '2025-02-23', 'no', NULL, NULL);

SET FOREIGN_KEY_CHECKS=1;

Select * From patient_report;


Select * From health_service;


-- BQ1
SELECT condition_description, count(patient_id) 
FROM schedule 
GROUP BY condition_description;

-- BQ2
SELECT count(p.hsid) as report_hsid, count(h.hsid) as hs_hsid, h.hsspecialty as type_of_service 
FROM patient_report p 
INNER JOIN health_service h 
ON p.hsid = h.hsid
GROUP BY h.hsspecialty;

-- BQ3
SELECT p.doctor_id, e.employee_id, count(p.exam_date) as patients_served, e.employee_name 
FROM patient_report p 
INNER JOIN employee e ON p.doctor_id = e.employee_id 
WHERE exam_date >= '2025-02-08' 
GROUP BY p.doctor_id;


-- BQ4
SELECT avg(patient_count) as average_patients FROM 
(SELECT doctor_id, count(exam_date) as patient_count FROM patient_report WHERE exam_date >= '2025-02-08' GROUP BY doctor_id) as Average_Past_Month;

-- BQ5
SELECT avg(DATEDIFF(resultsturnin_date, exam_date)) as average_turn_in_days FROM patient_report;

-- BQ6
SELECT patient.*, count(patient_report.patient_id) as multiple_reports, patient_report.patient_id 
FROM patient, patient_report GROUP BY patient.patient_id, patient_report.patient_id HAVING patient.patient_id = patient_report.patient_id
AND count(patient_report.patient_id) > 1;

-- BQ7
SELECT employee.state AS state, COUNT(DISTINCT part_time.pw2employee_id) AS pt_id, COUNT(DISTINCT full_time.fw2employee_id) AS ft_id, COUNT(DISTINCT employee_1099.employee1099_id) as doctor_id
FROM employee
LEFT JOIN part_time ON part_time.pw2employee_id = employee.employee_id
LEFT JOIN full_time ON full_time.fw2employee_id = employee.employee_id
LEFT JOIN employee_1099 ON employee_1099.employee1099_id = employee.employee_id
GROUP BY employee.state;

-- BQ8
SELECT avg(schedule_count) as doctor_scheduled_average FROM
(SELECT patient_report.doctor_id, patient_report.didpass, count(schedule.employee1099_id) as schedule_count
FROM 
patient_report RIGHT JOIN schedule ON patient_report.doctor_id = schedule.employee1099_id
 AND patient_report.didpass = 'yes' GROUP BY report_id) as patient_count;
 
 -- BQ9
SELECT s.state_name, COUNT(pr.report_id) AS passing_exams, s.funding_status
FROM patient_report pr INNER JOIN state s
ON pr.state_id = s.state_id
WHERE pr.didpass = 'yes'
GROUP BY s.funding_status, s.state_name
ORDER BY s.funding_status ASC, s.state_name ASC;

-- BQ10
SELECT e1.employee1099_id AS employee_id, e.employee_type, e1.contract_payment AS money_earned
FROM employee_1099 e1 
INNER JOIN employee e ON e1.employee1099_id = e.employee_id
WHERE  e1.contract_payment < (SELECT AVG(e1.contract_payment) FROM employee_1099 e1)
UNION ALL
SELECT ft.fw2employee_id AS employee_id, e.employee_type, ft.salary AS money_earned
FROM full_time ft 
INNER JOIN w2employee w2 ON ft.fw2employee_id = w2.w2employee_id 
INNER JOIN employee e ON w2.w2employee_id = e.employee_ID 
WHERE ft.salary < (SELECT AVG(ft.salary) FROM full_time ft);
