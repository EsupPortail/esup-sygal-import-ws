--
--
-- SyGAL
-- =====
--
-- Web Service d'import de données
-- -------------------------------
--
-- Vues Physalis propre à votre établissement.
--
-- ATTENTION: script à personnaliser!
--

CREATE OR REPLACE VIEW V_SYGAL_VARIABLE AS
select
    'physalis' as source_id,
    'ETB_LIB' as id,
    'ETB_LIB' as cod_vap,
    'Nom de l''établissement de référence' as lib_vap,
    ------------ CORRIGEZ, SVP -----------
    'L''Étable ISSEMENT' as par_vap,
    --------------------------------------
    to_date('2017-01-01', 'YYYY-MM-DD') as DATE_DEB_VALIDITE,
    to_date('9999-12-31', 'YYYY-MM-DD') as DATE_FIN_VALIDITE
from dual
union all
select
    'physalis' as source_id,
    'ETB_LIB_NOM_RESP' as id,
    'ETB_LIB_NOM_RESP' as cod_vap,
    'Nom du responsable de l''établissement' as lib_vap,
    ------------ CORRIGEZ, SVP -----------
    'M. Alain Térieur' as par_vap,
    --------------------------------------
    to_date('2017-01-01', 'YYYY-MM-DD') as DATE_DEB_VALIDITE,
    to_date('9999-12-31', 'YYYY-MM-DD') as DATE_FIN_VALIDITE
from dual
union all
select
    'physalis' as source_id,
    'ETB_LIB_TIT_RESP' as id,
    'ETB_LIB_TIT_RESP' as cod_vap,
    'Titre du responsable de l''établissement' as lib_vap,
    ------------ CORRIGEZ, SVP -----------
    'Directeur' as par_vap,
    --------------------------------------
    to_date('2017-01-01', 'YYYY-MM-DD') as DATE_DEB_VALIDITE,
    to_date('9999-12-31', 'YYYY-MM-DD') as DATE_FIN_VALIDITE
from dual
union all
select
    'physalis' as source_id,
    'ETB_ART_ETB_LIB' as id,
    'ETB_ART_ETB_LIB' as cod_vap,
    'Article du nom de l''etb de référence' as lib_vap,
    ------------ CORRIGEZ, SVP -----------
    'Le' as par_vap,
    --------------------------------------
    to_date('2017-01-01', 'YYYY-MM-DD') as DATE_DEB_VALIDITE,
    to_date('9999-12-31', 'YYYY-MM-DD') as DATE_FIN_VALIDITE
from dual
union all
select
    'physalis' as source_id,
    'EMAIL_ASSISTANCE' as id,
    'EMAIL_ASSISTANCE' as cod_vap,
    'Adresse mail de l''assistance utilisateur' as lib_vap,
    ------------ CORRIGEZ, SVP -----------
    'assistance-sygal@etable-issement.fr' as par_vap,
    --------------------------------------
    to_date('2017-01-01', 'YYYY-MM-DD') as DATE_DEB_VALIDITE,
    to_date('9999-12-31', 'YYYY-MM-DD') as DATE_FIN_VALIDITE
from dual
union all
select
    'physalis' as source_id,
    'EMAIL_BU' as id,
    'EMAIL_BU' as cod_vap,
    'Adresse mail de contact de la BU' as lib_vap,
    ------------ CORRIGEZ, SVP -----------
    'bu@etable-issement.fr' as par_vap,
    --------------------------------------
    to_date('2017-01-01', 'YYYY-MM-DD') as DATE_DEB_VALIDITE,
    to_date('9999-12-31', 'YYYY-MM-DD') as DATE_FIN_VALIDITE
from dual
union all
select
    'physalis' as source_id,
    'EMAIL_BDD' as id,
    'EMAIL_BDD' as cod_vap,
    'Adresse mail de contact de la Maison des doctorats' as lib_vap,
    ------------ CORRIGEZ, SVP -----------
    'doctorat@etable-issement.fr' as par_vap,
    --------------------------------------
    to_date('2017-01-01', 'YYYY-MM-DD') as DATE_DEB_VALIDITE,
    to_date('9999-12-31', 'YYYY-MM-DD') as DATE_FIN_VALIDITE
from dual
;
