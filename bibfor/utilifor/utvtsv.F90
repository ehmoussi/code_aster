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

subroutine utvtsv(raz, n, s, v, vtsv)
    implicit none
    character(len=*) :: raz
    integer :: n
    real(kind=8) :: s(*), v(*), vtsv
!     ------------------------------------------------------------------
!     PRODUIT VT . S . V - S CARREE SYMETRIQUE - V VECTEUR
!     ------------------------------------------------------------------
!IN   K4  RAZ  'ZERO' : ON FAIT VTSV = 0.   + VT*S*V
!              'CUMU' : ON FAIT VTSV = VTSV + VT*S*V
!IN   I   N    ORDRE DE S ET V
!IN   R   S    MATRICE S           (N*(N+1)/2)
!IN   R   V    VECTEUR V           (N)
!OUT  R   VTSV PRODUIT VT . S . V
!     ------------------------------------------------------------------
    character(len=4) :: raz2
    integer ::  ik, k, l
!-----------------------------------------------------------------------
#define k1(i,j) (j)*(j-1)/2+i
#define k2(i,j) (i)*(i-1)/2+j
!-----------------------------------------------------------------------
    raz2=raz
    if (raz2 .eq. 'ZERO') vtsv = 0.d0
!
    do 25 k = 1, n
        do 20 l = 1, n
            ik = k1(k,l)
            if (k .gt. l) ik = k2(k,l)
            vtsv = vtsv + s(ik) * v(k) * v(l)
20      continue
25  end do
end subroutine
