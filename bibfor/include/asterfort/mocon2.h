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
    subroutine mocon2(dir, sigb, siga, hh, nlit,&
                      om, rr, nufsup, nufinf, nufsd1,&
                      nufid1, nufsd2, nufid2, prec)
        integer :: nlit
        character(len=1) :: dir
        real(kind=8) :: sigb
        real(kind=8) :: siga(nlit)
        real(kind=8) :: hh
        real(kind=8) :: om(nlit)
        real(kind=8) :: rr(nlit)
        character(len=8) :: nufsup
        character(len=8) :: nufinf
        character(len=8) :: nufsd1
        character(len=8) :: nufid1
        character(len=8) :: nufsd2
        character(len=8) :: nufid2
        real(kind=8) :: prec
    end subroutine mocon2
end interface
