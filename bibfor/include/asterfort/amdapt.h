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
    subroutine amdapt(neq, nbnd, nbsn, pe, nv,&
                      invp, parent, supnd, adress, lgind,&
                      fctnzs, fctops, llist, nnv)
        integer :: neq
        integer :: nbnd
        integer :: nbsn
        integer :: pe(neq+1)
        integer :: nv(neq)
        integer :: invp(neq)
        integer :: parent(*)
        integer :: supnd(neq)
        integer :: adress(*)
        integer :: lgind
        integer :: fctnzs
        real(kind=8) :: fctops
        integer :: llist(neq)
        integer :: nnv(neq)
    end subroutine amdapt
end interface
