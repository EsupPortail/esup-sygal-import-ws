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

--
-- Vue fournissant les "variables d'environnement" requises.
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

--------------------------------------------------------------------------------

--
-- Vues des seules origines de financement à prendre en compte (éventuellement renommées).
--
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
select "ID","SOURCE_ID","COD_OFI","LIC_OFI","LIB_OFI" from tmp
;