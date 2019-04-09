--
--
-- SyGAL
-- =====
--
-- Web Service d'import de données
-- -------------------------------
--
-- Vues communes à tous les établissements ayant Apogée.
--


--
-- La vue SYGAL_MV_EMAIL est chargée de fournir les adresses électroniques des individus gravitant autour des thèses.
-- Par défaut, on crée une vue ne ramenant rien.
--
-- Les solutions possibles sont :
--   - modifier la vue SYGAL_MV_EMAIL pour interroger Apogée si les adresses électroniques y sont bien renseignées ;
--   - écrire une vue matérialisée SYGAL_MV_EMAIL interrogeant périodiquement Apogée et un annuaire LDAP
--     (solution actuelle des créateurs de SyGAL, cf. exemple dans `annexe-emails.sql`);
--   - créer une table SYGAL_MV_EMAIL peuplées périodiquement comme bon vous semble.
--
create view SYGAL_MV_EMAIL as
  with tmp(LAST_UPDATE, ID, EMAIL) as (
    select null, null, null from dual
    )
    select * from tmp where 0=1
/



create view SYGAL_SOURCE as
select
    'apogee' as id,
    'apogee' as code,
    'Apogée' as libelle,
    1        as importable
  from dual
/

create view SYGAL_VARIABLE as
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
    SYGAL_VARIABLE_MANU
/

create view SYGAL_INDIVIDU as
select distinct
    'apogee'                                            as source_id,       -- Id de la source
    'doctorant'                                         as type,
    to_char(ind.cod_etu)                                as id,              -- Numero etudiant
    to_char(ind.cod_etu)                                as supann_id,
    decode(ind.cod_civ, 1, 'M.', 'Mme')                 as civ,             -- Civilite etudiant
    ind.lib_nom_pat_ind                                 as lib_nom_pat_ind, -- Nom de famille etudiant
    coalesce(ind.lib_nom_usu_ind, ind.lib_nom_pat_ind)  as lib_nom_usu_ind, -- Nom usage etudiant
    initcap(coalesce(ind.lib_pr1_ind,'Aucun'))          as lib_pr1_ind,     -- Prenom 1 etudiant
    initcap(ind.lib_pr2_ind)                            as lib_pr2_ind,     -- Prenom 2 etudiant
    initcap(ind.lib_pr3_ind)                            as lib_pr3_ind,     -- Prenom 3 etudiant
    emails.email                                        as email,           -- Mail etudiant
    ind.date_nai_ind                                    as date_nai_ind,    -- Date naissance etudiant
    ind.cod_pay_nat                                     as cod_pay_nat,     -- Code nationalite
    pay.lib_nat                                         as lib_nat          -- Libelle nationalite
  from these_hdr_sout ths
         join diplome        dip on dip.cod_dip     = ths.cod_dip
         join typ_diplome    tpd on tpd.cod_tpd_etb = dip.cod_tpd_etb
         join individu       ind on ind.cod_ind     = ths.cod_ind --and ind.cod_etu != 21009539 -- Exclusion du compte de test Aaron AAABA
         join pays           pay on pay.cod_pay     = ind.cod_pay_nat
         left join SYGAL_MV_EMAIL emails on emails.id = ind.cod_etu
  where ths.cod_ths_trv     =  '1'  --  Exclusion des travaux
    and dip.cod_tpd_etb     in ( '39', '40' )
    and tpd.eta_ths_hdr_drt =  'T'  -- Inscription en these
    and tpd.tem_sante       =  'N'  -- Exclusion des theses d exercice
    and ind.cod_etu is not null         -- oui, oui, ça arrive
  union
    -- acteurs
  select "SOURCE_ID","TYPE","ID","SUPANN_ID","CIV","LIB_NOM_PAT_IND","LIB_NOM_USU_IND","LIB_PR1_IND","LIB_PR2_IND","LIB_PR3_IND","EMAIL","DATE_NAI_IND","COD_PAY_NAT","LIB_NAT" from (
    with acteur as (
      select
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
        ths.cod_ths,
        'D'              as cod_roj,
        ths.cod_per_cdr  as cod_per,
        ths.cod_etb_cdr  as cod_etb,
        ths.cod_cps_cdr  as cod_cps,
        null             as tem_rap_recu,
        null             as cod_roj_compl
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
        'R'              as cod_roj,
        trs.cod_per,
        null             as cod_etb,
        null             as cod_cps,
        trs.tem_rap_recu,
        null             as cod_roj_compl
      from ths_rap_sou trs
      union
      select
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
        'apogee'                                                                                                as source_id,
        'acteur'                                                                                                as type,
        coalesce(regexp_replace(per.num_dos_har_per,'[^0-9]',''), 'COD_PER_'||act.cod_per)                      as id,     -- Code Harpege ou Apogee de l acteur
        regexp_replace(per.num_dos_har_per,'[^0-9]','')                                                         as supann_id, -- Code Harpege de l acteur
        initcap(per.cod_civ_per)                                                                                as civ,             -- Civilite acteur
        per.LIB_NOM_PAT_PER                                                                                     as lib_nom_pat_ind, -- Nom de famille acteur
        per.lib_nom_usu_per                                                                                     as lib_nom_usu_ind, -- Nom d'usage acteur
        per.lib_pr1_per                                                                                         as lib_pr1_ind,     -- Prenom 1 acteur
        null                                                                                                    as lib_pr2_ind,     -- Prenom 2 acteur
        null                                                                                                    as lib_pr3_ind,     -- Prenom 3 acteur
        emails.email                                                                                            as email,           -- Mail acteur
        per.dat_nai_per                                                                                         as date_nai_ind,    -- Date naissance acteur
        null                                                                                                    as cod_pay_nat,     -- Code nationalite
        null                                                                                                    as lib_nat          -- Libelle nationalite
      from acteur               act
             join role_jury            roj on roj.cod_roj = act.cod_roj
             join personnel            per on per.cod_per = act.cod_per
             left join SYGAL_MV_EMAIL emails on emails.id = per.num_dos_har_per
  )
/

create view SYGAL_DOCTORANT as
select distinct
    'apogee' as source_id, -- Id de la source
    ind.cod_etu                                         as id,            -- Identifiant du doctorant
    ind.cod_etu                                         as individu_id    -- Identifiant de l'individu
  /*  decode(ind.cod_civ, 1, 'M.', 'Mme')                as civ_etu,         -- Civilite etudiant
    ind.lib_nom_pat_ind,                                                   -- Nom de famille etudiant
    coalesce(ind.lib_nom_usu_ind, ind.lib_nom_pat_ind) as lib_nom_usu_ind, -- Nom usage etudiant
    initcap(ind.lib_pr1_ind) lib_pr1_ind,                                  -- Prenom etudiant
    initcap(ind.lib_pr2_ind) lib_pr2_ind,                                  -- Prenom etudiant
    initcap(ind.lib_pr3_ind) lib_pr3_ind,                                  -- Prenom etudiant
    ucbn_ldap.etu2mail ( ind.cod_etu )                 as mail_etu,        -- Mail etudiant
    ind.date_nai_ind,                                                      -- Date naissance etudiant
    ind.cod_pay_nat,                                                       -- Code nationalite
    pay.lib_nat                                                            -- Libelle nationalite*/
  from these_hdr_sout ths
    join diplome        dip on dip.cod_dip     = ths.cod_dip
    join typ_diplome    tpd on tpd.cod_tpd_etb = dip.cod_tpd_etb
    join individu       ind on ind.cod_ind     = ths.cod_ind --and ind.cod_etu != 21009539 -- Exclusion du compte de test Aaron AAABA
    join pays           pay on pay.cod_pay     = ind.cod_pay_nat
  where ths.cod_ths_trv     =  '1'  --  Exclusion des travaux
        and dip.cod_tpd_etb     in ( '39', '40' )
        and tpd.eta_ths_hdr_drt =  'T'  -- Inscription en these
        and tpd.tem_sante       =  'N'  -- Exclusion des theses d exercice
        and cod_etu is not null
/

create view SYGAL_THESE as
  with inscription_administrative as (
    select distinct
      ths.cod_ind,
      iae.cod_dip,
      iae.cod_vrs_vdi
    from these_hdr_sout ths
           join ins_adm_etp    iae on iae.cod_ind = ths.cod_ind and ( iae.cod_dip, iae.cod_vrs_vdi ) in ( ( ths.cod_dip, ths.cod_vrs_vdi ), ( ths.cod_dip_anc, ths.cod_vrs_vdi_anc ) )
           join diplome        dip on dip.cod_dip = iae.cod_dip
           join typ_diplome    tpd on tpd.cod_tpd_etb = dip.cod_tpd_etb
    where ths.cod_ths_trv     =  '1'  -- Exclusion des travaux
      and iae.eta_iae         =  'E'  -- Inscription administrative non annulee
      and iae.eta_pmt_iae     =  'P'  -- Inscription administrative payee
      and dip.cod_tpd_etb     in ( '39', '40' )
      and tpd.eta_ths_hdr_drt =  'T'  -- Inscription en these
      and tpd.tem_sante       =  'N'  -- Exclusion des theses d exercice
    ),
    hierarchie_structures as (
      select
        cod_cmp_inf,
        cod_cmp_sup
      from cmp_cmp
      where connect_by_isleaf = 1
      connect by prior cod_cmp_sup = cod_cmp_inf
      ),
    ancienne_these as (
      select distinct
        cod_ind,
        cod_dip_anc,
        cod_vrs_vdi_anc,
        'A' eta_ths
      from these_hdr_sout
      where cod_ths_trv = '1'
        and cod_dip_anc is not null
      )

    select
      'apogee' as source_id,                            -- Id de la source

      ---------- Enregistrement de la these --------
      ths.cod_ths as id,                                -- Identifiant de la these
      case when ths.eta_ths = 'S' and nvl ( ths.dat_sou_ths, sysdate + 1 ) > sysdate
             then 'E' else ths.eta_ths end eta_ths,     -- Etat de la these (E=En cours, A=Abandonnee, S=Soutenue, U=Transferee)
      ind.cod_etu as doctorant_id,                      -- Identifiant du doctorant
      ths.cod_dis,                                      -- Code discipline
      dis.lib_int1_dis,                                 -- Libellé discipline
      ths.lib_ths,                                      -- Titre de la these
      ths.cod_lng,                                      -- Code langue etrangere du titre
      ths.dat_deb_ths,                                  -- Date de 1ere inscription
      null as cod_anu_prm_iae,                          -- DEPRECATED (cf. SYGAL_THESE_ANNEE_UNIV)

      edo.cod_nat_edo as ecole_doct_id,                 -- Identifiant de l'ecole doctorale
      ths.cod_eqr as unite_rech_id,                     -- Identifiant de l'unité de recherche principale

      ----------- Cotutelle ----------
      pay.lib_pay,                                      -- Denomination pays de cotutelle
      nvl ( etb.lib_web_etb, etb.lib_etb ) lib_etb_cot, -- Denomination etablissement de cotutelle
      ths.tem_avenant,                                  -- Avenant a la convention de cotutelle (O/N)

      ------- Organisation de la soutenance ------
      ths.dat_prev_sou,                                 -- Date previsionnelle de soutenance
      ths.tem_sou_aut_ths,                              -- Soutenance autorisee (O/N/null)
      ths.dat_aut_sou_ths,                              -- Date d autorisation de soutenance
      ths.dat_sou_ths,                                  -- Date de soutenance de la these

      ---------- Confidentialite --------
      ths.dat_fin_cfd_ths,                              -- Date de fin de confidentialite de la these

      ---------- Jury et resultats --------
      tre.cod_neg_tre,                                  -- Resultat positif (1) ou non (0)
      ths.eta_rpd_ths,                                  -- Reproduction de la these ( O=Oui / C=Oui avec corrections / N=Non )
      decode(ths.eta_rpd_ths,
             'N', 'obligatoire',
             'C', 'facultative',
             null) as correction_possible                    -- Témoin de corrections attendues

    from inscription_administrative iae
           join individu                   ind on ind.cod_ind = iae.cod_ind
           join version_diplome            vdi on vdi.cod_dip = iae.cod_dip and vdi.cod_vrs_vdi = iae.cod_vrs_vdi
           join these_hdr_sout             ths on ths.cod_ind = iae.cod_ind and ths.cod_dip = iae.cod_dip and ths.cod_vrs_vdi = iae.cod_vrs_vdi
           left join ancienne_these        anc on anc.cod_ind = ths.cod_ind and anc.cod_dip_anc = ths.cod_dip and anc.cod_vrs_vdi_anc = ths.cod_vrs_vdi and anc.eta_ths = ths.eta_ths
           left join annee_uni             ans on ans.cod_anu = ths.daa_fin_ths
           left join ecole_doctorale       edo on edo.cod_edo = ths.cod_edo
           left join secteur_rch           ser on ser.cod_ser = ths.cod_ser
           left join equipe_rch            eqr on eqr.cod_eqr = ths.cod_eqr
           left join resultat_vdi          rvi on rvi.cod_ind = iae.cod_ind and rvi.cod_dip = iae.cod_dip and rvi.cod_vrs_vdi = iae.cod_vrs_vdi and rvi.cod_ses = '0' and rvi.cod_adm = '1' and rvi.cod_tre is not null
           left join annee_uni             anr on anr.cod_anu = rvi.cod_anu
           left join typ_resultat          tre on tre.cod_tre = rvi.cod_tre
           left join mention               men on men.cod_men = rvi.cod_men
           left join hierarchie_structures ccm on ccm.cod_cmp_inf = ths.cod_cmp
           left join composante            cmp on cmp.cod_cmp = nvl ( ccm.cod_cmp_sup, ths.cod_cmp )
           left join diplome_sise          dis on dis.cod_dis = ths.cod_dis
           left join etablissement         etb on etb.cod_etb = ths.cod_etb
           left join pays                  pay on pay.cod_pay = ths.cod_pay
           left join etablissement         sou on sou.cod_etb = ths.cod_etb_sou
           left join etablissement         ori on ori.cod_etb = ths.cod_etb_origine
           left join langue                lng on lng.cod_lng = ths.cod_lng
    where
        ths.cod_ths_trv = '1' and --  Exclusion des travaux
        anc.cod_dip_anc is null
/

create view SYGAL_STRUCTURE as
select
    'apogee' as source_id,                  -- Id de la source
    'ecole-doctorale' as TYPE_STRUCTURE_ID, -- Type de structure
    edo.cod_nat_edo as id,                  -- Id unique : Identifiant national
    edo.lic_edo as sigle,                   -- Libellé court
    edo.lib_edo as libelle,                 -- Denomination
    null as code_pays,                        --
    null as libelle_pays                         --
  from ecole_doctorale edo
  union
  -- UR
  select
    'apogee' as source_id,                  -- Id de la source
    'unite-recherche' as TYPE_STRUCTURE_ID, -- Type de structure
    eqr.cod_eqr as id,                      -- Id unique
    eqr.lic_eqr as sigle,                   -- Libellé court
    eqr.lib_eqr as libelle,                 -- Denomination
    null as code_pays,                        --
    null as libelle_pays                         --
  from equipe_rch  eqr
  union
  -- Etablissements de cotutelle
  select
    'apogee' as source_id,                -- Id de la source
    'etablissement' as TYPE_STRUCTURE_ID, -- Type de structure
    etb.cod_etb as id,                    -- Id unique
    null as sigle,                        --
    etb.lib_etb as libelle,               -- Libelle
    pay.cod_pay as code_pays,             -- Code pays
    pay.lib_pay as libelle_pays           -- Libelle pays
  from etablissement etb
    join these_hdr_sout ths on ths.cod_etb = etb.cod_etb and -- établissements de cotutelle
                               ths.cod_ths_trv = '1' -- travaux exclus
    left join pays pay on pay.cod_pay = etb.cod_pay_adr_etb
  union
  -- Etablissements des directeurs de theses
  select
    'apogee' as source_id,                -- Id de la source
    'etablissement' as TYPE_STRUCTURE_ID, -- Type de structure
    etb.cod_etb as id,                    -- Id unique
    null as sigle,                        --
    etb.lib_etb as libelle,               -- Libelle
    pay.cod_pay as code_pays,             -- Code pays
    pay.lib_pay as libelle_pays           -- Libelle pays
  from etablissement etb
    join these_hdr_sout ths on ths.cod_etb_dir = etb.cod_etb and -- établissements des directeurs de theses
                               ths.cod_ths_trv = '1' -- travaux exclus
    left join pays pay on pay.cod_pay = etb.cod_pay_adr_etb
  union
  -- Etablissements des co-directeurs de theses
  select
    'apogee' as source_id,                -- Id de la source
    'etablissement' as TYPE_STRUCTURE_ID, -- Type de structure
    etb.cod_etb as id,                    -- Id unique
    null as sigle,                        --
    etb.lib_etb as libelle,               -- Libelle
    pay.cod_pay as code_pays,             -- Code pays
    pay.lib_pay as libelle_pays           -- Libelle pays
  from etablissement etb
    join these_hdr_sout ths on ths.cod_etb_cdr = etb.cod_etb and -- établissements des co-directeurs de theses
                               ths.cod_ths_trv = '1' -- travaux exclus
    left join pays pay on pay.cod_pay = etb.cod_pay_adr_etb
  union
  -- Etablissements des seconds co-directeurs de theses
  select
    'apogee' as source_id,                -- Id de la source
    'etablissement' as TYPE_STRUCTURE_ID, -- Type de structure
    etb.cod_etb as id,                    -- Id unique
    null as sigle,                        --
    etb.lib_etb as libelle,               -- Libelle
    pay.cod_pay as code_pays,             -- Code pays
    pay.lib_pay as libelle_pays           -- Libelle pays
  from etablissement etb
    join these_hdr_sout ths on ths.cod_etb_cdr2 = etb.cod_etb and -- établissements des seconds co-directeurs de theses
                               ths.cod_ths_trv = '1' -- travaux exclus
    left join pays pay on pay.cod_pay = etb.cod_pay_adr_etb
  union
  -- Etablissements des rapporteurs
  select
    'apogee' as source_id,                -- Id de la source
    'etablissement' as TYPE_STRUCTURE_ID, -- Type de structure
    etb.cod_etb as id,                    -- Id unique
    null as sigle,                        --
    etb.lib_etb as libelle,               -- Libelle
    pay.cod_pay as code_pays,             -- Code pays
    pay.lib_pay as libelle_pays           -- Libelle pays
  from etablissement etb
    join personnel   per on per.cod_etb = etb.cod_etb -- établissements des rapporteurs
    join ths_rap_sou trs on trs.cod_per = per.cod_per
    join these_hdr_sout ths on ths.cod_ths = trs.cod_ths and
                               ths.cod_ths_trv = '1' -- travaux exclus
    left join pays pay on pay.cod_pay = etb.cod_pay_adr_etb
  where per.tem_ext_int_per = 'X' -- personnels exterieurs uniquement
  union
  -- Etablissements des membres du jury
  select
    'apogee' as source_id,                -- Id de la source
    'etablissement' as TYPE_STRUCTURE_ID, -- Type de structure
    etb.cod_etb as id,                    -- Id unique
    null as sigle,                        --
    etb.lib_etb as libelle,               -- Libelle
    pay.cod_pay as code_pays,             -- Code pays
    pay.lib_pay as libelle_pays           -- Libelle pays
  from etablissement etb
    join personnel   per on per.cod_etb = etb.cod_etb -- établissements des membres du jury
    join ths_jur_per tjp on tjp.cod_per = per.cod_per
    join these_hdr_sout ths on ths.cod_ths = tjp.cod_ths and
                               ths.cod_ths_trv = '1' -- travaux exclus
    left join pays pay on pay.cod_pay = etb.cod_pay_adr_etb
  where per.tem_ext_int_per = 'X'
/

create view SYGAL_ECOLE_DOCT as
select distinct
    'apogee' as source_id,            -- Id de la source
    edo.cod_nat_edo as structure_id,  -- Id de la structure
    edo.cod_nat_edo as id             -- Id ecole doctorale
  from ecole_doctorale edo
/

create view SYGAL_UNITE_RECH as
select distinct
    'apogee' as source_id,        -- Id de la source
    eqr.cod_eqr as structure_id,  -- Id de la structure
    eqr.cod_eqr as id             -- Id unite de recherche
  from equipe_rch eqr
/

create view SYGAL_ETABLISSEMENT as
select distinct
    'apogee' as source_id,        -- Id de la source
    etb.cod_etb as structure_id,  -- Id de la structure
    etb.cod_etb as id,            -- Identifiant unique établissement
    etb.cod_etb as code           -- Code unique établissement
  from etablissement etb
    join these_hdr_sout ths on ths.cod_etb = etb.cod_etb and -- établissements de cotutelle
                               ths.cod_ths_trv = '1' -- travaux exclus
    left join pays pay on pay.cod_pay = etb.cod_pay_adr_etb
  union
  -- Etablissements des directeurs de theses
  select
    'apogee' as source_id,        -- Id de la source
    etb.cod_etb as structure_id,  -- Id de la structure
    etb.cod_etb as id,            -- Identifiant unique établissement
    etb.cod_etb as code           -- Code unique établissement
  from etablissement etb
    join these_hdr_sout ths on ths.cod_etb_dir = etb.cod_etb and -- établissements des directeurs de theses
                               ths.cod_ths_trv = '1' -- travaux exclus
    left join pays pay on pay.cod_pay = etb.cod_pay_adr_etb
  union
  -- Etablissements des co-directeurs de theses
  select
    'apogee' as source_id,        -- Id de la source
    etb.cod_etb as structure_id,  -- Id de la structure
    etb.cod_etb as id,            -- Identifiant unique établissement
    etb.cod_etb as code           -- Code unique établissement
  from etablissement etb
    join these_hdr_sout ths on ths.cod_etb_cdr = etb.cod_etb and -- établissements des co-directeurs de theses
                               ths.cod_ths_trv = '1' -- travaux exclus
    left join pays pay on pay.cod_pay = etb.cod_pay_adr_etb
  union
  -- Etablissements des seconds co-directeurs de theses
  select
    'apogee' as source_id,        -- Id de la source
    etb.cod_etb as structure_id,  -- Id de la structure
    etb.cod_etb as id,            -- Identifiant unique établissement
    etb.cod_etb as code           -- Code unique établissement
  from etablissement etb
    join these_hdr_sout ths on ths.cod_etb_cdr2 = etb.cod_etb and -- établissements des seconds co-directeurs de theses
                               ths.cod_ths_trv = '1' -- travaux exclus
    left join pays pay on pay.cod_pay = etb.cod_pay_adr_etb
  union
  -- Etablissements des rapporteurs
  select
    'apogee' as source_id,        -- Id de la source
    etb.cod_etb as structure_id,  -- Id de la structure
    etb.cod_etb as id,            -- Identifiant unique établissement
    etb.cod_etb as code           -- Code unique établissement
  from etablissement etb
    join personnel   per on per.cod_etb = etb.cod_etb -- établissements des rapporteurs
    join ths_rap_sou trs on trs.cod_per = per.cod_per
    join these_hdr_sout ths on ths.cod_ths = trs.cod_ths and
                               ths.cod_ths_trv = '1' -- travaux exclus
    left join pays pay on pay.cod_pay = etb.cod_pay_adr_etb
  where per.tem_ext_int_per = 'X' -- personnels exterieurs uniquement
  union
  -- Etablissements des membres du jury
  select
    'apogee' as source_id,        -- Id de la source
    etb.cod_etb as structure_id,  -- Id de la structure
    etb.cod_etb as id,            -- Identifiant unique établissement
    etb.cod_etb as code           -- Code unique établissement
  from etablissement etb
    join personnel   per on per.cod_etb = etb.cod_etb -- établissements des membres du jury
    join ths_jur_per tjp on tjp.cod_per = per.cod_per
    join these_hdr_sout ths on ths.cod_ths = tjp.cod_ths and
                               ths.cod_ths_trv = '1' -- travaux exclus
    left join pays pay on pay.cod_pay = etb.cod_pay_adr_etb
  where per.tem_ext_int_per = 'X'
/

create view SYGAL_ROLE_TR as
select 'A', 'A' from dual union
  select 'B', 'B' from dual union
  select 'C', 'C' from dual union
  select 'D', 'D' from dual union
  select 'K', 'K' from dual union
  select 'M', 'M' from dual union
  select 'P', 'P' from dual union
  select 'R', 'R' from dual
/

create view SYGAL_ROLE_NOMENC as
select 'A', 'Absent',     'Membre absent'         from dual union
  select 'B', 'Co-encadr',  'Co-encadrant'          from dual union
  select 'C', 'Chef Labo',  'Chef de laboratoire'   from dual union
  select 'D', 'Directeur',  'Directeur de thèse'    from dual union
  select 'K', 'Co-direct',  'Co-directeur de thèse' from dual union
  select 'M', 'Membre',     'Membre du jury'        from dual union
  select 'P', 'Président',  'Président du jury'     from dual union
  select 'R', 'Rapporteur', 'Rapporteur du jury'    from dual
/

create view SYGAL_ROLE_JURY as
select distinct
    rtr.TO_COD_ROJ as COD_ROJ,
    sr.LIB_ROJ,
    sr.LIC_ROJ
  from role_jury ar
    join SYGAL_ROLE_TR rtr on ar.COD_ROJ = rtr.FROM_COD_ROJ
    join SYGAL_ROLE_NOMENC sr on sr.COD_ROJ = rtr.TO_COD_ROJ
/

create view SYGAL_ROLE as
select
    'apogee' as source_id, -- Id de la source
    COD_ROJ as id,         -- Id du rôle
    LIB_ROJ,
    LIC_ROJ
  from SYGAL_ROLE_JURY
/

create view SYGAL_ACTEUR as
with acteur as (
    select
      'D_' || rowid as id,
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
      'K1_' || rowid as id,
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
      'K2_' || rowid as id,
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
      'R_' || rowid as id,
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
      'M_' || rowid as id,
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
    roj.cod_roj                                                           as role_id,                 -- Identifiant du rôle
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
    join SYGAL_ROLE_JURY       roj on roj.cod_roj = act.cod_roj
    join personnel             per on per.cod_per = act.cod_per
    left join corps_per        cps on cps.cod_cps = nvl ( act.cod_cps, per.cod_cps )
    left join etablissement    etb on etb.cod_etb = nvl ( act.cod_etb, per.cod_etb )
    left join pays             pay on pay.cod_pay = etb.cod_pay_adr_etb
    left join SYGAL_ROLE_JURY  rjc on rjc.cod_roj = act.cod_roj_compl
/

create view SYGAL_FINANCEMENT as
with inscription_admin as (
    select
      iae.cod_ind,
      iae.cod_dip,
      iae.cod_vrs_vdi,
      dip.lib_dip,
      min ( iae.cod_anu ) cod_anu_prm_iae
    from ins_adm_etp iae
           join diplome     dip on dip.cod_dip     = iae.cod_dip
           join typ_diplome tpd on tpd.cod_tpd_etb = dip.cod_tpd_etb
    where iae.eta_iae         =  'E'  -- Inscription administrative non annulee
      and iae.eta_pmt_iae     =  'P'  -- Inscription administrative payee
      and dip.cod_tpd_etb     in ( '39', '40' )
      and tpd.eta_ths_hdr_drt =  'T'  -- Inscription en these
      and tpd.tem_sante       =  'N'  -- Exclusion des theses d exercice
    group by
      iae.cod_ind,
      iae.cod_dip,
      iae.cod_vrs_vdi,
      dip.lib_dip
    )
    select
      min ( tfi.cod_seq_tfi )                          as id,       -- Premier numero de sequence du financement
      'apogee'                                         as source_id,
      tfi.cod_ths                                      as these_id,
      min ( nvl ( tfi.cod_anu, iae.cod_anu_prm_iae ) ) as annee_id, -- Identifiant de l annee universitaire (ex. 2018 pour 2018/2019)
      tfi.cod_ofi                                      as origine_financement_id,
      listagg ( tfi.compl_tfi, ' / ' ) within group ( order by tfi.cod_ths, tfi.cod_ofi, tfi.quotite_tfi, nvl ( tfi.cod_anu, iae.cod_anu_prm_iae ), tfi.cod_seq_tfi ) as complement_financement,
      tfi.quotite_tfi                                  as quotite_financement,
      min ( tfi.dat_deb_tfi )                          as date_debut_financement,
      max ( tfi.dat_fin_tfi )                          as date_fin_financement
    from inscription_admin   iae
           join these_hdr_sout      ths on ths.cod_ind     = iae.cod_ind and ths.cod_dip = iae.cod_dip and ths.cod_vrs_vdi = iae.cod_vrs_vdi
           join ths_financement     tfi on tfi.cod_ths     = ths.cod_ths
           join origine_financement ofi on ofi.cod_ofi     = tfi.cod_ofi
    where ths.cod_ths_trv     = '1'     -- Exclusion des travaux
      and ofi.tem_en_sve_ofi  = 'O'     -- Exclusion des anciens codes des origines de financements
    group by
      tfi.cod_ths,
      tfi.cod_ofi,
      tfi.quotite_tfi
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

create view SYGAL_TITRE_ACCES as
with inscription_administrative as (
    select
      iae.cod_ind,
      iae.cod_dip,
      iae.cod_vrs_vdi,
      dip.lib_dip,
      max ( iae.cod_anu ) as cod_anu_der_iae,
      min ( iae.cod_nat_tit_acc_iae ) keep ( dense_rank first order by iae.cod_ind, iae.cod_dip, iae.cod_vrs_vdi, iae.cod_nat_tit_acc_iae desc, iae.cod_anu ) as cod_nat_tit_acc_iae,
      min ( iae.cod_dip_acc         ) keep ( dense_rank first order by iae.cod_ind, iae.cod_dip, iae.cod_vrs_vdi, iae.cod_nat_tit_acc_iae desc, iae.cod_anu ) as cod_dip_acc,
      min ( iae.cod_vrs_vdi_acc     ) keep ( dense_rank first order by iae.cod_ind, iae.cod_dip, iae.cod_vrs_vdi, iae.cod_nat_tit_acc_iae desc, iae.cod_anu ) as cod_vrs_vdi_acc,
      min ( iae.cod_dac_acc         ) keep ( dense_rank first order by iae.cod_ind, iae.cod_dip, iae.cod_vrs_vdi, iae.cod_nat_tit_acc_iae desc, iae.cod_anu ) as cod_dac_acc,
      min ( iae.cod_tpe_acc_iae     ) keep ( dense_rank first order by iae.cod_ind, iae.cod_dip, iae.cod_vrs_vdi, iae.cod_nat_tit_acc_iae desc, iae.cod_anu ) as cod_tpe_acc_iae,
      min ( iae.cod_etb_acc_iae     ) keep ( dense_rank first order by iae.cod_ind, iae.cod_dip, iae.cod_vrs_vdi, iae.cod_nat_tit_acc_iae desc, iae.cod_anu ) as cod_etb_acc_iae,
      min ( iae.cod_dep_pay_acc     ) keep ( dense_rank first order by iae.cod_ind, iae.cod_dip, iae.cod_vrs_vdi, iae.cod_nat_tit_acc_iae desc, iae.cod_anu ) as cod_dep_pay_acc,
      min ( iae.cod_typ_dep_pay_acc ) keep ( dense_rank first order by iae.cod_ind, iae.cod_dip, iae.cod_vrs_vdi, iae.cod_nat_tit_acc_iae desc, iae.cod_anu ) as cod_typ_dep_pay_acc
    from ins_adm_etp iae
      join diplome dip on dip.cod_dip = iae.cod_dip
      join typ_diplome tpd on tpd.cod_tpd_etb = dip.cod_tpd_etb
    where iae.eta_iae = 'E'  -- Inscription administrative non annulee
          and iae.eta_pmt_iae = 'P'  -- Inscription administrative payee
          and dip.cod_tpd_etb in ('39', '40') -- Inscription dans un diplome de type doctorat
          and tpd.eta_ths_hdr_drt = 'T'  -- Inscription en these
          and tpd.tem_sante = 'N'  -- Exclusion des theses d exercice
    group by
      iae.cod_ind,
      iae.cod_dip,
      iae.cod_vrs_vdi,
      dip.lib_dip
  ),
  titre_acces as (
    select
      iae.cod_ind,
      iae.cod_dip,
      iae.cod_vrs_vdi,
      case iae.cod_nat_tit_acc_iae
      when 'A' then null
      else iae.cod_nat_tit_acc_iae
      end                                                as titre_acces_interne_externe,
      case iae.cod_nat_tit_acc_iae
      when 'I' then vdi.lib_web_vdi
      when 'E' then nvl ( dac.lib_web_dac, dac.lib_dac )
      end                                                as libelle_titre_acces,
      tpe.lib_tpe                                          as type_etb_titre_acces,
      case iae.cod_nat_tit_acc_iae
      when 'I' then etb_lib.par_vap
      when 'E' then etb.lib_etb
      end                                                as libelle_etb_titre_acces,
      case iae.cod_nat_tit_acc_iae
      when 'I' then etb_dep.par_vap
      when 'E' then case iae.cod_typ_dep_pay_acc when 'D' then iae.cod_dep_pay_acc else null end
      end                                                as code_dept_titre_acces,
      case iae.cod_nat_tit_acc_iae
      when 'I' then '100'
      when 'E' then case iae.cod_typ_dep_pay_acc when 'P' then iae.cod_dep_pay_acc else null end
      end                                                as code_pays_titre_acces
    from variable_appli                     etb_cod
      cross join variable_appli             etb_typ
      cross join variable_appli             etb_lib
      cross join variable_appli             etb_dep
      cross join inscription_administrative iae
      left join version_diplome             vdi on vdi.cod_dip = iae.cod_dip_acc and vdi.cod_vrs_vdi = iae.cod_vrs_vdi_acc
      left join dip_aut_cur                 dac on dac.cod_dac = iae.cod_dac_acc
      left join typ_etb                     tpe on tpe.cod_tpe = case iae.cod_nat_tit_acc_iae when 'I' then etb_typ.par_vap when 'E' then iae.cod_tpe_acc_iae end
      left join etablissement               etb on etb.cod_etb = iae.cod_etb_acc_iae
    where etb_cod.cod_vap = 'ETB_COD'
          and etb_typ.cod_vap = 'ETB_TYP'
          and etb_lib.cod_vap = 'ETB_LIB'
          and etb_dep.cod_vap = 'ETB_DEP'
  )
  select
    'apogee' as source_id,    -- Id de la source
    ths.cod_ths as id,        -- Clé primaire de la vue
    ths.cod_ths as these_id,  -- Identifiant de la these
    tac.titre_acces_interne_externe,
    tac.libelle_titre_acces,
    tac.type_etb_titre_acces,
    tac.libelle_etb_titre_acces,
    tac.code_dept_titre_acces,
    tac.code_pays_titre_acces
  from inscription_administrative iae
    join these_hdr_sout ths on ths.cod_ind = iae.cod_ind and ths.cod_dip = iae.cod_dip and ths.cod_vrs_vdi = iae.cod_vrs_vdi
    join titre_acces    tac on tac.cod_ind = iae.cod_ind and tac.cod_dip = iae.cod_dip and tac.cod_vrs_vdi = iae.cod_vrs_vdi
  where
    tac.titre_acces_interne_externe is not null
/

create view SYGAL_THESE_ANNEE_UNIV as
with old_these as (
    select distinct
      cod_ind,
      cod_dip_anc,
      cod_vrs_vdi_anc,
      'A' eta_ths
    from these_hdr_sout
    where cod_ths_trv = '1'
      and cod_dip_anc is not null
    )
    select distinct
      'apogee'    as source_id,
      ths.cod_ths || '_' || iae.cod_anu as id,
      ths.cod_ths as these_id,
      iae.cod_anu as annee_univ
    from these_hdr_sout ths
           left join old_these old on old.cod_ind = ths.cod_ind and old.cod_dip_anc = ths.cod_dip and old.cod_vrs_vdi_anc = ths.cod_vrs_vdi and old.eta_ths = ths.eta_ths
           join diplome        dip on dip.cod_dip = ths.cod_dip
           join typ_diplome    tpd on tpd.cod_tpd_etb = dip.cod_tpd_etb
           join ins_adm_etp    iae on iae.cod_ind = ths.cod_ind and ( iae.cod_dip, iae.cod_vrs_vdi ) in ( ( ths.cod_dip, ths.cod_vrs_vdi ), ( ths.cod_dip_anc, ths.cod_vrs_vdi_anc ) )
           join individu       ind on ind.cod_ind = iae.cod_ind
    where ths.cod_ths_trv     = '1'   -- Exclusion des travaux
      and old.cod_dip_anc     is null
      and dip.cod_tpd_etb     in ( '39', '40' )
      and tpd.eta_ths_hdr_drt =  'T'  -- Diplome de type these
      and tpd.tem_sante       =  'N'  -- Exclusion des theses d exercice
      and iae.eta_iae         =  'E'  -- Inscription administrative non annulee
      and iae.eta_pmt_iae     =  'P'
/
