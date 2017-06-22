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
interface 
    subroutine b3d_nosnap(istep, fr, rtref, dpic, gf,&
                          e, beta, gama, li, vref,&
                          xkweib, veq, rteff, errmesh, coeff3,&
                          coefft)
        integer :: istep
        real(kind=8) :: fr
        real(kind=8) :: rtref
        real(kind=8) :: dpic
        real(kind=8) :: gf
        real(kind=8) :: e
        real(kind=8) :: beta
        real(kind=8) :: gama
        real(kind=8) :: li
        real(kind=8) :: vref
        real(kind=8) :: xkweib
        real(kind=8) :: veq
        real(kind=8) :: rteff
        real(kind=8) :: errmesh
        real(kind=8) :: coeff3
        real(kind=8) :: coefft
    end subroutine b3d_nosnap
end interface 
