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
    subroutine nmchat(matel, mat, nbvar, memo, visc,&
                      plast, sigmdv, depsdv, pm, dp,&
                      ndimsi, dt, rpvp, qp, vim,&
                      idelta, n1, n2, beta1, beta2,&
                      dsidep)
        real(kind=8) :: matel(*)
        real(kind=8) :: mat(*)
        integer :: nbvar
        integer :: memo
        integer :: visc
        real(kind=8) :: plast
        real(kind=8) :: sigmdv(6)
        real(kind=8) :: depsdv(6)
        real(kind=8) :: pm
        real(kind=8) :: dp
        integer :: ndimsi
        real(kind=8) :: dt
        real(kind=8) :: rpvp
        real(kind=8) :: qp
        real(kind=8) :: vim(*)
        integer :: idelta
        real(kind=8) :: n1
        real(kind=8) :: n2
        real(kind=8) :: beta1
        real(kind=8) :: beta2
        real(kind=8) :: dsidep(6, 6)
    end subroutine nmchat
end interface
