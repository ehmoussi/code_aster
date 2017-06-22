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
    subroutine nvithm(compor, meca, thmc, ther, hydr,&
                      nvim, nvit, nvih, nvic, advime,&
                      advith, advihy, advico, vihrho, vicphi,&
                      vicpvp, vicsat, vicpr1, vicpr2)
        character(len=16) :: compor(*)
        character(len=16) :: meca
        character(len=16) :: thmc
        character(len=16) :: ther
        character(len=16) :: hydr
        integer :: nvim
        integer :: nvit
        integer :: nvih
        integer :: nvic
        integer :: advime
        integer :: advith
        integer :: advihy
        integer :: advico
        integer :: vihrho
        integer :: vicphi
        integer :: vicpvp
        integer :: vicsat
        integer :: vicpr1
        integer :: vicpr2
    end subroutine nvithm
end interface
