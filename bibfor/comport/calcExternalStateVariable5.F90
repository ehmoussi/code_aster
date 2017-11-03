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
!
subroutine calcExternalStateVariable5(fami, kpg, ksp, imate)
!
use calcul_module, only : ca_vext_hygrm_, ca_vext_hygrp_
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
!
character(len=*), intent(in) :: fami
integer, intent(in) :: kpg
integer, intent(in) :: ksp
integer, intent(in) :: imate
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour - Compute intrinsic external state variables
!
! Case: hygrometry (hygrometry)
!
! --------------------------------------------------------------------------------------------------
!
! In  fami             : Gauss family for integration point rule
! In  imate            : coded material address
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
!
! --------------------------------------------------------------------------------------------------
!
    integer           :: codret(1)
    real(kind=8)      :: valres(1)
    character(len=16) :: nomres(1)
!
! --------------------------------------------------------------------------------------------------
!
    nomres(1) = 'FONC_DESORP'
    call rcvalb(fami, kpg, ksp, '-', imate,&
                ' ', 'ELAS', 0, ' ', [0.d0],&
                1, nomres, valres, codret, 0)
    if (codret(1) .eq. 0) then
        ca_vext_hygrm_ = valres(1)
    else
        call utmess('F', 'COMPOR2_94')
    endif
    call rcvalb(fami, kpg, ksp, '+', imate,&
                ' ', 'ELAS', 0, ' ', [0.d0],&
                1, nomres, valres, codret, 0)
    if (codret(1) .eq. 0) then
        ca_vext_hygrp_ = valres(1)
    else
        call utmess('F', 'COMPOR2_94')
    endif
!
end subroutine
