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

subroutine tdlamb(angmas, dlambt, tdlamt, aniso, ndim)
    implicit none
! --- DEFINITION DU TENSEUR DLAMBT DANS LE REPERE GLOBAL ---------------
! --- CAS ISOTROPE OU ISOTROPE TRANSVERSE ------------------------------
! ======================================================================
#include "asterc/r8pi.h"
#include "asterfort/matini.h"
#include "asterfort/matrot.h"
#include "asterfort/utbtab.h"
    integer :: aniso, ndim
    real(kind=8) :: angmas(3), dlambt(4)
    real(kind=8) :: tdlamt(ndim, ndim), tdlamti(3, 3)
    real(kind=8) :: passag(3, 3), work(3, 3), tk2(3, 3)
! ======================================================================
! --- INITIALISATION DU TENSEUR ----------------------------------------
! ======================================================================
    call matini(3, 3, 0.d0, work)
    call matini(3, 3, 0.d0, tk2)
    call matini(ndim, ndim, 0.d0, tdlamt)
    call matini(3, 3, 0.d0, tdlamti)
    if (aniso .eq. 0) then
! ======================================================================
! --- CAS ISOTROPE -----------------------------------------------------
! --- CALCUL DU TENSEUR DLAMBT DANS LE REPERE GLOBAL -------------------
! ======================================================================
        tdlamt(1,1)=dlambt(1)
        tdlamt(2,2)=dlambt(1)
        if (ndim .eq. 3) then
            tdlamt(3,3)=dlambt(1)
        endif
    else if (aniso.eq.1) then
! ======================================================================
! --- CAS ISOTROPE TRANSVERSE 3D------------------------------------------
! --- CALCUL DU TENSEUR DE CONDUCTIVITE DANS LE REPERE GLOBAL ----------
! ======================================================================
        if (ndim .eq. 3) then
            tdlamti(1,1)=dlambt(2)
            tdlamti(2,2)=dlambt(2)
            tdlamti(3,3)=dlambt(3)
! Recupération de la matrice de passage du local au global
            call matrot(angmas, passag)
            call utbtab('ZERO', 3, 3, tdlamti, passag,&
                        work, tk2)
            tdlamt= tk2
        endif
    else if (aniso.eq.2) then
! ======================================================================
! --- CAS ORTHOTROPE 2D ------------------------------------------
! --- CALCUL DU TENSEUR DE CONDUCTIVITE DANS LE REPERE GLOBAL ----------
! ======================================================================
        tdlamti(1,1)=dlambt(2)
        tdlamti(2,2)=dlambt(4)
        call matrot(angmas, passag)
        call utbtab('ZERO', 3, 3, tdlamti, passag,&
                    work, tk2)
        tdlamt(1,1)= tk2(1,1)
        tdlamt(2,2)= tk2(2,2)
        tdlamt(1,2)= tk2(1,2)
        tdlamt(2,1)= tk2(2,1)
    endif
end subroutine
