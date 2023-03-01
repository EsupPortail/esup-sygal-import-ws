--
-- Apogée.
--

create or replace view V_SYGAL_VARIABLE as
select
    'apogee'            as source_id,       -- Id de la source
    cod_vap             as id,
    cod_vap,
    lib_vap,
    par_vap,
    to_date('2017-01-01', 'YYYY-MM-DD') as DATE_DEB_VALIDITE,
    to_date('9999-12-31', 'YYYY-MM-DD') as DATE_FIN_VALIDITE
from variable_appli
where cod_vap in (
    'ETB_LIB',
    'ETB_ART_ETB_LIB',
    'ETB_LIB_TIT_RESP',
    'ETB_LIB_NOM_RESP'
);

create or replace view V_SYGAL_VARIABLE_V2 as
select
    cod_vap as source_code, -- Id unique
    'apogee' as source_id,  -- identifiant unique de la source
    cod_vap             as id,
    cod_vap,
    lib_vap,
    par_vap,
    to_date('2017-01-01', 'YYYY-MM-DD') as DATE_DEB_VALIDITE,
    to_date('9999-12-31', 'YYYY-MM-DD') as DATE_FIN_VALIDITE
from variable_appli
where cod_vap in (
    'ETB_LIB',
    'ETB_ART_ETB_LIB',
    'ETB_LIB_TIT_RESP',
    'ETB_LIB_NOM_RESP'
);

drop view V_SYGAL_VARIABLE_MANU;
