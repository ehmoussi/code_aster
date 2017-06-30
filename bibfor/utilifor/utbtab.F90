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

subroutine utbtab(raz, na, mb, a, b,&
                  xab, btab)
    implicit none
#include "asterfort/r8inir.h"
    character(len=*) :: raz
    integer :: na, mb
    real(kind=8) :: a(na, na), b(na, mb), xab(na, mb)
    real(kind=8) :: btab(mb, mb)
!     ------------------------------------------------------------------
!     PRODUIT BT . A . B - A CARREE - B RECTANGULAIRE
!     ------------------------------------------------------------------
!IN   K4  RAZ  'ZERO' : ON FAIT BTAB = 0    + BT*A.B
!              'CUMU' : ON FAIT BTAB = BTAB + BT*A.B
!IN   I   NA   ORDRE DE A
!IN   I   MB   NB DE COLONNES DE B
!IN   R   A    MATRICE A           (NA,NA)
!IN   R   B    MATRICE B           (NA,MB)
!IN   R   XAB  ZONE DE TRAVAIL XAB (NA,MB)
!OUT  R   BTAB PRODUIT BT . A . B  (MB,MB)
!     ------------------------------------------------------------------
    character(len=4) :: raz2
! --DEB
!-----------------------------------------------------------------------
    integer :: i, j, k
!-----------------------------------------------------------------------
    raz2=raz
!
    call r8inir(na*mb, 0.0d0, xab, 1)
    do j = 1, mb
        do k = 1, na
            do i = 1, na
                xab(i,j) = xab(i,j) + a(i,k) * b(k,j)
            end do
        end do
    end do
!
    if (raz2 .eq. 'ZERO') call r8inir(mb*mb, 0.0d0, btab, 1)
!
    do j = 1, mb
        do i = 1, mb
            do k = 1, na
                btab(i,j) = btab(i,j) + b(k,i) * xab(k,j)
            end do
        end do
    end do
end subroutine
