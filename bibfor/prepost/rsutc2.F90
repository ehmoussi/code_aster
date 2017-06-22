! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine rsutc2(typres, nomch, nomgd, typsd)
    implicit none
#include "asterfort/utmess.h"
    character(len=*) :: typres, nomch, nomgd, typsd
!
! person_in_charge: jacques.pellet at edf.fr
!
!     RECHERCHE :
!       - DE LA GRANDEUR ASSOCIEE AU NOM_CHAM
!       - DU TYPE DE LA SD
!
! IN  : TYPRES : K16  : TYPE DE RESULTAT ('EVOL_THER', 'EVOL_ELAS',...)
! IN  : NOMCH  : K16  : NOM DU CHAMP ('DEPL', 'EPSA_ELNO',...)
! OUT : NOMGD  : K8   : NOM DE LA GRANDEUR ASSOCIEE AU CHAMP
!                       ('DEPL_R','SIEF_R')
! OUT : TYPSD  : K4   : TYPE DE LA SD ('NOEU', 'ELNO', 'ELGA')
!
!----------------------------------------------------------------------
!
    if (nomch .eq. 'DEPL') then
        nomgd = 'DEPL_R'
        typsd = 'NOEU'
    else if (nomch.eq.'VITE') then
        nomgd = 'DEPL_R'
        typsd = 'NOEU'
    else if (nomch.eq.'ACCE') then
        nomgd = 'DEPL_R'
        typsd = 'NOEU'
    else if (nomch.eq.'TEMP') then
        nomgd = 'TEMP_R'
        typsd = 'NOEU'
    else if (nomch.eq.'VARI_ELNO') then
        nomgd = 'VARI_R'
        typsd = 'ELNO'
    else if (nomch.eq.'EPSA_ELNO') then
        nomgd = 'EPSI_R'
        typsd = 'ELNO'
    else if (nomch.eq.'SIEF_ELNO') then
        nomgd = 'SIEF_R'
        typsd = 'ELNO'
    else if (nomch.eq.'SIGM_ELNO') then
        nomgd = 'SIEF_R'
        typsd = 'ELNO'
    else if (nomch.eq.'PRES') then
        nomgd = 'PRES_R'
        typsd = 'ELNO'
    else if (nomch.eq.'FVOL_3D') then
        nomgd = 'FORC_R'
        typsd = 'NOEU'
    else if (nomch.eq.'FVOL_2D') then
        nomgd = 'FORC_R'
        typsd = 'NOEU'
    else if (nomch.eq.'FSUR_3D') then
        nomgd = 'FORC_R'
        typsd = 'NOEU'
    else if (nomch.eq.'FSUR_2D') then
        nomgd = 'FORC_R'
        typsd = 'NOEU'
    else if (nomch.eq.'EPSI_NOEU') then
        nomgd = 'EPSI_R'
        typsd = 'NOEU'
    else if (nomch.eq.'VITE_VENT') then
        nomgd = 'DEPL_R'
        typsd = 'NOEU'
    else if (nomch.eq.'T_EXT') then
        nomgd = 'TEMP_R'
        typsd = 'NOEU'
    else if (nomch.eq.'COEF_H') then
        nomgd = 'COEH_R'
        typsd = 'NOEU'
    else
!
        call utmess('F', 'PREPOST4_76')
    endif
!
!--- TRAITEMENT DES CHAMPS DE DEPLACEMENTS COMPLEXES
!
    if (nomgd .eq. 'DEPL_R') then
        if (typres .eq. 'DYNA_HARMO' .or. typres .eq. 'HARM_GENE' .or. typres .eq.&
            'MODE_MECA_C') then
            nomgd = 'DEPL_C'
        endif
    endif
!
end subroutine
