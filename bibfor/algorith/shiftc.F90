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

subroutine shiftc(craid, cmass, ndim, valshi)
!    P. RICHARD     DATE 20/03/91
!-----------------------------------------------------------------------
!  BUT:  PROCEDER A UN SHIFT DES MATRICES COMPLEXES POUR CALCUL AUX
!   VALEURS PROPRES
    implicit none
!
!-----------------------------------------------------------------------
!
! CRAID    /M/: MATRICE COMPLEXE DE RAIDEUR
! CMASS    /I/: MATRICE COMPLEXE DE MASSE
! NDIM     /I/: DIMENSION DES MATRICES CARREES COMPLEXES
! VALSHI   /I/: VALEUR COMPLEXE DU SHIFT
!
!-----------------------------------------------------------------------
    complex(kind=8) :: craid(*), cmass(*), czero, valshi
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, ndim
!-----------------------------------------------------------------------
    czero=dcmplx(0.d0,0.d0)
!
    if (valshi .eq. czero) goto 9999
!
    do 10 i = 1, ndim*(ndim+1)/2
        craid(i)=craid(i)+valshi*cmass(i)
10  end do
!
9999  continue
end subroutine
