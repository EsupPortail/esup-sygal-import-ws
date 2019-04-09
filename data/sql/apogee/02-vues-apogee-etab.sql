--
--
-- SyGAL
-- =====
--
-- Web Service d'import de données
-- -------------------------------
--
-- Vues Apogée propre à votre établissement, à personnaliser.
--

--
-- Vue fournissant les "variables d'environnement" requis par SyGAL :
--   - Adresse mail de l'assistance utilisateur
--   - Adresse mail de contact de la BU
--   - Adresse mail de contact du bureau des doctorats
--
create or replace view SYGAL_VARIABLE_MANU as
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
    'Adresse mail de contact de la BU' as lib_vap,
    'bu@univ.fr' as par_vap, ------------------------------------------> à personnaliser
    to_date('2017-01-01', 'YYYY-MM-DD') as DATE_DEB_VALIDITE,
    to_date('9999-12-31', 'YYYY-MM-DD') as DATE_FIN_VALIDITE
  from dual
  union all
  select
    'apogee' as source_id,
    'EMAIL_BDD' as id,
    'EMAIL_BDD' as cod_vap,
    'Adresse mail de contact du bureau des doctorats' as lib_vap,
    'bdd@univ.fr' as par_vap, -----------------------------------------> à personnaliser
    to_date('2017-01-01', 'YYYY-MM-DD') as DATE_DEB_VALIDITE,
    to_date('9999-12-31', 'YYYY-MM-DD') as DATE_FIN_VALIDITE
  from dual
/

--
-- Vue traduisant les codes rôles en usage dans votre établissement vers les codes compris par SyGAL.
--
create or replace view SYGAL_ROLE_TR as
  select 'A', 'A' from dual union -- A : Membre absent
  select 'B', 'B' from dual union -- B : Co-encadrant
  select 'C', 'C' from dual union -- C : Chef de laboratoire
  select 'D', 'D' from dual union -- D : Directeur de thèse
  select 'K', 'K' from dual union -- K : Co-directeur de thèse
  select 'M', 'M' from dual union -- M : Membre du jury
  select 'P', 'P' from dual union -- P : Président du jury
  select 'R', 'R' from dual       -- R : Rapporteur du jury
/
