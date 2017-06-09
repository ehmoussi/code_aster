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

subroutine prmade(deblis, liste, adjncy, xadjd, ndi)
! person_in_charge: olivier.boiteau at edf.fr
    implicit none
    integer :: deblis, liste(*), adjncy(*), xadjd(*), ndi
    integer :: nd, nnzero
    nd = deblis
    nnzero = 0
 1  continue
    if (nd .ne. 0) then
!      DO WHILE(ND.NE.0)
        adjncy(xadjd(ndi) + nnzero ) = nd
        nnzero = nnzero +1
        nd = liste(nd)
        goto 1
    endif
    xadjd(ndi+1) = xadjd(ndi) +nnzero
    deblis=0
end subroutine
