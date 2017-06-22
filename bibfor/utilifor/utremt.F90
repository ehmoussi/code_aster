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

subroutine utremt(mot, liste, nbval, place)
    implicit none
    character(len=*) :: mot, liste(*)
    integer :: nbval, place
!
!     ------------------------------------------------------------------
!     RECHERCHE UN MOT DONNE DANS UN LISTE (TABLEAU) DE MOTS
!     ------------------------------------------------------------------
! IN  MOT      : CH*(*) : LE MOT CHERCHE DANS LA LISTE
! IN  LISTE(*) : CH*(*) : LISTE DE MOT PROPOSE
! IN  NBVAL    : IS     : NOMBRE DE MOT DANS LA LISTE
! OUT PLACE    : IS     : PLACE DU MOT DANS LA LISTE
!                         = 0  SI LE MOT EST ABSENT DE LA LISTE
!
!-----------------------------------------------------------------------
    integer :: i
!-----------------------------------------------------------------------
    place = 0
    do 10 i = 1, nbval
        if (mot .eq. liste(i)) then
            place = i
            goto 9999
        endif
10  end do
9999  continue
end subroutine
