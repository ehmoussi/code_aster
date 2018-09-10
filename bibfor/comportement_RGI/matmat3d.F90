! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine matmat3d(a, b, nl, nc1, nc2,&
                  c)
! person_in_charge: etienne.grimal@edf.fr
!=====================================================================
!=====================================================================
!  C(NL,NC2)=A(NL,NC1)*B(NC1,NC2)
!  LE PREMIER INDICE EST DE LIGNE, LE DEUXIEME DE COLONNE
!=====================================================================
    implicit none
    integer :: nc1
    integer :: nl
    real(kind=8) :: a(nl, *)
    real(kind=8) :: b(nc1, *), xx
    integer :: nc2, i, j, k
    real(kind=8) :: c(nl, *)
    do i = 1, nl
        do j = 1, nc2
            xx= 0.d0
            do k = 1, nc1
                xx = a(i,k)*b(k,j) + xx
            end do
            c(i,j)=xx
        end do
    end do
end subroutine
