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
    subroutine dndiss(ipara, nmnbn, nmplas, nmdpla, nmddpl,&
                      nmprox, deps, newnbn, newpla, newdpl,&
                      newddp, newzfg, despit, ddisit, dc1,&
                      dc2, dtg, normm, normn)
        integer :: ipara(4)
        real(kind=8) :: nmnbn(*)
        real(kind=8) :: nmplas(2, *)
        real(kind=8) :: nmdpla(2, *)
        real(kind=8) :: nmddpl(2, *)
        integer :: nmprox(*)
        real(kind=8) :: deps(*)
        real(kind=8) :: newnbn(*)
        real(kind=8) :: newpla(2, *)
        real(kind=8) :: newdpl(2, *)
        real(kind=8) :: newddp(2, *)
        real(kind=8) :: newzfg(2)
        real(kind=8) :: despit(*)
        real(kind=8) :: ddisit
        real(kind=8) :: dc1(6, 6)
        real(kind=8) :: dc2(6, 6)
        real(kind=8) :: dtg(6, 6)
        real(kind=8) :: normm
        real(kind=8) :: normn
    end subroutine dndiss
end interface
