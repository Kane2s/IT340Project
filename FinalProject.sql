-- Created By Xavier, Kane and Curtis
-- Tables done by Xavier
-- Primary keys and Foreign keys done by Curtis
-- Relationships done by Kane
/*
DROP TABLE DRUGWARDREQ;
DROP TABLE SURGWARDREQ;
DROP TABLE PATIENTMEDS;
DROP TABLE PHARMSUPPLIES;
DROP TABLE SURGSUPPLIES;
DROP TABLE OUTPATIENTS;
DROP TABLE INPATIENTS;
DROP TABLE PATAPP;
DROP TABLE LOCALDOCTORS;
DROP TABLE NEXTOFKIN;
DROP TABLE PATIENT;
DROP TABLE STAFF;
DROP TABLE WARD;
DROP TABLE SUPPLIERS;
DROP TABLE CLINIC;
*/
-- Creating Tables
CREATE SCHEMA IF NOT EXISTS hospital;
USE hospital;
CREATE TABLE CLINIC (
	ClinicNum INTEGER NOT NULL,
    ClinicName CHAR(50) NOT NULL,
    ClinicCity CHAR(50) NOT NULL,
    ClinicState CHAR(50) NOT NULL,
    ClinicStreet CHAR(50) NOT NULL,
    ClinicBuildNum INTEGER NOT NULL,
    ClinicZip INTEGER NOT NULL,
    PRIMARY KEY (ClinicNum)
);

CREATE TABLE WARD (
	WardNum INTEGER NOT NULL,
    ClinicNum INTEGER NOT NULL,
    WardName CHAR(50) NOT NULL,
    WardLocation CHAR(50),
    WardBeds INTEGER NOT NULL,
    WardPhone CHAR(20) NOT NULL,
    PRIMARY KEY (WardNum), 
    FOREIGN KEY (ClinicNum) REFERENCES CLINIC(ClinicNum)
);

CREATE TABLE STAFF (
	StaffNum INTEGER NOT NULL,
    StaffFName CHAR(50) NOT NULL,
    StaffLName CHAR(50) NOT NULL,
    StaffCity CHAR(30),
    StaffStreet CHAR(40), 
    StaffHouseNum INTEGER,
    StaffDOB DATE NOT NULL,
    StaffSex Char(10) NOT NULL,
    -- Sex --> Male, Female, Other
    StaffNIN INTEGER NOT NULL,
    StaffPosition CHAR(20) NOT NULL,
    StaffSalary DECIMAL(20,2) NOT NULL,
    StaffScale CHAR(10) NOT NULL,
    -- Scale --> Salary or Wage
    StaffContract CHAR(10) NOT NULL,
    StaffHours INTEGER,
    StaffTemp CHAR(15),
    StaffPayType CHAR(25),
    StaffShift CHAR(5),
    -- Shift --> Early, Late or Night shift
    PRIMARY KEY (StaffNum)
);

CREATE TABLE PATIENT (
	PatNum INTEGER NOT NULL,
    PatFName CHAR(50) NOT NULL,
    PatLName CHAR(50) NOT NULL,
    PatState Char(50) NOT NULL,
    PatCity CHAR(30) NOT NULL,
    PatStreet CHAR(40) NOT NULL, 
    PatHouseNum INTEGER NOT NULL,
    PatZip INTEGER NOT NULL,
    PatDOB DATE NOT NULL,
    Sex Char(10) NOT NULL,
    -- Sex --> Male, Female, Other
    PatMarStat Char(18),
    -- Mar --> Married, Not Married
    PatRegDate DATE NOT NULL,
    PatKin Char(20),
    PRIMARY KEY (PatNum)
);

CREATE TABLE NEXTOFKIN (
	FullName CHAR(50) NOT NULL,
    RelationToPatient CHAR(30) NOT NULL,
	KinState CHAR(30) NOT NULL,
    KinCity CHAR(30) NOT NULL,
    KinStreet CHAR(40) NOT NULL, 
    KinHouseNum INTEGER NOT NULL,
    KinZip INTEGER NOT NULL,
    PhoneNum CHAR(40),
    PatNum INTEGER,
    FOREIGN KEY (PatNum) REFERENCES PATIENT(PatNum)
);

CREATE TABLE LOCALDOCTORS (
	StaffNum INTEGER NOT NULL,
    ClinicNum INTEGER NOT NULL,
    FOREIGN KEY (StaffNum) REFERENCES STAFF(StaffNum),
    FOREIGN KEY (ClinicNum) REFERENCES CLINIC(ClinicNum)
);

-- Patient Appoinments
CREATE TABLE PATAPP (
	AppNum INTEGER NOT NULL,
    StaffNum INTEGER NOT NULL,
    AppDate DATETIME NOT NULL,
    ExamRoom INTEGER NOT NULL,
    DateOfWaitingList DATE,
    PRIMARY KEY (AppNum),
    FOREIGN KEY (StaffNum) REFERENCES STAFF(StaffNum)
);

CREATE TABLE OUTPATIENTS (
	PatNum INTEGER NOT NULL,
    AppNum INTEGER NOT NULL,
    FOREIGN KEY (PatNum) REFERENCES PATIENT(PatNum),
    FOREIGN KEY (AppNum) REFERENCES PATAPP(AppNum)
);

CREATE TABLE INPATIENTS (
	BedNum INTEGER,
    WardNum INTEGER,
    PatNum INTEGER,
    FullName CHAR(50) NOT NULL,
    Address CHAR(50),
    PhoneNum CHAR(50),
    DateOfBirth DATE NOT NULL,
    Sex CHAR(10) NOT NULL,
    -- Sex --> Male, Female, Other
	PatMarStat CHAR(18),
    -- Mar --> Married, Not Married
    PatRegDate DATE NOT NULL,
    PatKin CHAR(20),
    DateOfWaitingList DATE NOT NULL,
    WardRequired INTEGER NULL,
    DatePlacedInWard DATE NOT NULL,
    DateToLeave DATE,
    DateLeft DATE,
    FOREIGN KEY (PatNum) REFERENCES PATIENT(PatNum),
	FOREIGN KEY (WardNum) REFERENCES WARD(WardNum)
);

CREATE TABLE SUPPLIERS (
	SuppName CHAR(50) NOT NULL,
    SuppNum INTEGER NOT NULL,
    SuppCity CHAR(50) NOT NULL,
    SuppState CHAR(50) NOT NULL,
    SuppStreet CHAR(50) NOT NULL,
    SuppBuildNum INTEGER NOT NULL,
    SuppZip INTEGER NOT NULL,
    SuppPhone Char(20) NOT NULL,
    SuppFax INTEGER,
    PRIMARY KEY (SuppNum)
);

CREATE TABLE SURGSUPPLIES (
	SurgSuppNum INTEGER NOT NULL,
    SuppNum INTEGER NOT NULL,
    SurgSuppName CHAR(50) NOT NULL,
    SurgSuppDescrip CHAR(200),
    SurgSuppQuantity INTEGER NOT NULL,
    SurgSuppReOrder CHAR(50) NOT NULL,
    SurgSuppCost DECIMAL (50,2) NOT NULL,
    PRIMARY KEY (SurgSuppNum),
    FOREIGN KEY (SuppNum) REFERENCES SUPPLIERS(SuppNum)
);

CREATE TABLE PHARMSUPPLIES (
	DrugNum INT NOT NULL,
    SuppNum INTEGER NOT NULL,
    DrugName CHAR(50) NOT NULL,
    DrugDose DECIMAL(30,10) NOT NULL,
    DurgAdmin CHAR(50) NOT NULL,
    DrugQuantity INTEGER NOT NULL,
    DrugReOrder CHAR(50) NOT NULL,
    DrugCost DECIMAL (50,2) NOT NULL,
    PRIMARY KEY (DrugNum),
    FOREIGN KEY (SuppNum) REFERENCES SUPPLIERS(SuppNum)
);

CREATE TABLE PATIENTMEDS (
	PatName CHAR(50) NOT NULL,
    PatNum INTEGER NOT NULL,
    DrugName CHAR(50) NOT NULL,
    DrugNum INTEGER NOT NULL,
    DrugUnits DECIMAL(50,10) NOT NULL,
    DrugAdmin CHAR(50),
    MedStartDate DATE NOT NULL,
    MedFinishDate DATE,
    FOREIGN KEY (PatNum) REFERENCES PATIENT(PatNum),
    FOREIGN KEY (DrugNum) REFERENCES PHARMSUPPLIES(DrugNum)
);

CREATE TABLE SURGWARDREQ (
	ReqNum INTEGER NOT NULL,
    StaffName Char(50) NOT NULL,
    WardNum INTEGER NOT NULL,
    SurgSuppNum INTEGER NOT NULL,
    PRIMARY KEY (ReqNum),
    FOREIGN KEY (SurgSuppNum) REFERENCES SURGSUPPLIES(SurgSuppNum),
    FOREIGN KEY (WardNum) REFERENCES WARD(WardNum)
);

CREATE TABLE DRUGWARDREQ (
	ReqNum INTEGER NOT NULL,
    WardNum INTEGER NOT NULL,
    DrugNum INTEGER NOT NULL,
    DrugName CHAR(50) NOT NULL,
    DrugDescription CHAR(200) NOT NULL,
    DrugDose DECIMAL(30,10) NOT NULL,
    DurgAdmin CHAR(50) NOT NULL,
    DrugQuantity INTEGER NOT NULL,
    DrugCost DECIMAL (50,2) NOT NULL,
    StaffName CHAR(50) NOT NULL,
    PRIMARY KEY (ReqNum),
    FOREIGN KEY (DrugNum) REFERENCES PHARMSUPPLIES(DrugNum),
    FOREIGN KEY (WardNum) REFERENCES WARD(WardNum)
);
