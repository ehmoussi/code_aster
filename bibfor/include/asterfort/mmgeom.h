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
    subroutine mmgeom(ndim  ,nne   ,nnm   ,ffe   ,ffm   , &
                      geomae,geomam,tau1  ,tau2  , &
              norm  ,mprojn,mprojt,geome ,geomm )
        integer :: ndim
        integer :: nne
        integer :: nnm
        real(kind=8) :: ffe(9)
        real(kind=8) :: ffm(9)
        real(kind=8) :: geomae(9, 3)
        real(kind=8) :: geomam(9, 3)
        real(kind=8) :: tau1(3)
        real(kind=8) :: tau2(3)
        real(kind=8) :: norm(3)
        real(kind=8) :: mprojn(3, 3)
        real(kind=8) :: mprojt(3, 3)
        real(kind=8) :: geome(3)
        real(kind=8) :: geomm(3)
    end subroutine mmgeom
end interface
