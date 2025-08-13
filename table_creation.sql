-- Creating the database along with it's table
CREATE DATABASE `Synthea_Health`;
USE `Synthea_Health`;

CREATE TABLE patients (
id VARCHAR(255) PRIMARY KEY,
birthdate DATE NULL,
deathdate DATE NULL,
ssn VARCHAR(255) NULL,
drivers VARCHAR(255) NULL,
passport VARCHAR(255) NULL,
prefix VARCHAR(255) NULL,
first_name VARCHAR(255) NULL,
middle_name VARCHAR(255) NULL,
last_name VARCHAR(255) NULL,
suffix VARCHAR(255) NULL,
maiden_name VARCHAR(255) NULL,
marital VARCHAR(255) NULL,
race VARCHAR(255) NULL,
ethnicity VARCHAR(255) NULL,
gender VARCHAR(255) NULL,
birthplace VARCHAR(255) NULL,
address VARCHAR(255) NULL,
city VARCHAR(255) NULL,
state VARCHAR(255) NULL,
county VARCHAR(255) NULL,
fips INT(255) NULL,
zip INT(255) NULL,
lat DECIMAL(9,6) NULL,
lon DECIMAL(9,6) NULL,
healthcare_expense DECIMAL(12,2) NULL,
healthcare_coverage DECIMAL(12,2) NULL,
income INT NULL
);

CREATE TABLE allergies(
start DATE NULL, 
stop DATE NULL,
patient VARCHAR(255) NULL,
encounter VARCHAR(255) NULL,
code VARCHAR(255) NULL,
sys_tem VARCHAR(255) NULL,
description VARCHAR(255) NULL,
type VARCHAR(255) NULL,
category VARCHAR(255) NULL,
reaction1 VARCHAR(255) NULL,
description1 VARCHAR(255) NULL,
severity1 VARCHAR(255) NULL,
reaction2 VARCHAR(255) NULL,
description2 VARCHAR(255) NULL,
severity2 VARCHAR(255) NULL,
FOREIGN KEY (patient) REFERENCES patients(id) 
);

CREATE TABLE careplans(
id VARCHAR(255) PRIMARY KEY,
start DATE NULL, 
stop DATE NULL,
patient VARCHAR(255) NULL,
encounter VARCHAR(255) NULL,
code VARCHAR(255) NULL,
description VARCHAR(255) NULL,
reasoncode VARCHAR(255) NULL,
reasondescription VARCHAR(255) NULL,
FOREIGN KEY (patient) REFERENCES patients(id)
);

CREATE TABLE claims(
id VARCHAR(255) PRIMARY KEY,
patient_id VARCHAR(255) NULL,
provider_id VARCHAR(255) NULL,
primary_patient_insurance_id VARCHAR(255) NULL,
secondary_patient_insurance_id VARCHAR(255) NULL,
department_id INT NULL,
patient_department_id INT NULL,
diagnosis1 VARCHAR(255) NULL,
diagnosis2 VARCHAR(255) NULL,
diagnosis3 VARCHAR(255) NULL,
diagnosis4 VARCHAR(255) NULL,
diagnosis5 VARCHAR(255) NULL,
diagnosis6 VARCHAR(255) NULL,
diagnosis7 VARCHAR(255) NULL,
diagnosis8 VARCHAR(255) NULL,
referring_provider_id VARCHAR(255) NULL,
appointment_id VARCHAR(255) NULL,
current_illness_date DATETIME NULL, 
service_date DATETIME NULL, 
supervising_provider_id VARCHAR(255) NULL,
status1 VARCHAR(255) NULL,
status2 VARCHAR(255) NULL,
statusp VARCHAR(255) NULL,
outstanding1 VARCHAR(255) NULL,
outstanding2 VARCHAR(255) NULL,
outstandingp VARCHAR(255) NULL,
last_billed_date1 DATETIME NULL,
last_billed_date2 DATETIME NULL,
last_billed_datep DATETIME NULL,
health_care_claim_type_id1 INT NULL,
health_care_claim_type_id2 INT NULL,
FOREIGN KEY (patient_id) REFERENCES patients(id)
); 

CREATE TABLE claims_transactions(
id VARCHAR(255) PRIMARY KEY,
claim_id VARCHAR(255) NULL, 
charge_id INT NULL, 
patient_id VARCHAR(255) NULL,
type VARCHAR(255) NULL,
amount DECIMAL(10,2) NULL,
method VARCHAR(255) NULL,
from_date DATETIME NULL,
to_date DATETIME NULL,
place_of_service VARCHAR(255) NULL,
procedure_code VARCHAR(255) NULL, 
modifier1 VARCHAR(255) NULL,
modifier2 VARCHAR(255) NULL,
diagnosis_ref1 INT NULL,
diagnosis_ref2 INT NULL,
diagnosis_ref3 INT NULL,
diagnosis_ref4 INT NULL,
units INT NULL, 
department_id INT NULL,
notes VARCHAR(255) NULL,
unit_amount DECIMAL(10,2) NULL,
transfer_out_id INT NULL, 
transfer_type VARCHAR(255) NULL,
payments DECIMAL(10,2) NULL,
adjustments INT NULL,
transfers DECIMAL(10,2) NULL,
outstanding DECIMAL(10,2) NULL, 
appointment_id VARCHAR(255) NULL,
line_note VARCHAR(255) NULL,
patient_insurance_id VARCHAR(255) NULL,
fee_schedule_id INT NULL, 
provider_id VARCHAR(255) NULL,
supervising_provider_id VARCHAR(255) NULL,
FOREIGN KEY (patient_id) REFERENCES patients(id)
);

CREATE TABLE conditions(
start DATE NULL,
stop DATE NULL, 
patient VARCHAR(255) NULL,
encounter VARCHAR(255) NULL,
sys_tem VARCHAR(255) NULL,
code VARCHAR(255) NULL,
description VARCHAR(255) NULL,
FOREIGN KEY (patient) REFERENCES patients(id)
);

CREATE TABLE devices(
start DATE NULL,
stop DATE NULL,
patient VARCHAR(255) NULL,
encounter VARCHAR(255) NULL,
code VARCHAR(255) NULL,
description VARCHAR(255) NULL,
udi VARCHAR(255) NULL,
FOREIGN KEY (patient) REFERENCES patients(id)
);

CREATE TABLE encounters(
id VARCHAR(255) PRIMARY KEY,
start DATETIME NULL,
stop  DATETIME NULL, 
patient VARCHAR(255) NULL,
organization VARCHAR(255) NULL,
provider VARCHAR(255) NULL,
payer VARCHAR(255) NULL,
encounter_class VARCHAR(255) NULL,
code VARCHAR(255) NULL,
description VARCHAR(255) NULL,
base_encounter_cost DECIMAL(10,2) NULL,
total_claim_cost DECIMAL(10,2) NULL,
payer_coverage DECIMAL(10,2) NULL, 
reason_code VARCHAR(255) NULL,
reason_description VARCHAR(255) NULL,
FOREIGN KEY (patient) REFERENCES patients(id)
);

CREATE TABLE imaging_studies(
internal_id INT PRIMARY KEY,
id VARCHAR(255),
date DATE NULL,
time TIME NULL,
patient VARCHAR(255) NULL,
encounter VARCHAR(255) NULL,
series_uid VARCHAR(255) NULL,
bodysite_code VARCHAR(255) NULL,
bodysite_description VARCHAR(255) NULL,
modality_code VARCHAR(255) NULL,
modality_description VARCHAR(255) NULL,
instance_uid VARCHAR(255) NULL,
sop_code VARCHAR(255) NULL,
sop_description VARCHAR(255) NULL,
procedure_code VARCHAR(255) NULL,
FOREIGN KEY (patient) REFERENCES patients(id)
);

CREATE TABLE immunizations(
date DATETIME NULL,
patient VARCHAR(255) NULL,
encounter VARCHAR(255) NULL,
code INT NULL,
description VARCHAR(255) NULL,
base_cost INT NULL,
FOREIGN KEY (patient) REFERENCES patients(id)	
);

CREATE TABLE medications(
start DATETIME NULL,
stop DATETIME NULL,
patient VARCHAR(255) NULL,
payer VARCHAR(255) NULL,
encounter VARCHAR(255) NULL,
code INT NULL,
description VARCHAR(255) NULL,
base_cost DECIMAL(10,2) NULL,
payer_coverage DECIMAL(10,2) NULL,
dispenses INT NULL,
total_cost DECIMAL(10,2) NULL,
reason_code VARCHAR(255) NULL,
reason_description VARCHAR(255) NULL,
FOREIGN KEY (patient) REFERENCES patients(id)
);

CREATE TABLE observations(
date_recorded DATETIME NULL,
patient VARCHAR(255) NULL,
encounter VARCHAR(255) NULL,
category VARCHAR(255) NULL,
code VARCHAR(255) NULL,
description VARCHAR(255) NULL,
value VARCHAR(255) NULL,
units VARCHAR(255) NULL,
type VARCHAR(255) NULL,
FOREIGN KEY (patient) REFERENCES patients(id)
);


CREATE TABLE organizations(
id VARCHAR(255) PRIMARY KEY,
name VARCHAR(255) NULL,
address VARCHAR(255) NULL,
city VARCHAR(255) NULL,
state VARCHAR(255) NULL,
zip VARCHAR(64) NULL,
lat DECIMAL(15,12) NULL,
lon DECIMAL(15,12) NULL, 
phone VARCHAR(255) NULL,
revenue INT NULL,
utilization INT NULL  
);

CREATE TABLE payer_transitions(
internal_id INT PRIMARY KEY,
patient VARCHAR(255) NULL,
member_id VARCHAR(255),
start_date DATE NULL, 
start_time TIME NULL,
end_date DATE NULL,
end_time TIME NULL,
payer VARCHAR(255) NULL,
secondary_payer VARCHAR(255) NULL,
plan_ownership VARCHAR(255) NULL,
owner_name VARCHAR(255) NULL,
FOREIGN KEY (patient) REFERENCES patients(id)
);

CREATE TABLE payers(
id VARCHAR(255) PRIMARY KEY,
name VARCHAR(255) NULL,
ownership VARCHAR(255) NULL,
address VARCHAR(255) NULL,
city VARCHAR(255) NULL,
state_headquartered VARCHAR(255) NULL,
zip VARCHAR(255) NULL,
phone VARCHAR(255) NULL,
amount_covered DECIMAL(10,2) NULL,
amount_uncovered DECIMAL(10,2) NULL,
revenue DECIMAL(10,2) NULL,
covered_encounters INT NULL,
uncovered_encounters INT NULL,
covered_medications INT NULL,
uncovered_medications INT NULL,
covered_procedures INT NULL,
uncovered_procedures INT NULL,
covered_immunizations INT NULL,
uncovered_immunizations INT NULL,
unique_customers INT NULL,
qols_avg DECIMAL(10,9) NULL,
member_months INT NULL
);

CREATE TABLE procedures(
start_date DATE NULL,
start_time TIME NULL,
stop_date DATE NULL,
stop_time TIME NULL,
patient VARCHAR(255) NULL,
encounter VARCHAR(255) NULL,
sys_tem VARCHAR(255) NULL,
code VARCHAR(255) NULL,
description VARCHAR(255) NULL,
base_cost DECIMAL(10,2) NULL,
reason_code VARCHAR(64) NULL,
reason_description VARCHAR(255) NULL,
FOREIGN KEY (patient) REFERENCES patients(id)
);

CREATE TABLE providers(
id VARCHAR(255) PRIMARY KEY,
organization VARCHAR(255) NULL,
name VARCHAR(255) NULL,
gender VARCHAR(255) NULL,
specialty VARCHAR(255) NULL,
address VARCHAR(255) NULL,
city VARCHAR(255) NULL,
state VARCHAR(255) NULL,
zip INT NULL, 
lat DECIMAL(15,12) NULL, 
lon DECIMAL(15,12) NULL,
encounters INT NULL,
procedures INT NULL,
FOREIGN KEY (organization) REFERENCES organizations(id)  
);

CREATE TABLE supplies(
date DATE NULL, 
patient VARCHAR(255) NULL,
encounter VARCHAR(255) NULL,
code VARCHAR(255) NULL,
description VARCHAR(255) NULL,
quantity INT NULL, 
FOREIGN KEY (patient) REFERENCES patients(id)
);


LOAD DATA INFILE 
INTO TABLE supplies
FIELDS TERMINATED BY ","
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;






