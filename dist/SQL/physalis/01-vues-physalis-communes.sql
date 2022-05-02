--
--
-- SyGAL
-- =====
--
-- Web Service d'import de données
-- -------------------------------
--
-- Vues communes à tous les établissements ayant Physalis.
--


CREATE OR REPLACE FORCE EDITIONABLE VIEW "API_SCOLARITE"."V_SYGAL_MV_EMAIL" ("LAST_UPDATE", "ID", "EMAIL") AS
with tmp(LAST_UPDATE, ID, EMAIL) as (
    select null, null, null from dual
)
select "LAST_UPDATE","ID","EMAIL" from tmp where 0=1
/



CREATE VIEW "API_SCOLARITE"."V_SYGAL_ACTEUR_V2" ("ID", "SOURCE_CODE", "SOURCE_ID", "INDIVIDU_ID", "THESE_ID", "ACTEUR_ETABLISSEMENT_ID", "COD_PAY_ETB", "LIB_CPS", "LIB_PAY_ETB", "COD_PER", "COD_CPS", "ROLE_ID", "COD_ROJ_COMPL", "LIB_ROJ_COMPL", "TEM_HAB_RCH_PER", "TEM_RAP_RECU") AS
SELECT
        i.no_individu||2 || T.ID_THESE || ro.id as ID,
        i.no_individu||2 || T.ID_THESE || ro.id as SOURCE_CODE,
        'physalis' as SOURCE_ID,
        i.pers_id AS INDIVIDU_ID,
        T.ID_THESE AS THESE_ID,

        case
            when mjt.LIBELLE_STRUCT_EXTERNE is not null
                then
                    mjt.MJT_ORDRE || mjt.CP_ORDRE || mjt.ID_THESE
            else
                mjt.C_RNE
            end as ACTEUR_ETABLISSEMENT_ID,

        null as COD_PAY_ETB,
        case
            when   CORPS.LL_CORPS is null THEN  upper( MJT.TITRE_SPECIAL)
            when   MJT.TITRE_SPECIAL is null then upper(nvl(CORPS.LIBELLE_EDITION, CORPS.LL_CORPS))
            end  as  LIB_CPS,
        '' as LIB_PAY_ETB,
        '' as COD_PER,
        corps.c_corps as COD_CPS ,

        case ASS_CODE
            WHEN 'D_JR_PRES' THEN 'P'
            WHEN 'D_JR_MEM'  THEN 'M'
            WHEN 'D_DIR'  THEN 'D'
            end as    ROLE_ID,

        '' as COD_ROJ_COMPL,
        '' as LIB_ROJ_COMPL,
        'N' as TEM_HAB_RCH_PER,
        '' as TEM_RAP_RECU

FROM RECHERCHE.DOCTORANT D
         LEFT OUTER JOIN RECHERCHE.DOCTORANT_THESE T ON D.ID_DOCTORANT = T.ID_DOCTORANT
         INNER JOIN RECHERCHE.MEMBRE_JURY_THESE MJT ON MJT.ID_THESE = T.ID_THESE
         LEFT OUTER JOIN grhum.CORPS ON CORPS.C_CORPS = MJT.C_CORPS
         LEFT OUTER JOIN grhum.RNE ON RNE.C_RNE = MJT.C_RNE
         INNER JOIN ACCORDS.CONTRAT_PARTENAIRE CP ON CP.CP_ORDRE = MJT.CP_ORDRE
         INNER JOIN ACCORDS.CONTRAT C ON CP.CON_ORDRE = C.CON_ORDRE
         INNER JOIN GRHUM.INDIVIDU_ULR I ON I.PERS_ID = CP.PERS_ID
         left outer  JOIN GRHUM.COMPTE CPT on I.PERS_ID = CPT.PERS_ID
         INNER JOIN GRHUM.REPART_ASSOCIATION RA ON RA.PERS_ID = CP.PERS_ID AND RA.C_STRUCTURE = C.CON_GROUPE_PARTENAIRE
         INNER JOIN GRHUM.ASSOCIATION A ON A.ASS_ID = RA.ASS_ID
         INNER JOIN GRHUM.ASSOCIATION_RESEAU AR ON A.ASS_ID = AR.ASS_ID_FILS
         left outer join grhum.pays p on I.C_PAYS_NATIONALITE  =p.C_PAYS
         left outer join API_SCOLARITE.SYGAL_ROLE_TMP ro on ro.ID = a.ass_id
--left outer join
WHERE-- T.ID_THESE = 13 -- a modifier
-- membre du jury sauf invité
  --extract(year from d.DATE_INSC_DOCTORAT_ETAB) >= 2016 and
        ASS_ID_PERE = (select ass_id from GRHUM.ASSOCIATION where ass_code = 'D_TYPE_JURY')
  AND ASS_CODE != 'D_JR_INV'
union
SELECT
        i.no_individu||2 || T.ID_THESE || ro.id as ID,
        i.no_individu||2 || T.ID_THESE || ro.id as SOURCE_CODE,
        'physalis' as SOURCE_ID,
        i.pers_id AS INDIVIDU_ID,
        T.ID_THESE AS THESE_ID,

        case
            when mjt.C_RNE is not null then mjt.C_RNE
            when mjt.C_STRUCTURE_ETAB is not null then mjt.C_STRUCTURE_ETAB
            when mjt.C_STRUCTURE_ENTREPRISE is not null then mjt.C_STRUCTURE_ENTREPRISE
            end as   ACTEUR_ETABLISSEMENT_ID,
        null as COD_PAY_ETB,
        case
            when   CORPS.LL_CORPS is null and  mem.TITRE_SPECIAL is null THEN RAS_COMMENTAIRE
            when   CORPS.LL_CORPS is null and mem.TITRE_SPECIAL is not null  THEN  upper( mem.TITRE_SPECIAL)
            when   mem.TITRE_SPECIAL is null and  CORPS.LL_CORPS is not null then upper(nvl(CORPS.LIBELLE_EDITION, CORPS.LL_CORPS))
            end  as  LIB_CPS,
        null as LIB_PAYS_ETB,
        corps.c_corps as COD_CPS ,
        '' as COD_PER,

        case ASS_CODE
            WHEN 'D_JR_PRES' THEN 'P'
            WHEN 'D_JR_MEM'  THEN 'M'
            WHEN 'D_DIR_THESE'  THEN 'D'
            WHEN 'CO_ENCA' THEN 'B'
            WHEN 'CO_DIR' THEN 'K'
            WHEN  'D_DIR_COENC' THEN 'B'
            end as    ROLE_ID,

        '' as COD_ROJ_COMPL,
        '' as LIB_ROJ_COMPL,
        'N' as TEM_HAB_RCH_PER,
        '' as TEM_RAP_RECU

FROM RECHERCHE.DOCTORANT D
         LEFT OUTER JOIN RECHERCHE.DOCTORANT_THESE T ON D.ID_DOCTORANT = T.ID_DOCTORANT
         INNER JOIN RECHERCHE.DIRECTEUR_THESE MJT ON MJT.ID_THESE = T.ID_THESE
         LEFT OUTER JOIN grhum.RNE ON RNE.C_RNE = MJT.C_RNE
         INNER JOIN ACCORDS.CONTRAT_PARTENAIRE CP ON CP.CP_ORDRE = MJT.CP_ORDRE
         INNER JOIN ACCORDS.CONTRAT C ON CP.CON_ORDRE = C.CON_ORDRE
         INNER JOIN GRHUM.INDIVIDU_ULR I ON I.PERS_ID = CP.PERS_ID
         left outer  JOIN GRHUM.COMPTE CPT on I.PERS_ID = CPT.PERS_ID
         INNER JOIN GRHUM.REPART_ASSOCIATION RA ON RA.PERS_ID = CP.PERS_ID AND RA.C_STRUCTURE = C.CON_GROUPE_PARTENAIRE
         INNER JOIN GRHUM.ASSOCIATION A ON A.ASS_ID = RA.ASS_ID
         INNER JOIN GRHUM.ASSOCIATION_RESEAU AR ON A.ASS_ID = AR.ASS_ID_FILS
         left outer join grhum.pays p on I.C_PAYS_NATIONALITE  =p.C_PAYS
         left outer join API_SCOLARITE.SYGAL_ROLE_TMP ro on ro.ID = a.ass_id
         left outer join recherche.membre_jury_these mem on MJT.cp_ordre = mem.cp_ordre
         LEFT OUTER JOIN grhum.CORPS ON CORPS.C_CORPS = mem.C_CORPS
--left outer join
WHERE-- T.ID_THESE = 13 -- a modifier
-- membre du jury sauf invité
  --extract(year from d.DATE_INSC_DOCTORAT_ETAB) >= 2016 and
        ASS_ID_PERE = (select ass_id from GRHUM.ASSOCIATION where ass_code = 'D_DIR')
  AND ASS_CODE != 'D_JR_INV'
union
SELECT
        i.no_individu||2 || T.ID_THESE || ro.id as ID,
        i.no_individu||2 || T.ID_THESE || ro.id as SOURCE_CODE,
        'physalis' as SOURCE_ID,
        i.pers_id AS INDIVIDU_ID,
        T.ID_THESE AS THESE_ID,
        case
            when mjt.LIBELLE_STRUCT_EXTERNE is not null
                then
                    mjt.MJT_ORDRE || mjt.CP_ORDRE || mjt.ID_THESE
            else
                mjt.C_RNE
            end as ACTEUR_ETABLISSEMENT_ID,
        null as COD_PAY_ETB,
        case
            when   CORPS.LL_CORPS is null THEN  upper( MJT.TITRE_SPECIAL)
            when   MJT.TITRE_SPECIAL is null then upper(nvl(CORPS.LIBELLE_EDITION, CORPS.LL_CORPS))
            end  as  LIB_CPS,
        '' as LIB_PAYS_ETB,
        corps.c_corps as COD_CPS ,
        '' as COD_PER,

        case ASS_CODE
            WHEN 'D_JR_PRES' THEN 'P'
            WHEN 'D_JR_MEM'  THEN 'M'
            WHEN 'D_DIR_THESE'  THEN 'D'
            WHEN 'CO_ENCA' THEN 'B'
            WHEN 'CO_DIR' THEN 'K'
            WHEN  'D_DIR_COENC' THEN 'B'
            WHEN 'D_JURY_RAP' THEN 'R'
            end as    ROLE_ID,

        '' COD_ROJ_COMPL,
        '' as LIB_ROJ_COMPL,
        'N' as TEM_HAB_RCH_PER,
        '' as TEM_RAP_RECU

FROM RECHERCHE.DOCTORANT D
         LEFT OUTER JOIN RECHERCHE.DOCTORANT_THESE T ON D.ID_DOCTORANT = T.ID_DOCTORANT
         INNER JOIN RECHERCHE.MEMBRE_JURY_THESE MJT ON MJT.ID_THESE = T.ID_THESE
         LEFT OUTER JOIN grhum.CORPS ON CORPS.C_CORPS = MJT.C_CORPS
         LEFT OUTER JOIN grhum.RNE ON RNE.C_RNE = MJT.C_RNE
         INNER JOIN ACCORDS.CONTRAT_PARTENAIRE CP ON CP.CP_ORDRE = MJT.CP_ORDRE
         INNER JOIN ACCORDS.CONTRAT C ON CP.CON_ORDRE = C.CON_ORDRE
         INNER JOIN GRHUM.INDIVIDU_ULR I ON I.PERS_ID = CP.PERS_ID
         left outer  JOIN GRHUM.COMPTE CPT on I.PERS_ID = CPT.PERS_ID
         INNER JOIN GRHUM.REPART_ASSOCIATION RA ON RA.PERS_ID = CP.PERS_ID AND RA.C_STRUCTURE = C.CON_GROUPE_PARTENAIRE
         INNER JOIN GRHUM.ASSOCIATION A ON A.ASS_ID = RA.ASS_ID
         INNER JOIN GRHUM.ASSOCIATION_RESEAU AR ON A.ASS_ID = AR.ASS_ID_FILS
         left outer join grhum.pays p on I.C_PAYS_NATIONALITE  =p.C_PAYS
         left outer join API_SCOLARITE.SYGAL_ROLE_TMP ro on ro.ID = a.ass_id
--left outer join
-- T.ID_THESE = 13 -- a modifier
-- membre du jury sauf invité
where --extract(year from d.DATE_INSC_DOCTORAT_ETAB) >= 2016 and
        ASS_ID_PERE = (select ass_id from GRHUM.ASSOCIATION where ass_code = 'D_JURY')
  AND ASS_CODE != 'D_JR_INV';



CREATE VIEW "API_SCOLARITE"."V_SYGAL_DOCTORANT_V2" ("ID", "SOURCE_CODE", "SOURCE_ID", "INDIVIDU_ID", "INE") AS
select
    i.pers_id  as ID ,
    i.pers_id  as SOURCE_CODE ,
    'physalis' as SOURCE_ID,
    i.pers_id as INDIVIDU_ID ,
    e.ETUD_CODE_INE as ine
from RECHERCHE.DOCTORANT d left outer join grhum.INDIVIDU_ULR i on d.no_individu= i.no_individu
                           left outer join grhum.etudiant e on d.ETUD_NUMERO =  e.ETUD_NUMERO;



CREATE VIEW "API_SCOLARITE"."V_SYGAL_ECOLE_DOCT_V2" ("STRUCTURE_ID", "SOURCE_ID", "SOURCE_CODE", "ID") AS
SELECT
    distinct
    etab_cot.c_structure   AS STRUCTURE_ID,
    'physalis' as source_id,
    etab_cot.c_structure as   SOURCE_CODE,
    etab_cot.c_structure as   ID
FROM  GRHUM.REPART_ASSOCIATION RA
          LEFT OUTER JOIN GRHUM.ASSOCIATION A_COT ON A_COT.ASS_ID = RA.ASS_ID
          LEFT OUTER JOIN grhum.structure_ulr etab_cot on etab_cot.pers_id = ra.pers_id
-- adresse de l etablissement de cotutelle
          LEFT OUTER JOIN GRHUM.REPART_PERSONNE_ADRESSE RPA_COT ON RPA_COT.PERS_ID = etab_cot.PERS_ID AND RPA_COT.RPA_PRINCIPAL = 'O'
          LEFT OUTER JOIN GRHUM.ADRESSE AD_cot ON RPA_COT.ADR_ORDRE = AD_cot.ADR_ORDRE
          LEFT OUTER JOIN GRHUM.PAYS P_cot ON P_cot.C_PAYS = AD_cot.C_PAYS

WHERE  A_COT.ASS_CODE = 'D_ED_R'
;



CREATE VIEW "API_SCOLARITE"."V_SYGAL_ETABLISSEMENT_V2" ("STRUCTURE_ID", "SOURCE_ID", "SOURCE_CODE", "ID", "CODE") AS
SELECT
    distinct
    etab_cot.c_structure   AS STRUCTURE_ID,
    'physalis' as source_id,
    etab_cot.c_structure as   SOURCE_CODE,
    etab_cot.c_structure as   ID,
    etab_cot.c_structure  as code

FROM  GRHUM.REPART_ASSOCIATION RA
          LEFT OUTER JOIN GRHUM.ASSOCIATION A_COT ON A_COT.ASS_ID = RA.ASS_ID
          LEFT OUTER JOIN grhum.structure_ulr etab_cot on etab_cot.pers_id = ra.pers_id
-- adresse de l etablissement de cotutelle
          LEFT OUTER JOIN GRHUM.REPART_PERSONNE_ADRESSE RPA_COT ON RPA_COT.PERS_ID = etab_cot.PERS_ID AND RPA_COT.RPA_PRINCIPAL = 'O'
          LEFT OUTER JOIN GRHUM.ADRESSE AD_cot ON RPA_COT.ADR_ORDRE = AD_cot.ADR_ORDRE
          LEFT OUTER JOIN GRHUM.PAYS P_cot ON P_cot.C_PAYS = AD_cot.C_PAYS

WHERE  A_COT.ASS_CODE = 'D_COT_ETAB'

union

select th.MJT_ORDRE || th.CP_ORDRE || th.ID_THESE  AS STRUCTURE_ID,
       'physalis' as source_id,
       th.MJT_ORDRE || th.CP_ORDRE || th.ID_THESE  AS SOURCE_CODE,
       th.MJT_ORDRE || th.CP_ORDRE || th.ID_THESE  AS ID,
       th.MJT_ORDRE || th.CP_ORDRE || th.ID_THESE as code
from RECHERCHE.MEMBRE_JURY_THESE th
where th.LIBELLE_STRUCT_EXTERNE is not null

union

select distinct th.C_RNE  AS STRUCTURE_ID,
                'physalis' as source_id,
                th.C_RNE AS SOURCE_CODE,
                th.C_RNE AS ID,
                th.C_RNE as code
from RECHERCHE.MEMBRE_JURY_THESE th
where th.C_RNE is not null
;


CREATE VIEW "API_SCOLARITE"."V_SYGAL_PHYSALIS_FINANCEMENT_V2" ("ID_PHYSALIS", "ID_SYGAL") AS
select  RECHERCHE.TYPE_FINANCEMENT.ID_TYPE_FINANCEMENT as id_physalis   ,
        CASE RECHERCHE.TYPE_FINANCEMENT.ID_TYPE_FINANCEMENT

            WHEN 31  THEN 11
            WHEN 32  THEN 10
            WHEN 33  THEN 11
            WHEN 34  THEN 13
            WHEN 35  THEN 31
            WHEN 36  THEN 13
            WHEN 37  THEN 30
            WHEN 38  THEN 21
            WHEN 39  THEN 25
            WHEN 40  THEN 33
            WHEN 41  THEN 32
            WHEN 42  THEN 26
            WHEN 43  THEN 32
            WHEN 44  THEN 40
            WHEN 45  THEN 40
            WHEN 47  THEN 21
            WHEN 48  THEN 40
            WHEN 49  THEN 38
            WHEN 50  THEN 21
            WHEN 51  THEN 21
            WHEN 52  THEN 13
            WHEN 53  THEN 14
            WHEN 54  THEN 15
            WHEN 55  THEN 16
            WHEN 56  THEN 17
            WHEN 58  THEN 19
            WHEN 59  THEN 20
            WHEN 60  THEN 21
            WHEN 61  THEN 22
            WHEN 62  THEN 24
            WHEN 63  THEN 29
            WHEN 64  THEN 26
            WHEN 65 THEN 27
            WHEN 66 THEN 28
            WHEN 67 THEN 11
            WHEN 68 THEN 30
            WHEN 69 THEN 11
            when 70 THEN 32
            when 71 then 33
            when 72 then 37
            when 73 then 34
            when 74 then 35
            when 75 then 36
            when 76 then 37
            when 77 then 40
            when 78 then 38
            when 79 then 39
            when 80 then 40
            when 81 then 42
            when 82 then 43
            when 83 then 31

            else   11
            end as id_sygal
from RECHERCHE.TYPE_FINANCEMENT;



CREATE VIEW "API_SCOLARITE"."V_SYGAL_FINANCEMENT_V2" ("ID", "SOURCE_CODE", "AVT_ORDRE", "SOURCE_ID", "THESE_ID", "FINANCEUR", "QUOTITE_FINANCEMENT", "DATE_DEBUT_FINANCEMENT", "DATE_FIN_FINANCEMENT", "ANNEE_ID", "ORIGINE_FINANCEMENT_ID", "COMPLEMENT_FINANCEMENT", "CODE_TYPE_FINANCEMENT", "LIBELLE_TYPE_FINANCEMENT") AS
select
        id_these|| f.id_financement as ID  ,
        id_these|| f.id_financement as SOURCE_CODE,
        a.avt_ordre,
        'physalis' as source_id,
        id_these   as these_id,
        --           as annee_id,
        -- p.PERS_LIBELLE as employeur,
        --  p2.PERS_LIBELLE as financeur,
        0 as financeur,
        -- ra2.RAS_QUOTITE as quotite_financeur,
        0 as quotite_financement,
        a.AVT_DATE_DEB_EXEC  as date_debut_financement ,
        a.AVT_DATE_FIN_EXEC as date_fin_financement,

        case
            when a.AVT_DATE_DEB_EXEC  is not null then  extract (YEAR from  a.AVT_DATE_DEB_EXEC)
            else  2019
            end as annee_id,
        --      ann.ANNEE_UNIV
        typef.ID_SYGAL as origine_financement_id,
        'NON RENSEIGNE' as COMPLEMENT_FINANCEMENT,
        'A' as CODE_TYPE_FINANCEMENT ,
        'TODO' as LIBELLE_TYPE_FINANCEMENT
from recherche.doctorant_these dt

         --left outer join RECHERCHE.doctorant doc on doc.ID_DOCTORANT = dt.ID_DOCTORANT
--left outer join V_SYGAL_THESE_ANNEE_UNIV_V2 ann on ann.THESE_ID = dt.ID_THESE

         left outer join accords.avenant a on a.con_ordre = dt.con_ordre

-- financement
         left outer join RECHERCHE.DOCTORANT_FINANCEMENT f on f.AVT_ORDRE = a.avt_ordre
         left outer join grhum.repart_association ra on ra.ras_id = f.ras_id
         left outer join grhum.personne p on p.pers_id = ra.pers_id
         left outer join api_scolarite.V_SYGAL_PHYSALIS_FINANCEMENT_V2 typef on  typef.ID_PHYSALIS = f.ID_TYPE_FINANCEMENT

-- financeur
         left outer join recherche.doctorant_financeur f2 on f.ID_FINANCEMENT = f2.ID_FINANCEMENT
         left outer join grhum.repart_association ra2 on ra2.ras_id = f2.ras_id
         left outer join grhum.personne p2 on p2.pers_id = ra2.pers_id
where extract (YEAR from  a.AVT_DATE_DEB_EXEC) >= 2016

--where typef.ID_SYGAL is not null and f.DATE_DEBUT_FINANCEMENT is not null
--where dt.id_these=272
;



CREATE VIEW "API_SCOLARITE"."V_SYGAL_INDIVIDU_V2" ("ID", "SOURCE_CODE", "TYPE", "SOURCE_ID", "CIV", "LIB_NOM_PAT_IND", "LIB_NOM_USU_IND", "LIB_PR1_IND", "LIB_PR2_IND", "LIB_PR3_IND", "EMAIL", "DATE_NAI_IND", "LIB_NAT", "COD_PAY_NAT", "SUPANN_ID") AS
SELECT
            distinct( i.pers_id) as ID,
            i.pers_id as SOURCE_CODE,
            'doctorant' as TYPE,
            'physalis' as SOURCE_ID,

            case I.c_civilite
                WHEN 'MLLE'  THEN 'MME.'
                ELSE  I.c_civilite
                end as CIV,
            upper(I.NOM_PATRONYMIQUE) AS LIB_NOM_PAT_IND,
            upper(I.NOM_USUEL) as LIB_NOM_USU_IND,
            upper( initcap(nvl(I.PRENOM_AFFICHAGE, I.PRENOM))) as LIB_PR1_IND,
            upper(garnuche.decouper_chaine_multi_seps(I.PRENOM2, ' ', 1)) as LIB_PR2_IND,
            upper(garnuche.decouper_chaine_multi_seps(I.PRENOM2, ' ', 2)) as LIB_PR3_IND,

            CASE
                WHEN cpt.CPT_EMAIL is    null THEN ' '
                ELSE cpt.CPT_EMAIL ||'@' || cpt.CPT_DOMAINE
                end as EMAIL,
            I.D_NAISSANCE AS DATE_NAI_IND,
            p.L_NATIONALITE   AS LIB_NAT,
            I.C_PAYS_NATIONALITE AS COD_PAY_NAT,
            i.pers_id as SUPANN_ID
FROM RECHERCHE.DOCTORANT D
         LEFT OUTER JOIN RECHERCHE.DOCTORANT_THESE T ON D.ID_DOCTORANT = T.ID_DOCTORANT
         INNER JOIN GRHUM.INDIVIDU_ULR I ON I.NO_INDIVIDU = D.NO_INDIVIDU
         left outer  JOIN GRHUM.COMPTE CPT on I.PERS_ID = CPT.PERS_ID and cpt.cpt_email is not null and cpt_ordre <> 60891 and cpt_ordre <> 58888
         left outer join grhum.pays p on I.C_PAYS_NATIONALITE  =p.C_PAYS
--where  extract(year from d.DATE_INSC_DOCTORAT_ETAB) >= 2016

union
--membre d'un jury
SELECT
            distinct( i.pers_id) as ID,
            i.pers_id as SOURCE_CODE,
            'acteur' as TYPE,
            'physalis' as SOURCE_ID,

            case I.c_civilite
                WHEN 'MLLE'  THEN 'MME.'
                ELSE  I.c_civilite
                end as CIV,
            case
                when  I.NOM_PATRONYMIQUE is null THEN I.NOM_USUEL
                ELSE  upper(I.NOM_PATRONYMIQUE)
                end as LIB_NOM_PAT_IND,

            upper(I.NOM_USUEL) as LIB_NOM_USU_IND,
            upper( initcap(nvl(I.PRENOM_AFFICHAGE, I.PRENOM))) as PRENOM1,
            upper(garnuche.decouper_chaine_multi_seps(I.PRENOM2, ' ', 1)) as PRENOM2,
            upper(garnuche.decouper_chaine_multi_seps(I.PRENOM2, ' ', 2)) as PRENOM3,

            CASE
                WHEN cpt.CPT_EMAIL is    null THEN ' '
                ELSE cpt.CPT_EMAIL ||'@' || cpt.CPT_DOMAINE
                end as EMAIL,
            I.D_NAISSANCE AS DATE_NAI_IND,
            p.L_NATIONALITE AS LIB_NAT,
            I.C_PAYS_NATIONALITE AS COD_PAY_NAT,
            i.pers_id as SUPANN_ID
--lower(nvl(CORPS.LIBELLE_EDITION, CORPS.LL_CORPS)) as LIBELLE_CORPS,
--case
-- when   CORPS.LL_CORPS is null THEN  upper( MJT.TITRE_SPECIAL)
-- when   MJT.TITRE_SPECIAL is null then upper(corps.LL_CORPS)
--end  as titre,
--ASS_CODE
FROM RECHERCHE.DOCTORANT D
         LEFT OUTER JOIN RECHERCHE.DOCTORANT_THESE T ON D.ID_DOCTORANT = T.ID_DOCTORANT
         INNER JOIN RECHERCHE.MEMBRE_JURY_THESE MJT ON MJT.ID_THESE = T.ID_THESE
         LEFT OUTER JOIN grhum.CORPS ON CORPS.C_CORPS = MJT.C_CORPS
         LEFT OUTER JOIN grhum.RNE ON RNE.C_RNE = MJT.C_RNE
         INNER JOIN ACCORDS.CONTRAT_PARTENAIRE CP ON CP.CP_ORDRE = MJT.CP_ORDRE
         INNER JOIN ACCORDS.CONTRAT C ON CP.CON_ORDRE = C.CON_ORDRE
         INNER JOIN GRHUM.INDIVIDU_ULR I ON I.PERS_ID = CP.PERS_ID
         left outer  JOIN GRHUM.COMPTE CPT on I.PERS_ID = CPT.PERS_ID and cpt.cpt_email is not null
         INNER JOIN GRHUM.REPART_ASSOCIATION RA ON RA.PERS_ID = CP.PERS_ID AND RA.C_STRUCTURE = C.CON_GROUPE_PARTENAIRE
         INNER JOIN GRHUM.ASSOCIATION A ON A.ASS_ID = RA.ASS_ID
         INNER JOIN GRHUM.ASSOCIATION_RESEAU AR ON A.ASS_ID = AR.ASS_ID_FILS
         left outer join grhum.pays p on I.C_PAYS_NATIONALITE  =p.C_PAYS
WHERE-- T.ID_THESE = 13 -- a modifier
-- membre du jury sauf invité
  -- extract(year from d.DATE_INSC_DOCTORAT_ETAB) >= 2016 and
        ASS_ID_PERE = (select ass_id from GRHUM.ASSOCIATION where ass_code = 'D_TYPE_JURY')
  AND ASS_CODE != 'D_JR_INV'  --AND to_char(T.DATE_SOUTENANCE ,'YYYY')='2016'
union

--directeur de these
SELECT
            distinct( i.pers_id) as ID,
            i.pers_id as SOURCE_CODE,
            'acteur' as TYPE,
            'physalis' as SOURCE_ID,

            case I.c_civilite
                WHEN 'MLLE'  THEN 'MME.'
                ELSE  I.c_civilite
                end as CIV,
            case
                when  I.NOM_PATRONYMIQUE is null THEN I.NOM_USUEL
                ELSE  upper(I.NOM_PATRONYMIQUE)
                end as LIB_NOM_PAT_IND,

            upper(I.NOM_USUEL) as LIB_NOM_USU_IND,
            upper( initcap(nvl(I.PRENOM_AFFICHAGE, I.PRENOM))) as PRENOM1,
            upper(garnuche.decouper_chaine_multi_seps(I.PRENOM2, ' ', 1)) as PRENOM2,
            upper(garnuche.decouper_chaine_multi_seps(I.PRENOM2, ' ', 2)) as PRENOM3,

            CASE
                WHEN cpt.CPT_EMAIL is    null THEN ' '
                ELSE cpt.CPT_EMAIL ||'@' || cpt.CPT_DOMAINE
                end as EMAIL,
            I.D_NAISSANCE AS DATE_NAI_IND,
            p.L_NATIONALITE AS LIB_NAT,
            I.C_PAYS_NATIONALITE AS COD_PAY_NAT,
            i.pers_id as SUPANN_ID
--lower(nvl(CORPS.LIBELLE_EDITION, CORPS.LL_CORPS)) as LIBELLE_CORPS,
--case
-- when   CORPS.LL_CORPS is null THEN  upper( MJT.TITRE_SPECIAL)
-- when   MJT.TITRE_SPECIAL is null then upper(corps.LL_CORPS)
--end  as titre,
--ASS_CODE
FROM RECHERCHE.DOCTORANT D
         LEFT OUTER JOIN RECHERCHE.DOCTORANT_THESE T ON D.ID_DOCTORANT = T.ID_DOCTORANT
         INNER JOIN RECHERCHE.DIRECTEUR_THESE MJT ON MJT.ID_THESE = T.ID_THESE
         LEFT OUTER JOIN grhum.RNE ON RNE.C_RNE = MJT.C_RNE
         INNER JOIN ACCORDS.CONTRAT_PARTENAIRE CP ON CP.CP_ORDRE = MJT.CP_ORDRE
         INNER JOIN ACCORDS.CONTRAT C ON CP.CON_ORDRE = C.CON_ORDRE
         INNER JOIN GRHUM.INDIVIDU_ULR I ON I.PERS_ID = CP.PERS_ID
         left outer  JOIN GRHUM.COMPTE CPT on I.PERS_ID = CPT.PERS_ID
         INNER JOIN GRHUM.REPART_ASSOCIATION RA ON RA.PERS_ID = CP.PERS_ID AND RA.C_STRUCTURE = C.CON_GROUPE_PARTENAIRE
         INNER JOIN GRHUM.ASSOCIATION A ON A.ASS_ID = RA.ASS_ID
         INNER JOIN GRHUM.ASSOCIATION_RESEAU AR ON A.ASS_ID = AR.ASS_ID_FILS
         left outer join grhum.pays p on I.C_PAYS_NATIONALITE  =p.C_PAYS
         left outer join API_SCOLARITE.SYGAL_ROLE_TMP ro on ro.ID = a.ass_id
         left outer join recherche.membre_jury_these mem on MJT.cp_ordre = mem.cp_ordre
         LEFT OUTER JOIN grhum.CORPS ON CORPS.C_CORPS = mem.C_CORPS
--left outer join
WHERE-- T.ID_THESE = 13 -- a modifier
-- membre du jury sauf invité
  --extract(year from d.DATE_INSC_DOCTORAT_ETAB) >= 2016 and
        ASS_ID_PERE = (select ass_id from GRHUM.ASSOCIATION where ass_code = 'D_DIR')
  AND ASS_CODE != 'D_JR_INV'
;



CREATE VIEW "API_SCOLARITE"."V_SYGAL_ROLE_V2" ("ID", "SOURCE_CODE", "SOURCE_ID", "LIB_ROJ", "LIC_ROJ") AS
SELECT case ID
           when 301 THEN 'D'
           when 314 THEN 'K'
           when 308 THEN 'M'
           when 310 THEN 'R'
           when 307 THEN 'P'
           when 315 THEN 'B'
           else 'Z'
           end as ID,
       case ID
           when 301 THEN 'D'
           when 314 THEN 'K'
           when 308 THEN 'M'
           when 310 THEN 'R'
           when 307 THEN 'P'
           when 315 THEN 'B'
           else 'Z'
           end as SOURCE_CODE,
       "SOURCE_ID","LIB_ROJ","LIC_ROJ"
from sygal_role_tmp
;



CREATE VIEW "API_SCOLARITE"."V_SYGAL_STRUCTURE_V2" ("SOURCE_ID", "TYPE_STRUCTURE_ID", "ID", "SOURCE_CODE", "SIGLE", "LIBELLE", "CODE_PAYS", "LIBELLE_PAYS") AS
select
    distinct
    'physalis' as source_id,
    'etablissement' as TYPE_STRUCTURE_ID,
    etab_cot.c_structure as   ID,
    etab_cot.c_structure as   SOURCE_CODE,
    null as sigle,
    substr(etab_cot.LL_STRUCTURE ,1,100)as libelle,
    P_cot.C_PAYS as code_pays,
    P_cot.LL_PAYS as libelle_pays

FROM  GRHUM.REPART_ASSOCIATION RA
          LEFT OUTER JOIN GRHUM.ASSOCIATION A_COT ON A_COT.ASS_ID = RA.ASS_ID
          LEFT OUTER JOIN grhum.structure_ulr etab_cot on etab_cot.pers_id = ra.pers_id


-- adresse de l etablissement de cotutelle
          LEFT OUTER JOIN GRHUM.REPART_PERSONNE_ADRESSE RPA_COT ON RPA_COT.PERS_ID = etab_cot.PERS_ID AND RPA_COT.RPA_PRINCIPAL = 'O'
          LEFT OUTER JOIN GRHUM.ADRESSE AD_cot ON RPA_COT.ADR_ORDRE = AD_cot.ADR_ORDRE
          LEFT OUTER JOIN GRHUM.PAYS P_cot ON P_cot.C_PAYS = AD_cot.C_PAYS

WHERE  A_COT.ASS_CODE = 'D_COT_ETAB'

union

SELECT
    distinct
    'physalis' as source_id,
    'ecole-doctorale' as TYPE_STRUCTURE_ID,
    etab_cot.c_structure as   ID,
    etab_cot.c_structure as   SOURCE_CODE,
    null as sigle,
    substr(etab_cot.LL_STRUCTURE ,1,100) as libelle,
    P_cot.C_PAYS as code_pays,
    P_cot.LL_PAYS as libelle_pays

FROM  GRHUM.REPART_ASSOCIATION RA
          LEFT OUTER JOIN GRHUM.ASSOCIATION A_COT ON A_COT.ASS_ID = RA.ASS_ID
          LEFT OUTER JOIN grhum.structure_ulr etab_cot on etab_cot.pers_id = ra.pers_id


-- adresse de l etablissement de cotutelle
          LEFT OUTER JOIN GRHUM.REPART_PERSONNE_ADRESSE RPA_COT ON RPA_COT.PERS_ID = etab_cot.PERS_ID AND RPA_COT.RPA_PRINCIPAL = 'O'
          LEFT OUTER JOIN GRHUM.ADRESSE AD_cot ON RPA_COT.ADR_ORDRE = AD_cot.ADR_ORDRE
          LEFT OUTER JOIN GRHUM.PAYS P_cot ON P_cot.C_PAYS = AD_cot.C_PAYS

WHERE  A_COT.ASS_CODE = 'D_ED_R'

union

SELECT
    distinct
    'physalis' as source_id,
    'unite-recherche' as TYPE_STRUCTURE_ID,
    etab_cot.c_structure as   ID,
    etab_cot.c_structure as   SOURCE_CODE,
    null as sigle,
    substr(etab_cot.LL_STRUCTURE ,1,100) as libelle,
    P_cot.C_PAYS as code_pays,
    P_cot.LL_PAYS as libelle_pays

FROM  GRHUM.REPART_ASSOCIATION RA
          LEFT OUTER JOIN GRHUM.ASSOCIATION A_COT ON A_COT.ASS_ID = RA.ASS_ID
          LEFT OUTER JOIN grhum.structure_ulr etab_cot on etab_cot.pers_id = ra.pers_id


-- adresse de l etablissement de cotutelle
          LEFT OUTER JOIN GRHUM.REPART_PERSONNE_ADRESSE RPA_COT ON RPA_COT.PERS_ID = etab_cot.PERS_ID AND RPA_COT.RPA_PRINCIPAL = 'O'
          LEFT OUTER JOIN GRHUM.ADRESSE AD_cot ON RPA_COT.ADR_ORDRE = AD_cot.ADR_ORDRE
          LEFT OUTER JOIN GRHUM.PAYS P_cot ON P_cot.C_PAYS = AD_cot.C_PAYS

WHERE  A_COT.ASS_CODE = 'D_LAB_THESE'

union

select
    'physalis' as source_id,
    'etablissement' as TYPE_STRUCTURE_ID,
    th.MJT_ORDRE || th.CP_ORDRE || th.ID_THESE  AS ID,
    th.MJT_ORDRE || th.CP_ORDRE || th.ID_THESE  AS SOURCE_CODE,
    null as sigle,
    substr(th.LIBELLE_STRUCT_EXTERNE ,1,100)  as libelle,
    null as code_pays,
    null as libelle_pays
from RECHERCHE.MEMBRE_JURY_THESE th
where th.LIBELLE_STRUCT_EXTERNE is not null

union

select
    'physalis' as source_id,
    'etablissement' as TYPE_STRUCTURE_ID,
    r.C_RNE  AS ID,
    r.C_RNE  AS SOURCE_CODE,
    null as sigle,
    substr(r.LL_RNE,1,100) as libelle,
    '100' as code_pays,
    'FRANCE' as libelle_pays
from RECHERCHE.MEMBRE_JURY_THESE th left outer join   grhum.rne  r on th.c_rne = r.c_rne
where th.C_RNE is not null;



CREATE VIEW "API_SCOLARITE"."V_SYGAL_THESE_V2" ("ID", "SOURCE_CODE", "SOURCE_ID", "DOCTORANT_ID", "COD_DIS", "DAT_DEB_THS", "DAT_FIN_CFD_THS", "DAT_PREV_SOU", "DAT_SOU_THS", "ETA_THS", "LIB_INT1_DIS", "LIB_THS", "UNITE_RECH_ID", "ECOLE_DOCT_ID", "COD_NEG_TRE", "CORRECTION_POSSIBLE", "DAT_AUT_SOU_THS", "LIB_ETB_COT", "LIB_PAY", "TEM_AVENANT", "TEM_SOU_AUT_THS", "COD_LNG", "ETA_RPD_THS", "COD_ANU_PRM_IAE", "DAT_TRANSFERT_DEP", "DAT_ABANDON", "CORRECTION_EFFECTUEE") AS
select ID,
       ID as SOURCE_CODE,
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
             h.hist_annee_scol,
             'physalis' as SOURCE_ID,
             i.pers_id as DOCTORANT_ID,
             gd.ID_SISE_DIPLOME as COD_DIS,
             av.avt_date_deb as DAT_DEB_THS,
             '' as DAT_FIN_CFD_THS ,
             th.DATE_PREV_SOUTENANCE as DAT_PREV_SOU,
             th.DATE_SOUTENANCE DAT_SOU_THS,
             case
                 when  th.DATE_SOUTENANCE is not null then 'S'
                 when DATE_FIN_ANTICIPEE  is not null THEN 'A'
                 else 'E'

                 end as ETA_THS,

             --      case A_COT.ASS_CODE
             --      when 'D_LAB_THESE' THEN c_structure



             --    end as
             sise.libelle as LIB_INT1_DIS,
             con.CON_OBJET as LIB_THS ,
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
                                        left outer join api_scolarite.co_tutelle cot on cot.id_doctorant = d.id_doctorant
                                        LEFT OUTER JOIN GRHUM.REPART_ASSOCIATION RA1 ON RA1.C_STRUCTURE = Con.CON_GROUPE_PARTENAIRE
                                        LEFT OUTER JOIN GRHUM.ASSOCIATION A_COT1 ON A_COT1.ASS_ID = RA1.ASS_ID
                                        LEFT OUTER JOIN grhum.structure_ulr etab_cot1 on etab_cot1.pers_id = ra1.pers_id
                                        LEFT OUTER JOIN ACCORDS.contrat_partenaire cp1 on cp1.con_ordre = con.con_ordre and cp1.pers_id = ra1.pers_id
                                        LEFT OUTER JOIN GRHUM.REPART_ASSOCIATION RA2 ON RA2.C_STRUCTURE = Con.CON_GROUPE_PARTENAIRE
                                        LEFT OUTER JOIN GRHUM.ASSOCIATION A_COT2 ON A_COT2.ASS_ID = RA2.ASS_ID
                                        LEFT OUTER JOIN grhum.structure_ulr etab_cot2 on etab_cot2.pers_id = ra2.pers_id
                                        LEFT OUTER JOIN ACCORDS.contrat_partenaire cp2 on cp2.con_ordre = con.con_ordre and cp2.pers_id = ra2.pers_id

      WHERE  A_COT1.ASS_CODE = 'D_ED_R' AND A_COT2.ASS_CODE = 'D_LAB_THESE' )--and h.ID_THESE =472)
where rn = 1;



CREATE VIEW "API_SCOLARITE"."V_SYGAL_THESE_ANNEE_UNIV_V2" ("SOURCE_ID", "ID", "SOURCE_CODE", "THESE_ID", "ANNEE_UNIV") AS
select
    'physalis' as SOURCE_ID     ,
    th.ID_THESE||so.fann_key as ID,
    th.ID_THESE||so.fann_key as SOURCE_CODE,

    th.ID_THESE as THESE_ID,
    nvl( so.fann_key,1900) as annee_univ

from RECHERCHE.DOCTORANT_THESE th left outer join recherche.doctorant d on d.id_doctorant = th.id_doctorant
    --left outer join garnuche.historique h on h.etud_numero  = d.etud_numero
--left outer join garnuche.insc_dipl ins on ins.hist_numero = h.hist_numero
                                  left outer join scolarite.scol_inscription_etudiant so on so.etud_numero = d.etud_numero and so.FGRA_CODE='D'
--where extract(year from d.DATE_INSC_DOCTORAT_ETAB) >= 2016
--and ( so.FGRA_CODE='D' )
--and (so.res_code <> 'Z'  )

-- or so.FGRA_CODE is not null
order  by id asc;



CREATE VIEW "API_SCOLARITE"."V_SYGAL_TITRE_ACCES_V2" ("SOURCE_ID", "ID", "SOURCE_CODE", "THESE_ID", "TYPE_ETB_TITRE_ACCES", "TITRE_ACCES_INTERNE_EXTERNE", "LIBELLE_TITRE_ACCES", "CODE_DEPT_TITRE_ACCES", "LIBELLE_ETB_TITRE_ACCES", "CODE_PAYS_TITRE_ACCES") AS
select 'physalis' as source_id  ,
       ID,
       ID as SOURCE_CODE,
       these_id,
       substr(type_etb_titre_acces,1,40),
       substr(titre_acces_interne_externe,1,100),
       substr(libelle_titre_acces,1,100),
       code_dept_titre_acces,
       substr(libelle_etb_titre_acces,1,100),
       code_pays_titre_acces
from
    (
        select

            th.ID_THESE as ID,
            --   p.ll_pays,
            th.ID_THESE as these_id ,

            type_etab.TETAB_LIBELLE as  type_etb_titre_acces,

            case  h.ETAB_CODE_DER_DIPL
                when '0760165S' THEN 'I'
                else  'E'
                end   titre_acces_interne_externe ,

            h.hist_libelle_der_dipl as libelle_titre_acces,
            etab.CODE_POSTAL as  code_dept_titre_acces,
            etab.LL_RNE as libelle_etb_titre_acces,
            h.PAYS_CODE_DER_DIPL as code_pays_titre_acces,
            row_number() over(partition by h.etud_numero order by h.hist_annee_scol desc) as rn
        from RECHERCHE.DOCTORANT e left outer join  garnuche.historique h on  e.etud_numero = h.etud_numero
                                   left outer join  recherche.doctorant_these th on e.id_doctorant=  th.id_doctorant
                                   left outer join  grhum.rne etab on etab.C_RNE = h.ETAB_CODE_DER_DIPL
                                   left outer join  grhum.type_etablissement_ulr type_etab on type_etab.TETAB_CODE = etab.TETAB_CODE
--where extract (year from e.DATE_INSC_DOCTORAT_ETAB) >=2016

    )
where rn = 1
;


--grant select on grhum.type_etablissement_ulr  to api_scolarite;



CREATE VIEW "API_SCOLARITE"."V_SYGAL_UNITE_RECH_V2" ("STRUCTURE_ID", "SOURCE_ID", "SOURCE_CODE", "ID") AS
SELECT
    distinct
    etab_cot.c_structure   AS STRUCTURE_ID,
    'physalis' as source_id,
    etab_cot.c_structure as   SOURCE_CODE,
    etab_cot.c_structure as   ID

FROM  GRHUM.REPART_ASSOCIATION RA
          LEFT OUTER JOIN GRHUM.ASSOCIATION A_COT ON A_COT.ASS_ID = RA.ASS_ID
          LEFT OUTER JOIN grhum.structure_ulr etab_cot on etab_cot.pers_id = ra.pers_id

-- adresse de l etablissement de cotutelle
          LEFT OUTER JOIN GRHUM.REPART_PERSONNE_ADRESSE RPA_COT ON RPA_COT.PERS_ID = etab_cot.PERS_ID AND RPA_COT.RPA_PRINCIPAL = 'O'
          LEFT OUTER JOIN GRHUM.ADRESSE AD_cot ON RPA_COT.ADR_ORDRE = AD_cot.ADR_ORDRE
          LEFT OUTER JOIN GRHUM.PAYS P_cot ON P_cot.C_PAYS = AD_cot.C_PAYS

WHERE  A_COT.ASS_CODE = 'D_LAB_THESE'
;


