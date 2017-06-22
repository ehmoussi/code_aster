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

subroutine copvis(nb, ivec1, ivec2)
    implicit none
!
!***********************************************************************
!    P. RICHARD     DATE 19/02/91
!-----------------------------------------------------------------------
!  BUT:  COPIER UN VECTEUR D'ENTIER DANS UN AUTRE EN LE MULTIPLIANT
!   PAR UN FACTEUR
!
!-----------------------------------------------------------------------
!
! NOM----- / /:
!
! NB       /I/: NOMBRE D'ENTIER A COPIER
! IVEC1    /I/: VECTEUR A COPIER
! IVEC2    /O/: VECTEUR RESULTAT
!
!-----------------------------------------------------------------------
!
!      CHARACTER*1
!      CHARACTER*8
!      CHARACTER*9
!      CHARACTER*16
!      CHARACTER*24
!      REAL*8
    integer :: ivec1(nb), ivec2(nb)
    integer :: i, nb
!-----------------------------------------------------------------------
!
    if (nb .eq. 0) goto 9999
!
    do 10 i = 1, nb
        ivec2(i)=ivec1(i)
10  end do
!
!
9999  continue
end subroutine
