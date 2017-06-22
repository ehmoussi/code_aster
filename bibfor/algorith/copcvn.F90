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

subroutine copcvn(nb, vec1, vec2, indir, fact)
    implicit none
!
!***********************************************************************
!    P. RICHARD     DATE 19/02/91
!-----------------------------------------------------------------------
!  BUT:  COPIER UN VECTEUR DE REELS DANS UN AUTRE EN LE MULTIPLIANT
!   PAR UN FACTEUR AVEC UNE INDIRECTION ENTRE LES ADRESSES DES DEUX
!        VECTEURS
!
!-----------------------------------------------------------------------
!
! NB       /I/: NOMBRE REELS A COPIER
! IVEC1    /I/: VECTEUR A COPIER
! IVEC2    /O/: VECTEUR RESULTAT
! INDIR    /I/: VECTEUR DES INDIRECTIONS DE RANG
! FACT     /I/: FACTEUR
!
!-----------------------------------------------------------------------
!
    real(kind=8) :: vec1(*), vec2(nb)
    integer :: indir(nb)
    integer :: i, nb
    real(kind=8) :: fact
!-----------------------------------------------------------------------
!
    if (nb .eq. 0) goto 9999
!
    do 10 i = 1, nb
        if (indir(i) .gt. 0) then
            vec2(i)=vec1(indir(i))*fact
        else
            vec2(i)=0.d0
        endif
10  end do
!
9999  continue
end subroutine
