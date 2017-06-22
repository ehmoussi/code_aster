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
    subroutine tensca(tablca, icabl, nbnoca, nbf0, f0,&
                      delta, typrel, trelax, xflu, xret,&
                      ea, rh1000, mu0, fprg, frco,&
                      frli, sa, regl)
        character(len=19) :: tablca
        integer :: icabl
        integer :: nbnoca
        integer :: nbf0
        real(kind=8) :: f0
        real(kind=8) :: delta
        character(len=24) :: typrel
        real(kind=8) :: trelax
        real(kind=8) :: xflu
        real(kind=8) :: xret
        real(kind=8) :: ea
        real(kind=8) :: rh1000
        real(kind=8) :: mu0
        real(kind=8) :: fprg
        real(kind=8) :: frco
        real(kind=8) :: frli
        real(kind=8) :: sa
        character(len=4) :: regl
    end subroutine tensca
end interface
