--
-- sygal-import-ws v1.3.0
--
-- Transformation des vues SYGAL_* en tables pour réduire les temps de réponses.
-- L'utilisation de vues V_SYGAL_* perdure néanmoins comme source de données de ces tables.
-- Le contenu de ces tables sera mis à jour par un script PHP à CRONer.
--

rename SYGAL_ACTEUR              to V_SYGAL_ACTEUR ;
rename SYGAL_DOCTORANT           to V_SYGAL_DOCTORANT ;
rename SYGAL_ECOLE_DOCT          to V_SYGAL_ECOLE_DOCT ;
rename SYGAL_ETABLISSEMENT       to V_SYGAL_ETABLISSEMENT ;
rename SYGAL_FINANCEMENT         to V_SYGAL_FINANCEMENT ;
rename SYGAL_INDIVIDU            to V_SYGAL_INDIVIDU ;
rename SYGAL_ORIGINE_FINANCEMENT to V_SYGAL_ORIGINE_FINANCEMENT ;
rename SYGAL_ROLE                to V_SYGAL_ROLE ;
-- rename SYGAL_ROLE_JURY           to V_SYGAL_ROLE_JURY ; --> non applicable pour Physalis
-- rename SYGAL_ROLE_NOMENC         to V_SYGAL_ROLE_NOMENC ; --> non applicable pour Physalis
-- rename SYGAL_ROLE_TR             to V_SYGAL_ROLE_TR ; --> non applicable pour Physalis
rename SYGAL_SOURCE              to V_SYGAL_SOURCE ;
rename SYGAL_STRUCTURE           to V_SYGAL_STRUCTURE ;
rename SYGAL_THESE               to V_SYGAL_THESE ;
rename SYGAL_THESE_ANNEE_UNIV    to V_SYGAL_THESE_ANNEE_UNIV ;
rename SYGAL_TITRE_ACCES         to V_SYGAL_TITRE_ACCES ;
rename SYGAL_UNITE_RECH          to V_SYGAL_UNITE_RECH ;
rename SYGAL_VARIABLE            to V_SYGAL_VARIABLE ;
rename SYGAL_VARIABLE_MANU       to V_SYGAL_VARIABLE_MANU ;

--
-- V_SYGAL_VARIABLE
--
-- Corriger pour qu'elle interroge V_SYGAL_VARIABLE_MANU et non plus SYGAL_VARIABLE_MANU.
--
-- ...
--

create table SYGAL_ACTEUR              as select * from V_SYGAL_ACTEUR ;
create table SYGAL_DOCTORANT           as select * from V_SYGAL_DOCTORANT ;
create table SYGAL_ECOLE_DOCT          as select * from V_SYGAL_ECOLE_DOCT ;
create table SYGAL_ETABLISSEMENT       as select * from V_SYGAL_ETABLISSEMENT ;
create table SYGAL_FINANCEMENT         as select * from V_SYGAL_FINANCEMENT ;
create table SYGAL_INDIVIDU            as select * from V_SYGAL_INDIVIDU ;
create table SYGAL_ORIGINE_FINANCEMENT as select * from V_SYGAL_ORIGINE_FINANCEMENT ;
create table SYGAL_ROLE                as select * from V_SYGAL_ROLE ;
create table SYGAL_STRUCTURE           as select * from V_SYGAL_STRUCTURE ;
create table SYGAL_THESE               as select * from V_SYGAL_THESE ;
create table SYGAL_THESE_ANNEE_UNIV    as select * from V_SYGAL_THESE_ANNEE_UNIV ;
create table SYGAL_TITRE_ACCES         as select * from V_SYGAL_TITRE_ACCES ;
create table SYGAL_UNITE_RECH          as select * from V_SYGAL_UNITE_RECH ;
create table SYGAL_VARIABLE            as select * from V_SYGAL_VARIABLE ;

alter table SYGAL_ACTEUR              add inserted_on date default sysdate not null ;
alter table SYGAL_DOCTORANT           add inserted_on date default sysdate not null ;
alter table SYGAL_ECOLE_DOCT          add inserted_on date default sysdate not null ;
alter table SYGAL_ETABLISSEMENT       add inserted_on date default sysdate not null ;
alter table SYGAL_FINANCEMENT         add inserted_on date default sysdate not null ;
alter table SYGAL_INDIVIDU            add inserted_on date default sysdate not null ;
alter table SYGAL_ORIGINE_FINANCEMENT add inserted_on date default sysdate not null ;
alter table SYGAL_ROLE                add inserted_on date default sysdate not null ;
alter table SYGAL_STRUCTURE           add inserted_on date default sysdate not null ;
alter table SYGAL_THESE               add inserted_on date default sysdate not null ;
alter table SYGAL_THESE_ANNEE_UNIV    add inserted_on date default sysdate not null ;
alter table SYGAL_TITRE_ACCES         add inserted_on date default sysdate not null ;
alter table SYGAL_UNITE_RECH          add inserted_on date default sysdate not null ;
alter table SYGAL_VARIABLE            add inserted_on date default sysdate not null ;
