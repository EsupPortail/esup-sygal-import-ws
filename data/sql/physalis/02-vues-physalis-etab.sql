--
--
-- SyGAL
-- =====
--
-- Web Service d'import de données
-- -------------------------------
--
-- Vues Physalis propre à votre établissement, à personnaliser.
--

create or replace view SYGAL_VARIABLE_MANU as
    select
        'physalis' as source_id,
        'EMAIL_ASSISTANCE' as id,
        'EMAIL_ASSISTANCE' as cod_vap,
        'Adresse mail de l''assistance utilisateur' as lib_vap,
        'assistance-sygal@univ.fr' as par_vap, -----------------------------> à personnaliser
        to_date('2017-01-01', 'YYYY-MM-DD') as DATE_DEB_VALIDITE,
        to_date('9999-12-31', 'YYYY-MM-DD') as DATE_FIN_VALIDITE
    from dual
    union all
    select
        'physalis' as source_id,
        'EMAIL_BU' as id,
        'EMAIL_BU' as cod_vap,
        'Adresse mail de contact de la BU' as lib_vap,
        'bu@univ.fr' as par_vap, ------------------------------------------> à personnaliser
        to_date('2017-01-01', 'YYYY-MM-DD') as DATE_DEB_VALIDITE,
        to_date('9999-12-31', 'YYYY-MM-DD') as DATE_FIN_VALIDITE
    from dual
    union all
    select
        'physalis' as source_id,
        'EMAIL_BDD' as id,
        'EMAIL_BDD' as cod_vap,
        'Adresse mail de contact du bureau des doctorats' as lib_vap,
        'bdd@univ.fr' as par_vap, -----------------------------------------> à personnaliser
        to_date('2017-01-01', 'YYYY-MM-DD') as DATE_DEB_VALIDITE,
        to_date('9999-12-31', 'YYYY-MM-DD') as DATE_FIN_VALIDITE
    from dual
/

create view V_SYGAL_VARIABLE as
    with tmp(cod_vap, lib_vap, par_vap) as (
        select 'ETB_ART_ETB_LIB',    'Article du nom de l''etb de référence',           'L'''                               from dual union
        select 'ETB_LIB',            'Nom de l''établissement de référence',            'Université de Caen Normandie'      from dual union
        select 'ETB_LIB_NOM_RESP',   'Nom du responsable de l''établissement',          'M. Pierre Denise'                  from dual union
        select 'ETB_LIB_TIT_RESP',   'Titre du responsable de l''établissement',        'Le Président de l''université'     from dual union
        select 'EMAIL_ASSISTANCE',   'Adresse mail de l''assistance utilisateur',       'assistance-sygal@unicaen.fr'       from dual union
        select 'EMAIL_BU',           'Adresse mail de contact de la BU',                'scd.theses@unicaen.fr'             from dual union
        select 'EMAIL_BDD',          'Adresse mail de contact du bureau des doctorats', 'recherche.doctorat@unicaen.fr'     from dual union
        select 'TRIBUNAL_COMPETENT', 'Tribunal compétent',                              'Le Tribunal Administratif de Caen' from dual
    )
    select
        'physalis' as source_id, -- Id de la source
        cod_vap    as id,
        cod_vap,
        lib_vap,
        par_vap,
        to_date('2017-01-01', 'YYYY-MM-DD') as DATE_DEB_VALIDITE,
        to_date('9999-12-31', 'YYYY-MM-DD') as DATE_FIN_VALIDITE
    from tmp
         -- + variables définies manuellement :
    union all
    select
        source_id,
        id,
        cod_vap,
        lib_vap,
        par_vap,
        DATE_DEB_VALIDITE,
        DATE_FIN_VALIDITE
    from
        V_SYGAL_VARIABLE_MANU
/
