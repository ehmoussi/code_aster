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
#include "asterf_types.h"
!
interface
    subroutine rslphi(fami, kpg, ksp, loi, imat,&
                      troisk, troimu, depsmo, rigdmo, rieleq,&
                      pi, d, s1, ann, theta,&
                      acc, f, df, sig0, eps0,&
                      mexpo, dt, phi, phip, rigeq,&
                      rigm, p, overfl)
        character(len=*) :: fami
        integer :: kpg
        integer :: ksp
        character(len=16) :: loi
        integer :: imat
        real(kind=8) :: troisk
        real(kind=8) :: troimu
        real(kind=8) :: depsmo
        real(kind=8) :: rigdmo
        real(kind=8) :: rieleq
        real(kind=8) :: pi
        real(kind=8) :: d
        real(kind=8) :: s1
        real(kind=8) :: ann
        real(kind=8) :: theta
        real(kind=8) :: acc
        real(kind=8) :: f
        real(kind=8) :: df
        real(kind=8) :: sig0
        real(kind=8) :: eps0
        real(kind=8) :: mexpo
        real(kind=8) :: dt
        real(kind=8) :: phi
        real(kind=8) :: phip
        real(kind=8) :: rigeq
        real(kind=8) :: rigm
        real(kind=8) :: p
        aster_logical :: overfl
    end subroutine rslphi
end interface
