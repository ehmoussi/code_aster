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

subroutine xtcaln(ndim, tau1, tau2, norm, mprojt)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/matini.h"
#include "asterfort/mmnorm.h"
#include "asterfort/normev.h"
#include "asterfort/provec.h"
    integer :: ndim
    real(kind=8) :: tau1(3), tau2(3)
    real(kind=8) :: norm(3)
    real(kind=8) :: mprojt(3, 3)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE XFEMGG - UTILITAIRE)
!
! CALCUL DE LA NORMALE ET DES MATRICES DE PROJECTION
!
! ----------------------------------------------------------------------
!
!
! IN  NDIM   : DIMENSION DE LA MAILLE DE CONTACT
! IN  TAU1   : PREMIERE TANGENTE EXTERIEURE
! IN  TAU2   : SECONDE TANGENTE EXTERIEURE
! OUT NORM   : NORMALE INTERIEURE
! OUT MPROJT : MATRICE DE PROJECTION TANGENTE
!
! ----------------------------------------------------------------------
!
    integer :: i, j
    real(kind=8) :: noor
!
! ----------------------------------------------------------------------
!
    call matini(3, 3, 0.d0, mprojt)
!
! --- NORMALE
!
    if (ndim .eq. 2) then
        call mmnorm(ndim, tau1, tau2, norm, noor)
    else if (ndim.eq.3) then
        call provec(tau1, tau2, norm)
        call normev(norm, noor)
    endif
    if (noor .lt. r8prem()) then
        ASSERT(.false.)
    endif
!
! --- MATRICE DE PROJECTION TANGENTE
!
    do 121 i = 1, ndim
        do 111 j = 1, ndim
            mprojt(i,j) = -1.d0*norm(i)*norm(j)
111      continue
121  end do
    do 330 i = 1, ndim
        mprojt(i,i) = 1.d0 + mprojt(i,i)
330  end do
!
end subroutine
