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

subroutine dmdepv(rho, fsat, tbiot, dmdeps)

! ======================================================================
!
! --- CALCUL DES DERIVEES DES APPORTS MASSIQUES PAR RAPPORT A LA -------
! --- DEFORMATION VOLUMIQUE --------------------------------------------
! ======================================================================
    implicit none
!
    integer :: i
    real(kind=8) :: rho, fsat, tbiot(6), dmdeps(6)
    real(kind=8) :: rac2
    rac2=sqrt(2.d0)
    do 10 i = 1, 3
        dmdeps(i) = rho*tbiot(i)*fsat
10  end do
    do 20 i = 4, 6
        dmdeps(i) = rho*tbiot(i)*fsat*rac2
20  end do
! ======================================================================
end subroutine
