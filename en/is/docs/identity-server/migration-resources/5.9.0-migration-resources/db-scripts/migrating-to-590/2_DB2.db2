
        CREATE TABLE FIDO2_DEVICE_STORE (
                  TENANT_ID INTEGER NOT NULL,
                  DOMAIN_NAME VARCHAR(255) NOT NULL,
                  USER_NAME VARCHAR(45) NOT NULL,
                  TIME_REGISTERED TIMESTAMP,
                  USER_HANDLE VARCHAR(64) NOT NULL,
                  CREDENTIAL_ID VARCHAR(200) NOT NULL,
                  PUBLIC_KEY_COSE VARCHAR(1024) NOT NULL,
                  SIGNATURE_COUNT BIGINT,
                  USER_IDENTITY VARCHAR(512) NOT NULL,
                PRIMARY KEY (CREDENTIAL_ID, USER_HANDLE))
        /
        
        CREATE TABLE IDN_AUTH_SESSION_APP_INFO (
                  SESSION_ID VARCHAR (100) NOT NULL,
                  SUBJECT VARCHAR (100) NOT NULL,
                  APP_ID INTEGER NOT NULL,
                  INBOUND_AUTH_TYPE VARCHAR (255) NOT NULL,
                PRIMARY KEY (SESSION_ID, SUBJECT, APP_ID, INBOUND_AUTH_TYPE)
        )
        /
        
        CREATE TABLE IDN_AUTH_SESSION_META_DATA (
                  SESSION_ID VARCHAR (100) NOT NULL,
                  PROPERTY_TYPE VARCHAR (100) NOT NULL,
                  VALUE VARCHAR (255) NOT NULL,
                PRIMARY KEY (SESSION_ID, PROPERTY_TYPE, VALUE)
        )
        /
        
        CREATE TABLE IDN_FUNCTION_LIBRARY (
                  NAME VARCHAR(255) NOT NULL,
                  DESCRIPTION VARCHAR(1023),
                  TYPE VARCHAR(255) NOT NULL,
                  TENANT_ID INTEGER NOT NULL,
                  DATA BLOB NOT NULL,
                PRIMARY KEY (TENANT_ID,NAME)
        )
        /
        
        CREATE INDEX IDX_FIDO2_STR ON FIDO2_DEVICE_STORE(USER_NAME, TENANT_ID, DOMAIN_NAME, CREDENTIAL_ID, USER_HANDLE)
        /
        