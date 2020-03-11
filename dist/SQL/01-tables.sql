--
--
-- SyGAL
-- =====
--
-- Web Service d'import de données
-- -------------------------------
--
-- Tables à créer par chaque établissement.
--

create table SYGAL_ACTEUR
(
    ID VARCHAR2(104),
    SOURCE_ID VARCHAR2(50 char),
    THESE_ID NUMBER(8),
    ROLE_ID CHAR,
    COD_ROJ_COMPL VARCHAR2(1 char),
    LIB_ROJ_COMPL VARCHAR2(21),
    COD_PER NUMBER(8),
    INDIVIDU_ID VARCHAR2(4000),
    ACTEUR_ETABLISSEMENT_ID VARCHAR2(8),
    COD_PAY_ETB VARCHAR2(3),
    LIB_PAY_ETB VARCHAR2(40),
    COD_CPS VARCHAR2(10),
    LIB_CPS VARCHAR2(40),
    TEM_HAB_RCH_PER VARCHAR2(1) not null,
    TEM_RAP_RECU VARCHAR2(1),
    SOURCE_INSERT_DATE DATE default sysdate not null
)
/

create table SYGAL_DOCTORANT
(
    SOURCE_ID VARCHAR2(50 char),
    ID NUMBER(8),
    INDIVIDU_ID NUMBER(8),
    INE VARCHAR2(12),
    SOURCE_INSERT_DATE DATE default sysdate not null
)
/

create table SYGAL_ECOLE_DOCT
(
    SOURCE_ID VARCHAR2(50 char),
    STRUCTURE_ID VARCHAR2(4),
    ID VARCHAR2(4),
    SOURCE_INSERT_DATE DATE default sysdate not null
)
/

create table SYGAL_ETABLISSEMENT
(
    SOURCE_ID VARCHAR2(50 char),
    STRUCTURE_ID VARCHAR2(8),
    ID VARCHAR2(8),
    CODE VARCHAR2(8),
    SOURCE_INSERT_DATE DATE default sysdate not null
)
/

create table SYGAL_FINANCEMENT
(
    ID NUMBER,
    SOURCE_ID VARCHAR2(50 char),
    THESE_ID NUMBER(8) not null,
    ANNEE_ID VARCHAR2(4),
    ORIGINE_FINANCEMENT_ID VARCHAR2(2),
    COMPLEMENT_FINANCEMENT VARCHAR2(4000),
    QUOTITE_FINANCEMENT NUMBER(3),
    DATE_DEBUT_FINANCEMENT DATE,
    DATE_FIN_FINANCEMENT DATE,
    SOURCE_INSERT_DATE DATE default sysdate not null
)
/

create table SYGAL_INDIVIDU
(
    SOURCE_ID VARCHAR2(50 char),
    TYPE VARCHAR2(9),
    ID VARCHAR2(4000),
    SUPANN_ID VARCHAR2(4000),
    CIV VARCHAR2(5),
    LIB_NOM_PAT_IND VARCHAR2(40),
    LIB_NOM_USU_IND VARCHAR2(40),
    LIB_PR1_IND VARCHAR2(20),
    LIB_PR2_IND VARCHAR2(20),
    LIB_PR3_IND VARCHAR2(20),
    EMAIL VARCHAR2(4000),
    DATE_NAI_IND DATE,
    COD_PAY_NAT VARCHAR2(3),
    LIB_NAT VARCHAR2(40),
    SOURCE_INSERT_DATE DATE default sysdate not null
)
/

create table SYGAL_ORIGINE_FINANCEMENT
(
    ID CHAR(2),
    SOURCE_ID VARCHAR2(50 char),
    COD_OFI CHAR(2),
    LIC_OFI VARCHAR2(10),
    LIB_OFI VARCHAR2(40),
    SOURCE_INSERT_DATE DATE default sysdate not null
)
/

create table SYGAL_ROLE
(
    SOURCE_ID VARCHAR2(50 char),
    ID CHAR,
    LIB_ROJ VARCHAR2(21),
    LIC_ROJ VARCHAR2(10),
    SOURCE_INSERT_DATE DATE default sysdate not null
)
/

create table SYGAL_STRUCTURE
(
    SOURCE_ID VARCHAR2(50 char),
    TYPE_STRUCTURE_ID VARCHAR2(15),
    ID VARCHAR2(10),
    SIGLE VARCHAR2(25),
    LIBELLE VARCHAR2(100),
    CODE_PAYS VARCHAR2(3),
    LIBELLE_PAYS VARCHAR2(40),
    SOURCE_INSERT_DATE DATE default sysdate not null
)
/

create table SYGAL_THESE_ANNEE_UNIV
(
    SOURCE_ID VARCHAR2(50 char),
    ID VARCHAR2(45),
    THESE_ID NUMBER(8) not null,
    ANNEE_UNIV VARCHAR2(4) not null,
    SOURCE_INSERT_DATE DATE default sysdate not null
)
/

create table SYGAL_TITRE_ACCES
(
    SOURCE_ID VARCHAR2(50 char),
    ID NUMBER(8) not null,
    THESE_ID NUMBER(8) not null,
    TITRE_ACCES_INTERNE_EXTERNE VARCHAR2(1),
    LIBELLE_TITRE_ACCES VARCHAR2(120),
    TYPE_ETB_TITRE_ACCES VARCHAR2(40),
    LIBELLE_ETB_TITRE_ACCES VARCHAR2(100),
    CODE_DEPT_TITRE_ACCES VARCHAR2(100),
    CODE_PAYS_TITRE_ACCES VARCHAR2(3),
    SOURCE_INSERT_DATE DATE default sysdate not null
)
/

create table SYGAL_UNITE_RECH
(
    SOURCE_ID VARCHAR2(50 char),
    STRUCTURE_ID VARCHAR2(10) not null,
    ID VARCHAR2(10) not null,
    SOURCE_INSERT_DATE DATE default sysdate not null
)
/

create table SYGAL_VARIABLE
(
    SOURCE_ID VARCHAR2(50 char),
    ID VARCHAR2(20),
    COD_VAP VARCHAR2(20),
    LIB_VAP VARCHAR2(47),
    PAR_VAP VARCHAR2(100),
    DATE_DEB_VALIDITE DATE,
    DATE_FIN_VALIDITE DATE,
    SOURCE_INSERT_DATE DATE default sysdate not null
)
/

create table SYGAL_THESE
(
    SOURCE_ID VARCHAR2(50 char),
    ID NUMBER(8) not null,
    ETA_THS VARCHAR2(1),
    DOCTORANT_ID NUMBER(8),
    COD_DIS NUMBER(7),
    LIB_INT1_DIS VARCHAR2(200),
    LIB_THS VARCHAR2(800),
    COD_LNG VARCHAR2(4),
    DAT_DEB_THS DATE,
    ECOLE_DOCT_ID VARCHAR2(4),
    UNITE_RECH_ID VARCHAR2(10),
    LIB_PAY VARCHAR2(40),
    LIB_ETB_COT VARCHAR2(120),
    TEM_AVENANT VARCHAR2(1),
    DAT_PREV_SOU DATE,
    TEM_SOU_AUT_THS VARCHAR2(1),
    DAT_AUT_SOU_THS DATE,
    DAT_SOU_THS DATE,
    DAT_FIN_CFD_THS DATE,
    COD_NEG_TRE VARCHAR2(1),
    ETA_RPD_THS VARCHAR2(1),
    CORRECTION_POSSIBLE VARCHAR2(11),
    COD_ANU_PRM_IAE VARCHAR2(20),
    DAT_ABANDON DATE,
    DAT_TRANSFERT_DEP DATE,
    SOURCE_INSERT_DATE DATE default sysdate not null
)
/

