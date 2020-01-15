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


create view V_SYGAL_SOURCE as
select
    'physalis' as id,
    'physalis' as code,
    'Physalis' as libelle,
    1        as importable
from dual
/

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "API_SCOLARITE"."V_SYGAL_ACTEUR" ("ID", "SOURCE_ID", "INDIVIDU_ID", "THESE_ID", "ACTEUR_ETABLISSEMENT_ID", "COD_PAY_ETB", "LIB_CPS", "LIB_PAY_ETB", "COD_PER", "COD_CPS", "ROLE_ID", "COD_ROJ_COMPL", "LIB_ROJ_COMPL", "TEM_HAB_RCH_PER", "TEM_RAP_RECU") AS 
  SELECT 
   i.no_individu||2 || T.ID_THESE || ro.id as ID,
 'physalis' as SOURCE_ID,
  i.no_individu||2 AS INDIVIDU_ID,
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
 ASS_ID_PERE = (select ass_id from GRHUM.ASSOCIATION where ass_code = 'D_TYPE_JURY')
AND ASS_CODE != 'D_JR_INV'
union 
 SELECT 
    i.no_individu||2 || T.ID_THESE || ro.id as ID,
 'physalis' as SOURCE_ID,
  i.no_individu || 2 AS INDIVIDU_ID,
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
 ASS_ID_PERE = (select ass_id from GRHUM.ASSOCIATION where ass_code = 'D_DIR')
AND ASS_CODE != 'D_JR_INV'
union
SELECT 
    i.no_individu||2 || T.ID_THESE || ro.id as ID,
 'physalis' as SOURCE_ID,
  i.no_individu || 2 AS INDIVIDU_ID,
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
WHERE-- T.ID_THESE = 13 -- a modifier
-- membre du jury sauf invité
 ASS_ID_PERE = (select ass_id from GRHUM.ASSOCIATION where ass_code = 'D_JURY')
AND ASS_CODE != 'D_JR_INV';
--------------------------------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "API_SCOLARITE"."V_SYGAL_DOCTORANT" ("ID", "SOURCE_ID", "INDIVIDU_ID", "INE") AS 
  select D.NO_INDIVIDU ||1 as ID , 'physalis' as SOURCE_ID, d.NO_INDIVIDU ||1 as INDIVIDU_ID , e.ETUD_CODE_INE as ine
from RECHERCHE.DOCTORANT d
left outer join grhum.etudiant e on d.ETUD_NUMERO =  e.ETUD_NUMERO;


--------------------------------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "API_SCOLARITE"."V_SYGAL_ECOLE_DOCT" ("STRUCTURE_ID", "SOURCE_ID", "ID") AS 
  SELECT 
distinct
etab_cot.c_structure   AS STRUCTURE_ID,
'physalis' as source_id,
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

--------------------------------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "API_SCOLARITE"."V_SYGAL_ETABLISSEMENT" ("STRUCTURE_ID", "SOURCE_ID", "ID", "CODE") AS 
  SELECT 
distinct
etab_cot.c_structure   AS STRUCTURE_ID,
'physalis' as source_id,
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
 th.MJT_ORDRE || th.CP_ORDRE || th.ID_THESE  AS ID,
 th.MJT_ORDRE || th.CP_ORDRE || th.ID_THESE as code
 from RECHERCHE.MEMBRE_JURY_THESE th
 where th.LIBELLE_STRUCT_EXTERNE is not null 
 
 union
 
 select distinct th.C_RNE  AS STRUCTURE_ID,
 'physalis' as source_id,
 th.C_RNE AS ID,
 th.C_RNE as code
 from RECHERCHE.MEMBRE_JURY_THESE th
 where th.C_RNE is not null
 ;

--------------------------------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "API_SCOLARITE"."V_SYGAL_FINANCEMENT" ("ID", "SOURCE_ID", "THESE_ID", "FINANCEUR", "QUOTITE_FINANCEMENT", "DATE_DEBUT_FINANCEMENT", "DATE_FIN_FINANCEMENT", "ANNEE_ID", "ORIGINE_FINANCEMENT_ID", "COMPLEMENT_FINANCEMENT") AS 
  select id_these|| f.id_financement as ID  , 
       'physalis' as source_id,
       id_these   as these_id,
       --           as annee_id,
       -- p.PERS_LIBELLE as employeur, 
     --  p2.PERS_LIBELLE as financeur, 
     0 as financeur,
       -- ra2.RAS_QUOTITE as quotite_financeur,
       0 as quotite_financement,
        f.DATE_DEBUT_FINANCEMENT  as date_debut_financement , 
        f.DATE_FIN_FINANCEMENT as date_fin_financement,
        
        
        case 
        when f.DATE_DEBUT_FINANCEMENT  is not null then  extract (YEAR from  f.DATE_DEBUT_FINANCEMENT) 
        else  2019 
        end as annee_id,
  --      ann.ANNEE_UNIV
         typef.ID_SYGAL as origine_financement_id,
        'NON RENSEIGNE' as COMPLEMENT_FINANCEMENT
from recherche.doctorant_these dt



--left outer join RECHERCHE.doctorant doc on doc.ID_DOCTORANT = dt.ID_DOCTORANT
--left outer join V_SYGAL_THESE_ANNEE_UNIV ann on ann.THESE_ID = dt.ID_THESE


left outer join accords.avenant a on a.con_ordre = dt.con_ordre

-- financement
left outer join RECHERCHE.DOCTORANT_FINANCEMENT f on f.AVT_ORDRE = a.avt_ordre
left outer join grhum.repart_association ra on ra.ras_id = f.ras_id
left outer join grhum.personne p on p.pers_id = ra.pers_id
left outer join V_SYGAL_PHYSALIS_FINANCEMENT typef on  typef.ID_PHYSALIS = f.ID_TYPE_FINANCEMENT

-- financeur
left outer join recherche.doctorant_financeur f2 on f.ID_FINANCEMENT = f2.ID_FINANCEMENT
left outer join grhum.repart_association ra2 on ra2.ras_id = f2.ras_id
left outer join grhum.personne p2 on p2.pers_id = ra2.pers_id

where typef.ID_SYGAL is not null and f.DATE_DEBUT_FINANCEMENT is not null;

--------------------------------------------------------------------------------



  CREATE OR REPLACE FORCE EDITIONABLE VIEW "API_SCOLARITE"."V_SYGAL_INDIVIDU" ("ID", "TYPE", "SOURCE_ID", "CIV", "LIB_NOM_PAT_IND", "LIB_NOM_USU_IND", "LIB_PR1_IND", "LIB_PR2_IND", "LIB_PR3_IND", "EMAIL", "DATE_NAI_IND", "LIB_NAT", "COD_PAY_NAT", "SUPANN_ID") AS 
  SELECT 
 distinct( i.no_individu) || 1 AS ID,
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

union
SELECT 
 distinct( i.no_individu) || 2 AS ID,
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
 ASS_ID_PERE = (select ass_id from GRHUM.ASSOCIATION where ass_code = 'D_TYPE_JURY')
AND ASS_CODE != 'D_JR_INV'  --AND to_char(T.DATE_SOUTENANCE ,'YYYY')='2016'
;


--------------------------------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "API_SCOLARITE"."V_SYGAL_MV_EMAIL" ("LAST_UPDATE", "ID", "EMAIL") AS 
  with tmp(LAST_UPDATE, ID, EMAIL) as (
    select null, null, null from dual
    )
    select "LAST_UPDATE","ID","EMAIL" from tmp where 0=1;


--------------------------------------------------------------------------------



  CREATE OR REPLACE FORCE EDITIONABLE VIEW "API_SCOLARITE"."V_SYGAL_ORIGINE_FINANCEMENT" ("ID", "SOURCE_ID", "COD_OFI", "LIC_OFI", "LIB_OFI") AS 
  with tmp(ID, SOURCE_ID, COD_OFI, LIC_OFI, LIB_OFI) as (
    select '10', 'physalis', '10', 'SALARIE',     'Etudiant salarié'                         from dual union all
    select '11', 'physalis', '11', 'SANS FIN',    'Sans financement'                         from dual union all
    select '13', 'physalis', '13', 'DOT EPSCP',   'Dotation des EPSCP'                       from dual union all
    select '14', 'physalis', '14', 'DOT EPST',    'Dotation des EPST'                        from dual union all
    select '15', 'physalis', '15', 'POLYTECH',    'Programmes Spé. Normaliens, Polytechnici' from dual union all
    select '16', 'physalis', '16', 'HANDICAP',    'Programme Spécifique Handicap'            from dual union all
    select '17', 'physalis', '17', 'DEFENSE',     'Ministère de la Défense (dont DGA)'       from dual union all
    select '18', 'physalis', '18', 'AGRICULTUR',  'Ministère de l''Agriculture'              from dual union all
    select '19', 'physalis', '19', 'AFF ETRANG',  'Ministère des Affaires Etrangères'        from dual union all
    select '20', 'physalis', '20', 'SANTE',       'Ministère de la Santé'                    from dual union all
    select '21', 'physalis', '21', 'AUTRES MIN',  'Autres Ministères'                        from dual union all
    select '22', 'physalis', '22', 'DOT EPIC',    'Dotation des EPIC'                        from dual union all
    select '23', 'physalis', '23', 'DOT EPA',     'Dotation des EPA'                         from dual union all
    select '24', 'physalis', '24', 'NORMANDIE',   'Région Normandie'                         from dual union all
    select '25', 'physalis', '25', 'AUT COLLEC',  'Autre Collectivité Territoriale'          from dual union all
    select '26', 'physalis', '26', 'ANR',         'ANR'                                      from dual union all
    select '27', 'physalis', '27', 'IDEX',        'IDEX'                                     from dual union all
    select '28', 'physalis', '28', 'PIA',         'Autres dispositifs du PIA (dont LABEX)'   from dual union all
    select '29', 'physalis', '29', 'AUT AFFPR',   'Autres Finan. Pub. d''Agences Françaises' from dual union all
    select '30', 'physalis', '30', 'FI PUB PRV',  'Financements Mixtes Public Privé'         from dual union all
    select '31', 'physalis', '31', 'CIFRE',       'Conventions CIFRE'                        from dual union all
    select '32', 'physalis', '32', 'PART RECH',   'Partenariat de Recherche'                 from dual union all
    select '33', 'physalis', '33', 'MECENAT',     'Mécénat y compris Fondations et Asso.'    from dual union all
    select '34', 'physalis', '34', 'ERC',         'ERC'                                      from dual union all
    select '35', 'physalis', '35', 'MARIE CURI',  'Actions Marie Sklodowska Curie'           from dual union all
    select '36', 'physalis', '36', 'ERASMUS',     'ERASMUS'                                  from dual union all
    select '37', 'physalis', '37', 'AUT PRO EU',  'Autre Programme Européen'                 from dual union all
    select '38', 'physalis', '38', 'GOUV EUROP',  'Gouvernement Etranger Européen'           from dual union all
    select '39', 'physalis', '39', 'GOUV NON E',  'Gouvernement Etranger Hors Europe'        from dual union all
    select '40', 'physalis', '40', 'AUT FI ETR',  'Autres Financements Etrangers'            from dual union all
    select '41', 'physalis', '41', 'ENT ETR',     'Entreprise Etrangère'                     from dual union all
    select '42', 'physalis', '42', 'ORG FC',      'Financements Organismes FC'               from dual union all
    select '43', 'physalis', '43', 'ORG INTER',   'Organismes Internationaux'                from dual
  )
  select "ID","SOURCE_ID","COD_OFI","LIC_OFI","LIB_OFI" from tmp;


--------------------------------------------------------------------------------



  CREATE OR REPLACE FORCE EDITIONABLE VIEW "API_SCOLARITE"."V_SYGAL_PHYSALIS_FINANCEMENT" ("ID_PHYSALIS", "ID_SYGAL") AS 
  select  RECHERCHE.TYPE_FINANCEMENT.ID_TYPE_FINANCEMENT as id_physalis   ,
CASE RECHERCHE.TYPE_FINANCEMENT.ID_TYPE_FINANCEMENT

WHEN 52  THEN 13
WHEN 53  THEN 14
WHEN 54  THEN 15
WHEN 55  THEN 16
WHEN 56  THEN 17
WHEN 57  THEN 18
WHEN 58  THEN 19
WHEN 59  THEN 20
WHEN 60  THEN 21
WHEN 61  THEN 23
WHEN 62  THEN 24
WHEN 63  THEN 29
WHEN 64  THEN 26
WHEN 65  THEN 27
WHEN 66  THEN 28
WHEN 70  THEN 32
WHEN 71  THEN 33
WHEN 72  THEN 37
WHEN 73  THEN 34
WHEN 74  THEN 35
WHEN 75  THEN 36
WHEN 76  THEN 37
WHEN 77  THEN 40
WHEN 78  THEN 38
WHEN 79  THEN 39
WHEN 80  THEN 40
WHEN 81  THEN 42
WHEN 82  THEN 43
WHEN 83  THEN 31
else   11
end as id_sygal
from RECHERCHE.TYPE_FINANCEMENT;


--------------------------------------------------------------------------------



  CREATE OR REPLACE FORCE EDITIONABLE VIEW "API_SCOLARITE"."V_SYGAL_ROLE" ("ID", "SOURCE_ID", "LIB_ROJ", "LIC_ROJ") AS 
  SELECT case ID
        when 301 THEN 'D'
        when 314 THEN 'K'
        when 308 THEN 'M'
        when 310 THEN 'R'
        when 307 THEN 'P'
        when 315 THEN 'B'
        else 'Z'
        end as ID,
        "SOURCE_ID","LIB_ROJ","LIC_ROJ" 
  from sygal_role_tmp
 ;


--------------------------------------------------------------------------------



  CREATE OR REPLACE FORCE EDITIONABLE VIEW "API_SCOLARITE"."V_SYGAL_STRUCTURE" ("SOURCE_ID", "TYPE_STRUCTURE_ID", "ID", "SIGLE", "LIBELLE", "CODE_PAYS", "LIBELLE_PAYS") AS 
  select 
distinct
'physalis' as source_id,
'etablissement' as TYPE_STRUCTURE_ID,
etab_cot.c_structure as   ID,
null as sigle,
etab_cot.LL_STRUCTURE as libelle,
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
null as sigle,
etab_cot.LL_STRUCTURE as libelle,
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
null as sigle,
etab_cot.LL_STRUCTURE as libelle,
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
  null as sigle,
 th.LIBELLE_STRUCT_EXTERNE as libelle,
 null as code_pays,
 null as libelle_pays
 from RECHERCHE.MEMBRE_JURY_THESE th
 where th.LIBELLE_STRUCT_EXTERNE is not null
 
 union
 
 select 
 'physalis' as source_id,
 'etablissement' as TYPE_STRUCTURE_ID,
 r.C_RNE  AS ID,
  null as sigle,
 r.LL_RNE as libelle,
 '100' as code_pays,
 'FRANCE' as libelle_pays
 from RECHERCHE.MEMBRE_JURY_THESE th left outer join   grhum.rne  r on th.c_rne = r.c_rne
 where th.C_RNE is not null
 ;


--------------------------------------------------------------------------------

--------------------------------------------------------------------------------



/*
create view SYGAL_INDIVIDU as
  ...
*/

/*
create view SYGAL_DOCTORANT as
  ...
*/

/*
create view SYGAL_THESE as
  ...
*/

/*
create view SYGAL_STRUCTURE as
  ...
*/

/*
create view SYGAL_ECOLE_DOCT as
  ...
*/

/*
create view SYGAL_UNITE_RECH as
  ...
*/

/*
create view SYGAL_ETABLISSEMENT as
  ...
*/

/*
create view SYGAL_ACTEUR as
  ...
*/

/*
create view SYGAL_FINANCEMENT as
  ...
*/

create view SYGAL_ROLE(source_id, COD_ROJ, LIC_ROJ, LIB_ROJ) as
  select 'physalis', 'A', 'Absent',     'Membre absent'         from dual union
  select 'physalis', 'B', 'Co-encadr',  'Co-encadrant'          from dual union
  select 'physalis', 'C', 'Chef Labo',  'Chef de laboratoire'   from dual union
  select 'physalis', 'D', 'Directeur',  'Directeur de thèse'    from dual union
  select 'physalis', 'K', 'Co-direct',  'Co-directeur de thèse' from dual union
  select 'physalis', 'M', 'Membre',     'Membre du jury'        from dual union
  select 'physalis', 'P', 'Président',  'Président du jury'     from dual union
  select 'physalis', 'R', 'Rapporteur', 'Rapporteur du jury'    from dual
/

create view SYGAL_ORIGINE_FINANCEMENT as
  select '10', 'apogee', '10', 'SALARIE',     'Etudiant salarié'                         from dual union all
  select '11', 'apogee', '11', 'SANS FIN',    'Sans financement'                         from dual union all
  select '13', 'apogee', '13', 'DOT EPSCP',   'Dotation des EPSCP'                       from dual union all
  select '14', 'apogee', '14', 'DOT EPST',    'Dotation des EPST'                        from dual union all
  select '15', 'apogee', '15', 'POLYTECH',    'Programmes Spé. Normaliens, Polytechnici' from dual union all
  select '16', 'apogee', '16', 'HANDICAP',    'Programme Spécifique Handicap'            from dual union all
  select '17', 'apogee', '17', 'DEFENSE',     'Ministère de la Défense (dont DGA)'       from dual union all
  select '18', 'apogee', '18', 'AGRICULTUR',  'Ministère de l''Agriculture'              from dual union all
  select '19', 'apogee', '19', 'AFF ETRANG',  'Ministère des Affaires Etrangères'        from dual union all
  select '20', 'apogee', '20', 'SANTE',       'Ministère de la Santé'                    from dual union all
  select '21', 'apogee', '21', 'AUTRES MIN',  'Autres Ministères'                        from dual union all
  select '22', 'apogee', '22', 'DOT EPIC',    'Dotation des EPIC'                        from dual union all
  select '23', 'apogee', '23', 'DOT EPA',     'Dotation des EPA'                         from dual union all
  select '24', 'apogee', '24', 'NORMANDIE',   'Région Normandie'                         from dual union all
  select '25', 'apogee', '25', 'AUT COLLEC',  'Autre Collectivité Territoriale'          from dual union all
  select '26', 'apogee', '26', 'ANR',         'ANR'                                      from dual union all
  select '27', 'apogee', '27', 'IDEX',        'IDEX'                                     from dual union all
  select '28', 'apogee', '28', 'PIA',         'Autres dispositifs du PIA (dont LABEX)'   from dual union all
  select '29', 'apogee', '29', 'AUT AFFPR',   'Autres Finan. Pub. d''Agences Françaises' from dual union all
  select '30', 'apogee', '30', 'FI PUB PRV',  'Financements Mixtes Public Privé'         from dual union all
  select '31', 'apogee', '31', 'CIFRE',       'Conventions CIFRE'                        from dual union all
  select '32', 'apogee', '32', 'PART RECH',   'Partenariat de Recherche'                 from dual union all
  select '33', 'apogee', '33', 'MECENAT',     'Mécénat y compris Fondations et Asso.'    from dual union all
  select '34', 'apogee', '34', 'ERC',         'ERC'                                      from dual union all
  select '35', 'apogee', '35', 'MARIE CURI',  'Actions Marie Sklodowska Curie'           from dual union all
  select '36', 'apogee', '36', 'ERASMUS',     'ERASMUS'                                  from dual union all
  select '37', 'apogee', '37', 'AUT PRO EU',  'Autre Programme Européen'                 from dual union all
  select '38', 'apogee', '38', 'GOUV EUROP',  'Gouvernement Etranger Européen'           from dual union all
  select '39', 'apogee', '39', 'GOUV NON E',  'Gouvernement Etranger Hors Europe'        from dual union all
  select '40', 'apogee', '40', 'AUT FI ETR',  'Autres Financements Etrangers'            from dual union all
  select '41', 'apogee', '41', 'ENT ETR',     'Entreprise Etrangère'                     from dual union all
  select '42', 'apogee', '42', 'ORG FC',      'Financements Organismes FC'               from dual union all
  select '43', 'apogee', '43', 'ORG INTER',   'Organismes Internationaux'                from dual
/
