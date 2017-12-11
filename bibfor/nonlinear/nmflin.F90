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
subroutine nmflin(ds_posttimestep, matass, freqr, linsta)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/echmat.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
!
type(NL_DS_PostTimeStep), intent(inout) :: ds_posttimestep
character(len=19) :: matass
aster_logical :: linsta
real(kind=8) :: freqr
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (POST-TRAITEMENT)
!
! DETECTION D'UNE INSTABILITE
!
! ----------------------------------------------------------------------
!
!
! IN  MATASS : MATRICE ASSEMBLEE
! IO  ds_posttimestep  : datastructure for post-treatment at each time step
! IN  FREQR  : FREQUENCE SOLUTION INSTABILITE
! OUT LINSTA : .TRUE. SI INSTABILITE DETECTEE
!
!
!
!
    aster_logical :: valtst, ldist, l_geom_matr
    real(kind=8) :: freqr0, prec, minmat, maxmat
    character(len=16) :: sign
    character(len=24), pointer :: refa(:) => null()
!
! ----------------------------------------------------------------------
!
    linsta = ASTER_FALSE
!
! - Get parameters
!
    freqr0 = ds_posttimestep%stab_para%prev_freq
    if (abs(freqr0) .gt. 1.d30) then
        ds_posttimestep%stab_para%prev_freq = freqr
        freqr0 = freqr
    endif
    l_geom_matr = ds_posttimestep%stab_para%l_geom_matr
    prec        = ds_posttimestep%stab_para%instab_prec
    sign        = ds_posttimestep%stab_para%instab_sign
!
! --- DETECTION INSTABILITE
!
    if (.not. l_geom_matr) then
        call jeveuo(matass//'.REFA', 'L', vk24=refa)
        if (refa(11)(1:11) .ne. 'MPI_COMPLET') then
            call utmess('F', 'MECANONLINE6_13')
        endif
        ldist = ASTER_FALSE
        call echmat(matass, ldist, minmat, maxmat)
        if (((freqr0*freqr).lt.0.d0) .or. (abs(freqr).lt.(prec*minmat))) then
            linsta = ASTER_TRUE
        endif
    else
        valtst = ASTER_FALSE
        if (sign .eq. 'POSITIF') then
            valtst = ((freqr.ge.0.d0).and.(abs(freqr).lt.(1.d0+prec)))
        else if (sign.eq.'NEGATIF') then
            valtst = ((freqr.le.0.d0).and.(abs(freqr).lt.(1.d0+prec)))
        else if (sign.eq.'POSITIF_NEGATIF') then
            valtst = (abs(freqr).lt.(1.d0+prec))
        else
            ASSERT(ASTER_FALSE)
        endif
        if (valtst) then
            linsta = ASTER_TRUE
        endif
    endif
!
end subroutine
