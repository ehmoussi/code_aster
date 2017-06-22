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
    subroutine nmed2d(nno, npg, ipoids, ivf, idfde,&
                      geom, typmod, option, imate, compor,&
                      lgpg, crit, ideplm, iddepl, sigm,&
                      vim, dfdi, def, sigp, vip,&
                      matuu, ivectu, codret)
        integer :: lgpg
        integer :: npg
        integer :: nno
        integer :: ipoids
        integer :: ivf
        integer :: idfde
        real(kind=8) :: geom(2, nno)
        character(len=8) :: typmod(*)
        character(len=16) :: option
        integer :: imate
        character(len=16) :: compor(*)
        real(kind=8) :: crit(3)
        integer :: ideplm
        integer :: iddepl
        real(kind=8) :: sigm(4, npg)
        real(kind=8) :: vim(lgpg, npg)
        real(kind=8) :: dfdi(nno, 2)
        real(kind=8) :: def(4, nno, 2)
        real(kind=8) :: sigp(4, npg)
        real(kind=8) :: vip(lgpg, npg)
        real(kind=8) :: matuu(*)
        integer :: ivectu
        integer :: codret
    end subroutine nmed2d
end interface
