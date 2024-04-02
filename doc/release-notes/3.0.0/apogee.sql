----------------------------------------------------------
-- Apogée : modification de vues/tables pour l'API V3.
----------------------------------------------------------

--
-- NB : Seules les vues/tables modifiées existent en version "V3" (ex: V_SYGAL_DOCTORANT_V3).
--      Les vues/tables inchangées restent en version "V2".
--

create or replace view V_SYGAL_DOCTORANT_V3 as
    select distinct
        ind.cod_etu as source_code, -- Identifiant unique
        'apogee' as source_id, -- identifiant unique de la source
        ind.cod_etu as id, -- Identifiant du doctorant
        ind.cod_etu as individu_id, -- Identifiant de l'individu
        ind.cod_nne_ind||ind.cod_cle_nne_ind as ine, -- INE du doctorant
        ind.cod_etu as code_apprenant_in_source -- Numero étudiant Apogée <<<<<<<<<<<<< nouvelle colonne
    from these_hdr_sout ths
             join diplome        dip on dip.cod_dip     = ths.cod_dip
             join typ_diplome    tpd on tpd.cod_tpd_etb = dip.cod_tpd_etb
             join individu       ind on ind.cod_ind     = ths.cod_ind --and ind.cod_etu != 21009539 -- Exclusion du compte de test Aaron AAABA
             join pays           pay on pay.cod_pay     = ind.cod_pay_nat
    where ths.cod_ths_trv =  '1' -- Exclusion des travaux
      and dip.cod_tpd_etb in ('39', '40')
      and tpd.eta_ths_hdr_drt = 'T' -- Inscription en these
      and tpd.tem_sante = 'N' -- Exclusion des theses d exercice
      and cod_etu is not null
;



--drop table SYGAL_DOCTORANT_V3;
create table SYGAL_DOCTORANT_V3 as select * from V_SYGAL_DOCTORANT_V3;
alter table SYGAL_DOCTORANT_V3 add source_insert_date date default sysdate;
