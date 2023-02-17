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
create or replace view V_SYGAL_ORIGINE_FINANCEMENT_V2 as
with tmp(source_id, COD_OFI, LIC_OFI, LIB_OFI) as (
    select 'apogee', '10', 'SALARIE',     'Etudiant salarié'                         from dual union all
    select 'apogee', '11', 'SANS FIN',    'Sans financement'                         from dual union all
    select 'apogee', '13', 'DOT EPSCP',   'Dotation des EPSCP'                       from dual union all
    select 'apogee', '14', 'DOT EPST',    'Dotation des EPST'                        from dual union all
    select 'apogee', '15', 'POLYTECH',    'Programmes Spé. Normaliens, Polytechnici' from dual union all
    select 'apogee', '16', 'HANDICAP',    'Programme Spécifique Handicap'            from dual union all
    select 'apogee', '17', 'DEFENSE',     'Ministère de la Défense (dont DGA)'       from dual union all
    select 'apogee', '18', 'AGRICULTUR',  'Ministère de l''Agriculture'              from dual union all
    select 'apogee', '19', 'AFF ETRANG',  'Ministère des Affaires Etrangères'        from dual union all
    select 'apogee', '20', 'SANTE',       'Ministère de la Santé'                    from dual union all
    select 'apogee', '21', 'AUTRES MIN',  'Autres Ministères'                        from dual union all
    select 'apogee', '22', 'DOT EPIC',    'Dotation des EPIC'                        from dual union all
    select 'apogee', '23', 'DOT EPA',     'Dotation des EPA'                         from dual union all
    select 'apogee', '24', 'NORMANDIE',   'Région Normandie'                         from dual union all
    select 'apogee', '25', 'AUT COLLEC',  'Autre Collectivité Territoriale'          from dual union all
    select 'apogee', '26', 'ANR',         'ANR'                                      from dual union all
    select 'apogee', '27', 'IDEX',        'IDEX'                                     from dual union all
    select 'apogee', '28', 'PIA',         'Autres dispositifs du PIA (dont LABEX)'   from dual union all
    select 'apogee', '29', 'AUT AFFPR',   'Autres Finan. Pub. d''Agences Françaises' from dual union all
    select 'apogee', '30', 'FI PUB PRV',  'Financements Mixtes Public Privé'         from dual union all
    select 'apogee', '31', 'CIFRE',       'Conventions CIFRE'                        from dual union all
    select 'apogee', '32', 'PART RECH',   'Partenariat de Recherche'                 from dual union all
    select 'apogee', '33', 'MECENAT',     'Mécénat y compris Fondations et Asso.'    from dual union all
    select 'apogee', '34', 'ERC',         'ERC'                                      from dual union all
    select 'apogee', '35', 'MARIE CURI',  'Actions Marie Sklodowska Curie'           from dual union all
    select 'apogee', '36', 'ERASMUS',     'ERASMUS'                                  from dual union all
    select 'apogee', '37', 'AUT PRO EU',  'Autre Programme Européen'                 from dual union all
    select 'apogee', '38', 'GOUV EUROP',  'Gouvernement Etranger Européen'           from dual union all
    select 'apogee', '39', 'GOUV NON E',  'Gouvernement Etranger Hors Europe'        from dual union all
    select 'apogee', '40', 'AUT FI ETR',  'Autres Financements Etrangers'            from dual union all
    select 'apogee', '41', 'ENT ETR',     'Entreprise Etrangère'                     from dual union all
    select 'apogee', '42', 'ORG FC',      'Financements Organismes FC'               from dual union all
    select 'apogee', '43', 'ORG INTER',   'Organismes Internationaux'                from dual
)
select COD_OFI as ID, COD_OFI as SOURCE_CODE, source_id, COD_OFI, LIC_OFI, LIB_OFI from tmp
/
