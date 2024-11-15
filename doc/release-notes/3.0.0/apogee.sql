----------------------------------------------------------
-- Apogée : modification de vues/tables pour l'API V3.
----------------------------------------------------------

--
-- NB : Seule les vues `V_SYGAL_DOCTORANT_V3` et `V_SYGAL_ORIGINE_FINANCEMENT_V3` passent en version V3, c'est normal.
--      Les vues/tables inchangées restent en version "V2".
--

--
-- Doctorants : ajout de la colonne "code_apprenant_in_source" (numero étudiant).
--
create or replace view V_SYGAL_DOCTORANT_V3 as
    select distinct
        ind.cod_etu as source_code, -- Identifiant unique
        'apogee' as source_id, -- identifiant unique de la source
        ind.cod_etu as id, -- Identifiant du doctorant
        ind.cod_etu as individu_id, -- Identifiant de l'individu
        ind.cod_nne_ind||ind.cod_cle_nne_ind as ine, -- INE du doctorant
        ind.cod_etu as code_apprenant_in_source -- Numero étudiant <<<<<<<<<<<<< nouvelle colonne
    from these_hdr_sout ths
             join diplome        dip on dip.cod_dip     = ths.cod_dip
             join typ_diplome    tpd on tpd.cod_tpd_etb = dip.cod_tpd_etb
             join individu       ind on ind.cod_ind     = ths.cod_ind --and ind.cod_etu != 21009539 -- Exclusion du compte de test Aaron AAABA
             join pays           pay on pay.cod_pay     = ind.cod_pay_nat
    where ths.cod_ths_trv =  '1' -- Exclusion des travaux
      and dip.cod_tpd_etb in ('39', '40')
      and tpd.eta_ths_hdr_drt = 'T' -- Inscription en these
      and tpd.tem_sante = 'N' -- Exclusion des theses d exercice
      and cod_etu is not null
;

--drop table SYGAL_DOCTORANT_V3;
create table SYGAL_DOCTORANT_V3 as select * from V_SYGAL_DOCTORANT_V3;
alter table SYGAL_DOCTORANT_V3 add source_insert_date date default sysdate;



--
-- Origines de financement : plus de valeurs en dur, la table "origine_financement" est sensée contenir les données correctes !
--
create or replace view V_SYGAL_ORIGINE_FINANCEMENT_V3 as
    select COD_OFI as ID,
           COD_OFI as SOURCE_CODE,
           'apogee' as source_id,
           COD_OFI,
           LIC_OFI,
           LIB_OFI
    from origine_financement
    where TEM_EN_SVE_OFI = 'O'
;

--drop table SYGAL_ORIGINE_FINANCEMENT_V3;
create table SYGAL_ORIGINE_FINANCEMENT_V3 as select * from V_SYGAL_ORIGINE_FINANCEMENT_V3;
alter table SYGAL_ORIGINE_FINANCEMENT_V3 add source_insert_date date default sysdate;



--
-- Thèses : ajout trim des sauts de ligne et tabulations sur le titre.
--
create or replace view V_SYGAL_THESE_V2 as
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
    ths.cod_ths as id,          -- Identifiant de la these
    ths.cod_ths as source_code, -- Identifiant unique
    'apogee' as source_id,  -- identifiant unique de la source

    ---------- Enregistrement de la these --------
    case when ths.eta_ths = 'S' and nvl ( ths.dat_sou_ths, sysdate + 1 ) > sysdate
             then 'E' else ths.eta_ths end eta_ths,     -- Etat de la these (E=En cours, A=Abandonnee, S=Soutenue, U=Transferee)
    ind.cod_etu as doctorant_id,                      -- Identifiant du doctorant
    ths.cod_dis,                                      -- Code discipline
    dis.lib_int1_dis,                                 -- Libellé discipline
    trim(CHR(09) from trim(CHR(13) from trim(CHR(10) from ths.lib_ths))) as lib_ths, -- Titre de la these
    ths.cod_lng,                                      -- Code langue etrangere du titre
    ths.dat_deb_ths,                                  -- Date de 1ere inscription
    ths.dat_abandon,                                  -- Date d'abandon
    ths.dat_transfert_dep,                            -- Date de transfert

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
           null) as correction_possible,              -- Témoin de corrections attendues
    ths.tem_cor_ths as correction_effectuee           -- Témoin de corrections effectuees

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
;
