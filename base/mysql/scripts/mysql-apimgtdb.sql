create database apimgtdb;
use apimgtdb;
-- Start of IDENTITY Tables--
CREATE TABLE IF NOT EXISTS IDN_BASE_TABLE (
                                              PRODUCT_NAME VARCHAR(20),
                                              PRIMARY KEY (PRODUCT_NAME)
)ENGINE INNODB;

INSERT INTO IDN_BASE_TABLE values ('WSO2 Identity Server');

CREATE TABLE IF NOT EXISTS IDN_OAUTH_CONSUMER_APPS (
                                                       ID INTEGER NOT NULL AUTO_INCREMENT,
                                                       CONSUMER_KEY VARCHAR(255),
                                                       CONSUMER_SECRET VARCHAR(2048),
                                                       USERNAME VARCHAR(255),
                                                       TENANT_ID INTEGER DEFAULT 0,
                                                       USER_DOMAIN VARCHAR(50),
                                                       APP_NAME VARCHAR(255),
                                                       OAUTH_VERSION VARCHAR(128),
                                                       CALLBACK_URL VARCHAR(2048),
                                                       GRANT_TYPES VARCHAR (1024),
                                                       PKCE_MANDATORY CHAR(1) DEFAULT '0',
                                                       PKCE_SUPPORT_PLAIN CHAR(1) DEFAULT '0',
                                                       APP_STATE VARCHAR (25) DEFAULT 'ACTIVE',
                                                       USER_ACCESS_TOKEN_EXPIRE_TIME BIGINT DEFAULT 3600,
                                                       APP_ACCESS_TOKEN_EXPIRE_TIME BIGINT DEFAULT 3600,
                                                       REFRESH_TOKEN_EXPIRE_TIME BIGINT DEFAULT 84600,
                                                       ID_TOKEN_EXPIRE_TIME BIGINT DEFAULT 3600,
                                                       CONSTRAINT CONSUMER_KEY_CONSTRAINT UNIQUE (CONSUMER_KEY),
                                                       PRIMARY KEY (ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_SCOPE_VALIDATORS (
                                                           APP_ID INTEGER NOT NULL,
                                                           SCOPE_VALIDATOR VARCHAR (128) NOT NULL,
                                                           PRIMARY KEY (APP_ID,SCOPE_VALIDATOR),
                                                           FOREIGN KEY (APP_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_OAUTH1A_REQUEST_TOKEN (
                                                         REQUEST_TOKEN VARCHAR(255),
                                                         REQUEST_TOKEN_SECRET VARCHAR(512),
                                                         CONSUMER_KEY_ID INTEGER,
                                                         CALLBACK_URL VARCHAR(2048),
                                                         SCOPE VARCHAR(2048),
                                                         AUTHORIZED VARCHAR(128),
                                                         OAUTH_VERIFIER VARCHAR(512),
                                                         AUTHZ_USER VARCHAR(512),
                                                         TENANT_ID INTEGER DEFAULT -1,
                                                         PRIMARY KEY (REQUEST_TOKEN),
                                                         FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_OAUTH1A_ACCESS_TOKEN (
                                                        ACCESS_TOKEN VARCHAR(255),
                                                        ACCESS_TOKEN_SECRET VARCHAR(512),
                                                        CONSUMER_KEY_ID INTEGER,
                                                        SCOPE VARCHAR(2048),
                                                        AUTHZ_USER VARCHAR(512),
                                                        TENANT_ID INTEGER DEFAULT -1,
                                                        PRIMARY KEY (ACCESS_TOKEN),
                                                        FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_ACCESS_TOKEN (
                                                       TOKEN_ID VARCHAR (255),
                                                       ACCESS_TOKEN VARCHAR(2048),
                                                       REFRESH_TOKEN VARCHAR(2048),
                                                       CONSUMER_KEY_ID INTEGER,
                                                       AUTHZ_USER VARCHAR (100),
                                                       TENANT_ID INTEGER,
                                                       USER_DOMAIN VARCHAR(50),
                                                       USER_TYPE VARCHAR (25),
                                                       GRANT_TYPE VARCHAR (50),
                                                       TIME_CREATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                                       REFRESH_TOKEN_TIME_CREATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                                       VALIDITY_PERIOD BIGINT,
                                                       REFRESH_TOKEN_VALIDITY_PERIOD BIGINT,
                                                       TOKEN_SCOPE_HASH VARCHAR(32),
                                                       TOKEN_STATE VARCHAR(25) DEFAULT 'ACTIVE',
                                                       TOKEN_STATE_ID VARCHAR (128) DEFAULT 'NONE',
                                                       SUBJECT_IDENTIFIER VARCHAR(255),
                                                       ACCESS_TOKEN_HASH VARCHAR(512),
                                                       REFRESH_TOKEN_HASH VARCHAR(512),
                                                       IDP_ID INTEGER,
                                                       PRIMARY KEY (TOKEN_ID),
                                                       FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE,
                                                       CONSTRAINT CON_APP_KEY UNIQUE (CONSUMER_KEY_ID,AUTHZ_USER,TENANT_ID,USER_DOMAIN,USER_TYPE,TOKEN_SCOPE_HASH,
                                                                                      TOKEN_STATE,TOKEN_STATE_ID,IDP_ID)
)ENGINE INNODB;


CREATE TABLE IF NOT EXISTS IDN_OAUTH2_ACCESS_TOKEN_AUDIT (
                                                             TOKEN_ID VARCHAR (255),
                                                             ACCESS_TOKEN VARCHAR(2048),
                                                             REFRESH_TOKEN VARCHAR(2048),
                                                             CONSUMER_KEY_ID INTEGER,
                                                             AUTHZ_USER VARCHAR (100),
                                                             TENANT_ID INTEGER,
                                                             USER_DOMAIN VARCHAR(50),
                                                             USER_TYPE VARCHAR (25),
                                                             GRANT_TYPE VARCHAR (50),
                                                             TIME_CREATED TIMESTAMP NULL,
                                                             REFRESH_TOKEN_TIME_CREATED TIMESTAMP NULL,
                                                             VALIDITY_PERIOD BIGINT,
                                                             REFRESH_TOKEN_VALIDITY_PERIOD BIGINT,
                                                             TOKEN_SCOPE_HASH VARCHAR(32),
                                                             TOKEN_STATE VARCHAR(25),
                                                             TOKEN_STATE_ID VARCHAR (128) ,
                                                             SUBJECT_IDENTIFIER VARCHAR(255),
                                                             ACCESS_TOKEN_HASH VARCHAR(512),
                                                             REFRESH_TOKEN_HASH VARCHAR(512),
                                                             INVALIDATED_TIME TIMESTAMP NULL,
                                                             IDP_ID INTEGER
);

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_AUTHORIZATION_CODE (
                                                             CODE_ID VARCHAR (255),
                                                             AUTHORIZATION_CODE VARCHAR(2048),
                                                             CONSUMER_KEY_ID INTEGER,
                                                             CALLBACK_URL VARCHAR(2048),
                                                             SCOPE VARCHAR(2048),
                                                             AUTHZ_USER VARCHAR (100),
                                                             TENANT_ID INTEGER,
                                                             USER_DOMAIN VARCHAR(50),
                                                             TIME_CREATED TIMESTAMP,
                                                             VALIDITY_PERIOD BIGINT,
                                                             STATE VARCHAR (25) DEFAULT 'ACTIVE',
                                                             TOKEN_ID VARCHAR(255),
                                                             SUBJECT_IDENTIFIER VARCHAR(255),
                                                             PKCE_CODE_CHALLENGE VARCHAR(255),
                                                             PKCE_CODE_CHALLENGE_METHOD VARCHAR(128),
                                                             AUTHORIZATION_CODE_HASH VARCHAR(512),
                                                             IDP_ID INTEGER,
                                                             PRIMARY KEY (CODE_ID),
                                                             FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE
)ENGINE INNODB;




CREATE TABLE IF NOT EXISTS IDN_OAUTH2_ACCESS_TOKEN_SCOPE (
                                                             TOKEN_ID VARCHAR (255),
                                                             TOKEN_SCOPE VARCHAR (60),
                                                             TENANT_ID INTEGER DEFAULT -1,
                                                             PRIMARY KEY (TOKEN_ID, TOKEN_SCOPE),
                                                             FOREIGN KEY (TOKEN_ID) REFERENCES IDN_OAUTH2_ACCESS_TOKEN(TOKEN_ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_SCOPE (
                                                SCOPE_ID INTEGER NOT NULL AUTO_INCREMENT,
                                                NAME VARCHAR(255) NOT NULL,
                                                DISPLAY_NAME VARCHAR(255) NOT NULL,
                                                DESCRIPTION VARCHAR(512),
                                                TENANT_ID INTEGER NOT NULL DEFAULT -1,
                                                PRIMARY KEY (SCOPE_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_SCOPE_BINDING (
                                                        SCOPE_ID INTEGER NOT NULL,
                                                        SCOPE_BINDING VARCHAR(255),
                                                        FOREIGN KEY (SCOPE_ID) REFERENCES IDN_OAUTH2_SCOPE(SCOPE_ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_OAUTH2_RESOURCE_SCOPE (
                                                         RESOURCE_PATH VARCHAR(255) NOT NULL,
                                                         SCOPE_ID INTEGER NOT NULL,
                                                         TENANT_ID INTEGER DEFAULT -1,
                                                         PRIMARY KEY (RESOURCE_PATH),
                                                         FOREIGN KEY (SCOPE_ID) REFERENCES IDN_OAUTH2_SCOPE (SCOPE_ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_SCIM_GROUP (
                                              ID INTEGER AUTO_INCREMENT,
                                              TENANT_ID INTEGER NOT NULL,
                                              ROLE_NAME VARCHAR(255) NOT NULL,
                                              ATTR_NAME VARCHAR(1024) NOT NULL,
                                              ATTR_VALUE VARCHAR(1024),
                                              PRIMARY KEY (ID)
)ENGINE INNODB;



CREATE TABLE IF NOT EXISTS IDN_OPENID_REMEMBER_ME (
                                                      USER_NAME VARCHAR(255) NOT NULL,
                                                      TENANT_ID INTEGER DEFAULT 0,
                                                      COOKIE_VALUE VARCHAR(1024),
                                                      CREATED_TIME TIMESTAMP,
                                                      PRIMARY KEY (USER_NAME, TENANT_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_OPENID_USER_RPS (
                                                   USER_NAME VARCHAR(255) NOT NULL,
                                                   TENANT_ID INTEGER DEFAULT 0,
                                                   RP_URL VARCHAR(255) NOT NULL,
                                                   TRUSTED_ALWAYS VARCHAR(128) DEFAULT 'FALSE',
                                                   LAST_VISIT DATE NOT NULL,
                                                   VISIT_COUNT INTEGER DEFAULT 0,
                                                   DEFAULT_PROFILE_NAME VARCHAR(255) DEFAULT 'DEFAULT',
                                                   PRIMARY KEY (USER_NAME, TENANT_ID, RP_URL)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_OPENID_ASSOCIATIONS (
                                                       HANDLE VARCHAR(255) NOT NULL,
                                                       ASSOC_TYPE VARCHAR(255) NOT NULL,
                                                       EXPIRE_IN TIMESTAMP NOT NULL,
                                                       MAC_KEY VARCHAR(255) NOT NULL,
                                                       ASSOC_STORE VARCHAR(128) DEFAULT 'SHARED',
                                                       TENANT_ID INTEGER DEFAULT -1,
                                                       PRIMARY KEY (HANDLE)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_STS_STORE (
                                             ID INTEGER AUTO_INCREMENT,
                                             TOKEN_ID VARCHAR(255) NOT NULL,
                                             TOKEN_CONTENT BLOB(1024) NOT NULL,
                                             CREATE_DATE TIMESTAMP NOT NULL,
                                             EXPIRE_DATE TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                             STATE INTEGER DEFAULT 0,
                                             PRIMARY KEY (ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_IDENTITY_USER_DATA (
                                                      TENANT_ID INTEGER DEFAULT -1234,
                                                      USER_NAME VARCHAR(255) NOT NULL,
                                                      DATA_KEY VARCHAR(255) NOT NULL,
                                                      DATA_VALUE VARCHAR(2048),
                                                      PRIMARY KEY (TENANT_ID, USER_NAME, DATA_KEY)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_IDENTITY_META_DATA (
                                                      USER_NAME VARCHAR(255) NOT NULL,
                                                      TENANT_ID INTEGER DEFAULT -1234,
                                                      METADATA_TYPE VARCHAR(255) NOT NULL,
                                                      METADATA VARCHAR(255) NOT NULL,
                                                      VALID VARCHAR(255) NOT NULL,
                                                      PRIMARY KEY (TENANT_ID, USER_NAME, METADATA_TYPE,METADATA)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_THRIFT_SESSION (
                                                  SESSION_ID VARCHAR(255) NOT NULL,
                                                  USER_NAME VARCHAR(255) NOT NULL,
                                                  CREATED_TIME VARCHAR(255) NOT NULL,
                                                  LAST_MODIFIED_TIME VARCHAR(255) NOT NULL,
                                                  TENANT_ID INTEGER DEFAULT -1,
                                                  PRIMARY KEY (SESSION_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_AUTH_SESSION_STORE (
                                                      SESSION_ID VARCHAR (100) NOT NULL,
                                                      SESSION_TYPE VARCHAR(100) NOT NULL,
                                                      OPERATION VARCHAR(10) NOT NULL,
                                                      SESSION_OBJECT BLOB,
                                                      TIME_CREATED BIGINT,
                                                      TENANT_ID INTEGER DEFAULT -1,
                                                      EXPIRY_TIME BIGINT,
                                                      PRIMARY KEY (SESSION_ID, SESSION_TYPE, TIME_CREATED, OPERATION)
)ENGINE INNODB;




CREATE TABLE IF NOT EXISTS IDN_AUTH_TEMP_SESSION_STORE (
                                                           SESSION_ID VARCHAR (100) NOT NULL,
                                                           SESSION_TYPE VARCHAR(100) NOT NULL,
                                                           OPERATION VARCHAR(10) NOT NULL,
                                                           SESSION_OBJECT BLOB,
                                                           TIME_CREATED BIGINT,
                                                           TENANT_ID INTEGER DEFAULT -1,
                                                           EXPIRY_TIME BIGINT,
                                                           PRIMARY KEY (SESSION_ID, SESSION_TYPE, TIME_CREATED, OPERATION)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_AUTH_USER (
                                             USER_ID VARCHAR(255) NOT NULL,
                                             USER_NAME VARCHAR(255) NOT NULL,
                                             TENANT_ID INTEGER NOT NULL,
                                             DOMAIN_NAME VARCHAR(255) NOT NULL,
                                             IDP_ID INTEGER NOT NULL,
                                             PRIMARY KEY (USER_ID),
                                             CONSTRAINT USER_STORE_CONSTRAINT UNIQUE (USER_NAME, TENANT_ID, DOMAIN_NAME, IDP_ID));

CREATE TABLE IF NOT EXISTS IDN_AUTH_USER_SESSION_MAPPING (
                                                             USER_ID VARCHAR(255) NOT NULL,
                                                             SESSION_ID VARCHAR(255) NOT NULL,
                                                             CONSTRAINT USER_SESSION_STORE_CONSTRAINT UNIQUE (USER_ID, SESSION_ID));

CREATE TABLE IF NOT EXISTS IDN_AUTH_SESSION_APP_INFO (
                                                         SESSION_ID VARCHAR (100) NOT NULL,
                                                         SUBJECT VARCHAR (100) NOT NULL,
                                                         APP_ID INTEGER NOT NULL,
                                                         INBOUND_AUTH_TYPE VARCHAR (255) NOT NULL,
                                                         PRIMARY KEY (SESSION_ID, SUBJECT, APP_ID, INBOUND_AUTH_TYPE)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_AUTH_SESSION_META_DATA (
                                                          SESSION_ID VARCHAR (100) NOT NULL,
                                                          PROPERTY_TYPE VARCHAR (100) NOT NULL,
                                                          VALUE VARCHAR (255) NOT NULL,
                                                          PRIMARY KEY (SESSION_ID, PROPERTY_TYPE, VALUE)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS SP_APP (
                                      ID INTEGER NOT NULL AUTO_INCREMENT,
                                      TENANT_ID INTEGER NOT NULL,
                                      APP_NAME VARCHAR (255) NOT NULL ,
                                      USER_STORE VARCHAR (255) NOT NULL,
                                      USERNAME VARCHAR (255) NOT NULL ,
                                      DESCRIPTION VARCHAR (1024),
                                      ROLE_CLAIM VARCHAR (512),
                                      AUTH_TYPE VARCHAR (255) NOT NULL,
                                      PROVISIONING_USERSTORE_DOMAIN VARCHAR (512),
                                      IS_LOCAL_CLAIM_DIALECT CHAR(1) DEFAULT '1',
                                      IS_SEND_LOCAL_SUBJECT_ID CHAR(1) DEFAULT '0',
                                      IS_SEND_AUTH_LIST_OF_IDPS CHAR(1) DEFAULT '0',
                                      IS_USE_TENANT_DOMAIN_SUBJECT CHAR(1) DEFAULT '1',
                                      IS_USE_USER_DOMAIN_SUBJECT CHAR(1) DEFAULT '1',
                                      ENABLE_AUTHORIZATION CHAR(1) DEFAULT '0',
                                      SUBJECT_CLAIM_URI VARCHAR (512),
                                      IS_SAAS_APP CHAR(1) DEFAULT '0',
                                      IS_DUMB_MODE CHAR(1) DEFAULT '0',
                                      PRIMARY KEY (ID)
)ENGINE INNODB;

ALTER TABLE SP_APP ADD CONSTRAINT APPLICATION_NAME_CONSTRAINT UNIQUE(APP_NAME, TENANT_ID);

CREATE TABLE IF NOT EXISTS SP_METADATA (
                                           ID INTEGER AUTO_INCREMENT,
                                           SP_ID INTEGER,
                                           NAME VARCHAR(255) NOT NULL,
                                           VALUE VARCHAR(255) NOT NULL,
                                           DISPLAY_NAME VARCHAR(255),
                                           TENANT_ID INTEGER DEFAULT -1,
                                           PRIMARY KEY (ID),
                                           CONSTRAINT SP_METADATA_CONSTRAINT UNIQUE (SP_ID, NAME),
                                           FOREIGN KEY (SP_ID) REFERENCES SP_APP(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS SP_INBOUND_AUTH (
                                               ID INTEGER NOT NULL AUTO_INCREMENT,
                                               TENANT_ID INTEGER NOT NULL,
                                               INBOUND_AUTH_KEY VARCHAR (255),
                                               INBOUND_AUTH_TYPE VARCHAR (255) NOT NULL,
                                               INBOUND_CONFIG_TYPE VARCHAR (255) NOT NULL,
                                               PROP_NAME VARCHAR (255),
                                               PROP_VALUE VARCHAR (1024) ,
                                               APP_ID INTEGER NOT NULL,
                                               PRIMARY KEY (ID)
)ENGINE INNODB;

ALTER TABLE SP_INBOUND_AUTH ADD CONSTRAINT APPLICATION_ID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS SP_AUTH_STEP (
                                            ID INTEGER NOT NULL AUTO_INCREMENT,
                                            TENANT_ID INTEGER NOT NULL,
                                            STEP_ORDER INTEGER DEFAULT 1,
                                            APP_ID INTEGER NOT NULL ,
                                            IS_SUBJECT_STEP CHAR(1) DEFAULT '0',
                                            IS_ATTRIBUTE_STEP CHAR(1) DEFAULT '0',
                                            PRIMARY KEY (ID)
)ENGINE INNODB;

ALTER TABLE SP_AUTH_STEP ADD CONSTRAINT APPLICATION_ID_CONSTRAINT_STEP FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS SP_FEDERATED_IDP (
                                                ID INTEGER NOT NULL,
                                                TENANT_ID INTEGER NOT NULL,
                                                AUTHENTICATOR_ID INTEGER NOT NULL,
                                                PRIMARY KEY (ID, AUTHENTICATOR_ID)
)ENGINE INNODB;

ALTER TABLE SP_FEDERATED_IDP ADD CONSTRAINT STEP_ID_CONSTRAINT FOREIGN KEY (ID) REFERENCES SP_AUTH_STEP (ID) ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS SP_CLAIM_DIALECT (
                                                ID INTEGER NOT NULL AUTO_INCREMENT,
                                                TENANT_ID INTEGER NOT NULL,
                                                SP_DIALECT VARCHAR (512) NOT NULL,
                                                APP_ID INTEGER NOT NULL,
                                                PRIMARY KEY (ID));

ALTER TABLE SP_CLAIM_DIALECT ADD CONSTRAINT DIALECTID_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS SP_CLAIM_MAPPING (
                                                ID INTEGER NOT NULL AUTO_INCREMENT,
                                                TENANT_ID INTEGER NOT NULL,
                                                IDP_CLAIM VARCHAR (512) NOT NULL ,
                                                SP_CLAIM VARCHAR (512) NOT NULL ,
                                                APP_ID INTEGER NOT NULL,
                                                IS_REQUESTED VARCHAR(128) DEFAULT '0',
                                                IS_MANDATORY VARCHAR(128) DEFAULT '0',
                                                DEFAULT_VALUE VARCHAR(255),
                                                PRIMARY KEY (ID)
)ENGINE INNODB;

ALTER TABLE SP_CLAIM_MAPPING ADD CONSTRAINT CLAIMID_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS SP_ROLE_MAPPING (
                                               ID INTEGER NOT NULL AUTO_INCREMENT,
                                               TENANT_ID INTEGER NOT NULL,
                                               IDP_ROLE VARCHAR (255) NOT NULL ,
                                               SP_ROLE VARCHAR (255) NOT NULL ,
                                               APP_ID INTEGER NOT NULL,
                                               PRIMARY KEY (ID)
)ENGINE INNODB;

ALTER TABLE SP_ROLE_MAPPING ADD CONSTRAINT ROLEID_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS SP_REQ_PATH_AUTHENTICATOR (
                                                         ID INTEGER NOT NULL AUTO_INCREMENT,
                                                         TENANT_ID INTEGER NOT NULL,
                                                         AUTHENTICATOR_NAME VARCHAR (255) NOT NULL ,
                                                         APP_ID INTEGER NOT NULL,
                                                         PRIMARY KEY (ID)
)ENGINE INNODB;

ALTER TABLE SP_REQ_PATH_AUTHENTICATOR ADD CONSTRAINT REQ_AUTH_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS SP_PROVISIONING_CONNECTOR (
                                                         ID INTEGER NOT NULL AUTO_INCREMENT,
                                                         TENANT_ID INTEGER NOT NULL,
                                                         IDP_NAME VARCHAR (255) NOT NULL ,
                                                         CONNECTOR_NAME VARCHAR (255) NOT NULL ,
                                                         APP_ID INTEGER NOT NULL,
                                                         IS_JIT_ENABLED CHAR(1) NOT NULL DEFAULT '0',
                                                         BLOCKING CHAR(1) NOT NULL DEFAULT '0',
                                                         RULE_ENABLED CHAR(1) NOT NULL DEFAULT '0',
                                                         PRIMARY KEY (ID)
)ENGINE INNODB;

ALTER TABLE SP_PROVISIONING_CONNECTOR ADD CONSTRAINT PRO_CONNECTOR_APPID_CONSTRAINT FOREIGN KEY (APP_ID) REFERENCES SP_APP (ID) ON DELETE CASCADE;

CREATE TABLE SP_AUTH_SCRIPT (
                                ID         INTEGER AUTO_INCREMENT NOT NULL,
                                TENANT_ID  INTEGER                NOT NULL,
                                APP_ID     INTEGER                NOT NULL,
                                TYPE       VARCHAR(255)           NOT NULL,
                                CONTENT    BLOB    DEFAULT NULL,
                                IS_ENABLED CHAR(1) NOT NULL DEFAULT '0',
                                PRIMARY KEY (ID));

CREATE TABLE IF NOT EXISTS SP_TEMPLATE (
                                           ID         INTEGER AUTO_INCREMENT NOT NULL,
                                           TENANT_ID  INTEGER                NOT NULL,
                                           NAME VARCHAR(255) NOT NULL,
                                           DESCRIPTION VARCHAR(1023),
                                           CONTENT BLOB DEFAULT NULL,
                                           PRIMARY KEY (ID),
                                           CONSTRAINT SP_TEMPLATE_CONSTRAINT UNIQUE (TENANT_ID, NAME));

CREATE TABLE IF NOT EXISTS IDN_ARTIFACT_STORE (
                                                  ID          VARCHAR(255)           NOT NULL,
                                                  TENANT_ID   INTEGER                NOT NULL,
                                                  ARTIFACT    BLOB                   DEFAULT NULL,
                                                  IDENTIFIER  VARCHAR(255)           NOT NULL,
                                                  ARTIFACT_TYPE       VARCHAR(255)   NOT NULL,
                                                  CONTENT_TYPE        VARCHAR(255)   DEFAULT NULL,
                                                  PRIMARY KEY (ID),
                                                  UNIQUE (IDENTIFIER , ARTIFACT_TYPE )
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_AUTH_WAIT_STATUS (
                                                    ID              INTEGER AUTO_INCREMENT NOT NULL,
                                                    TENANT_ID       INTEGER                NOT NULL,
                                                    LONG_WAIT_KEY   VARCHAR(255)           NOT NULL,
                                                    WAIT_STATUS     CHAR(1) NOT NULL DEFAULT '1',
                                                    TIME_CREATED    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                                    EXPIRE_TIME     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                                    PRIMARY KEY (ID),
                                                    CONSTRAINT IDN_AUTH_WAIT_STATUS_KEY UNIQUE (LONG_WAIT_KEY));

CREATE TABLE IF NOT EXISTS IDP (
                                   ID INTEGER AUTO_INCREMENT,
                                   TENANT_ID INTEGER,
                                   NAME VARCHAR(254) NOT NULL,
                                   IS_ENABLED CHAR(1) NOT NULL DEFAULT '1',
                                   IS_PRIMARY CHAR(1) NOT NULL DEFAULT '0',
                                   HOME_REALM_ID VARCHAR(254),
                                   IMAGE MEDIUMBLOB,
                                   CERTIFICATE BLOB,
                                   ALIAS VARCHAR(254),
                                   INBOUND_PROV_ENABLED CHAR (1) NOT NULL DEFAULT '0',
                                   INBOUND_PROV_USER_STORE_ID VARCHAR(254),
                                   USER_CLAIM_URI VARCHAR(254),
                                   ROLE_CLAIM_URI VARCHAR(254),
                                   DESCRIPTION VARCHAR (1024),
                                   DEFAULT_AUTHENTICATOR_NAME VARCHAR(254),
                                   DEFAULT_PRO_CONNECTOR_NAME VARCHAR(254),
                                   PROVISIONING_ROLE VARCHAR(128),
                                   IS_FEDERATION_HUB CHAR(1) NOT NULL DEFAULT '0',
                                   IS_LOCAL_CLAIM_DIALECT CHAR(1) NOT NULL DEFAULT '0',
                                   DISPLAY_NAME VARCHAR(255),
                                   PRIMARY KEY (ID),
                                   UNIQUE (TENANT_ID, NAME)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDP_ROLE (
                                        ID INTEGER AUTO_INCREMENT,
                                        IDP_ID INTEGER,
                                        TENANT_ID INTEGER,
                                        ROLE VARCHAR(254),
                                        PRIMARY KEY (ID),
                                        UNIQUE (IDP_ID, ROLE),
                                        FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDP_ROLE_MAPPING (
                                                ID INTEGER AUTO_INCREMENT,
                                                IDP_ROLE_ID INTEGER,
                                                TENANT_ID INTEGER,
                                                USER_STORE_ID VARCHAR (253),
                                                LOCAL_ROLE VARCHAR(253),
                                                PRIMARY KEY (ID),
                                                UNIQUE (IDP_ROLE_ID, TENANT_ID, USER_STORE_ID, LOCAL_ROLE),
                                                FOREIGN KEY (IDP_ROLE_ID) REFERENCES IDP_ROLE(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDP_CLAIM (
                                         ID INTEGER AUTO_INCREMENT,
                                         IDP_ID INTEGER,
                                         TENANT_ID INTEGER,
                                         CLAIM VARCHAR(254),
                                         PRIMARY KEY (ID),
                                         UNIQUE (IDP_ID, CLAIM),
                                         FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDP_CLAIM_MAPPING (
                                                 ID INTEGER AUTO_INCREMENT,
                                                 IDP_CLAIM_ID INTEGER,
                                                 TENANT_ID INTEGER,
                                                 LOCAL_CLAIM VARCHAR(253),
                                                 DEFAULT_VALUE VARCHAR(255),
                                                 IS_REQUESTED VARCHAR(128) DEFAULT '0',
                                                 PRIMARY KEY (ID),
                                                 UNIQUE (IDP_CLAIM_ID, TENANT_ID, LOCAL_CLAIM),
                                                 FOREIGN KEY (IDP_CLAIM_ID) REFERENCES IDP_CLAIM(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDP_AUTHENTICATOR (
                                                 ID INTEGER AUTO_INCREMENT,
                                                 TENANT_ID INTEGER,
                                                 IDP_ID INTEGER,
                                                 NAME VARCHAR(255) NOT NULL,
                                                 IS_ENABLED CHAR (1) DEFAULT '1',
                                                 DISPLAY_NAME VARCHAR(255),
                                                 PRIMARY KEY (ID),
                                                 UNIQUE (TENANT_ID, IDP_ID, NAME),
                                                 FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDP_METADATA (
                                            ID INTEGER AUTO_INCREMENT,
                                            IDP_ID INTEGER,
                                            NAME VARCHAR(255) NOT NULL,
                                            VALUE VARCHAR(255) NOT NULL,
                                            DISPLAY_NAME VARCHAR(255),
                                            TENANT_ID INTEGER DEFAULT -1,
                                            PRIMARY KEY (ID),
                                            CONSTRAINT IDP_METADATA_CONSTRAINT UNIQUE (IDP_ID, NAME),
                                            FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDP_AUTHENTICATOR_PROPERTY (
                                                          ID INTEGER AUTO_INCREMENT,
                                                          TENANT_ID INTEGER,
                                                          AUTHENTICATOR_ID INTEGER,
                                                          PROPERTY_KEY VARCHAR(255) NOT NULL,
                                                          PROPERTY_VALUE VARCHAR(2047),
                                                          IS_SECRET CHAR (1) DEFAULT '0',
                                                          PRIMARY KEY (ID),
                                                          UNIQUE (TENANT_ID, AUTHENTICATOR_ID, PROPERTY_KEY),
                                                          FOREIGN KEY (AUTHENTICATOR_ID) REFERENCES IDP_AUTHENTICATOR(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDP_PROVISIONING_CONFIG (
                                                       ID INTEGER AUTO_INCREMENT,
                                                       TENANT_ID INTEGER,
                                                       IDP_ID INTEGER,
                                                       PROVISIONING_CONNECTOR_TYPE VARCHAR(255) NOT NULL,
                                                       IS_ENABLED CHAR (1) DEFAULT '0',
                                                       IS_BLOCKING CHAR (1) DEFAULT '0',
                                                       IS_RULES_ENABLED CHAR (1) DEFAULT '0',
                                                       PRIMARY KEY (ID),
                                                       UNIQUE (TENANT_ID, IDP_ID, PROVISIONING_CONNECTOR_TYPE),
                                                       FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDP_PROV_CONFIG_PROPERTY (
                                                        ID INTEGER AUTO_INCREMENT,
                                                        TENANT_ID INTEGER,
                                                        PROVISIONING_CONFIG_ID INTEGER,
                                                        PROPERTY_KEY VARCHAR(255) NOT NULL,
                                                        PROPERTY_VALUE VARCHAR(2048),
                                                        PROPERTY_BLOB_VALUE BLOB,
                                                        PROPERTY_TYPE CHAR(32) NOT NULL,
                                                        IS_SECRET CHAR (1) DEFAULT '0',
                                                        PRIMARY KEY (ID),
                                                        UNIQUE (TENANT_ID, PROVISIONING_CONFIG_ID, PROPERTY_KEY),
                                                        FOREIGN KEY (PROVISIONING_CONFIG_ID) REFERENCES IDP_PROVISIONING_CONFIG(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDP_PROVISIONING_ENTITY (
                                                       ID INTEGER AUTO_INCREMENT,
                                                       PROVISIONING_CONFIG_ID INTEGER,
                                                       ENTITY_TYPE VARCHAR(255) NOT NULL,
                                                       ENTITY_LOCAL_USERSTORE VARCHAR(255) NOT NULL,
                                                       ENTITY_NAME VARCHAR(255) NOT NULL,
                                                       ENTITY_VALUE VARCHAR(255),
                                                       TENANT_ID INTEGER,
                                                       ENTITY_LOCAL_ID VARCHAR(255),
                                                       PRIMARY KEY (ID),
                                                       UNIQUE (ENTITY_TYPE, TENANT_ID, ENTITY_LOCAL_USERSTORE, ENTITY_NAME, PROVISIONING_CONFIG_ID),
                                                       UNIQUE (PROVISIONING_CONFIG_ID, ENTITY_TYPE, ENTITY_VALUE),
                                                       FOREIGN KEY (PROVISIONING_CONFIG_ID) REFERENCES IDP_PROVISIONING_CONFIG(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDP_LOCAL_CLAIM (
                                               ID INTEGER AUTO_INCREMENT,
                                               TENANT_ID INTEGER,
                                               IDP_ID INTEGER,
                                               CLAIM_URI VARCHAR(255) NOT NULL,
                                               DEFAULT_VALUE VARCHAR(255),
                                               IS_REQUESTED VARCHAR(128) DEFAULT '0',
                                               PRIMARY KEY (ID),
                                               UNIQUE (TENANT_ID, IDP_ID, CLAIM_URI),
                                               FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_ASSOCIATED_ID (
                                                 ID INTEGER AUTO_INCREMENT,
                                                 IDP_USER_ID VARCHAR(255) NOT NULL,
                                                 TENANT_ID INTEGER DEFAULT -1234,
                                                 IDP_ID INTEGER NOT NULL,
                                                 DOMAIN_NAME VARCHAR(255) NOT NULL,
                                                 USER_NAME VARCHAR(255) NOT NULL,
                                                 PRIMARY KEY (ID),
                                                 UNIQUE(IDP_USER_ID, TENANT_ID, IDP_ID),
                                                 FOREIGN KEY (IDP_ID) REFERENCES IDP(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_USER_ACCOUNT_ASSOCIATION (
                                                            ASSOCIATION_KEY VARCHAR(255) NOT NULL,
                                                            TENANT_ID INTEGER,
                                                            DOMAIN_NAME VARCHAR(255) NOT NULL,
                                                            USER_NAME VARCHAR(255) NOT NULL,
                                                            PRIMARY KEY (TENANT_ID, DOMAIN_NAME, USER_NAME)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS FIDO_DEVICE_STORE (
                                                 TENANT_ID INTEGER,
                                                 DOMAIN_NAME VARCHAR(255) NOT NULL,
                                                 USER_NAME VARCHAR(45) NOT NULL,
                                                 TIME_REGISTERED TIMESTAMP,
                                                 KEY_HANDLE VARCHAR(200) NOT NULL,
                                                 DEVICE_DATA VARCHAR(2048) NOT NULL,
                                                 PRIMARY KEY (TENANT_ID, DOMAIN_NAME, USER_NAME, KEY_HANDLE)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS FIDO2_DEVICE_STORE (
                                                  TENANT_ID INTEGER,
                                                  DOMAIN_NAME VARCHAR(255) NOT NULL,
                                                  USER_NAME VARCHAR(45) NOT NULL,
                                                  TIME_REGISTERED TIMESTAMP,
                                                  USER_HANDLE VARCHAR(64) NOT NULL,
                                                  CREDENTIAL_ID VARCHAR(200) NOT NULL,
                                                  PUBLIC_KEY_COSE VARCHAR(1024) NOT NULL,
                                                  SIGNATURE_COUNT BIGINT,
                                                  USER_IDENTITY VARCHAR(512) NOT NULL,
                                                  PRIMARY KEY (CREDENTIAL_ID, USER_HANDLE)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS WF_REQUEST (
                                          UUID VARCHAR (45),
                                          CREATED_BY VARCHAR (255),
                                          TENANT_ID INTEGER DEFAULT -1,
                                          OPERATION_TYPE VARCHAR (50),
                                          CREATED_AT TIMESTAMP,
                                          UPDATED_AT TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                          STATUS VARCHAR (30),
                                          REQUEST BLOB,
                                          PRIMARY KEY (UUID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS WF_BPS_PROFILE (
                                              PROFILE_NAME VARCHAR(45),
                                              HOST_URL_MANAGER VARCHAR(255),
                                              HOST_URL_WORKER VARCHAR(255),
                                              USERNAME VARCHAR(45),
                                              PASSWORD VARCHAR(1023),
                                              CALLBACK_HOST VARCHAR (45),
                                              CALLBACK_USERNAME VARCHAR (45),
                                              CALLBACK_PASSWORD VARCHAR (255),
                                              TENANT_ID INTEGER DEFAULT -1,
                                              PRIMARY KEY (PROFILE_NAME, TENANT_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS WF_WORKFLOW(
                                          ID VARCHAR (45),
                                          WF_NAME VARCHAR (45),
                                          DESCRIPTION VARCHAR (255),
                                          TEMPLATE_ID VARCHAR (45),
                                          IMPL_ID VARCHAR (45),
                                          TENANT_ID INTEGER DEFAULT -1,
                                          PRIMARY KEY (ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS WF_WORKFLOW_ASSOCIATION(
                                                      ID INTEGER NOT NULL AUTO_INCREMENT,
                                                      ASSOC_NAME VARCHAR (45),
                                                      EVENT_ID VARCHAR(45),
                                                      ASSOC_CONDITION VARCHAR (2000),
                                                      WORKFLOW_ID VARCHAR (45),
                                                      IS_ENABLED CHAR (1) DEFAULT '1',
                                                      TENANT_ID INTEGER DEFAULT -1,
                                                      PRIMARY KEY(ID),
                                                      FOREIGN KEY (WORKFLOW_ID) REFERENCES WF_WORKFLOW(ID)ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS WF_WORKFLOW_CONFIG_PARAM(
                                                       WORKFLOW_ID VARCHAR (45),
                                                       PARAM_NAME VARCHAR (45),
                                                       PARAM_VALUE VARCHAR (1000),
                                                       PARAM_QNAME VARCHAR (45),
                                                       PARAM_HOLDER VARCHAR (45),
                                                       TENANT_ID INTEGER DEFAULT -1,
                                                       PRIMARY KEY (WORKFLOW_ID, PARAM_NAME, PARAM_QNAME, PARAM_HOLDER),
                                                       FOREIGN KEY (WORKFLOW_ID) REFERENCES WF_WORKFLOW(ID)ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS WF_REQUEST_ENTITY_RELATIONSHIP(
                                                             REQUEST_ID VARCHAR (45),
                                                             ENTITY_NAME VARCHAR (255),
                                                             ENTITY_TYPE VARCHAR (50),
                                                             TENANT_ID INTEGER DEFAULT -1,
                                                             PRIMARY KEY(REQUEST_ID, ENTITY_NAME, ENTITY_TYPE, TENANT_ID),
                                                             FOREIGN KEY (REQUEST_ID) REFERENCES WF_REQUEST(UUID)ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS WF_WORKFLOW_REQUEST_RELATION(
                                                           RELATIONSHIP_ID VARCHAR (45),
                                                           WORKFLOW_ID VARCHAR (45),
                                                           REQUEST_ID VARCHAR (45),
                                                           UPDATED_AT TIMESTAMP,
                                                           STATUS VARCHAR (30),
                                                           TENANT_ID INTEGER DEFAULT -1,
                                                           PRIMARY KEY (RELATIONSHIP_ID),
                                                           FOREIGN KEY (WORKFLOW_ID) REFERENCES WF_WORKFLOW(ID)ON DELETE CASCADE,
                                                           FOREIGN KEY (REQUEST_ID) REFERENCES WF_REQUEST(UUID)ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_RECOVERY_DATA (
                                                 USER_NAME VARCHAR(255) NOT NULL,
                                                 USER_DOMAIN VARCHAR(127) NOT NULL,
                                                 TENANT_ID INTEGER DEFAULT -1,
                                                 CODE VARCHAR(255) NOT NULL,
                                                 SCENARIO VARCHAR(255) NOT NULL,
                                                 STEP VARCHAR(127) NOT NULL,
                                                 TIME_CREATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                                 REMAINING_SETS VARCHAR(2500) DEFAULT NULL,
                                                 PRIMARY KEY(USER_NAME, USER_DOMAIN, TENANT_ID, SCENARIO,STEP),
                                                 UNIQUE(CODE)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_PASSWORD_HISTORY_DATA (
                                                         ID INTEGER NOT NULL AUTO_INCREMENT,
                                                         USER_NAME   VARCHAR(127) NOT NULL,
                                                         USER_DOMAIN VARCHAR(50) NOT NULL,
                                                         TENANT_ID   INTEGER DEFAULT -1,
                                                         SALT_VALUE  VARCHAR(255),
                                                         HASH        VARCHAR(255) NOT NULL,
                                                         TIME_CREATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                                         PRIMARY KEY(ID),
                                                         UNIQUE (USER_NAME,USER_DOMAIN,TENANT_ID,SALT_VALUE,HASH)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_CLAIM_DIALECT (
                                                 ID INTEGER NOT NULL AUTO_INCREMENT,
                                                 DIALECT_URI VARCHAR (255) NOT NULL,
                                                 TENANT_ID INTEGER NOT NULL,
                                                 PRIMARY KEY (ID),
                                                 CONSTRAINT DIALECT_URI_CONSTRAINT UNIQUE (DIALECT_URI, TENANT_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_CLAIM (
                                         ID INTEGER NOT NULL AUTO_INCREMENT,
                                         DIALECT_ID INTEGER,
                                         CLAIM_URI VARCHAR (255) NOT NULL,
                                         TENANT_ID INTEGER NOT NULL,
                                         PRIMARY KEY (ID),
                                         FOREIGN KEY (DIALECT_ID) REFERENCES IDN_CLAIM_DIALECT(ID) ON DELETE CASCADE,
                                         CONSTRAINT CLAIM_URI_CONSTRAINT UNIQUE (DIALECT_ID, CLAIM_URI, TENANT_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_CLAIM_MAPPED_ATTRIBUTE (
                                                          ID INTEGER NOT NULL AUTO_INCREMENT,
                                                          LOCAL_CLAIM_ID INTEGER,
                                                          USER_STORE_DOMAIN_NAME VARCHAR (255) NOT NULL,
                                                          ATTRIBUTE_NAME VARCHAR (255) NOT NULL,
                                                          TENANT_ID INTEGER NOT NULL,
                                                          PRIMARY KEY (ID),
                                                          FOREIGN KEY (LOCAL_CLAIM_ID) REFERENCES IDN_CLAIM(ID) ON DELETE CASCADE,
                                                          CONSTRAINT USER_STORE_DOMAIN_CONSTRAINT UNIQUE (LOCAL_CLAIM_ID, USER_STORE_DOMAIN_NAME, TENANT_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_CLAIM_PROPERTY (
                                                  ID INTEGER NOT NULL AUTO_INCREMENT,
                                                  LOCAL_CLAIM_ID INTEGER,
                                                  PROPERTY_NAME VARCHAR (255) NOT NULL,
                                                  PROPERTY_VALUE VARCHAR (255) NOT NULL,
                                                  TENANT_ID INTEGER NOT NULL,
                                                  PRIMARY KEY (ID),
                                                  FOREIGN KEY (LOCAL_CLAIM_ID) REFERENCES IDN_CLAIM(ID) ON DELETE CASCADE,
                                                  CONSTRAINT PROPERTY_NAME_CONSTRAINT UNIQUE (LOCAL_CLAIM_ID, PROPERTY_NAME, TENANT_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_CLAIM_MAPPING (
                                                 ID INTEGER NOT NULL AUTO_INCREMENT,
                                                 EXT_CLAIM_ID INTEGER NOT NULL,
                                                 MAPPED_LOCAL_CLAIM_ID INTEGER NOT NULL,
                                                 TENANT_ID INTEGER NOT NULL,
                                                 PRIMARY KEY (ID),
                                                 FOREIGN KEY (EXT_CLAIM_ID) REFERENCES IDN_CLAIM(ID) ON DELETE CASCADE,
                                                 FOREIGN KEY (MAPPED_LOCAL_CLAIM_ID) REFERENCES IDN_CLAIM(ID) ON DELETE CASCADE,
                                                 CONSTRAINT EXT_TO_LOC_MAPPING_CONSTRN UNIQUE (EXT_CLAIM_ID, TENANT_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS  IDN_SAML2_ASSERTION_STORE (
                                                          ID INTEGER NOT NULL AUTO_INCREMENT,
                                                          SAML2_ID  VARCHAR(255) ,
                                                          SAML2_ISSUER  VARCHAR(255) ,
                                                          SAML2_SUBJECT  VARCHAR(255) ,
                                                          SAML2_SESSION_INDEX  VARCHAR(255) ,
                                                          SAML2_AUTHN_CONTEXT_CLASS_REF  VARCHAR(255) ,
                                                          SAML2_ASSERTION  VARCHAR(4096) ,
                                                          ASSERTION BLOB ,
                                                          PRIMARY KEY (ID)
)ENGINE INNODB;

CREATE TABLE IDN_SAML2_ARTIFACT_STORE (
                                          ID INT(11) NOT NULL AUTO_INCREMENT,
                                          SOURCE_ID VARCHAR(255) NOT NULL,
                                          MESSAGE_HANDLER VARCHAR(255) NOT NULL,
                                          AUTHN_REQ_DTO BLOB NOT NULL,
                                          SESSION_ID VARCHAR(255) NOT NULL,
                                          EXP_TIMESTAMP TIMESTAMP NOT NULL,
                                          INIT_TIMESTAMP TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                          ASSERTION_ID VARCHAR(255),
                                          PRIMARY KEY (`ID`)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_OIDC_JTI (
                                            JWT_ID VARCHAR(255) NOT NULL,
                                            EXP_TIME TIMESTAMP NOT NULL ,
                                            TIME_CREATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ,
                                            PRIMARY KEY (JWT_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS  IDN_OIDC_PROPERTY (
                                                  ID INTEGER NOT NULL AUTO_INCREMENT,
                                                  TENANT_ID  INTEGER,
                                                  CONSUMER_KEY  VARCHAR(255) ,
                                                  PROPERTY_KEY  VARCHAR(255) NOT NULL,
                                                  PROPERTY_VALUE  VARCHAR(2047) ,
                                                  PRIMARY KEY (ID),
                                                  FOREIGN KEY (CONSUMER_KEY) REFERENCES IDN_OAUTH_CONSUMER_APPS(CONSUMER_KEY) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_OIDC_REQ_OBJECT_REFERENCE (
                                                             ID INTEGER NOT NULL AUTO_INCREMENT,
                                                             CONSUMER_KEY_ID INTEGER ,
                                                             CODE_ID VARCHAR(255) ,
                                                             TOKEN_ID VARCHAR(255) ,
                                                             SESSION_DATA_KEY VARCHAR(255),
                                                             PRIMARY KEY (ID),
                                                             FOREIGN KEY (CONSUMER_KEY_ID) REFERENCES IDN_OAUTH_CONSUMER_APPS(ID) ON DELETE CASCADE,
                                                             FOREIGN KEY (TOKEN_ID) REFERENCES IDN_OAUTH2_ACCESS_TOKEN(TOKEN_ID) ON DELETE CASCADE,
                                                             FOREIGN KEY (CODE_ID) REFERENCES IDN_OAUTH2_AUTHORIZATION_CODE(CODE_ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_OIDC_REQ_OBJECT_CLAIMS (
                                                          ID INTEGER NOT NULL AUTO_INCREMENT,
                                                          REQ_OBJECT_ID INTEGER,
                                                          CLAIM_ATTRIBUTE VARCHAR(255) ,
                                                          ESSENTIAL CHAR(1) NOT NULL DEFAULT '0' ,
                                                          VALUE VARCHAR(255) ,
                                                          IS_USERINFO CHAR(1) NOT NULL DEFAULT '0',
                                                          PRIMARY KEY (ID),
                                                          FOREIGN KEY (REQ_OBJECT_ID) REFERENCES IDN_OIDC_REQ_OBJECT_REFERENCE (ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_OIDC_REQ_OBJ_CLAIM_VALUES (
                                                             ID INTEGER NOT NULL AUTO_INCREMENT,
                                                             REQ_OBJECT_CLAIMS_ID INTEGER ,
                                                             CLAIM_VALUES VARCHAR(255) ,
                                                             PRIMARY KEY (ID),
                                                             FOREIGN KEY (REQ_OBJECT_CLAIMS_ID) REFERENCES  IDN_OIDC_REQ_OBJECT_CLAIMS(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_CERTIFICATE (
                                               ID INTEGER NOT NULL AUTO_INCREMENT,
                                               NAME VARCHAR(100),
                                               CERTIFICATE_IN_PEM BLOB,
                                               TENANT_ID INTEGER DEFAULT 0,
                                               PRIMARY KEY(ID),
                                               CONSTRAINT CERTIFICATE_UNIQUE_KEY UNIQUE (NAME, TENANT_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_OIDC_SCOPE (
                                              ID INTEGER NOT NULL AUTO_INCREMENT,
                                              NAME VARCHAR(255) NOT NULL,
                                              TENANT_ID INTEGER DEFAULT -1,
                                              PRIMARY KEY (ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_OIDC_SCOPE_CLAIM_MAPPING (
                                                            ID INTEGER NOT NULL AUTO_INCREMENT,
                                                            SCOPE_ID INTEGER,
                                                            EXTERNAL_CLAIM_ID INTEGER,
                                                            PRIMARY KEY (ID),
                                                            FOREIGN KEY (SCOPE_ID) REFERENCES IDN_OIDC_SCOPE(ID) ON DELETE CASCADE,
                                                            FOREIGN KEY (EXTERNAL_CLAIM_ID) REFERENCES IDN_CLAIM(ID) ON DELETE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS IDN_FUNCTION_LIBRARY (
                                                    NAME VARCHAR(255) NOT NULL,
                                                    DESCRIPTION VARCHAR(1023),
                                                    TYPE VARCHAR(255) NOT NULL,
                                                    TENANT_ID INTEGER NOT NULL,
                                                    DATA BLOB NOT NULL,
                                                    PRIMARY KEY (TENANT_ID,NAME)
)ENGINE INNODB;

-- --------------------------- INDEX CREATION -----------------------------
-- IDN_OAUTH2_ACCESS_TOKEN --
CREATE INDEX IDX_TC ON IDN_OAUTH2_ACCESS_TOKEN(TIME_CREATED);
CREATE INDEX IDX_ATH ON IDN_OAUTH2_ACCESS_TOKEN(ACCESS_TOKEN_HASH);
CREATE INDEX IDX_AT_CK_AU ON IDN_OAUTH2_ACCESS_TOKEN(CONSUMER_KEY_ID, AUTHZ_USER, TOKEN_STATE, USER_TYPE);
CREATE INDEX IDX_AT_TI_UD ON IDN_OAUTH2_ACCESS_TOKEN(AUTHZ_USER, TENANT_ID, TOKEN_STATE, USER_DOMAIN);
CREATE INDEX IDX_AT_AU_TID_UD_TS_CKID ON IDN_OAUTH2_ACCESS_TOKEN(AUTHZ_USER, TENANT_ID, USER_DOMAIN, TOKEN_STATE, CONSUMER_KEY_ID);
CREATE INDEX IDX_AT_AU_CKID_TS_UT ON IDN_OAUTH2_ACCESS_TOKEN(AUTHZ_USER, CONSUMER_KEY_ID, TOKEN_STATE, USER_TYPE);
CREATE INDEX IDX_AT_RTH ON IDN_OAUTH2_ACCESS_TOKEN(REFRESH_TOKEN_HASH);

-- IDN_OAUTH2_AUTHORIZATION_CODE --
CREATE INDEX IDX_AUTHORIZATION_CODE_HASH ON IDN_OAUTH2_AUTHORIZATION_CODE (AUTHORIZATION_CODE_HASH, CONSUMER_KEY_ID);
CREATE INDEX IDX_AUTHORIZATION_CODE_AU_TI ON IDN_OAUTH2_AUTHORIZATION_CODE (AUTHZ_USER, TENANT_ID, USER_DOMAIN, STATE);
CREATE INDEX IDX_AC_CKID ON IDN_OAUTH2_AUTHORIZATION_CODE(CONSUMER_KEY_ID);
CREATE INDEX IDX_AC_TID ON IDN_OAUTH2_AUTHORIZATION_CODE(TOKEN_ID);

-- IDN_SCIM_GROUP --
CREATE INDEX IDX_IDN_SCIM_GROUP_TI_RN ON IDN_SCIM_GROUP (TENANT_ID, ROLE_NAME);
CREATE INDEX IDX_IDN_SCIM_GROUP_TI_RN_AN ON IDN_SCIM_GROUP (TENANT_ID, ROLE_NAME, ATTR_NAME(500));

-- IDN_AUTH_SESSION_STORE --
CREATE INDEX IDX_IDN_AUTH_SESSION_TIME ON IDN_AUTH_SESSION_STORE (TIME_CREATED);

-- IDN_AUTH_TEMP_SESSION_STORE --
CREATE INDEX IDX_IDN_AUTH_TMP_SESSION_TIME ON IDN_AUTH_TEMP_SESSION_STORE (TIME_CREATED);

-- IDN_OIDC_SCOPE_CLAIM_MAPPING --
CREATE INDEX IDX_AT_SI_ECI ON IDN_OIDC_SCOPE_CLAIM_MAPPING(SCOPE_ID, EXTERNAL_CLAIM_ID);

-- IDN_OAUTH2_SCOPE --
CREATE INDEX IDX_SC_TID ON IDN_OAUTH2_SCOPE(TENANT_ID);
CREATE INDEX IDX_SC_N_TID ON IDN_OAUTH2_SCOPE(NAME, TENANT_ID);

-- IDN_OAUTH2_SCOPE_BINDING --
CREATE INDEX IDX_SB_SCPID ON IDN_OAUTH2_SCOPE_BINDING(SCOPE_ID);

-- IDN_OIDC_REQ_OBJECT_REFERENCE --
CREATE INDEX IDX_OROR_TID ON IDN_OIDC_REQ_OBJECT_REFERENCE(TOKEN_ID);

-- IDN_OAUTH2_ACCESS_TOKEN_SCOPE --
CREATE INDEX IDX_ATS_TID ON IDN_OAUTH2_ACCESS_TOKEN_SCOPE(TOKEN_ID);

-- SP_TEMPLATE --
CREATE INDEX IDX_SP_TEMPLATE ON SP_TEMPLATE (TENANT_ID, NAME);

-- IDN_AUTH_USER --
CREATE INDEX IDX_AUTH_USER_UN_TID_DN ON IDN_AUTH_USER (USER_NAME, TENANT_ID, DOMAIN_NAME);
CREATE INDEX IDX_AUTH_USER_DN_TOD ON IDN_AUTH_USER (DOMAIN_NAME, TENANT_ID);

-- IDN_AUTH_USER_SESSION_MAPPING --
CREATE INDEX IDX_USER_ID ON IDN_AUTH_USER_SESSION_MAPPING (USER_ID);
CREATE INDEX IDX_SESSION_ID ON IDN_AUTH_USER_SESSION_MAPPING (SESSION_ID);

-- IDN_OAUTH_CONSUMER_APPS --
CREATE INDEX IDX_OCA_UM_TID_UD_APN ON IDN_OAUTH_CONSUMER_APPS(USERNAME,TENANT_ID,USER_DOMAIN, APP_NAME);

-- IDX_SPI_APP --
CREATE INDEX IDX_SPI_APP ON SP_INBOUND_AUTH(APP_ID);

-- IDN_OIDC_PROPERTY --
CREATE INDEX IDX_IOP_TID_CK ON IDN_OIDC_PROPERTY(TENANT_ID,CONSUMER_KEY);

-- IDN_FIDO2_PROPERTY --
CREATE INDEX IDX_FIDO2_STR ON FIDO2_DEVICE_STORE(USER_NAME, TENANT_ID, DOMAIN_NAME, CREDENTIAL_ID, USER_HANDLE);
-- End of IDENTITY Tables--

-- Start of CONSENT-MGT Tables --

CREATE TABLE CM_PII_CATEGORY (
                                 ID           INTEGER AUTO_INCREMENT,
                                 NAME         VARCHAR(255) NOT NULL,
                                 DESCRIPTION  VARCHAR(1023),
                                 DISPLAY_NAME VARCHAR(255),
                                 IS_SENSITIVE INTEGER      NOT NULL,
                                 TENANT_ID    INTEGER DEFAULT '-1234',
                                 UNIQUE KEY (NAME, TENANT_ID),
                                 PRIMARY KEY (ID)
);

CREATE TABLE CM_RECEIPT (
                            CONSENT_RECEIPT_ID  VARCHAR(255) NOT NULL,
                            VERSION             VARCHAR(255) NOT NULL,
                            JURISDICTION        VARCHAR(255) NOT NULL,
                            CONSENT_TIMESTAMP   TIMESTAMP    NOT NULL,
                            COLLECTION_METHOD   VARCHAR(255) NOT NULL,
                            LANGUAGE            VARCHAR(255) NOT NULL,
                            PII_PRINCIPAL_ID    VARCHAR(255) NOT NULL,
                            PRINCIPAL_TENANT_ID INTEGER DEFAULT '-1234',
                            POLICY_URL          VARCHAR(255) NOT NULL,
                            STATE               VARCHAR(255) NOT NULL,
                            PII_CONTROLLER      VARCHAR(2048) NOT NULL,
                            PRIMARY KEY (CONSENT_RECEIPT_ID)
);

CREATE TABLE CM_PURPOSE (
                            ID            INTEGER AUTO_INCREMENT,
                            NAME          VARCHAR(255) NOT NULL,
                            DESCRIPTION   VARCHAR(1023),
                            PURPOSE_GROUP VARCHAR(255) NOT NULL,
                            GROUP_TYPE    VARCHAR(255) NOT NULL,
                            TENANT_ID     INTEGER DEFAULT '-1234',
                            UNIQUE KEY (NAME, TENANT_ID, PURPOSE_GROUP, GROUP_TYPE),
                            PRIMARY KEY (ID)
);

CREATE TABLE CM_PURPOSE_CATEGORY (
                                     ID          INTEGER AUTO_INCREMENT,
                                     NAME        VARCHAR(255) NOT NULL,
                                     DESCRIPTION VARCHAR(1023),
                                     TENANT_ID   INTEGER DEFAULT '-1234',
                                     UNIQUE KEY (NAME, TENANT_ID),
                                     PRIMARY KEY (ID)
);

CREATE TABLE CM_RECEIPT_SP_ASSOC (
                                     ID                 INTEGER AUTO_INCREMENT,
                                     CONSENT_RECEIPT_ID VARCHAR(255) NOT NULL,
                                     SP_NAME            VARCHAR(255) NOT NULL,
                                     SP_DISPLAY_NAME    VARCHAR(255),
                                     SP_DESCRIPTION     VARCHAR(255),
                                     SP_TENANT_ID       INTEGER DEFAULT '-1234',
                                     UNIQUE KEY (CONSENT_RECEIPT_ID, SP_NAME, SP_TENANT_ID),
                                     PRIMARY KEY (ID)
);

CREATE TABLE CM_SP_PURPOSE_ASSOC (
                                     ID                     INTEGER AUTO_INCREMENT,
                                     RECEIPT_SP_ASSOC       INTEGER      NOT NULL,
                                     PURPOSE_ID             INTEGER      NOT NULL,
                                     CONSENT_TYPE           VARCHAR(255) NOT NULL,
                                     IS_PRIMARY_PURPOSE     INTEGER      NOT NULL,
                                     TERMINATION            VARCHAR(255) NOT NULL,
                                     THIRD_PARTY_DISCLOSURE INTEGER      NOT NULL,
                                     THIRD_PARTY_NAME       VARCHAR(255),
                                     UNIQUE KEY (RECEIPT_SP_ASSOC, PURPOSE_ID),
                                     PRIMARY KEY (ID)
);

CREATE TABLE CM_SP_PURPOSE_PURPOSE_CAT_ASSC (
                                                SP_PURPOSE_ASSOC_ID INTEGER NOT NULL,
                                                PURPOSE_CATEGORY_ID INTEGER NOT NULL,
                                                UNIQUE KEY (SP_PURPOSE_ASSOC_ID, PURPOSE_CATEGORY_ID)
);

CREATE TABLE CM_PURPOSE_PII_CAT_ASSOC (
                                          PURPOSE_ID         INTEGER NOT NULL,
                                          CM_PII_CATEGORY_ID INTEGER NOT NULL,
                                          IS_MANDATORY       INTEGER NOT NULL,
                                          UNIQUE KEY (PURPOSE_ID, CM_PII_CATEGORY_ID)
);

CREATE TABLE CM_SP_PURPOSE_PII_CAT_ASSOC (
                                             SP_PURPOSE_ASSOC_ID INTEGER NOT NULL,
                                             PII_CATEGORY_ID     INTEGER NOT NULL,
                                             VALIDITY            VARCHAR(1023),
                                             UNIQUE KEY (SP_PURPOSE_ASSOC_ID, PII_CATEGORY_ID)
);

CREATE TABLE CM_CONSENT_RECEIPT_PROPERTY (
                                             CONSENT_RECEIPT_ID VARCHAR(255)  NOT NULL,
                                             NAME               VARCHAR(255)  NOT NULL,
                                             VALUE              VARCHAR(1023) NOT NULL,
                                             UNIQUE KEY (CONSENT_RECEIPT_ID, NAME)
);

ALTER TABLE CM_RECEIPT_SP_ASSOC
    ADD CONSTRAINT CM_RECEIPT_SP_ASSOC_fk0 FOREIGN KEY (CONSENT_RECEIPT_ID) REFERENCES CM_RECEIPT (CONSENT_RECEIPT_ID);

ALTER TABLE CM_SP_PURPOSE_ASSOC
    ADD CONSTRAINT CM_SP_PURPOSE_ASSOC_fk0 FOREIGN KEY (RECEIPT_SP_ASSOC) REFERENCES CM_RECEIPT_SP_ASSOC (ID);

ALTER TABLE CM_SP_PURPOSE_ASSOC
    ADD CONSTRAINT CM_SP_PURPOSE_ASSOC_fk1 FOREIGN KEY (PURPOSE_ID) REFERENCES CM_PURPOSE (ID);

ALTER TABLE CM_SP_PURPOSE_PURPOSE_CAT_ASSC
    ADD CONSTRAINT CM_SP_P_P_CAT_ASSOC_fk0 FOREIGN KEY (SP_PURPOSE_ASSOC_ID) REFERENCES CM_SP_PURPOSE_ASSOC (ID);

ALTER TABLE CM_SP_PURPOSE_PURPOSE_CAT_ASSC
    ADD CONSTRAINT CM_SP_P_P_CAT_ASSOC_fk1 FOREIGN KEY (PURPOSE_CATEGORY_ID) REFERENCES CM_PURPOSE_CATEGORY (ID);

ALTER TABLE CM_SP_PURPOSE_PII_CAT_ASSOC
    ADD CONSTRAINT CM_SP_P_PII_CAT_ASSOC_fk0 FOREIGN KEY (SP_PURPOSE_ASSOC_ID) REFERENCES CM_SP_PURPOSE_ASSOC (ID);

ALTER TABLE CM_SP_PURPOSE_PII_CAT_ASSOC
    ADD CONSTRAINT CM_SP_P_PII_CAT_ASSOC_fk1 FOREIGN KEY (PII_CATEGORY_ID) REFERENCES CM_PII_CATEGORY (ID);

ALTER TABLE CM_CONSENT_RECEIPT_PROPERTY
    ADD CONSTRAINT CM_CONSENT_RECEIPT_PRT_fk0 FOREIGN KEY (CONSENT_RECEIPT_ID) REFERENCES CM_RECEIPT (CONSENT_RECEIPT_ID);

INSERT INTO CM_PURPOSE (NAME, DESCRIPTION, PURPOSE_GROUP, GROUP_TYPE, TENANT_ID) VALUES ('DEFAULT', 'For core functionalities of the product', 'DEFAULT', 'SP', '-1234');

INSERT INTO CM_PURPOSE_CATEGORY (NAME, DESCRIPTION, TENANT_ID) VALUES ('DEFAULT','For core functionalities of the product', '-1234');
-- End of CONSENT-MGT Tables --

-- Start of API-MGT Tables --
CREATE TABLE IF NOT EXISTS AM_SUBSCRIBER (
                                             SUBSCRIBER_ID INTEGER AUTO_INCREMENT,
                                             USER_ID VARCHAR(255) NOT NULL,
                                             TENANT_ID INTEGER NOT NULL,
                                             EMAIL_ADDRESS VARCHAR(256) NULL,
                                             DATE_SUBSCRIBED TIMESTAMP NOT NULL,
                                             PRIMARY KEY (SUBSCRIBER_ID),
                                             CREATED_BY VARCHAR(100),
                                             CREATED_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                             UPDATED_BY VARCHAR(100),
                                             UPDATED_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                             UNIQUE (TENANT_ID,USER_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_APPLICATION (
                                              APPLICATION_ID INTEGER AUTO_INCREMENT,
                                              NAME VARCHAR(100),
                                              SUBSCRIBER_ID INTEGER,
                                              APPLICATION_TIER VARCHAR(50) DEFAULT 'Unlimited',
                                              CALLBACK_URL VARCHAR(512),
                                              DESCRIPTION VARCHAR(512),
                                              APPLICATION_STATUS VARCHAR(50) DEFAULT 'APPROVED',
                                              GROUP_ID VARCHAR(100),
                                              CREATED_BY VARCHAR(100),
                                              CREATED_TIME TIMESTAMP,
                                              UPDATED_BY VARCHAR(100),
                                              UPDATED_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                              UUID VARCHAR(256),
                                              TOKEN_TYPE VARCHAR(10),
                                              FOREIGN KEY(SUBSCRIBER_ID) REFERENCES AM_SUBSCRIBER(SUBSCRIBER_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
                                              PRIMARY KEY(APPLICATION_ID),
                                              UNIQUE (NAME,SUBSCRIBER_ID),
                                              UNIQUE (UUID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_API (
                                      API_ID INTEGER AUTO_INCREMENT,
                                      API_PROVIDER VARCHAR(200),
                                      API_NAME VARCHAR(200),
                                      API_VERSION VARCHAR(30),
                                      CONTEXT VARCHAR(256),
                                      CONTEXT_TEMPLATE VARCHAR(256),
                                      API_TIER VARCHAR(256),
                                      API_TYPE VARCHAR(10),
                                      CREATED_BY VARCHAR(100),
                                      CREATED_TIME TIMESTAMP,
                                      UPDATED_BY VARCHAR(100),
                                      UPDATED_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                      PRIMARY KEY(API_ID),
                                      UNIQUE (API_PROVIDER,API_NAME,API_VERSION)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_API_URL_MAPPING (
                                                  URL_MAPPING_ID INTEGER AUTO_INCREMENT,
                                                  API_ID INTEGER NOT NULL,
                                                  HTTP_METHOD VARCHAR(20) NULL,
                                                  AUTH_SCHEME VARCHAR(50) NULL,
                                                  URL_PATTERN VARCHAR(512) NULL,
                                                  THROTTLING_TIER varchar(512) DEFAULT NULL,
                                                  MEDIATION_SCRIPT BLOB,
                                                  PRIMARY KEY (URL_MAPPING_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_API_PRODUCT_MAPPING (
                                                      API_PRODUCT_MAPPING_ID INTEGER AUTO_INCREMENT,
                                                      API_ID INTEGER,
                                                      URL_MAPPING_ID INTEGER,
                                                      FOREIGN KEY (API_ID) REFERENCES AM_API(API_ID) ON DELETE CASCADE,
                                                      FOREIGN KEY (URL_MAPPING_ID) REFERENCES AM_API_URL_MAPPING(URL_MAPPING_ID) ON DELETE CASCADE,
                                                      PRIMARY KEY(API_PRODUCT_MAPPING_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_SUBSCRIPTION (
                                               SUBSCRIPTION_ID INTEGER AUTO_INCREMENT,
                                               TIER_ID VARCHAR(50),
                                               API_ID INTEGER,
                                               LAST_ACCESSED TIMESTAMP NULL,
                                               APPLICATION_ID INTEGER,
                                               SUB_STATUS VARCHAR(50),
                                               SUBS_CREATE_STATE VARCHAR(50) DEFAULT 'SUBSCRIBE',
                                               CREATED_BY VARCHAR(100),
                                               CREATED_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                               UPDATED_BY VARCHAR(100),
                                               UPDATED_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                               UUID VARCHAR(256),
                                               FOREIGN KEY(APPLICATION_ID) REFERENCES AM_APPLICATION(APPLICATION_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
                                               FOREIGN KEY(API_ID) REFERENCES AM_API(API_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
                                               PRIMARY KEY (SUBSCRIPTION_ID),
                                               UNIQUE (UUID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_SUBSCRIPTION_KEY_MAPPING (
                                                           SUBSCRIPTION_ID INTEGER,
                                                           ACCESS_TOKEN VARCHAR(512),
                                                           KEY_TYPE VARCHAR(512) NOT NULL,
                                                           FOREIGN KEY(SUBSCRIPTION_ID) REFERENCES AM_SUBSCRIPTION(SUBSCRIPTION_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
                                                           PRIMARY KEY(SUBSCRIPTION_ID,ACCESS_TOKEN)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_APPLICATION_KEY_MAPPING (
                                                          APPLICATION_ID INTEGER,
                                                          CONSUMER_KEY VARCHAR(255),
                                                          KEY_TYPE VARCHAR(512) NOT NULL,
                                                          STATE VARCHAR(30) NOT NULL,
                                                          CREATE_MODE VARCHAR(30) DEFAULT 'CREATED',
                                                          FOREIGN KEY(APPLICATION_ID) REFERENCES AM_APPLICATION(APPLICATION_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
                                                          PRIMARY KEY(APPLICATION_ID,KEY_TYPE)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_API_LC_EVENT (
                                               EVENT_ID INTEGER AUTO_INCREMENT,
                                               API_ID INTEGER NOT NULL,
                                               PREVIOUS_STATE VARCHAR(50),
                                               NEW_STATE VARCHAR(50) NOT NULL,
                                               USER_ID VARCHAR(255) NOT NULL,
                                               TENANT_ID INTEGER NOT NULL,
                                               EVENT_DATE TIMESTAMP NOT NULL,
                                               FOREIGN KEY(API_ID) REFERENCES AM_API(API_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
                                               PRIMARY KEY (EVENT_ID)
)ENGINE INNODB;

CREATE TABLE AM_APP_KEY_DOMAIN_MAPPING (
                                           CONSUMER_KEY VARCHAR(255),
                                           AUTHZ_DOMAIN VARCHAR(255) DEFAULT 'ALL',
                                           PRIMARY KEY (CONSUMER_KEY,AUTHZ_DOMAIN)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_API_COMMENTS (
                                               COMMENT_ID VARCHAR(255) NOT NULL,
                                               COMMENT_TEXT VARCHAR(512),
                                               COMMENTED_USER VARCHAR(255),
                                               DATE_COMMENTED TIMESTAMP NOT NULL,
                                               API_ID INTEGER,
                                               FOREIGN KEY(API_ID) REFERENCES AM_API(API_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
                                               PRIMARY KEY (COMMENT_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_API_RATINGS (
                                              RATING_ID VARCHAR(255) NOT NULL,
                                              API_ID INTEGER,
                                              RATING INTEGER,
                                              SUBSCRIBER_ID INTEGER,
                                              FOREIGN KEY(API_ID) REFERENCES AM_API(API_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
                                              FOREIGN KEY(SUBSCRIBER_ID) REFERENCES AM_SUBSCRIBER(SUBSCRIBER_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
                                              PRIMARY KEY (RATING_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_TIER_PERMISSIONS (
                                                   TIER_PERMISSIONS_ID INTEGER AUTO_INCREMENT,
                                                   TIER VARCHAR(50) NOT NULL,
                                                   PERMISSIONS_TYPE VARCHAR(50) NOT NULL,
                                                   ROLES VARCHAR(512) NOT NULL,
                                                   TENANT_ID INTEGER NOT NULL,
                                                   PRIMARY KEY(TIER_PERMISSIONS_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_EXTERNAL_STORES (
                                                  APISTORE_ID INTEGER AUTO_INCREMENT,
                                                  API_ID INTEGER,
                                                  STORE_ID VARCHAR(255) NOT NULL,
                                                  STORE_DISPLAY_NAME VARCHAR(255) NOT NULL,
                                                  STORE_ENDPOINT VARCHAR(255) NOT NULL,
                                                  STORE_TYPE VARCHAR(255) NOT NULL,
                                                  LAST_UPDATED_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                                  FOREIGN KEY(API_ID) REFERENCES AM_API(API_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
                                                  PRIMARY KEY (APISTORE_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_WORKFLOWS(
                                           WF_ID INTEGER AUTO_INCREMENT,
                                           WF_REFERENCE VARCHAR(255) NOT NULL,
                                           WF_TYPE VARCHAR(255) NOT NULL,
                                           WF_STATUS VARCHAR(255) NOT NULL,
                                           WF_CREATED_TIME TIMESTAMP,
                                           WF_UPDATED_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
                                           WF_STATUS_DESC VARCHAR(1000),
                                           TENANT_ID INTEGER,
                                           TENANT_DOMAIN VARCHAR(255),
                                           WF_EXTERNAL_REFERENCE VARCHAR(255) NOT NULL,
                                           PRIMARY KEY (WF_ID),
                                           UNIQUE (WF_EXTERNAL_REFERENCE)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_APPLICATION_REGISTRATION (
                                                           REG_ID INT AUTO_INCREMENT,
                                                           SUBSCRIBER_ID INT,
                                                           WF_REF VARCHAR(255) NOT NULL,
                                                           APP_ID INT,
                                                           TOKEN_TYPE VARCHAR(30),
                                                           TOKEN_SCOPE VARCHAR(1500) DEFAULT 'default',
                                                           INPUTS VARCHAR(1000),
                                                           ALLOWED_DOMAINS VARCHAR(256),
                                                           VALIDITY_PERIOD BIGINT,
                                                           UNIQUE (SUBSCRIBER_ID,APP_ID,TOKEN_TYPE),
                                                           FOREIGN KEY(SUBSCRIBER_ID) REFERENCES AM_SUBSCRIBER(SUBSCRIBER_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
                                                           FOREIGN KEY(APP_ID) REFERENCES AM_APPLICATION(APPLICATION_ID) ON UPDATE CASCADE ON DELETE RESTRICT,
                                                           PRIMARY KEY (REG_ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_API_SCOPES (
                                             API_ID  INTEGER NOT NULL,
                                             SCOPE_ID  INTEGER NOT NULL,
                                             FOREIGN KEY (API_ID) REFERENCES AM_API (API_ID) ON DELETE CASCADE ON UPDATE CASCADE,
                                             FOREIGN KEY (SCOPE_ID) REFERENCES IDN_OAUTH2_SCOPE (SCOPE_ID) ON DELETE CASCADE ON UPDATE CASCADE,
                                             PRIMARY KEY (API_ID, SCOPE_ID)
)ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS AM_API_DEFAULT_VERSION (
                                                      DEFAULT_VERSION_ID INT AUTO_INCREMENT,
                                                      API_NAME VARCHAR(256) NOT NULL ,
                                                      API_PROVIDER VARCHAR(256) NOT NULL ,
                                                      DEFAULT_API_VERSION VARCHAR(30) ,
                                                      PUBLISHED_DEFAULT_API_VERSION VARCHAR(30) ,
                                                      PRIMARY KEY (DEFAULT_VERSION_ID)
)ENGINE = INNODB;

CREATE INDEX IDX_SUB_APP_ID ON AM_SUBSCRIPTION (APPLICATION_ID, SUBSCRIPTION_ID);

CREATE TABLE IF NOT EXISTS AM_MONETIZATION_USAGE (
                                                     ID VARCHAR(100) NOT NULL,
                                                     STATE VARCHAR(50) NOT NULL,
                                                     STATUS VARCHAR(50) NOT NULL,
                                                     STARTED_TIME VARCHAR(50) NOT NULL,
                                                     PUBLISHED_TIME VARCHAR(50) NOT NULL,
                                                     PRIMARY KEY(ID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_ALERT_TYPES (
                                              ALERT_TYPE_ID INTEGER AUTO_INCREMENT,
                                              ALERT_TYPE_NAME VARCHAR(255) NOT NULL ,
                                              STAKE_HOLDER VARCHAR(100) NOT NULL,
                                              PRIMARY KEY (ALERT_TYPE_ID)
)ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS AM_ALERT_TYPES_VALUES (
                                                     ALERT_TYPE_ID INTEGER,
                                                     USER_NAME VARCHAR(255) NOT NULL ,
                                                     STAKE_HOLDER VARCHAR(100) NOT NULL ,
                                                     PRIMARY KEY (ALERT_TYPE_ID,USER_NAME,STAKE_HOLDER)
)ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS AM_ALERT_EMAILLIST (
                                                  EMAIL_LIST_ID INTEGER AUTO_INCREMENT,
                                                  USER_NAME VARCHAR(255) NOT NULL ,
                                                  STAKE_HOLDER VARCHAR(100) NOT NULL ,
                                                  PRIMARY KEY (EMAIL_LIST_ID,USER_NAME,STAKE_HOLDER)
)ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS  AM_ALERT_EMAILLIST_DETAILS (
                                                           EMAIL_LIST_ID INTEGER,
                                                           EMAIL VARCHAR(255),
                                                           PRIMARY KEY (EMAIL_LIST_ID,EMAIL)
)ENGINE = INNODB;

INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('AbnormalResponseTime', 'publisher');
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('AbnormalBackendTime', 'publisher');
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('AbnormalRequestsPerMin', 'subscriber');
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('AbnormalRequestPattern', 'subscriber');
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('UnusualIPAccess', 'subscriber');
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('FrequentTierLimitHitting', 'subscriber');
INSERT INTO AM_ALERT_TYPES (ALERT_TYPE_NAME, STAKE_HOLDER) VALUES ('ApiHealthMonitor', 'publisher');



-- AM Throttling tables --

CREATE TABLE IF NOT EXISTS AM_POLICY_SUBSCRIPTION (
                                                      POLICY_ID INT(11) NOT NULL AUTO_INCREMENT,
                                                      NAME VARCHAR(512) NOT NULL,
                                                      DISPLAY_NAME VARCHAR(512) NULL DEFAULT NULL,
                                                      TENANT_ID INT(11) NOT NULL,
                                                      DESCRIPTION VARCHAR(1024) NULL DEFAULT NULL,
                                                      QUOTA_TYPE VARCHAR(25) NOT NULL,
                                                      QUOTA INT(11) NOT NULL,
                                                      QUOTA_UNIT VARCHAR(10) NULL,
                                                      UNIT_TIME INT(11) NOT NULL,
                                                      TIME_UNIT VARCHAR(25) NOT NULL,
                                                      RATE_LIMIT_COUNT INT(11) NULL DEFAULT NULL,
                                                      RATE_LIMIT_TIME_UNIT VARCHAR(25) NULL DEFAULT NULL,
                                                      IS_DEPLOYED TINYINT(1) NOT NULL DEFAULT 0,
                                                      CUSTOM_ATTRIBUTES BLOB DEFAULT NULL,
                                                      STOP_ON_QUOTA_REACH BOOLEAN NOT NULL DEFAULT 0,
                                                      BILLING_PLAN VARCHAR(20) NOT NULL,
                                                      UUID VARCHAR(256),
                                                      MONETIZATION_PLAN VARCHAR(25) NULL DEFAULT NULL,
                                                      FIXED_RATE VARCHAR(15) NULL DEFAULT NULL,
                                                      BILLING_CYCLE VARCHAR(15) NULL DEFAULT NULL,
                                                      PRICE_PER_REQUEST VARCHAR(15) NULL DEFAULT NULL,
                                                      CURRENCY VARCHAR(15) NULL DEFAULT NULL,
                                                      PRIMARY KEY (POLICY_ID),
                                                      UNIQUE INDEX AM_POLICY_SUBSCRIPTION_NAME_TENANT (NAME, TENANT_ID),
                                                      UNIQUE (UUID)
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS AM_POLICY_APPLICATION (
                                                     POLICY_ID INT(11) NOT NULL AUTO_INCREMENT,
                                                     NAME VARCHAR(512) NOT NULL,
                                                     DISPLAY_NAME VARCHAR(512) NULL DEFAULT NULL,
                                                     TENANT_ID INT(11) NOT NULL,
                                                     DESCRIPTION VARCHAR(1024) NULL DEFAULT NULL,
                                                     QUOTA_TYPE VARCHAR(25) NOT NULL,
                                                     QUOTA INT(11) NOT NULL,
                                                     QUOTA_UNIT VARCHAR(10) NULL DEFAULT NULL,
                                                     UNIT_TIME INT(11) NOT NULL,
                                                     TIME_UNIT VARCHAR(25) NOT NULL,
                                                     IS_DEPLOYED TINYINT(1) NOT NULL DEFAULT 0,
                                                     CUSTOM_ATTRIBUTES BLOB DEFAULT NULL,
                                                     UUID VARCHAR(256),
                                                     PRIMARY KEY (POLICY_ID),
                                                     UNIQUE INDEX APP_NAME_TENANT (NAME, TENANT_ID),
                                                     UNIQUE (UUID)
)ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS AM_POLICY_HARD_THROTTLING (
                                                         POLICY_ID INT(11) NOT NULL AUTO_INCREMENT,
                                                         NAME VARCHAR(512) NOT NULL,
                                                         TENANT_ID INT(11) NOT NULL,
                                                         DESCRIPTION VARCHAR(1024) NULL DEFAULT NULL,
                                                         QUOTA_TYPE VARCHAR(25) NOT NULL,
                                                         QUOTA INT(11) NOT NULL,
                                                         QUOTA_UNIT VARCHAR(10) NULL DEFAULT NULL,
                                                         UNIT_TIME INT(11) NOT NULL,
                                                         TIME_UNIT VARCHAR(25) NOT NULL,
                                                         IS_DEPLOYED TINYINT(1) NOT NULL DEFAULT 0,
                                                         PRIMARY KEY (POLICY_ID),
                                                         UNIQUE INDEX POLICY_HARD_NAME_TENANT (NAME, TENANT_ID)
)ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS AM_API_THROTTLE_POLICY (
                                                      POLICY_ID INT(11) NOT NULL AUTO_INCREMENT,
                                                      NAME VARCHAR(512) NOT NULL,
                                                      DISPLAY_NAME VARCHAR(512) NULL DEFAULT NULL,
                                                      TENANT_ID INT(11) NOT NULL,
                                                      DESCRIPTION VARCHAR (1024),
                                                      DEFAULT_QUOTA_TYPE VARCHAR(25) NOT NULL,
                                                      DEFAULT_QUOTA INTEGER NOT NULL,
                                                      DEFAULT_QUOTA_UNIT VARCHAR(10) NULL,
                                                      DEFAULT_UNIT_TIME INTEGER NOT NULL,
                                                      DEFAULT_TIME_UNIT VARCHAR(25) NOT NULL,
                                                      APPLICABLE_LEVEL VARCHAR(25) NOT NULL,
                                                      IS_DEPLOYED TINYINT(1) NOT NULL DEFAULT 0,
                                                      UUID VARCHAR(256),
                                                      PRIMARY KEY (POLICY_ID),
                                                      UNIQUE INDEX API_NAME_TENANT (NAME, TENANT_ID),
                                                      UNIQUE (UUID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_CONDITION_GROUP (
                                                  CONDITION_GROUP_ID INTEGER NOT NULL AUTO_INCREMENT,
                                                  POLICY_ID INTEGER NOT NULL,
                                                  QUOTA_TYPE VARCHAR(25),
                                                  QUOTA INTEGER NOT NULL,
                                                  QUOTA_UNIT VARCHAR(10) NULL DEFAULT NULL,
                                                  UNIT_TIME INTEGER NOT NULL,
                                                  TIME_UNIT VARCHAR(25) NOT NULL,
                                                  DESCRIPTION VARCHAR (1024) NULL DEFAULT NULL,
                                                  PRIMARY KEY (CONDITION_GROUP_ID),
                                                  FOREIGN KEY (POLICY_ID) REFERENCES AM_API_THROTTLE_POLICY(POLICY_ID) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_QUERY_PARAMETER_CONDITION (
                                                            QUERY_PARAMETER_ID INTEGER NOT NULL AUTO_INCREMENT,
                                                            CONDITION_GROUP_ID INTEGER NOT NULL,
                                                            PARAMETER_NAME VARCHAR(255) DEFAULT NULL,
                                                            PARAMETER_VALUE VARCHAR(255) DEFAULT NULL,
                                                            IS_PARAM_MAPPING BOOLEAN DEFAULT 1,
                                                            PRIMARY KEY (QUERY_PARAMETER_ID),
                                                            FOREIGN KEY (CONDITION_GROUP_ID) REFERENCES AM_CONDITION_GROUP(CONDITION_GROUP_ID) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_HEADER_FIELD_CONDITION (
                                                         HEADER_FIELD_ID INTEGER NOT NULL AUTO_INCREMENT,
                                                         CONDITION_GROUP_ID INTEGER NOT NULL,
                                                         HEADER_FIELD_NAME VARCHAR(255) DEFAULT NULL,
                                                         HEADER_FIELD_VALUE VARCHAR(255) DEFAULT NULL,
                                                         IS_HEADER_FIELD_MAPPING BOOLEAN DEFAULT 1,
                                                         PRIMARY KEY (HEADER_FIELD_ID),
                                                         FOREIGN KEY (CONDITION_GROUP_ID) REFERENCES AM_CONDITION_GROUP(CONDITION_GROUP_ID) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_JWT_CLAIM_CONDITION (
                                                      JWT_CLAIM_ID INTEGER NOT NULL AUTO_INCREMENT,
                                                      CONDITION_GROUP_ID INTEGER NOT NULL,
                                                      CLAIM_URI VARCHAR(512) DEFAULT NULL,
                                                      CLAIM_ATTRIB VARCHAR(1024) DEFAULT NULL,
                                                      IS_CLAIM_MAPPING BOOLEAN DEFAULT 1,
                                                      PRIMARY KEY (JWT_CLAIM_ID),
                                                      FOREIGN KEY (CONDITION_GROUP_ID) REFERENCES AM_CONDITION_GROUP(CONDITION_GROUP_ID) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_IP_CONDITION (
                                               AM_IP_CONDITION_ID INT NOT NULL AUTO_INCREMENT,
                                               STARTING_IP VARCHAR(45) NULL,
                                               ENDING_IP VARCHAR(45) NULL,
                                               SPECIFIC_IP VARCHAR(45) NULL,
                                               WITHIN_IP_RANGE BOOLEAN DEFAULT 1,
                                               CONDITION_GROUP_ID INT NULL,
                                               PRIMARY KEY (AM_IP_CONDITION_ID),
                                               INDEX fk_AM_IP_CONDITION_1_idx (CONDITION_GROUP_ID ASC),  CONSTRAINT fk_AM_IP_CONDITION_1    FOREIGN KEY (CONDITION_GROUP_ID)
        REFERENCES AM_CONDITION_GROUP (CONDITION_GROUP_ID)   ON DELETE CASCADE ON UPDATE CASCADE)
    ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS AM_POLICY_GLOBAL (
                                                POLICY_ID INT(11) NOT NULL AUTO_INCREMENT,
                                                NAME VARCHAR(512) NOT NULL,
                                                KEY_TEMPLATE VARCHAR(512) NOT NULL,
                                                TENANT_ID INT(11) NOT NULL,
                                                DESCRIPTION VARCHAR(1024) NULL DEFAULT NULL,
                                                SIDDHI_QUERY BLOB DEFAULT NULL,
                                                IS_DEPLOYED TINYINT(1) NOT NULL DEFAULT 0,
                                                UUID VARCHAR(256),
                                                PRIMARY KEY (POLICY_ID),
                                                UNIQUE (UUID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_THROTTLE_TIER_PERMISSIONS (
                                                            THROTTLE_TIER_PERMISSIONS_ID INT NOT NULL AUTO_INCREMENT,
                                                            TIER VARCHAR(50) NULL,
                                                            PERMISSIONS_TYPE VARCHAR(50) NULL,
                                                            ROLES VARCHAR(512) NULL,
                                                            TENANT_ID INT(11) NULL,
                                                            PRIMARY KEY (THROTTLE_TIER_PERMISSIONS_ID))
    ENGINE = InnoDB;

CREATE TABLE `AM_BLOCK_CONDITIONS` (
                                       `CONDITION_ID` int(11) NOT NULL AUTO_INCREMENT,
                                       `TYPE` varchar(45) DEFAULT NULL,
                                       `VALUE` varchar(512) DEFAULT NULL,
                                       `ENABLED` varchar(45) DEFAULT NULL,
                                       `DOMAIN` varchar(45) DEFAULT NULL,
                                       `UUID` VARCHAR(256),
                                       PRIMARY KEY (`CONDITION_ID`),
                                       UNIQUE (`UUID`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `AM_CERTIFICATE_METADATA` (
                                                         `TENANT_ID` INT(11) NOT NULL,
                                                         `ALIAS` VARCHAR(45) NOT NULL,
                                                         `END_POINT` VARCHAR(100) NOT NULL,
                                                         CONSTRAINT PK_ALIAS PRIMARY KEY (`ALIAS`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `AM_API_CLIENT_CERTIFICATE` (
                                                           `TENANT_ID` INT(11) NOT NULL,
                                                           `ALIAS` VARCHAR(45) NOT NULL,
                                                           `API_ID` INTEGER NOT NULL,
                                                           `CERTIFICATE` BLOB NOT NULL,
                                                           `REMOVED` BOOLEAN NOT NULL DEFAULT 0,
                                                           `TIER_NAME` VARCHAR (512),
                                                           FOREIGN KEY (API_ID) REFERENCES AM_API (API_ID) ON DELETE CASCADE ON UPDATE CASCADE,
                                                           PRIMARY KEY (`ALIAS`, `TENANT_ID`, `REMOVED`)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS AM_APPLICATION_GROUP_MAPPING (
                                                            APPLICATION_ID INTEGER NOT NULL,
                                                            GROUP_ID VARCHAR(512) NOT NULL,
                                                            TENANT VARCHAR(255),
                                                            PRIMARY KEY (APPLICATION_ID,GROUP_ID,TENANT),
                                                            FOREIGN KEY (APPLICATION_ID) REFERENCES AM_APPLICATION(APPLICATION_ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS AM_USAGE_UPLOADED_FILES (
                                                       TENANT_DOMAIN varchar(255) NOT NULL,
                                                       FILE_NAME varchar(255) NOT NULL,
                                                       FILE_TIMESTAMP TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                                       FILE_PROCESSED tinyint(1) DEFAULT FALSE,
                                                       FILE_CONTENT MEDIUMBLOB DEFAULT NULL,
                                                       PRIMARY KEY (TENANT_DOMAIN, FILE_NAME, FILE_TIMESTAMP)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS AM_API_LC_PUBLISH_EVENTS (
                                                        ID INTEGER(11) NOT NULL AUTO_INCREMENT,
                                                        TENANT_DOMAIN VARCHAR(500) NOT NULL,
                                                        API_ID VARCHAR(500) NOT NULL,
                                                        EVENT_TIME TIMESTAMP NOT NULL,
                                                        PRIMARY KEY (ID)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS AM_APPLICATION_ATTRIBUTES (
                                                         APPLICATION_ID int(11) NOT NULL,
                                                         NAME varchar(255) NOT NULL,
                                                         VALUE varchar(1024) NOT NULL,
                                                         TENANT_ID int(11) NOT NULL,
                                                         PRIMARY KEY (APPLICATION_ID,NAME),
                                                         FOREIGN KEY (APPLICATION_ID) REFERENCES AM_APPLICATION (APPLICATION_ID) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS AM_LABELS (
                                         LABEL_ID VARCHAR(50),
                                         NAME VARCHAR(255),
                                         DESCRIPTION VARCHAR(1024),
                                         TENANT_DOMAIN VARCHAR(255),
                                         UNIQUE (NAME,TENANT_DOMAIN),
                                         PRIMARY KEY (LABEL_ID)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS AM_LABEL_URLS (
                                             LABEL_ID VARCHAR(50),
                                             ACCESS_URL VARCHAR(255),
                                             PRIMARY KEY (LABEL_ID,ACCESS_URL),
                                             FOREIGN KEY (LABEL_ID) REFERENCES AM_LABELS(LABEL_ID) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS AM_SYSTEM_APPS (
                                              ID INTEGER AUTO_INCREMENT,
                                              NAME VARCHAR(50) NOT NULL,
                                              CONSUMER_KEY VARCHAR(512) NOT NULL,
                                              CONSUMER_SECRET VARCHAR(512) NOT NULL,
                                              CREATED_TIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                              UNIQUE (NAME),
                                              UNIQUE (CONSUMER_KEY),
                                              PRIMARY KEY (ID)
) ENGINE=InnoDB;

-- BotDATA Email table --
CREATE TABLE IF NOT EXISTS AM_NOTIFICATION_SUBSCRIBER (
                                                          UUID VARCHAR(255),
                                                          CATEGORY VARCHAR(255),
                                                          NOTIFICATION_METHOD VARCHAR(255),
                                                          SUBSCRIBER_ADDRESS VARCHAR(255) NOT NULL,
                                                          PRIMARY KEY(UUID, SUBSCRIBER_ADDRESS)
) ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AM_REVOKED_JWT (
                                              UUID VARCHAR(255) NOT NULL,
                                              SIGNATURE VARCHAR(2048) NOT NULL,
                                              EXPIRY_TIMESTAMP BIGINT NOT NULL,
                                              TENANT_ID INTEGER DEFAULT -1,
                                              TOKEN_TYPE VARCHAR(15) DEFAULT 'DEFAULT',
                                              TIME_CREATED TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                              PRIMARY KEY (UUID)
) ENGINE=InnoDB;
-- End of API-MGT Tables --

-- Performance indexes start--

create index IDX_ITS_LMT on IDN_THRIFT_SESSION (LAST_MODIFIED_TIME);
create index IDX_IOAT_UT on IDN_OAUTH2_ACCESS_TOKEN (USER_TYPE);
create index IDX_AAI_CTX on AM_API (CONTEXT);
create index IDX_AAKM_CK on AM_APPLICATION_KEY_MAPPING (CONSUMER_KEY);
create index IDX_AAUM_AI on AM_API_URL_MAPPING (API_ID);
create index IDX_AAPM_AI on AM_API_PRODUCT_MAPPING (API_ID);
create index IDX_AAUM_TT on AM_API_URL_MAPPING (THROTTLING_TIER);
create index IDX_AATP_DQT on AM_API_THROTTLE_POLICY (DEFAULT_QUOTA_TYPE);
create index IDX_ACG_QT on AM_CONDITION_GROUP (QUOTA_TYPE);
create index IDX_APS_QT on AM_POLICY_SUBSCRIPTION (QUOTA_TYPE);
create index IDX_AS_AITIAI on AM_SUBSCRIPTION (API_ID,TIER_ID,APPLICATION_ID);
create index IDX_APA_QT on AM_POLICY_APPLICATION (QUOTA_TYPE);
create index IDX_AA_AT_CB on AM_APPLICATION (APPLICATION_TIER,CREATED_BY);

-- Performance indexes end--
