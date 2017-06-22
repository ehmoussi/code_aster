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
    subroutine calck1(norev, nomdb, sigmrv, sigmdb, tbscrv,&
                      tbscmb, prodef, londef, deklag, lrev,&
                      k1a, k1b)
        integer :: norev
        integer :: nomdb
        character(len=19) :: sigmrv
        character(len=19) :: sigmdb
        character(len=19) :: tbscrv
        character(len=19) :: tbscmb
        real(kind=8) :: prodef
        real(kind=8) :: londef
        real(kind=8) :: deklag
        real(kind=8) :: lrev
        real(kind=8) :: k1a
        real(kind=8) :: k1b
    end subroutine calck1
end interface
