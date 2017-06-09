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

subroutine elas_iso_3d(depst6, e1, xnu1, dsige6)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!       calcul d'un increment de contrainte pour la loi elastique  isotr
!=====================================================================
    implicit none
    real(kind=8) :: depst6(6)
    real(kind=8) :: e1
    real(kind=8) :: xnu1
    real(kind=8) :: dsige6(6)
!       depst6: pour les 3 1er, gamma pour les autres
    real(kind=8) :: dgamd6(6), depsv, xk0, xmu0
    integer :: i
!       increment de la deformation volumique
    depsv=0.d0
    do i = 1, 3
        depsv=depsv+depst6(i)
    end do
!       increment des gammas
    do i = 1, 3
        dgamd6(i)=(depst6(i)-depsv/3.d0)*2.d0
    end do
    xk0=e1/3.d0/(1.d0-2.d0*xnu1)
    xmu0=e1/2.d0/(1.d0+xnu1)
!       calcul des increments de contraintes effectives dans le squelett
    do i = 1, 3
        dsige6(i)=xk0*depsv+xmu0*dgamd6(i)
    end do
    do i = 4, 6
        dsige6(i)=xmu0*depst6(i)
    end do
end subroutine
