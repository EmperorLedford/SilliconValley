-- Table structure starts here
DROP DATABASE apartment_renting;

-- SHOW DATABASES;
CREATE DATABASE apartment_renting;
USE apartment_renting;

-- Create Country table
CREATE TABLE IF NOT EXISTS Country (
  country_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL
) Engine=InnoDB;

-- Create State table
CREATE TABLE IF NOT EXISTS State (
  state_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  country_id INT,
  CONSTRAINT fk_State_Country FOREIGN KEY (country_id) REFERENCES Country(country_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

-- Create City table
CREATE TABLE IF NOT EXISTS City (
  city_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  state_id INT,
  CONSTRAINT fk_City_State FOREIGN KEY (state_id) REFERENCES State(state_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

-- Create Neighborhood table
CREATE TABLE IF NOT EXISTS Neighborhood (
  neighborhood_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  city_id INT,
  CONSTRAINT fk_Neighborhood_City FOREIGN KEY (city_id) REFERENCES City(city_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

-- Create Location table
CREATE TABLE IF NOT EXISTS Location (
  location_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  address VARCHAR(255),
  neighborhood_id INT NOT NULL,
  CONSTRAINT fk_Location_Neighborhood FOREIGN KEY (neighborhood_id) REFERENCES Neighborhood(neighborhood_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

-- Create Rating table
CREATE TABLE IF NOT EXISTS Rating (
  rating_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  rating_scale DECIMAL(2, 1),
  property_name VARCHAR(255),
  comments TEXT
) Engine=InnoDB;

-- MySQL uses the word 'event' internally, meaning you cannot use it as a database name.
CREATE TABLE IF NOT EXISTS PropertyEvent(
  propertyevent_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  propertyevent_description TEXT NOT NULL
) Engine=InnoDB;

-- Create FAQ table
CREATE TABLE IF NOT EXISTS FAQ(
  faq_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  rating_id INT NOT NULL,
  propertyevent_id INT NOT NULL,
  CONSTRAINT fk_FAQ_Rating FOREIGN KEY (rating_id) REFERENCES Rating(rating_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_FAQ_PropertyEvent FOREIGN KEY (propertyevent_id) REFERENCES PropertyEvent(propertyevent_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

-- A person can start an application without becoming a tenant; hence, the Application table does not need to know about the tenant.
-- Only the tenant table needs to know about the application.
CREATE TABLE IF NOT EXISTS Application (
  application_id INT PRIMARY KEY AUTO_INCREMENT, 
  application_date DATE, 
  application_status VARCHAR(255), 
  application_Desc TEXT
) Engine=InnoDB;

-- The RoomType does not need to know anything about the property, only the types of room.
CREATE TABLE IF NOT EXISTS RoomType (
  room_type_id INT PRIMARY KEY AUTO_INCREMENT,
  room_type_name VARCHAR(255),
  monthly_rent DECIMAL(10,2)
) Engine=InnoDB;

-- An apartment can exist without a tenant
CREATE TABLE IF NOT EXISTS Apartment(
  apartment_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  room_type_id INT NOT NULL,
  CONSTRAINT fk_Apartment_RoomType FOREIGN KEY (room_type_id) REFERENCES RoomType(room_type_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS Building (
  building_id INT PRIMARY KEY AUTO_INCREMENT,
  building_num INT,
  building_type VARCHAR(255),
  apartment_id INT,
  CONSTRAINT fk_Building_Apartment FOREIGN KEY (apartment_id) REFERENCES Apartment(apartment_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS Property (
  property_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT, 
  location_id INT, 
  building_id INT, 
  faq_id INT, 
  property_name VARCHAR(255), 
  CONSTRAINT fk_Property_Location FOREIGN KEY (location_id) REFERENCES Location(location_id) ON DELETE RESTRICT ON UPDATE CASCADE, 
  CONSTRAINT fk_Property_Building FOREIGN KEY (building_id) REFERENCES Building(building_id) ON DELETE RESTRICT ON UPDATE CASCADE, 
  CONSTRAINT fk_Property_FAQ FOREIGN KEY (faq_id) REFERENCES FAQ(faq_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

-- A tenant can only have one lease; hence, only the tenant table has to know about the lease.
-- The lease does not need to know about the tenant.
-- The lease does not need to know about the payment; it should just contain information about the lease.
CREATE TABLE IF NOT EXISTS Lease (
  lease_id INT PRIMARY KEY AUTO_INCREMENT,
  apartment_id INT, 
  building_id INT, 
  lease_start_date DATE, 
  lease_end_date DATE, 
  security_deposit DECIMAL(10, 2), 
  refund DECIMAL(10, 2), 
  CONSTRAINT fk_Lease_Apartment FOREIGN KEY (apartment_id) REFERENCES Apartment(apartment_id) ON DELETE RESTRICT ON UPDATE CASCADE, 
  CONSTRAINT fk_Lease_Building FOREIGN KEY (building_id) REFERENCES Building(building_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS Tenant (
  tenant_id INT PRIMARY KEY AUTO_INCREMENT, 
  application_id INT, 
  lease_id INT, 
  first_name VARCHAR(255), 
  last_name VARCHAR(255), 
  date_of_birth DATE, 
  credit_score INT, 
  lease_signed boolean,
  rating_id INT, 
  CONSTRAINT fk_Tenant_Application FOREIGN KEY (application_id) REFERENCES Application(application_id) ON DELETE RESTRICT ON UPDATE CASCADE, 
  CONSTRAINT fk_Tenant_Lease FOREIGN KEY (lease_id) REFERENCES Lease(lease_id) ON DELETE RESTRICT ON UPDATE CASCADE, 
  CONSTRAINT fk_Tenant_Rating FOREIGN KEY (rating_id) REFERENCES Rating(rating_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS Payment (
  payment_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  tenant_id INT NOT NULL,
  apartment_id INT NOT NULL,
  payment_confirmation VARCHAR(255),
  payment_date DATE,
  payment_amount DECIMAL(10, 2),
  CONSTRAINT fk_Payment_Tenant FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_Payment_Apartment FOREIGN KEY (apartment_id) REFERENCES Apartment(apartment_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS Department (
  department_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  department_name VARCHAR(50) NOT NULL,
  property_id INT NOT NULL,
  CONSTRAINT fk_Department_Property FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS Role (
  role_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  role_title VARCHAR(50) NOT NULL
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS Employee (
  employee_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  employee_name VARCHAR(255) NOT NULL,
  role_id INT NOT NULL,
  department_id INT NOT NULL,
  CONSTRAINT fk_Employee_Role FOREIGN KEY (role_id) REFERENCES Role(role_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_Employee_Department FOREIGN KEY (department_id) REFERENCES Department(department_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS Amenity (
  amenity_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  property_id INT NOT NULL,
  amenity_type varchar(255),
  CONSTRAINT fk_Amenity_Property FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS Utility (
  utility_id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  tenant_id INT NOT NULL,
  lease_id INT NOT NULL,
  utility_offered VARCHAR(255) NOT NULL,
  CONSTRAINT fk_Utility_Tenant FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_Utility_Lease FOREIGN KEY (lease_id) REFERENCES Lease(lease_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS Invoice (
  invoice_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  tenant_id INT NOT NULL, 
  payment_id INT NOT NULL,
  issue_date DATETIME NOT NULL,
  amount_billed DECIMAL(10, 2),
  CONSTRAINT fk_Invoice_Tenant FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_Invoice_Payment FOREIGN KEY (payment_id) REFERENCES Payment(payment_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS EmergencyContact (
  contact_id INT PRIMARY KEY AUTO_INCREMENT, 
  tenant_id INT, 
  first_name VARCHAR(255), 
  last_name VARCHAR(255), 
  phone_number VARCHAR(255), 
  relation_to_tenant VARCHAR(255), 
  CONSTRAINT fk_EmergencyContact_Tenant FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS Fine (
  fine_id INT PRIMARY KEY AUTO_INCREMENT,
  tenant_id INT,
  fine_date INT,
  issue_date DATE,
  amount_billed DECIMAL(10,2),
  payment_id INT,
  CONSTRAINT fk_Fine_Tenant FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_Fine_Payment FOREIGN KEY (payment_id) REFERENCES Payment(payment_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS Document (
  document_id INT PRIMARY KEY AUTO_INCREMENT,
  tenant_id INT,
  document_type VARCHAR(255),
  document_name VARCHAR(255),
  document_desc TEXT,
  property_id INT, 
  CONSTRAINT fk_Document_Property FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS Guarantor (
  guarantor_id INT PRIMARY KEY AUTO_INCREMENT,
  tenant_id INT,
  guarantor_first_name VARCHAR(255),
  guarantor_last_name VARCHAR(255),
  guarantor_address VARCHAR(255),
  guarantor_phone VARCHAR(255),
  relation_to_tenant VARCHAR(255),
  CONSTRAINT fk_Guarantor_Tenant FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS Parking (
  parking_id INT PRIMARY KEY AUTO_INCREMENT,
  building_id INT,
  parking_type VARCHAR(255),
  CONSTRAINT fk_Parking_Building FOREIGN KEY (building_id) REFERENCES Building(building_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS PetPolicy (
  pet_policy_id INT PRIMARY KEY AUTO_INCREMENT,
  building_id INT,
  policy_type VARCHAR(255),
  CONSTRAINT fk_PetPolicy_Building FOREIGN KEY (building_id) REFERENCES Building(building_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;

CREATE TABLE IF NOT EXISTS Notification(
  notification_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  propertyevent_id INT,
  employee_id int,
  CONSTRAINT fk_Notification_PropertyEvent FOREIGN KEY (propertyevent_id) REFERENCES PropertyEvent(propertyevent_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_Notification_Employee FOREIGN KEY (employee_id) REFERENCES Employee(employee_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine = InnoDB;

CREATE TABLE IF NOT EXISTS Inspection(
  inspection_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  tenant_id INT,
  apartment_id int,
  last_inpection DATE,
  first_inspection DATE,
  inspection_status bool NOT NULL,
  CONSTRAINT fk_Inspection_Tenant FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_Notification_Apartment FOREIGN KEY (apartment_id) REFERENCES Apartment(apartment_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine = InnoDB;

CREATE TABLE IF NOT EXISTS MaintenanceRequest (
  maint_req_id INT PRIMARY KEY AUTO_INCREMENT,
  tenant_id INT,
  employee_id INT,
  request_date DATE,
  request_description TEXT,
  urgency VARCHAR(225),
  schedule_date DATE,
  cost DECIMAL(10,2),
  maintain_history TEXT,
  ticket TEXT,
  CONSTRAINT fk_MaintenanceRequest_Tenant FOREIGN KEY (tenant_id) REFERENCES Tenant(tenant_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_MaintenanceRequest_Employee FOREIGN KEY (employee_id) REFERENCES Employee(employee_id) ON DELETE RESTRICT ON UPDATE CASCADE
) Engine=InnoDB;


-- Inserts start here
INSERT INTO Country (name) 
VALUES 
  ('USA'), 
  ('Canada'), 
  ('UK'), 
  ('Australia'), 
  ('Germany'), 
  ('France'), 
  ('India'), 
  ('Japan'), 
  ('Brazil'), 
  ('South Africa');
INSERT INTO State (name, country_id) 
VALUES 
  ('New York', 1), 
  ('California', 1), 
  ('Ontario', 2), 
  ('Quebec', 2), 
  ('London', 3), 
  ('Sydney', 4), 
  ('Bavaria', 5), 
  ('Paris', 6), 
  ('Mumbai', 7), 
  ('Tokyo', 8);
INSERT INTO City (name, state_id) 
VALUES 
  ('New York City', 1), 
  ('Los Angeles', 2), 
  ('Toronto', 3), 
  ('Montreal', 4), 
  ('London City', 5), 
  ('Sydney City', 6), 
  ('Munich', 7), 
  ('Paris City', 8), 
  ('Mumbai City', 9), 
  ('Tokyo City', 10);
INSERT INTO Neighborhood (name, city_id) 
VALUES 
  ('Manhattan', 1), 
  ('Hollywood', 2), 
  ('Downtown', 3), 
  ('Old Montreal', 4), 
  ('Westminster', 5), 
  ('Bondi Beach', 6), 
  ('Schwabing', 7), 
  ('Montmartre', 8), 
  ('Bandra', 9), 
  ('Shibuya', 10);
INSERT INTO Location (address, neighborhood_id) 
VALUES 
  ('123 Main St, Apt 101', 1), 
  (
    '456 Hollywood Blvd, Apt 201', 2
  ), 
  ('789 Downtown Ave, Apt 301', 3), 
  (
    '987 Old Montreal St, Apt 401', 
    4
  ), 
  (
    '456 Westminster Rd, Apt 501', 5
  ), 
  (
    '123 Bondi Beach Rd, Apt 601', 6
  ), 
  (
    '789 Schwabing Strasse, Apt 701', 
    7
  ), 
  (
    '987 Montmartre Rue, Apt 801', 8
  ), 
  ('456 Bandra Road, Apt 901', 9), 
  (
    '123 Shibuya Dori, Apt 1001', 10
  );
INSERT INTO Rating (rating_scale, comments, property_name) 
VALUES 
  (4.5, 'Manhattan Residences','Great place to live!'), 
  (3.2, 'Hollywood Heights', 'Average property.'), 
  (5.0, 'Downtown Lofts','Excellent service.'), 
  (4.7, 'Old Montreal Apartments','Highly recommended.'), 
  (3.9, 'Westminster View','Could be better.'), 
  (4.1, 'Bondi Beach Suites','Good location.'), 
  (4.8, 'Munich Manor','Outstanding experience.'), 
  (2.5, 'Montmartre Apartments','Not satisfied.'), 
  (4.0, 'Bandra Bliss','Nice neighborhood.'), 
  (3.5, 'Shibuya ','Needs improvement');
INSERT INTO PropertyEvent (propertyevent_description) 
VALUES 
  (
    'Maintenance request received.'
  ), 
  ('New lease agreement signed.'), 
  (
    'Emergency maintenance needed.'
  ), 
  ('Fire alarm activated.'), 
  (
    'Property inspection scheduled.'
  ), 
  ('Tenant moved out.'), 
  ('Amenities upgraded.'), 
  ('Pet policy updated.'), 
  (
    'Fine issued for late payment.'
  ), 
  (
    'New building construction started.'
  );
INSERT INTO FAQ (rating_id, propertyevent_id) 
VALUES 
  (1, 1), 
  (2, 2), 
  (3, 3), 
  (4, 4), 
  (5, 5), 
  (6, 6), 
  (7, 7), 
  (8, 8), 
  (9, 9), 
  (10, 10);
INSERT INTO Application (
  application_date, application_status, 
  application_Desc
) 
VALUES 
  (
    '2023-10-01', 'Pending', 'First application for the property.'
  ), 
  (
    '2023-10-02', 'Approved', 'Tenant accepted.'
  ), 
  (
    '2023-10-03', 'Pending', 'Application under review.'
  ), 
  (
    '2023-10-04', 'Rejected', 'Insufficient information.'
  ), 
  (
    '2023-10-05', 'Approved', 'Good credit score.'
  ), 
  (
    '2023-10-06', 'Pending', 'Background check in progress.'
  ), 
  (
    '2023-10-07', 'Approved', 'Lease agreement signed.'
  ), 
  (
    '2023-10-08', 'Rejected', 'Failed credit check.'
  ), 
  (
    '2023-10-09', 'Pending', 'References being checked.'
  ), 
  (
    '2023-10-10', 'Approved', 'Tenant selected.'
  );
INSERT INTO RoomType (room_type_name, monthly_rent) 
VALUES 
  ('Studio', 1200.00), 
  ('1 Bedroom', 1500.00), 
  ('2 Bedroom', 2000.00), 
  ('3 Bedroom', 2500.00), 
  ('Loft', 1800.00), 
  ('Duplex', 2200.00), 
  ('Penthouse', 3000.00), 
  ('Bachelor', 1100.00), 
  ('Townhouse', 1900.00), 
  ('Economy', 900.00);
INSERT INTO Apartment (room_type_id) 
VALUES 
  (1), 
  (2), 
  (3), 
  (4), 
  (5), 
  (6), 
  (7), 
  (8), 
  (9), 
  (10);
INSERT INTO Building (
  building_num, building_type, apartment_id
) 
VALUES 
  (101, 'Residential', 1), 
  (201, 'Residential', 2), 
  (301, 'Residential', 3), 
  (401, 'Residential', 4), 
  (501, 'Residential', 5), 
  (601, 'Residential', 6), 
  (701, 'Residential', 7), 
  (801, 'Residential', 8), 
  (901, 'Residential', 9), 
  (1001, 'Residential', 10);
INSERT INTO Property (
  location_id, building_id, faq_id, 
  property_name
) 
VALUES 
  (1, 1, 1, 'Manhattan Residences'), 
  (2, 2, 2, 'Hollywood Heights'), 
  (3, 3, 3, 'Downtown Lofts'), 
  (
    4, 4, 4, 'Old Montreal Apartments'
  ), 
  (5, 5, 5, 'Westminster View'), 
  (6, 6, 6, 'Bondi Beach Suites'), 
  (7, 7, 7, 'Munich Manor'), 
  (8, 8, 8, 'Montmartre Apartments'), 
  (9, 9, 9, 'Bandra Bliss'), 
  (10, 10, 10, 'Shibuya Residences');
INSERT INTO Lease (
  apartment_id, building_id, lease_start_date, 
  lease_end_date, security_deposit, 
  refund
) 
VALUES 
  (
    1, 1, '2023-10-01', '2024-09-30', 1500.00, 
    0.00
  ), 
  (
    2, 2, '2023-10-02', '2024-09-30', 1800.00, 
    0.00
  ), 
  (
    3, 3, '2023-10-03', '2024-09-30', 2200.00, 
    0.00
  ), 
  (
    4, 4, '2023-10-04', '2023-12-01', 2500.00, 
    0.00
  ), 
  (
    5, 5, '2023-10-05', '2024-09-30', 2000.00, 
    0.00
  ), 
  (
    6, 6, '2023-10-06', '2023-12-13', 2400.00, 
    0.00
  ), 
  (
    7, 7, '2023-10-07', '2024-09-30', 3000.00, 
    0.00
  ), 
  (
    8, 8, '2023-10-08', '2024-09-30', 1400.00, 
    0.00
  ), 
  (
    9, 9, '2023-10-09', '2024-09-30', 1900.00, 
    0.00
  ), 
  (
    10, 10, '2023-10-10', '2024-09-30', 
    1200.00, 0.00
  );
INSERT INTO Tenant (
  application_id, lease_id, first_name, 
  last_name, date_of_birth, credit_score, 
  lease_signed, rating_id
) 
VALUES 
  (
    1, 1, 'John', 'Doe', '1990-03-15', 720, 
    TRUE, 1
  ), 
  (
    2, 2, 'Jane', 'Smith', '1985-07-22', 
    680, FALSE, 2
  ), 
  (
    3, 3, 'Michael', 'Johnson', '1995-11-10', 
    750, TRUE, 3
  ), 
  (
    4, 4, 'Emily', 'Brown', '1992-04-30', 
    700, FALSE, 4
  ), 
  (
    5, 5, 'David', 'Wilson', '1988-09-18', 
    690, TRUE, 5
  ), 
  (
    6, 6, 'Sarah', 'Anderson', '1993-01-25', 
    710, FALSE, 6
  ), 
  (
    7, 7, 'Robert', 'Martinez', '1989-06-03', 
    730, TRUE, 7
  ), 
  (
    8, 8, 'Jennifer', 'Taylor', '1991-08-12', 
    740, FALSE, 8
  ), 
  (
    9, 9, 'William', 'Lee', '1994-12-05', 
    700, TRUE, 9
  ), 
  (
    10, 10, 'Linda', 'Clark', '1987-02-20', 
    710, FALSE, 10
  );
INSERT INTO Payment (
  tenant_id, apartment_id, payment_confirmation, 
  payment_date, payment_amount
) 
VALUES 
  (
    1, 1, 'Payment-0001', '2023-10-15 09:00:00', 
    1500.00
  ), 
  (
    2, 2, 'Payment-0002', '2023-10-15 10:00:00', 
    1800.00
  ), 
  (
    3, 3, 'Payment-0003', '2023-08-11', 
    2200.00
  ), 
  (
    4, 4, 'Payment-0004', '2023-10-15 12:00:00', 
    2500.00
  ), 
  (
    5, 5, 'Payment-0005', '2023-10-15 13:00:00', 
    2000.00
  ), 
  (
    6, 6, 'Payment-0006', '2023-10-15 14:00:00', 
    2400.00
  ), 
  (
    7, 7, 'Payment-0007', '2023-07-10', 
    3000.00
  ), 
  (
    8, 8, 'Payment-0008', '2023-10-15 16:00:00', 
    1400.00
  ), 
  (
    9, 9, 'Payment-0009', '2023-07-21', 
    1900.00
  ), 
  (
    10, 10, 'Payment-0010', '2023-10-15 18:00:00', 
    1200.00
  );
INSERT INTO Department (department_name, property_id) 
VALUES 
  ('Property Management', 1), 
  ('Maintenance', 2), 
  ('Finance', 3), 
  ('Leasing', 4), 
  ('Customer Service', 5), 
  ('HR', 6), 
  ('Legal', 7), 
  ('Marketing', 8), 
  ('IT', 9), 
  ('Security', 10);
INSERT INTO Role (role_title) 
VALUES 
  ('Manager'), 
  ('Supervisor'), 
  ('Coordinator'), 
  ('Specialist'), 
  ('Associate'), 
  ('Analyst'), 
  ('Director'), 
  ('Assistant'), 
  ('Officer'), 
  ('Technician');
INSERT INTO Employee (
  employee_name, role_id, department_id
) 
VALUES 
  ('John Manager', 1, 1), 
  ('Jane Supervisor', 2, 2), 
  ('Michael Coordinator', 3, 3), 
  ('Emily Specialist', 4, 4), 
  ('David Associate', 5, 5), 
  ('Sarah Analyst', 6, 6), 
  ('Robert Director', 7, 7), 
  ('Jennifer Assistant', 8, 8), 
  ('William Officer', 9, 9), 
  ('Linda Technician', 10, 10);

INSERT INTO Amenity (amenity_type, property_id) 
VALUES 
  ('Gym',1), 
  ('Playground', 2), 
  ('Gym',3), 
  ('High-Speed Internet', 4), 
  ('Gym', 5), 
  ('Gym',6), 
  ('Pool', 7), 
  ('Pool', 8), 
  ('High-Speed Internet', 9), 
  ('Tennis Court', 10);
INSERT INTO Utility (
  tenant_id, lease_id, utility_offered
) 
VALUES 
  (1, 1, 'Electricity, Water, Gas'), 
  (2, 2, 'Electricity, Water'), 
  (3, 3, 'Electricity, Internet'), 
  (4, 4, 'Water, Gas'), 
  (
    5, 5, 'Electricity, Water, Gas, Internet'
  ), 
  (6, 6, 'Electricity, Water, Gas'), 
  (
    7, 7, 'Electricity, Water, Internet'
  ), 
  (8, 8, 'Electricity, Water, Gas'), 
  (9, 9, 'Water, Gas, Internet'), 
  (
    10, 10, 'Electricity, Water, Gas, Internet'
  );
INSERT INTO Invoice (
  tenant_id, payment_id, issue_date, 
  amount_billed
) 
VALUES 
  (
    1, 1, '2023-10-05 12:00:00', 1500.00
  ), 
  (
    2, 2, '2023-10-05 13:00:00', 1800.00
  ), 
  (
    3, 3, '2023-10-05 14:00:00', 2200.00
  ), 
  (
    4, 4, '2023-10-05 15:00:00', 2500.00
  ), 
  (
    5, 5, '2023-10-05 16:00:00', 2000.00
  ), 
  (
    6, 6, '2023-10-05 17:00:00', 2400.00
  ), 
  (
    7, 7, '2023-10-05 18:00:00', 3000.00
  ), 
  (
    8, 8, '2023-10-05 19:00:00', 1400.00
  ), 
  (
    9, 9, '2023-10-05 20:00:00', 1900.00
  ), 
  (
    10, 10, '2023-10-05 21:00:00', 1200.00
  );

INSERT INTO EmergencyContact (tenant_id, first_name, last_name, phone_number, relation_to_tenant) VALUES
(1, 'John', 'Doe', '111-222-3333', 'Mother'),
(3, 'Dean', 'Jackson', '111-222-5555', 'Brother'),
(4, 'Sam', 'Winch', '111-222-6666', 'Friend'),
(5, 'Robert', 'Axle', '111-222-7777', 'Father'),
(6, 'Shawn', 'Doe', '111-222-8888', 'Husband'),
(10, 'Jenni', 'Gomez', '222-333-4444', 'Sibling');

INSERT INTO Fine (
  tenant_id, fine_date, issue_date, 
  amount_billed, payment_id
) 
VALUES 
  (
    1, '20231015', '2023-10-20', 50.00, 
    1
  ), 
  (
    2, '20231015', '2023-10-21', 60.00, 
    2
  ), 
  (
    3, '20231015', '2023-10-22', 70.00, 
    3
  ), 
  (
    4, '20231015', '2023-10-23', 80.00, 
    4
  ), 
  (
    5, '20231015', '2023-10-24', 90.00, 
    5
  ), 
  (
    6, '20231015', '2023-10-25', 100.00, 
    6
  ), 
  (
    7, '20231015', '2023-10-26', 110.00, 
    7
  ), 
  (
    8, '20231015', '2023-10-27', 120.00, 
    8
  ), 
  (
    9, '20231015', '2023-10-28', 130.00, 
    9
  ), 
  (
    10, '20231015', '2023-10-29', 140.00, 
    10
  );
INSERT INTO Document (
  tenant_id, document_type, document_name, 
  document_desc, property_id
) 
VALUES 
  (
    1, 'Lease Agreement', 'Lease-001', 
    'Signed lease agreement for Manhattan Residences.', 
    1
  ), 
  (
    2, 'Lease Agreement', 'Lease-002', 
    'Signed lease agreement for Hollywood Heights.', 
    2
  ), 
  (
    3, 'Lease Agreement', 'Lease-003', 
    'Signed lease agreement for Downtown Lofts.', 
    3
  ), 
  (
    4, 'Lease Agreement', 'Lease-004', 
    'Signed lease agreement for Old Montreal Apartments.', 
    4
  ), 
  (
    5, 'Lease Agreement', 'Lease-005', 
    'Signed lease agreement for Westminster View.', 
    5
  ), 
  (
    6, 'Lease Agreement', 'Lease-006', 
    'Signed lease agreement for Bondi Beach Suites.', 
    6
  ), 
  (
    7, 'Lease Agreement', 'Lease-007', 
    'Signed lease agreement for Munich Manor.', 
    7
  ), 
  (
    8, 'Lease Agreement', 'Lease-008', 
    'Signed lease agreement for Montmartre Apartments.', 
    8
  ), 
  (
    9, 'Lease Agreement', 'Lease-009', 
    'Signed lease agreement for Bandra Bliss.', 
    9
  ), 
  (
    10, 'Lease Agreement', 'Lease-010', 
    'Signed lease agreement for Shibuya Residences.', 
    10
  );
INSERT INTO Guarantor (
  tenant_id, guarantor_first_name, 
  guarantor_last_name, guarantor_address, 
  guarantor_phone, relation_to_tenant
) 
VALUES 
  (
    1, 'Guarantor1', 'Lastname1', 'Guarantor Address 1', 
    '123-456-7890', 'Parent'
  ), 
  (
    2, 'Guarantor2', 'Lastname2', 'Guarantor Address 2', 
    '234-567-8901', 'Sibling'
  ), 
  (
    3, 'Guarantor3', 'Lastname3', 'Guarantor Address 3', 
    '345-678-9012', 'Friend'
  ), 
  (
    4, 'Guarantor4', 'Lastname4', 'Guarantor Address 4', 
    '456-789-0123', 'Spouse'
  ), 
  (
    5, 'Guarantor5', 'Lastname5', 'Guarantor Address 5', 
    '567-890-1234', 'Relative'
  ), 
  (
    6, 'Guarantor6', 'Lastname6', 'Guarantor Address 6', 
    '678-901-2345', 'Parent'
  ), 
  (
    7, 'Guarantor7', 'Lastname7', 'Guarantor Address 7', 
    '789-012-3456', 'Sibling'
  ), 
  (
    8, 'Guarantor8', 'Lastname8', 'Guarantor Address 8', 
    '890-123-4567', 'Friend'
  ), 
  (
    9, 'Guarantor9', 'Lastname9', 'Guarantor Address 9', 
    '901-234-5678', 'Spouse'
  ), 
  (
    10, 'Guarantor10', 'Lastname10', 'Guarantor Address 10', 
    '012-345-6789', 'Relative'
  );
INSERT INTO Parking (building_id, parking_type) 
VALUES 
  (1, 'Garage'), 
  (2, 'Street'), 
  (3, 'Covered'), 
  (4, 'Open Lot'), 
  (5, 'Garage'), 
  (6, 'Street'), 
  (7, 'Covered'), 
  (8, 'Open Lot'), 
  (9, 'Garage'), 
  (10, 'Street');
INSERT INTO PetPolicy (building_id, policy_type) 
VALUES 
  (1, 'Allowed'), 
  (2, 'Not Allowed'), 
  (3, 'Allowed'), 
  (4, 'Not Allowed'), 
  (5, 'Allowed'), 
  (6, 'Not Allowed'), 
  (7, 'Allowed'), 
  (8, 'Not Allowed'), 
  (9, 'Allowed'), 
  (10, 'Not Allowed');
INSERT INTO Notification (propertyevent_id, employee_id) 
VALUES 
  (1, 1), 
  (2, 2), 
  (3, 3), 
  (4, 4), 
  (5, 5), 
  (6, 6), 
  (7, 7), 
  (8, 8), 
  (9, 9), 
  (10, 10);
INSERT INTO Inspection (
  tenant_id, apartment_id, last_inpection, 
  first_inspection
) 
VALUES 
  (1, 1, '2023-10-01', '2023-09-01'), 
  (2, 2, '2023-10-02', '2023-09-02'), 
  (3, 3, '2023-10-03', '2023-09-03'), 
  (4, 4, '2023-10-04', '2023-09-04'), 
  (5, 5, '2023-10-05', '2023-09-05'), 
  (6, 6, '2023-10-06', '2023-09-06'), 
  (7, 7, '2023-10-07', '2023-09-07'), 
  (8, 8, '2023-10-08', '2023-09-08'), 
  (9, 9, '2023-10-09', '2023-09-09'), 
  (
    10, 10, '2023-10-10', '2023-09-10'
  );
INSERT INTO MaintenanceRequest (
  tenant_id, employee_id, request_date, 
  request_description, urgency, schedule_date, 
  cost, maintain_history, ticket
) 
VALUES 
  (
    1, 1, '2023-10-15', 'Leaky faucet', 
    'High', '2023-10-16', 50.00, 'Faucet replaced', 
    'Ticket-001'
  ), 
  (
    2, 2, '2023-10-15', 'Broken window', 
    'Medium', '2023-10-17', 60.00, 'Window repaired', 
    'Ticket-002'
  ), 
  (
    3, 3, '2023-10-15', 'Clogged drain', 
    'Low', '2023-10-18', 70.00, 'Drain cleared', 
    'Ticket-003'
  ), 
  (
    4, 4, '2023-10-15', 'No hot water', 
    'High', '2023-10-19', 80.00, 'Heater fixed', 
    'Ticket-004'
  ), 
  (
    5, 5, '2023-10-15', 'Broken door', 
    'Medium', '2023-10-20', 90.00, 'Door replaced', 
    'Ticket-005'
  ), 
  (
    6, 6, '2023-10-15', 'Leaky roof', 'Low', 
    '2023-10-21', 100.00, 'Roof patched', 
    'Ticket-006'
  ), 
  (
    7, 7, '2023-10-15', 'Faulty wiring', 
    'High', '2023-10-22', 110.00, 'Wiring repaired', 
    'Ticket-007'
  ), 
  (
    8, 8, '2023-10-15', 'AC not working', 
    'Medium', '2023-10-23', 120.00, 'AC fixed', 
    'Ticket-008'
  ), 
  (
    9, 9, '2023-10-15', 'Pest issue', 'Low', 
    '2023-10-24', 130.00, 'Pest control', 
    'Ticket-009'
  ), 
  (
    10, 10, '2023-10-15', 'Heating problem', 
    'High', '2023-10-25', 140.00, 'Heating fixed', 
    'Ticket-010'
  );

-- SQL Problems and Solutions start here
-- Query #1:  
-- List all tenants who have submitted an application but have not yet signed a lease.
SELECT * FROM Tenant WHERE lease_signed = FALSE;

-- Query #2: 
-- Identify the top 3 amenities that are most commonly listed in properties.
SELECT amenity_type, COUNT(*) AS type_frequency FROM Amenity GROUP BY amenity_type ORDER BY type_frequency DESC LIMIT 3;

-- Query #3: 
-- Find all tenants whose leases are expiring in the next 30 days. 
SELECT Tenant.* FROM Lease JOIN Tenant ON Lease.lease_id = Tenant.lease_id  WHERE Lease.lease_end_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY); 

-- Query #4:
-- List all tenants who have outstanding payments for more than two months.

-- Query #5:
-- Shohw the number of open maintenance requests per department.

-- Query #6: 
-- List properties with an average rating of 4.5 or higher.
SELECT rating_scale, property_name from Rating WHERE rating_scale >= 4.5; 

-- Query #7: 
-- Identify tenants who have not provided emergency contact information.
SELECT Tenant.tenant_id, Tenant.first_name, Tenant.last_name, Tenant.lease_id FROM Tenant
LEFT JOIN EmergencyContact on Tenant.tenant_id = EmergencyContact.tenant_id WHERE EmergencyContact.tenant_id IS NULL;

-- Query #8: 
-- Show the percentage of parking spaces utilized per property.
SELECT * FROM PARKING;

-- Query #9:
-- List the top 5 FAQs that have been consulted by tenants.

-- Query #10:
-- Identify tenants who have not yet aknowledged notifications for upcomming events.

-- Query #11: 
-- List properties that have received more than two fines due to failed inpections
SHOW TABLES;
SELECT * FROM Inspection;

-- Query #12: 
-- Calculate the total amount to be refunded in security deposits for leases

 

