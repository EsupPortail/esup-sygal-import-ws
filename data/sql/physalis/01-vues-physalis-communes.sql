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

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

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
