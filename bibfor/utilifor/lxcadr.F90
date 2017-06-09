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

subroutine lxcadr(chaine)
    implicit none
    character(len=*) :: chaine
!
!     ------------------------------------------------------------------
!      CADRAGE A GAUCHE D'UN TEXTE
!     ------------------------------------------------------------------
! VAR CHAINE CHAINE A CADRER
!     ROUTINE(S) UTILISEE(S) :
!         -
!     ROUTINE(S) FORTRAN     :
!         LEN
!     ------------------------------------------------------------------
! FIN LXCADR
!     ------------------------------------------------------------------
!
!
!-----------------------------------------------------------------------
    integer :: ilong, ldec, long
!-----------------------------------------------------------------------
    long = len(chaine)
    do 10 ilong = 1, long
        if (chaine(ilong:ilong) .ne. ' ') then
            ldec = ilong-1
            goto 11
        endif
10  end do
!     --- CAS DE LA CHAINE BLANCHE ---
    ldec = 0
!     --- CAS STANDARD ---
11  continue
    if (ilong .gt. 0) then
        do 20 ilong = 1, long-ldec
            chaine(ilong:ilong) = chaine(ilong+ldec:ilong+ldec)
20      continue
        chaine(long-ldec+1:) = ' '
    endif
end subroutine
