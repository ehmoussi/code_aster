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

subroutine prmadl(ndj, deblis, liste)
! person_in_charge: olivier.boiteau at edf.fr
    implicit none
    integer :: deblis, liste(*), ndj
    integer :: nd, ndanc
    if (deblis .eq. 0) then
        deblis = ndj
        liste(deblis) = 0
    else
        nd = deblis
        ndanc = 0
 1      continue
!         DO WHILE(ND.NE.0.AND.ND.LE.NDJ)
        if (nd .ne. 0 .and. nd .le. ndj) then
            ndanc = nd
            nd = liste(nd)
            goto 1
        endif
!        ND EST NUL OU > NDJ, ON INSERE NDJ APRES NDANC
        if (ndanc .eq. 0) then
            nd = deblis
            deblis = ndj
        else
            liste(ndanc) = ndj
        endif
        liste(ndj) = nd
    endif
end subroutine
