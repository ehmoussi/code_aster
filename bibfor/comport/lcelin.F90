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

subroutine lcelin(mod, nmat, materd, materf, deps,&
                  sigd, sigf)
    implicit none
! INTEGRATION ELASTIQUE LINEAIRE ISOTROPE SUR DT
! IN  MOD    :  MODELISATION
!     NMAT   :  DIMENSION MATER
!     MATERD :  COEFFICIENTS MATERIAU A T
!     MATERF :  COEFFICIENTS MATERIAU A T+DT
!     SIGD   :  CONTRAINTE  A T
! VAR DEPS   :  INCREMENT DE DEFORMATION
! OUT SIGF   :  CONTRAINTE A T+DT
! ----------------------------------------------------------------
#include "asterfort/lcopil.h"
#include "asterfort/lcopli.h"
#include "asterfort/lcprmv.h"
#include "asterfort/lcsove.h"
    integer :: nmat
    real(kind=8) :: materd(nmat, 2), materf(nmat, 2)
    real(kind=8) :: sigd(6), sigf(6)
    real(kind=8) :: dkooh(6, 6), hookf(6, 6)
    real(kind=8) :: epsed(6), epsef(6), deps(6)
    character(len=8) :: mod
! ----------------------------------------------------------------
    if (int(materf(nmat,1)) .eq. 0) then
!
! --     OPERATEUR ELASTIQUE LINEAIRE ISOTROPE
!
        call lcopli('ISOTROPE', mod, materf(1, 1), hookf)
        call lcopil('ISOTROPE', mod, materd(1, 1), dkooh)
!
    else if (int(materf(nmat,1)).eq.1) then
!
! --     OPERATEUR ELASTIQUE LINEAIRE ORTHOTROPE
!
        call lcopli('ORTHOTRO', mod, materf(1, 1), hookf)
        call lcopil('ORTHOTRO', mod, materd(1, 1), dkooh)
    endif
!
!                                                        -1
! --  DEFORMATION ELASTIQUE A T ET T+DT : EPSEF = HOOKD  SIGD + DEPS
!
    call lcprmv(dkooh, sigd, epsed)
    call lcsove(epsed, deps, epsef)
!
! --  CONTRAINTES PLANES
!     DEPS3 = - ( H31 EPSEF1 + H32 EPSEF2 + H34 EPSEF4 )/H33 - EPSED3
!
    if (mod(1:6) .eq. 'C_PLAN') then
        deps(3) = - (&
                  hookf(3, 1) * epsef(1) + hookf(3, 2) * epsef(2) + hookf(3, 4) * epsef(4) ) / ho&
                  &okf(3,&
                  3) - epsed(3&
                  )
        call lcsove(epsed, deps, epsef)
    endif
!
! --  INTEGRATION ELASTIQUE : SIGF = HOOKF EPSEF (EPSEF MODIFIE EN CP)
!
    call lcprmv(hookf, epsef, sigf)
!
end subroutine
