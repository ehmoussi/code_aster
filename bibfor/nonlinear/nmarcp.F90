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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmarcp(typost, ds_posttimestep, vecmod, freqr, imode)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "jeveux.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
!
character(len=4) :: typost
type(NL_DS_PostTimeStep), intent(in) :: ds_posttimestep
character(len=19) :: vecmod
real(kind=8) :: freqr
integer :: imode
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - ARCHIVAGE)
!
! VECTEUR DE DEPL. POUR LE MODE
!
! ----------------------------------------------------------------------
!
!
! IN  TYPOST : TYPE DE POST-TRAITEMENTS (STABILITE OU MODE_VIBR)
! In  ds_posttimestep  : datastructure for post-treatment at each time step
! OUT VECMOD : VECTEUR DE DEPLACEMENT POUR LE MODE
! OUT FREQR  : FREQUENCE ATTACHEE AU MODE
! OUT IMODE  : VAUT ZEOR S'IL N'Y A PAS DE MODE
!
! ----------------------------------------------------------------------
!

!
! --- MODE SELECTIONNE: INFOS DANS SDPOST
!
    if (typost .eq. 'VIBR') then
        freqr  = ds_posttimestep%mode_vibr_resu%eigen_value
        vecmod = ds_posttimestep%mode_vibr_resu%eigen_vector
    else if (typost .eq. 'FLAM') then
        freqr  = ds_posttimestep%mode_flam_resu%eigen_value
        vecmod = ds_posttimestep%mode_flam_resu%eigen_vector
    else if (typost .eq. 'STAB') then
        freqr  = ds_posttimestep%crit_stab_resu%eigen_value
        vecmod = ds_posttimestep%crit_stab_resu%eigen_vector
    else
        ASSERT(ASTER_FALSE)
    endif
!
! --- EXTRACTION DU MODE
!
    if (freqr .eq. r8vide()) then
        imode = 0
    else
        imode = 1
    endif
!
end subroutine
