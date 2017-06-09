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
    subroutine modcoq(base, nuor, nbm, mater1, mater2,&
                      noma, nomgrp, iaxe, kec, geom,&
                      vicoq, torco, tcoef, ifreba)
        integer :: nbm
        character(len=8) :: base
        integer :: nuor(nbm)
        character(len=8) :: mater1
        character(len=8) :: mater2
        character(len=8) :: noma
        character(len=24) :: nomgrp(*)
        integer :: iaxe
        integer :: kec
        real(kind=8) :: geom(9)
        integer :: vicoq(nbm)
        real(kind=8) :: torco(4, nbm)
        real(kind=8) :: tcoef(10, nbm)
        integer :: ifreba
    end subroutine modcoq
end interface
