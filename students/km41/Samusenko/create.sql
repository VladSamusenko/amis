
--
-- Create model ContentType
--
CREATE TABLE "DJANGO_CONTENT_TYPE" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "NAME" NVARCHAR2(100) NULL, "APP_LABEL" NVARCHAR2(100) NULL, "MODEL" NVARCHAR2(100) NULL);
--
-- Alter unique_together for contenttype (1 constraint(s))
--
ALTER TABLE "DJANGO_CONTENT_TYPE" ADD CONSTRAINT "DJANGO_CO_APP_LABEL_76BD3D3B_U" UNIQUE ("APP_LABEL", "MODEL");

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'DJANGO_CONTENT_TYPE_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "DJANGO_CONTENT_TYPE_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "DJANGO_CONTENT_TYPE_TR"
BEFORE INSERT ON "DJANGO_CONTENT_TYPE"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "DJANGO_CONTENT_TYPE_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/
COMMIT;


--
-- Create model Permission
--
CREATE TABLE "AUTH_PERMISSION" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "NAME" NVARCHAR2(50) NULL, "CONTENT_TYPE_ID" NUMBER(11) NOT NULL, "CODENAME" NVARCHAR2(100) NULL);
--
-- Create model Group
--
CREATE TABLE "AUTH_GROUP" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "NAME" NVARCHAR2(80) NULL UNIQUE);
CREATE TABLE "AUTH_GROUP_PERMISSIONS" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "GROUP_ID" NUMBER(11) NOT NULL, "PERMISSION_ID" NUMBER(11) NOT NULL);
--
-- Create model User
--
CREATE TABLE "AUTH_USER" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "PASSWORD" NVARCHAR2(128) NULL, "LAST_LOGIN" TIMESTAMP NOT NULL, "IS_SUPERUSER" NUMBER(1) NOT NULL CHECK ("IS_SUPERUSER" IN (0,1)), "USERNAME" NVARCHAR2(30) NULL UNIQUE, "FIRST_NAME" NVARCHAR2(30) NULL, "LAST_NAME" NVARCHAR2(30) NULL, "EMAIL" NVARCHAR2(75) NULL, "IS_STAFF" NUMBER(1) NOT NULL CHECK ("IS_STAFF" IN (0,1)), "IS_ACTIVE" NUMBER(1) NOT NULL CHECK ("IS_ACTIVE" IN (0,1)), "DATE_JOINED" TIMESTAMP NOT NULL);
CREATE TABLE "AUTH_USER_GROUPS" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "USER_ID" NUMBER(11) NOT NULL, "GROUP_ID" NUMBER(11) NOT NULL);
CREATE TABLE "AUTH_USER_USER_PERMISSIONS" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "USER_ID" NUMBER(11) NOT NULL, "PERMISSION_ID" NUMBER(11) NOT NULL);

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'AUTH_PERMISSION_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "AUTH_PERMISSION_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "AUTH_PERMISSION_TR"
BEFORE INSERT ON "AUTH_PERMISSION"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "AUTH_PERMISSION_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/
ALTER TABLE "AUTH_PERMISSION" ADD CONSTRAINT "AUTH_PERM_CONTENT_T_2F476E4B_F" FOREIGN KEY ("CONTENT_TYPE_ID") REFERENCES "DJANGO_CONTENT_TYPE" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "AUTH_PERMISSION" ADD CONSTRAINT "AUTH_PERM_CONTENT_T_01AB375A_U" UNIQUE ("CONTENT_TYPE_ID", "CODENAME");
CREATE INDEX "AUTH_PERMI_CONTENT_TY_2F476E4B" ON "AUTH_PERMISSION" ("CONTENT_TYPE_ID");

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'AUTH_GROUP_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "AUTH_GROUP_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "AUTH_GROUP_TR"
BEFORE INSERT ON "AUTH_GROUP"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "AUTH_GROUP_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'AUTH_GROUP_PERMISSIONS_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "AUTH_GROUP_PERMISSIONS_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "AUTH_GROUP_PERMISSIONS_TR"
BEFORE INSERT ON "AUTH_GROUP_PERMISSIONS"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "AUTH_GROUP_PERMISSIONS_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/
ALTER TABLE "AUTH_GROUP_PERMISSIONS" ADD CONSTRAINT "AUTH_GROU_GROUP_ID_B120CBF9_F" FOREIGN KEY ("GROUP_ID") REFERENCES "AUTH_GROUP" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "AUTH_GROUP_PERMISSIONS" ADD CONSTRAINT "AUTH_GROU_PERMISSIO_84C5C92E_F" FOREIGN KEY ("PERMISSION_ID") REFERENCES "AUTH_PERMISSION" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "AUTH_GROUP_PERMISSIONS" ADD CONSTRAINT "AUTH_GROU_GROUP_ID__0CD325B0_U" UNIQUE ("GROUP_ID", "PERMISSION_ID");
CREATE INDEX "AUTH_GROUP_GROUP_ID_B120CBF9" ON "AUTH_GROUP_PERMISSIONS" ("GROUP_ID");
CREATE INDEX "AUTH_GROUP_PERMISSION_84C5C92E" ON "AUTH_GROUP_PERMISSIONS" ("PERMISSION_ID");

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'AUTH_USER_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "AUTH_USER_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "AUTH_USER_TR"
BEFORE INSERT ON "AUTH_USER"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "AUTH_USER_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'AUTH_USER_GROUPS_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "AUTH_USER_GROUPS_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "AUTH_USER_GROUPS_TR"
BEFORE INSERT ON "AUTH_USER_GROUPS"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "AUTH_USER_GROUPS_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/
ALTER TABLE "AUTH_USER_GROUPS" ADD CONSTRAINT "AUTH_USER_USER_ID_6A12ED8B_F" FOREIGN KEY ("USER_ID") REFERENCES "AUTH_USER" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "AUTH_USER_GROUPS" ADD CONSTRAINT "AUTH_USER_GROUP_ID_97559544_F" FOREIGN KEY ("GROUP_ID") REFERENCES "AUTH_GROUP" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "AUTH_USER_GROUPS" ADD CONSTRAINT "AUTH_USER_USER_ID_G_94350C0C_U" UNIQUE ("USER_ID", "GROUP_ID");
CREATE INDEX "AUTH_USER__USER_ID_6A12ED8B" ON "AUTH_USER_GROUPS" ("USER_ID");
CREATE INDEX "AUTH_USER__GROUP_ID_97559544" ON "AUTH_USER_GROUPS" ("GROUP_ID");

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'AUTH_USER_USER_PERMISSI7B1E';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "AUTH_USER_USER_PERMISSI7B1E"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "AUTH_USER_USER_PERMISSI17F3"
BEFORE INSERT ON "AUTH_USER_USER_PERMISSIONS"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "AUTH_USER_USER_PERMISSI7B1E".nextval
        INTO :new."ID" FROM dual;
    END;
/
ALTER TABLE "AUTH_USER_USER_PERMISSIONS" ADD CONSTRAINT "AUTH_USER_USER_ID_A95EAD1B_F" FOREIGN KEY ("USER_ID") REFERENCES "AUTH_USER" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "AUTH_USER_USER_PERMISSIONS" ADD CONSTRAINT "AUTH_USER_PERMISSIO_1FBB5F2C_F" FOREIGN KEY ("PERMISSION_ID") REFERENCES "AUTH_PERMISSION" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "AUTH_USER_USER_PERMISSIONS" ADD CONSTRAINT "AUTH_USER_USER_ID_P_14A6B632_U" UNIQUE ("USER_ID", "PERMISSION_ID");
CREATE INDEX "AUTH_USER__USER_ID_A95EAD1B" ON "AUTH_USER_USER_PERMISSIONS" ("USER_ID");
CREATE INDEX "AUTH_USER__PERMISSION_1FBB5F2C" ON "AUTH_USER_USER_PERMISSIONS" ("PERMISSION_ID");
COMMIT;


--
-- Create model LogEntry
--
CREATE TABLE "DJANGO_ADMIN_LOG" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "ACTION_TIME" TIMESTAMP NOT NULL, "OBJECT_ID" NCLOB NULL, "OBJECT_REPR" NVARCHAR2(200) NULL, "ACTION_FLAG" NUMBER(11) NOT NULL CHECK ("ACTION_FLAG" >= 0), "CHANGE_MESSAGE" NCLOB NULL, "CONTENT_TYPE_ID" NUMBER(11) NULL, "USER_ID" NUMBER(11) NOT NULL);

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'DJANGO_ADMIN_LOG_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "DJANGO_ADMIN_LOG_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "DJANGO_ADMIN_LOG_TR"
BEFORE INSERT ON "DJANGO_ADMIN_LOG"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "DJANGO_ADMIN_LOG_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/
ALTER TABLE "DJANGO_ADMIN_LOG" ADD CONSTRAINT "DJANGO_AD_CONTENT_T_C4BCE8EB_F" FOREIGN KEY ("CONTENT_TYPE_ID") REFERENCES "DJANGO_CONTENT_TYPE" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "DJANGO_ADMIN_LOG" ADD CONSTRAINT "DJANGO_AD_USER_ID_C564EBA6_F" FOREIGN KEY ("USER_ID") REFERENCES "AUTH_USER" ("ID") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "DJANGO_ADM_CONTENT_TY_C4BCE8EB" ON "DJANGO_ADMIN_LOG" ("CONTENT_TYPE_ID");
CREATE INDEX "DJANGO_ADM_USER_ID_C564EBA6" ON "DJANGO_ADMIN_LOG" ("USER_ID");
COMMIT;


--
-- Change Meta options on contenttype
--
--
-- Alter field name on contenttype
--
--
-- MIGRATION NOW PERFORMS OPERATION THAT CANNOT BE WRITTEN AS SQL:
-- Raw Python operation
--
--
-- Remove field name from contenttype
--
ALTER TABLE "DJANGO_CONTENT_TYPE" DROP COLUMN "NAME";
COMMIT;


--
-- Alter field name on permission
--
ALTER TABLE "AUTH_PERMISSION" MODIFY "NAME" NVARCHAR2(255);
COMMIT;


--
-- Alter field email on user
--
ALTER TABLE "AUTH_USER" MODIFY "EMAIL" NVARCHAR2(254);
COMMIT;


--
-- Alter field last_login on user
--
ALTER TABLE "AUTH_USER" MODIFY "LAST_LOGIN" NULL;
COMMIT;


--
-- Alter field username on user
--
ALTER TABLE "AUTH_USER" MODIFY "USERNAME" NVARCHAR2(150);
COMMIT;


--
-- Create model Car
--
CREATE TABLE "PARKING_CAR" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "CAR_PICTURE" NVARCHAR2(100) NULL, "MODEL" NVARCHAR2(50) NULL);
CREATE TABLE "PARKING_CAR_OWNER" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "CAR_ID" NUMBER(11) NOT NULL, "USER_ID" NUMBER(11) NOT NULL);
--
-- Create model ParkingPlace
--
CREATE TABLE "PARKING_PARKINGPLACE" ("ID" NUMBER(11) NOT NULL PRIMARY KEY, "NAME" NVARCHAR2(155) NULL, "ADRESS" NVARCHAR2(155) NULL UNIQUE, "DESCRIPTION" NVARCHAR2(255) NULL, "BUSY_FROM" TIMESTAMP NULL, "BUSY_TO" TIMESTAMP NULL, "PRICE_PER_HOUR" NUMBER(11) NULL CHECK ("PRICE_PER_HOUR" >= 0), "CAR_PARKED_ID" NUMBER(11) NULL);

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'PARKING_CAR_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "PARKING_CAR_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "PARKING_CAR_TR"
BEFORE INSERT ON "PARKING_CAR"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "PARKING_CAR_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'PARKING_CAR_OWNER_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "PARKING_CAR_OWNER_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "PARKING_CAR_OWNER_TR"
BEFORE INSERT ON "PARKING_CAR_OWNER"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "PARKING_CAR_OWNER_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/
ALTER TABLE "PARKING_CAR_OWNER" ADD CONSTRAINT "PARKING_C_CAR_ID_E70F9662_F" FOREIGN KEY ("CAR_ID") REFERENCES "PARKING_CAR" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "PARKING_CAR_OWNER" ADD CONSTRAINT "PARKING_C_USER_ID_4EC0AE82_F" FOREIGN KEY ("USER_ID") REFERENCES "AUTH_USER" ("ID") DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE "PARKING_CAR_OWNER" ADD CONSTRAINT "PARKING_C_CAR_ID_US_895D273E_U" UNIQUE ("CAR_ID", "USER_ID");
CREATE INDEX "PARKING_CA_CAR_ID_E70F9662" ON "PARKING_CAR_OWNER" ("CAR_ID");
CREATE INDEX "PARKING_CA_USER_ID_4EC0AE82" ON "PARKING_CAR_OWNER" ("USER_ID");

DECLARE
    i INTEGER;
BEGIN
    SELECT COUNT(1) INTO i FROM USER_SEQUENCES
        WHERE SEQUENCE_NAME = 'PARKING_PARKINGPLACE_SQ';
    IF i = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SEQUENCE "PARKING_PARKINGPLACE_SQ"';
    END IF;
END;
/

CREATE OR REPLACE TRIGGER "PARKING_PARKINGPLACE_TR"
BEFORE INSERT ON "PARKING_PARKINGPLACE"
FOR EACH ROW
WHEN (new."ID" IS NULL)
    BEGIN
        SELECT "PARKING_PARKINGPLACE_SQ".nextval
        INTO :new."ID" FROM dual;
    END;
/
ALTER TABLE "PARKING_PARKINGPLACE" ADD CONSTRAINT "PARKING_P_CAR_PARKE_4F0A31D9_F" FOREIGN KEY ("CAR_PARKED_ID") REFERENCES "PARKING_CAR" ("ID") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "PARKING_PA_CAR_PARKED_4F0A31D9" ON "PARKING_PARKINGPLACE" ("CAR_PARKED_ID");
COMMIT;


--
-- Create model Session
--
CREATE TABLE "DJANGO_SESSION" ("SESSION_KEY" NVARCHAR2(40) NOT NULL PRIMARY KEY, "SESSION_DATA" NCLOB NULL, "EXPIRE_DATE" TIMESTAMP NOT NULL);
CREATE INDEX "DJANGO_SES_EXPIRE_DAT_A5C62663" ON "DJANGO_SESSION" ("EXPIRE_DATE");
COMMIT;

--
-- Customs
--
ALTER TABLE "AUTH_USER"
  ADD CONSTRAINT email_validator
  CHECK (REGEXP_LIKE (email, '[A-Za-z0-9._]+@[A-Za-z0-9._]+\.[A-Za-z]{2,10}'));

ALTER TABLE "AUTH_USER"
  ADD CONSTRAINT "f_n_validator"
    CHECK ( REGEXP_LIKE ("FIRST_NAME", '[A-Za-z ,-]{0,20}')); 

ALTER TABLE "AUTH_USER"
  ADD CONSTRAINT "l_n_validator"
    CHECK ( REGEXP_LIKE ("LAST", '[A-Za-z ,-]{0,20}')); 
    
ALTER TABLE "AUTH_USER"
  ADD CONSTRAINT "unique_email" UNIQUE ("EMAIL");
