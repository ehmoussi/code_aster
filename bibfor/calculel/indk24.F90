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

function indk24(lk24, k24z, rang, nbk24)
    implicit none
    integer :: indk24
!
! INSPI INDIK8
!     ARGUMENTS:
!     ----------
    integer :: nbk24, rang
    character(len=*) :: k24z, lk24(*)
    character(len=24) :: k24, lk24z
! ----------------------------------------------------------------------
!     ENTREES:
!     LK24 : LISTE DE K24 OU ON DOIT CHERCHER LE MOT K24
!     K24 : MOT A CHERCHER
!     NBK24: NOMBRE DE MOTS DE LK24
!     RANG : ON CHERCHE LE RANG-IEME MOT K24 DANS LA LISTE.
!
!     SORTIES:
!     INDK24 : POSITION DU MOT CHERCHE DANS LA LISTE.
!           SI LE MOT EST ABSENT: INDK24=0
!
! ----------------------------------------------------------------------
!
!     VARIABLES LOCALES:
!     ------------------
    integer :: i, j
! DEB-------------------------------------------------------------------
!
    k24 = k24z
    j = 0
    do 100 i = 1, nbk24
        lk24z = lk24(i)
        if (lk24z .eq. k24) then
            j = j + 1
            if (j .eq. rang) goto 110
        endif
100  end do
    indk24 = 0
    goto 120
110  continue
    indk24 = i
120  continue
end function
