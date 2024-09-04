----------------------------------------------------------
-- Physalis : modification de vues/tables pour l'API V3.
----------------------------------------------------------

--
-- NB : Seules les vues/tables modifiées existent en version "V3" (ex: V_SYGAL_DOCTORANT_V3).
--      Les vues/tables inchangées restent en version "V2".
--

--
-- Doctorants : ajout de la colonne "code_apprenant_in_source" (numero étudiant).
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




create or replace view "API_SCOLARITE"."V_SYGAL_ORIGINE_FINANCEMENT_V3" as
select *
from "API_SCOLARITE"."V_SYGAL_ORIGINE_FINANCEMENT_V2"
;

--drop table SYGAL_ORIGINE_FINANCEMENT_V3;
create table SYGAL_ORIGINE_FINANCEMENT_V3 as select * from "API_SCOLARITE"."V_SYGAL_ORIGINE_FINANCEMENT_V3";
alter table SYGAL_ORIGINE_FINANCEMENT_V3 add source_insert_date date default sysdate;



--
-- Thèses : ajout trim des sauts de ligne et tabulations sur le titre.
--
CREATE VIEW "API_SCOLARITE"."V_SYGAL_THESE_V2" ("ID", "SOURCE_CODE", "SOURCE_ID", "DOCTORANT_ID", "COD_DIS", "DAT_DEB_THS", "DAT_FIN_CFD_THS", "DAT_PREV_SOU", "DAT_SOU_THS", "ETA_THS", "LIB_INT1_DIS", "LIB_THS", "UNITE_RECH_ID", "ECOLE_DOCT_ID", "COD_NEG_TRE", "CORRECTION_POSSIBLE", "DAT_AUT_SOU_THS", "LIB_ETB_COT", "LIB_PAY", "TEM_AVENANT", "TEM_SOU_AUT_THS", "COD_LNG", "ETA_RPD_THS", "COD_ANU_PRM_IAE", "DAT_TRANSFERT_DEP", "DAT_ABANDON", "CORRECTION_EFFECTUEE") AS
select ID,
       ID as SOURCE_CODE,
       --     code_apprenant,
       --   annee_universitaire,
       SOURCE_ID,
       DOCTORANT_ID,
       COD_DIS,
       DAT_DEB_THS,
       DAT_FIN_CFD_THS ,
       DAT_PREV_SOU,
       DAT_SOU_THS,
       ETA_THS,
       LIB_INT1_DIS,
       LIB_THS ,
       unite_rech_id,
       ecole_doct_id,
       COD_NEG_TRE,
       CORRECTION_POSSIBLE,
       DAT_AUT_SOU_THS,
       LIB_ETB_COT,
       LIB_PAY,
       TEM_AVENANT,
       TEM_SOU_AUT_THS,
       COD_LNG,
       ETA_RPD_THS,
       extract (YEAR from DAT_DEB_THS) as COD_ANU_PRM_IAE,
       DAT_TRANSFERT_DEP,
       DAT_ABANDON,
       null as CORRECTION_EFFECTUEE

FROM
    ( select th.ID_THESE as ID,
             case
                 when d.etud_numero >=20000 then  lpad (d.etud_numero,9,0)--code pegase
                 else  to_char(d.etud_numero)

                 end as  code_apprenant,
             --  to_char(  h.etud_numero )as code_apprenant,
             h.hist_annee_scol  as annee_universitaire ,
             'physalis' as SOURCE_ID,
             case
                 when d.etud_numero >=20000 then  lpad (d.etud_numero,9,0)--code pegase
                 else  to_char(d.etud_numero)

                 end as  DOCTORANT_ID,

             --  to_char( h.etud_numero)  as DOCTORANT_ID,
             sise.code as COD_DIS,
             av.avt_date_deb as DAT_DEB_THS,
             '' as DAT_FIN_CFD_THS ,
             th.DATE_PREV_SOUTENANCE as DAT_PREV_SOU,
             th.DATE_SOUTENANCE DAT_SOU_THS,
             case
                 when  th.DATE_SOUTENANCE  <= sysdate then 'S'
                 when DATE_FIN_ANTICIPEE  is not null THEN 'A'
                 else 'E'

                 end as ETA_THS,
             --      case A_COT.ASS_CODE
             --      when 'D_LAB_THESE' THEN c_structure
             --    end as
             sise.libelle as LIB_INT1_DIS,

             trim(CHR(09) from trim(CHR(13) from trim(CHR(10) from con.CON_OBJET))) as LIB_THS ,
             etab_cot2.c_structure AS unite_rech_id,
             etab_cot1.c_structure AS ecole_doct_id,
             '' AS COD_NEG_TRE,
             null AS CORRECTION_POSSIBLE,
             th.DATE_PREV_SOUTENANCE AS DAT_AUT_SOU_THS,
             cot.NOM_ETABLISSEMENT_COTUTELLE as LIB_ETB_COT,
             cot.PAYS_COTUTELLE AS LIB_PAY,
             '' AS TEM_AVENANT,
             '' as TEM_SOU_AUT_THS,
             '' as COD_LNG,
             null AS ETA_RPD_THS,
             row_number() over(partition by th.ID_THESE order by h.hist_annee_scol desc) as rn,
             null as COD_ANU_PRM_IAE,
             th.DATE_TRANSFERT as DAT_TRANSFERT_DEP,
             th.DATE_FIN_ANTICIPEE as  DAT_ABANDON

      from RECHERCHE.DOCTORANT_THESE th left outer join  GRHUM.SISE_DOCTORAT_ETAB gd on th.ID_SISE_DOCTORAT_ETAB=gd.ID_SISE_DOCTORAT_ETAB
                                        left outer join grhum.sise_diplome sise on gd.id_sise_diplome = sise.id_sise_diplome
                                        left outer join recherche.doctorant d on d.id_doctorant = th.id_doctorant
                                        left outer join grhum.individu_ulr i on i.no_individu = d.no_individu
                                        left outer join accords.avenant av on av.con_ordre = th.con_ordre
                                        left outer join garnuche.historique h on h.etud_numero  = d.etud_numero
                                        left outer join garnuche.insc_dipl ins on ins.hist_numero = h.hist_numero and ins.res_code <> 'Z'
                                        left outer join accords.contrat  con on th.CON_ORDRE = con.con_ordre
                                        left outer join api_scolarite.v_sygal_co_tutelle cot on cot.id_doctorant = d.id_doctorant
                                        LEFT OUTER JOIN GRHUM.REPART_ASSOCIATION RA1 ON RA1.C_STRUCTURE = Con.CON_GROUPE_PARTENAIRE
                                        LEFT OUTER JOIN GRHUM.ASSOCIATION A_COT1 ON A_COT1.ASS_ID = RA1.ASS_ID
                                        LEFT OUTER JOIN grhum.structure_ulr etab_cot1 on etab_cot1.pers_id = ra1.pers_id
                                        LEFT OUTER JOIN ACCORDS.contrat_partenaire cp1 on cp1.con_ordre = con.con_ordre and cp1.pers_id = ra1.pers_id
                                        LEFT OUTER JOIN GRHUM.REPART_ASSOCIATION RA2 ON RA2.C_STRUCTURE = Con.CON_GROUPE_PARTENAIRE
                                        LEFT OUTER JOIN GRHUM.ASSOCIATION A_COT2 ON A_COT2.ASS_ID = RA2.ASS_ID
                                        LEFT OUTER JOIN grhum.structure_ulr etab_cot2 on etab_cot2.pers_id = ra2.pers_id
                                        LEFT OUTER JOIN ACCORDS.contrat_partenaire cp2 on cp2.con_ordre = con.con_ordre and cp2.pers_id = ra2.pers_id

      WHERE  A_COT1.ASS_CODE = 'D_ED_R' AND A_COT2.ASS_CODE = 'D_LAB_THESE' and  h.hist_annee_scol <= 2021))
where rn = 1
union
select ID,
       ID as SOURCE_CODE,
       -- code_apprenant,
--annee_universitaire,
       SOURCE_ID,
       DOCTORANT_ID,
       COD_DIS,
       DAT_DEB_THS,
       DAT_FIN_CFD_THS ,
       DAT_PREV_SOU,
       DAT_SOU_THS,
       ETA_THS,
       LIB_INT1_DIS,
       LIB_THS ,
       unite_rech_id,
       ecole_doct_id,
       COD_NEG_TRE,
       CORRECTION_POSSIBLE,
       DAT_AUT_SOU_THS,
       LIB_ETB_COT,
       LIB_PAY,
       TEM_AVENANT,
       TEM_SOU_AUT_THS,
       COD_LNG,
       ETA_RPD_THS,
       extract (YEAR from DAT_DEB_THS) as COD_ANU_PRM_IAE,
       DAT_TRANSFERT_DEP,
       DAT_ABANDON,
       null as CORRECTION_EFFECTUEE
FROM
    ( select
          th.ID_THESE as ID,
          case
              when d.etud_numero >=20000 then  lpad (d.etud_numero,9,0)--code pegase
              else  to_char(d.etud_numero)

              end as  code_apprenant,
          to_number(   h.annee_universitaire) as annee_universitaire,
          'physalis' as SOURCE_ID,
          case
              when d.etud_numero >=20000 then  lpad (d.etud_numero,9,0)--code pegase
              else  to_char(d.etud_numero)

              end as  DOCTORANT_ID,
          --   h.code_apprenant as DOCTORANT_ID,
          sise.code as COD_DIS,

          av.avt_date_deb as DAT_DEB_THS,
          '' as DAT_FIN_CFD_THS ,
          th.DATE_PREV_SOUTENANCE as DAT_PREV_SOU,
          th.DATE_SOUTENANCE DAT_SOU_THS,
          case
              when  th.DATE_SOUTENANCE  <= sysdate then 'S'
              when DATE_FIN_ANTICIPEE  is not null THEN 'A'
              else 'E'

              end as ETA_THS,
          --      case A_COT.ASS_CODE
          --      when 'D_LAB_THESE' THEN c_structure
          --    end as
          sise.libelle as LIB_INT1_DIS,
          trim(CHR(09) from trim(CHR(13) from trim(CHR(10) from con.CON_OBJET))) as LIB_THS ,
          etab_cot2.c_structure AS unite_rech_id,
          etab_cot1.c_structure AS ecole_doct_id,
          '' AS COD_NEG_TRE,
          null AS CORRECTION_POSSIBLE,
          th.DATE_PREV_SOUTENANCE AS DAT_AUT_SOU_THS,
          cot.NOM_ETABLISSEMENT_COTUTELLE as LIB_ETB_COT,
          cot.PAYS_COTUTELLE AS LIB_PAY,
          '' AS TEM_AVENANT,
          '' as TEM_SOU_AUT_THS,
          '' as COD_LNG,
          null AS ETA_RPD_THS,
          row_number() over(partition by th.ID_THESE order by h.annee_universitaire desc) as rn,
          null as COD_ANU_PRM_IAE,
          th.DATE_TRANSFERT as DAT_TRANSFERT_DEP,
          th.DATE_FIN_ANTICIPEE as  DAT_ABANDON

      from RECHERCHE.DOCTORANT_THESE th left outer join  GRHUM.SISE_DOCTORAT_ETAB gd on th.ID_SISE_DOCTORAT_ETAB=gd.ID_SISE_DOCTORAT_ETAB
                                        left outer join grhum.sise_diplome sise on gd.id_sise_diplome = sise.id_sise_diplome
                                        left outer join recherche.doctorant d on d.id_doctorant = th.id_doctorant
                                        left outer join grhum.individu_ulr i on i.no_individu = d.no_individu
                                        left outer join accords.avenant av on av.con_ordre = th.con_ordre
                                        left outer join pegase_synchro.ins_flux_inscription h on h.code_apprenant= d.etud_numero
          --     left outer join garnuche.historique h on h.etud_numero  = d.etud_numero
          --    left outer join garnuche.insc_dipl ins on ins.hist_numero = h.hist_numero and ins.res_code <> 'Z'
                                        left outer join accords.contrat  con on th.CON_ORDRE = con.con_ordre
                                        left outer join api_scolarite.v_sygal_co_tutelle cot on cot.id_doctorant = d.id_doctorant
                                        LEFT OUTER JOIN GRHUM.REPART_ASSOCIATION RA1 ON RA1.C_STRUCTURE = Con.CON_GROUPE_PARTENAIRE
                                        LEFT OUTER JOIN GRHUM.ASSOCIATION A_COT1 ON A_COT1.ASS_ID = RA1.ASS_ID
                                        LEFT OUTER JOIN grhum.structure_ulr etab_cot1 on etab_cot1.pers_id = ra1.pers_id
                                        LEFT OUTER JOIN ACCORDS.contrat_partenaire cp1 on cp1.con_ordre = con.con_ordre and cp1.pers_id = ra1.pers_id
                                        LEFT OUTER JOIN GRHUM.REPART_ASSOCIATION RA2 ON RA2.C_STRUCTURE = Con.CON_GROUPE_PARTENAIRE
                                        LEFT OUTER JOIN GRHUM.ASSOCIATION A_COT2 ON A_COT2.ASS_ID = RA2.ASS_ID
                                        LEFT OUTER JOIN grhum.structure_ulr etab_cot2 on etab_cot2.pers_id = ra2.pers_id
                                        LEFT OUTER JOIN ACCORDS.contrat_partenaire cp2 on cp2.con_ordre = con.con_ordre and cp2.pers_id = ra2.pers_id

      WHERE  A_COT1.ASS_CODE = 'D_ED_R' AND A_COT2.ASS_CODE = 'D_LAB_THESE'
        and h.code_apprenant is not null)
where rn = 1;
