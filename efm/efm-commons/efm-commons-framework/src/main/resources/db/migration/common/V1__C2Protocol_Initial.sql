--
-- (c) 2018-2019 Cloudera, Inc. All rights reserved.
--
--  This code is provided to you pursuant to your written agreement with Cloudera, which may be the terms of the
--  Affero General Public License version 3 (AGPLv3), or pursuant to a written agreement with a third party authorized
--  to distribute this code.  If you do not have a written agreement with Cloudera or with an authorized and
--  properly licensed third party, you do not have any rights to this code.
--
--  If this code is provided to you under the terms of the AGPLv3:
--   (A) CLOUDERA PROVIDES THIS CODE TO YOU WITHOUT WARRANTIES OF ANY KIND;
--   (B) CLOUDERA DISCLAIMS ANY AND ALL EXPRESS AND IMPLIED WARRANTIES WITH RESPECT TO THIS CODE, INCLUDING BUT NOT
--       LIMITED TO IMPLIED WARRANTIES OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE;
--   (C) CLOUDERA IS NOT LIABLE TO YOU, AND WILL NOT DEFEND, INDEMNIFY, OR HOLD YOU HARMLESS FOR ANY CLAIMS ARISING
--       FROM OR RELATED TO THE CODE; AND
--   (D) WITH RESPECT TO YOUR EXERCISE OF ANY RIGHTS GRANTED TO YOU FOR THE CODE, CLOUDERA IS NOT LIABLE FOR ANY
--       DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, PUNITIVE OR CONSEQUENTIAL DAMAGES INCLUDING, BUT NOT LIMITED
--       TO, DAMAGES RELATED TO LOST REVENUE, LOST PROFITS, LOSS OF INCOME, LOSS OF BUSINESS ADVANTAGE OR
--       UNAVAILABILITY, OR LOSS OR CORRUPTION OF DATA.
--

CREATE TABLE AGENT_MANIFEST (
    ID VARCHAR(50) NOT NULL,
    CONTENT LONGTEXT NOT NULL,
    CREATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UPDATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK__AGENT_MANIFEST PRIMARY KEY (ID)
);

CREATE TABLE AGENT_CLASS (
    ID VARCHAR(200) NOT NULL,
    DESCRIPTION VARCHAR(8000) NULL,
    CREATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UPDATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK__AGENT_CLASS PRIMARY KEY (ID)
);

CREATE TABLE AGENT_CLASS_MANIFEST (
    AGENT_CLASS_ID VARCHAR(200) NOT NULL,
    AGENT_MANIFEST_ID VARCHAR(50) NOT NULL,
    CONSTRAINT PK__AGENT_CLASS_MANIFEST PRIMARY KEY (AGENT_CLASS_ID, AGENT_MANIFEST_ID),
    CONSTRAINT FK__AGENT_CLASS_MANIFEST__AGENT_CLASS_ID
        FOREIGN KEY (AGENT_CLASS_ID) REFERENCES AGENT_CLASS(ID) ON DELETE CASCADE,
    CONSTRAINT FK__AGENT_CLASS_MANIFEST__AGENT_MANIFEST_ID
        FOREIGN KEY (AGENT_MANIFEST_ID) REFERENCES AGENT_MANIFEST(ID) ON DELETE CASCADE
);

CREATE TABLE AGENT (
  ID VARCHAR(50) NOT NULL,
  AGENT_NAME VARCHAR(120) NULL,
  FIRST_SEEN TIMESTAMP NULL,
  LAST_SEEN TIMESTAMP NULL,
  AGENT_CLASS VARCHAR(200) NULL,
  AGENT_MANIFEST_ID VARCHAR(50) NULL,
  AGENT_STATUS LONGTEXT NULL,
  CREATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UPDATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT PK__AGENT PRIMARY KEY (ID),
  CONSTRAINT FK__AGENT__AGENT_CLASS FOREIGN KEY (AGENT_CLASS) REFERENCES AGENT_CLASS(ID) ON DELETE CASCADE,
  CONSTRAINT FK__AGENT__AGENT_MANIFEST_ID FOREIGN KEY (AGENT_MANIFEST_ID) REFERENCES AGENT_MANIFEST(ID) ON DELETE CASCADE
);

CREATE TABLE DEVICE (
    ID VARCHAR(50) NOT NULL,
    DEVICE_NAME VARCHAR(200) NULL,
    FIRST_SEEN TIMESTAMP NULL,
    LAST_SEEN TIMESTAMP NULL,
    MACHINE_ARCH VARCHAR(100) NULL,
    PHYSICAL_MEM BIGINT NULL,
    V_CORES INTEGER NULL,
    NETWORK_ID VARCHAR(200) NULL,
    HOSTNAME VARCHAR(4096) NULL,
    IP_ADDRESS VARCHAR(45) NULL,
    CREATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UPDATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK__DEVICE PRIMARY KEY (ID)
);

CREATE TABLE FLOW (
    ID VARCHAR(50) NOT NULL,
    REGISTRY_URL VARCHAR(4096) NULL,
    REGISTRY_BUCKET_ID VARCHAR(50) NULL,
    REGISTRY_FLOW_ID VARCHAR(50) NULL,
    REGISTRY_FLOW_VERSION INT NULL,
    FLOW_CONTENT LONGTEXT NOT NULL,
    FLOW_CONTENT_FORMAT VARCHAR(50) NOT NULL,
    CREATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UPDATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK__FLOW PRIMARY KEY (ID)
);

CREATE TABLE FLOW_MAPPING (
    AGENT_CLASS VARCHAR(200) NOT NULL,
    FLOW_ID VARCHAR(50) NOT NULL,
    CREATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UPDATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK__FLOW_MAPPING PRIMARY KEY (AGENT_CLASS),
    CONSTRAINT FK__FLOW_MAPPING__AGENT_CLASS FOREIGN KEY (AGENT_CLASS) REFERENCES AGENT_CLASS (ID) ON DELETE CASCADE,
    CONSTRAINT FK__FLOW_MAPPING__FLOW_ID FOREIGN KEY (FLOW_ID) REFERENCES FLOW (ID) ON DELETE CASCADE
);

CREATE TABLE OPERATION (
    ID VARCHAR(50) NOT NULL,
    OPERATION_TYPE VARCHAR(120) NOT NULL,
    OPERAND VARCHAR(4096) NULL,
    TARGET_AGENT_ID VARCHAR(50) NOT NULL,
    STATE VARCHAR(40) NOT NULL,
    CREATED_BY VARCHAR(240) NULL,
    CREATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UPDATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK__OPERATION_ID PRIMARY KEY (ID)
);

CREATE TABLE OPERATION_ARG (
    OPERATION_ID VARCHAR(50) NOT NULL,
    ARG_KEY VARCHAR(120) NOT NULL,
    ARG_VALUE VARCHAR(4096) NOT NULL,
    CONSTRAINT PK__OPERATION_ARG PRIMARY KEY (OPERATION_ID, ARG_KEY),
    CONSTRAINT FK__OPERATION_ARG__OPERATION_ID FOREIGN KEY (OPERATION_ID) REFERENCES OPERATION(ID) ON DELETE CASCADE
);

CREATE TABLE OPERATION_DEPENDENCY (
    OPERATION_ID VARCHAR(50) NOT NULL,
    DEPENDENCY_ID VARCHAR(50) NOT NULL,
    CONSTRAINT PK__OPERATION_DEPENDENCY PRIMARY KEY (OPERATION_ID, DEPENDENCY_ID),
    CONSTRAINT FK__OPERATION_DEPENDENCY__OPERATION_ID FOREIGN KEY (OPERATION_ID) REFERENCES OPERATION(ID) ON DELETE CASCADE,
    CONSTRAINT FK__OPERATION_DEPENDENCY__DEPENDENCY_ID FOREIGN KEY (DEPENDENCY_ID) REFERENCES OPERATION(ID) ON DELETE CASCADE
);

CREATE TABLE HEARTBEAT (
    ID VARCHAR(50) NOT NULL,
    DEVICE_ID VARCHAR(50) NULL,
    AGENT_MANIFEST_ID VARCHAR(50) NULL,
    AGENT_CLASS VARCHAR(50) NULL,
    AGENT_ID VARCHAR(50) NULL,
    FLOW_ID VARCHAR(50) NULL,
    CONTENT LONGTEXT NULL,
    CREATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK__HEARTBEAT PRIMARY KEY (ID)
);

CREATE TABLE EVENT (
    ID VARCHAR(50) NOT NULL,
    SEVERITY VARCHAR(10) NOT NULL,
    EVENT_TYPE VARCHAR(200) NOT NULL,
    MESSAGE VARCHAR(8000) NOT NULL,
    SOURCE_TYPE VARCHAR(200) NULL,
    SOURCE_ID VARCHAR(200) NULL,
    DETAIL_TYPE VARCHAR(200) NULL,
    DETAIL_ID VARCHAR(200) NULL,
    AGENT_CLASS VARCHAR(200) NULL,
    CREATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UPDATED TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT PK__EVENT PRIMARY KEY (ID)
);

CREATE TABLE EVENT_TAG (
    EVENT_ID VARCHAR(50) NOT NULL,
    TAG VARCHAR(200) NOT NULL,
    TAG_VALUE VARCHAR(4096) NOT NULL,
    CONSTRAINT PK__EVENT_TAG PRIMARY KEY (EVENT_ID, TAG),
    CONSTRAINT FK__EVENT_TAG__EVENT_ID FOREIGN KEY (EVENT_ID) REFERENCES EVENT(ID)
);




