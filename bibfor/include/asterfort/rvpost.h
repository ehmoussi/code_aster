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

!
!
interface
    subroutine rvpost(mcf, iocc, dim, i1, i2,&
                      ncheff, xnomcp, nresu, nch19, nlsmac,&
                      nlsnac, nomtab, xnovar)
        character(len=*) :: mcf
        integer :: iocc
        character(len=2) :: dim
        integer :: i1
        integer :: i2
        character(len=16) :: ncheff
        character(len=24) :: xnomcp
        character(len=8) :: nresu
        character(len=19) :: nch19
        character(len=24) :: nlsmac
        character(len=24) :: nlsnac
        character(len=19) :: nomtab
        character(len=24) :: xnovar
    end subroutine rvpost
end interface
