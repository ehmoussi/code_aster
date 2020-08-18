! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine romCalcMatrReduit(modeNume, base, nbMatr, prod_matr_mode, matr_redu,&
                             modeType)

use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/mcmult.h"
#include "asterfort/mrmult.h"
#include "asterfort/romModeSave.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
#include "blas/zdotc.h"
#include "blas/ddot.h"
#include "asterf_types.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
!
integer, intent(in) :: nbMatr, modeNume
type(ROM_DS_Empi), intent(in) :: base
character(len=24), intent(in) :: matr_redu(:)
character(len=24), intent(in) :: prod_matr_mode(:)
character(len=1), intent(in) :: modeType
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Compute reduced matrix
!
! --------------------------------------------------------------------------------------------------
!
! In  modeNume         : mode number
! In  nbMatr           : number of elementary matrix
! In  modeType         : type of mode  (R or C) 
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbModeMaxi, nbEqua, iEqua
    integer :: iMatr, iMode, iret
    character(len=24) :: fieldIden
    character(len=8) :: resultName
    complex(kind=8) :: termc
    real(kind=8) :: termr
    character(len=19) :: mode
    complex(kind=8), pointer :: vc_mode(:) => null()
    real(kind=8), pointer :: vr_mode(:) => null()
    complex(kind=8), pointer :: vc_matr_red(:) => null()
    real(kind=8), pointer :: vr_matr_red(:) => null()
    complex(kind=8), pointer :: vc_matr_mode(:) => null()
    complex(kind=8), pointer :: vc_matr_jmode(:) => null()
    real(kind=8), pointer :: vr_matr_mode(:) => null()
    real(kind=8), pointer :: vr_matr_jmode(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    resultName = base%resultName
    nbModeMaxi = base%nbModeMaxi
    nbEqua     = base%mode%nbEqua
!
! - Get acess to mode_current
!
    fieldIden = 'DEPL'
    call rsexch(' ', resultName, fieldIden, modeNume, mode, iret)
    
    if (modeType .eq. 'R') then 
        call jeveuo(mode(1:19)//'.VALE', 'L', vr = vr_mode)
    else if (modeType .eq. 'C') then 
        call jeveuo(mode(1:19)//'.VALE', 'L', vc = vc_mode)
    else 
        ASSERT(ASTER_FALSE)
    end if
!
! - Get acess to product Matrix x Mode and Compute reduced matrix
!
    if (modeType .eq. 'R') then
        do iMatr = 1, nbMatr
           call jeveuo(matr_redu(iMatr), 'E', vr = vr_matr_red)
           call jeveuo(prod_matr_mode(iMatr), 'L', vr = vr_matr_mode)
           do iMode = 1, modeNume
              AS_ALLOCATE(vr = vr_matr_jmode, size=nbEqua)
              do iEqua = 1, nbEqua
                 vr_matr_jmode(iEqua) = vr_matr_mode(iEqua+nbEqua*(iMode-1))
              end do
              termr = ddot(nbEqua, vr_mode, 1, vr_matr_jmode, 1)
              vr_matr_red(nbModeMaxi*(modeNume-1)+iMode) = termr
              vr_matr_red(nbModeMaxi*(iMode-1)+modeNume) = termr
              AS_DEALLOCATE(vr = vr_matr_jmode)
           end do
        end do 
    else if (modeType .eq. 'C') then
        do iMatr = 1, nbMatr
           call jeveuo(matr_redu(iMatr), 'E', vc = vc_matr_red)
           call jeveuo(prod_matr_mode(iMatr), 'L', vc = vc_matr_mode)
           do iMode = 1, modeNume
              AS_ALLOCATE(vc = vc_matr_jmode, size=nbEqua)
              do iEqua = 1, nbEqua
                 vc_matr_jmode(iEqua) = vc_matr_mode(iEqua+nbEqua*(iMode-1))
              end do
              termc = zdotc(nbEqua, vc_mode, 1, vc_matr_jmode, 1)
              vc_matr_red(nbModeMaxi*(modeNume-1)+iMode) = termc
              vc_matr_red(nbModeMaxi*(iMode-1)+modeNume) = dconjg(termc)
              AS_DEALLOCATE(vc = vc_matr_jmode)
           end do
        end do 
    else
        ASSERT(ASTER_FALSE)
    end if
!
end subroutine
