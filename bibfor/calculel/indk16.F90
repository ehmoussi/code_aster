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

function indk16(lk16, k16z, rang, nbk16)
    implicit none
    integer :: indk16
!
! INSPI INDIK8
!     ARGUMENTS:
!     ----------
    integer :: nbk16, rang
    character(len=*) :: k16z, lk16(*)
    character(len=16) :: k16, lk16z
! ----------------------------------------------------------------------
!     ENTREES:
!     LK16 : LISTE DE K16 OU ON DOIT CHERCHER LE MOT K16
!     K16 : MOT A CHERCHER
!     NBK16: NOMBRE DE MOTS DE LK16
!     RANG : ON CHERCHE LE RANG-IEME MOT K16 DANS LA LISTE.
!
!     SORTIES:
!     INDK16 : POSITION DU MOT CHERCHE DANS LA LISTE.
!           SI LE MOT EST ABSENT: INDK16=0
!
! ----------------------------------------------------------------------
!
!     VARIABLES LOCALES:
!     ------------------
    integer :: i, j
! DEB-------------------------------------------------------------------
!
    k16 = k16z
    j = 0
    do 100 i = 1, nbk16
        lk16z = lk16(i)
        if (lk16z .eq. k16) then
            j = j + 1
            if (j .eq. rang) goto 110
        endif
100  end do
    indk16 = 0
    goto 120
110  continue
    indk16 = i
120  continue
end function
