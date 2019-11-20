--
-- sygal-import-ws v1.3.0
--
-- Transformation des vues SYGAL_* en tables pour réduire les temps de réponses.
-- L'utilisation de vues V_SYGAL_* perdure néanmoins comme source de données de ces tables.
-- Le contenu de ces tables sera mis à jour par un script PHP à CRONer.
--

rename SYGAL_ACTEUR              to V_SYGAL_ACTEUR ;
rename SYGAL_DOCTORANT           to V_SYGAL_DOCTORANT ;
rename SYGAL_ECOLE_DOCT          to V_SYGAL_ECOLE_DOCT ;
rename SYGAL_ETABLISSEMENT       to V_SYGAL_ETABLISSEMENT ;
rename SYGAL_FINANCEMENT         to V_SYGAL_FINANCEMENT ;
rename SYGAL_INDIVIDU            to V_SYGAL_INDIVIDU ;
rename SYGAL_ORIGINE_FINANCEMENT to V_SYGAL_ORIGINE_FINANCEMENT ;
rename SYGAL_ROLE                to V_SYGAL_ROLE ;
rename SYGAL_ROLE_JURY           to V_SYGAL_ROLE_JURY ;
rename SYGAL_ROLE_NOMENC         to V_SYGAL_ROLE_NOMENC ;
rename SYGAL_ROLE_TR             to V_SYGAL_ROLE_TR ;
rename SYGAL_SOURCE              to V_SYGAL_SOURCE ;
rename SYGAL_STRUCTURE           to V_SYGAL_STRUCTURE ;
rename SYGAL_THESE               to V_SYGAL_THESE ;
rename SYGAL_THESE_ANNEE_UNIV    to V_SYGAL_THESE_ANNEE_UNIV ;
rename SYGAL_TITRE_ACCES         to V_SYGAL_TITRE_ACCES ;
rename SYGAL_UNITE_RECH          to V_SYGAL_UNITE_RECH ;
rename SYGAL_VARIABLE            to V_SYGAL_VARIABLE ;
rename SYGAL_VARIABLE_MANU       to V_SYGAL_VARIABLE_MANU ;

create or replace view V_SYGAL_ROLE_JURY as
select distinct
    rtr.TO_COD_ROJ as COD_ROJ,
    sr.LIB_ROJ,
    sr.LIC_ROJ
from role_jury ar
         join V_SYGAL_ROLE_TR rtr on ar.COD_ROJ = rtr.FROM_COD_ROJ
         join V_SYGAL_ROLE_NOMENC sr on sr.COD_ROJ = rtr.TO_COD_ROJ
;

create or replace view V_SYGAL_ACTEUR as
    with acteur as (
        select
                'D.'||ths.cod_ths||'.'||ths.cod_per_dir||'.'||ths.cod_etb_dir||'.'||ths.cod_cps_dir as id,
                ths.cod_ths,
                'D'              as cod_roj,
                ths.cod_per_dir  as cod_per,
                ths.cod_etb_dir  as cod_etb,
                ths.cod_cps_dir  as cod_cps,
                null             as tem_rap_recu,
                null             as cod_roj_compl
        from these_hdr_sout ths
        where ths.cod_ths_trv = '1' and ths.cod_per_dir is not null
        union
        select
                'K1.'||ths.cod_ths||'.'||ths.cod_per_cdr||'.'||ths.cod_etb_cdr||'.'||ths.cod_cps_cdr as id,
                ths.cod_ths,
                'K'              as cod_roj,
                ths.cod_per_cdr  as cod_per,
                ths.cod_etb_cdr  as cod_etb,
                ths.cod_cps_cdr  as cod_cps,
                null             as tem_rap_recu,
                null             as cod_roj_compl
        from these_hdr_sout ths
        where ths.cod_ths_trv = '1' and ths.cod_per_cdr is not null
        union
        select
                'K2.'||ths.cod_ths||'.'||ths.cod_per_cdr2||'.'||ths.cod_etb_cdr2||'.'||ths.cod_cps_cdr2 as id,
                ths.cod_ths,
                'K'              as cod_roj,
                ths.cod_per_cdr2 as cod_per,
                ths.cod_etb_cdr2 as cod_etb,
                ths.cod_cps_cdr2 as cod_cps,
                null             as tem_rap_recu,
                null             as cod_roj_compl
        from these_hdr_sout ths
        where ths.cod_ths_trv = '1' and ths.cod_per_cdr2 is not null
        union
        select
                'R.'||trs.cod_ths||'.'||trs.cod_per as id,
                trs.cod_ths,
                'R'              as cod_roj,
                trs.cod_per,
                null             as cod_etb,
                null             as cod_cps,
                trs.tem_rap_recu,
                null             as cod_roj_compl
        from ths_rap_sou trs
        union
        select
                'M.'||tjp.cod_ths||'.'||tjp.cod_per||'.'||tjp.cod_etb||'.'||tjp.cod_cps as id,
                tjp.cod_ths,
                'M'              as cod_roj,
                tjp.cod_per,
                tjp.cod_etb,
                tjp.cod_cps,
                null             as tem_rap_recu,
                case when tjp.cod_roj in ( 'P', 'B', 'A' ) then tjp.cod_roj else null end as cod_roj_compl
        from ths_jur_per tjp
    )
    select distinct
        act.id                                                                as id,
        'apogee'                                                              as source_id,               -- Id de la source
        act.cod_ths                                                           as these_id,                -- Identifiant de la these
        roj.cod_roj                                                           as role_id,                 -- Identifiant du rÃ´le
        cast(act.cod_roj_compl as varchar2(1 char))                           as cod_roj_compl,           -- Code du complement sur le role dans le jury
        rjc.lib_roj                                                           as lib_roj_compl,           -- Libelle du complement sur le role dans le jury
        act.cod_per,
        coalesce(
                regexp_replace(per.num_dos_har_per,'[^0-9]',''),
                'COD_PER_'||act.cod_per
            )                                                                     as individu_id,             -- Code Harpege ou Apogee de l acteur
        nvl ( act.cod_etb, per.cod_etb )                                      as acteur_etablissement_id, -- Id de l'etablissement de l'acteur
        case when etb.cod_dep = '099' then etb.cod_pay_adr_etb else null end  as cod_pay_etb,             -- Code pays etablissement
        case when etb.cod_dep = '099' then pay.lib_pay         else null end  as lib_pay_etb,             -- Libelle pays etablissement
        cps.cod_cps,                                                                                      -- Code du corps d'appartenance
        cps.lib_cps,                                                                                      -- Libelle du corps d'appartenance
        per.tem_hab_rch_per,                                                                              -- HDR (O/N)
        act.tem_rap_recu                                                                                  -- Rapport recu (O/N)
    from acteur                  act
             join V_SYGAL_ROLE_JURY       roj on roj.cod_roj = act.cod_roj
             join personnel             per on per.cod_per = act.cod_per
             left join corps_per        cps on cps.cod_cps = nvl ( act.cod_cps, per.cod_cps )
             left join etablissement    etb on etb.cod_etb = nvl ( act.cod_etb, per.cod_etb )
             left join pays             pay on pay.cod_pay = etb.cod_pay_adr_etb
             left join V_SYGAL_ROLE_JURY  rjc on rjc.cod_roj = act.cod_roj_compl
;

create or replace view V_SYGAL_ROLE as
select
    'apogee' as source_id, -- Id de la source
    COD_ROJ as id,         -- Id du rÃ´le
    LIB_ROJ,
    LIC_ROJ
from V_SYGAL_ROLE_JURY
;

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
        )
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
;

create table SYGAL_ACTEUR              as select * from V_SYGAL_ACTEUR ;
create table SYGAL_DOCTORANT           as select * from V_SYGAL_DOCTORANT ;
create table SYGAL_ECOLE_DOCT          as select * from V_SYGAL_ECOLE_DOCT ;
create table SYGAL_ETABLISSEMENT       as select * from V_SYGAL_ETABLISSEMENT ;
create table SYGAL_FINANCEMENT         as select * from V_SYGAL_FINANCEMENT ;
create table SYGAL_INDIVIDU            as select * from V_SYGAL_INDIVIDU ;
create table SYGAL_ORIGINE_FINANCEMENT as select * from V_SYGAL_ORIGINE_FINANCEMENT ;
create table SYGAL_ROLE                as select * from V_SYGAL_ROLE ;
create table SYGAL_STRUCTURE           as select * from V_SYGAL_STRUCTURE ;
create table SYGAL_THESE               as select * from V_SYGAL_THESE ;
create table SYGAL_THESE_ANNEE_UNIV    as select * from V_SYGAL_THESE_ANNEE_UNIV ;
create table SYGAL_TITRE_ACCES         as select * from V_SYGAL_TITRE_ACCES ;
create table SYGAL_UNITE_RECH          as select * from V_SYGAL_UNITE_RECH ;
create table SYGAL_VARIABLE            as select * from V_SYGAL_VARIABLE ;

alter table SYGAL_ACTEUR              add inserted_on date default sysdate not null ;
alter table SYGAL_DOCTORANT           add inserted_on date default sysdate not null ;
alter table SYGAL_ECOLE_DOCT          add inserted_on date default sysdate not null ;
alter table SYGAL_ETABLISSEMENT       add inserted_on date default sysdate not null ;
alter table SYGAL_FINANCEMENT         add inserted_on date default sysdate not null ;
alter table SYGAL_INDIVIDU            add inserted_on date default sysdate not null ;
alter table SYGAL_ORIGINE_FINANCEMENT add inserted_on date default sysdate not null ;
alter table SYGAL_ROLE                add inserted_on date default sysdate not null ;
alter table SYGAL_STRUCTURE           add inserted_on date default sysdate not null ;
alter table SYGAL_THESE               add inserted_on date default sysdate not null ;
alter table SYGAL_THESE_ANNEE_UNIV    add inserted_on date default sysdate not null ;
alter table SYGAL_TITRE_ACCES         add inserted_on date default sysdate not null ;
alter table SYGAL_UNITE_RECH          add inserted_on date default sysdate not null ;
alter table SYGAL_VARIABLE            add inserted_on date default sysdate not null ;
