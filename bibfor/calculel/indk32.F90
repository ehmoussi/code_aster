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

function indk32(lk32, k32z, rang, nbk32)
    implicit none
    integer :: indk32
!
! INSPI INDIK24
!     ARGUMENTS:
!     ----------
    integer :: nbk32, rang
    character(len=*) :: k32z, lk32(*)
    character(len=32) :: k32, lk32z
! ----------------------------------------------------------------------
!     ENTREES:
!     LK32 : LISTE DE K32 OU ON DOIT CHERCHER LE MOT K32
!     K32 : MOT A CHERCHER
!     NBK32: NOMBRE DE MOTS DE LK32
!     RANG : ON CHERCHE LE RANG-IEME MOT K32 DANS LA LISTE.
!
!     SORTIES:
!     INDK32 : POSITION DU MOT CHERCHE DANS LA LISTE.
!           SI LE MOT EST ABSENT: INDK32=0
!
! ----------------------------------------------------------------------
!
!     VARIABLES LOCALES:
!     ------------------
    integer :: i, j
! DEB-------------------------------------------------------------------
!
    k32 = k32z
    j = 0
    do 10 i = 1, nbk32
        lk32z = lk32(i)
        if (lk32z .eq. k32) then
            j = j + 1
            if (j .eq. rang) goto 20
        endif
10  end do
    indk32 = 0
    goto 30
20  continue
    indk32 = i
30  continue
end function
