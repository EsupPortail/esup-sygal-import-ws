--
--
-- SyGAL
-- =====
--
-- Web Service d'import de données
-- -------------------------------
--
-- Vue matérialisée interrogeant Apogée et l'annuaire LDAP pour obtenir
-- les adresses électroniques (grâce au package UCBN_LDAP).
--
-- NB : cette vue matérialisée est de type "refresh complete on demand", autrement dit est mise à jour manuellement
-- à l'aide de l'instruction PL/SQL `DBMS_MVIEW.REFRESH('SYGAL_MV_EMAIL', 'C')`.
--


-- drop materialized view SYGAL_MV_EMAIL
--/

create materialized view SYGAL_MV_EMAIL
    refresh complete on demand using trusted constraints
as
select sysdate as last_update, tmp.*
from (
         select
             -- doctorants
             to_char(ind.cod_etu)            as id,
             -- Numero etudiant
             ucbn_ldap.etu2mail(ind.cod_etu) as email -- Mail etudiant
         from these_hdr_sout ths
                  join diplome dip on dip.cod_dip = ths.cod_dip
                  join typ_diplome tpd on tpd.cod_tpd_etb = dip.cod_tpd_etb
                  join individu ind
                       on ind.cod_ind = ths.cod_ind --and ind.cod_etu != 21009539 -- Exclusion du compte de test Aaron AAABA
         where ths.cod_ths_trv = '1'  --  Exclusion des travaux
           and dip.cod_tpd_etb in ('39', '40')
           and tpd.eta_ths_hdr_drt = 'T'  -- Inscription en these
           and tpd.tem_sante = 'N'  -- Exclusion des theses d exercice
           and ind.cod_etu is not null         -- oui, oui, Ã§a arrive
         union
         select *
         from (
                  -- acteurs
                  with acteur as (
                      select
                          ths.cod_ths,
                          'D'             as cod_roj,
                          ths.cod_per_dir as cod_per,
                          ths.cod_etb_dir as cod_etb,
                          ths.cod_cps_dir as cod_cps,
                          null            as tem_rap_recu,
                          null            as cod_roj_compl
                      from these_hdr_sout ths
                      where ths.cod_ths_trv = '1' and ths.cod_per_dir is not null
                      union
                      select
                          ths.cod_ths,
                          'D'             as cod_roj,
                          ths.cod_per_cdr as cod_per,
                          ths.cod_etb_cdr as cod_etb,
                          ths.cod_cps_cdr as cod_cps,
                          null            as tem_rap_recu,
                          null            as cod_roj_compl
                      from these_hdr_sout ths
                      where ths.cod_ths_trv = '1' and ths.cod_per_cdr is not null
                      union
                      select
                          ths.cod_ths,
                          'D'              as cod_roj,
                          ths.cod_per_cdr2 as cod_per,
                          ths.cod_etb_cdr2 as cod_etb,
                          ths.cod_cps_cdr2 as cod_cps,
                          null             as tem_rap_recu,
                          null             as cod_roj_compl
                      from these_hdr_sout ths
                      where ths.cod_ths_trv = '1' and ths.cod_per_cdr2 is not null
                      union
                      select
                          trs.cod_ths,
                          'R'  as cod_roj,
                          trs.cod_per,
                          null as cod_etb,
                          null as cod_cps,
                          trs.tem_rap_recu,
                          null as cod_roj_compl
                      from ths_rap_sou trs
                      union
                      select
                          tjp.cod_ths,
                          'M'           as cod_roj,
                          tjp.cod_per,
                          tjp.cod_etb,
                          tjp.cod_cps,
                          null          as tem_rap_recu,
                          case when tjp.cod_roj in ('P', 'B', 'A')
                                   then tjp.cod_roj
                               else null end as cod_roj_compl
                      from ths_jur_per tjp
                  )
                  select distinct
                      coalesce(regexp_replace(per.num_dos_har_per, '[^0-9]', ''), 'COD_PER_' || act.cod_per) as id,
                      -- Code Harpege ou Apogee de l acteur
                      case when per.num_dos_har_per is null
                               then null
                           else ucbn_ldap.uid2mail('p' || per.num_dos_har_per) end                                as email -- Mail acteur
                  from acteur act
                           join role_jury roj on roj.cod_roj = act.cod_roj
                           join personnel per on per.cod_per = act.cod_per
              )
     ) tmp
where email is not null
/