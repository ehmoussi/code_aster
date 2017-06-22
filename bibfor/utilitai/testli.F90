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

subroutine testli(ima, numa, nma, kma, ierr)
    implicit none
    integer :: numa(nma)
    integer :: ierr, ima, jma, kma, nma
!-----------------------------------------------------------------------
    ierr=0
    do 10 jma = 1, nma
        kma=numa(jma)
        if (ima .eq. kma) then
            ierr=1
            goto 20
        endif
10  end do
20  continue
end subroutine
