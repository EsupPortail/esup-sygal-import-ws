--
--
-- SyGAL
-- =====
--
-- Web Service d'import de données
-- -------------------------------
--
-- Vues Apogée propre à votre établissement.
--
-- ATTENTION: script à personnaliser!
--

--
-- Vue fournissant les "variables d'environnement" requises.
--
create view V_SYGAL_VARIABLE_MANU as
  select
    'apogee' as source_id,
    'EMAIL_ASSISTANCE' as id,
    'EMAIL_ASSISTANCE' as cod_vap,
    'Adresse mail de l''assistance utilisateur' as lib_vap,
    'assistance-sygal@univ.fr' as par_vap, -----------------------------> à personnaliser
    to_date('2017-01-01', 'YYYY-MM-DD') as DATE_DEB_VALIDITE,
    to_date('9999-12-31', 'YYYY-MM-DD') as DATE_FIN_VALIDITE
  from dual
  union all
  select
    'apogee' as source_id,
    'EMAIL_BU' as id,
    'EMAIL_BU' as cod_vap,
    'Adresse mail de contact pour les aspects BU' as lib_vap,
    'bu@univ.fr' as par_vap, ------------------------------------------> à personnaliser
    to_date('2017-01-01', 'YYYY-MM-DD') as DATE_DEB_VALIDITE,
    to_date('9999-12-31', 'YYYY-MM-DD') as DATE_FIN_VALIDITE
  from dual
  union all
  select
    'apogee' as source_id,
    'EMAIL_BDD' as id,
    'EMAIL_BDD' as cod_vap,
    'Adresse mail de contact pour les aspects Doctorat' as lib_vap,
    'doctorat@univ.fr' as par_vap, -----------------------------------------> à personnaliser
    to_date('2017-01-01', 'YYYY-MM-DD') as DATE_DEB_VALIDITE,
    to_date('9999-12-31', 'YYYY-MM-DD') as DATE_FIN_VALIDITE
  from dual
/

--
-- Vue traduisant les codes rôles en usage dans votre établissement vers les codes compris par SyGAL.
--
create view V_SYGAL_ROLE_TR as
  with tmp(FROM_COD_ROJ, TO_COD_ROJ) as (
      select 'A', 'A' from dual union -- A : Membre absent
      select 'B', 'B' from dual union -- B : Co-encadrant
      select 'C', 'C' from dual union -- C : Chef de laboratoire
      select 'D', 'D' from dual union -- D : Directeur de thèse
      select 'K', 'K' from dual union -- K : Co-directeur de thèse
      select 'M', 'M' from dual union -- M : Membre du jury
      select 'P', 'P' from dual union -- P : Président du jury
      select 'R', 'R' from dual       -- R : Rapporteur du jury
    )
    select * from tmp
/

--
-- Vues des seules origines de financement à prendre en compte (éventuellement renommées).
--
create view V_SYGAL_ORIGINE_FINANCEMENT as
with tmp(ID, SOURCE_ID, COD_OFI, LIC_OFI, LIB_OFI) as (
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
)
select * from tmp
/
