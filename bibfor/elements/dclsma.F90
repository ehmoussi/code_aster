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

subroutine dclsma(n, tab, iran)
    implicit none
!
!     EVALUE L ORDRE DES RACINES DANS IRAN AVEC N PETIT
!
! IN  N : NOMBRE DE RACINE DU POLYNOME
! IN  TAB : TABLEAU DES RACINES DU POLYNOME
!
! OUT IRAN : RANG DE LA RACINE
!
    integer :: i, ii, j, jj, n, iswap, iran(*)
    real(kind=8) :: tab(*)
!
    do 10, i=1,n
    iran(i) = i
    10 end do
!
    do 30, i=1,n-1
    ii=iran(i)
    do 20, j=i+1,n
    jj=iran(j)
    if (tab(ii) .gt. tab(jj)) then
        iswap=iran(i)
        iran(i)=iran(j)
        iran(j)=iswap
        ii=iran(i)
    endif
20  continue
    30 end do
!
end subroutine
