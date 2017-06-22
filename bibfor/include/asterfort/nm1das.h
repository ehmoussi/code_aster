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
    subroutine nm1das(fami, kpg, ksp, e, syc,&
                      syt, etc, ett, cr, tmoins,&
                      tplus, icodma, sigm, deps, vim,&
                      sig, vip, dsdem, dsdep)
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        real(kind=8) :: e
        real(kind=8) :: syc
        real(kind=8) :: syt
        real(kind=8) :: etc
        real(kind=8) :: ett
        real(kind=8) :: cr
        real(kind=8) :: tmoins
        real(kind=8) :: tplus
        integer :: icodma
        real(kind=8) :: sigm
        real(kind=8) :: deps
        real(kind=8) :: vim(4)
        real(kind=8) :: sig
        real(kind=8) :: vip(4)
        real(kind=8) :: dsdem
        real(kind=8) :: dsdep
    end subroutine nm1das
end interface
