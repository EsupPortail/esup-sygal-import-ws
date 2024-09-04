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
