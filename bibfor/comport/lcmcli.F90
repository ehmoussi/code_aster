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

subroutine lcmcli(nomfam, nbsys, is, pgl,&
                  sigf, sicl)
    implicit none
!     CONTRAINTE DE CLIVAGE MAXI POUR LE MONOCRISTAL
!     ----------------------------------------------------------------
#include "asterfort/lcmmsg.h"
#include "asterfort/tnsvec.h"
    integer :: i, nbsys, is, ir, j
    real(kind=8) :: sigf(6), pgl(3, 3), ms(6), ng(3), si(3, 3), sing(3), sicl, p
    real(kind=8) :: lg(3)
    real(kind=8) :: qm(3, 3)
    character(len=16) :: nomfam
    integer :: irr, decirr, nbsyst, decal, gdef
    common/polycr/irr,decirr,nbsyst,decal,gdef
!
    ir=0
!
    call lcmmsg(nomfam, nbsys, is, pgl, ms,&
                ng, lg, ir, qm)
!     SIGMA (3,3)
!     calcul du max de Ns.(SIGMA.Ns)
    if (gdef .eq. 1) then
        call tnsvec(6, 3, si, sigf, 1.d0)
    else
        call tnsvec(6, 3, si, sigf, 1.d0/sqrt(2.d0))
    endif
    sing(:) = 0.d0
    do i = 1, 3
        do j = 1, 3
            sing(i) = sing(i) + si(i,j) * ng(j)
        end do
    end do
    p = 0.d0
    do i = 1, 3
        p = p + sing(i)*ng(i)
    end do
    sicl = max(sicl, p)
!
end subroutine
