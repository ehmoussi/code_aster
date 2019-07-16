! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine comcq1(fami  , kpg   , ksp   , imate   , compor,&
                  carcri, instm , instp , eps     , deps  ,&
                  sigm  , vim   , option, angmas  , sigp  ,&
                  vip   , dsde  , codret, BEHinteg)
!
use Behaviour_type
!
implicit none
!
#include "asterfort/nmcomp.h"
!
! --------------------------------------------------------------------------------------------------
!
    character(len=*) :: fami
    character(len=16) :: option, compor(*)
    integer :: codret, kpg, ksp, imate
    real(kind=8) :: angmas(3), sigm(4), eps(4), deps(4)
    real(kind=8) :: vim(*), vip(*), sigp(4), dsde(6, 6), carcri(*)
    real(kind=8) :: instm, instp
    character(len=8) :: typmod(2)
    type(Behaviour_Integ), intent(in) :: BEHinteg
!
! --------------------------------------------------------------------------------------------------
!
    dsde   = 0.d0
    sigp   = 0.d0
    codret = 0
!     INTEGRATION DE LA LOI DE COMPORTEMENT POUR LES COQUE_1D :
!     COQUE_AXIS : COMPORTEMENT C_PLAN
!     COQUE_AXIS, DIRECTION Y : CPLAN (EVT DEBORST)
!     DIRECTION Z : EPSZZ CONNU
!
    typmod(1) = 'C_PLAN  '
    call nmcomp(BEHinteg,&
                fami, kpg, ksp, 2, typmod,&
                imate, compor, carcri, instm, instp,&
                4, eps, deps, 4, sigm,&
                vim, option, angmas, &
                sigp, vip, 36, dsde, codret)
!
end subroutine
