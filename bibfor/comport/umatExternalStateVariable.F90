! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine umatExternalStateVariable(fami, kpg, ksp, &
                                         irets, ireth, &
                                         sechm, sechp, hydrm, hydrp, &
                                         predef, dpred)
!
implicit none
!
#include "asterc/r8nnem.h"
#include "asterfort/assert.h"
#include "asterfort/r8inir.h"
#include "asterfort/rcvalb.h"
#include "asterfort/rcvarc.h"
#include "asterfort/rccoma.h"
#include "asterfort/verift.h"
!
character(len=*), intent(in) :: fami
integer, intent(in) :: kpg, ksp
integer, intent(in)      :: irets, ireth
real(kind=8), intent(in) :: sechm, sechp, hydrm, hydrp
real(kind=8), intent(out) :: predef(*), dpred(*)
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour (UMAT)
!
! Prepare predef and dpred variables
!
! --------------------------------------------------------------------------------------------------
!
! In  fami             : Gauss family for integration point rule
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
! In  irets            : error code for 'SECH'
! In  ireth            : error code for 'HYDR'
! In  sechm            : 'SECH' at the beginning of current step time
! In  sechp            : 'SECH' at the end of current step time
! In  hydrm            : 'HYDR' at the beginning of current step time
! In  hydrp            : 'HYDR' at the end of current step time
! Out predef           : external state variables at beginning of current step time
! Out dpred            : increment of external state variables during current step time
!
! --------------------------------------------------------------------------------------------------
!
    integer            :: i, iret, iret2
    integer, parameter :: npred = 8
    real(kind=8)       :: vrcm, vrcp
    character(len=8)   :: lvarc(npred)
!
    data lvarc/'SECH','HYDR','IRRA','NEUT1','NEUT2','CORR','ALPHPUR','ALPHBETA'/
! 
    call r8inir(npred, 0.d0, predef, 1)
    call r8inir(npred, 0.d0, dpred, 1)
!
    if (irets .eq. 0) then
        predef(1)=sechm
        dpred(1)=sechp-sechm
    endif
!
    if (ireth .eq. 0) then
        predef(2)=hydrm
        dpred(2)=hydrp-hydrm
    endif
!
    do i = 3, npred
        call rcvarc(' ', lvarc(i), '-', fami, kpg, ksp, vrcm, iret)
        if (iret .eq. 0) then
            predef(i)=vrcm
            call rcvarc('F', lvarc(i), '+', fami, kpg, ksp, vrcp, iret2)
            dpred(i)=vrcp-vrcm
        endif
    enddo
!
    end
