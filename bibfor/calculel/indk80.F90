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

function indk80(lk80, k80z, rang, nbk80)
    implicit none
    integer :: indk80
!
! INSPI INDIK24
!     ARGUMENTS:
!     ----------
    integer :: nbk80, rang
    character(len=*) :: k80z, lk80(*)
    character(len=80) :: k80, lk80z
! ----------------------------------------------------------------------
!     ENTREES:
!     LK80 : LISTE DE K80 OU ON DOIT CHERCHER LE MOT K80
!     K80 : MOT A CHERCHER
!     NBK80: NOMBRE DE MOTS DE LK80
!     RANG : ON CHERCHE LE RANG-IEME MOT K80 DANS LA LISTE.
!
!     SORTIES:
!     INDK80 : POSITION DU MOT CHERCHE DANS LA LISTE.
!           SI LE MOT EST ABSENT: INDK80=0
!
! ----------------------------------------------------------------------
!
!     VARIABLES LOCALES:
!     ------------------
    integer :: i, j
! DEB-------------------------------------------------------------------
!
    k80 = k80z
    j = 0
    do 10 i = 1, nbk80
        lk80z = lk80(i)
        if (lk80z .eq. k80) then
            j = j + 1
            if (j .eq. rang) goto 20
        endif
10  end do
    indk80 = 0
    goto 30
20  continue
    indk80 = i
30  continue
end function
