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
