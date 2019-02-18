! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
    subroutine calc_myf_gf(em, ftj, fcj, h, ea, omx, & 
                           ya, sya, ipenteflex, kappa_flex,&
                           myf, gf)
        real(kind=8) :: em
        real(kind=8) :: ftj
        real(kind=8) :: fcj
        real(kind=8) :: h
        real(kind=8) :: ea
        real(kind=8) :: omx
        real(kind=8) :: ya
        real(kind=8) :: sya
        integer :: ipenteflex
        real(kind=8) :: kappa_flex
        real(kind=8) :: myf
        real(kind=8) :: gf
    end subroutine calc_myf_gf
end interface
