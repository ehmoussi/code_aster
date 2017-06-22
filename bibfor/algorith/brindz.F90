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

subroutine brindz(i, k, l)
!
!     ROUTINE ANCIENNEMENT NOMMEE INDICE0
!
!
!     CORRESPONDANCE DES INDICE VECTEUR TENSEUR CONTRAINTES
    implicit none
    integer :: i, k, l
    if (i .le. 3) then
        k=i
        l=i
    endif
    if (i .eq. 4) then
        k=1
        l=2
    endif
    if (i .eq. 5) then
        k=1
        l=3
    endif
    if (i .eq. 6) then
        k=2
        l=3
    endif
end subroutine
