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
    subroutine b3d_stock_tail(xmat, nmatt, ifour, mfr1, nmat0,&
                              nmat1, t33, n33, local, vt33,&
                              var0, varf, nvari, erreur, gf,&
                              fr, rt, epic, beta1, gama1,&
                              nvar1)
#include "asterf_types.h"
        integer :: nvari
        integer :: nmatt
        real(kind=8) :: xmat(nmatt)
        integer :: ifour
        integer :: mfr1
        integer :: nmat0
        integer :: nmat1
        real(kind=8) :: t33(3, 3)
        real(kind=8) :: n33(3, 3)
        aster_logical :: local
        real(kind=8) :: vt33(3, 3)
        real(kind=8) :: var0(nvari)
        real(kind=8) :: varf(nvari)
        integer :: erreur
        real(kind=8) :: gf
        real(kind=8) :: fr
        real(kind=8) :: rt
        real(kind=8) :: epic
        real(kind=8) :: beta1
        real(kind=8) :: gama1
        integer :: nvar1
    end subroutine b3d_stock_tail
end interface 
