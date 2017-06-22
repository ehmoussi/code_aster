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

subroutine b3d_erupt(local, i, l3, e23, r,&
                     beta, epic, fr, gf, e,&
                     dpic)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!=====================================================================
!     calcul de la deformation a rupture pour une loi d'endo
!     une energie et une taille d element donnee
!=====================================================================
    implicit none
#include "asterf_types.h"
!
    aster_logical :: local
    integer :: i
    real(kind=8) :: l3(3)
    real(kind=8) :: e23(3)
    real(kind=8) :: r
    real(kind=8) :: beta
    real(kind=8) :: epic
    real(kind=8) :: fr
    real(kind=8) :: gf
    real(kind=8) :: e
    real(kind=8) :: dpic
    real(kind=8) :: li, t1, t2, t4, t10, t13, sef2
    if (local .or. (i.eq.1)) then
        li=l3(i)
        t1 = r ** 2
        t2 = t1 * li
        t4 = gf * e
        t10 = fr * dpic
        t13 = fr * beta
        sef2 = (-0.2D1 * t2 - 0.6D1 * t4 * fr + t2 * fr + 0.2D1 * t2 * beta + 0.6D1 * t4 * t10 - &
               &0.4D1 * t2 * t13) / (-dpic * beta + 0.2D1 * t10 * beta + dpic + t10 + beta - fr -&
               & 0.2D1 * t13 - 0.1D1) / r / li / 0.2D1
        e23(i)=sef2/e
    else
        e23(i)=e23(1)
    end if 
end subroutine
