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
    subroutine irmhdf(ifi, ndim, nbnoeu, coordo, nbmail,&
                      connex, point, nomast, typma, titre,&
                      nbtitr, nbgrno, nomgno, nbgrma, nomgma,&
                      nommai, nomnoe, infmed)
        integer :: ifi
        integer :: ndim
        integer :: nbnoeu
        real(kind=8) :: coordo(*)
        integer :: nbmail
        integer :: connex(*)
        integer :: point(*)
        character(len=8) :: nomast
        integer :: typma(*)
        character(len=80) :: titre(*)
        integer :: nbtitr
        integer :: nbgrno
        character(len=24) :: nomgno(*)
        integer :: nbgrma
        character(len=24) :: nomgma(*)
        character(len=8) :: nommai(*)
        character(len=8) :: nomnoe(*)
        integer :: infmed
    end subroutine irmhdf
end interface
