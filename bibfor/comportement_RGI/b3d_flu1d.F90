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

subroutine b3d_flu1d(vsigma, e0, dt, eps10, veps10,&
                     e1, eta1, eta2, veps20, deps0,&
                     deps1, deps2, veps1f, veps2f)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!=====================================================================
!     calcul des increments de deformations de fluage induites
!      par une variation  de la contrainte
!=====================================================================
    implicit none
    real(kind=8) :: vsigma
    real(kind=8) :: e0
    real(kind=8) :: dt
    real(kind=8) :: eps10
    real(kind=8) :: veps10
    real(kind=8) :: e1
    real(kind=8) :: eta1
    real(kind=8) :: eta2
    real(kind=8) :: veps20
    real(kind=8) :: deps0
    real(kind=8) :: deps1
    real(kind=8) :: deps2
    real(kind=8) :: veps1f
    real(kind=8) :: veps2f, t4, t5, t6, t11, t14, t15, t26, t27
    deps0 = vsigma / e0 * dt
    t4 = -vsigma + veps10 * e1
    t5 = e1 ** 2
    t6 = 0.1D1 / t5
    t11 = exp(-e1 / eta1 * dt)
    t14 = 0.1D1 / e1
    t15 = vsigma * t14
    deps1 = -t4 * t6 * eta1 * t11 + t15 * dt + (eps10 * t5 - eta1 * vsigma + eta1 * veps10 * e1&
            ) * t6 - eps10
    veps1f = t4 * t14 * t11 + t15
    t26 = vsigma / eta2
    t27 = dt ** 2
    deps2 = t26 * t27 / 0.2D1 + veps20 * dt
    veps2f = t26 * dt + veps20
end subroutine
