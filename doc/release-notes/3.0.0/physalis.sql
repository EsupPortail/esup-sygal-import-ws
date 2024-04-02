----------------------------------------------------------
-- Physalis : modification de vues/tables pour l'API V3.
----------------------------------------------------------

--
-- NB : Seules les vues/tables modifiées existent en version "V3" (ex: V_SYGAL_DOCTORANT_V3).
--      Les vues/tables inchangées restent en version "V2".
--

CREATE or replace VIEW "API_SCOLARITE"."V_SYGAL_DOCTORANT_V3" ("ID", "SOURCE_CODE", "SOURCE_ID", "INDIVIDU_ID", "INE", "CODE_APPRENANT_IN_SOURCE") AS
select
    i.pers_id  as ID ,
    i.pers_id  as SOURCE_CODE ,
    'physalis' as SOURCE_ID,
    i.pers_id as INDIVIDU_ID ,
    e.ETUD_CODE_INE as ine,
    e.ETUD_NUMERO as CODE_APPRENANT_IN_SOURCE
from RECHERCHE.DOCTORANT d left outer join grhum.INDIVIDU_ULR i on d.no_individu= i.no_individu
                           left outer join grhum.etudiant e on d.ETUD_NUMERO =  e.ETUD_NUMERO;



--drop table "API_SCOLARITE".SYGAL_DOCTORANT_V3;
create table "API_SCOLARITE".SYGAL_DOCTORANT_V3 as select * from "API_SCOLARITE".V_SYGAL_DOCTORANT_V3;
alter table "API_SCOLARITE".SYGAL_DOCTORANT_V3 add source_insert_date date default sysdate;
