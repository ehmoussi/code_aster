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

subroutine nmgvdn(ndim, nno1, nno2, iu, ia)
!
!
!
    implicit none
!
    integer :: ndim, nno1, nno2, iu(ndim*nno1), ia(nno2)
! ---------------------------------------------------------------------
!
!     POSITION DES INDICES POUR LES DEGRES DE LIBERTE
!
! IN  NDIM    : DIMENSION DES ELEMENTS
! IN  NNO1    : NOMBRE DE NOEUDS (FAMILLE U)
! IN  NNO2    : NOMBRE DE NOEUDS (FAMILLE A)
! ---------------------------------------------------------------------
!
    integer :: n, i, os
!
    character(len=16) :: nomelt
    common /ffauto/ nomelt
! ---------------------------------------------------------------------
!
!
!      ELEMENT P1 - CONTINU
!
    do 110 n = 1, nno2
        do 120 i = 1, ndim
            iu(nno1*(i-1)+n) = i + (n-1)*(ndim+1)
120      continue
        ia(n) = 1 + ndim + (n-1)*(ndim+1)
110  continue
    os = (1+ndim)*nno2
    do 140 n = 1, nno1-nno2
        do 150 i = 1, ndim
            iu(nno1*(i-1)+n+nno2) = i + (n-1)*ndim + os
150      continue
140  continue
!
!
!
end subroutine
