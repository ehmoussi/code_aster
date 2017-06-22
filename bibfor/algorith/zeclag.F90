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

subroutine zeclag(vect, nbddl, ideeq)
!
!  BUT: ANNULER LES DDL DE LAGRANGE DANS UN VECTEUR COMPLEXE
!       (.VALE D'UN CHAMNO)
    implicit none
!
!-----------------------------------------------------------------------
!
! VECT     /M/: VECTEUR DU CHAMNO
! NBDDL    /I/: NOMBRE DE DEGRES DE LIBERTE
! IDEEQ    /I/: VECTEUR DEEQ DU NUMDDL ASSOCIE AU CHAMNO
!
!-----------------------------------------------------------------------
    complex(kind=8) :: vect(nbddl)
    integer :: ideeq(2, nbddl)
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, ityp, nbddl
!-----------------------------------------------------------------------
    do 10 i = 1, nbddl
        ityp = ideeq(2,i)
        if (ityp .le. 0) vect(i)=dcmplx(0.d0,0.d0)
10  end do
!
end subroutine
