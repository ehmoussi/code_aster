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
    function spect3(x, a, b, func, tol,&
                    coeff, xlc, vitn, defm, rhoe,&
                    nbp, im, jm)
        integer :: nbp
        real(kind=8) :: x
        real(kind=8) :: a
        real(kind=8) :: b
        real(kind=8) :: tol
        real(kind=8) :: coeff(*)
        real(kind=8) :: xlc
        real(kind=8) :: vitn(nbp, *)
        real(kind=8) :: defm(nbp, *)
        real(kind=8) :: rhoe(nbp, *)
        integer :: im
        integer :: jm
        real(kind=8) :: spect3
        interface
            function func(xx, y, xlc, vitn, rhoe,&
                          defm, nbp, im, jm)
                integer :: nbp
                real(kind=8) :: xx
                real(kind=8) :: y
                real(kind=8) :: xlc
                real(kind=8) :: vitn(nbp, *)
                real(kind=8) :: rhoe(nbp, *)
                real(kind=8) :: defm(nbp, *)
                integer :: im
                integer :: jm
                real(kind=8) :: func
            end function func
        end interface
    end function spect3
end interface
