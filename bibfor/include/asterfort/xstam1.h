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
    subroutine xstam1(noma, nbma, nmafis, mafis,&
                      stano, mafon, maen1, maen2, maen3,&
                      nmafon, nmaen1, nmaen2, nmaen3,&
                      typdis, cnslt)
        integer :: nmafis
        integer :: nbma
        character(len=8) :: noma
        integer :: mafis(nmafis)
        integer :: stano(*)
        integer :: mafon(nmafis)
        integer :: maen1(nbma)
        integer :: maen2(nbma)
        integer :: maen3(nbma)
        integer :: nmafon
        integer :: nmaen1
        integer :: nmaen2
        integer :: nmaen3
        character(len=16) :: typdis
        character(len=19) :: cnslt
    end subroutine xstam1
end interface
