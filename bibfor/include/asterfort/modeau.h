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
    subroutine modeau(melflu, noma, geom, fsvr, base,&
                      freqi, nbm, nuor, vicoq, torco,&
                      tcoef, amor, masg, fact, amfr,&
                      vecpr, maj)
        integer :: nbm
        character(len=19) :: melflu
        character(len=8) :: noma
        real(kind=8) :: geom(9)
        real(kind=8) :: fsvr(7)
        character(len=8) :: base
        real(kind=8) :: freqi(*)
        integer :: nuor(nbm)
        integer :: vicoq(nbm)
        real(kind=8) :: torco(4, nbm)
        real(kind=8) :: tcoef(10, nbm)
        real(kind=8) :: amor(nbm)
        real(kind=8) :: masg(nbm)
        real(kind=8) :: fact(nbm)
        real(kind=8) :: amfr(nbm, 2)
        real(kind=8) :: vecpr(nbm, nbm)
        real(kind=8) :: maj(nbm)
    end subroutine modeau
end interface
