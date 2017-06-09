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

subroutine rsllin(mod, nmat, materd, materf, matcst,&
                  deps, sigd, vind, sigf, theta)
    implicit none
!       INTEGRATION ELASTIQUE LINEAIRE ISOTROPE SUR DT POUR
!         LE MODELE DE ROUSSELIER (UTILISATION DES CONTRAINTES
!         EFFECTIVES)
!       IN  MOD    :  MODELISATION
!           NMAT   :  DIMENSION MATER
!           MATERD :  COEFFICIENTS MATERIAU A T
!           MATERF :  COEFFICIENTS MATERIAU A T+DT
!           MATCST :  'OUI' SI MATERIAU CONSTANT SUR DT
!       VAR DEPS   :  INCREMENT DE DEFORMATION
!           SIGD   :  CONTRAINTE  A T
!           VIND   :  VARIABLES INTERNES A T
!       OUT SIGF   :  CONTRAINTE A T+DT
!           VINF   :  VARIABLES INTERNES A T+DT
!       ----------------------------------------------------------------
#include "asterfort/lcopil.h"
#include "asterfort/lcopli.h"
#include "asterfort/lcprmm.h"
#include "asterfort/lcprmv.h"
#include "asterfort/lcprsv.h"
#include "asterfort/lcsove.h"
    integer :: nmat
!
    real(kind=8) :: materd(nmat, 2), materf(nmat, 2)
    real(kind=8) :: sigd(6), sigf(6)
    real(kind=8) :: vind(*)
    real(kind=8) :: dkooh(6, 6), hookf(6, 6), ident(6, 6)
    real(kind=8) :: dsig(6), deps(6), thde(6)
    real(kind=8) :: rho, f, f0, un, theta
!
    parameter       ( un     = 1.d0   )
!
    character(len=8) :: mod
    character(len=3) :: matcst
!       ----------------------------------------------------------------
!
! --    CALCUL DE RHO
!
    f = vind(2)
    f0 = materf(3,2)
    rho = (un-f)/(un-f0)
!
    if (matcst(1:3) .eq. 'OUI') then
!
! --INTEGRATION ELASTIQUE : SIGF = SIGD+ RHO HOOKF DEPS
        call lcopli('ISOTROPE', mod, materf(1, 1), hookf)
        call lcprsv(theta, deps, thde)
        call lcprmv(hookf, thde, sigf)
        call lcprsv(rho, sigf, sigf)
        call lcsove(sigd, sigf, sigf)
    else
!                                                  -1
! --DEFORMATION ELASTIQUE A T ET T+DT : EPSEF = HOOKD/RHO  SIGD + DEPS
! --INTEGRATION ELASTIQUE :              SIGF = RHO*HOOKF EPSEF
        call lcopli('ISOTROPE', mod, materf(1, 1), hookf)
        call lcopil('ISOTROPE', mod, materd(1, 1), dkooh)
        call lcprmm(dkooh, hookf, ident)
        call lcprmv(ident, sigd, sigf)
        call lcprsv(theta, deps, thde)
        call lcprmv(hookf, thde, dsig)
        call lcprsv(rho, dsig, dsig)
        call lcsove(sigf, dsig, sigf)
    endif
!
end subroutine
