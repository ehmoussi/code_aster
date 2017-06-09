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

function indiis(lis, is, rang, nbis)
    implicit none
    integer :: indiis
!
!     ARGUMENTS:
!     ----------
    integer :: nbis, rang
    integer :: is, lis(*)
! ----------------------------------------------------------------------
!     ENTREES:
!     LIS : LISTE DE IS OU ON DOIT CHERCHER L'ENTIER IS
!     IS  : ENTIER A CHERCHER
!     NBIS: NOMBRE D'ENTIERS DE LA LISTE
!     RANG: ON CHERCHE LE RANG-IEME ENTIER IS DANS LA LISTE.
!
!     SORTIES:
!     INDIIS : POSITION DE L'ENTIER DANS LA LISTE
!           SI L'ENTIER EST ABSENT: INDIIS=0
!
! ----------------------------------------------------------------------
!
!     VARIABLES LOCALES:
!     ------------------
    integer :: i, j
! DEB-------------------------------------------------------------------
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    j = 0
    do 100 i = 1, nbis
        if (lis(i) .eq. is) then
            j = j + 1
            if (j .eq. rang) goto 110
        endif
100  end do
    indiis = 0
    goto 120
110  continue
    indiis = i
120  continue
end function
