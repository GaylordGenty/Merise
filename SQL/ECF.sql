CREATE TABLE Victimes (AFF_ID char(50) NOT NULL, TYPE_VICT_ID CHAR(50) NOT NULL, VICT_NOM CHAR(50) NULL, VICT_PRENOM VARCHAR, VICT_AUTRE VARCHAR, VICT_ADRESSE VARCHAR,
VICT_ID VARCHAR);

CREATE TABLE AFFAIRE (AFF_ID varchar, OBJ_ID varchar, FCT_ID varchar, INFR_ID VARCHAR);
CREATE TABLE TYPEVICTIMES(TYPE_VICT_ID CHAR(50) NOT NULL, TYPEVICT_NOM VARCHAR, PRIMARY KEY(TYPE_VICT_ID));
--


CREATE TABLE FONCTIONNAIRES (FCT_ID VARCHAR NOT NULL, SERV_ID INTEGER, FCT_NOM VARCHAR, PRIMARY KEY (FCT_ID));
CREATE TABLE OBJETS (OBJ_ID varchar NOT NULL, OBJ_TYPE varchar, PRIMARY KEY (OBJ_ID));
CREATE TABLE SERVICE (SERV_ID INTEGER, SERV_NOM VARCHAR, PRIMARY KEY(SERV_ID));

INSERT INTO AFFAIRE VALUES ('bcda', 'random', 'abcd', 'infrabcd');
INSERT INTO OBJETS VALUES ('random', 'letype');
INSERT INTO FONCTIONNAIRES VALUES ('abcd', 01, 'LAURENCE');
INSERT INTO SERVICE VALUES (01, 'POLICE');

ALTER TABLE TYPEVICTIMES ADD CONSTRAINT TYPEVICT_NOM_NOT CHECK (TYPEVICT_NOM NOT IN('Entreprise', 'Association', 'Particulier','Administration'));

SELECT OBJ_ID FROM AFFAIRE WHERE OBJ_ID = (SELECT OBJ_ID FROM AFFAIRE 
WHERE FCT_ID = (SELECT FCT_ID FROm FONCTIONNAIRES WHERE FCT_NOM ='LAURENCE'));

SELECT SERV_NOM FROM SERVICE INNER JOIN FONCTIONNAIRES ON SERVICE.SERV_ID = FONCTIONNAIRES.SERV_ID 
WHERE FCT_NOM ='LAURENCE';

SELECT SERV_ID, TYPEVICTIMES.* FROM FONCTIONNAIRES, TYPEVICTIMES 
WHERE FONCTIONNAIRES.FCT_ID = (SELECT FCT_ID FROM AFFAIRE 
WHERE AFF_ID = (SELECT AFF_ID FROM Victimes WHERE VICT_NOM = ('Avril Lavigne')))



