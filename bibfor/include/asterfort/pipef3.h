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
    subroutine pipef3(ndim, nno, nddl, npg, lgpg,&
                      wref, vff, dfde, mate, geom,&
                      vim, ddepl, deplm, ddepl0, ddepl1,&
                      dtau, copilo, typmod)
        integer :: lgpg
        integer :: npg
        integer :: nddl
        integer :: nno
        integer :: ndim
        real(kind=8) :: wref(npg)
        real(kind=8) :: vff(nno, npg)
        real(kind=8) :: dfde(2, nno, npg)
        integer :: mate
        real(kind=8) :: geom(nddl)
        real(kind=8) :: vim(lgpg, npg)
        real(kind=8) :: ddepl(nddl)
        real(kind=8) :: deplm(nddl)
        real(kind=8) :: ddepl0(nddl)
        real(kind=8) :: ddepl1(nddl)
        real(kind=8) :: dtau
        real(kind=8) :: copilo(5, npg)
        character(len=8) :: typmod(2)
    end subroutine pipef3
end interface
