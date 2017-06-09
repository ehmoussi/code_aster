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

subroutine tebiot(angmas, biot, tbiot, aniso, ndim)
    implicit none
! --- DEFINITION DU TENSEUR DE BIOT DANS LE REPERE GLOBAL --------------
! --- CAS ISOTROPE OU ISOTROPE TRANSVERSE ------------------------------
! ======================================================================
#include "asterc/r8dgrd.h"
#include "asterc/r8pi.h"
#include "asterfort/matini.h"
#include "asterfort/matrot.h"
#include "asterfort/utbtab.h"
#include "asterfort/vecini.h"
    integer :: aniso, ndim
    real(kind=8) :: angmas(3), biot(4)
    real(kind=8) :: tbiot(6)
    real(kind=8) :: bt(3, 3), work(3, 3)
    real(kind=8) :: pass(3, 3), ipass(3, 3), bgl(3, 3), int(3, 3)
    real(kind=8) :: zero
! ======================================================================
! --- INITIALISATION DU TENSEUR DE BIOT --------------------------------
! ======================================================================
    zero = 0.0d0
!
    call matini(3, 3, zero, bt)
    call matini(3, 3, zero, int)
    call matini(3, 3, zero, pass)
    call matini(3, 3, zero, ipass)
    call matini(3, 3, zero, bgl)
    call vecini(6, zero, tbiot)
!
    if (aniso .eq. 0) then
! ======================================================================
! --- CAS ISOTROPE -----------------------------------------------------
! --- RECUPERATION DU TENSEUR DE BIOT DANS LE REPERE LOCAL -------------
! ======================================================================
        bt(1,1)= biot(1)
        bt(2,2)= biot(1)
        bt(3,3)= biot(1)
    else if (aniso.eq.1) then
! ======================================================================
! --- CAS ISOTROPE TRANSVERSE ------------------------------------------
! --- RECUPERATION DU TENSEUR DE BIOT DANS LE REPERE LOCAL -------------
! ======================================================================
        bt(1,1)= biot(2)
        bt(2,2)= biot(2)
        bt(3,3)= biot(3)
    else if (aniso.eq.2) then
! ======================================================================
! --- CAS ORTHOTROPE 2D ------------------------------------------
! --- RECUPERATION DU TENSEUR DE BIOT DANS LE REPERE LOCAL -------------
! ======================================================================
        bt(1,1)= biot(2)
        bt(2,2)= biot(4)
        bt(3,3)= biot(3)
    endif
! Verification angle en 2D
    if (ndim .eq. 2) then
        angmas(2) = 0.d0
        angmas(3) = 0.d0
    endif
!
!
! matrice de passage du local au global
    call matrot(angmas, pass)
! ======================================================================
! --- CALCUL DU TENSEUR DE BIOT BGL DANS LE REPERE GLOBAL -------------
! ======================================================================
    call utbtab('ZERO', 3, 3, bt, pass,&
                work, bgl)
!
    tbiot(1)= bgl(1,1)
    tbiot(2)= bgl(2,2)
    tbiot(3)= bgl(3,3)
    tbiot(4)= bgl(1,2)
    tbiot(5)= bgl(1,3)
    tbiot(6)= bgl(2,3)
!
!
end subroutine
