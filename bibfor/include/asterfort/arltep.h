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
    subroutine arltep(ndim  ,coors   ,npgs   ,kpgs  , &
                      nns   ,fctfs   , &
                      elrefc,nnc   ,coorc , &
                      fctfc ,dfdxc ,dfdyc ,dfdzc)
        integer :: ndim
        integer :: npgs
        integer :: kpgs
        integer :: nns
        integer :: nnc
        character(len=8) :: elrefc
        real(kind=8) :: coorc(ndim*nnc)
        real(kind=8) :: coors(ndim*nns)
        real(kind=8) :: fctfs(nns*npgs)
        real(kind=8) :: fctfc(ndim*ndim*nnc)
        real(kind=8) :: dfdxc(nnc)
        real(kind=8) :: dfdyc(nnc)
        real(kind=8) :: dfdzc(nnc)
    end subroutine arltep
end interface
