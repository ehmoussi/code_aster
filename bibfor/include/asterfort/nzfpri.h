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
    subroutine nzfpri(deuxmu, trans, rprim, seuil, phasp,&
                      nz, fmel, eta, unsurn, dt,&
                      dp, fplas, fp, fd, fprim,&
                      fdevi)
        integer :: nz
        real(kind=8) :: deuxmu
        real(kind=8) :: trans
        real(kind=8) :: rprim
        real(kind=8) :: seuil
        real(kind=8) :: phasp(5)
        real(kind=8) :: fmel
        real(kind=8) :: eta(nz)
        real(kind=8) :: unsurn(nz)
        real(kind=8) :: dt
        real(kind=8) :: dp
        real(kind=8) :: fplas
        real(kind=8) :: fp(nz)
        real(kind=8) :: fd(5)
        real(kind=8) :: fprim
        real(kind=8) :: fdevi
    end subroutine nzfpri
end interface
