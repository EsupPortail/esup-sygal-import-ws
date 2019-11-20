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
